// VisualCaptureTests.swift
// Layer: Tests
// Purpose: Deterministic images of representative screens (off screen and hosted in a window) and of every level, to
// compare the rendering before and after a change meant to be invisible (written only when IRIS_CAPTURE_DIR is set)

import SwiftUI
import Testing
import UIKit
@testable import Iris

/// Directory receiving the images; set it outside the repository (`TEST_RUNNER_IRIS_CAPTURE_DIR` with xcodebuild).
private let captureDirectory = ProcessInfo.processInfo.environment["IRIS_CAPTURE_DIR"]

@Suite("Visual capture", .serialized)
@MainActor
struct VisualCaptureTests {
    /// iPhone 17 and 17 Pro, in points.
    static let phone = CGSize(width: 402, height: 874)

    private typealias Node = (level: LevelDefinition, state: LevelNode.State, eclats: Set<Eclat>)
    private typealias Draw = @MainActor (_ name: String, _ note: String, _ view: AnyView) async throws -> Void

    private func coordinator(seeded: LaunchOptions.SeededProgress? = nil) -> AppCoordinator {
        let progress = seeded.map { LaunchOptions.progress(for: $0) } ?? CampaignProgress()
        return AppContainer.preview(progressStore: InMemoryProgressStore(progress: progress)).makeAppCoordinator()
    }

    /// Every node state and éclat count appears across the campaign's cards; the last chapter stays locked.
    private func nodes(_ chapter: ChapterDefinition, open: Bool) -> [Node] {
        chapter.levels.enumerated().map { index, level -> Node in
            guard open else { return (level: level, state: .locked, eclats: []) }
            switch index % 4 {
            case 0: return (level: level, state: .completed, eclats: Set(Eclat.allCases))
            case 1: return (level: level, state: .completed, eclats: [.atteint])
            case 2: return (level: level, state: .next, eclats: [])
            default: return (level: level, state: .available, eclats: [])
            }
        }
    }

    private func restingLevel(chapter: Int) -> LevelDefinition {
        LevelDefinition(chapter: chapter, index: 1, title: "repos", principle: "p", zone: 0.46, noise: 0,
                        lueurs: [LueurDefinition(start: NormalizedPoint(x: 0.62, y: 0.3), iris: NormalizedPoint(x: 0.62, y: 0.3))],
                        hints: [], par: LevelPar(time: 10, intrusions: 2))
    }

    /// Phase text for the manifest, without the unordered sets of a result.
    private func note(_ phase: GamePhase) -> String {
        guard case let .levelComplete(result) = phase else { return String(describing: phase) }
        return "levelComplete \(result.levelID) earned \(result.earned.count) new \(result.newlyEarned.count) best \(result.isNewBestTime)"
    }

