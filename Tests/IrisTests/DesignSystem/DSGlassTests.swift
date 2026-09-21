// DSGlassTests.swift
// Layer: Tests
// Purpose: The Liquid Glass roles: native glass where the system has it, the plain fallback elsewhere, opaque under
// Reduce Transparency, distinct roles, the validated clear control unchanged, no chapter colour, no game, gaze or
// physics dependency, gallery candidates kept out of the app, every native call confined to DesignSystem/Glass, and
// navigation built from the system's own tab bar and toolbar

import CryptoKit
import Foundation
import SwiftUI
import Testing
@testable import Iris

@Suite("Liquid Glass design roles")
@MainActor
struct DSGlassTests {
    /// Navigation sources, re-frozen by the gaze assistance release: the coordinator answers whether the levels
    /// that teach the gaze marker are behind the player and holds the first level behind its introduction, there is
    /// a fourth sheet, and the root view presents it. They change again only with a deliberate navigation decision
    /// and this table.
    static let navigationSources: [String: String] = [
        "Navigation/AppCoordinator.swift": "15550e59be78db1139228fd976b375cc3ff1a61e8694a6ff2aa7ed8bb3aab412",
        "Navigation/AppDestination.swift": "57ee608cdd0b66bd907ac0f7d9368004510b28e40e77e2009484c391f1d5828f",
        "Navigation/AppRoute.swift": "8d05c60e7f49851d4c37fbc045e9c7c6aa6361b15681a5fb13ddf930d77fb73e",
        "Navigation/AppSheet.swift": "e33ba41e0c2b61f0340cac7085f6b4a579a2ec62866255df60a4235afbe1e0ae",
        "Navigation/HomeSummary.swift": "ad8b42102791d939250b8663085566d85336845280b74d5257efc92eb9dfb2e9",
        "Navigation/RootView.swift": "0ca62455edf207cd80f2adb99e5293ade77ba720970205d197cdbb6645a61546",
    ]

