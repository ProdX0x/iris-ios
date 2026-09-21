// InfoPlistLocalizationTests.swift
// Layer: Tests
// Purpose: The purpose strings iOS itself displays. They live in Config/Info.plist, outside both corpus catalogues,
// so every guarantee EN-4 to EN-7 established stops at their door — an English build showed a French camera alert
// until EN-8. What follows is structural: the set of languages is derived from the catalogues the app already
// ships rather than written down here, so a third language added to the interface fails this suite until the
// purpose strings follow it

import Foundation
import Testing
@testable import Iris

@Suite("Info.plist localization, phase EN-8")
struct InfoPlistLocalizationTests {
    /// The declared purpose strings, read from the plist the target actually builds with. Deriving the list instead
    /// of naming the camera key keeps a microphone or photo-library key added later from slipping through unlocalized.
    private static func purposeStrings() throws -> [String: String] {
        let url = LocalizationCatalog.projectRoot.appendingPathComponent("Config/Info.plist")
        let data = try Data(contentsOf: url)
        let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
        let entries = try #require(plist as? [String: Any], "Config/Info.plist is not a dictionary")
        return entries.reduce(into: [:]) { found, entry in
            guard entry.key.hasPrefix("NS"), entry.key.hasSuffix("UsageDescription"),
                  let sentence = entry.value as? String else { return }
            found[entry.key] = sentence
        }
    }

    /// `Resources/InfoPlist.xcstrings`, as JSON. The catalogue is the source; the `.strings` in the bundle is its
    /// compiled shadow, and the two are compared rather than one being trusted.
    private static func catalogue() throws -> [String: [String: String]] {
        let url = LocalizationCatalog.projectRoot.appendingPathComponent("Resources/InfoPlist.xcstrings")
        let data = try Data(contentsOf: url)
        let json = try JSONSerialization.jsonObject(with: data)
        let root = try #require(json as? [String: Any], "InfoPlist.xcstrings is not an object")
        let strings = try #require(root["strings"] as? [String: Any], "InfoPlist.xcstrings declares no strings")
        var read: [String: [String: String]] = [:]
        for (key, entry) in strings {
            let body = try #require(entry as? [String: Any], "\(key) is not an object")
            let localizations = try #require(body["localizations"] as? [String: Any], "\(key) has no localizations")
            var byLanguage: [String: String] = [:]
            for (language, localization) in localizations {
                let unit = try #require((localization as? [String: Any])?["stringUnit"] as? [String: Any],
                                        "\(key)/\(language) has no stringUnit")
                #expect(unit["state"] as? String == "translated", "\(key)/\(language) is not marked translated")
                byLanguage[language] = try #require(unit["value"] as? String, "\(key)/\(language) has no value")
            }
            read[key] = byLanguage
        }
        return read
    }

    /// The languages the app ships, taken from the interface catalogue rather than declared here.
    private static func shippedLanguages() throws -> Set<String> {
        let url = LocalizationCatalog.url(table: IrisText.interfaceTable)
        let json = try JSONSerialization.jsonObject(with: try Data(contentsOf: url))
        let root = try #require(json as? [String: Any], "the interface catalogue is not an object")
        let strings = try #require(root["strings"] as? [String: Any], "the interface catalogue declares no strings")
        var languages: Set<String> = []
        for entry in strings.values {
            guard let localizations = (entry as? [String: Any])?["localizations"] as? [String: Any] else { continue }
            languages.formUnion(localizations.keys)
        }
        #expect(languages.count > 1, "a single-language catalogue cannot police the purpose strings")
        return languages
    }

    @Test("1: every purpose string of the target is catalogued, in every language the app ships")
    func everyPurposeStringIsCatalogued() throws {
        let declared = try Self.purposeStrings()
        let catalogued = try Self.catalogue()
        let languages = try Self.shippedLanguages()

        #expect(!declared.isEmpty, "Config/Info.plist declares no purpose string at all")
        let orphans = Set(catalogued.keys).subtracting(declared.keys).sorted()
        let unlocalized = Set(declared.keys).subtracting(catalogued.keys).sorted()
        #expect(Set(catalogued.keys) == Set(declared.keys),
                "catalogued but not declared: \(orphans), declared but not catalogued: \(unlocalized)")

        for (key, byLanguage) in catalogued {
            #expect(Set(byLanguage.keys) == languages,
                    "\(key) is localized into \(byLanguage.keys.sorted()), the app ships \(languages.sorted())")
            for (language, sentence) in byLanguage {
                #expect(!sentence.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                        "\(key)/\(language) is empty")
            }
        }
    }

    @Test("2: the French catalogue value is the value the plist itself carries")
    func frenchMatchesThePlist() throws {
        // The base plist stays French, and iOS falls back to it whenever a localization is missing. Letting the two
        // drift would mean a French device could read one sentence and a French .lproj another.
        let declared = try Self.purposeStrings()
        let catalogued = try Self.catalogue()
        for (key, sentence) in declared {
            let byLanguage = try #require(catalogued[key], "\(key) is not catalogued")
            #expect(byLanguage["fr"] == sentence, "\(key): the plist and the French catalogue disagree")
        }
    }

    @Test("3: each language compiles an InfoPlist.strings holding exactly the catalogued sentences")
    func compiledArtefactMatchesTheCatalogue() throws {
        // Reading each .lproj directly, rather than asking Bundle.main, keeps the result independent of the language
        // the host happens to run in — the same reason test 13 of the English suite reads them this way.
        let catalogued = try Self.catalogue()
        for language in try Self.shippedLanguages().sorted() {
            let folder = try #require(Bundle.main.path(forResource: language, ofType: "lproj"),
                                      "the built app has no \(language).lproj")
            let file = URL(fileURLWithPath: folder).appendingPathComponent("InfoPlist.strings")
            #expect(FileManager.default.fileExists(atPath: file.path),
                    "\(language).lproj has no InfoPlist.strings — the catalogue is not in the target's resources")
            let plist = try PropertyListSerialization.propertyList(from: try Data(contentsOf: file),
                                                                  options: [], format: nil)
            let compiled = try #require(plist as? [String: String], "\(language)/InfoPlist.strings is not a dictionary")
            let expected = catalogued.compactMapValues { $0[language] }
            #expect(compiled == expected,
                    "\(language)/InfoPlist.strings holds \(compiled.keys.sorted()), the catalogue holds \(expected.keys.sorted())")
        }
    }

    @Test("4: the two languages say different things, and each resolves through the bundle iOS would use")
    func eachLanguageResolvesToItsOwnSentence() throws {
        // What iOS looks up when it draws the permission alert is this exact table in the localization it picked.
        // Asserting the lookup — not just the file — is what shows an English device would be answered in English.
        let catalogued = try Self.catalogue()
        for (key, byLanguage) in catalogued {
            var seen: Set<String> = []
            for (language, sentence) in byLanguage {
                let folder = try #require(Bundle.main.path(forResource: language, ofType: "lproj"),
                                          "the built app has no \(language).lproj")
                let bundle = try #require(Bundle(path: folder))
                let resolved = bundle.localizedString(forKey: key, value: "\u{0}", table: "InfoPlist")
                #expect(resolved == sentence, "\(language)/\(key) resolved to « \(resolved) »")
                seen.insert(resolved)
            }
            #expect(seen.count == byLanguage.count,
                    "\(key): two languages carry the same sentence — one of them was never translated")
        }
    }
}
