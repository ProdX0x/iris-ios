// LevelHintLocalizationTests.swift
// Layer: Tests
// Purpose: Every contextual instruction the engine can show has exactly one stable identity, that identity is never
// its French sentence, no two instructions share one, the campaign needs no fallback, and with no translation the
// French returned is the French the level holds. The engine itself is asked what it would show: nothing is copied here

import Foundation
import Testing
@testable import Iris

@Suite("Level hint localization")
struct LevelHintLocalizationTests {
    /// The late help the engine synthesises for a level, obtained from the engine rather than written down: a long
    /// elapsed time fires every delayed hint, and the help the tracker appends is the last one shown.
    private func engineLateHelp(for level: LevelDefinition) -> String? {
        var tracker = HintTracker.forLevel(level)
        _ = tracker.observe(events: [], elapsed: 100_000)
        return tracker.current
    }

    private var levels: [LevelDefinition] { Campaign.levels }

    @Test("A: every hint of every level has exactly one identity, and it is the one its trigger names")
    func everyHintHasOneIdentity() {
        var count = 0
        for level in levels {
            for hint in level.hints {
                let expected = HintText.key(level: level.id, trigger: hint.trigger)
                #expect(HintText.key(for: hint.text, in: level) == expected, "\(level.id): \(hint.trigger)")
                #expect(!expected.isEmpty)
                count += 1
            }
        }
        // 162 in the campaign the player receives. The four others belong to the Braises prototype, a DEBUG-only
        // chapter absent from `Campaign.levels`; the registry covers it too, being built from any LevelDefinition.
        #expect(count == 162, "the campaign carries \(count) hints; the mapping was measured on 162")
    }

    @Test("B: no two hints of the campaign share an identity")
    func identitiesAreUnique() {
        var keys: [String] = []
        for level in levels {
            keys.append(contentsOf: level.hints.map { HintText.key(level: level.id, trigger: $0.trigger) })
            if level.oculo?.help != nil { keys.append(HintText.oculoHelpKey(level: level.id)) }
        }
        keys.append(contentsOf: HintText.GenericHelp.allCases.map { HintText.key(generic: $0) })
        #expect(Set(keys).count == keys.count, "\(keys.count - Set(keys).count) colliding keys")
    }

    @Test("C: an identity is an identifier, never a sentence")
    func identitiesCarryNoFrench() {
        let allowed = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.-_")
        for level in levels {
            for hint in level.hints {
                let key = HintText.key(level: level.id, trigger: hint.trigger)
                #expect(key.unicodeScalars.allSatisfy { allowed.contains($0) }, "\(key) is not an identifier")
                #expect(!key.contains(hint.text))
                #expect(!key.contains(" "))
            }
        }
    }

    @Test("D: inside a level, one sentence resolves once and only once")
    func oneSentenceResolvesOnce() {
        for level in levels {
            let registry = HintText.registry(for: level)
            let sentences = Set(level.hints.map(\.text)).union(level.oculo?.help.map { [$0] } ?? [])
            #expect(registry.count == sentences.count, "\(level.id): a sentence is written twice in the same level")
            for hint in level.hints {
                #expect(registry[hint.text] == HintText.key(level: level.id, trigger: hint.trigger), "\(level.id)")
            }
        }
    }

    @Test("E: a level that names its own oculomotor help has an identity for it")
    func oculoHelpsAreCovered() {
        var covered = 0
        for level in levels {
            guard let help = level.oculo?.help else { continue }
            #expect(HintText.registry(for: level)[help] == HintText.oculoHelpKey(level: level.id))
            #expect(HintText.key(for: help, in: level) == HintText.oculoHelpKey(level: level.id))
            covered += 1
        }
        #expect(covered >= 1, "the campaign names at least one oculomotor help of its own")
    }

    @Test("F: the late help the engine synthesises is identified by the shape of the level, not by its words")
    func genericHelpsAreCovered() throws {
        var seen: Set<HintText.GenericHelp> = []
        for level in levels {
            let help = try #require(engineLateHelp(for: level), "\(level.id) shows no late help")
            let resolved = HintText.key(for: help, in: level)
            if level.oculo?.help != nil {
                #expect(resolved == HintText.oculoHelpKey(level: level.id), "\(level.id)")
            } else {
                let generic = HintText.genericHelp(for: level)
                #expect(resolved == HintText.key(generic: generic), "\(level.id)")
                seen.insert(generic)
            }
        }
        #expect(!seen.isEmpty)
        #expect(seen.isSubset(of: Set(HintText.GenericHelp.allCases)))
    }

    @Test("G: the campaign as it stands never needs the fallback")
    func noFallbackIsNeeded() {
        for level in levels {
            let registry = HintText.registry(for: level)
            for hint in level.hints {
                #expect(registry[hint.text] != nil, "\(level.id) would fall back for « \(hint.text) »")
            }
        }
    }

    @Test("H: with no translation, the French shown is exactly the French the level holds")
    func frenchIsUnchanged() {
        var checked = 0
        for level in levels {
            for hint in level.hints {
                #expect(HintText.localized(hint.text, in: level) == hint.text, "\(level.id)")
                checked += 1
            }
            if let help = engineLateHelp(for: level) {
                #expect(HintText.localized(help, in: level) == help, "\(level.id) late help")
                checked += 1
            }
        }
        #expect(checked == 162 + levels.count, "expected one correspondence per hint plus one late help per level")
    }

    @Test("I: every instruction keeps its French, and no language Iris does not ship")
    func noTranslationExists() throws {
        let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()
            .deletingLastPathComponent().deletingLastPathComponent()
        let data = try Data(contentsOf: root.appendingPathComponent("Resources/Gameplay.xcstrings"))
        let catalogue = try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])
        let strings = try #require(catalogue["strings"] as? [String: Any])
        for (key, entry) in strings {
            let localizations = try #require((entry as? [String: Any])?["localizations"] as? [String: Any])
            // Until EN-5 this said « French only ». EN-5 translates the instructions on purpose; what still has
            // to hold is that the French is never lost and that no third language appears.
            #expect(localizations["fr"] != nil, "\(key) has lost its French")
            #expect(Set(localizations.keys).isSubset(of: ["fr", "en"]),
                    "\(key) carries a language Iris does not ship")
        }
    }

    @Test("J: no screen can ever be handed a technical key")
    func noKeyReachesTheScreen() {
        for level in levels {
            for text in level.hints.map(\.text) + [engineLateHelp(for: level)].compactMap({ $0 }) {
                let shown = HintText.localized(text, in: level)
                #expect(!shown.hasPrefix("level."))
                #expect(!shown.hasPrefix("hint."))
                #expect(!shown.isEmpty)
            }
        }
        // A sentence from nowhere is identified as the level's generic help — that is what `HintText.key(for:in:)`
        // promises — and since EN-3 the catalogue answers that key with a real sentence. What matters here has not
        // changed: French reaches the screen, never an identifier. In play the case cannot arise, because the only
        // sentences the engine produces are the level's own and the generic help itself.
        let stranger = "Une phrase que personne n'a écrite."
        let shown = HintText.localized(stranger, in: levels[0])
        #expect(!shown.hasPrefix("hint.") && !shown.hasPrefix("level."))
        #expect(!shown.isEmpty)
        #expect(shown == HintText.localized(engineLateHelp(for: levels[0]) ?? stranger, in: levels[0]))
    }
}
