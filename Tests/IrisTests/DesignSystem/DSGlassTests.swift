// DSGlassTests.swift
// Layer: Tests
// Purpose: The Liquid Glass roles: native glass where the system has it, the plain fallback elsewhere, opaque under
// Reduce Transparency, distinct roles, no chapter colour, no game, gaze or physics dependency, and no screen using
// glass before its migration phase

import Foundation
import SwiftUI
import Testing
@testable import Iris

@Suite("Liquid Glass design roles")
@MainActor
struct DSGlassTests {
    /// Project root, derived from this file's compile-time path (Tests/IrisTests/DesignSystem/...).
    private static var projectRoot: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
    }

    private func glassSources() throws -> [(path: String, text: String)] {
        let directory = Self.projectRoot.appendingPathComponent("DesignSystem/Glass")
        let names = try FileManager.default.contentsOfDirectory(atPath: directory.path).filter { $0.hasSuffix(".swift") }.sorted()
        return try names.map { ("DesignSystem/Glass/\($0)", try String(contentsOf: directory.appendingPathComponent($0), encoding: .utf8)) }
    }

    private func appSourcesOutsideGlass() throws -> [(path: String, text: String)] {
        var sources: [(path: String, text: String)] = []
        for base in ["App", "AR", "Audio", "Domain", "GameEngine", "Haptics", "Navigation", "Features", "DesignSystem"] {
            let files = FileManager.default.enumerator(atPath: Self.projectRoot.appendingPathComponent(base).path)?.allObjects as? [String] ?? []
            for relative in files.sorted() where relative.hasSuffix(".swift") {
                let path = "\(base)/\(relative)"
                guard !path.hasPrefix("DesignSystem/Glass/") else { continue }
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

    @Test("A: on iOS 26 every role draws the system's Liquid Glass with its own variant, tint and touch response")
    func nativeGlass() throws {
        #expect(DSGlassRendering.resolve(nativeGlassAvailable: true, reduceTransparency: false) == .native)
        if #available(iOS 26.0, *) {
            #expect(DSGlassRendering.isNativeGlassAvailable)
            #expect(DSGlassRendering.resolve(reduceTransparency: false) == .native)
            #expect(DSGlassRole.clearControl.glass(interactive: true) == Glass.clear.tint(nil).interactive(true))
            #expect(DSGlassRole.regularPanel.glass(interactive: true) == Glass.regular.tint(nil).interactive(false))
            #expect(DSGlassRole.chrome.glass(interactive: true) == Glass.regular.tint(nil).interactive(false))
            #expect(DSGlassRole.prominentAction.glass(interactive: true)
                    == Glass.regular.tint(DSColor.Navigation.primary.opacity(0.4)).interactive(true))
            #expect(DSGlassRole.clearControl.glass(interactive: false) == Glass.clear.tint(nil).interactive(false))
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
        for (path, text) in try appSourcesOutsideGlass() {
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

    @Test("D: the four roles stay distinct: clear glass only for controls, a tint only for the prominent action, their own shapes")
    func distinctRoles() {
        struct Signature: Hashable {
            let variant: DSGlassRole.Variant
            let interactive: Bool
            let tinted: Bool
            let shape: DSGlassShape
            let translucent: Color
        }
        #expect(DSGlassRole.allCases == [.clearControl, .regularPanel, .chrome, .prominentAction])
        #expect(DSGlassRole.allCases.filter { $0.variant == .clear } == [.clearControl])
        #expect(DSGlassRole.allCases.filter { $0.tint != nil } == [.prominentAction])
        #expect(DSGlassRole.allCases.filter(\.isInteractive) == [.clearControl, .prominentAction])
        #expect(DSGlassRole.clearControl.defaultShape == .circle)
        #expect(DSGlassRole.regularPanel.defaultShape == .rounded(DSRadius.l))
        let signatures = Set(DSGlassRole.allCases.map {
            Signature(variant: $0.variant, interactive: $0.isInteractive, tinted: $0.tint != nil, shape: $0.defaultShape, translucent: $0.fill(.translucent))
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

    @Test("H: no production screen uses glass yet: roles, group, surfaces and native glass calls live only in DesignSystem/Glass")
    func noProductionScreenUsesGlass() throws {
        let calls = ["dsGlass", "DSGlass", "glassEffect", "GlassEffectContainer", "buttonStyle(.glass", ".glassProminent"]
        let sources = try appSourcesOutsideGlass()
        for (path, text) in sources {
            for call in calls {
                #expect(!text.contains(call), "\(path) uses \(call)")
            }
        }
        #expect(sources.count > 150)
    }
}
