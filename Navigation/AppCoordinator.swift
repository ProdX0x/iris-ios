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

    /// The chapter whose lock opened the paywall, for the sheet to name it.
    private(set) var paywallChapter: ChapterDefinition?
    /// The level waiting behind the gaze introduction, started as soon as it is read.
    @ObservationIgnored private var levelAfterGazeIntroduction: LevelDefinition?

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
    /// The store, for the commercial screens only. Everything else asks `entitlement`.
    var store: any StorePurchasing { container.store }
    var onboarding: OnboardingStore { container.onboarding }

    /// The strongest commercial right the player holds right now.
    var entitlement: AccessEntitlement { container.store.entitlement }

    /// Called once the interface is on screen: the store starts listening off the first frame, never before it.
    func activate() {
        container.store.start()
    }

    /// The levels that teach the gaze marker are behind the player once the last of them is completed. This is
    /// derived from the campaign progress rather than stored again, so it survives exactly as the progress does.
    var hasCompletedGazeLearning: Bool {
        guard let final = Campaign.level(id: GazeAssistancePolicy.learningFinalLevelID) else { return true }
        return progress.isCompleted(final)
    }

    // MARK: Access queries

    /// True when the player's rights open this chapter; progression is a separate question.
    func isAccessible(_ chapter: ChapterDefinition) -> Bool {
        AccessPolicy.isAccessible(chapter, with: entitlement)
    }

    func isAccessible(_ level: LevelDefinition) -> Bool {
        AccessPolicy.isAccessible(level, with: entitlement)
    }

    /// True when the level may be started right now: reached in the campaign, and open to the player's rights.
    func isPlayable(_ level: LevelDefinition) -> Bool {
        isUnlocked(level) && isAccessible(level)
    }

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

    /// Switches to one of the three permanent destinations of the tab bar.
    func show(_ destination: AppDestination) {
        switch destination {
        case .seuil: returnHome()
        case .chapitres: openChapters()
        case .carnet: openCarnet()
        }
    }

    func showSettings() {
        sheet = .settings
    }

    func showHowToPlay() {
        sheet = .howToPlay
    }

    /// Opens the gaze introduction on demand (from the settings); starting a level is not implied.
    func showGazeIntroduction() {
        levelAfterGazeIntroduction = nil
        sheet = .gazeIntroduction
    }

    /// The three screens have been read: remember it, and start the level that was waiting behind them.
    func completeGazeIntroduction() {
        container.onboarding.completeGazeIntroduction()
        sheet = nil
        guard let level = levelAfterGazeIntroduction else { return }
        levelAfterGazeIntroduction = nil
        pendingLevel = level
        proceedToLevel()
    }

    /// Opens the full access screen, naming the chapter that led there when there is one.
    func presentPaywall(for chapter: ChapterDefinition? = nil) {
        paywallChapter = chapter
        sheet = .paywall
    }

    func completeOnboarding() {
        container.onboarding.complete()
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

    /// Starts a level once hardware, camera permission and gaze are ready. A level the campaign has not opened yet is
    /// ignored; a level the player's rights do not open leads to the full access screen instead.
    func play(_ level: LevelDefinition) {
        guard isUnlocked(level) else { return }
        guard isAccessible(level) else {
            presentPaywall(for: Campaign.chapter(of: level))
            return
        }
        // The very first level explains the gaze marker once, before anything starts.
        if level.id == GazeAssistancePolicy.learningLevelIDs.first, !container.onboarding.hasSeenGazeIntroduction {
            levelAfterGazeIntroduction = level
            sheet = .gazeIntroduction
            return
        }
        pendingLevel = level
        proceedToLevel()
    }

    #if DEBUG
    /// EXPERIMENTAL (prototype B1): starts a prototype level outside the campaign; nothing is unlocked or recorded.
    func playPrototype(_ level: LevelDefinition) {
        guard level.isExperimental else { return }
        sheet = nil
        pendingLevel = level
        proceedToLevel()
    }
    #endif

    /// Recalibration from the settings sheet; comes back to the current route.
    func recalibrate() {
        sheet = nil
        guard container.capabilities.supportsFaceTracking else {
            route = .unavailable(.faceTrackingUnsupported)
            return
        }
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

    private static func launchLevel(id: String) -> LevelDefinition? {
        if let level = Campaign.level(id: id) { return level }
        #if DEBUG
        return BraisesPrototype.level(id: id)
        #else
        return nil
        #endif
    }

    /// Opens a route directly (debug launch options).
    private func jump(to route: AppRoute) {
        switch route {
        case .game:
            isGazeReady = true
            pendingLevel = container.launchOptions.level.flatMap(Self.launchLevel(id:)) ?? nextLevel ?? Campaign.levels.first
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
    /// The game screen asks before moving on by itself; it never knows why the answer is no.
    func gameMayContinue(to level: LevelDefinition) -> Bool {
        isAccessible(level)
    }

    /// The campaign continues into a chapter the player's rights do not open: leave the game and say so.
    func gameDidReachLockedLevel(_ level: LevelDefinition) {
        gameViewModel = nil
        route = .chapters
        presentPaywall(for: Campaign.chapter(of: level))
    }

    func gameHasCompletedGazeLearning() -> Bool {
        hasCompletedGazeLearning
    }

    func gameDidStart(level: LevelDefinition) {
        guard !level.introduces.allSatisfy(progress.encounteredElements.contains) else { return }
        progress.encounter(level.introduces)
        persist()
    }

    func gameDidComplete(level: LevelDefinition, outcome: LevelOutcome) -> LevelRecord {
        guard !level.isExperimental else { return LevelRecord() }
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
