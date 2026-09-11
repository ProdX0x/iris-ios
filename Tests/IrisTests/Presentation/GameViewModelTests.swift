// GameViewModelTests.swift
// Layer: Tests
// Purpose: Deterministic phase transitions of the game screen with simulated gaze, mock audio and a manual clock

import Foundation
import Testing
@testable import Iris

@Suite("GameViewModel")
@MainActor
struct GameViewModelTests {
    private let gaze = SimulatedGazeTrackingService()
    private let audio = MockAudioService()
    private let clock = ManualGameClock()
    private let navigator = MockNavigator()

    private let store = InMemoryCalibrationStore()

    private func makeSUT(levels: [Level]? = nil, autoplay: Bool = false) -> GameViewModel {
        let progression = GameProgression(levels: levels ?? LevelCatalog.all)
        let settings = GameSettingsStore(defaults: UserDefaults(suiteName: "iris.tests.\(UUID().uuidString)") ?? .standard)
        return GameViewModel(progression: progression, gaze: gaze, audio: audio, clock: clock,
                             settings: settings, calibrationStore: store, orientation: FixedOrientationProvider(),
                             isPad: false, autoplay: autoplay, navigator: navigator)
    }

    private func expectClose(_ point: Vector2?, _ expected: Vector2, _ comment: Comment? = nil) {
        #expect(point != nil, comment)
        if let point {
            #expect(abs(point.x - expected.x) < 1e-6 && abs(point.y - expected.y) < 1e-6, comment)
        }
    }

    /// A level whose single target already rests on its arrival, far from the initial centred cursor
    /// (the reference engine starts the cursor at the screen centre): validates after 45 frames.
    private func restingLevels(count: Int) -> [Level] {
        (0..<count).map { index in
            SessionFixture.level(placements: [SessionFixture.Placement(start: Vector2(x: 320, y: 760), arrival: Vector2(x: 320, y: 760))],
                                 number: index + 1)
        }
    }

    private func prepared(_ sut: GameViewModel) {
        sut.prepare(width: 390, height: 844, displayScale: 3)
    }

    @Test("starts initializing, becomes ready once tracking is available, services are started")
    func readyAfterTracking() {
        let sut = makeSUT()

        #expect(sut.phase == .initializing)
        prepared(sut)

        #expect(sut.phase == .ready)
        #expect(sut.gazeState == .tracking(faceVisible: true))
        #expect(audio.activateCount == 1)
        #expect(sut.levelNumber == 1)
        #expect(sut.levelCount == 14)
    }

    @Test("tap starts the game and ticks advance the scene")
    func tapStartsPlaying() {
        let sut = makeSUT()
        prepared(sut)
        let before = sut.snapshot

        sut.primaryAction()
        #expect(sut.phase == .playing)
        #expect(clock.isRunning)
        clock.tick(frames: 10)

        #expect(sut.snapshot != before)
        #expect(sut.snapshot.targets.count == 1)
    }

    @Test("pause stops the clock, silences the crescendo, tap resumes")
    func pauseResume() {
        let sut = makeSUT()
        prepared(sut)
        sut.primaryAction()
        clock.tick(frames: 5)
        audio.clearCues()

        sut.pause()

        #expect(sut.phase == .paused)
        #expect(!clock.isRunning)
        #expect(audio.cues.contains(.stopProgress(voice: 0)))

        sut.primaryAction()
        #expect(sut.phase == .playing)
        #expect(clock.isRunning)
    }

    @Test("the cursor starts on the latest gaze, follows samples while playing, freezes while paused")
    func gazeCursorLifecycle() {
        let sut = makeSUT()
        prepared(sut)
        sut.showsGazeIndicator = true
        gaze.inject(point: Vector2(x: 10, y: 10), timestamp: 0)

        sut.primaryAction()
        clock.tick(1.0 / 60.0)
        expectClose(sut.snapshot.gaze, Vector2(x: 10, y: 10), "seeded exactly on the latest sample")

        gaze.inject(point: Vector2(x: 110, y: 10), timestamp: 1)
        clock.tick(1.0 / 60.0)
        expectClose(sut.snapshot.gaze, Vector2(x: 20, y: 10), "smoothed 10 percent toward the sample")

        sut.pause()
        gaze.inject(point: Vector2(x: 300, y: 300), timestamp: 2)
        expectClose(sut.snapshot.gaze, Vector2(x: 20, y: 10), "frozen while paused")
    }

