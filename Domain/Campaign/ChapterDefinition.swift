// ChapterDefinition.swift
// Layer: Domain
// Purpose: A campaign chapter: numeral, name, principle, ambient tone and its levels

import Foundation

struct ChapterDefinition: Hashable, Sendable, Identifiable {
    let number: Int
    let name: String
    let principle: String
    /// Root frequency of the chapter's ambient drone (Hz).
    let ambientFrequency: Double
    let levels: [LevelDefinition]

    init(number: Int, name: String, principle: String, ambientFrequency: Double, levels: [LevelDefinition]) {
        self.number = number
        self.name = name
        self.principle = principle
        self.ambientFrequency = ambientFrequency
        self.levels = levels
    }

    var id: Int { number }

    var numeral: String {
        let numerals = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"]
        return number >= 1 && number <= numerals.count ? numerals[number - 1] : "\(number)"
    }
}
