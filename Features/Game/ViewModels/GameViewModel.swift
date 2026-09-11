// GameViewModel.swift
// Layer: Presentation
// Purpose: Owns the game loop: session, progression, gaze mapping, audio, phase transitions

import Foundation
import Observation
import os

@MainActor
@Observable
final class GameViewModel {
    // Coarse state read by HUD and overlays.
    private(set) var phase: GamePhase = .initializing
    private(set) var levelNumber: Int
    private(set) var levelCount: Int
    private(set) var targetCount: Int
    private(set) var isSequential: Bool
    private(set) var gazeState: GazeTrackingState = .idle
    private(set) var audioStatus: AudioStatus = .inactive
    private(set) var completedLevels = 0
    private(set) var calibrationStatus: GazeCalibrationStatus = .uncalibrated

    // Per-frame state read by the canvas only.
    private(set) var snapshot: GameSceneSnapshot

    var showsGazeIndicator: Bool {
        get { settings.showsGazeIndicator }
        set {
            settings.showsGazeIndicator = newValue
            refreshSnapshot()
        }
    }

    var isSimulatedGaze: Bool { gaze is SimulatedGazeTrackingService }

    /// Face absence tolerated while playing before the game pauses itself (the reference engine's FACE_LOST_TIMEOUT).
    static let faceLostTimeout: TimeInterval = 0.3

    @ObservationIgnored private var progression: GameProgression
    @ObservationIgnored private var session: GameSession
    @ObservationIgnored private var bounds: PlayfieldBounds
    @ObservationIgnored private var nominal: NominalDisplayGeometry?
    @ObservationIgnored private var mapper: GazeMapper?
    @ObservationIgnored private var diagnostics = GazeDiagnostics()
    @ObservationIgnored private var cuePolicy = AudioCuePolicy()
    @ObservationIgnored private var playDuration: TimeInterval = 0
    @ObservationIgnored private var levelInProgress = false
    @ObservationIgnored private var phaseBeforeSuspension: GamePhase?
    @ObservationIgnored private var isPrepared = false
    @ObservationIgnored private var faceLostDuration: TimeInterval = 0
    @ObservationIgnored private var sampleCounter = 0
    /// True while this ViewModel owns the shared gaze tracker's callbacks. Cleared by teardown so that a late
    /// `onDisappear` (SwiftUI transitions overlap) never stops a session another screen has just started.
    @ObservationIgnored private var ownsGaze = false

    @ObservationIgnored private let gaze: any GazeTrackingService
    @ObservationIgnored private let audio: any AudioService
    @ObservationIgnored private let clock: any GameClock
    @ObservationIgnored private let settings: GameSettingsStore
    @ObservationIgnored private let calibrationStore: any CalibrationStore
    @ObservationIgnored private let orientation: any InterfaceOrientationProvider
    @ObservationIgnored private let isPad: Bool
    @ObservationIgnored private let autoplay: Bool
    @ObservationIgnored private weak var navigator: (any GameNavigating)?
    @ObservationIgnored private let logger = Logger(subsystem: "com.prodx0x.iris", category: "game")

    init(progression: GameProgression,
         gaze: any GazeTrackingService,
         audio: any AudioService,
         clock: any GameClock,
         settings: GameSettingsStore,
         calibrationStore: any CalibrationStore,
         orientation: any InterfaceOrientationProvider,
         isPad: Bool,
         autoplay: Bool = false,
         navigator: any GameNavigating) {
        self.progression = progression
        self.gaze = gaze
        self.audio = audio
        self.clock = clock
        self.settings = settings
        self.calibrationStore = calibrationStore
        self.orientation = orientation
        self.isPad = isPad
        self.autoplay = autoplay
        self.navigator = navigator
        self.bounds = .referencePhone
        self.session = GameSession(level: progression.currentLevel, bounds: .referencePhone)
        self.snapshot = GameSceneSnapshot(session: session, showsGaze: settings.showsGazeIndicator)
        self.levelNumber = progression.currentNumber
        self.levelCount = progression.levelCount
        self.targetCount = progression.currentLevel.targetCount
        self.isSequential = progression.currentLevel.isSequential
    }

    // MARK: Lifecycle

    /// Called by the view once its size is known. Builds the gaze mapper, starts gaze tracking and audio.
    func prepare(width: Double, height: Double, displayScale: Double) {
        let newBounds = PlayfieldBounds(width: width, height: height)
        let geometry = NominalDisplayGeometry.estimate(viewport: newBounds, displayScale: displayScale, isPad: isPad)
        if isPrepared {
            gaze.updateViewport(GazeViewport(bounds: bounds, nominal: geometry))
            return
        }
        isPrepared = true
        bounds = newBounds
        nominal = geometry
        reloadCalibration()
        loadLevel(progression.currentLevel)
        wireServices()
        phase = .initializing
        gaze.start(viewport: GazeViewport(bounds: bounds, nominal: geometry))
        audio.activate()
    }