    @Test("completing a level shows the level end, the chime plays, tap loads the next level")
    func levelCompletion() {
        let sut = makeSUT(levels: restingLevels(count: 2))
        prepared(sut)
        sut.primaryAction()

        clock.tick(frames: 45)

        #expect(sut.phase == .levelComplete(number: 1, isLast: false))
        #expect(!clock.isRunning)
        #expect(audio.cues.contains(.validation))
        #expect(sut.completedLevels == 1)

        sut.primaryAction()
        #expect(sut.phase == .playing)
        #expect(sut.levelNumber == 2)
    }

    @Test("completing the last level ends the journey through the navigator")
    func journeyEnd() {
        let sut = makeSUT(levels: restingLevels(count: 1))
        prepared(sut)
        sut.primaryAction()
        clock.tick(frames: 45)
        #expect(sut.phase == .levelComplete(number: 1, isLast: true))

        sut.primaryAction()

        #expect(navigator.finishedSummaries.count == 1)
        #expect(navigator.finishedSummaries.first?.levelCount == 1)
        #expect(audio.deactivateCount >= 1)
    }

    @Test("restart level goes back to ready with a fresh session")
    func restartLevel() {
        let sut = makeSUT(levels: restingLevels(count: 1))
        prepared(sut)
        sut.primaryAction()
        clock.tick(frames: 20)

        sut.restartLevel()

        #expect(sut.phase == .ready)
        #expect(sut.snapshot.targets[0].progress == 0)
    }

    @Test("an AR interruption while playing pauses the loop; tracking back asks for a tap to resume")
    func interruption() {
        let sut = makeSUT()
        prepared(sut)
        sut.primaryAction()
        clock.tick(frames: 3)

        gaze.simulate(state: .interrupted)
        #expect(sut.phase == .interrupted)
        #expect(!clock.isRunning)

        gaze.simulate(state: .tracking(faceVisible: true))
        #expect(sut.phase == .resuming)

        sut.primaryAction()
        #expect(sut.phase == .playing)
    }

    @Test("camera denied surfaces a failure with a settings shortcut")
    func cameraDenied() {
        let sut = makeSUT()
        prepared(sut)

        gaze.simulate(state: .unavailable(.cameraDenied))

        #expect(sut.phase == .failed(.cameraDenied))
        if case let .failed(failure) = sut.phase {
            #expect(failure.canOpenSettings)
        }
    }

    @Test("unsupported device and AR errors are failures too")
    func otherFailures() {
        let sut = makeSUT()
        prepared(sut)

        gaze.simulate(state: .unavailable(.faceTrackingUnsupported))
        #expect(sut.phase == .failed(.faceTrackingUnsupported))

        gaze.simulate(state: .failed(message: "boom"))
        #expect(sut.phase == .failed(.trackingError(message: "boom")))
    }

    @Test("going to the background suspends everything; coming back requires a tap when a level was running")
    func backgroundAndForeground() {
        let sut = makeSUT()
        prepared(sut)
        sut.primaryAction()
        clock.tick(frames: 2)

        sut.suspend()

        #expect(sut.phase == .suspended)
        #expect(!clock.isRunning)
        #expect(gaze.state == .idle)
        #expect(audio.deactivateCount == 1)

        sut.wake()

        #expect(sut.phase == .resuming)
        #expect(audio.activateCount == 2)
    }

    @Test("background before the first tap comes back to ready")
    func backgroundBeforeStart() {
        let sut = makeSUT()
        prepared(sut)

        sut.suspend()
        sut.wake()

        #expect(sut.phase == .ready)
    }

    @Test("background during the level end keeps the level end")
    func backgroundOnLevelEnd() {
        let sut = makeSUT(levels: restingLevels(count: 2))
        prepared(sut)
        sut.primaryAction()
        clock.tick(frames: 45)

        sut.suspend()
        sut.wake()

        #expect(sut.phase == .levelComplete(number: 1, isLast: false))
    }

    @Test("exit tears down services and notifies the navigator")
    func exit() {
        let sut = makeSUT()
        prepared(sut)
        sut.primaryAction()

        sut.exit()

        #expect(navigator.exitCount == 1)
        #expect(!clock.isRunning)
        #expect(gaze.state == .idle)
        #expect(audio.deactivateCount == 1)
    }

    @Test("autoplay skips the ready tap")
    func autoplay() {
        let sut = makeSUT(autoplay: true)

        prepared(sut)

        #expect(sut.phase == .playing)
    }

    @Test("the gaze indicator setting exposes cursor and diagnostic points")
    func settings() {
        let sut = makeSUT()
        prepared(sut)

        sut.showsGazeIndicator = true
        gaze.inject(point: Vector2(x: 50, y: 60), timestamp: 0)
        gaze.inject(point: Vector2(x: 50, y: 60), timestamp: 0.02)
        gaze.inject(point: Vector2(x: 50, y: 60), timestamp: 0.04)

        #expect(sut.snapshot.gaze != nil)
        expectClose(sut.snapshot.diagnostics?.raw, Vector2(x: 50, y: 60))
        expectClose(sut.snapshot.diagnostics?.calibrated, Vector2(x: 50, y: 60), "uncalibrated: calibrated equals raw")
        #expect(sut.calibrationStatus == .uncalibrated)
    }

