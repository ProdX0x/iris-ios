// LocalizationCatalog.swift
// Layer: Tests (support)
// Purpose: The deterministic source of the French catalogues. Every entry here is derived — from the campaign, from
// the enums, from the call sites written in the app — and not one French sentence of the corpus is transcribed by
// hand. The same code that writes the catalogues is the code that verifies them, so a catalogue can never quietly
// drift away from the app it is supposed to describe

import Foundation
@testable import Iris

/// One entry of a String Catalog: what it is called, what it says in French, and what a translator needs to know.
struct CatalogEntry: Hashable, Comparable {
    let key: String
    let french: String
    let comment: String
    /// True when the catalogue declares a plural variation on the first argument of the format.
    let isPluralized: Bool
    /// The English, when this key has been translated. Nil is the normal state of a sentence still waiting, and it is
    /// never filled in by guesswork.
    let english: String?
    /// The English singular of a counted entry. French holds one wording at every count; English does not.
    let englishOne: String?

    init(_ key: String, _ french: String, _ comment: String, pluralized: Bool = false,
         english: String? = nil, englishOne: String? = nil) {
        self.key = key
        self.french = french
        self.comment = comment
        self.isPluralized = pluralized
        self.english = english
        self.englishOne = englishOne
    }

    static func < (lhs: CatalogEntry, rhs: CatalogEntry) -> Bool { lhs.key < rhs.key }
}

enum LocalizationCatalog {
    // MARK: - Where the two catalogues live

