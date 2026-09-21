// LevelResult.swift
// Layer: Presentation
// Purpose: What the result screen shows after a level: measurements, éclats and what comes next

import Foundation

struct LevelResult: Hashable, Sendable {
    let levelID: String
    let outcome: LevelOutcome
    let earned: Set<Eclat>
    let newlyEarned: Set<Eclat>
    let isNewBestTime: Bool
    let hasNextLevel: Bool
    let isChapterEnd: Bool
    let isCampaignEnd: Bool

    init(levelID: String, outcome: LevelOutcome, earned: Set<Eclat>, newlyEarned: Set<Eclat>, isNewBestTime: Bool,
         hasNextLevel: Bool, isChapterEnd: Bool, isCampaignEnd: Bool) {
        self.levelID = levelID
        self.outcome = outcome
        self.earned = earned
        self.newlyEarned = newlyEarned
        self.isNewBestTime = isNewBestTime
        self.hasNextLevel = hasNextLevel
        self.isChapterEnd = isChapterEnd
        self.isCampaignEnd = isCampaignEnd
    }

    var primaryTitle: String {
        if isCampaignEnd { return IrisText.interface("result.seeEnding.action", french: "Voir la fin") }
        if !hasNextLevel { return IrisText.interface("common.chapters", french: "Chapitres") }
        if isChapterEnd { return IrisText.interface("result.nextChapter.action", french: "Chapitre suivant") }
        return IrisText.interface("common.next", french: "Suivant")
    }
}
