// GameViewModelTests.swift
// Layer: Tests
// Purpose: Campaign game screen: intro, play, hints, result and éclats, next level, help, lifecycle, gaze and audio

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
    private let settings = GameSettingsStore(defaults: UserDefaults(suiteName: "iris.tests.game.\(UUID().uuidString)") ?? .standard)
    private let farGaze = Vector2(x: 40, y: 800)

    /// A level of chapter `chapter`, index `index`, whose lueur already rests next to its iris.
    private func restingLevel(chapter: Int = 1, index: Int = 1, hints: [LevelHint] = []) -> LevelDefinition {
        LevelDefinition(chapter: chapter, index: index, title: "repos", principle: "p", zone: 0.46, noise: 0,
                        lueurs: [LueurDefinition(start: NormalizedPoint(x: 0.62, y: 0.3), iris: NormalizedPoint(x: 0.62, y: 0.3))],
                        hints: hints, par: LevelPar(time: 10, intrusions: 2))
    }

    private func makeSUT(level: LevelDefinition, autoplay: Bool = false) -> GameViewModel {
        GameViewModel(level: level, gaze: gaze, audio: audio, clock: clock, settings: settings, calibrationStore: store,
                      orientation: FixedOrientationProvider(), isPad: false, autoplay: autoplay, navigator: navigator)
    }

    private func prepared(_ sut: GameViewModel) {
        sut.prepare(width: 390, height: 844, displayScale: 3)
    }

    private func startPlaying(_ sut: GameViewModel) {
        prepared(sut)
        gaze.inject(point: farGaze, timestamp: 0)
        sut.primaryAction()
    }

    private func expectClose(_ point: Vector2?, _ expected: Vector2, _ comment: Comment? = nil) {
        #expect(point != nil, comment)
        if let point {
            #expect(abs(point.x - expected.x) < 1e-6 && abs(point.y - expected.y) < 1e-6, comment)
        }
    }

    @Test("prepare loads the level, shows the intro once tracking works, starts audio with the chapter drone")
    func intro() {
        let sut = makeSUT(level: restingLevel())

        #expect(sut.phase == .initializing)
        prepared(sut)

        #expect(sut.phase == .ready)
        #expect(sut.level.id == "1-1")
        #expect(sut.chapter.number == 1)
        #expect(navigator.startedLevels == ["1-1"])
        #expect(audio.activateCount == 1)
        #expect(audio.cues.contains(.ambient(frequency: 110)))
        #expect(sut.snapshot.lueurs.count == 1)
    }

    @Test("sound disabled: the audio engine is never activated and no cue is sent")
    func soundDisabled() {
        settings.soundEnabled = false
        let sut = makeSUT(level: restingLevel())

        startPlaying(sut)
        clock.tick(frames: 60)

        #expect(audio.activateCount == 0)
        #expect(audio.cues.allSatisfy { if case .stopProgress = $0 { return true } else { return false } })
    }

    @Test("the start hint shows when play begins and follows the player's first actions")
    func hints() {
        guard let tutorial = Campaign.level(id: "1-1") else {
            Issue.record("missing 1-1")
            return
        }
        let sut = makeSUT(level: tutorial)
        startPlaying(sut)

        #expect(sut.hint == "Regardez la lueur.")
        let lueur = sut.snapshot.lueurs[0].position
        gaze.inject(point: Vector2(x: lueur.x, y: lueur.y + 30), timestamp: 1)
        gaze.inject(point: Vector2(x: lueur.x, y: lueur.y + 30), timestamp: 1.01)
        gaze.inject(point: Vector2(x: lueur.x, y: lueur.y + 30), timestamp: 1.02)
        for _ in 0..<60 {
            gaze.inject(point: Vector2(x: lueur.x, y: lueur.y + 30), timestamp: 1.1)
            clock.tick(1.0 / 60.0)
        }

        #expect(sut.hint == "Elle fuit votre regard. Regardez ailleurs, sur l'écran.")
    }

    @Test("completing a level shows the result with éclats, reports the outcome and loads the next level on demand")
    func completion() {
        navigator.recordToReturn = LevelRecord(completions: 1, bestTime: 30, fewestIntrusions: 5, eclats: [.atteint])
        let sut = makeSUT(level: restingLevel())
        startPlaying(sut)

        clock.tick(frames: 50)

        guard case let .levelComplete(result) = sut.phase else {
            Issue.record("expected result, got \(sut.phase)")
            return
        }
        #expect(result.earned == [.atteint, .fluide, .serein])
        #expect(result.newlyEarned == [.fluide, .serein])
        #expect(result.isNewBestTime)
        #expect(result.hasNextLevel && !result.isCampaignEnd && !result.isChapterEnd)
        #expect(result.primaryTitle == "Suivant")
        #expect(navigator.completions.count == 1)
        #expect(!clock.isRunning)
        #expect(audio.cues.contains(.levelComplete))

        sut.primaryAction()
        #expect(sut.phase == .ready)
        #expect(sut.level.id == "1-2")
        #expect(navigator.startedLevels == ["1-1", "1-2"])
    }

    @Test("replay reloads the same level; restart from pause too")
    func replayAndRestart() {
        let sut = makeSUT(level: restingLevel())
        startPlaying(sut)
        clock.tick(frames: 50)

        sut.replay()
        #expect(sut.phase == .ready)
        #expect(sut.level.id == "1-1")

        gaze.inject(point: farGaze, timestamp: 2)
        sut.primaryAction()
        clock.tick(frames: 10)
        sut.pause()
        sut.restartLevel()
        #expect(sut.phase == .ready)
        #expect(sut.snapshot.lueurs[0].progress == 0)
    }

    @Test("the last level of the campaign ends on the finale")
    func campaignEnd() {
        let sut = makeSUT(level: restingLevel(chapter: 6, index: 6))
        startPlaying(sut)
        clock.tick(frames: 50)

        guard case let .levelComplete(result) = sut.phase else {
            Issue.record("expected result")
            return
        }
        #expect(result.isCampaignEnd && result.isChapterEnd && !result.hasNextLevel)
        #expect(result.primaryTitle == "Voir la fin")

        sut.primaryAction()
        #expect(navigator.finishCampaignCount == 1)
        #expect(gaze.state == .idle)
    }

    @Test("the last level of a chapter proposes the next chapter and changes the drone")
    func chapterEnd() {
        let sut = makeSUT(level: restingLevel(chapter: 1, index: 5))
        startPlaying(sut)
        clock.tick(frames: 50)

        guard case let .levelComplete(result) = sut.phase else {
            Issue.record("expected result")
            return
        }
        #expect(result.isChapterEnd && result.primaryTitle == "Chapitre suivant")
        sut.primaryAction()
        #expect(sut.level.id == "2-1")
        #expect(audio.cues.contains(.ambient(frequency: 123.47)))
    }

    @Test("pause stops the loop, resume continues, chapters leaves the game")
    func pauseAndChapters() {
        let sut = makeSUT(level: restingLevel())
        startPlaying(sut)
        clock.tick(frames: 5)

        sut.pause()
        #expect(sut.phase == .paused)
        #expect(!clock.isRunning)
        sut.primaryAction()
        #expect(sut.phase == .playing)

        sut.pause()
        sut.openChapters()
        #expect(navigator.chaptersCount == 1)
        #expect(gaze.state == .idle)
        #expect(audio.deactivateCount == 1)
    }

    @Test("after the help delay a pushing level shows its route")
    func routeHelp() {
        guard let pushing = Campaign.level(id: "3-1") else {
            Issue.record("missing 3-1")
            return
        }
        let sut = makeSUT(level: pushing)
        startPlaying(sut)

        clock.tick(frames: 60 * 44)
        #expect(sut.snapshot.routes.isEmpty)
        clock.tick(frames: 90)
        #expect(sut.snapshot.routes.count == 1)
        #expect(sut.hint == "La voie est tracée en pointillés.")
    }

    @Test("the cursor starts on the latest gaze, follows samples while playing, freezes while paused")
    func cursor() {
        let sut = makeSUT(level: restingLevel())
        prepared(sut)
        sut.showsGazeIndicator = true
        gaze.inject(point: Vector2(x: 10, y: 10), timestamp: 0)

        sut.primaryAction()
        clock.tick(1.0 / 60.0)
        expectClose(sut.snapshot.gaze, Vector2(x: 10, y: 10), "seeded")
        gaze.inject(point: Vector2(x: 110, y: 10), timestamp: 1)
        clock.tick(1.0 / 60.0)
        expectClose(sut.snapshot.gaze, Vector2(x: 20, y: 10), "smoothed")
        sut.pause()
        gaze.inject(point: Vector2(x: 300, y: 300), timestamp: 2)
        expectClose(sut.snapshot.gaze, Vector2(x: 20, y: 10), "frozen")
    }

    @Test("a stored compatible profile corrects the gaze")
    func calibrationApplied() {
        let viewport = PlayfieldBounds(width: 390, height: 844)
        store.save(CalibrationProfile(transform: AffineTransform2D(a0: 0.1, a1: 1, a2: 0, b0: 0, b1: 0, b2: 1),
                                      axisMapping: .standard, interfaceOrientation: "portrait", viewport: viewport,
                                      nominalGeometry: NominalDisplayGeometry.estimate(viewport: viewport, displayScale: 3, isPad: false),
                                      createdAt: Date(), validationMeanError: 0.07, validationMaxError: 0.12, isValid: true))
        let sut = makeSUT(level: restingLevel())
        prepared(sut)
        sut.showsGazeIndicator = true
        gaze.inject(point: Vector2(x: 100, y: 700), timestamp: 0)

        sut.primaryAction()
        clock.tick(1.0 / 60.0)

        #expect(sut.calibrationStatus == .calibrated(meanError: 0.07, isValid: true))
        expectClose(sut.snapshot.gaze, Vector2(x: 139, y: 700))
    }

    @Test("face lost for 0.3 s pauses the game, which resumes by itself")
    func faceLost() {
        let sut = makeSUT(level: restingLevel())
        startPlaying(sut)
        gaze.simulate(state: .tracking(faceVisible: false))
        clock.tick(frames: 10)
        #expect(sut.phase == .playing)
        clock.tick(frames: 12)
        #expect(sut.phase == .faceLost)
        gaze.simulate(state: .tracking(faceVisible: true))
        #expect(sut.phase == .playing)
    }

    @Test("interruption, camera denial and tracking errors")
    func interruptionsAndFailures() {
        let sut = makeSUT(level: restingLevel())
        startPlaying(sut)
        gaze.simulate(state: .interrupted)
        #expect(sut.phase == .interrupted)
        gaze.simulate(state: .tracking(faceVisible: true))
        #expect(sut.phase == .resuming)
        gaze.simulate(state: .unavailable(.cameraDenied))
        #expect(sut.phase == .failed(.cameraDenied))
        gaze.simulate(state: .failed(message: "boom"))
        #expect(sut.phase == .failed(.trackingError(message: "boom")))
    }

    @Test("background and foreground keep the level, the result survives a background trip")
    func lifecycle() {
        let sut = makeSUT(level: restingLevel())
        startPlaying(sut)
        clock.tick(frames: 3)
        sut.suspend()
        #expect(sut.phase == .suspended)
        sut.wake()
        #expect(sut.phase == .resuming)

        sut.primaryAction()
        clock.tick(frames: 50)
        guard case .levelComplete = sut.phase else {
            Issue.record("expected result")
            return
        }
        let result = sut.phase
        sut.suspend()
        sut.wake()
        #expect(sut.phase == result)
    }

    @Test("recalibration suspends the game and resumes it")
    func recalibration() {
        let sut = makeSUT(level: restingLevel())
        startPlaying(sut)
        sut.pause()

        sut.requestRecalibration()
        #expect(sut.phase == .suspended)
        #expect(navigator.recalibrationCount == 1)
        sut.resumeAfterRecalibration()
        #expect(sut.phase == .resuming)
    }

    @Test("autoplay skips the intro card")
    func autoplay() {
        let sut = makeSUT(level: restingLevel(), autoplay: true)
        prepared(sut)
        #expect(sut.phase == .playing)
    }

    @Test("a late onDisappear after handing the tracker to the setup does not stop the setup's session")
    func sharedTrackerOwnership() {
        let sut = makeSUT(level: restingLevel())
        startPlaying(sut)
        sut.pause()
        sut.requestRecalibration()
        let setup = GazeSetupViewModel(intent: .recalibrate, gaze: gaze, calibrationStore: store,
                                       capabilities: StaticDeviceCapabilities(supportsFaceTracking: true),
                                       cameraAuthorization: StubCameraAuthorizationService(status: .authorized),
                                       orientation: FixedOrientationProvider(), settings: settings, isPad: false, navigator: navigator)
        setup.prepare(width: 390, height: 844, displayScale: 3)

        sut.viewDisappeared()
        #expect(gaze.state == .tracking(faceVisible: true))

        setup.finish()
        sut.resumeAfterRecalibration()
        setup.viewDisappeared()
        #expect(gaze.state == .tracking(faceVisible: true))
    }
}
