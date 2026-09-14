// ConstellationTests.swift
// Layer: Tests
// Purpose: Chapter XII, constellation: the finale combines at least two expansion ideas per level, ends the campaign on
// the last iris, and every level needs the player (avoidance fails) while the guided player finishes it

import Foundation
import Testing
@testable import Iris

@Suite("Chapter XII constellation")
struct ConstellationTests {
    private let bounds = CampaignBot.referenceBounds
    private let frame = 1.0 / 60.0

    private var chapter: ChapterDefinition {
        guard let chapter = Campaign.chapter(number: 12) else { preconditionFailure("chapter XII missing") }
        return ChapterDefinition(number: chapter.number, name: chapter.name, principle: chapter.principle, ambientFrequency: chapter.ambientFrequency,
                                 theme: chapter.theme, levels: chapter.levels.filter(\.gatesProgression))
    }

    private static let expansionKinds: Set<GameElement> = [.jumelles, .souffle, .dormeuse, .echo, .gouffre, .braise]

    @Test("structure: chapter XII closes the campaign with six levels, each weaving at least two expansion ideas, the finale three")
    func structure() {
        #expect(Campaign.expansionChapters.map(\.number) == [7, 8, 9, 10, 11, 12])
        #expect(Campaign.chapters.last?.name == "constellation" && chapter.theme == .constellation && chapter.numeral == "XII")
        #expect(chapter.levels.map(\.id) == ["12-1", "12-2", "12-3", "12-4", "12-5", "12-6"])
        #expect(Campaign.baseChapters.last?.levels.last?.id == "12-6" && Campaign.baseChapters.last?.levels.last?.title == "le dernier iris")
        #expect(Campaign.next(after: Campaign.levels[Campaign.levels.count - 1]) == nil)
        for level in chapter.levels {
            let ideas = level.elementKinds.intersection(Self.expansionKinds)
            #expect(ideas.count >= 2, "\(level.id) weaves \(ideas)")
            #expect((1...3).contains(level.lueurs.count), "\(level.id)")
            #expect(level.hold == 0.75 && (0.40...0.52).contains(level.zone) && (1.6...3.2).contains(level.repulsionForce), "\(level.id)")
            #expect(level.introduces.isEmpty, "\(level.id) introduces nothing new: everything was met before")
        }
        let finale = chapter.levels[5]
        #expect(finale.elementKinds.intersection(Self.expansionKinds).count >= 3)
        #expect(finale.hasTwins && finale.hasSleepers && finale.echo != nil && !finale.gouffres.isEmpty)
    }

    @Test("every idea of the finale was introduced earlier in the campaign, in order")
    func introductions() {
        var known: Set<GameElement> = []
        for level in Campaign.levels {
            for element in level.introduces {
                #expect(!known.contains(element), "\(level.id) reintroduces \(element)")
                known.insert(element)
            }
        }
        #expect(known.isSuperset(of: Self.expansionKinds))
        #expect(known.isSuperset(of: Set(GameElement.allCases).subtracting([.balise])) || known == Set(GameElement.allCases), "every Carnet entry is met somewhere")
    }

    @Test("necessity: no level of the finale is solved by avoidance; the guided player solves all of them")
    func necessity() {
        for level in chapter.levels {
            #expect(!CampaignMeasurements.of(level).avoidance.completed, "\(level.id) solved by avoidance")
            let solved = CampaignMeasurements.of(level).guided.allSatisfy(\.completed)
            #expect(solved, "\(level.id) not solved by the guided player")
        }
    }

    @Test("the rendez-vous of twins breathes an echo from their meeting point, which wakes a sleeper within reach")
    func twinsEcho() {
        let level = LevelDefinition(chapter: 12, index: 99, title: "staged", principle: "", zone: 0.46, noise: 0,
                                    lueurs: [LueurDefinition(start: Campaign.pt(0.2, 0.2), iris: Campaign.pt(0.3, 0.3), twin: 2),
                                             LueurDefinition(start: Campaign.pt(0.8, 0.8), iris: Campaign.pt(0.7, 0.7), twin: 1),
                                             LueurDefinition(start: Campaign.pt(0.5, 0.62), iris: Campaign.pt(0.5, 0.9), asleep: true)],
                                    echo: .standard, par: LevelPar(time: 10, intrusions: 1))
        let resolved = LevelResolver.resolve(level, in: bounds)
        var session = resolved.makeSession(noiseSources: [SilentNoise(), SilentNoise(), SilentNoise()])
        var targets = session.targets
        targets[0].position = Vector2(x: 160, y: 400)
        targets[1].position = Vector2(x: 240, y: 430)
        session.replaceTargets(targets)
        session.placeGaze(at: Vector2(x: 20, y: 830))
        var events: [GameEvent] = []
        for _ in 0..<(6 * 60) { events += session.advance(by: frame) }
        #expect(events.contains(.twinsLinked(sequence: 1)) && events.contains(.targetValidated(sequence: 1)))
        #expect(events.contains(.echoEmitted(sequence: 1)), "the closed rendez-vous breathes")
        #expect(events.contains(.lueurWoken(sequence: 3)), "the sleeper 100 pt below the meeting point wakes")
        #expect(session.isComplete)
    }
}
