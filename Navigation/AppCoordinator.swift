// AppCoordinator.swift
// Layer: Presentation (Navigation)
// Purpose: Deterministic route state machine: home, camera access, gaze setup, tutorial, game, journey end

import Foundation
import Observation

@MainActor
@Observable
final class AppCoordinator {
    private(set) var route: AppRoute = .home
    private(set) var gameViewModel: GameViewModel?
    private(set) var cameraAccessViewModel: CameraAccessViewModel?
    private(set) var gazeSetupViewModel: GazeSetupViewModel?
    /// The gaze was validated during this process lifetime; the game may start without another setup.
    private(set) var isGazeReady = false

    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
        if let route = container.launchOptions.initialRoute {
            jump(to: route)
        }
    }

    /// Opens a route directly (launch options); the game route builds its ViewModel like `startGame`.
    private func jump(to route: AppRoute) {
        switch route {
        case .game:
            isGazeReady = true
            presentGame()
        case .cameraAccess:
            cameraAccessViewModel = container.makeCameraAccessViewModel(navigator: self)
            self.route = route
        case let .gazeSetup(intent):
            openGazeSetup(intent: intent)
        case .home, .tutorial, .journeyComplete, .unavailable:
            self.route = route
        }
    }

    // MARK: Intents

    func beginJourney() {
        guard container.capabilities.supportsFaceTracking else {
            route = .unavailable(.faceTrackingUnsupported)
            return
        }
        switch container.cameraAuthorization.currentStatus() {
        case .authorized:
            proceedToGazeSetupOrGame()
        case .notDetermined, .denied, .restricted:
            cameraAccessViewModel = container.makeCameraAccessViewModel(navigator: self)
            route = .cameraAccess
        }
    }

    func showTutorial() {
        route = .tutorial
    }

    /// From the tutorial or the journey end: the game starts only once the gaze has been validated.
    func startGame() {
        container.settings.hasSeenTutorial = true
        if isGazeReady {
            presentGame()
        } else {
            beginJourney()
        }
    }

    func returnHome() {
        gameViewModel = nil
        cameraAccessViewModel = nil
        gazeSetupViewModel = nil
        route = .home
    }

    func replayJourney() {
        startGame()
    }

    // MARK: Helpers

    private func proceedToGazeSetupOrGame() {
        if isGazeReady {
            if container.settings.hasSeenTutorial {
                presentGame()
            } else {
                route = .tutorial
            }
            return
        }
        let stored = container.calibrationStore.load()
        openGazeSetup(intent: stored?.isCurrentAndValid == true ? .revalidate : .firstRun)
    }

    private func openGazeSetup(intent: GazeSetupIntent) {
        gazeSetupViewModel = container.makeGazeSetupViewModel(intent: intent, navigator: self)
        route = .gazeSetup(intent)
    }

    private func presentGame() {
        gameViewModel = container.makeGameViewModel(navigator: self)
        route = .game
    }
}

extension AppCoordinator: CameraAccessNavigating {
    func cameraAccessGranted() {
        cameraAccessViewModel = nil
        proceedToGazeSetupOrGame()
    }

    func cameraAccessAbandoned() {
        returnHome()
    }
}

extension AppCoordinator: GazeSetupNavigating {
    func gazeSetupCompleted(intent: GazeSetupIntent) {
        gazeSetupViewModel = nil
        isGazeReady = true
        switch intent {
        case .recalibrate:
            route = .game
            gameViewModel?.resumeAfterRecalibration()
        case .firstRun, .revalidate:
            if container.settings.hasSeenTutorial {
                presentGame()
            } else {
                route = .tutorial
            }
        }
    }

    func gazeSetupCancelled(intent: GazeSetupIntent) {
        gazeSetupViewModel = nil
        switch intent {
        case .recalibrate:
            route = .game
            gameViewModel?.resumeAfterRecalibration()
        case .firstRun, .revalidate:
            returnHome()
        }
    }
}

extension AppCoordinator: GameNavigating {
    func gameDidFinishJourney(summary: JourneySummary) {
        gameViewModel = nil
        route = .journeyComplete(summary)
    }

    func gameDidRequestExit() {
        returnHome()
    }

    func gameDidRequestRecalibration() {
        openGazeSetup(intent: .recalibrate)
    }
}