    /// Rebuilds the mapper from the stored profile (after a recalibration or at start).
    func reloadCalibration() {
        guard let nominal else { return }
        let orientationName = orientation.interfaceOrientation.irisName
        if let profile = calibrationStore.load(), profile.isUsable(viewport: bounds, interfaceOrientation: orientationName) {
            mapper = GazeMapper(viewport: bounds, profile: profile)
            calibrationStatus = .calibrated(meanError: profile.validationMeanError, isValid: profile.isValid)
            logger.info("calibration loaded: valid \(profile.isValid) mean error \(profile.validationMeanError ?? -1, format: .fixed(precision: 3)) axes \(GazeReadinessEvaluator.describe(profile.axisMapping), privacy: .public)")
        } else {
            mapper = GazeMapper(viewport: bounds, nominal: nominal)
            calibrationStatus = .uncalibrated
            logger.info("no usable calibration, nominal mapping in use")
        }
    }

    func viewDisappeared() {
        guard ownsGaze else { return }
        teardown()
    }

    // MARK: Player intents

    /// Tap on the scene: starts, resumes or continues depending on the phase.
    func primaryAction() {
        switch phase {
        case .ready, .paused, .resuming:
            play()
        case let .levelComplete(_, isLast):
            if isLast {
                finishJourney()
            } else {
                loadLevel(progression.currentLevel)
                play()
            }
        case .initializing, .playing, .interrupted, .faceLost, .suspended, .failed:
            break
        }
    }

    func pause() {
        guard phase == .playing else { return }
        haltLoop()
        phase = .paused
    }

    func restartLevel() {
        guard phase == .paused || phase == .playing || phase == .resuming else { return }
        haltLoop()
        loadLevel(progression.currentLevel)
        levelInProgress = false
        phase = .ready
    }

    func retryAfterFailure() {
        guard case .failed = phase, let nominal else { return }
        phase = .initializing
        if !ownsGaze { wireServices() }
        gaze.start(viewport: GazeViewport(bounds: bounds, nominal: nominal))
        audio.activate()
    }

    func exit() {
        teardown()
        navigator?.gameDidRequestExit()
    }

    /// Leaves the game screen for the gaze setup (recalibration) and keeps the progression.
    func requestRecalibration() {
        guard phase == .paused else { return }
        phaseBeforeSuspension = .paused
        haltLoop()
        releaseGaze()
        audio.deactivate()
        phase = .suspended
        navigator?.gameDidRequestRecalibration()
    }

    /// Back from the gaze setup: reload the profile and restart tracking.
    func resumeAfterRecalibration() {
        guard phase == .suspended, let nominal else { return }
        reloadCalibration()
        wireServices()
        phase = .initializing
        gaze.start(viewport: GazeViewport(bounds: bounds, nominal: nominal))
        audio.activate()
    }

    /// Simulator and previews only: the pointer plays the role of the gaze.
    func simulatePointer(x: Double, y: Double, timestamp: TimeInterval) {
        (gaze as? SimulatedGazeTrackingService)?.inject(point: Vector2(x: x, y: y), timestamp: timestamp)
    }

    // MARK: Scene phase

    func suspend() {
        guard isPrepared, phase != .suspended, !isFailed else { return }
        phaseBeforeSuspension = phase
        haltLoop()
        gaze.pause()
        audio.deactivate()
        phase = .suspended
    }

    func wake() {
        guard phase == .suspended, let nominal else { return }
        phase = .initializing
        if ownsGaze {
            gaze.resume()
        } else {
            wireServices()
            gaze.start(viewport: GazeViewport(bounds: bounds, nominal: nominal))
        }
        audio.activate()
    }

    // MARK: Loop

    private func play() {
        phase = .playing
        levelInProgress = true
        faceLostDuration = 0
        seedCursorIfNeeded()
        clock.start { [weak self] deltaTime in
            self?.tick(deltaTime)
        }
    }

    /// The reference engine started its cursor at the screen centre because no gaze data existed yet.
    /// Here samples already flow before the first tap, so the cursor starts exactly at the current gaze
    /// instead of smoothing its way there and repelling spheres near the centre for no reason.
    private func seedCursorIfNeeded() {
        guard !session.gaze.isActive, let sample = gaze.latestSample, let point = mapper?.screenPoint(sample) else { return }
        session.placeGaze(at: point)
        refreshSnapshot()
    }

    private func tick(_ deltaTime: TimeInterval) {
        guard phase == .playing else { return }
        if case .tracking(false) = gazeState {
            faceLostDuration += deltaTime
            if faceLostDuration >= Self.faceLostTimeout {
                haltLoop()
                phase = .faceLost
                return
            }
        } else {
            faceLostDuration = 0
        }
        let events = session.advance(by: deltaTime)
        playDuration += min(max(deltaTime, 0), session.maxDeltaTime)
        for cue in cuePolicy.cues(for: events, at: session.elapsed) {
            audio.apply(cue)
        }
        refreshSnapshot()
        if events.contains(.levelCompleted) {
            completeLevel()
        }
    }

