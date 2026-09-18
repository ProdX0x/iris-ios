// IrisText.swift
// Layer: Presentation (shared)
// Purpose: The one place where a sentence Iris holds becomes the sentence Iris shows. A stable technical key carries
// the identity of a string; the French value the app already carries is the default, and remains the fallback for as
// long as no translation exists. Iris is French: this file adds a hinge, not a second language

import Foundation

enum IrisText {
    /// Screens, controls, messages: what the interface says about itself.
    static let interfaceTable = "Localizable"
    /// Chapters, levels, elements, marks: the sentences that tell a player what to do with their eyes. Their
    /// translation needs a reader who understands the gesture, which is why they live in a table of their own.
    static let gameplayTable = "Gameplay"

    /// Resolves a stable key against a table, falling back to the French the caller already holds.
    ///
    /// The French value is not optional and is never allowed to be empty on the way out: no screen can show a raw
    /// key, an empty line, or a language the player did not ask for. A missing key is not an error here — until a
    /// translation exists, missing is the normal case, and French is the answer.
    static func resolve(key: String, french: String, table: String) -> String {
        guard !french.isEmpty else { return french }
        let localized = Bundle.main.localizedString(forKey: key, value: french, table: table)
        return localized.isEmpty ? french : localized
    }

    /// Game content: chapters, levels, elements, marks.
    static func gameplay(_ key: String, french: String) -> String {
        resolve(key: key, french: french, table: gameplayTable)
    }

    /// Interface: everything the app says in its own voice.
    static func interface(_ key: String, french: String) -> String {
        resolve(key: key, french: french, table: interfaceTable)
    }
}
