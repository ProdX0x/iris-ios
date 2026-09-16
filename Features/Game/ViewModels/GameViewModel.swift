// GameViewModel.swift
// Layer: Presentation
// Purpose: Owns one play session: campaign level, engine loop, gaze mapping, hints, audio, haptics, results and phases

import Foundation
import Observation
import os

@MainActor
@Observable
final class GameViewModel {
    // Coarse state read by HUD and overlays.
    private(set) var phase: GamePhase = .initializing
    private(set) var level: LevelDefinition
    private(set) var chapter: ChapterDefinition
    private(set) var hint: String?
    private(set) var gazeState: GazeTrackingState = .idle
    private(set) var audioStatus: AudioStatus = .inactive
    private(set) var calibrationStatus: GazeCalibrationStatus = .uncalibrated

    // Per-frame state read by the canvas only.
    private(set) var snapshot: GameSceneSnapshot

    /// The player's gaze assistance mode. The game asks the policy what to show; it never decides for itself.
    var gazeAssistance: GazeAssistanceMode {
        get { settings.gazeAssistance }
        set {
            settings.gazeAssistance = newValue
            refreshSnapshot()
        }
    }

    #if DEBUG
    /// Developer overlay switch, read by the HUD. Not a product setting.
    var showsDeveloperGazeDiagnostics: Bool { settings.showsDeveloperGazeDiagnostics }
    #endif

    var isSimulatedGaze: Bool { gaze is SimulatedGazeTrackingService }

    /// Face absence tolerated while playing before the game pauses itself (the reference engine's FACE_LOST_TIMEOUT).
    static let faceLostTimeout: TimeInterval = 0.3
    /// Seconds before the route help or the empty-space advice appears.
    static let helpDelay: TimeInterval = 45

    @ObservationIgnored private var bounds: PlayfieldBounds = .referencePhone
    @ObservationIgnored private var resolved: ResolvedLevel
    @ObservationIgnored private var session: GameSession
    @ObservationIgnored private var hints: HintTracker
    @ObservationIgnored private var hintsBegun = false
    @ObservationIgnored private var showsRoute = false
    @ObservationIgnored private var nominal: NominalDisplayGeometry?
    @ObservationIgnored private var mapper: GazeMapper?
    #if DEBUG
    /// Developer overlay only: the raw and calibrated points. A Release build never builds one.
    @ObservationIgnored private var diagnostics: GazeDiagnostics?
    #endif
    @ObservationIgnored private var cuePolicy = AudioCuePolicy()
    @ObservationIgnored private var hapticPolicy = HapticCuePolicy()
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
    @ObservationIgnored private let haptics: any HapticFeedbackService
    @ObservationIgnored private let clock: any GameClock
    @ObservationIgnored private let settings: GameSettingsStore
    @ObservationIgnored private let calibrationStore: any CalibrationStore
    @ObservationIgnored private let orientation: any InterfaceOrientationProvider
    @ObservationIgnored private let isPad: Bool
    @ObservationIgnored private let autoplay: Bool
    @ObservationIgnored private weak var navigator: (any GameNavigating)?
    /// Asked once when a level loads: the levels that teach the marker are already completed.
    @ObservationIgnored private var hasCompletedGazeLearning = true
    @ObservationIgnored private let logger = Logger(subsystem: "net.steve-s.iris", category: "game")
    #if DEBUG
    /// PROTOTYPE (chapter I level 6): observation-only trace; nil for every other level. Never steers the game.
    @ObservationIgnored private(set) var oculoTrace: OculomotorTrace?
    /// One DEBUG line for the HUD diagnostics (shown only with the gaze indicator).
    private(set) var oculoStatus: String?
    /// Chapter X final: the JSON Lines capture, only when the app was launched with `--iris-capture`.
    @ObservationIgnored private var ancreCapture: AncreCapture?
    #endif

