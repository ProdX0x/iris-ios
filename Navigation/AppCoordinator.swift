// AppCoordinator.swift
// Layer: Presentation (Navigation)
// Purpose: Deterministic route state machine and owner of the campaign progress

import Foundation
import Observation

@MainActor
@Observable
final class AppCoordinator {
    private(set) var route: AppRoute = .home
    var sheet: AppSheet?
    private(set) var gameViewModel: GameViewModel?
    private(set) var cameraAccessViewModel: CameraAccessViewModel?
    private(set) var gazeSetupViewModel: GazeSetupViewModel?
    /// The gaze was validated during this process lifetime; levels may start without another setup.
    private(set) var isGazeReady = false
    private(set) var progress: CampaignProgress

    @ObservationIgnored private var pendingLevel: LevelDefinition?
    @ObservationIgnored private var routeBeforeSetup: AppRoute = .home
    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
        self.progress = container.progressStore.load()
        if let route = container.launchOptions.initialRoute {
            jump(to: route)
        }
    }

    var settings: GameSettingsStore { container.settings }

    // MARK: Progress queries

    var nextLevel: LevelDefinition? {
        progress.nextLevel(in: Campaign.levels)
    }

    var homeSummary: HomeSummary {
        let levels = Campaign.levels
        let eclats = progress.eclatCount(in: levels)
        guard let next = nextLevel else {
            return HomeSummary(action: .replay, detail: nil, eclats: eclats, maxEclats: levels.count * 3)
        }
        let started = progress.completedCount(in: levels) > 0
        return HomeSummary(action: started ? .resume : .begin, detail: Self.label(for: next), eclats: eclats, maxEclats: levels.count * 3)
    }

    func isUnlocked(_ level: LevelDefinition) -> Bool {
        progress.isUnlocked(level, in: Campaign.levels)
    }

    func isUnlocked(_ chapter: ChapterDefinition) -> Bool {
        progress.isUnlocked(chapter, in: Campaign.levels)
    }

    func record(for level: LevelDefinition) -> LevelRecord {
        progress.record(for: level)
    }

    static func label(for level: LevelDefinition) -> String {
        let chapter = Campaign.chapter(of: level)
        return "\(chapter?.numeral ?? "") · \(chapter?.name ?? "") — \(level.index) · \(level.title)"
    }

    // MARK: Intents

    func continueJourney() {
        if let next = nextLevel {
            play(next)
        } else {
            openChapters()
        }
    }

    func openChapters() {
        route = .chapters
    }

    func openCarnet() {
        sheet = nil
        route = .carnet
    }

    func showSettings() {
        sheet = .settings
    }

    func dismissSheet() {
        sheet = nil
    }

    func returnHome() {
        gameViewModel = nil
        cameraAccessViewModel = nil
        gazeSetupViewModel = nil
        pendingLevel = nil
        route = .home
    }

    /// Starts a level once hardware, camera permission and gaze are ready. Locked levels are ignored.
    func play(_ level: LevelDefinition) {
        guard isUnlocked(level) else { return }
        pendingLevel = level
        proceedToLevel()
    }

    /// Recalibration from the settings sheet; comes back to the current route.
    func recalibrate() {
        sheet = nil
        routeBeforeSetup = route
        openGazeSetup(intent: .recalibrate)
    }

    func resetProgress() {
        container.progressStore.reset()
        progress = container.progressStore.load()
    }

    // MARK: Flow

    private func proceedToLevel() {
        guard container.capabilities.supportsFaceTracking else {
            route = .unavailable(.faceTrackingUnsupported)
            return
        }
        switch container.cameraAuthorization.currentStatus() {
        case .authorized:
            if isGazeReady {
                presentPendingLevel()
            } else {
                routeBeforeSetup = .home
                let stored = container.calibrationStore.load()
                openGazeSetup(intent: stored?.isCurrentAndValid == true ? .revalidate : .firstRun)
            }
        case .notDetermined, .denied, .restricted:
            cameraAccessViewModel = container.makeCameraAccessViewModel(navigator: self)
            route = .cameraAccess
        }
    }

    private func openGazeSetup(intent: GazeSetupIntent) {
        gazeSetupViewModel = container.makeGazeSetupViewModel(intent: intent, navigator: self)
        route = .gazeSetup(intent)
    }

    private func presentPendingLevel() {
        guard let level = pendingLevel else {
            route = .home
            return
        }
        pendingLevel = nil
        gameViewModel = container.makeGameViewModel(level: level, navigator: self)
        route = .game
    }

    private func persist() {
        container.progressStore.save(progress)
    }

    /// Opens a route directly (debug launch options).
    private func jump(to route: AppRoute) {
        switch route {
        case .game:
            isGazeReady = true
            pendingLevel = container.launchOptions.level.flatMap(Campaign.level(id:)) ?? nextLevel ?? Campaign.levels.first
            presentPendingLevel()
        case .cameraAccess:
            cameraAccessViewModel = container.makeCameraAccessViewModel(navigator: self)
            self.route = route
        case let .gazeSetup(intent):
            openGazeSetup(intent: intent)
        case .home, .chapters, .carnet, .journeyComplete, .unavailable:
            self.route = route
        }
    }
}

extension AppCoordinator: CameraAccessNavigating {
    func cameraAccessGranted() {
        cameraAccessViewModel = nil
        if pendingLevel == nil {
            route = .home
        } else {
            proceedToLevel()
        }
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
            if let game = gameViewModel {
                route = .game
                game.resumeAfterRecalibration()
            } else {
                route = routeBeforeSetup
            }
        case .firstRun, .revalidate:
            if pendingLevel != nil {
                presentPendingLevel()
            } else {
                route = .home
            }
        }
    }

    func gazeSetupCancelled(intent: GazeSetupIntent) {
        gazeSetupViewModel = nil
        switch intent {
        case .recalibrate:
            if let game = gameViewModel {
                route = .game
                game.resumeAfterRecalibration()
            } else {
                route = routeBeforeSetup
            }
        case .firstRun, .revalidate:
            returnHome()
        }
    }
}

extension AppCoordinator: GameNavigating {
    func gameDidStart(level: LevelDefinition) {
        guard !level.introduces.allSatisfy(progress.encounteredElements.contains) else { return }
        progress.encounter(level.introduces)
        persist()
    }

    func gameDidComplete(level: LevelDefinition, outcome: LevelOutcome) -> LevelRecord {
        let previous = progress.record(for: level)
        progress.register(outcome, for: level)
        persist()
        return previous
    }

    func gameDidRequestChapters() {
        gameViewModel = nil
        route = .chapters
    }

    func gameDidFinishCampaign() {
        gameViewModel = nil
        route = .journeyComplete(JourneySummary(levelCount: Campaign.levels.count,
                                                playDuration: progress.totalPlayTime,
                                                eclats: progress.eclatCount(in: Campaign.levels),
                                                maxEclats: Campaign.levels.count * 3))
    }

    func gameDidRequestExit() {
        returnHome()
    }

    func gameDidRequestRecalibration() {
        routeBeforeSetup = .game
        openGazeSetup(intent: .recalibrate)
    }
}
