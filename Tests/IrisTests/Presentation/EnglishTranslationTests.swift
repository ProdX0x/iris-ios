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
        #expect(counted == 684, "the catalogues hold \(counted) keys, not 684")
    }

    @Test("2: the classification still explains which phase wrote each sentence")
    func englishSitsWhereTheRuleAllows() throws {
        // Until EN-5 this read « and for no sensitive one ». EN-5 ends that deliberately: what the rule decides now
        // is which table a key's English came from, and EN-4C's ninety-four sentences must never be reached by it.
        for table in Self.tables {
            for entry in try Self.entries(table) {
                let category = try #require(LocalizationCatalogTests.category(table, entry.key),
                                            "\(table)/\(entry.key) has no class")
                let english = try #require(entry.english, "\(entry.key) has no English")
                #expect(!english.isEmpty)
                switch category {
                case .sensitiveEN5:
                    #expect(EnglishTranslationsEN5.byKey[entry.key] != nil, "\(entry.key) was deferred, so EN-5 owns it")
                    #expect(EnglishTranslations.byKey[entry.key] == nil, "\(entry.key) is claimed by both phases")
                case .nonSensitive, .reserved:
                    // Written when EN-4C owned every non-sensitive sentence. Keys created afterwards — the four
                    // status words VoiceOver speaks, for instance — are non-sensitive too and belong to the phase
                    // that wrote them. What must stay true is that exactly one phase claims each key.
                    let en4c = EnglishTranslations.byKey[entry.key] != nil
                    let en5 = EnglishTranslationsEN5.byKey[entry.key] != nil
                    #expect(en4c != en5, "\(entry.key) is claimed by \(en4c && en5 ? "both phases" : "neither phase")")
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
                    let listed = EnglishTranslations.identicalByDesign.contains(entry.key)
                        || EnglishTranslationsEN5.identicalByDesign.contains(entry.key)
                    #expect(listed, "\(entry.key) is identical to the French without being listed as legitimately identical")
                }
            }
        }
        // And nothing sits in the list that is not actually identical.
        let all = try Self.tables.flatMap { try Self.entries($0) }
        for key in EnglishTranslations.identicalByDesign.union(EnglishTranslationsEN5.identicalByDesign) {
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

    @Test("7: the whole gameplay corpus is translated, and all of it by EN-5")
    func gameplayIsTranslatedByEN5() throws {
        let gameplay = try Self.entries(IrisText.gameplayTable)
        #expect(gameplay.count == 417)
        for entry in gameplay {
            #expect(entry.english != nil, "\(entry.key) has no English")
            #expect(LocalizationCatalogTests.category(IrisText.gameplayTable, entry.key) == .sensitiveEN5)
            #expect(EnglishTranslations.byKey[entry.key] == nil, "\(entry.key) belongs to EN-5, not EN-4C")
        }
    }

    @Test("8: every translation offered is written, and no more than what was offered")
    func noTranslationIsStranded() throws {
        let all = try Self.tables.flatMap { table in try Self.entries(table).map { (table, $0) } }
        let written = Set(all.compactMap { $0.1.english == nil ? nil : $0.1.key })
        let offered = Set(EnglishTranslations.byKey.keys).union(EnglishTranslationsEN5.byKey.keys)
        #expect(written == offered, "written \(written.count), offered \(offered.count)")
    }

    @Test("9: the plural mechanism is Apple's, in both languages")
    func pluralsAreNative() throws {
        let plurals = try Self.entries(IrisText.interfaceTable).filter(\.isPluralized)
        #expect(plurals.count == 2)
        for entry in plurals {
            #expect(entry.english != nil, "\(entry.key) has no English plural")
            #expect(entry.englishOne != nil, "\(entry.key) has no English singular")
            #expect(entry.englishOne != entry.english, "\(entry.key): English says the same thing at 1 and at 2")
        }
        // French keeps one wording at every count, exactly as validated.
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
                let expected = try #require(entry.english, "\(entry.key) has no English")
                if entry.isPluralized {
                    #expect(en.contains("%#@"), "en/\(entry.key) should resolve through the plural template")
                } else {
                    #expect(en == expected, "en/\(entry.key) answered « \(en) »")
                }
                #expect(fr != entry.key && en != entry.key)
            }
        }
    }

    @Test("12: the plurals resolve at 0, 1, 2 and 5 — English singular at 1, plural everywhere else")
    func pluralsResolveAtEveryCount() throws {
        let english = try Self.bundle("en")
        let french = try Self.bundle("fr")
        let locale = Locale(identifier: "en_US")

        func render(_ bundle: Bundle, _ key: String, _ arguments: [any CVarArg]) -> String {
            let template = bundle.localizedString(forKey: key, value: "", table: IrisText.interfaceTable)
            return String(format: template, locale: locale, arguments: arguments)
        }

        for count in [0, 1, 2, 5] {
            let noun = count == 1 ? "glint" : "glints"
            #expect(render(english, "eclats.outOfThree.value", [count]) == "\(count) \(noun) out of 3")
            #expect(render(english, "eclats.total.value", [count, 423]) == "\(count) \(noun) out of 423")
            // French keeps one wording at every count: EN-5 changes no validated French.
            #expect(render(french, "eclats.outOfThree.value", [count]) == "\(count) éclats sur 3")
            #expect(render(french, "eclats.total.value", [count, 423]) == "\(count) éclats sur 423")
        }
        // The noun is the one word Iris uses for what a level awards, and it is used nowhere else by another name.
        #expect(EnglishTranslationsEN5.eclatTerm == "glint")
        for key in ["eclats.outOfThree.value", "eclats.total.value", "journey.eclats.label", "settings.reset.confirm"] {
            let value = try #require(EnglishTranslationsEN5.byKey[key] ?? EnglishTranslationsEN5.plurals[key]?.other)
            #expect(value.lowercased().contains(EnglishTranslationsEN5.eclatTerm), "\(key) names the mark differently")
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