    init(level: LevelDefinition,
         gaze: any GazeTrackingService,
         audio: any AudioService,
         haptics: any HapticFeedbackService,
         clock: any GameClock,
         settings: GameSettingsStore,
         calibrationStore: any CalibrationStore,
         orientation: any InterfaceOrientationProvider,
         isPad: Bool,
         autoplay: Bool = false,
         navigator: any GameNavigating) {
        let chapter = Self.chapter(of: level)
        self.level = level
        self.chapter = chapter
        let resolved = LevelResolver.resolve(level, in: .referencePhone)
        let session = resolved.makeSession()
        self.resolved = resolved
        self.session = session
        self.hints = HintTracker.forLevel(level, helpDelay: Self.helpDelay)
        self.snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false,
                                          marker: .hidden, diagnostics: nil, theme: chapter.theme)
        self.gaze = gaze
        self.audio = audio
        self.haptics = haptics
        self.clock = clock
        self.settings = settings
        self.calibrationStore = calibrationStore
        self.orientation = orientation
        self.isPad = isPad
        self.autoplay = autoplay
        self.navigator = navigator
    }

    // MARK: Lifecycle

    /// Called by the view once its size is known. Builds the gaze mapper, loads the level, starts tracking and audio.
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
        loadLevel(level)
        wireServices()
        phase = .initializing
        gaze.start(viewport: GazeViewport(bounds: bounds, nominal: geometry))
        activateAudio()
    }

    /// Rebuilds the mapper from the stored profile (after a recalibration or at start).
    func reloadCalibration() {
        guard let nominal else { return }
        let orientationName = orientation.interfaceOrientation.irisName
        if let profile = calibrationStore.load(), profile.isUsable(viewport: bounds, interfaceOrientation: orientationName) {
            mapper = GazeMapper(viewport: bounds, profile: profile)
            calibrationStatus = .calibrated(meanError: profile.validationMeanError, isValid: profile.isValid)
            logger.info("calibration loaded: valid \(profile.isValid)")
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

    /// Tap on the scene or the main button: starts, resumes or moves on depending on the phase.
    func primaryAction() {
        switch phase {
        case .ready, .paused, .resuming:
            play()
        case let .levelComplete(result):
            if result.isCampaignEnd {
                finishCampaign()
            } else if result.hasNextLevel {
                playNext()
            } else {
                openChapters()
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
        loadLevel(level)
        phase = .ready
    }

    func replay() {
        guard case .levelComplete = phase else { return }
        loadLevel(level)
        phase = .ready
    }

    func playNext() {
        guard case .levelComplete = phase, let next = Self.next(after: level) else { return }
        // The next level may belong to a chapter this player has not opened: the navigator decides, the game does not.
        guard navigator?.gameMayContinue(to: next) ?? true else {
            teardown()
            navigator?.gameDidReachLockedLevel(next)
            return
        }
        let chapterChanged = next.chapter != level.chapter
        loadLevel(next)
        if chapterChanged && settings.ambienceEnabled {
            audio.apply(.ambient(frequency: chapter.ambientFrequency))
        }
        phase = .ready
    }

    func openChapters() {
        teardown()
        navigator?.gameDidRequestChapters()
    }

    func retryAfterFailure() {
        guard case .failed = phase, let nominal else { return }
        phase = .initializing
        if !ownsGaze { wireServices() }
        gaze.start(viewport: GazeViewport(bounds: bounds, nominal: nominal))
        activateAudio()
    }

    func exit() {
        teardown()
        navigator?.gameDidRequestExit()
    }

    /// Leaves the game screen for the gaze setup (recalibration) and keeps the level.
    func requestRecalibration() {
        guard phase == .paused else { return }
        phaseBeforeSuspension = .paused
        haltLoop()
        releaseGaze()
        deactivateAudio()
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
        activateAudio()
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
        deactivateAudio()
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
        activateAudio()
    }

    // MARK: Loop

    private func play() {
        phase = .playing
        levelInProgress = true
        faceLostDuration = 0
        seedCursorIfNeeded()
        if !hintsBegun {
            hintsBegun = true
            hints.begin()
            hint = hints.current
        }
        clock.start { [weak self] deltaTime in
            self?.tick(deltaTime)
        }
    }

    /// Samples already flow before the first tap, so the cursor starts exactly at the current gaze.
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
                #if DEBUG
                ancreCapture?.mark("faceLostWarning", session: session, phase: phase)
                #endif
                return
            }
        } else {
            faceLostDuration = 0
        }
        let events = session.advance(by: deltaTime)
        #if DEBUG
        oculoTrace?.observeTick(session: session, events: events)
        ancreCapture?.observeTick(session: session, phase: phase, events: events)
        #endif
        if settings.soundEffectsEnabled {
            for cue in cuePolicy.cues(for: events, at: session.elapsed) {
                audio.apply(cue)
            }
        }
        if settings.hapticsEnabled {
            for cue in hapticPolicy.cues(for: events, at: session.elapsed) {
                haptics.play(cue)
            }
        }
        if hints.observe(events: events, elapsed: session.elapsed) {
            hint = hints.current
        }
        if !showsRoute && level.requiresPushing && session.elapsed >= Self.helpDelay {
            showsRoute = true
        }
        refreshSnapshot()
        if events.contains(.levelCompleted) {
            completeLevel()
        }
    }

    private func completeLevel() {
        haltLoop()
        #if DEBUG
        ancreCapture?.stop(reason: "level complete")
        #endif
        levelInProgress = false
        hint = nil
        let outcome = LevelOutcome(time: session.elapsed, intrusions: session.metrics.intrusions, losses: session.metrics.losses)
        let previous = navigator?.gameDidComplete(level: level, outcome: outcome) ?? LevelRecord()
        let earned = outcome.eclats(par: level.par)
        let next = Self.next(after: level)
        phase = .levelComplete(LevelResult(levelID: level.id,
                                           outcome: outcome,
                                           earned: earned,
                                           newlyEarned: earned.subtracting(previous.eclats),
                                           isNewBestTime: previous.bestTime.map { outcome.time < $0 } ?? false,
                                           hasNextLevel: next != nil,
                                           isChapterEnd: !level.isExperimental && Campaign.isLastInChapter(level),
                                           isCampaignEnd: !level.isExperimental && next == nil))
        logger.info("level \(self.level.id, privacy: .public) completed in \(outcome.time, format: .fixed(precision: 1)) s, intrusions \(outcome.intrusions), losses \(outcome.losses)")
    }

    private func finishCampaign() {
        teardown()
        navigator?.gameDidFinishCampaign()
    }

    /// Campaign chapters, plus the experimental chapter in DEBUG builds (prototype levels are never in the campaign).
    private static func chapter(of level: LevelDefinition) -> ChapterDefinition {
        if let chapter = Campaign.chapter(of: level) { return chapter }
        #if DEBUG
        if let chapter = BraisesPrototype.chapter(of: level) { return chapter }
        #endif
        return Campaign.chapters[0]
    }

    private static func next(after level: LevelDefinition) -> LevelDefinition? {
        #if DEBUG
        if level.isExperimental { return BraisesPrototype.next(after: level) }
        #endif
        return Campaign.next(after: level)
    }

    private func loadLevel(_ definition: LevelDefinition) {
        level = definition
        chapter = Self.chapter(of: definition)
        resolved = LevelResolver.resolve(definition, in: bounds)
        session = resolved.makeSession()
        hints = HintTracker.forLevel(definition, helpDelay: Self.helpDelay)
        hintsBegun = false
        hint = nil
        showsRoute = false
        cuePolicy.reset()
        hapticPolicy.reset()
        faceLostDuration = 0
        levelInProgress = false
        #if DEBUG
        if let balises = definition.balises {
            oculoTrace = OculomotorTrace(names: balises.balises.map(\.name))
        } else if let oculo = definition.oculo {
            oculoTrace = OculomotorTrace(names: oculo.stages.indices.map { "stage\($0 + 1)" })
        } else {
            oculoTrace = nil
        }
        oculoStatus = nil
        ancreCapture?.stop(reason: "another level")
        ancreCapture = AncreCapture(level: definition)
        #endif
        hasCompletedGazeLearning = navigator?.gameHasCompletedGazeLearning() ?? true
        refreshSnapshot()
        navigator?.gameDidStart(level: definition)
    }

    /// True while the first three levels of chapter I are still teaching the marker. The pause reads this to say
    /// so, and to stop offering a choice it could not honour on this level.
    var isGazeLearningActive: Bool {
        GazeAssistancePolicy.isLearning(levelID: level.id, hasCompletedLearning: hasCompletedGazeLearning)
    }

    /// What the interface should do with the gaze marker right now. One question, one answer, one place.
    var gazeMarker: GazeMarkerPresentation {
        GazeAssistancePolicy.presentation(mode: settings.gazeAssistance,
                                          levelID: level.id,
                                          hasCompletedLearning: hasCompletedGazeLearning,
                                          activePlayTime: session.elapsed)
    }

    private func refreshSnapshot() {
        #if DEBUG
        let developerDiagnostics = diagnostics
        #else
        let developerDiagnostics: GazeDiagnostics? = nil
        #endif
        snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: showsRoute,
                                     marker: gazeMarker, diagnostics: developerDiagnostics, theme: chapter.theme)
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
        #if DEBUG
        ancreCapture?.stop(reason: "left the game")
        #endif
        releaseGaze()
        deactivateAudio()
    }

    private func releaseGaze() {
        guard ownsGaze else { return }
        ownsGaze = false
        gaze.onSample = nil
        gaze.onStateChange = nil
        gaze.stop()
    }

    /// The engine runs when effects or ambience are wanted; the drone plays only if the ambience is wanted.
    private func activateAudio() {
        guard settings.wantsAudio else { return }
        audio.activate()
        if settings.ambienceEnabled {
            audio.apply(.ambient(frequency: chapter.ambientFrequency))
        }
    }

    private func deactivateAudio() {
        audio.apply(.ambient(frequency: nil))
        audio.deactivate()
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
        let mapped = mapper.screenPoint(sample)
        #if DEBUG
        if let oculoTrace {
            oculoTrace.observeSample(mapped: mapped, sample: sample, bounds: bounds)
            if settings.showsDeveloperGazeDiagnostics { oculoStatus = oculoTrace.statusLine }
        }
        if let ancreCapture {
            var faceTracked: Bool?
            if case let .tracking(visible) = gazeState { faceTracked = visible }
            ancreCapture.observeSample(session: session, phase: phase, faceTracked: faceTracked, observation: sample.observation,
                                       screenHead: sample.observation.map { Self.screenHead($0, mapping: mapper.axisMapping) }, mapped: mapped,
                                       gazeState: oculoTrace?.state.rawValue ?? (mapped == nil ? "INVALID" : "UNKNOWN"), bounds: bounds,
                                       timestamp: sample.timestamp)
        }
        #endif
        #if DEBUG
        if settings.showsDeveloperGazeDiagnostics {
            let edge = oculoTrace?.lastEdge.flatMap { GazeDiagnostics.Edge(rawValue: $0.rawValue.lowercased()) }
            diagnostics = GazeDiagnostics(raw: mapper.rawScreenPoint(sample), calibrated: mapped, edge: edge)
        } else if diagnostics != nil {
            diagnostics = nil
        }
        #endif
        // Between ticks the scene is only rebuilt when something gaze-driven is actually on screen.
        if phase != .playing, gazeMarker.isMarkerVisible {
            sampleCounter += 1
            if sampleCounter.isMultiple(of: 3) {
                refreshSnapshot()
            }
        }
        guard phase == .playing else { return }
        if let point = mapped {
            session.ingestGaze(point)
        } else if level.oculo?.readsHeadWithoutGaze != true {
            return
        }
        // OCULOMOTOR EXPANSION: the stages that ask for the head read it from the same observation, oriented like the
        // screen by the calibration's axis mapping (the one that already places the gaze), so no axis sign is assumed.
        // Chapter X's final reads it even when the sample has no gaze projection: its circles follow the head alone.
        session.ingestHeadPose(sample.observation.map { Self.screenHead($0, mapping: mapper.axisMapping) })
    }

    /// View-frame head angles in screen terms: yaw toward the screen's right as the player sees it, pitch toward its top.
    /// The mapping only swaps or flips the two in-plane axes, so the size of a head turn is unchanged.
    nonisolated static func screenHead(_ observation: GazeObservation, mapping: AxisMapping) -> HeadPose {
        let screen = mapping.screenCoordinates(of: SIMD2(observation.headYaw, observation.headPitch))
        return HeadPose(yaw: screen.x, pitch: screen.y)
    }

    private func handleGazeState(_ state: GazeTrackingState) {
        gazeState = state
        switch state {
        case let .tracking(faceVisible):
            #if DEBUG
            oculoTrace?.observeFaceVisible(faceVisible)
            if settings.showsDeveloperGazeDiagnostics, let oculoTrace { oculoStatus = oculoTrace.statusLine }
            ancreCapture?.mark(faceVisible ? "faceVisible" : "faceHidden", session: session, phase: phase, faceTracked: faceVisible)
            #endif
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
        case let .levelComplete(result):
            .levelComplete(result)
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
