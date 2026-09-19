// EnglishTranslationEN5Tests.swift
// Layer: Tests
// Purpose: What EN-5 must not have got wrong. The instructions it translates decide where a player looks, and the
// gaze pushes: an inverted left is not a clumsy phrase, it sends the player the wrong way. Directions are checked
// side by side with the French, the word for what a level awards is checked for being the only one, and the
// ninety-four sentences EN-4C settled are checked for not having moved

import Foundation
import Testing
@testable import Iris

@Suite("English translation, phase EN-5A")
struct EnglishTranslationEN5Tests {
    private static let tables = [IrisText.gameplayTable, IrisText.interfaceTable]

    private static func entries(_ table: String) throws -> [CatalogEntry] {
        try LocalizationCatalog.read(table: table)
    }

    private static var allEntries: [CatalogEntry] {
        get throws { try tables.flatMap { try entries($0) } }
    }

    @Test("A: the two phases own disjoint sets of keys, and together they cover the catalogues")
    func phasesDoNotOverlap() throws {
        let en4c = Set(EnglishTranslations.byKey.keys)
        let en5 = Set(EnglishTranslationsEN5.byKey.keys)
        #expect(en4c.isDisjoint(with: en5), "claimed twice: \(en4c.intersection(en5).sorted().prefix(8))")
        #expect(en4c.count == 89, "EN-4C settled \(en4c.count) sentences, not 89")
        #expect(en5.count == 591, "EN-5 wrote \(en5.count) sentences, not 591 (566 catalogue + 25 readiness)")
        let catalogued = Set(try Self.allEntries.map(\.key))
        #expect(en4c.union(en5) == catalogued, "the tables and the catalogues do not describe the same keys")
    }

    @Test("B: not one sentence EN-4C settled has moved")
    func en4cIsUntouched() throws {
        let onDisk = Dictionary(uniqueKeysWithValues: try Self.allEntries.map { ($0.key, $0.english) })
        for (key, english) in EnglishTranslations.byKey {
            #expect(onDisk[key] == english, "\(key): « \(onDisk[key] ?? "nil") » is not what EN-4C settled")
        }
    }

