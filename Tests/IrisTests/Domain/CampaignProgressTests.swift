// CampaignProgressTests.swift
// Layer: Tests
// Purpose: Éclats, records and unlock rules of the campaign

import Foundation
import Testing
@testable import Iris

@Suite("CampaignProgress")
struct CampaignProgressTests {
    private let par = LevelPar(time: 20, intrusions: 3)

    private func level(_ chapter: Int, _ index: Int) -> LevelDefinition {
        LevelDefinition(chapter: chapter, index: index, title: "t", principle: "p",
                        lueurs: [LueurDefinition(start: NormalizedPoint(x: 0.5, y: 0.8), iris: NormalizedPoint(x: 0.5, y: 0.2))],
                        par: par)
    }

    @Test("éclats: atteint always, fluide under par time, serein without loss and within par intrusions")
    func eclats() {
        #expect(LevelOutcome(time: 30, intrusions: 9, losses: 2).eclats(par: par) == [.atteint])
        #expect(LevelOutcome(time: 19, intrusions: 9, losses: 0).eclats(par: par) == [.atteint, .fluide])
        #expect(LevelOutcome(time: 25, intrusions: 3, losses: 0).eclats(par: par) == [.atteint, .serein])
        #expect(LevelOutcome(time: 20, intrusions: 1, losses: 1).eclats(par: par) == [.atteint, .fluide])
        #expect(LevelOutcome(time: 10, intrusions: 0, losses: 0).eclats(par: par).count == 3)
    }

    @Test("records keep the union of éclats and the best values")
    func records() {
        var record = LevelRecord()
        record.register(LevelOutcome(time: 18, intrusions: 8, losses: 1), par: par)
        record.register(LevelOutcome(time: 26, intrusions: 2, losses: 0), par: par)

        #expect(record.completions == 2)
        #expect(record.bestTime == 18)
        #expect(record.fewestIntrusions == 2)
        #expect(record.eclats == [.atteint, .fluide, .serein])
    }

    @Test("levels unlock one after the other and the next level is the first open one not completed")
    func unlocking() {
        let campaign = [level(1, 1), level(1, 2), level(2, 1)]
        let chapter2 = ChapterDefinition(number: 2, name: "b", principle: "", ambientFrequency: 100, levels: [campaign[2]])
        var progress = CampaignProgress()

        #expect(progress.isUnlocked(campaign[0], in: campaign))
        #expect(!progress.isUnlocked(campaign[1], in: campaign))
        #expect(progress.nextLevel(in: campaign)?.id == "1-1")

        progress.register(LevelOutcome(time: 5, intrusions: 0, losses: 0), for: campaign[0])
        #expect(progress.isUnlocked(campaign[1], in: campaign))
        #expect(!progress.isUnlocked(chapter2, in: campaign))
        #expect(progress.nextLevel(in: campaign)?.id == "1-2")

        progress.register(LevelOutcome(time: 5, intrusions: 9, losses: 0), for: campaign[1])
        #expect(progress.isUnlocked(chapter2, in: campaign))
        progress.register(LevelOutcome(time: 5, intrusions: 0, losses: 0), for: campaign[2])
        #expect(progress.nextLevel(in: campaign) == nil)
        #expect(progress.completedCount(in: campaign) == 3)
        #expect(progress.eclatCount(in: campaign) == 8)
        #expect(abs(progress.totalPlayTime - 15) < 1e-9)
    }

    @Test("an unknown level is never unlocked and elements accumulate")
    func unknownAndElements() {
        var progress = CampaignProgress()
        #expect(!progress.isUnlocked(level(9, 9), in: [level(1, 1)]))
        progress.encounter([.courant, .voile])
        progress.encounter([.courant])
        #expect(progress.encounteredElements == [.courant, .voile])
    }
}
