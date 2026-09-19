// LocalizationInfrastructureTests.swift
// Layer: Tests
// Purpose: The localisation hinge holds: a stable key resolves, a missing key falls back to the French Iris already
// carries, no screen can ever show a raw key, the game content is not duplicated or drifting, the keys do not collide,
// and no translation has been slipped in. Iris is French, and these tests are what keeps it exactly as French as it was

import Foundation
import Testing
@testable import Iris

@Suite("Localization infrastructure")
struct LocalizationInfrastructureTests {
    /// Project root, derived from this file's compile-time path (Tests/IrisTests/Presentation/...).
    private static var projectRoot: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
    }

    private func catalog(_ name: String) throws -> [String: Any] {
        let url = Self.projectRoot.appendingPathComponent("Resources/\(name).xcstrings")
        let object = try JSONSerialization.jsonObject(with: try Data(contentsOf: url))
        return try #require(object as? [String: Any])
    }

    private func strings(_ name: String) throws -> [String: Any] {
        try #require(try catalog(name)["strings"] as? [String: Any])
    }

    @Test("A: a stable key resolves to the French the catalogue holds")
    func stableKeyResolves() {
        // The key carries the identity; the French passed in is only the fallback, and the catalogue wins.
        #expect(IrisText.gameplay("level.1-1.title", french: "ce texte ne doit pas sortir") == "premier regard")
        #expect(IrisText.interface("settings.audio.soundEffects", french: "ce texte ne doit pas sortir") == "Effets sonores")
    }

    @Test("B: a key nobody has translated falls back to the French, never to the key")
    func missingKeyFallsBackToFrench() {
        let french = "Regardez la lueur."
        let resolved = IrisText.gameplay("level.0-0.doesNotExist", french: french)
        #expect(resolved == french)
        #expect(!resolved.contains("level.0-0"))
    }

    @Test("C: no screen can show a technical key or an empty line")
    func noKeyAndNoEmptyLineReachesAScreen() {
        for level in Campaign.levels {
            for text in [CampaignText.title(of: level), CampaignText.principle(of: level)] {
                #expect(!text.isEmpty)
                #expect(!text.hasPrefix("level."), "\(level.id) shows its key")
                #expect(!text.hasPrefix("chapter."))
            }
        }
        for chapter in Campaign.chapters {
            #expect(!CampaignText.name(of: chapter).isEmpty)
            #expect(!CampaignText.name(of: chapter).hasPrefix("chapter."))
        }
    }

    @Test("D: the French of every level, chapter, element and mark is exactly the one Domain holds")
    func frenchIsUnchanged() {
        for level in Campaign.levels {
            #expect(CampaignText.title(of: level) == level.title, "\(level.id) title")
            #expect(CampaignText.principle(of: level) == level.principle, "\(level.id) principle")
        }
        for chapter in Campaign.chapters {
            #expect(CampaignText.name(of: chapter) == chapter.name, "chapter \(chapter.number) name")
            #expect(CampaignText.principle(of: chapter) == chapter.principle, "chapter \(chapter.number) principle")
        }
        for element in GameElement.allCases {
            #expect(CampaignText.name(of: element) == element.name, "\(element) name")
            #expect(CampaignText.summary(of: element) == element.summary, "\(element) summary")
        }
        for eclat in Eclat.allCases {
            #expect(CampaignText.title(of: eclat) == eclat.title, "\(eclat) title")
            #expect(CampaignText.condition(of: eclat) == eclat.condition, "\(eclat) condition")
        }
    }

    @Test("E: a key is made of what a thing is, never of what it says")
    func keysComeFromIdentity() {
        #expect(CampaignText.key(level: "3-4", .title) == "level.3-4.title")
        #expect(CampaignText.key(level: "11-3", .principle) == "level.11-3.principle")
        #expect(CampaignText.key(chapter: 1, .name) == "chapter.1.name")
        #expect(CampaignText.key(element: .lueur, .summary) == "element.lueur.summary")
        #expect(CampaignText.key(eclat: .serein, .condition) == "eclat.serein.condition")
        // Rewording the French cannot move a key: the key never reads the sentence.
        let level = Campaign.levels[0]
        #expect(CampaignText.key(level: level.id, .title) == "level.\(level.id).title")
    }

    @Test("F: no two pieces of content share a key")
    func keysDoNotCollide() {
        var keys: [String] = []
        for level in Campaign.levels {
            keys.append(CampaignText.key(level: level.id, .title))
            keys.append(CampaignText.key(level: level.id, .principle))
        }
        for chapter in Campaign.chapters {
            keys.append(CampaignText.key(chapter: chapter.number, .name))
            keys.append(CampaignText.key(chapter: chapter.number, .principle))
        }
        for element in GameElement.allCases {
            keys.append(CampaignText.key(element: element, .name))
            keys.append(CampaignText.key(element: element, .summary))
        }
        for eclat in Eclat.allCases {
            keys.append(CampaignText.key(eclat: eclat, .title))
            keys.append(CampaignText.key(eclat: eclat, .condition))
        }
        #expect(Set(keys).count == keys.count, "\(keys.count - Set(keys).count) colliding keys")
        #expect(keys.allSatisfy { !$0.contains(" ") }, "a key is an identifier, not a sentence")
    }

    @Test("G: French is the source of both catalogues, every key gives a translator context")
    func cataloguesAreFrenchSourced() throws {
        for name in ["Localizable", "Gameplay"] {
            let catalogue = try catalog(name)
            #expect(catalogue["sourceLanguage"] as? String == "fr")
            for (key, entry) in try strings(name) {
                let localizations = try #require((entry as? [String: Any])?["localizations"] as? [String: Any])
                // Written when French was the only language. EN-4A adds English to the non-sensitive interface
                // under a rule checked in EnglishTranslationTests; what this suite still guards is that French is
                // never lost and that no unplanned language appears.
                #expect(localizations["fr"] != nil, "\(name): \(key) has lost its French")
                #expect(Set(localizations.keys).isSubset(of: ["fr", "en"]),
                        "\(name): \(key) carries a language Iris does not ship")
                let comment = (entry as? [String: Any])?["comment"] as? String
                #expect(!(comment ?? "").isEmpty, "\(name): \(key) gives a translator no context")
            }
        }
    }

    @Test("H: the French written in the gameplay catalogue is the French Domain holds, to the character")
    func catalogueDoesNotDriftFromDomain() throws {
        for (key, entry) in try strings("Gameplay") {
            let parts = key.split(separator: ".")
            guard parts.count == 3, parts[0] == "level", parts[2] == "title" else { continue }
            let level = try #require(Campaign.level(id: String(parts[1])), "\(key) names no level")
            let unit = (entry as? [String: Any])?["localizations"] as? [String: Any]
            let french = ((unit?["fr"] as? [String: Any])?["stringUnit"] as? [String: Any])?["value"] as? String
            #expect(french == level.title, "\(key) has drifted from Domain")
        }
    }
}
