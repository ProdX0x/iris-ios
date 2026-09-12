// AppCoordinatorTests.swift
// Layer: Tests
// Purpose: Deterministic routes, gaze gating, progress recording and debug launch options

import Foundation
import Testing
@testable import Iris

@Suite("AppCoordinator")
@MainActor
struct AppCoordinatorTests {
    private func makeSUT(supportsFaceTracking: Bool = true, cameraStatus: CameraAuthorizationStatus = .authorized,
                         calibration: any CalibrationStore = InMemoryCalibrationStore(),
                         progress: any ProgressStore = InMemoryProgressStore(),
                         launchOptions: LaunchOptions = .none) -> AppCoordinator {
        AppContainer.preview(supportsFaceTracking: supportsFaceTracking, cameraStatus: cameraStatus, calibrationStore: calibration,
                             progressStore: progress, launchOptions: launchOptions).makeAppCoordinator()
    }

    private func validProfile() -> CalibrationProfile {
        CalibrationProfile(transform: .identity, axisMapping: .standard, interfaceOrientation: "portrait", viewport: .referencePhone,
                           nominalGeometry: NominalDisplayGeometry.estimate(viewport: .referencePhone, displayScale: 3, isPad: false),
                           createdAt: Date(), validationMeanError: 0.05, validationMaxError: 0.1, isValid: true)
    }

    private func level(_ id: String) -> LevelDefinition {
        guard let level = Campaign.level(id: id) else { preconditionFailure("missing level \(id)") }
        return level
    }

    @Test("starts at the threshold proposing to begin with the first level")
    func home() {
        let sut = makeSUT()

        #expect(sut.route == .home)
        #expect(sut.homeSummary.action == .begin)
        #expect(sut.homeSummary.primaryTitle == "Commencer")
        #expect(sut.homeSummary.detail == "I · éveil — 1 · premier regard")
        #expect(sut.homeSummary.maxEclats == Campaign.levels.count * 3)
    }

    @Test("an unsupported device goes to the unavailability screen")
    func unsupported() {
        let sut = makeSUT(supportsFaceTracking: false)
        sut.continueJourney()
        #expect(sut.route == .unavailable(.faceTrackingUnsupported))
    }

    @Test("first launch: gaze setup first, then the pending level")
    func firstRun() {
        let sut = makeSUT()
        sut.continueJourney()
        #expect(sut.route == .gazeSetup(.firstRun))

        sut.gazeSetupCompleted(intent: .firstRun)
        #expect(sut.route == .game)
        #expect(sut.gameViewModel?.level.id == "1-1")
        #expect(sut.isGazeReady)
    }

    @Test("a stored valid calibration only needs a revalidation")
    func revalidation() {
        let sut = makeSUT(calibration: InMemoryCalibrationStore(profile: validProfile()))
        sut.continueJourney()
        #expect(sut.route == .gazeSetup(.revalidate))
    }

    @Test("camera permission comes before the gaze setup; abandoning returns home; a still-denied camera stays on the permission screen")
    func camera() async {
        let sut = makeSUT(cameraStatus: .notDetermined)
        sut.continueJourney()
        #expect(sut.route == .cameraAccess)
        sut.cameraAccessAbandoned()
        #expect(sut.route == .home)

        let container = AppContainer.preview(cameraStatus: .notDetermined)
        let granted = container.makeAppCoordinator()
        granted.continueJourney()
        _ = await container.cameraAuthorization.requestAccess()
        granted.cameraAccessGranted()
        #expect(granted.route == .gazeSetup(.firstRun))

        let stillDenied = makeSUT(cameraStatus: .denied)
        stillDenied.continueJourney()
        stillDenied.cameraAccessGranted()
        #expect(stillDenied.route == .cameraAccess, "the coordinator re-checks the real status")
    }

    @Test("cancelling the setup returns home and forgets the pending level")
    func cancelSetup() {
        let sut = makeSUT()
        sut.continueJourney()
        sut.gazeSetupCancelled(intent: .firstRun)
        #expect(sut.route == .home)
        #expect(sut.gameViewModel == nil)
    }

