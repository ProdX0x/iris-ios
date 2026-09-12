// ChapterDefinition.swift
// Layer: Domain
// Purpose: A campaign chapter: numeral, name, principle, ambient tone, visual theme and its levels

import Foundation

struct ChapterDefinition: Hashable, Sendable, Identifiable {
    let number: Int
    let name: String
    let principle: String
    /// Root frequency of the chapter's ambient drone (Hz).
    let ambientFrequency: Double
    /// Visual identity; the historical chapters keep the default chambre noire.
    let theme: ChapterTheme
    let levels: [LevelDefinition]

    init(number: Int, name: String, principle: String, ambientFrequency: Double, theme: ChapterTheme = .chambreNoire,
         levels: [LevelDefinition]) {
        self.number = number
        self.name = name
        self.principle = principle
        self.ambientFrequency = ambientFrequency
        self.theme = theme
        self.levels = levels
    }

    var id: Int { number }

    var numeral: String {
        let numerals = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X",
                        "XI", "XII", "XIII", "XIV", "XV", "XVI", "XVII", "XVIII", "XIX", "XX"]
        if number == 0 { return "P" }
        return number >= 1 && number <= numerals.count ? numerals[number - 1] : "\(number)"
    }

    /// True for the six chapters of the original campaign, whose levels are frozen (see HistoricalCampaignFingerprintTests).
    var isHistorical: Bool { (1...6).contains(number) }
}
