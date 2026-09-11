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
    let calibrationStore: any CalibrationStore
    let orientationProvider: any InterfaceOrientationProvider
    let isPad: Bool
    let launchOptions: LaunchOptions

    /// One gaze tracker per process, shared by the setup and the game (one ARSession, started and stopped by each screen).
    private(set) lazy var gazeTracking: any GazeTrackingService = makeGazeTrackingService()

    init(environment: AppEnvironment,
         capabilities: any DeviceCapabilities,
         cameraAuthorization: any CameraAuthorizationService,
         settings: GameSettingsStore,
         calibrationStore: any CalibrationStore,
         orientationProvider: any InterfaceOrientationProvider,
         isPad: Bool,
         launchOptions: LaunchOptions = .none) {
        self.environment = environment
        self.capabilities = capabilities
        self.cameraAuthorization = cameraAuthorization
        self.settings = settings
        self.calibrationStore = calibrationStore
        self.orientationProvider = orientationProvider
        self.isPad = isPad
        self.launchOptions = launchOptions
    }

    /// The container used by the running app. On the simulator, gaze comes from the pointer (or a scripted oracle)
    /// because no TrueDepth camera exists there; on a device every service is real.
    static func live() -> AppContainer {
        #if DEBUG
        let launchOptions = LaunchOptions.parse(ProcessInfo.processInfo.arguments)
        #else
        let launchOptions = LaunchOptions.none
        #endif
        #if targetEnvironment(simulator)
        return AppContainer(environment: .simulator,
                            capabilities: StaticDeviceCapabilities(supportsFaceTracking: true),
                            cameraAuthorization: StubCameraAuthorizationService(status: .authorized),
                            settings: GameSettingsStore(),
                            calibrationStore: UserDefaultsCalibrationStore(),
                            orientationProvider: WindowSceneOrientationProvider(),
                            isPad: DeviceIdiom.isPad,
                            launchOptions: launchOptions)
        #else
        return AppContainer(environment: .live,
                            capabilities: ARKitDeviceCapabilities(),
                            cameraAuthorization: AVCaptureCameraAuthorizationService(),
                            settings: GameSettingsStore(),
                            calibrationStore: UserDefaultsCalibrationStore(),
                            orientationProvider: WindowSceneOrientationProvider(),
                            isPad: DeviceIdiom.isPad,
                            launchOptions: launchOptions)
        #endif
    }

    static func preview(supportsFaceTracking: Bool = true,
                        cameraStatus: CameraAuthorizationStatus = .authorized,
                        calibrationStore: any CalibrationStore = InMemoryCalibrationStore(),
                        launchOptions: LaunchOptions = .none) -> AppContainer {
        AppContainer(environment: .preview,
                     capabilities: StaticDeviceCapabilities(supportsFaceTracking: supportsFaceTracking),
                     cameraAuthorization: StubCameraAuthorizationService(status: cameraStatus),
                     settings: GameSettingsStore(defaults: UserDefaults(suiteName: "iris.preview.\(UUID().uuidString)") ?? .standard),
                     calibrationStore: calibrationStore,
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

    func makeGameViewModel(navigator: any GameNavigating) -> GameViewModel {
        let startingIndex = (launchOptions.startingLevel ?? 1) - 1
        return GameViewModel(progression: GameProgression(startingIndex: startingIndex),
                             gaze: gazeTracking,
                             audio: makeAudioService(),
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