    @Test("locked levels cannot be played; completing a level unlocks the next and updates the threshold")
    func progress() {
        let store = InMemoryProgressStore()
        let sut = makeSUT(progress: store)
        sut.play(level("2-1"))
        #expect(sut.route == .home)

        let previous = sut.gameDidComplete(level: level("1-1"), outcome: LevelOutcome(time: 8, intrusions: 1, losses: 0))
        #expect(previous == LevelRecord())
        #expect(sut.isUnlocked(level("1-2")))
        #expect(sut.homeSummary.action == .resume)
        #expect(sut.homeSummary.detail == "I · éveil — 2 · tenir")
        #expect(sut.homeSummary.eclats == 3)
        #expect(store.load().record(for: level("1-1")).completions == 1)

        let again = sut.gameDidComplete(level: level("1-1"), outcome: LevelOutcome(time: 20, intrusions: 9, losses: 1))
        #expect(again.eclats == [.atteint, .fluide, .serein])
    }

    @Test("levels introduce their elements to the Carnet once")
    func carnet() {
        let store = InMemoryProgressStore()
        let sut = makeSUT(progress: store)
        sut.gameDidStart(level: level("3-1"))
        #expect(sut.progress.encounteredElements == [.courant])
        #expect(store.load().encounteredElements == [.courant])
        sut.openCarnet()
        #expect(sut.route == .carnet)
    }

    @Test("with the gaze ready, playing from the chapters opens the game directly; chapters from the game come back")
    func chaptersFlow() {
        let sut = makeSUT()
        sut.continueJourney()
        sut.gazeSetupCompleted(intent: .firstRun)
        sut.gameDidRequestChapters()
        #expect(sut.route == .chapters)
        #expect(sut.gameViewModel == nil)

        sut.play(level("1-1"))
        #expect(sut.route == .game)
    }

    @Test("settings sheet, recalibration from settings returns to the previous route")
    func settings() {
        let sut = makeSUT()
        sut.openChapters()
        sut.showSettings()
        #expect(sut.sheet == .settings)

        sut.recalibrate()
        #expect(sut.sheet == nil)
        #expect(sut.route == .gazeSetup(.recalibrate))
        sut.gazeSetupCompleted(intent: .recalibrate)
        #expect(sut.route == .chapters)

        sut.recalibrate()
        sut.gazeSetupCancelled(intent: .recalibrate)
        #expect(sut.route == .chapters)
    }

    @Test("recalibration from the game keeps the game and returns to it")
    func recalibrationFromGame() {
        let sut = makeSUT()
        sut.continueJourney()
        sut.gazeSetupCompleted(intent: .firstRun)
        let game = sut.gameViewModel

        sut.gameDidRequestRecalibration()
        #expect(sut.route == .gazeSetup(.recalibrate))
        sut.gazeSetupCompleted(intent: .recalibrate)
        #expect(sut.route == .game)
        #expect(sut.gameViewModel === game)
    }

    @Test("finishing the campaign shows the journey end with totals")
    func finale() {
        let sut = makeSUT(progress: InMemoryProgressStore(progress: LaunchOptions.progress(for: .all)))
        sut.gameDidFinishCampaign()

        guard case let .journeyComplete(summary) = sut.route else {
            Issue.record("expected journey end")
            return
        }
        #expect(summary.levelCount == Campaign.levels.count)
        #expect(summary.maxEclats == Campaign.levels.count * 3)
        #expect(summary.eclats > Campaign.levels.count)
        #expect(sut.homeSummary.action == .replay)
    }

    @Test("reset clears the progress")
    func reset() {
        let sut = makeSUT(progress: InMemoryProgressStore(progress: LaunchOptions.progress(for: .through("2-3"))))
        #expect(sut.homeSummary.action == .resume)
        sut.resetProgress()
        #expect(sut.homeSummary.action == .begin)
    }

    @Test("launch options open a given level directly")
    func launchOptions() {
        let sut = makeSUT(launchOptions: LaunchOptions(initialRoute: .game, level: "3-2"))
        #expect(sut.route == .game)
        #expect(sut.gameViewModel?.level.id == "3-2")
    }
}
