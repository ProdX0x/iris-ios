// EnglishTranslationTests.swift
// Layer: Tests
// Purpose: What EN-4A is allowed to have done, and nothing more. The classification is reproducible, the English
// exists exactly where the rule cleared it and nowhere else, not one French value moved, and every placeholder the
// French carries is carried by the English too — in whatever order English needs them

import Foundation
import Testing
@testable import Iris

@Suite("English translation, phase EN-4A")
struct EnglishTranslationTests {
    private static let tables = [IrisText.gameplayTable, IrisText.interfaceTable]

    private static func entries(_ table: String) throws -> [CatalogEntry] {
        try LocalizationCatalog.read(table: table)
    }

    /// Placeholders in the order a format declares them, so two formats can be compared as multisets.
    private static func placeholders(_ text: String) -> [String] {
        text.matches(of: /%(?:\d+\$)?(@|lld|ld|d|f|%)/).map { String($0.output.1) }.filter { $0 != "%" }
    }

    @Test("1: the classification is reproducible and covers every key exactly once")
    func classificationIsTotal() throws {
        var counted = 0
        for table in Self.tables {
            for entry in try Self.entries(table) {
                let first = LocalizationClassification.classify(table: table, key: entry.key,
                                                                french: entry.french, comment: entry.comment)
                let again = LocalizationClassification.classify(table: table, key: entry.key,
                                                               french: entry.french, comment: entry.comment)
                #expect(first == again, "\(entry.key) classifies differently twice")
                #expect(LocalizationCatalogTests.category(table, entry.key) != nil, "\(table)/\(entry.key) unclassified")
                counted += 1
            }
        }
        #expect(counted == 655, "the catalogues hold \(counted) keys, not 655")
    }

    @Test("2: English exists for every non-sensitive key, and for no sensitive one")
    func englishSitsWhereTheRuleAllows() throws {
        for table in Self.tables {
            for entry in try Self.entries(table) {
                switch LocalizationCatalogTests.category(table, entry.key) {
                case .nonSensitive:
                    let english = try #require(entry.english, "\(entry.key) is non-sensitive and has no English")
                    #expect(!english.isEmpty)
                case .sensitiveEN5:
                    #expect(entry.english == nil, "\(entry.key) is deferred to EN-5 and must not be translated yet")
                case .reserved:
                    if LocalizationClassification.mayTranslate(key: entry.key, french: entry.french,
                                                               deferredFrench: LocalizationCatalogTests.deferredFrench) {
                        #expect(entry.english != nil, "\(entry.key) is reserved and clear, so it should be translated")
                    } else {
                        #expect(entry.english == nil, "\(entry.key) carries words that are deferred elsewhere")
                    }
                case nil:
                    Issue.record("\(table)/\(entry.key) has no class")
                }
            }
        }
    }

