// AppContainer.swift
// Layer: App (DI)
// Purpose: Composition root. The only place concrete services are chosen.

import Foundation

@MainActor
final class AppContainer {
    let environment: AppEnvironment
    let capabilities: any DeviceCapabilities
    let cameraAuthorization: any CameraAuthorizationService
    let settings: GameSettingsStore
    /// The store of commercial rights: the only object in Iris that may talk to StoreKit.
    let store: any StorePurchasing
    /// Whether the four explanation screens have already been shown.
    let onboarding: OnboardingStore
    let calibrationStore: any CalibrationStore
    let progressStore: any ProgressStore
    let orientationProvider: any InterfaceOrientationProvider
    let isPad: Bool
    let launchOptions: LaunchOptions

    /// One gaze tracker per process, shared by the setup and the game (one ARSession, started and stopped by each screen).
    private(set) lazy var gazeTracking: any GazeTrackingService = makeGazeTrackingService()

    init(environment: AppEnvironment,
         capabilities: any DeviceCapabilities,
         cameraAuthorization: any CameraAuthorizationService,
         settings: GameSettingsStore,
         store: any StorePurchasing,
         onboarding: OnboardingStore,
         calibrationStore: any CalibrationStore,
         progressStore: any ProgressStore,
         orientationProvider: any InterfaceOrientationProvider,
         isPad: Bool,
         launchOptions: LaunchOptions = .none) {
        self.environment = environment
        self.capabilities = capabilities
        self.cameraAuthorization = cameraAuthorization
        self.settings = settings
        self.store = store
        self.onboarding = onboarding
        self.calibrationStore = calibrationStore
        self.progressStore = progressStore
        self.orientationProvider = orientationProvider
        self.isPad = isPad
        self.launchOptions = launchOptions
    }

    /// The container used by the running app. On the simulator, gaze comes from the pointer (or a scripted oracle)
    /// because no TrueDepth camera exists there; on a device every service is real.
    static func live() -> AppContainer {
        #if DEBUG
        // Observes the system events a brief visual glitch could be correlated with. It draws nothing and changes
        // nothing; Release contains none of it.
        LifecycleTrace.shared.start()
        let launchOptions = LaunchOptions.parse(ProcessInfo.processInfo.arguments)
        #else
        let launchOptions = LaunchOptions.none
        #endif
        let progressStore: any ProgressStore = launchOptions.seededProgress.map {
            InMemoryProgressStore(progress: LaunchOptions.progress(for: $0))
        } ?? UserDefaultsProgressStore()
        // The store is the real one in every build. In DEBUG a launch argument may stand a fixed right in its place,
        // to reach a commercial state deterministically; Release parses no launch argument at all, so this cannot
        // exist there (CommerceBoundaryTests holds the guarantee).
        #if DEBUG
        let store: any StorePurchasing = launchOptions.entitlement
            .map { StaticEntitlementService(entitlement: $0) } ?? StoreKitEntitlementService()
        let onboarding = launchOptions.forcesOnboarding
            ? OnboardingStore(defaults: UserDefaults(suiteName: "iris.onboarding.debug.\(UUID().uuidString)") ?? .standard)
            : OnboardingStore()
        #else
        let store: any StorePurchasing = StoreKitEntitlementService()
        let onboarding = OnboardingStore()
        #endif
        #if targetEnvironment(simulator)
        return AppContainer(environment: .simulator,
                            capabilities: StaticDeviceCapabilities(supportsFaceTracking: true),
                            cameraAuthorization: StubCameraAuthorizationService(status: .authorized),
                            settings: GameSettingsStore(),
                            store: store,
                            onboarding: onboarding,
                            calibrationStore: UserDefaultsCalibrationStore(),
                            progressStore: progressStore,
                            orientationProvider: WindowSceneOrientationProvider(),
                            isPad: DeviceIdiom.isPad,
                            launchOptions: launchOptions)
        #else
        return AppContainer(environment: .live,
                            capabilities: ARKitDeviceCapabilities(),
                            cameraAuthorization: AVCaptureCameraAuthorizationService(),
                            settings: GameSettingsStore(),
                            store: store,
                            onboarding: onboarding,
                            calibrationStore: UserDefaultsCalibrationStore(),
                            progressStore: progressStore,
                            orientationProvider: WindowSceneOrientationProvider(),
                            isPad: DeviceIdiom.isPad,
                            launchOptions: launchOptions)
        #endif
    }

