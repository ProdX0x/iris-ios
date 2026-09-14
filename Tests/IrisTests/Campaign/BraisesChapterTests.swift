// BraisesChapterTests.swift
// Layer: Tests
// Purpose: Chapter XI, braises: every braise of the campaign carries the frozen, human-validated tuning A; the chapter's
// structure; and the proof that a player who never warms a braise cannot finish any of its levels

import Foundation
import Testing
@testable import Iris

@Suite("Chapter XI braises")
struct BraisesChapterTests {
    private let bounds = CampaignBot.referenceBounds

    private var chapter: ChapterDefinition {
        guard let chapter = Campaign.chapter(number: 11) else { preconditionFailure("chapter XI missing") }
        return ChapterDefinition(number: chapter.number, name: chapter.name, principle: chapter.principle, ambientFrequency: chapter.ambientFrequency,
                                 theme: chapter.theme, levels: chapter.levels.filter(\.gatesProgression))
    }

    @Test("every braise of the chapter is the validated tuning A, byte for byte")
    func frozenTuning() {
        let expected = BraiseDefinition(chargeRadius: 0.22, releaseRadius: 0.28, heatDuration: 0.9, coolDuration: 30,
                                        acceptHeat: 0.5, releaseHeat: 0.4, flareHeat: 0.85, flareAttention: 1.5, initialHeat: 0)
        #expect(BraiseDefinition.prototype == expected)
        for level in chapter.levels {
            for lueur in level.lueurs where lueur.braise != nil {
                #expect(lueur.braise == expected, "\(level.id) braise tuning drifted from A")
            }
        }
    }

    @Test("structure: chapter XI has six levels, each with at least one braise, the discovery level alone with one")
    func structure() {
        #expect(Array(Campaign.expansionChapters.map(\.number).prefix(5)) == [7, 8, 9, 10, 11])
        #expect(Campaign.expansionChapters.count >= 5)
        #expect(chapter.name == "braises" && chapter.theme == .braises && chapter.numeral == "XI")
        #expect(chapter.levels.map(\.id) == ["11-1", "11-2", "11-3", "11-4", "11-5", "11-6"])
        #expect(chapter.levels[0].introduces == [.braise] && chapter.levels[0].lueurs.count == 1)
        for level in chapter.levels {
            #expect(level.hasBraises && level.elementKinds.contains(.braise), "\(level.id)")
            #expect((1...3).contains(level.lueurs.count), "\(level.id)")
            #expect(level.hold == 0.75 && (0.40...0.52).contains(level.zone) && (1.6...3.2).contains(level.repulsionForce), "\(level.id)")
            #expect(level.elementKinds.count <= 3, "\(level.id)")
            #expect(level.lueurs.allSatisfy { !$0.isTwin }, "\(level.id)")
            let resolved = LevelResolver.resolve(level, in: bounds)
            #expect(resolved.environment.braises.count == level.lueurs.filter { $0.braise != nil }.count, "\(level.id)")
        }
    }

    @Test("necessity: the player whose gaze never comes near (avoidance) cannot finish any level, since a cold braise never opens its iris; the guided player can")
    func necessity() {
        for level in chapter.levels {
            #expect(!CampaignMeasurements.of(level).avoidance.completed, "\(level.id) finished by avoidance")
            let solved = CampaignMeasurements.of(level).guided.allSatisfy(\.completed)
            #expect(solved, "\(level.id) not solved by the guided player")
        }
    }

    @Test("a cold braise in a level of the chapter keeps its iris closed and does not drift until warmed")
    func coldStart() {
        let level = chapter.levels[0]
        let resolved = LevelResolver.resolve(level, in: bounds)
        var session = resolved.makeSession(noiseSources: [SilentNoise()])
        session.placeGaze(at: Vector2(x: 20, y: 830))
        let start = session.targets[0].position
        for _ in 0..<180 { _ = session.advance(by: 1.0 / 60.0) }
        #expect(session.targets[0].position == start)
        #expect(!session.isIrisOpen(for: session.targets[0]))
        #expect(session.braises[0]?.isLit == false)
    }
}