    @Test("3: no English is empty, a key, or a copy of the French without reason")
    func englishIsRealEnglish() throws {
        for table in Self.tables {
            for entry in try Self.entries(table) {
                guard let english = entry.english else { continue }
                #expect(!english.trimmingCharacters(in: .whitespaces).isEmpty, "\(entry.key) is blank")
                #expect(english != entry.key, "\(entry.key) was translated into its own key")
                #expect(!english.hasPrefix("level.") && !english.hasPrefix("hint.") && !english.hasPrefix("chapter."),
                        "\(entry.key) looks like an identifier")
                if english == entry.french {
                    #expect(EnglishTranslations.identicalByDesign.contains(entry.key),
                            "\(entry.key) is identical to the French without being listed as legitimately identical")
                }
            }
        }
        // And nothing sits in the list that is not actually identical.
        let all = try Self.tables.flatMap { try Self.entries($0) }
        for key in EnglishTranslations.identicalByDesign {
            let entry = try #require(all.first { $0.key == key }, "\(key) is listed but absent from the catalogue")
            #expect(entry.english == entry.french, "\(key) is listed as identical but the two differ")
        }
    }

    @Test("4: every placeholder the French carries, the English carries too")
    func placeholdersSurvive() throws {
        for table in Self.tables {
            for entry in try Self.entries(table) {
                guard let english = entry.english else { continue }
                let french = Self.placeholders(entry.french)
                let translated = Self.placeholders(english)
                #expect(french.sorted() == translated.sorted(),
                        "\(entry.key): French \(french) vs English \(translated)")
                #expect(french.count == translated.count, "\(entry.key) gained or lost a placeholder")
            }
        }
    }

    @Test("5: a translated sentence with values renders in English with those values")
    func translatedFormatsRender() throws {
        let cases: [(String, [any CVarArg], String)] = [
            ("common.pageIndicator", [2, 4], "Screen 2 of 4"),
            ("chapters.level.label", [3, "the thread"], "Level 3, the thread"),
            ("chapters.locked.hint", ["III"], "Finish chapter III"),
            ("chapters.card.label", [2, "watches", 3, 12], "Chapter 2, watches, 3 of 12 levels reached"),
            ("chapters.card.label.locked", [9, "mists", 0, 11], "Chapter 9, mists, 0 of 11 levels reached, full access required"),
            ("paywall.unlock.withPrice", ["£2.99"], "Unlock · £2.99"),
            ("paywall.lockedChapter", ["VII"], "Chapter VII is included with full access."),
            ("result.levelIndex.eyebrow", [5], "level 5"),
            ("progress.percent.value", [40], "40 percent"),
            ("game.level.label", ["III · 2"], "Level III · 2"),
            ("about.version.line", ["1.0", "1"], "Version 1.0 (build 1)"),
            ("about.contact.address.label", ["contact@steve-s.net"], "Contact address: contact@steve-s.net"),
        ]
        for (key, arguments, expected) in cases {
            let english = try #require(EnglishTranslations.byKey[key])
            #expect(String(format: english, locale: Locale(identifier: "en_GB"), arguments: arguments) == expected, "\(key)")
        }
    }

    @Test("6: not one French value moved")
    func frenchIsUntouched() throws {
        for table in Self.tables {
            let expected = table == IrisText.gameplayTable
                ? LocalizationCatalog.gameplayEntries
                : LocalizationCatalog.interfaceEntries(calls: InterfaceLocalizationTests.callSites)
            let onDisk = Dictionary(uniqueKeysWithValues: try Self.entries(table).map { ($0.key, $0.french) })
            for entry in expected {
                #expect(onDisk[entry.key] == entry.french, "\(table)/\(entry.key): the French changed")
            }
        }
    }

    @Test("7: the whole gameplay corpus is still waiting for EN-5")
    func gameplayIsUntranslated() throws {
        let gameplay = try Self.entries(IrisText.gameplayTable)
        #expect(gameplay.count == 417)
        #expect(gameplay.allSatisfy { $0.english == nil }, "a gameplay sentence was translated before EN-5")
        for entry in gameplay {
            #expect(LocalizationCatalogTests.category(IrisText.gameplayTable, entry.key) == .sensitiveEN5)
        }
    }

    @Test("8: every key EnglishTranslations offers is a key the catalogue holds and the rule cleared")
    func noTranslationIsStranded() throws {
        let all = try Self.tables.flatMap { table in try Self.entries(table).map { (table, $0) } }
        let written = Set(all.compactMap { $0.1.english == nil ? nil : $0.1.key })
        for key in EnglishTranslations.byKey.keys {
            #expect(written.contains(key), "\(key) is translated in the table but not written to the catalogue")
        }
        #expect(written.count == EnglishTranslations.byKey.count,
                "\(written.count) keys carry English, \(EnglishTranslations.byKey.count) were offered")
    }

    @Test("9: the plural mechanism is Apple's, and no English plural has been written")
    func pluralsAreNativeAndStillFrench() throws {
        let plurals = try Self.entries(IrisText.interfaceTable).filter(\.isPluralized)
        #expect(plurals.count == 2)
        for entry in plurals {
            // Deferred with the rest of the « éclat » vocabulary: the English noun is EN-5's to choose.
            #expect(entry.english == nil, "\(entry.key) was given an English plural before its noun exists")
            #expect(LocalizationCatalogTests.category(IrisText.interfaceTable, entry.key) == .sensitiveEN5)
        }
        // The mechanism itself still resolves, in French, at every count the app can show.
        for count in [0, 1, 2, 5] {
            #expect(IrisText.interface("eclats.outOfThree.value", french: "%lld éclats sur 3", count)
                    == "\(count) éclats sur 3")
        }
    }

    /// The two compiled language bundles, read directly. Asking `Bundle.main` would answer in whatever language the
    /// simulator happens to be set to, and a suite whose result depends on that setting proves nothing.
    private static func bundle(_ language: String) throws -> Bundle {
        let path = try #require(Bundle.main.path(forResource: language, ofType: "lproj"),
                                "the built app has no \(language).lproj")
        return try #require(Bundle(path: path))
    }

    @Test("11: each language bundle answers in its own language, and never with a key")
    func eachBundleAnswersInItsLanguage() throws {
        let french = try Self.bundle("fr")
        let english = try Self.bundle("en")
        let marker = "\u{0}"
        for table in Self.tables {
            for entry in try Self.entries(table) {
                let fr = french.localizedString(forKey: entry.key, value: marker, table: table)
                if entry.isPluralized {
                    #expect(fr.contains("%#@"), "\(entry.key) should resolve through the plural template")
                } else {
                    #expect(fr == entry.french, "fr/\(entry.key) answered « \(fr) »")
                }
                let en = english.localizedString(forKey: entry.key, value: marker, table: table)
                if let expected = entry.english {
                    #expect(en == expected, "en/\(entry.key) answered « \(en) »")
                } else {
                    // Untranslated: the English bundle has nothing to say, and the app falls back to its French.
                    #expect(en == marker, "en/\(entry.key) answered « \(en) » but has no English yet")
                }
                #expect(fr != entry.key && en != entry.key)
            }
        }
    }

    @Test("12: the plural entries resolve in French at 0, 1, 2 and 5, and carry no English plural")
    func pluralsResolveAtEveryCount() throws {
        let english = try Self.bundle("en")
        for entry in try Self.entries(IrisText.interfaceTable).filter(\.isPluralized) {
            #expect(english.localizedString(forKey: entry.key, value: "\u{0}", table: IrisText.interfaceTable) == "\u{0}",
                    "\(entry.key) has an English plural before EN-5 chose the noun")
        }
        for count in [0, 1, 2, 5] {
            #expect(IrisText.interface("eclats.outOfThree.value", french: "%lld éclats sur 3", count)
                    == "\(count) éclats sur 3")
            #expect(IrisText.interface("eclats.total.value", french: "%lld éclats sur %lld", count, 423)
                    == "\(count) éclats sur 423")
        }
    }

    @Test("10: no screen can be handed a technical key in either language")
    func noKeyReachesAScreen() throws {
        for table in Self.tables {
            for entry in try Self.entries(table) {
                for text in [entry.french, entry.english].compactMap({ $0 }) {
                    #expect(text != entry.key)
                    #expect(!text.contains("%#@"), "\(entry.key) leaks a plural template")
                }
            }
        }
    }
}