    static var projectRoot: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()
            .deletingLastPathComponent().deletingLastPathComponent()
    }

    static func url(table: String) -> URL {
        projectRoot.appendingPathComponent("Resources/\(table).xcstrings")
    }

    // MARK: - Gameplay: generated from the campaign

    /// Chapters, levels, elements, marks and every contextual instruction, read from the corpus that owns them.
    static var gameplayEntries: [CatalogEntry] {
        var entries: [CatalogEntry] = []

        for chapter in Campaign.chapters {
            let where_ = "chapter \(chapter.numeral) (\(chapter.number) of \(Campaign.chapters.count))"
            entries.append(CatalogEntry(CampaignText.key(chapter: chapter.number, .name), chapter.name,
                                        "Name of \(where_). Chapter names are short, lowercase and evocative — they name a "
                                        + "movement of the eyes, not a place. Not a sentence, no final period."))
            entries.append(CatalogEntry(CampaignText.key(chapter: chapter.number, .principle), chapter.principle,
                                        "The single line that says what \(where_) teaches. Shown on the chapter card. "
                                        + "It states a principle, never an instruction to the player."))
        }

        for level in Campaign.levels {
            let chapter = Campaign.chapter(of: level)
            let where_ = "level \(chapter?.numeral ?? "?")-\(level.index)"
            entries.append(CatalogEntry(CampaignText.key(level: level.id, .title), level.title,
                                        "Title of \(where_). Short, lowercase, evocative; names what the eyes do. "
                                        + "Not an instruction, no final period."))
            entries.append(CatalogEntry(CampaignText.key(level: level.id, .principle), level.principle,
                                        "What \(where_) is about, in one line, shown before the level starts. "
                                        + "States the idea; the instructions are the hints."))
            for hint in level.hints {
                entries.append(CatalogEntry(HintText.key(level: level.id, trigger: hint.trigger), hint.text,
                                            "Instruction shown during \(where_) when \(Self.describe(hint.trigger)). "
                                            + "Read mid-play, while the player is looking at something else: keep it "
                                            + "short, calm, and addressed to the player."))
            }
            if let help = level.oculo?.help {
                entries.append(CatalogEntry(HintText.oculoHelpKey(level: level.id), help,
                                            "Late help for \(where_), shown when the player is still on the same "
                                            + "oculomotor sequence after a while. Encouraging, never corrective."))
            }
        }

        for element in GameElement.allCases {
            entries.append(CatalogEntry(CampaignText.key(element: element, .name), element.name,
                                        "Name of the game element `\(element.rawValue)`, as the carnet lists it. "
                                        + "Iris names its own things: keep the poetry, do not translate it into a "
                                        + "generic game term."))
            entries.append(CatalogEntry(CampaignText.key(element: element, .summary), element.summary,
                                        "What the element `\(element.rawValue)` does, in one line, in the carnet. "
                                        + "Describes behaviour the player can verify on screen."))
        }

        for eclat in Eclat.allCases {
            entries.append(CatalogEntry(CampaignText.key(eclat: eclat, .title), eclat.title,
                                        "Name of the mark `\(eclat.rawValue)`, one of the three a level can award."))
            entries.append(CatalogEntry(CampaignText.key(eclat: eclat, .condition), eclat.condition,
                                        "What earns the mark `\(eclat.rawValue)`. FUNCTIONAL: this is a promise the "
                                        + "game keeps exactly. Translate the condition precisely — not more generously, "
                                        + "not more strictly — or the player will believe a rule the engine does not apply."))
        }

        for (help, french) in Self.genericHelpFrench {
            entries.append(CatalogEntry(HintText.key(generic: help), french,
                                        "Late help shown in any level that names none of its own, chosen by the shape "
                                        + "of the level (`\(help.rawValue)`). Generic on purpose: it must fit every "
                                        + "level of that shape."))
        }

        return entries.sorted()
    }

    /// The four sentences the engine synthesises, taken from the engine itself rather than copied out of it:
    /// `HintTracker` lives in a frozen file, so it is asked, not read.
    static var genericHelpFrench: [(HintText.GenericHelp, String)] {
        var found: [(HintText.GenericHelp, String)] = []
        for help in HintText.GenericHelp.allCases {
            guard let level = Campaign.levels.first(where: { HintText.genericHelp(for: $0) == help && $0.oculo?.help == nil })
            else { continue }
            var tracker = HintTracker.forLevel(level)
            tracker.observe(events: [], elapsed: 46)
            if let sentence = tracker.current { found.append((help, sentence)) }
        }
        return found
    }

    /// A trigger, said in words a translator can use.
    static func describe(_ trigger: HintTrigger) -> String {
        switch trigger {
        case .start: "the level opens"
        case let .afterSeconds(seconds): "\(Int(seconds)) seconds have passed without the level being finished"
        case .firstIntrusion: "something enters the playfield for the first time"
        case .firstHold: "the player holds their gaze steady for the first time"
        case .firstValidation: "the first target is validated"
        case .firstLoss: "the player loses something for the first time"
        case .attentionLeftField: "the gaze leaves the useful area"
        case .veilleuseLow: "the veilleuse is running low"
        case .braiseLit: "a braise catches"
        case .braiseFlared: "a braise flares up"
        case .twinsLinked: "the two twins are linked"
        case .firstCarried: "something is carried for the first time"
        case .firstWake: "something wakes for the first time"
        case .firstSwallow: "something is swallowed for the first time"
        case .firstBalise: "the first balise wakes"
        case .balisesCompleted: "every balise is awake"
        case .firstOculoSuccess: "the first oculomotor target is reached"
        case .firstOculoMiss: "the first oculomotor target is missed"
        case .oculoCompleted: "the oculomotor sequence is complete"
        case let .oculoStageCompleted(stage): "stage \(stage) of the oculomotor sequence is complete"
        case let .oculoSuccessInStage(stage, ordinal): "target \(ordinal) of oculomotor stage \(stage) is reached"
        }
    }

    // MARK: - Interface: generated from the call sites and the enums

    /// Every `IrisText.interface` call written in the app, plus the identities the hinges build case by case.
    static func interfaceEntries(calls: [(path: String, key: String, french: String)]) -> [CatalogEntry] {
        var byKey: [String: String] = [:]
        for call in calls { byKey[call.key] = call.french }

        var entries = byKey.map { CatalogEntry($0.key, $0.value, InterfaceComments.comment(for: $0.key, french: $0.value),
                                               pluralized: InterfaceComments.pluralKeys.contains($0.key)) }

        for mode in GazeAssistanceMode.allCases {
            entries.append(CatalogEntry(GazeAssistanceText.key(.title, for: mode), mode.title,
                                        "Settings and pause. Name of the gaze-assistance mode `\(mode.rawValue)`, "
                                        + "which decides how visible the gaze marker is during play."))
            entries.append(CatalogEntry(GazeAssistanceText.key(.summary, for: mode), mode.summary,
                                        "Settings. What the `\(mode.rawValue)` gaze-assistance mode does, read by a "
                                        + "player who has time to read. FUNCTIONAL: describes what the marker actually does."))
            entries.append(CatalogEntry(GazeAssistanceText.key(.compact, for: mode), mode.compactSummary,
                                        "Pause panel. The `\(mode.rawValue)` mode in two or three words, for a player "
                                        + "mid-level who must recognise it at a glance. Keep it very short."))
        }

        for kind in ReadinessCheckKind.allCases {
            entries.append(CatalogEntry(GazeReadinessText.titleKey(for: kind), kind.title,
                                        "Gaze setup. Name of the readiness check `\(kind.rawValue)`, listed before "
                                        + "calibration. FUNCTIONAL: names a real hardware or signal condition."))
        }

        for action in [HomeSummary.Action.begin, .resume, .replay] {
            let summary = HomeSummary(action: action, detail: nil, eclats: 0, maxEclats: 0)
            entries.append(CatalogEntry(HomeText.key(for: action), summary.primaryTitle,
                                        "Threshold screen. The main button when the player's state is `\(HomeText.token(for: action))`. "
                                        + "One or two words; it is the largest control on the screen."))
        }

        for sheet in AppSheet.allCases {
            entries.append(CatalogEntry(NavigationText.key(sheet: sheet), sheet.title,
                                        "Navigation. Title of the `\(sheet.rawValue)` sheet. RESERVED: not read at "
                                        + "runtime yet — its only display site is a frozen file. Translate it anyway."))
        }

        for destination in AppDestination.allCases {
            entries.append(CatalogEntry(NavigationText.key(destination: destination), destination.title,
                                        "Navigation. Tab bar label for `\(destination.rawValue)`. RESERVED: not read "
                                        + "at runtime yet — the tab bar is drawn in a frozen file. Translate it anyway; "
                                        + "a tab label must stay very short."))
        }

        return entries.sorted()
    }

    // MARK: - Reading and writing the catalogue

    static func read(table: String) throws -> [CatalogEntry] {
        let root = try JSONSerialization.jsonObject(with: try Data(contentsOf: url(table: table))) as? [String: Any] ?? [:]
        let strings = root["strings"] as? [String: Any] ?? [:]
        return strings.compactMap { key, raw -> CatalogEntry? in
            guard let entry = raw as? [String: Any],
                  let localizations = entry["localizations"] as? [String: Any],
                  let french = localizations["fr"] as? [String: Any]
            else { return nil }
            let englishRoot = localizations["en"] as? [String: Any]
            var english = (englishRoot?["stringUnit"] as? [String: Any])?["value"] as? String
            var englishOne: String?
            if let plural = ((englishRoot?["variations"] as? [String: Any])?["plural"] as? [String: Any]) {
                english = ((plural["other"] as? [String: Any])?["stringUnit"] as? [String: Any])?["value"] as? String
                englishOne = ((plural["one"] as? [String: Any])?["stringUnit"] as? [String: Any])?["value"] as? String
            }
            if let unit = french["stringUnit"] as? [String: Any], let value = unit["value"] as? String {
                return CatalogEntry(key, value, entry["comment"] as? String ?? "", english: english, englishOne: englishOne)
            }
            guard let variations = french["variations"] as? [String: Any],
                  let plural = variations["plural"] as? [String: Any],
                  let other = plural["other"] as? [String: Any],
                  let unit = other["stringUnit"] as? [String: Any],
                  let value = unit["value"] as? String
            else { return nil }
            return CatalogEntry(key, value, entry["comment"] as? String ?? "", pluralized: true, english: english, englishOne: englishOne)
        }.sorted()
    }

    // MARK: - English, attached only where the classification allows it

    /// Puts the English of EN-4A on the entries cleared for it. A sentence deferred to EN-5 is left in French, and a
    /// reserved key is translated only when its words are not deferred elsewhere. A translation offered for a key the
    /// rule has not cleared is dropped here rather than written: the catalogue cannot become a way around the rule.
    static func attachEnglish(to entries: [CatalogEntry], table: String,
                              classes: [String: LocalizationClass], deferredFrench: Set<String>) -> [CatalogEntry] {
        entries.map { entry in
            let category = classes["\(table)|\(entry.key)"]
            let cleared: Bool
            switch category {
            case .nonSensitive: cleared = true
            case .reserved: cleared = LocalizationClassification.mayTranslate(key: entry.key, french: entry.french,
                                                                              deferredFrench: deferredFrench)
            default: cleared = false
            }
            // EN-5 writes the sentences the rule had deferred; its table and EN-4C's never overlap.
            if let english = EnglishTranslationsEN5.byKey[entry.key] {
                let plural = EnglishTranslationsEN5.plurals[entry.key]
                return CatalogEntry(entry.key, entry.french, entry.comment, pluralized: entry.isPluralized,
                                    english: plural?.other ?? english, englishOne: plural?.one)
            }
            guard cleared, let english = EnglishTranslations.byKey[entry.key] else { return entry }
            return CatalogEntry(entry.key, entry.french, entry.comment, pluralized: entry.isPluralized, english: english)
        }
    }

    /// Every French sentence that is waiting for EN-5, wherever it appears.
    static func deferredFrench(in classes: [String: LocalizationClass], entries: [(String, CatalogEntry)]) -> Set<String> {
        Set(entries.filter { classes["\($0.0)|\($0.1.key)"] == .sensitiveEN5 }.map(\.1.french))
    }

    /// Which languages each key carries. The measure EN-4 will be judged on.
    static func languages(table: String) throws -> [String: Set<String>] {
        let root = try JSONSerialization.jsonObject(with: try Data(contentsOf: url(table: table))) as? [String: Any] ?? [:]
        let strings = root["strings"] as? [String: Any] ?? [:]
        return strings.reduce(into: [:]) { result, pair in
            let localizations = (pair.value as? [String: Any])?["localizations"] as? [String: Any] ?? [:]
            result[pair.key] = Set(localizations.keys)
        }
    }

    /// The catalogue as Xcode writes it: sorted keys, two-space indent, French only.
    static func json(for entries: [CatalogEntry]) throws -> Data {
        var strings: [String: Any] = [:]
        for entry in entries {
            var french: [String: Any]
            if entry.isPluralized {
                let unit: [String: Any] = ["stringUnit": ["state": "translated", "value": entry.french]]
                // Both categories carry the very same French. French would say « 1 éclat », but that sentence has been
                // validated and photographed as it stands: this phase does not change a character of it. The plural
                // slot exists so English — and, the day someone decides to, French — can be written without moving a key.
                french = ["variations": ["plural": ["one": unit, "other": unit]]]
            } else {
                french = ["stringUnit": ["state": "translated", "value": entry.french]]
            }
            var localizations: [String: Any] = ["fr": french]
            if let english = entry.english {
                if let one = entry.englishOne {
                    localizations["en"] = ["variations": ["plural": [
                        "one": ["stringUnit": ["state": "translated", "value": one]],
                        "other": ["stringUnit": ["state": "translated", "value": english]],
                    ]]]
                } else {
                    localizations["en"] = ["stringUnit": ["state": "translated", "value": english]]
                }
            }
            strings[entry.key] = ["comment": entry.comment, "extractionState": "manual",
                                  "localizations": localizations]
        }
        let root: [String: Any] = ["sourceLanguage": "fr", "strings": strings, "version": "1.0"]
        return try JSONSerialization.data(withJSONObject: root,
                                          options: [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes])
    }
}
