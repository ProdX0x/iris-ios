// AppCoordinatorTests.swift
// Layer: Tests
// Purpose: Deterministic route transitions of the coordinator

import Foundation
import Testing
@testable import Iris

@Suite("AppCoordinator")
@MainActor
struct AppCoordinatorTests {
    private func makeSUT(supportsFaceTracking: Bool = true, cameraStatus: CameraAuthorizationStatus = .authorized,
                         store: any CalibrationStore = InMemoryCalibrationStore()) -> AppCoordinator {
        AppContainer.preview(supportsFaceTracking: supportsFaceTracking, cameraStatus: cameraStatus, calibrationStore: store).makeAppCoordinator()
    }

    private func validProfile() -> CalibrationProfile {
        CalibrationProfile(transform: .identity, axisMapping: .standard, interfaceOrientation: "portrait", viewport: .referencePhone,
                           nominalGeometry: NominalDisplayGeometry.estimate(viewport: .referencePhone, displayScale: 3, isPad: false),
                           createdAt: Date(), validationMeanError: 0.05, validationMaxError: 0.1, isValid: true)
    }

    @Test("starts at home")
    func home() {
        #expect(makeSUT().route == .home)
    }

    @Test("an unsupported device goes to the unavailability screen")
    func unsupportedDevice() {
        let sut = makeSUT(supportsFaceTracking: false)

        sut.beginJourney()

        #expect(sut.route == .unavailable(.faceTrackingUnsupported))
        sut.returnHome()
        #expect(sut.route == .home)
    }

    @Test("with camera authorized and no stored calibration the journey starts with the first-run gaze setup")
    func authorizedGoesToGazeSetup() {
        let sut = makeSUT(cameraStatus: .authorized)

        sut.beginJourney()

        #expect(sut.route == .gazeSetup(.firstRun))
        #expect(sut.gazeSetupViewModel != nil)
    }

    @Test("a stored valid calibration only needs a revalidation")
    func storedProfileRevalidates() {
        let sut = makeSUT(store: InMemoryCalibrationStore(profile: validProfile()))

        sut.beginJourney()

        #expect(sut.route == .gazeSetup(.revalidate))
    }

    @Test("gaze setup completion leads to the tutorial the first time, then straight to the game")
    func setupCompletion() {
        let sut = makeSUT()
        sut.beginJourney()

        sut.gazeSetupCompleted(intent: .firstRun)
        #expect(sut.route == .tutorial)
        #expect(sut.gazeSetupViewModel == nil)

        sut.startGame()
        #expect(sut.route == .game)

        sut.returnHome()
        sut.beginJourney()
        #expect(sut.route == .game, "gaze already validated in this session and tutorial seen")
    }

    @Test("cancelling the first-run setup returns home")
    func setupCancelled() {
        let sut = makeSUT()
        sut.beginJourney()

        sut.gazeSetupCancelled(intent: .firstRun)

        #expect(sut.route == .home)
    }

    @Test("recalibration from the game keeps the game ViewModel and comes back to it")
    func recalibrationRoundTrip() {
        let sut = makeSUT()
        sut.gazeSetupCompleted(intent: .firstRun)
        sut.startGame()
        let game = sut.gameViewModel

        sut.gameDidRequestRecalibration()
        #expect(sut.route == .gazeSetup(.recalibrate))
        #expect(sut.gameViewModel === game)

        sut.gazeSetupCompleted(intent: .recalibrate)
        #expect(sut.route == .game)
        #expect(sut.gameViewModel === game)

        sut.gameDidRequestRecalibration()
        sut.gazeSetupCancelled(intent: .recalibrate)
        #expect(sut.route == .game)
    }

    @Test("without camera decision the journey asks for camera access first")
    func askCameraFirst() {
        for status in [CameraAuthorizationStatus.notDetermined, .denied, .restricted] {
            let sut = makeSUT(cameraStatus: status)

            sut.beginJourney()

            #expect(sut.route == .cameraAccess)
            #expect(sut.cameraAccessViewModel != nil)

            sut.cameraAccessGranted()
            #expect(sut.route == .gazeSetup(.firstRun))
            #expect(sut.cameraAccessViewModel == nil)
        }
    }

    @Test("abandoning camera access returns home")
    func abandonCamera() {
        let sut = makeSUT(cameraStatus: .notDetermined)
        sut.beginJourney()

        sut.cameraAccessAbandoned()

        #expect(sut.route == .home)
    }

    @Test("starting the game creates a game ViewModel; finishing or exiting releases it")
    func gameLifecycle() {
        let sut = makeSUT()
        sut.gazeSetupCompleted(intent: .firstRun)

        sut.startGame()
        #expect(sut.route == .game)
        #expect(sut.gameViewModel != nil)

        sut.gameDidFinishJourney(summary: JourneySummary(levelCount: 14, playDuration: 10))
        #expect(sut.route == .journeyComplete(JourneySummary(levelCount: 14, playDuration: 10)))
        #expect(sut.gameViewModel == nil)

        sut.replayJourney()
        #expect(sut.route == .game)

        sut.gameDidRequestExit()
        #expect(sut.route == .home)
        #expect(sut.gameViewModel == nil)
    }

    @Test("launch options can open any route directly")
    func launchOptions() {
        let container = AppContainer.preview(launchOptions: LaunchOptions(initialRoute: .game, autoplay: false, startingLevel: 9))
        let sut = container.makeAppCoordinator()

        #expect(sut.route == .game)
        #expect(sut.gameViewModel?.levelNumber == 9)
    }
}