    /// Every representative screen; each state is built afresh, so no image depends on how the previous one was drawn.
    private func drawScreens(_ draw: Draw) async throws {
        try await draw("seuil-premier-lancement", "home, no progress", AnyView(HomeView().environment(coordinator())))
        try await draw("seuil-en-cours", "home, through 5-3", AnyView(HomeView().environment(coordinator(seeded: .through("5-3")))))
        try await draw("chapitres", "chapters, through 7-4", AnyView(ChaptersView().environment(coordinator(seeded: .through("7-4")))))
        let cards = VStack(spacing: 24) {
            ForEach(Array(Campaign.chapters.enumerated()), id: \.offset) { offset, chapter in
                let open = offset < Campaign.chapters.count - 1
                ChapterCard(chapter: chapter, isUnlocked: open, completed: open ? 2 : 0, nodes: nodes(chapter, open: open),
                            lockedHint: "Terminez le chapitre précédent", onSelect: { _ in })
            }
        }
        .padding(.horizontal, 24)
        try await draw("cartes-des-douze-chapitres", "every card, every node state", AnyView(cards))
        try await draw("carnet", "carnet, all progress", AnyView(CarnetView().environment(coordinator(seeded: .all))))
        try await draw("reglages", "settings sheet content", AnyView(SettingsView().environment(coordinator(seeded: .through("5-3")))))
        let summary = JourneySummary(levelCount: Campaign.levels.count, playDuration: 5_412,
                                     eclats: Campaign.levels.count * 3 - 21, maxEclats: Campaign.levels.count * 3)
        try await draw("fin-du-voyage", "journey complete", AnyView(JourneyCompleteView(summary: summary).environment(coordinator(seeded: .all))))
        try await draw("appareil-incompatible", "unavailable", AnyView(UnavailableView(reason: .faceTrackingUnsupported).environment(coordinator())))
        let cameraNavigator = MockNavigator()
        let camera = AppContainer.preview(cameraStatus: .denied).makeCameraAccessViewModel(navigator: cameraNavigator)
        try await draw("acces-camera-refuse", "camera access, denied", AnyView(CameraAccessView(viewModel: camera).environment(coordinator())))

        let readiness = SetupRig()
        readiness.look(seconds: 0.3)
        try await draw("calibration-etat-initial", String(describing: readiness.model.phase), AnyView(GazeSetupView(viewModel: readiness.model)))
        let fixation = SetupRig()
        fixation.look(seconds: 0.3)
        fixation.lookUntilCalibrating()
        fixation.look(seconds: 0.4)
        try await draw("calibration-point", String(describing: fixation.model.phase), AnyView(GazeSetupView(viewModel: fixation.model)))
        let verdict = SetupRig()
        verdict.look(seconds: 0.3)
        verdict.lookUntilVerdict()
        try await draw("calibration-verdict", String(describing: verdict.model.phase), AnyView(GazeSetupView(viewModel: verdict.model)))

        for id in ["1-1", "3-2", "7-1", "10-7", "12-1"] {
            let rig = GameRig(level: try #require(Campaign.level(id: id)))
            try await draw("jeu-intro-\(id)", note(rig.model.phase), AnyView(GameView(viewModel: rig.model)))
        }
        let visible = GameRig(level: try #require(Campaign.level(id: "3-2")))
        visible.play(frames: 90)
        try await draw("jeu-partie-visible-3-2", note(visible.model.phase), AnyView(GameView(viewModel: visible.model)))
        let paused = GameRig(level: try #require(Campaign.level(id: "3-2")))
        paused.play(frames: 90)
        paused.model.pause()
        try await draw("jeu-pause-3-2", note(paused.model.phase), AnyView(GameView(viewModel: paused.model)))
        for chapter in [1, 7] {
            let rig = GameRig(level: restingLevel(chapter: chapter))
            rig.navigator.recordToReturn = LevelRecord(completions: 1, bestTime: 30, fewestIntrusions: 5, eclats: [.atteint])
            rig.play(frames: 50)
            try await draw("jeu-resultat-chapitre-\(chapter)", note(rig.model.phase), AnyView(GameView(viewModel: rig.model)))
        }
        let failed = GameRig(level: try #require(Campaign.level(id: "1-1")), unavailable: .faceTrackingUnsupported)
        try await draw("jeu-echec-suivi", note(failed.model.phase), AnyView(GameView(viewModel: failed.model)))
    }

    @Test("representative screens render off screen at phone size (images written only when IRIS_CAPTURE_DIR is set)")
    func screens() async throws {
        let sheet = CaptureSheet()
        try await drawScreens { name, note, view in try sheet.render(name, note: note, view) }
        #expect(sheet.count == 22)
        try sheet.writeManifest("manifest-screens.txt")
    }

    @Test("the same screens hosted in a window, as the app draws them: scroll views, switches, safe areas (only when IRIS_CAPTURE_DIR is set)",
          .enabled(if: captureDirectory != nil))
    func screensInWindow() async throws {
        let sheet = CaptureSheet()
        try await drawScreens { name, note, view in try await sheet.host("fenetre-\(name)", note: note, view) }
        #expect(sheet.count == 22)
        try sheet.writeManifest("manifest-window.txt")
    }

    @Test("the game's state overlays as the app draws them: interruption, face lost, resuming, suspension (only when IRIS_CAPTURE_DIR is set)",
          .enabled(if: captureDirectory != nil))
    func gameStateOverlays() async throws {
        let sheet = CaptureSheet()
        let level = try #require(Campaign.level(id: "3-2"))

        let interrupted = GameRig(level: level)
        interrupted.play(frames: 60)
        interrupted.gaze.simulate(state: .interrupted)
        try await sheet.host("fenetre-jeu-interrompu", note: note(interrupted.model.phase), AnyView(GameView(viewModel: interrupted.model)))

        let faceLost = GameRig(level: level)
        faceLost.play(frames: 60)
        faceLost.gaze.simulate(state: .tracking(faceVisible: false))
        faceLost.tick(frames: 40)
        try await sheet.host("fenetre-jeu-visage-perdu", note: note(faceLost.model.phase), AnyView(GameView(viewModel: faceLost.model)))

        let resuming = GameRig(level: level)
        resuming.play(frames: 60)
        resuming.gaze.simulate(state: .interrupted)
        resuming.gaze.simulate(state: .tracking(faceVisible: true))
        try await sheet.host("fenetre-jeu-reprise", note: note(resuming.model.phase), AnyView(GameView(viewModel: resuming.model)))

        let suspended = GameRig(level: level)
        suspended.play(frames: 60)
        suspended.model.suspend()
        try await sheet.host("fenetre-jeu-suspendu", note: note(suspended.model.phase), AnyView(GameView(viewModel: suspended.model)))

        #expect(sheet.count == 4)
        try sheet.writeManifest("manifest-overlays.txt")
    }

    @Test("the navigation shell as the app draws it: the system's tab bar over the three destinations (only when IRIS_CAPTURE_DIR is set)",
          .enabled(if: captureDirectory != nil))
    func shell() async throws {
        let sheet = CaptureSheet()
        for destination in AppDestination.allCases {
            let coordinator = coordinator(seeded: .through("7-4"))
            coordinator.show(destination)
            try await sheet.host("coquille-\(destination.rawValue)", note: "shell \(destination.rawValue)",
                                 AnyView(RootView(coordinator: coordinator)))
        }
        #expect(sheet.count == 3)
        try sheet.writeManifest("manifest-shell.txt")
    }

    @Test("every level of the campaign a moment after it starts (only when IRIS_CAPTURE_DIR is set)",
          .enabled(if: captureDirectory != nil))
    func everyLevel() throws {
        let sheet = CaptureSheet()
        for level in Campaign.levels {
            let rig = GameRig(level: level)
            rig.play(frames: 90)
            let name = String(format: "niveau-%02d-%d", level.chapter, level.index)
            try sheet.render(name, note: note(rig.model.phase), scale: 2, AnyView(GameView(viewModel: rig.model)))
        }
        #expect(sheet.count == 82)
        try sheet.writeManifest("manifest-levels.txt")
    }
}

/// Draws views as images and records what each image shows.
@MainActor
private final class CaptureSheet {
    private var lines: [String] = []
    private(set) var count = 0

    /// Off screen: no onAppear, no task, no animation; scroll views and system switches are not drawn this way.
    func render(_ name: String, note: String, scale: CGFloat = 3, _ view: AnyView) throws {
        let size = VisualCaptureTests.phone
        let content = view
            .frame(width: size.width, height: name.hasPrefix("cartes") ? nil : size.height)
            .environment(\.colorScheme, .dark)
        let renderer = ImageRenderer(content: content)
        renderer.proposedSize = ProposedViewSize(width: size.width, height: name.hasPrefix("cartes") ? nil : size.height)
        renderer.scale = scale
        let image = try #require(renderer.uiImage, "\(name) renders")
        #expect(abs(image.size.width - size.width) < 0.5, "\(name) is \(image.size.width) pt wide")
        try keep(image, name: name, note: note, scale: scale)
    }

    /// In a window of the test host's scene, with animations removed: layout, tasks and reveals settle, then the
    /// window's hierarchy is drawn (without the status bar, which belongs to the system).
    func host(_ name: String, note: String, _ view: AnyView) async throws {
        let scene = try #require(UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first, "a window scene")
        let window = UIWindow(windowScene: scene)
        window.frame = CGRect(origin: .zero, size: VisualCaptureTests.phone)
        window.overrideUserInterfaceStyle = .dark
        window.rootViewController = UIHostingController(rootView: view.transaction { $0.animation = nil })
        window.isHidden = false
        try await Task.sleep(for: .milliseconds(1_500))
        let format = UIGraphicsImageRendererFormat()
        format.scale = 3
        format.opaque = true
        let image = UIGraphicsImageRenderer(bounds: window.bounds, format: format).image { _ in
            _ = window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        }
        window.isHidden = true
        window.rootViewController = nil
        try keep(image, name: name, note: note, scale: 3)
    }

    private func keep(_ image: UIImage, name: String, note: String, scale: CGFloat) throws {
        count += 1
        guard let captureDirectory else { return }
        let data = try #require(image.pngData(), "\(name) encodes")
        try data.write(to: URL(fileURLWithPath: captureDirectory).appendingPathComponent("\(name).png"))
        lines.append("\(name)\t\(Int(image.size.width * scale))x\(Int(image.size.height * scale))\t\(note.prefix(140))")
    }

    func writeManifest(_ file: String) throws {
        guard let captureDirectory else { return }
        try (lines.joined(separator: "\n") + "\n")
            .write(to: URL(fileURLWithPath: captureDirectory).appendingPathComponent(file), atomically: true, encoding: .utf8)
    }
}

/// A campaign level on a manual clock with a simulated gaze resting far from every lueur.
@MainActor
private final class GameRig {
    let gaze: SimulatedGazeTrackingService
    let clock = ManualGameClock()
    let navigator = MockNavigator()
    let model: GameViewModel
    private let farGaze = Vector2(x: 40, y: 800)

    init(level: LevelDefinition, unavailable: GazeUnavailabilityReason? = nil) {
        gaze = SimulatedGazeTrackingService(startsUnavailable: unavailable)
        let settings = GameSettingsStore(defaults: UserDefaults(suiteName: "iris.tests.capture.\(UUID().uuidString)") ?? .standard)
        model = GameViewModel(level: level, gaze: gaze, audio: MockAudioService(), haptics: MockHapticFeedbackService(), clock: clock,
                              settings: settings, calibrationStore: InMemoryCalibrationStore(), orientation: FixedOrientationProvider(),
                              isPad: false, autoplay: false, navigator: navigator)
        model.prepare(width: VisualCaptureTests.phone.width, height: VisualCaptureTests.phone.height, displayScale: 3)
    }

    func play(frames: Int) {
        gaze.inject(point: farGaze, timestamp: 0)
        model.primaryAction()
        for frame in 1...frames {
            gaze.inject(point: farGaze, timestamp: Double(frame) / 60)
            clock.tick(1.0 / 60.0)
        }
    }

    /// Advances the clock alone, without feeding the gaze: what the game sees when the face leaves.
    func tick(frames: Int) {
        for _ in 1...frames {
            clock.tick(1.0 / 60.0)
        }
    }
}

/// The gaze setup with a steady user who looks at the centre, then at every target.
@MainActor
private final class SetupRig {
    let gaze = SimulatedGazeTrackingService()
    let navigator = MockNavigator()
    let model: GazeSetupViewModel
    private let viewport = PlayfieldBounds(width: VisualCaptureTests.phone.width, height: VisualCaptureTests.phone.height)
    private var time = 0.0

    init() {
        let settings = GameSettingsStore(defaults: UserDefaults(suiteName: "iris.tests.capture.setup.\(UUID().uuidString)") ?? .standard)
        model = GazeSetupViewModel(intent: .firstRun, gaze: gaze, calibrationStore: InMemoryCalibrationStore(),
                                   capabilities: StaticDeviceCapabilities(supportsFaceTracking: true),
                                   cameraAuthorization: StubCameraAuthorizationService(status: .authorized),
                                   orientation: FixedOrientationProvider(), settings: settings, isPad: false, navigator: navigator)
        model.prepare(width: viewport.width, height: viewport.height, displayScale: 3)
    }

    func look(seconds: Double) {
        for _ in 0..<Int(seconds * 60) {
            let target: SIMD2<Double>
            switch model.phase {
            case let .calibrating(display), let .validating(display): target = display.target
            default: target = SIMD2(0.5, 0.5)
            }
            let point = NormalizedCoordinates.points(target, in: viewport)
            gaze.inject(point: Vector2(x: point.x + sin(time * 50) * 1.5, y: point.y + cos(time * 40) * 1.5), timestamp: time)
            time += 1.0 / 60
        }
    }

    func lookUntilCalibrating() {
        for _ in 0..<20 {
            if case .calibrating = model.phase { return }
            look(seconds: 0.25)
        }
    }

    func lookUntilVerdict() {
        for _ in 0..<160 {
            switch model.phase {
            case .ready, .insufficient, .failed: return
            default: look(seconds: 0.25)
            }
        }
    }
}