    @Test("C: every catalogued key answers in English")
    func everythingIsTranslated() throws {
        var count = 0
        for table in Self.tables {
            for entry in try Self.entries(table) {
                let english = try #require(entry.english, "\(table)/\(entry.key) has no English")
                #expect(!english.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, "\(entry.key) is blank")
                #expect(english != entry.key, "\(entry.key) was translated into its own key")
                #expect(!english.hasPrefix("level.") && !english.hasPrefix("chapter.") && !english.hasPrefix("element."),
                        "\(entry.key) reads like an identifier")
                count += 1
            }
        }
        #expect(count == 680, "\(count) keys, not 680 (655 + the 25 readiness messages)")
    }

    /// Direction words, French beside English. A sentence that names one in French must name its counterpart in
    /// English — never the opposite one.
    private static let directions: [(french: [String], english: [String], opposite: [String])] = [
        (["à gauche", "vers la gauche", "de gauche"], ["left"], ["right"]),
        (["à droite", "vers la droite", "de droite", "par la droite"], ["right"], ["left"]),
        (["au-dessus", "vers le haut", "du haut", "en haut", "monte", "montera"], ["above", "up", "upper", "top", "rise", "rises"], ["below", "down", "lower", "bottom"]),
        (["au-dessous", "vers le bas", "du bas", "en bas", "sous ", "d'en bas"], ["below", "down", "lower", "bottom", "under"], ["above", "up", "upper", "top"]),
    ]

    @Test("D: no direction is inverted, and none is lost")
    func directionsSurvive() throws {
        var checked = 0
        for entry in try Self.allEntries {
            guard let english = entry.english?.lowercased() else { continue }
            let french = entry.french.lowercased()
            for rule in Self.directions where rule.french.contains(where: french.contains) {
                #expect(rule.english.contains(where: english.contains),
                        "\(entry.key): the French says \(rule.english.first ?? "?"), the English does not — « \(entry.french) » / « \(entry.english ?? "") »")
                checked += 1
            }
        }
        #expect(checked >= 20, "only \(checked) directional sentences were checked; the corpus holds more")
    }

    @Test("E: the marks a level awards have exactly one English word")
    func eclatTermIsTheOnlyOne() throws {
        let term = EnglishTranslationsEN5.eclatTerm
        #expect(term == "glint")
        // Every sentence whose French names the mark must name it with that word, and no other candidate may appear
        // anywhere in the English: one concept, one word.
        let competitors = ["shard", "sparkle", "star rating", "medal", "trophy", "badge"]
        // « éclat » is two words in French. The mark a level awards is named by its key — the eclat family, the
        // counters, the reset confirmation, the end-of-journey label — and only those must carry the English term.
        // Only where the French uses the noun itself. `eclat.atteint.title` and its siblings name the three marks
        // one by one — reached, fluid, serene — and are not the noun.
        let namesTheMark = ["eclats.outOfThree.value", "eclats.total.value", "journey.eclats.label",
                            "settings.reset.confirm"]
        // The other « éclat » is the flash of the lying mirror, which calls the gaze to the wrong side. It is a
        // different thing and takes a different word, used consistently wherever that level speaks.
        let namesTheGlare = ["element.miroir.summary", "level.4-7.hint.firstOculoMiss",
                             "level.4-7.hint.firstOculoSuccess", "level.4-7.hint.start", "level.4-7.principle"]
        for entry in try Self.allEntries {
            guard let english = entry.english?.lowercased() else { continue }
            if namesTheMark.contains(entry.key) {
                #expect(english.contains(term) || entry.isPluralized,
                        "\(entry.key) names the mark without « \(term) »: « \(entry.english ?? "") »")
            }
            if namesTheGlare.contains(entry.key) {
                #expect(english.contains("glare"), "\(entry.key) should call the mirror's flash a glare")
                #expect(!english.contains(term), "\(entry.key) confuses the mirror's flash with the mark")
            }
            for rival in competitors {
                #expect(!english.contains(rival), "\(entry.key) introduces « \(rival) » for a concept that already has a word")
            }
        }
        // The three marks keep names of their own, and none of them borrows the noun.
        for mark in ["eclat.atteint.title", "eclat.fluide.title", "eclat.serein.title"] {
            let english = try #require(EnglishTranslationsEN5.byKey[mark])
            #expect(!english.lowercased().contains(term), "\(mark) should name one mark, not the noun")
            #expect(!english.isEmpty)
        }
        // The plural entries are built from the same word in both forms.
        for (key, forms) in EnglishTranslationsEN5.plurals {
            #expect(forms.one.contains(term), "\(key) singular")
            #expect(forms.other.contains(term + "s"), "\(key) plural")
        }
    }

    @Test("F: every placeholder the French carries, the English carries too")
    func placeholdersSurvive() throws {
        func placeholders(_ text: String) -> [String] {
            text.matches(of: /%(?:\d+\$)?(@|lld|ld|d|f|%)/).map { String($0.output.1) }.filter { $0 != "%" }
        }
        for entry in try Self.allEntries {
            guard let english = entry.english else { continue }
            #expect(placeholders(entry.french).sorted() == placeholders(english).sorted(),
                    "\(entry.key): \(placeholders(entry.french)) vs \(placeholders(english))")
            if let one = entry.englishOne {
                #expect(placeholders(one).sorted() == placeholders(english).sorted(), "\(entry.key) singular")
            }
        }
    }

    @Test("G: the world keeps one word per thing, in English as in French")
    func worldVocabularyIsConsistent() throws {
        let english = Dictionary(uniqueKeysWithValues: try Self.allEntries.compactMap { entry in
            entry.english.map { (entry.key, $0) }
        })
        // A thing is named once, and its name is the one the carnet gives it.
        let glossary = [
            ("element.lueur.name", "glimmer"), ("element.iris.name", "iris"), ("element.courant.name", "current"),
            ("element.voile.name", "veil"), ("element.veilleuse.name", "watchlight"), ("element.braise.name", "ember"),
            ("element.souffle.name", "breath"), ("element.gouffre.name", "chasm"), ("element.echo.name", "echo"),
            ("element.balise.name", "beacon"), ("element.dormeuse.name", "sleeper"), ("element.jumelles.name", "twins"),
        ]
        for (key, word) in glossary {
            #expect(english[key] == word, "\(key) is « \(english[key] ?? "nil") », the glossary says « \(word) »")
        }
        // The chapters are named after the things they teach.
        #expect(english["chapter.3.name"] == "currents")
        #expect(english["chapter.5.name"] == "watchlights")
        #expect(english["chapter.8.name"] == "breaths")
        #expect(english["chapter.10.name"] == "chasms")
        #expect(english["chapter.11.name"] == "embers")
        // The threshold and the journal are named once each, in both places they appear.
        #expect(english["common.threshold"] == english["navigation.destination.seuil.title"])
        #expect(english["carnet.title"]?.lowercased() == english["navigation.destination.carnet.title"]?.lowercased())
    }

    /// Where the French itself names a person. Everywhere else « elle » is the gender of a French noun, not a
    /// character: rendering it « she » in English would invent a personification the French never makes.
    private static let personified: Set<String> = [
        "level.7-7.hint.firstOculoSuccess",  // « Elle appelle sa sœur » — the twins are sisters in the French
        "level.8-6.hint.start",              // « son poste » — the twin who must reach her post
        "level.8-6.principle",               // « une jumelle de son poste »
    ]

    @Test("I: only the twins are people; everything else is « it »")
    func pronounsFollowTheFrench() throws {
        let people = /\b(she|her|hers)\b/.ignoresCase()
        for entry in try Self.allEntries {
            guard let english = entry.english else { continue }
            let usesPeople = english.firstMatch(of: people) != nil
            if Self.personified.contains(entry.key) {
                #expect(usesPeople, "\(entry.key) is one of the twins' sentences and should keep « her »")
            } else {
                #expect(!usesPeople, "\(entry.key) personifies something the French only genders: « \(english) »")
            }
        }
        // And the French of every personified key really does name a person.
        for key in Self.personified {
            let entry = try #require(try Self.allEntries.first { $0.key == key })
            let french = entry.french.lowercased()
            #expect(french.contains("sœur") || french.contains("jumelle") || french.contains("poste"),
                    "\(key) is listed as personified but its French names no person")
        }
    }

    @Test("J: the watchlight is named once, and named the same everywhere")
    func watchlightIsOneWord() throws {
        let english = Dictionary(uniqueKeysWithValues: try Self.allEntries.compactMap { e in e.english.map { (e.key, $0) } })
        #expect(english["element.veilleuse.name"] == "watchlight")
        #expect(english["chapter.5.name"] == "watchlights")
        #expect(english["level.5-1.title"] == "the watchlight")
        #expect(english["level.5-6.title"] == "watchlights")
        #expect(english["level.7-5.title"] == "under the watchlight")
        // No competing word for the same thing anywhere in the English.
        for rival in ["vigil", "nightlight", "night light", "watchfire", "guardian light"] {
            for (key, value) in english {
                #expect(!value.lowercased().contains(rival), "\(key) calls the watchlight « \(rival) »")
            }
        }
    }

    @Test("H: the 245 dynamic correspondences are untouched by the translation")
    func dynamicCorrespondencesHold() {
        var correspondences = 0
        for level in Campaign.levels {
            for hint in level.hints {
                #expect(HintText.key(for: hint.text, in: level) == HintText.key(level: level.id, trigger: hint.trigger))
                correspondences += 1
            }
            if let help = level.oculo?.help {
                #expect(HintText.key(for: help, in: level) == HintText.oculoHelpKey(level: level.id))
                correspondences += 1
            }
            correspondences += 1
        }
        #expect(correspondences == 245, "\(correspondences) correspondences, not 245")
    }
}