    @Test("a stored compatible profile is applied to the gaze")
    func calibrationApplied() {
        let nominal = NominalDisplayGeometry.estimate(viewport: PlayfieldBounds(width: 390, height: 844), displayScale: 3, isPad: false)
        let profile = CalibrationProfile(transform: AffineTransform2D(a0: 0.1, a1: 1, a2: 0, b0: 0, b1: 0, b2: 1),
                                         axisMapping: .standard, interfaceOrientation: "portrait",
                                         viewport: PlayfieldBounds(width: 390, height: 844), nominalGeometry: nominal,
                                         createdAt: Date(), validationMeanError: 0.07, validationMaxError: 0.12, isValid: true)
        store.save(profile)
        let sut = makeSUT()
        prepared(sut)
        sut.showsGazeIndicator = true

        gaze.inject(point: Vector2(x: 100, y: 400), timestamp: 0)
        sut.primaryAction()
        clock.tick(1.0 / 60.0)

        #expect(sut.calibrationStatus == .calibrated(meanError: 0.07, isValid: true))
        expectClose(sut.snapshot.gaze, Vector2(x: 100 + 39, y: 400), "offset of 10 percent of the width applied")
    }

    @Test("losing the face for more than 0.3 s pauses the game, which resumes by itself when the face is back")
    func faceLost() {
        let sut = makeSUT()
        prepared(sut)
        sut.primaryAction()
        clock.tick(frames: 3)

        gaze.simulate(state: .tracking(faceVisible: false))
        clock.tick(frames: 10)
        #expect(sut.phase == .playing, "short absences are tolerated")
        clock.tick(frames: 12)
        #expect(sut.phase == .faceLost)
        #expect(!clock.isRunning)

        gaze.simulate(state: .tracking(faceVisible: true))
        #expect(sut.phase == .playing)
        #expect(clock.isRunning)
    }

    @Test("recalibration suspends the game, notifies the navigator and resumes with the new profile")
    func recalibration() {
        let sut = makeSUT()
        prepared(sut)
        sut.primaryAction()
        clock.tick(frames: 2)
        sut.pause()

        sut.requestRecalibration()

        #expect(sut.phase == .suspended)
        #expect(navigator.recalibrationCount == 1)
        #expect(gaze.state == .idle)

        sut.resumeAfterRecalibration()

        #expect(sut.phase == .resuming)
        #expect(gaze.state == .tracking(faceVisible: true))
    }
}

@Suite("GameViewModel shared gaze ownership")
@MainActor
struct GameViewModelOwnershipTests {
    @Test("a late onDisappear after handing the tracker to the setup does not stop the setup's session")
    func lateDisappearIsHarmless() {
        let gaze = SimulatedGazeTrackingService()
        let navigator = MockNavigator()
        let store = InMemoryCalibrationStore()
        let settings = GameSettingsStore(defaults: UserDefaults(suiteName: "iris.tests.own.\(UUID().uuidString)") ?? .standard)
        let game = GameViewModel(progression: GameProgression(), gaze: gaze, audio: MockAudioService(), clock: ManualGameClock(),
                                 settings: settings, calibrationStore: store, orientation: FixedOrientationProvider(),
                                 isPad: false, navigator: navigator)
        game.prepare(width: 390, height: 844, displayScale: 3)
        game.primaryAction()
        game.pause()
        game.requestRecalibration()

        let setup = GazeSetupViewModel(intent: .recalibrate, gaze: gaze, calibrationStore: store,
                                       capabilities: StaticDeviceCapabilities(supportsFaceTracking: true),
                                       cameraAuthorization: StubCameraAuthorizationService(status: .authorized),
                                       orientation: FixedOrientationProvider(), settings: settings, isPad: false, navigator: navigator)
        setup.prepare(width: 390, height: 844, displayScale: 3)
        #expect(gaze.state == .tracking(faceVisible: true))

        game.viewDisappeared()

        #expect(gaze.state == .tracking(faceVisible: true), "the game no longer owns the tracker")
        #expect(gaze.onSample != nil)

        setup.finish()
        game.resumeAfterRecalibration()
        setup.viewDisappeared()

        #expect(gaze.state == .tracking(faceVisible: true), "the setup no longer owns the tracker either")
        #expect(game.phase == .resuming)
    }
}