    /// Project root, derived from this file's compile-time path (Tests/IrisTests/DesignSystem/...).
    private static var projectRoot: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
    }

    private func glassSources() throws -> [(path: String, text: String)] {
        let directory = Self.projectRoot.appendingPathComponent("DesignSystem/Glass")
        let names = try FileManager.default.contentsOfDirectory(atPath: directory.path).filter { $0.hasSuffix(".swift") }.sorted()
        return try names.map { ("DesignSystem/Glass/\($0)", try String(contentsOf: directory.appendingPathComponent($0), encoding: .utf8)) }
    }

    private func appSources(includingGlass: Bool = false) throws -> [(path: String, text: String)] {
        var sources: [(path: String, text: String)] = []
        for base in ["App", "AR", "Audio", "Commerce", "Domain", "GameEngine", "Haptics", "Navigation", "Features", "DesignSystem"] {
            let files = FileManager.default.enumerator(atPath: Self.projectRoot.appendingPathComponent(base).path)?.allObjects as? [String] ?? []
            for relative in files.sorted() where relative.hasSuffix(".swift") {
                let path = "\(base)/\(relative)"
                guard includingGlass || !path.hasPrefix("DesignSystem/Glass/") else { continue }
                sources.append((path, try String(contentsOf: Self.projectRoot.appendingPathComponent(path), encoding: .utf8)))
            }
        }
        return sources
    }

    private func resolved(_ color: Color) -> Color.Resolved {
        var environment = EnvironmentValues()
        environment.colorScheme = .dark
        return color.resolve(in: environment)
    }

    /// WCAG contrast ratio between two opaque colours.
    private func contrastRatio(_ first: Color, _ second: Color) -> Double {
        func luminance(_ color: Color) -> Double {
            let value = resolved(color)
            return 0.2126 * Double(value.linearRed) + 0.7152 * Double(value.linearGreen) + 0.0722 * Double(value.linearBlue)
        }
        let (lighter, darker) = (max(luminance(first), luminance(second)), min(luminance(first), luminance(second)))
        return (lighter + 0.05) / (darker + 0.05)
    }

    @Test("A: on iOS 26 every role draws the system's Liquid Glass with its own variant and touch response, and no material of its own is tinted")
    func nativeGlass() throws {
        #expect(DSGlassRendering.resolve(nativeGlassAvailable: true, reduceTransparency: false) == .native)
        if #available(iOS 26.0, *) {
            #expect(DSGlassRendering.isNativeGlassAvailable)
            #expect(DSGlassRendering.resolve(reduceTransparency: false) == .native)
            #expect(DSGlassRole.clearControl.recipe.glass(interactive: true) == Glass.clear.tint(nil).interactive(true))
            #expect(DSGlassRole.regularPanel.recipe.glass(interactive: true) == Glass.regular.tint(nil).interactive(false))
            #expect(DSGlassRole.chrome.recipe.glass(interactive: true) == Glass.regular.tint(nil).interactive(false))
            #expect(DSGlassRole.prominentAction.recipe.glass(interactive: true) == Glass.regular.tint(nil).interactive(true))
            #expect(DSGlassRole.clearControl.recipe.glass(interactive: false) == Glass.clear.tint(nil).interactive(false))
        } else {
            #expect(!DSGlassRendering.isNativeGlassAvailable)
        }
        let sources = try glassSources().map(\.text).joined()
        #expect(sources.contains(".glassEffect(") && sources.contains("GlassEffectContainer(") && sources.contains(".glassEffectID("))
    }

    @Test("B: before iOS 26 the roles fall back to a light plain surface of the interface colours, decided in one place")
    func fallback() throws {
        #expect(DSGlassRendering.resolve(nativeGlassAvailable: false, reduceTransparency: false) == .translucent)
        for role in DSGlassRole.allCases where role != .prominentAction {
            let alpha = Double(resolved(role.fill(.translucent)).opacity)
            #expect(alpha > 0.5 && alpha < 1, "\(role): translucent fill \(alpha)")
        }
        #expect(resolved(DSGlassRole.prominentAction.fill(.translucent)).opacity == 1)
        #expect(DSGlassRole.allCases.allSatisfy { resolved($0.fill(.native)).opacity == 0 })
        for (path, text) in try appSources() {
            #expect(!text.contains("#available(iOS 26"), "\(path) checks for iOS 26 itself")
        }
    }

    @Test("C: Reduce Transparency puts every role on an opaque, legible surface on every version; Increase Contrast strengthens the edge")
    func reduceTransparency() {
        #expect(DSGlassRendering.resolve(nativeGlassAvailable: true, reduceTransparency: true) == .opaque)
        #expect(DSGlassRendering.resolve(nativeGlassAvailable: false, reduceTransparency: true) == .opaque)
        for role in DSGlassRole.allCases {
            #expect(resolved(role.fill(.opaque)).opacity == 1, "\(role)")
            let ratio = contrastRatio(role.foreground(.opaque), role.fill(.opaque))
            #expect(ratio >= 4.5, "\(role): text contrast \(ratio)")
        }
        for role in DSGlassRole.allCases where role != .prominentAction {
            #expect(role.hairline(.increased) != role.hairline(.standard), "\(role)")
        }
        #expect(DSGlassRendering.transition(reduceMotion: false) == .morph)
        #expect(DSGlassRendering.transition(reduceMotion: true) == .fade)
    }

    @Test("D: the four roles stay distinct: clear glass only for controls, no tinted material, their own shapes")
    func distinctRoles() {
        struct Signature: Hashable {
            let variant: DSGlassRecipe.Variant
            let interactive: Bool
            let tinted: Bool
            let shape: DSGlassShape
            let translucent: Color
        }
        #expect(DSGlassRole.allCases == [.clearControl, .regularPanel, .chrome, .prominentAction])
        #expect(DSGlassRole.allCases.filter { $0.recipe.variant == .clear } == [.clearControl])
        #expect(DSGlassRole.allCases.allSatisfy { $0.recipe.tint == nil }, "Iris tints the system's button style, never a material")
        #expect(DSGlassRole.allCases.filter { $0.recipe.isInteractive } == [.clearControl, .prominentAction])
        #expect(DSGlassRole.clearControl.defaultShape == .circle)
        #expect(DSGlassRole.regularPanel.defaultShape == .rounded(DSRadius.l))
        let signatures = Set(DSGlassRole.allCases.map {
            Signature(variant: $0.recipe.variant, interactive: $0.recipe.isInteractive, tinted: $0.recipe.tint != nil,
                      shape: $0.defaultShape, translucent: $0.fill(.translucent))
        })
        #expect(signatures.count == 4)
        #expect(resolved(DSGlassRole.regularPanel.fill(.translucent)).opacity > resolved(DSGlassRole.clearControl.fill(.translucent)).opacity)
    }

    @Test("E: glass never uses a chapter colour or palette; it reads Identity and Navigation tokens only")
    func noChapterColour() throws {
        for (path, text) in try glassSources() {
            #expect(!text.contains("DSColor.Chapter") && !text.contains("DSThemePalette") && !text.contains("ChapterTheme") && !text.contains(".palette"), "\(path)")
            for match in text.matches(of: #/DSColor\.(\w+)/#) {
                #expect(["Identity", "Navigation"].contains(String(match.output.1)), "\(path) reads DSColor.\(match.output.1)")
            }
            #expect(!text.contains("Color(\"") && !text.contains("Color(red"), "\(path) names a raw colour")
        }
    }

    @Test("F: glass depends on SwiftUI alone: no game engine, game state, campaign, timer or display link")
    func noGameDependency() throws {
        let forbidden = ["GameSession", "GameViewModel", "GameScene", "GameCanvas", "GameEngine", "GameClock", "Campaign", "LevelDefinition",
                         "Timer", "TimelineView", "DisplayLink", "Canvas", "blur("]
        for (path, text) in try glassSources() {
            let imports = Set(text.matches(of: #/^import (\w+)/#.anchorsMatchLineEndings()).map { String($0.output.1) })
            #expect(imports == ["SwiftUI"], "\(path) imports \(imports)")
            for word in forbidden {
                #expect(!text.contains(word), "\(path) mentions \(word)")
            }
        }
    }

    @Test("G: glass references no AR, gaze, calibration, physics or audio API")
    func noGazeDependency() throws {
        let forbidden = ["ARKit", "ARSession", "ARFace", "Gaze", "Calibration", "TrueDepth", "AxisMapping", "Physics", "AVFoundation", "Haptic"]
        for (path, text) in try glassSources() {
            for word in forbidden {
                #expect(!text.contains(word), "\(path) mentions \(word)")
            }
        }
    }

    @Test("H: production screens reach Apple's glass only through the design system: no native call and no version check outside DesignSystem/Glass")
    func glassStaysInTheDesignSystem() throws {
        let nativeCalls = ["glassEffect(", "GlassEffectContainer(", "glassEffectID(", "buttonStyle(.glass", ".glassProminent",
                           "tabBarMinimizeBehavior", "scrollEdgeEffectStyle"]
        // Every screen reaches the material through the design system; none of them names a system style itself.
        let sources = try appSources()
        for (path, text) in sources {
            for call in nativeCalls {
                #expect(!text.contains(call), "\(path) calls \(call) itself")
            }
        }
        #expect(sources.count > 150)
        let glass = try glassSources().map(\.text).joined()
        #expect(glass.contains(".glassEffect(") && glass.contains("GlassEffectContainer(") && glass.contains(".glassEffectID("))
        #expect(glass.contains("buttonStyle(.glass)"))
        // V2: the prominent style filled the material with a full amber tint and read as an opaque capsule; the main
        // action now takes the same glass as the others and is told by the colour of its label.
        #expect(!glass.contains("glassProminent"), "a filled prominent style is back")
        #expect(glass.contains("tabBarMinimizeBehavior(.onScrollDown)") && glass.contains("scrollEdgeEffectStyle(.soft"))
    }

    @Test("I: the validated clear control keeps its exact glass, shape and surfaces; the other roles hold Apple's untinted materials")
    func clearControlUnchanged() {
        let clear = DSGlassRole.clearControl
        #expect(clear.recipe == DSGlassRecipe(.clear, interactive: true))
        #expect(clear.recipe.tint == nil && clear.recipe.foreground == nil && clear.recipe.edge == nil)
        #expect(clear.defaultShape == .circle)
        #expect(clear.fill(.translucent) == DSColor.Identity.surface.opacity(0.6))
        #expect(clear.fill(.opaque) == DSColor.Identity.surfaceElevated)
        #expect(clear.foreground(.native) == DSColor.Identity.textPrimary)
        #expect(clear.hairline(.standard) == DSColor.Identity.line)
        if #available(iOS 26.0, *) {
            #expect(clear.recipe.glass(interactive: true) == Glass.clear.tint(nil).interactive(true))
        }
        #expect(DSGlassRole.regularPanel.recipe == DSGlassRecipe(.regular))
        #expect(DSGlassRole.chrome.recipe == DSGlassRecipe(.regular))
        #expect(DSGlassRole.prominentAction.recipe == DSGlassRecipe(.regular, interactive: true))
    }

    @Test("J: the gallery's candidate recipes, demonstration grounds and experimental colours never reach the app")
    func galleryStaysOutOfTheApp() throws {
        let galleryNames = ["panelAiry", "panelBalanced", "chromeClear", "chromeBalanced", "prominentNeutral", "prominentSpectral",
                            "SelectionRecipes", "GalleryDemoGround", "DSGlassSelectionGallery", "DSGlassGallery"]
        let sources = try appSources(includingGlass: true)
        for (path, text) in sources {
            for name in galleryNames {
                #expect(!text.contains(name), "\(path) mentions \(name)")
            }
        }
        #expect(sources.contains { $0.path == "DesignSystem/Glass/DSGlassRecipe.swift" })
    }

    @Test("K: navigation is the system's own: one tab view of three destinations in Navigation, the system's chrome in the three sheets, nothing hand-made elsewhere")
    func navigationIsNative() throws {
        // The three sheets take the system's navigation chrome for their title and their close action, exactly as the
        // settings sheet does; no other screen builds navigation of its own.
        let sheetHosts = ["Features/Settings/SettingsView.swift", "Features/Paywall/PaywallView.swift",
                          "Features/HowToPlay/HowToPlayView.swift"]
        let allowed = ["Navigation/"] + sheetHosts
        for (path, text) in try appSources() where !allowed.contains(where: { path.hasPrefix($0) }) {
            for word in ["TabView", "NavigationStack", ".toolbar", ".tabItem"] {
                #expect(!text.contains(word), "\(path) builds navigation chrome itself")
            }
        }
        let root = try String(contentsOf: Self.projectRoot.appendingPathComponent("Navigation/RootView.swift"), encoding: .utf8)
        #expect(root.contains("TabView(selection:") && root.contains(".tabItem") && root.contains("NavigationStack"))
        #expect(root.contains("dsTabBarMinimizesOnScroll()"), "the tab bar keeps the system's minimise behaviour")
        for path in sheetHosts {
            let text = try String(contentsOf: Self.projectRoot.appendingPathComponent(path), encoding: .utf8)
            #expect(text.contains("NavigationStack") && text.contains(".toolbar"), "\(path): the title and close action must be the system's")
            #expect(text.contains("navigationBarTitleDisplayMode(.inline)"), "\(path)")
            #expect(!text.contains("TabView"), "\(path) builds a tab bar of its own")
        }
        // The onboarding is a full-screen explanation, not a navigation stack and not a tab view.
        let onboarding = try String(contentsOf: Self.projectRoot.appendingPathComponent("Features/Onboarding/OnboardingView.swift"), encoding: .utf8)
        #expect(!onboarding.contains("TabView") && !onboarding.contains("NavigationStack"))
        #expect(root.contains("fullScreenCover(isPresented: onboardingBinding)"))
        #expect(AppSheet.allCases == [.settings, .paywall, .howToPlay, .gazeIntroduction])
        #expect(AppDestination.allCases == [.seuil, .chapitres, .carnet])
        for (path, expected) in Self.navigationSources.sorted(by: { $0.key < $1.key }) {
            let data = try Data(contentsOf: Self.projectRoot.appendingPathComponent(path))
            let digest: String = SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
            #expect(digest == expected, "\(path) changed")
        }
        #expect(Self.navigationSources.count == 6)
    }
}