    private func completeLevel() {
        haltLoop()
        levelInProgress = false
        completedLevels += 1
        let completedNumber = progression.currentNumber
        switch progression.completeCurrentLevel() {
        case .nextLevel:
            phase = .levelComplete(number: completedNumber, isLast: false)
        case .journeyFinished:
            phase = .levelComplete(number: completedNumber, isLast: true)
        }
    }

    private func finishJourney() {
        let summary = JourneySummary(levelCount: progression.levelCount, playDuration: playDuration)
        teardown()
        navigator?.gameDidFinishJourney(summary: summary)
    }

    private func loadLevel(_ level: Level) {
        session = GameSession(level: level, bounds: bounds)
        cuePolicy.reset()
        levelNumber = level.number
        targetCount = level.targetCount
        isSequential = level.isSequential
        refreshSnapshot()
    }

    private func refreshSnapshot() {
        snapshot = GameSceneSnapshot(session: session, showsGaze: settings.showsGazeIndicator, diagnostics: diagnostics)
    }

    /// Stops ticking and silences every crescendo voice; the scene stays as it is.
    private func haltLoop() {
        clock.stop()
        for voice in 0..<3 {
            audio.apply(.stopProgress(voice: voice))
        }
    }

    private func fail(_ failure: GameFailure) {
        haltLoop()
        phase = .failed(failure)
    }

    private func teardown() {
        haltLoop()
        releaseGaze()
        audio.deactivate()
    }

    private func releaseGaze() {
        guard ownsGaze else { return }
        ownsGaze = false
        gaze.onSample = nil
        gaze.onStateChange = nil
        gaze.stop()
    }

    // MARK: Services

    private func wireServices() {
        ownsGaze = true
        gaze.onStateChange = { [weak self] state in
            self?.handleGazeState(state)
        }
        gaze.onSample = { [weak self] sample in
            self?.handleGazeSample(sample)
        }
        audio.onStatusChange = { [weak self] status in
            self?.audioStatus = status
        }
        audioStatus = audio.status
        gazeState = gaze.state
    }

    private func handleGazeSample(_ sample: RawGazeSample) {
        guard let mapper else { return }
        if settings.showsGazeIndicator {
            diagnostics = GazeDiagnostics(raw: mapper.rawScreenPoint(sample), calibrated: mapper.screenPoint(sample))
            sampleCounter += 1
            if phase != .playing, sampleCounter.isMultiple(of: 3) {
                refreshSnapshot()
            }
        }
        guard phase == .playing, let point = mapper.screenPoint(sample) else { return }
        session.ingestGaze(point)
    }

    private func handleGazeState(_ state: GazeTrackingState) {
        gazeState = state
        switch state {
        case let .tracking(faceVisible):
            if faceVisible {
                trackingBecameAvailable()
            }
        case .interrupted:
            if phase == .playing {
                haltLoop()
            }
            if phase == .playing || phase == .paused || phase == .ready || phase == .resuming || phase == .initializing || phase == .faceLost {
                phase = .interrupted
            }
        case let .unavailable(reason):
            fail(Self.failure(for: reason))
        case let .failed(message):
            fail(.trackingError(message: message))
        case .idle, .starting:
            break
        }
    }

    private func trackingBecameAvailable() {
        switch phase {
        case .initializing:
            if let previous = phaseBeforeSuspension {
                phaseBeforeSuspension = nil
                phase = Self.phaseAfterReturn(from: previous, levelInProgress: levelInProgress)
            } else if autoplay {
                play()
            } else {
                phase = .ready
            }
        case .interrupted:
            phase = levelInProgress ? .resuming : .ready
        case .faceLost:
            play()
        case .ready, .playing, .paused, .levelComplete, .resuming, .suspended, .failed:
            break
        }
    }

    private static func phaseAfterReturn(from previous: GamePhase, levelInProgress: Bool) -> GamePhase {
        switch previous {
        case .playing, .paused, .resuming, .interrupted, .faceLost:
            levelInProgress ? .resuming : .ready
        case let .levelComplete(number, isLast):
            .levelComplete(number: number, isLast: isLast)
        case .initializing, .ready, .suspended, .failed:
            .ready
        }
    }

    private static func failure(for reason: GazeUnavailabilityReason) -> GameFailure {
        switch reason {
        case .faceTrackingUnsupported: .faceTrackingUnsupported
        case .cameraDenied: .cameraDenied
        case .cameraRestricted: .cameraRestricted
        }
    }

    private var isFailed: Bool {
        if case .failed = phase { return true }
        return false
    }
}
