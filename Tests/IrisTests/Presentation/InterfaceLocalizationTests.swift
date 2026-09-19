// InterfaceLocalizationTests.swift
// Layer: Tests
// Purpose: The interface now names its sentences instead of being named by them. Every migrated string carries a stable
// key, no key is a French phrase, one key never means two different sentences, the French rendered is the French the
// code holds, no frozen file was drawn into the hinge, and no translation has been slipped in

import Foundation
import Testing
@testable import Iris

@Suite("Interface localization")
struct InterfaceLocalizationTests {
    /// Project root, derived from this file's compile-time path (Tests/IrisTests/Presentation/...).
    private static var projectRoot: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()
            .deletingLastPathComponent().deletingLastPathComponent()
    }

    private static let sourceRoots = ["App","AR","Audio","Commerce","DesignSystem","Domain","Features","GameEngine","Haptics","Navigation"]

    /// Every `IrisText.interface("key", french: "…")` written in the app, as (file, key, French).
    /// The catalogue is built from the same scan, so the two can never describe different apps.
    static let callSites: [(path: String, key: String, french: String)] = {
        // No closing parenthesis in the pattern: a sentence with values carries arguments after its French, and
        // requiring `")` here is how twenty-six of them stayed invisible to the catalogue for one build.
        let pattern = /IrisText\.interface\(\s*"([A-Za-z0-9.]+)",\s*french: "((?:\\.|[^"\\])*)"/
        var found: [(String, String, String)] = []
        for base in sourceRoots {
            let directory = projectRoot.appendingPathComponent(base)
            let files = FileManager.default.enumerator(atPath: directory.path)?.allObjects as? [String] ?? []
            for relative in files.sorted() where relative.hasSuffix(".swift") {
                let path = "\(base)/\(relative)"
                guard let text = try? String(contentsOf: directory.appendingPathComponent(relative), encoding: .utf8) else { continue }
                for match in text.matches(of: pattern) {
                    found.append((path, String(match.output.1), String(match.output.2)))
                }
            }
        }
        return found
    }()

    /// Every file whose bytes a suite pins by SHA-256, wherever that suite lives. Scanning only one folder is how the
    /// six Navigation files frozen by the glass suite were missed once; the whole test tree is read now, and a path
    /// counts as frozen only when a digest sits right beside it.
    private static let frozenFiles: Set<String> = {
        let directory = projectRoot.appendingPathComponent("Tests/IrisTests")
        let files = FileManager.default.enumerator(atPath: directory.path)?.allObjects as? [String] ?? []
        var frozen: Set<String> = []
        let pattern = /"([A-Za-z]+\/[^"\n]+\.swift)"[\s,:]*\n?\s*"[0-9a-f]{64}"/
        for file in files where file.hasSuffix(".swift") {
            guard let text = try? String(contentsOf: directory.appendingPathComponent(file), encoding: .utf8) else { continue }
            for match in text.matches(of: pattern) { frozen.insert(String(match.output.1)) }
        }
        return frozen
    }()

    /// What the app actually ships: previews and DEBUG-only blocks removed, so a sentence that never reaches a player
    /// is never mistaken for one that does.
    private static func shippedLines(of source: String) -> [(number: Int, text: String)] {
        var kept: [(Int, String)] = []
        var debugDepth = 0
        var conditionalDepth = 0
        var previewBraces = 0
        var inPreview = false
        for (index, line) in source.components(separatedBy: "\n").enumerated() {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.hasPrefix("#if") {
                conditionalDepth += 1
                if debugDepth == 0, trimmed.contains("DEBUG") { debugDepth = conditionalDepth }
                continue
            }
            if trimmed.hasPrefix("#endif") {
                if debugDepth == conditionalDepth { debugDepth = 0 }
                conditionalDepth = max(0, conditionalDepth - 1)
                continue
            }
            if trimmed.hasPrefix("#Preview") { inPreview = true; previewBraces = 0 }
            if inPreview {
                previewBraces += line.filter { $0 == "{" }.count - line.filter { $0 == "}" }.count
                if previewBraces <= 0, trimmed.contains("}") { inPreview = false }
                continue
            }
            if debugDepth > 0 { continue }
            kept.append((index + 1, line))
        }
        return kept
    }

    /// Reads like French: an accent, or a word only French would put there.
    private static func readsAsFrench(_ text: String) -> Bool {
        if text.contains(where: { "éèêëàâçùûôîïœÉÈÀÇ".contains($0) }) { return true }
        let words = Set(text.lowercased().split(whereSeparator: { !$0.isLetter }).map(String.init))
        return !words.isDisjoint(with: ["le","la","les","un","une","des","du","de","vous","votre","pour",
                                        "avec","sans","dans","est","sur","et","ou","au","aux","ce","cette","que","qui"])
    }

    @Test("A: a key is an identifier, never a French phrase")
    func keysAreIdentifiers() throws {
        #expect(!Self.callSites.isEmpty, "no migrated interface string was found")
        let allowed = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.")
        for call in Self.callSites {
            #expect(call.key.unicodeScalars.allSatisfy { allowed.contains($0) }, "\(call.path): \(call.key)")
            #expect(!call.key.contains(" "), "\(call.path): \(call.key)")
            #expect(call.key.contains("."), "\(call.path): \(call.key) names no family")
            // A key may echo a word of the sentence — `settings.recalibrate.action` for « Recalibrer le regard » —
            // and that is the point: it names the role. What it must never be is the sentence itself.
            #expect(call.key != call.french, "\(call.path): the sentence is being used as its own key")
        }
    }

    @Test("B: one key always means one sentence")
    func keysAreConsistent() {
        var french: [String: String] = [:]
        for call in Self.callSites {
            if let existing = french[call.key] {
                #expect(existing == call.french, "\(call.key) carries two different sentences: « \(existing) » / « \(call.french) »")
            } else {
                french[call.key] = call.french
            }
        }
        #expect(french.count >= 150, "expected at least 150 interface identities, found \(french.count)")
    }

    @Test("C: with no translation, the French rendered is the French the code holds")
    func frenchIsUnchanged() {
        // A sentence carrying values is not asked for without them: a plural entry answers with its `%#@…@` template
        // until `String(format:)` has resolved it. Those are rendered, argument by argument, by the catalogue suite.
        for call in Self.callSites where !call.french.contains("%lld") && !call.french.contains("%@") {
            #expect(IrisText.interface(call.key, french: call.french) == call.french, "\(call.key)")
        }
    }

    @Test("D: a key nobody has translated falls back to its French, never to the key")
    func fallbackIsSafe() {
        let french = "Une phrase que personne n'a traduite."
        let resolved = IrisText.interface("interface.key.thatDoesNotExist", french: french)
        #expect(resolved == french)
        #expect(!resolved.hasPrefix("interface."))
        #expect(IrisText.gameplay("level.0-0.hint.nothing", french: french) == french)
    }

    @Test("E: no frozen file was drawn into the hinge")
    func frozenFilesStayOut() {
        for call in Self.callSites {
            #expect(!Self.frozenFiles.contains(call.path), "\(call.path) is frozen and now calls IrisText")
        }
        for helper in ["Features/Shared/IrisText.swift", "Features/Shared/CampaignText.swift",
                       "Features/Shared/HintText.swift", "Features/Shared/GazeReadinessText.swift"] {
            #expect(!Self.frozenFiles.contains(helper))
        }
    }

    @Test("F: no migrated sentence carries an interpolation")
    func noInterpolationWasMigrated() {
        for call in Self.callSites {
            #expect(!call.french.contains("\\("), "\(call.key) was migrated with an interpolation in it")
        }
    }

    @Test("G: the content keys are still addressable, and the hint correspondences intact")
    func contentKeysStillWork() {
        var keys: Set<String> = []
        for level in Campaign.levels {
            keys.insert(CampaignText.key(level: level.id, .title))
            keys.insert(CampaignText.key(level: level.id, .principle))
            for hint in level.hints { keys.insert(HintText.key(level: level.id, trigger: hint.trigger)) }
        }
        for chapter in Campaign.chapters {
            keys.insert(CampaignText.key(chapter: chapter.number, .name))
            keys.insert(CampaignText.key(chapter: chapter.number, .principle))
        }
        for element in GameElement.allCases {
            keys.insert(CampaignText.key(element: element, .name))
            keys.insert(CampaignText.key(element: element, .summary))
        }
        for eclat in Eclat.allCases {
            keys.insert(CampaignText.key(eclat: eclat, .title))
            keys.insert(CampaignText.key(eclat: eclat, .condition))
        }
        for help in HintText.GenericHelp.allCases { keys.insert(HintText.key(generic: help)) }
        #expect(keys.count >= 415, "expected at least 415 content keys, found \(keys.count)")
    }

    @Test("H: the readiness checks are identified by their kind and status, not by their words")
    func readinessKeysAreStructural() {
        for kind in ReadinessCheckKind.allCases {
            let title = GazeReadinessText.title(of: ReadinessCheck(kind: kind, status: .pending))
            #expect(title == kind.title, "\(kind) title changed")
            #expect(GazeReadinessText.titleKey(for: kind) == "gazeReadiness.check.\(kind.rawValue).title")
            for status in [ReadinessStatus.pending, .pass, .fail] {
                let check = ReadinessCheck(kind: kind, status: status, detail: "détail français")
                #expect(GazeReadinessText.detail(of: check) == "détail français")
                #expect(GazeReadinessText.detailKey(for: kind, status: status).hasPrefix("gazeReadiness.check.\(kind.rawValue)."))
            }
            #expect(GazeReadinessText.detail(of: ReadinessCheck(kind: kind, status: .pass)) == nil)
        }
    }

    @Test("J: the threshold's main action is identified by what it does, not by its word")
    func homeActionIsStructural() {
        for action in [HomeSummary.Action.begin, .resume, .replay] {
            let summary = HomeSummary(action: action, detail: nil, eclats: 0, maxEclats: 3)
            #expect(HomeText.primaryTitle(of: summary) == summary.primaryTitle, "\(action) no longer renders its French")
            #expect(HomeText.key(for: action) == "home.action.\(HomeText.token(for: action))")
            #expect(HomeText.key(for: action) != summary.primaryTitle)
        }
        #expect(Set([HomeSummary.Action.begin, .resume, .replay].map(HomeText.key(for:))).count == 3)
    }

    /// Hinges whose French is a lookup table rather than a call site. Every sentence in them is handed to `IrisText`
    /// under a key built from an identity — which this scanner, reading one expression at a time, cannot see. That
    /// those keys exist, carry French and English, and cover every message is proved key by key elsewhere:
    /// ReadinessDetailLocalizationTests A, B, C and G.
    private static let fallbackTables: Set<String> = ["Features/Shared/GazeReadinessText.swift"]

    @Test("K: every sentence the app shows outside the frozen files now has a key")
    func migrationIsComplete() throws {
        // Two nets, because one was not enough: a sentence that reads as French anywhere, and any literal sitting
        // where the interface draws words — that is what caught « Chapitres » and « Retour », which carry neither
        // accent nor article and had slipped through the first pass.
        let drawn = /(?:Text|DSButton|DSBadge|DSOverlayPanel|DSStatusRow|Label|Toggle|Button|Link|navigationTitle|accessibilityLabel|accessibilityHint|accessibilityValue)\s*\(\s*(?:title:\s*|label:\s*)?"((?:\\.|[^"\\])*)"/
        let named = /(?:title|label|subtitle|detail|message|caption|placeholder|hint|headline|summary|action|note|eyebrow)\s*:\s*"((?:\\.|[^"\\])*)"/
        let anyString = /"((?:\\.|[^"\\])*)"/
        // What is deliberately left behind, and why. Interpolated sentences are assembled at runtime and need a
        // grammar this migration does not introduce; a name, a copyright and the app's own name are not translated;
        // `contactTitle` is declared but displayed nowhere; « et » joins a list inside an interpolated sentence.
        let permitted: Set<String> = ["Stéphane SAULNIER", "© 2026 Stéphane SAULNIER", "Assistance", " et ", "iris"]
        var unrouted: [String] = []
        // Only the layers that draw. A Domain type may still hold its French — that sentence is the fallback a
        // hinge passes to `IrisText`, exactly as the readiness checks and the campaign do; what must never happen is
        // a screen putting those words on glass without a key. Test L proves each such hinge exists.
        for base in ["App", "Commerce", "DesignSystem", "Features", "Navigation"] {
            let directory = Self.projectRoot.appendingPathComponent(base)
            let files = FileManager.default.enumerator(atPath: directory.path)?.allObjects as? [String] ?? []
            for relative in files.sorted() where relative.hasSuffix(".swift") {
                let path = "\(base)/\(relative)"
                guard !Self.frozenFiles.contains(path), !Self.fallbackTables.contains(path),
                      let text = try? String(contentsOf: directory.appendingPathComponent(relative), encoding: .utf8)
                else { continue }
                var irisDepth = 0
                for line in Self.shippedLines(of: text) {
                    let code = line.text.components(separatedBy: "//")[0]
                    // An `IrisText` call can span several lines; its French sits on one of them. Follow the call to
                    // its closing parenthesis instead of judging one line at a time.
                    let wasInside = irisDepth > 0
                    if code.contains("IrisText.") || wasInside {
                        irisDepth += code.filter { $0 == "(" }.count - code.filter { $0 == ")" }.count
                        irisDepth = max(0, irisDepth)
                        continue
                    }
                    var suspects = code.matches(of: drawn).map { String($0.output.1) }
                    suspects += code.matches(of: named).map { String($0.output.1) }
                    suspects += code.matches(of: anyString).map { String($0.output.1) }.filter { Self.readsAsFrench($0) }
                    for sentence in suspects {
                        guard sentence.count > 1, !permitted.contains(sentence), !sentence.contains("\\("),
                              !sentence.hasPrefix("http"), !sentence.hasPrefix("mailto"),
                              sentence.contains(where: { $0.isLetter })
                        else { continue }
                        unrouted.append("\(path):\(line.number) « \(sentence) »")
                    }
                }
            }
        }
        #expect(unrouted.isEmpty, "shown without a key:\n\(Set(unrouted).sorted().joined(separator: "\n"))")
    }

    @Test("L: the assistance modes are identified by the mode, not by its sentence")
    func assistanceKeysAreStructural() {
        for mode in GazeAssistanceMode.allCases {
            #expect(GazeAssistanceText.title(of: mode) == mode.title)
            #expect(GazeAssistanceText.summary(of: mode) == mode.summary)
            #expect(GazeAssistanceText.compactSummary(of: mode) == mode.compactSummary)
            for facet in [GazeAssistanceText.Facet.title, .summary, .compact] {
                let key = GazeAssistanceText.key(facet, for: mode)
                #expect(key == "gazeAssistance.mode.\(mode.rawValue).\(facet.rawValue)")
                #expect(key != mode.title && key != mode.summary && key != mode.compactSummary)
            }
        }
        let keys = Set(GazeAssistanceMode.allCases.flatMap { mode in
            [GazeAssistanceText.Facet.title, .summary, .compact].map { GazeAssistanceText.key($0, for: mode) }
        })
        #expect(keys.count == GazeAssistanceMode.allCases.count * 3)
    }

    @Test("I: French is the source language, and no third language has appeared")
    func onlyExpectedLanguagesExist() throws {
        for name in ["Localizable", "Gameplay"] {
            let url = Self.projectRoot.appendingPathComponent("Resources/\(name).xcstrings")
            let catalogue = try #require(try JSONSerialization.jsonObject(with: try Data(contentsOf: url)) as? [String: Any])
            #expect(catalogue["sourceLanguage"] as? String == "fr")
            let strings = try #require(catalogue["strings"] as? [String: Any])
            for (key, entry) in strings {
                let localizations = try #require((entry as? [String: Any])?["localizations"] as? [String: Any])
                // EN-2 and EN-3 could say « French only ». Since EN-4A the non-sensitive interface also carries
                // English; which keys may is decided by rule, and proved in EnglishTranslationTests. Here: French
                // is never lost, and nothing but English has been added.
                #expect(localizations["fr"] != nil, "\(name): \(key) has lost its French")
                #expect(Set(localizations.keys).isSubset(of: ["fr", "en"]),
                        "\(name): \(key) carries a language Iris does not ship")
            }
        }
    }
}
