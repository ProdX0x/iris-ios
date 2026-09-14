// ColorRoleBoundaryTests.swift
// Layer: Tests
// Purpose: The colour roles stay apart and keep their values: chapters I to XII and the game's states are unchanged,
// the interface families carry the values they replaced, the game world reads chapter tokens only, and no colour set
// is shared between the world and the interface, so recolouring the interface cannot recolour a chapter

import Foundation
import SwiftUI
import Testing
import UIKit
@testable import Iris

@Suite("Colour role boundaries")
@MainActor
struct ColorRoleBoundaryTests {
    /// Project root, derived from this file's compile-time path (Tests/IrisTests/Presentation/...).
    private static var projectRoot: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
    }

    /// Sources of the game world besides Features/Game/Rendering: they read `DSColor.Chapter` and chapter palettes only.
    static let worldSources = [
        "DesignSystem/Components/DSThemeWash.swift",
        "DesignSystem/Tokens/DSThemePalette.swift",
        "Features/Game/Views/GameCanvasView.swift",
        "Features/Game/Views/GameFieldBackground.swift",
        "Features/Game/Views/GameView.swift",
        "Features/Shared/ChapterTheme+Palette.swift",
    ]

    /// 8-bit sRGB of a colour as SwiftUI resolves it in the app's dark appearance, such as "#F2B35A".
    private func hex(_ color: Color) -> String {
        var environment = EnvironmentValues()
        environment.colorScheme = .dark
        let resolved = color.resolve(in: environment)
        let channels = [resolved.red, resolved.green, resolved.blue, resolved.opacity].map { Int((Double($0) * 255).rounded()) }
        return String(format: "#%02X%02X%02X", channels[0], channels[1], channels[2]) + (channels[3] == 255 ? "" : String(format: "@%02X", channels[3]))
    }

    /// Value stored in a colour set of the catalogue; its light and dark entries must agree.
    private func catalogueHex(_ contents: URL) throws -> String {
        struct Contents: Decodable {
            struct Entry: Decodable {
                struct Value: Decodable { let components: [String: String] }
                let color: Value
            }
            let colors: [Entry]
        }
        let decoded = try JSONDecoder().decode(Contents.self, from: Data(contentsOf: contents))
        let values = decoded.colors.map { entry -> String in
            let components = entry.color.components
            func byte(_ key: String) -> Int { Int(components[key]?.dropFirst(2) ?? "", radix: 16) ?? -1 }
            return String(format: "#%02X%02X%02X", byte("red"), byte("green"), byte("blue"))
        }
        #expect(Set(values).count == 1, "\(contents.deletingLastPathComponent().lastPathComponent): entries differ")
        return values.first ?? ""
    }

    @Test("A: chapters I to VI keep the chambre noire exactly: ink field, amber attention, pearl lueurs, no wash")
    func historicalChapters() {
        #expect(Campaign.chapters.prefix(6).allSatisfy { $0.theme == .chambreNoire })
        let palette = ChapterTheme.chambreNoire.palette
        #expect(hex(palette.accent) == "#F2B35A")
        #expect(hex(palette.glow) == "#F7E6C4")
        #expect(palette.wash == nil)
        let world: [(String, Color, String)] = [
            ("ink", DSColor.Chapter.ink, "#07080B"), ("abyss", DSColor.Chapter.abyss, "#121620"),
            ("attention", DSColor.Chapter.attention, "#F2B35A"), ("attentionDeep", DSColor.Chapter.attentionDeep, "#C9812F"),
            ("lueurCore", DSColor.Chapter.lueurCore, "#F4EFE4"), ("lueurGlow", DSColor.Chapter.lueurGlow, "#F7E6C4"),
            ("maree", DSColor.Chapter.maree, "#5E93BF"), ("veil", DSColor.Chapter.veil, "#ECE7DC"),
            ("nacre", DSColor.Chapter.nacre, "#ECE7DC"), ("cendre", DSColor.Chapter.cendre, "#85817A"), ("line", DSColor.Chapter.line, "#262A35"),
            ("rank(1)", DSColor.Chapter.rank(1), "#E9C98A"), ("rank(2)", DSColor.Chapter.rank(2), "#9CC3E6"),
            ("rank(3)", DSColor.Chapter.rank(3), "#DBA3CF"), ("rank(4)", DSColor.Chapter.rank(4), "#E9C98A"),
        ]
        for (name, color, expected) in world {
            #expect(hex(color) == expected, "Chapter.\(name)")
        }
    }

    @Test("B: chapters VII to XII keep their themes, and each palette its accent, glow and wash")
    func expansionChapters() {
        #expect(Campaign.chapters.dropFirst(6).map(\.theme) == [.jumelles, .brume, .echo, .gouffres, .braises, .constellation])
        let expected: [(ChapterTheme, String, String, String)] = [
            (.jumelles, "#F2A6C0", "#FFD6E4", "#1A0B14"), (.brume, "#9FD3E6", "#CFF2FF", "#0A1519"),
            (.echo, "#C9E36B", "#F0FFC2", "#0E140A"), (.gouffres, "#B39CFF", "#E0D4FF", "#100A1C"),
            (.braises, "#FF8C42", "#FFC9A6", "#1A0C07"), (.constellation, "#E8E6F2", "#FFFFFF", "#05060C"),
        ]
        for (theme, accent, glow, wash) in expected {
            let palette = theme.palette
            #expect(hex(palette.accent) == accent, "\(theme) accent")
            #expect(hex(palette.glow) == glow, "\(theme) glow")
            #expect(palette.wash.map { hex($0) } == wash, "\(theme) wash")
        }
    }

    @Test("C: the game's state colours are unchanged: menthe and corail in the world, the same outcomes around it")
    func stateColours() {
        #expect(hex(DSColor.Chapter.success) == "#7FE0C0")
        #expect(hex(DSColor.Chapter.trouble) == "#FF7A5C")
        #expect(hex(DSColor.State.success) == "#7FE0C0")
        #expect(hex(DSColor.State.danger) == "#FF7A5C")
        #expect(hex(DSColor.State.warning) == "#F2B35A")
        #expect(hex(DSColor.State.info) == "#9CC3E6")
    }

    @Test("D: every interface token carries exactly the value of the flat token it replaced; the system assets are unchanged")
    func interfaceValues() {
        let replaced: [(String, Color, String)] = [
            ("backgroundPrimary → Identity.ground", DSColor.Identity.ground, "#07080B"),
            ("fieldAbyss → Identity.groundAbyss", DSColor.Identity.groundAbyss, "#121620"),
            ("backgroundSurface → Identity.surface", DSColor.Identity.surface, "#0D0F14"),
            ("backgroundElevated → Identity.surfaceElevated", DSColor.Identity.surfaceElevated, "#161922"),
            ("lineSubtle → Identity.line", DSColor.Identity.line, "#262A35"),
            ("textPrimary → Identity.textPrimary", DSColor.Identity.textPrimary, "#ECE7DC"),
            ("textSecondary → Identity.textSecondary", DSColor.Identity.textSecondary, "#A7A399"),
            ("textTertiary → Identity.textTertiary", DSColor.Identity.textTertiary, "#85817A"),
            ("textWarm → Identity.textWarm", DSColor.Identity.textWarm, "#D9D2C3"),
            ("accent → Identity.accent", DSColor.Identity.accent, "#F2B35A"),
            ("lueurCore → Identity.emblemCore", DSColor.Identity.emblemCore, "#F4EFE4"),
            ("lueurGlow → Identity.emblemGlow", DSColor.Identity.emblemGlow, "#F7E6C4"),
            ("accent → Navigation.primary", DSColor.Navigation.primary, "#F2B35A"),
            ("textOnAccent → Navigation.onPrimary", DSColor.Navigation.onPrimary, "#1A1206"),
            ("backgroundElevated → Navigation.secondary", DSColor.Navigation.secondary, "#161922"),
            ("accent → Navigation.control", DSColor.Navigation.control, "#F2B35A"),
            ("accent → Navigation.selection", DSColor.Navigation.selection, "#F2B35A"),
            ("fieldInk → Navigation.veil", DSColor.Navigation.veil, "#07080B"),
            ("statusSuccess → State.success", DSColor.State.success, "#7FE0C0"),
            ("statusDanger → State.danger", DSColor.State.danger, "#FF7A5C"),
            ("accent → State.warning", DSColor.State.warning, "#F2B35A"),
            ("statusInfo → State.info", DSColor.State.info, "#9CC3E6"),
        ]
        for (name, color, expected) in replaced {
            #expect(hex(color) == expected, "\(name)")
        }
        let dark = UITraitCollection(userInterfaceStyle: .dark)
        for (asset, expected) in [("AccentColor", "#F2B35A"), ("LaunchBackground", "#07080B")] {
            let resolved = UIColor(named: asset)?.resolvedColor(with: dark)
            #expect(resolved.map { hex(Color(uiColor: $0)) } == expected, "\(asset)")
        }
    }

    @Test("E: the game world reads chapter tokens only: no interface colour, no interface background, no colour set by name")
    func worldReadsChapterTokensOnly() throws {
        let root = Self.projectRoot
        let rendering = try FileManager.default.contentsOfDirectory(atPath: root.appendingPathComponent("Features/Game/Rendering").path)
            .filter { $0.hasSuffix(".swift") }
            .map { "Features/Game/Rendering/\($0)" }
        #expect(rendering.count >= 7)
        for path in (rendering + Self.worldSources).sorted() {
            let text = try String(contentsOf: root.appendingPathComponent(path), encoding: .utf8)
            for match in text.matches(of: #/DSColor\.(\w+)/#) {
                #expect(match.output.1 == "Chapter", "\(path) reads DSColor.\(match.output.1)")
            }
            #expect(!text.contains("DSBackground("), "\(path) stands on the interface background")
            #expect(!text.contains("Color(\""), "\(path) names a colour set")
            #expect(!text.contains(".accentColor"), "\(path) reads the system accent")
        }
        let game = try String(contentsOf: root.appendingPathComponent("Features/Game/Views/GameView.swift"), encoding: .utf8)
        #expect(game.contains("GameFieldBackground()") && game.contains(".background(DSColor.Chapter.ink)"))
    }

    @Test("E: the interface around the game never reads a chapter token; it shows a chapter's colour only through its palette")
    func interfaceReadsNoChapterToken() throws {
        let root = Self.projectRoot
        var checked = 0
        for base in ["App", "DesignSystem", "Features", "Navigation"] {
            let files = FileManager.default.enumerator(atPath: root.appendingPathComponent(base).path)?.allObjects as? [String] ?? []
            for relative in files where relative.hasSuffix(".swift") {
                let path = "\(base)/\(relative)"
                guard !path.hasPrefix("Features/Game/Rendering/"), !Self.worldSources.contains(path),
                      path != "DesignSystem/Tokens/DSColor.swift" else { continue }
                let text = try String(contentsOf: root.appendingPathComponent(path), encoding: .utf8)
                #expect(!text.contains("DSColor.Chapter"), "\(path) reads a chapter token")
                #expect(!text.contains("Color(\""), "\(path) names a colour set")
                checked += 1
            }
        }
        #expect(checked > 40)
    }

    @Test("F: each token owns a colour set named after its family and the world shares none with the interface: recolouring every interface set leaves every chapter token as it is")
    func coloursetsAreDisjoint() throws {
        let root = Self.projectRoot
        let source = try String(contentsOf: root.appendingPathComponent("DesignSystem/Tokens/DSColor.swift"), encoding: .utf8)
        var family = ""
        var owners: [String: String] = [:]
        for line in source.split(separator: "\n") {
            if let declaration = line.firstMatch(of: #/^\s+enum (\w+) \{/#) {
                family = String(declaration.output.1)
            }
            for match in line.matches(of: #/Color\("([^"\\]+)(\\\(index\))?"\)/#) {
                let base = String(match.output.1)
                for name in match.output.2 == nil ? [base] : (1...3).map({ "\(base)\($0)" }) {
                    #expect(owners[name] == nil, "\(name) is declared twice")
                    owners[name] = family
                }
            }
        }
        #expect(Set(owners.values) == ["Identity", "Navigation", "State", "Chapter"])
        for (name, owner) in owners {
            #expect(name.hasPrefix("ds.\(owner.lowercased())."), "\(name) is declared in \(owner)")
        }

        let catalogue = root.appendingPathComponent("Resources/Assets.xcassets")
        let sets = try FileManager.default.contentsOfDirectory(atPath: catalogue.path)
            .filter { $0.hasSuffix(".colorset") }
            .map { String($0.dropLast(".colorset".count)) }
        #expect(Set(sets.filter { $0.hasPrefix("ds.") }) == Set(owners.keys), "every ds colour set has exactly one token")
        #expect(Set(sets.filter { !$0.hasPrefix("ds.") }) == ["AccentColor", "LaunchBackground"])

        var values: [String: String] = [:]
        for name in owners.keys {
            let value = try catalogueHex(catalogue.appendingPathComponent("\(name).colorset/Contents.json"))
            #expect(value == hex(Color(name)), "\(name): the catalogue and the app agree")
            values[name] = value
        }
        var recoloured = values
        for (name, owner) in owners where owner != "Chapter" {
            recoloured[name] = "#FF00FF"
        }
        let chapterSets = owners.filter { $0.value == "Chapter" }.map(\.key)
        #expect(chapterSets.count == 34)
        for name in chapterSets {
            #expect(recoloured[name] == values[name], "\(name) would follow an interface recolouring")
        }
    }
}
