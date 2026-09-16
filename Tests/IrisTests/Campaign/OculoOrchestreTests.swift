// OculoOrchestreTests.swift
// Layer: Tests
// Purpose: Chapter XII final « l'orchestre du regard »: seven short passages of seven different gaze ideas, each
// lighting a star; the whole gaze repertoire plays the finale through, a single passive strategy never does

import Foundation
import Testing
@testable import Iris

@Suite("Chapter XII final: orchestre du regard")
struct OculoOrchestreTests {
    private typealias Support = OculoStageTestSupport
    private var level: LevelDefinition { Campaign.finalConstellation }

    private static func oracleHead(_ index: Int, _ session: GameSession) -> HeadPose? {
        session.oculo?.suggestedHead ?? .neutral
    }

    private static func stagesCompleted(_ run: Support.Run) -> Int {
        run.events.filter { if case .oculoStageCompleted = $0 { return true } else { return false } }.count
    }

    private static func kind(_ stage: OculoStageDefinition) -> String {
        switch stage {
        case .coeur: "coeur"
        case .fil: "fil"
        case .miroir: "miroir"
        case .etoiles: "etoiles"
        case .jardin: "jardin"
        case .croisement: "croisement"
        case .courant: "courant"
        case .absence: "absence"
        case .ancre: "ancre"
        case .tourner: "tourner"
        }
    }

    @Test("structure: level 12-7 closes the campaign as an optional final; seven short passages of seven different ideas and a constellation")
    func structure() throws {
        let chapter = try #require(Campaign.chapter(number: 12))
        #expect(chapter.levels.count == 7 && chapter.levels.last?.id == "12-7")
        #expect(Campaign.levels.last?.id == "12-7" && Campaign.next(after: level) == nil)
        #expect(Campaign.level(id: "12-7") == level && !level.gatesProgression && level.introduces == [.orchestre])
        let oculo = try #require(level.oculo)
        #expect(oculo.stages.count == 7 && Set(oculo.stages.map(Self.kind)).count == 7 && oculo.showsConstellation)
        for stage in oculo.stages {
            switch stage {
            case let .coeur(definition): #expect(definition.requirement <= 3)
            case let .absence(definition): #expect(definition.trials.count <= 2)
            case let .fil(definition): #expect(definition.requirement <= 4)
            case let .jardin(definition): #expect(definition.batches.count == 1)
            case let .etoiles(definition): #expect(definition.rounds.count == 1)
            case let .croisement(definition): #expect(definition.legs.count <= 2)
            case let .tourner(definition): #expect(definition.goal <= 2)
            case .miroir, .courant, .ancre: Issue.record("unexpected passage \(Self.kind(stage))")
            }
        }
    }

    @Test("the whole gaze repertoire plays the finale through: seven passages, then the twins fuse")
    func finale() {
        let run = Support.run(level, seconds: 120, head: Self.oracleHead, policy: Support.oracle)
        #expect(run.completedSequence && Self.stagesCompleted(run) == 7 && run.session.isComplete)
    }

    @Test("a single passive strategy never plays the finale through: the centre, a corner, random gazes")
    func ablations() {
        let centre = Support.run(level, seconds: 90, head: Self.oracleHead, policy: Support.centre)
        #expect(!centre.completedSequence && Self.stagesCompleted(centre) <= 1)
        let corner = Support.run(level, seconds: 90, head: Self.oracleHead, policy: Support.corner)
        #expect(!corner.completedSequence && Self.stagesCompleted(corner) == 0)
        for seed in 1...3 {
            #expect(!Support.run(level, seconds: 90, noise: true, seed: seed, head: Self.oracleHead, policy: Support.randomGaze).completedSequence, "seed \(seed)")
        }
    }

    @Test("each passage lights one more star; at the end all seven are linked and the constellation grows")
    func constellation() throws {
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        var session = resolved.makeSession(noiseSources: [SilentNoise(), SilentNoise()])
        var completed = 0
        var generator = LinearCongruentialGenerator(seed: 5)
        var radiusAtEnd: Double?
        for index in 0..<(120 * 60) {
            if let point = Support.oracle(index, session, &generator) { session.placeGaze(at: point) }
            session.ingestHeadPose(Self.oracleHead(index, session))
            let events = session.advance(by: Support.frame)
            let newly = events.filter { if case .oculoStageCompleted = $0 { return true } else { return false } }.count
            if newly > 0 {
                completed += newly
                let snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, marker: .hidden, diagnostics: nil)
                let lit = snapshot.oculo?.constellation.filter(\.isLit).count ?? -1
                #expect(lit == completed, "after \(completed) passages")
            }
            if events.contains(.oculoCompleted) {
                let snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, marker: .hidden, diagnostics: nil)
                radiusAtEnd = snapshot.oculo?.constellation.first.map { $0.position.distance(to: Support.bounds.center) }
            }
            if session.isComplete { break }
        }
        #expect(completed == 7)
        let final = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, marker: .hidden, diagnostics: nil)
        let stars = try #require(final.oculo?.constellation)
        let lit = stars.filter { $0.isLit }.count
        #expect(stars.count == 7 && lit == 7 && final.oculo?.constellationLinks?.isClosed == true)
        let grown = stars.first.map { $0.position.distance(to: Support.bounds.center) } ?? 0
        #expect(grown > (radiusAtEnd ?? .infinity), "the constellation opens out once complete")
    }

    @Test("without head data (simulator) the finale still plays through, the last passage by the eyes alone")
    func withoutHead() {
        let run = Support.run(level, seconds: 150, policy: Support.oracle)
        #expect(run.completedSequence && Self.stagesCompleted(run) == 7)
    }

    @Test("guided bot plays the finale through, avoidance and off-screen never")
    func bots() {
        let guided = (1...3).map { CampaignBot(definition: level, policy: .guided, seed: $0).run(maxSeconds: 90) }
        let solved = guided.allSatisfy(\.completed)
        #expect(solved, "guided \(guided.map(\.time))")
        #expect(!CampaignBot(definition: level, policy: .avoidance).run(maxSeconds: 60).completed)
        #expect(!CampaignBot(definition: level, policy: .offScreen).run(maxSeconds: 30).completed)
    }
}
