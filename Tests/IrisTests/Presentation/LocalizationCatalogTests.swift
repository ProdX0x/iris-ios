// LocalizationCatalogTests.swift
// Layer: Tests
// Purpose: The French catalogues say exactly what the app says, and nothing else. Every key the app can ask for has an
// entry, every entry answers to a key the app can ask for, the French in the catalogue is the French in the code, and
// no English has appeared. The generator that writes the catalogues lives here too, so what verifies them is what
// produced them

import Foundation
import Testing
@testable import Iris

@Suite("French localization catalogues")
struct LocalizationCatalogTests {
    private static let gameplay = LocalizationCatalog.gameplayEntries
    private static let interface = LocalizationCatalog.interfaceEntries(calls: InterfaceLocalizationTests.callSites)

    /// Writes the two catalogues from the corpus. Runs only when `.write-catalogs` sits at the project root, so no
    /// ordinary test run can ever touch the repository.
    @Test("Z: generator — writes the catalogues when asked, and only then")
    func generateCatalogues() throws {
        let marker = LocalizationCatalog.projectRoot.appendingPathComponent(".write-catalogs")
        guard FileManager.default.fileExists(atPath: marker.path) else { return }
        try LocalizationCatalog.json(for: Self.gameplay).write(to: LocalizationCatalog.url(table: IrisText.gameplayTable))
        try LocalizationCatalog.json(for: Self.interface).write(to: LocalizationCatalog.url(table: IrisText.interfaceTable))
    }

    @Test("M: every key the app can ask for has an entry")
    func everyRequiredKeyExists() throws {
        for (table, expected) in [(IrisText.gameplayTable, Self.gameplay), (IrisText.interfaceTable, Self.interface)] {
            let present = Set(try LocalizationCatalog.read(table: table).map(\.key))
            let missing = expected.map(\.key).filter { !present.contains($0) }
            #expect(missing.isEmpty, "\(table) is missing \(missing.count): \(missing.prefix(12).joined(separator: ", "))")
        }
    }

    @Test("N: no entry answers to a key the app never asks for")
    func noOrphanEntry() throws {
        for (table, expected) in [(IrisText.gameplayTable, Self.gameplay), (IrisText.interfaceTable, Self.interface)] {
            let wanted = Set(expected.map(\.key))
            let orphans = try LocalizationCatalog.read(table: table).map(\.key).filter { !wanted.contains($0) }
            #expect(orphans.isEmpty, "\(table) carries \(orphans.count) key(s) nothing reads: \(orphans.prefix(12).joined(separator: ", "))")
        }
    }

    @Test("O: the French in the catalogue is the French in the code")
    func frenchMatchesTheCorpus() throws {
        for (table, expected) in [(IrisText.gameplayTable, Self.gameplay), (IrisText.interfaceTable, Self.interface)] {
            let onDisk = Dictionary(uniqueKeysWithValues: try LocalizationCatalog.read(table: table).map { ($0.key, $0) })
            for entry in expected {
                guard let written = onDisk[entry.key] else { continue }
                #expect(written.french == entry.french, "\(table)/\(entry.key): « \(written.french) » ≠ « \(entry.french) »")
                #expect(written.isPluralized == entry.isPluralized, "\(table)/\(entry.key): plural declaration differs")
            }
        }
    }

    @Test("P: a key is never a sentence, and never collides")
    func keysAreIdentitiesNotSentences() throws {
        for table in [IrisText.gameplayTable, IrisText.interfaceTable] {
            let entries = try LocalizationCatalog.read(table: table)
            #expect(Set(entries.map(\.key)).count == entries.count, "\(table) repeats a key")
            for entry in entries {
                #expect(entry.key != entry.french, "\(table): \(entry.key) is its own sentence")
                #expect(!entry.key.contains(" "), "\(table): \(entry.key) is not an identifier")
                #expect(entry.key.contains("."), "\(table): \(entry.key) names no family")
                #expect(!entry.french.isEmpty || entry.key == "common.list.conjunction", "\(table): \(entry.key) is empty")
            }
        }
    }

    @Test("Q: no English has been added")
    func noEnglishExists() throws {
        for table in [IrisText.gameplayTable, IrisText.interfaceTable] {
            let root = try JSONSerialization.jsonObject(with: try Data(contentsOf: LocalizationCatalog.url(table: table))) as? [String: Any]
            #expect(root?["sourceLanguage"] as? String == "fr")
            let strings = try #require(root?["strings"] as? [String: Any])
            for (key, raw) in strings {
                let localizations = try #require((raw as? [String: Any])?["localizations"] as? [String: Any])
                #expect(Set(localizations.keys) == ["fr"], "\(table)/\(key) carries a language other than French")
            }
        }
    }

