// DSGlassAdoptionTests.swift
// Layer: Tests
// Purpose: The production interface really stands on Apple's glass: each migrated surface asks the design system for
// it, no hand-made translucent surface is left in the chrome, the destinations are the system's, and the plain
// fallbacks stay legible where the system draws no glass

import Foundation
import SwiftUI
import Testing
@testable import Iris

@Suite("Liquid Glass adoption")
@MainActor
struct DSGlassAdoptionTests {
    /// Project root, derived from this file's compile-time path (Tests/IrisTests/DesignSystem/...).
    private static var projectRoot: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
    }

    private func source(_ path: String) throws -> String {
        try String(contentsOf: Self.projectRoot.appendingPathComponent(path), encoding: .utf8)
    }

    /// Every source of the running app, glass foundation included.
    private func productionSources() throws -> [(path: String, text: String)] {
        var sources: [(path: String, text: String)] = []
        for base in ["App", "DesignSystem", "Features", "Navigation"] {
            let files = FileManager.default.enumerator(atPath: Self.projectRoot.appendingPathComponent(base).path)?.allObjects as? [String] ?? []
            for relative in files.sorted() where relative.hasSuffix(".swift") {
                let path = "\(base)/\(relative)"
                sources.append((path, try source(path)))
            }
        }
        return sources
    }

    @Test("A: every surface the audit classified as migrated asks the design system for its glass")
    func migratedSurfaces() throws {
        let expected: [String: [String]] = [
            "DesignSystem/Components/DSButton.swift": ["dsGlassButton(variant.glassRole"],
            "DesignSystem/Components/DSScreen.swift": ["dsSoftScrollEdges()"],
            "DesignSystem/Glass/DSGlassPanel.swift": ["dsGlass(.regularPanel"],
            "Features/Game/Views/GameHUDView.swift": [".dsGlass(.clearControl)", ".dsGlass(.chrome, in: .capsule)"],
            "Features/Game/Views/GameOverlayView.swift": ["DSGlassPanel {"],
            "Features/Game/Views/LevelIntroCard.swift": [".dsGlass(.regularPanel)"],
            "Features/GazeSetup/Views/FixationTargetView.swift": [".dsGlass(.clearControl)"],
            "Features/GazeSetup/Views/GazeReadinessView.swift": ["DSGlassPanel {"],
            "Features/GazeSetup/Views/GazeVerdictView.swift": ["DSGlassPanel {"],
            "Navigation/RootView.swift": ["TabView(selection:", "dsTabBarMinimizesOnScroll()"],
        ]
        for (path, needles) in expected.sorted(by: { $0.key < $1.key }) {
            let text = try source(path)
            for needle in needles {
                #expect(text.contains(needle), "\(path) no longer asks for \(needle)")
            }
        }
    }

    @Test("B: no hand-made translucent surface is left in the production chrome")
    func noImitations() throws {
        let imitations = ["DSCard(style: .glass)", ".background(DSColor.Identity.surface.opacity(",
                          ".background(DSColor.Navigation.veil.opacity(", ".ultraThinMaterial", ".regularMaterial",
                          ".thinMaterial", ".thickMaterial", ".blur(radius:"]
        for (path, text) in try productionSources() {
            for imitation in imitations {
                #expect(!text.contains(imitation), "\(path) imitates a material with \(imitation)")
            }
        }
    }

    @Test("C: the legacy opaque card is gone; every interface panel stands on the glass of DSGlassPanel")
    func noLegacyCard() throws {
        let legacy = Self.projectRoot.appendingPathComponent("DesignSystem/Components/DSCard.swift")
        #expect(!FileManager.default.fileExists(atPath: legacy.path), "the legacy card component is back")
        for (path, text) in try productionSources() {
            #expect(!text.contains("DSCard"), "\(path) still references the legacy card")
        }
        #expect(try source("DesignSystem/Glass/DSGlassPanel.swift").contains("dsGlass(.regularPanel"))
    }

    @Test("D: the main action takes the system's prominent glass, secondary actions its plain glass, text actions none")
    func buttonRoles() {
        #expect(DSButton.Variant.primary.glassRole == .prominent)
        #expect(DSButton.Variant.secondary.glassRole == .standard)
        #expect(DSButton.Variant.ghost.glassRole == .plain)
    }

    @Test("E: the three destinations of the tab bar stand for three routes; every other route stays immersive")
    func destinations() {
        #expect(AppDestination.allCases.map(\.route) == [.home, .chapters, .carnet])
        #expect(AppDestination(route: .home) == .seuil)
        #expect(AppDestination(route: .chapters) == .chapitres)
        #expect(AppDestination(route: .carnet) == .carnet)
        for immersive in [AppRoute.game, .cameraAccess, .gazeSetup(.firstRun), .unavailable(.faceTrackingUnsupported)] {
            #expect(AppDestination(route: immersive) == nil, "\(immersive) must show no navigation chrome")
        }
    }

    @Test("F: the coordinator changes destination without inventing a route")
    func coordinatorShowsDestinations() {
        let sut = AppContainer.preview().makeAppCoordinator()
        sut.show(.chapitres)
        #expect(sut.route == .chapters)
        sut.show(.carnet)
        #expect(sut.route == .carnet)
        sut.show(.seuil)
        #expect(sut.route == .home)
    }

    @Test("G: the destinations no longer carry hand-made back buttons or a settings button of their own")
    func noHandMadeNavigation() throws {
        for path in ["Features/Chapters/ChaptersView.swift", "Features/Carnet/CarnetView.swift", "Features/Home/HomeView.swift"] {
            let text = try source(path)
            #expect(!text.contains("chevron.left"), "\(path) draws its own back button")
            #expect(!text.contains("showSettings()"), "\(path) opens the settings itself")
        }
        #expect(try source("Features/Chapters/ChaptersView.swift").contains("ChapterCard("))
    }

    @Test("H: where the system draws no glass, the roles behind the migrated surfaces stay opaque and legible")
    func fallbacksStayLegible() {
        #expect(DSGlassRendering.resolve(nativeGlassAvailable: false, reduceTransparency: false) == .translucent)
        #expect(DSGlassRendering.resolve(nativeGlassAvailable: true, reduceTransparency: true) == .opaque)
        // The main action paints the surface of its role wherever the system's button style is unavailable.
        #expect(DSGlassRole.prominentAction.fill(.translucent) == DSColor.Navigation.primary)
        #expect(DSGlassRole.prominentAction.fill(.opaque) == DSColor.Navigation.primary)
        #expect(DSGlassRole.prominentAction.foreground(.translucent) == DSColor.Navigation.onPrimary)
        for role in [DSGlassRole.clearControl, .regularPanel, .chrome] {
            #expect(role.foreground(.opaque) == DSColor.Identity.textPrimary, "\(role)")
        }
    }
}