    static func preview(supportsFaceTracking: Bool = true,
                        cameraStatus: CameraAuthorizationStatus = .authorized,
                        calibrationStore: any CalibrationStore = InMemoryCalibrationStore(),
                        progressStore: any ProgressStore = InMemoryProgressStore(),
                        store: any StorePurchasing = StaticEntitlementService(),
                        hasCompletedOnboarding: Bool = true,
                        launchOptions: LaunchOptions = .none) -> AppContainer {
        // Previews and tests never touch the device's own defaults: settings and onboarding live in a throwaway suite.
        let defaults = UserDefaults(suiteName: "iris.preview.\(UUID().uuidString)") ?? .standard
        let onboarding = OnboardingStore(defaults: defaults)
        onboarding.hasCompletedOnboarding = hasCompletedOnboarding
        return AppContainer(environment: .preview,
                     capabilities: StaticDeviceCapabilities(supportsFaceTracking: supportsFaceTracking),
                     cameraAuthorization: StubCameraAuthorizationService(status: cameraStatus),
                     settings: GameSettingsStore(defaults: defaults),
                     store: store,
                     onboarding: onboarding,
                     calibrationStore: calibrationStore,
                     progressStore: progressStore,
                     orientationProvider: FixedOrientationProvider(),
                     isPad: false,
                     launchOptions: launchOptions)
    }

    // MARK: Services

    private func makeGazeTrackingService() -> any GazeTrackingService {
        switch environment {
        case .live:
            ARKitGazeTrackingService(capabilities: capabilities, orientationProvider: orientationProvider)
        case .simulator, .preview:
            SimulatedGazeTrackingService(parkedPoint: launchOptions.parkedGaze, oracle: launchOptions.oracleGaze)
        }
    }

    func makeAudioService() -> any AudioService {
        switch environment {
        case .live, .simulator: AVAudioEngineAudioService()
        case .preview: SilentAudioService()
        }
    }

    func makeHapticFeedbackService() -> any HapticFeedbackService {
        switch environment {
        case .live, .simulator: UIKitHapticFeedbackService()
        case .preview: SilentHapticFeedbackService()
        }
    }

    func makeGameClock() -> any GameClock {
        switch environment {
        case .live, .simulator: DisplayLinkGameClock()
        case .preview: ManualGameClock()
        }
    }

    // MARK: Presentation

    func makeAppCoordinator() -> AppCoordinator {
        AppCoordinator(container: self)
    }

    func makeGameViewModel(level: LevelDefinition, navigator: any GameNavigating) -> GameViewModel {
        GameViewModel(level: level,
                      gaze: gazeTracking,
                      audio: makeAudioService(),
                      haptics: makeHapticFeedbackService(),
                      clock: makeGameClock(),
                      settings: settings,
                      calibrationStore: calibrationStore,
                      orientation: orientationProvider,
                      isPad: isPad,
                      autoplay: launchOptions.autoplay,
                      navigator: navigator)
    }

    func makeCameraAccessViewModel(navigator: any CameraAccessNavigating) -> CameraAccessViewModel {
        CameraAccessViewModel(authorization: cameraAuthorization, navigator: navigator)
    }

    func makeGazeSetupViewModel(intent: GazeSetupIntent, navigator: any GazeSetupNavigating) -> GazeSetupViewModel {
        GazeSetupViewModel(intent: intent,
                           gaze: gazeTracking,
                           calibrationStore: calibrationStore,
                           capabilities: capabilities,
                           cameraAuthorization: cameraAuthorization,
                           orientation: orientationProvider,
                           settings: settings,
                           isPad: isPad,
                           navigator: navigator)
    }
}