    @Test("R: every sentence resolves to itself, and never to a raw key")
    func nothingFallsBackToAKey() throws {
        for entry in try LocalizationCatalog.read(table: IrisText.interfaceTable) where !entry.french.contains("%") {
            let resolved = IrisText.interface(entry.key, french: entry.french)
            #expect(resolved == entry.french, "\(entry.key) resolved to « \(resolved) »")
            #expect(resolved != entry.key)
        }
        for entry in try LocalizationCatalog.read(table: IrisText.gameplayTable) {
            let resolved = IrisText.gameplay(entry.key, french: entry.french)
            #expect(resolved == entry.french, "\(entry.key) resolved to « \(resolved) »")
            #expect(resolved != entry.key)
        }
    }

    @Test("S: the dynamic correspondences still find their key")
    func dynamicCorrespondencesHold() {
        var correspondences = 0
        for level in Campaign.levels {
            for hint in level.hints {
                #expect(HintText.key(for: hint.text, in: level) == HintText.key(level: level.id, trigger: hint.trigger),
                        "\(level.id): « \(hint.text.prefix(40)) »")
                correspondences += 1
            }
            if let help = level.oculo?.help {
                #expect(HintText.key(for: help, in: level) == HintText.oculoHelpKey(level: level.id))
                correspondences += 1
            }
            #expect(HintText.key(for: "une phrase que ce niveau ne nomme pas", in: level)
                    == HintText.key(generic: HintText.genericHelp(for: level)))
            correspondences += 1
        }
        #expect(correspondences == Self.expectedCorrespondences,
                "the campaign now holds \(correspondences) dynamic correspondences, not \(Self.expectedCorrespondences)")
    }

    /// Measured on the campaign as it stands: one per hint a level names, one per oculomotor late help, and one per
    /// level for the generic help the engine synthesises when the level names none.
    static let expectedCorrespondences = 245

    @Test("T: a sentence with values renders exactly the French it rendered before")
    func interpolationsRenderUnchanged() {
        #expect(IrisText.interface("about.version.line", french: "Version %@ (build %@)", "1.0", "1") == "Version 1.0 (build 1)")
        #expect(IrisText.interface("common.pageIndicator", french: "Écran %lld sur %lld", 2, 4) == "Écran 2 sur 4")
        #expect(IrisText.interface("chapters.locked.hint", french: "Terminez le chapitre %@", "III") == "Terminez le chapitre III")
        #expect(IrisText.interface("chapters.level.label", french: "Niveau %lld, %@", 3, "le fil") == "Niveau 3, le fil")
        #expect(IrisText.interface("common.chapterLevel.line", french: "%@ · %@ — %@", "III", "courants", "la brèche")
                == "III · courants — la brèche")
        #expect(IrisText.interface("levelIntro.chapterLevel.line", french: "%@ · %@ — %lld", "IV", "veilles", 2) == "IV · veilles — 2")
        #expect(IrisText.interface("gazeStatus.meanError.line", french: "%@ — écart moyen %lld %%.", "Calibration réussie", 12)
                == "Calibration réussie — écart moyen 12 %.")
        #expect(IrisText.interface("gazeStatus.line", french: "%@.", "Calibration réussie") == "Calibration réussie.")
        #expect(IrisText.interface("gazeVerdict.percent.value", french: "%lld %%", 18) == "18 %")
        #expect(IrisText.interface("progress.percent.value", french: "%lld pour cent", 40) == "40 pour cent")
        #expect(IrisText.interface("result.levelIndex.eyebrow", french: "niveau %lld", 5) == "niveau 5")
        #expect(IrisText.interface("paywall.unlock.withPrice", french: "Débloquer · %@", "2,99 €") == "Débloquer · 2,99 €")
        #expect(IrisText.interface("paywall.freeChapters", french: "Les chapitres %@ restent gratuits, pour toujours.", "I, II et III")
                == "Les chapitres I, II et III restent gratuits, pour toujours.")
        #expect(IrisText.interface("paywall.lockedChapter", french: "Le chapitre %@ fait partie de l'accès complet.", "VII")
                == "Le chapitre VII fait partie de l'accès complet.")
        #expect(IrisText.interface("chapters.card.label", french: "Chapitre %lld, %@, %lld niveaux sur %lld atteints",
                                   2, "veilles", 3, 12) == "Chapitre 2, veilles, 3 niveaux sur 12 atteints")
        #expect(IrisText.interface("chapters.card.label.locked",
                                   french: "Chapitre %lld, %@, %lld niveaux sur %lld atteints, accès complet requis",
                                   9, "brumes", 0, 11) == "Chapitre 9, brumes, 0 niveaux sur 11 atteints, accès complet requis")
        #expect(IrisText.interface("gazeSetup.insufficientSignal.message",
                                   french: "Le regard n'a pas pu être mesuré sur le point %lld. Gardez la tête immobile, évitez les reflets et recommencez.", 4)
                .hasPrefix("Le regard n'a pas pu être mesuré sur le point 4."))
        #expect(IrisText.interface("game.trackingError.message",
                                   french: "Le suivi du regard s'est arrêté de façon inattendue. %@", "Session interrompue.")
                == "Le suivi du regard s'est arrêté de façon inattendue. Session interrompue.")
    }

    @Test("U: a sentence carrying a literal percent sign is not read as a format")
    func literalPercentSurvives() {
        let note = IrisText.interface("gazeVerdict.error.note",
                                      french: "en pourcentage de la petite dimension de l'écran (seuils 18 % et 30 %)")
        #expect(note.contains("18 %") && note.contains("30 %"))
        #expect(IrisText.interface("gazeLearning.accuracy.note",
                                   french: "0 % est une référence idéale").contains("0 %"))
    }

    @Test("V: the plural entries render the validated French at every count")
    func pluralsRenderTheValidatedFrench() {
        for count in 0...3 {
            #expect(IrisText.interface("eclats.outOfThree.value", french: "%lld éclats sur 3", count) == "\(count) éclats sur 3")
        }
        let total = Campaign.levels.count * 3
        for count in [0, 1, 2, total - 1, total] {
            #expect(IrisText.interface("eclats.total.value", french: "%lld éclats sur %lld", count, total)
                    == "\(count) éclats sur \(total)")
        }
    }

    @Test("W: the navigation line rebuilt outside the freeze equals the one the frozen file composes")
    @MainActor
    func navigationLabelMatchesTheFrozenComposition() {
        for level in Campaign.levels {
            #expect(NavigationText.label(for: level) == AppCoordinator.label(for: level), "\(level.id)")
        }
        for sheet in AppSheet.allCases { #expect(NavigationText.title(of: sheet) == sheet.title) }
        for destination in AppDestination.allCases { #expect(NavigationText.title(of: destination) == destination.title) }
    }

    @Test("X: the readiness details are not translatable, and the catalogue must not pretend they are")
    func readinessDetailsStayOutOfTheCatalogue() throws {
        // Their sentences are composed in `AR/Calibration/GazeReadinessEvaluator.swift`, which is frozen. A single
        // (kind, status) pair can produce several of them — `.session` + `.fail` alone has three — and one is built
        // with a live measurement. A key that cannot name one sentence must not be given one, or a translation would
        // silently merge three different messages into one.
        let present = Set(try LocalizationCatalog.read(table: IrisText.interfaceTable).map(\.key))
        for kind in ReadinessCheckKind.allCases {
            #expect(present.contains(GazeReadinessText.titleKey(for: kind)), "the check's name is translatable")
            for status in [ReadinessStatus.pending, .pass, .fail] {
                #expect(!present.contains(GazeReadinessText.detailKey(for: kind, status: status)),
                        "\(kind).\(status) must not be given a canonical sentence")
            }
        }
    }

    @Test("Y: what EN-4 will have to fill, listed rather than guessed")
    func englishCoverageIsMeasurable() throws {
        for table in [IrisText.gameplayTable, IrisText.interfaceTable] {
            let entries = try LocalizationCatalog.read(table: table)
            #expect(!entries.isEmpty)
            #expect(try Self.keysAwaitingEnglish(in: table).count == entries.count,
                    "\(table): English exists for some keys already, which EN-3 must not have added")
        }
    }

    /// The base EN-4 and EN-5 will check against: which keys of a table still carry no English. Today, all of them;
    /// when EN-4 has done its work this returns the empty array, and that is the assertion to flip.
    static func keysAwaitingEnglish(in table: String) throws -> [String] {
        try LocalizationCatalog.languages(table: table).filter { !$0.value.contains("en") }.keys.sorted()
    }
}
