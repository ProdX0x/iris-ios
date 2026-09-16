// OculoAbsenceTests.swift
// Layer: Tests
// Purpose: Chapter IX final « l'absence »: a held presence, an answer after a gap or during an overlap; leaving for
// the answer wins, never leaving, leaving too early, the centre and random gazes never do; misses repeat the trial

import Foundation
import Testing
@testable import Iris

@Suite("Chapter IX final: absence")
struct OculoAbsenceTests {
    private typealias Support = OculoStageTestSupport
    private var level: LevelDefinition { Campaign.finalEchos }

    private var absence: AbsenceStageState? {
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        if case let .absence(state)? = resolved.environment.oculo?.current { return state }
        return nil
    }

    private static func state(_ session: GameSession) -> AbsenceStageState? {
        if case let .absence(state)? = session.oculo?.current { return state }
        return nil
    }

    @Test("structure: level 9-7 is the optional final of chapter IX; eight chained trials alternate gap and overlap")
    func structure() throws {
        let chapter = try #require(Campaign.chapter(number: 9))
        #expect(chapter.levels.count == 7 && chapter.levels.last?.id == "9-7")
        #expect(Campaign.level(id: "9-7") == level && !level.gatesProgression && level.introduces == [.absence])
        let state = try #require(absence)
        #expect(state.trials.count == 8)
        for index in state.trials.indices {
            #expect(state.trials[index].mode == (index.isMultiple(of: 2) ? .gap : .overlap))
            if index > 0 { #expect(state.trials[index].from == state.trials[index - 1].to, "trial \(index) does not start where the last answer was") }
        }
        for i in state.places.indices {
            #expect((0.15...0.85).contains(state.places[i].x / 393) && (0.12...0.88).contains(state.places[i].y / 852))
            for j in state.places.indices where j > i {
                #expect(state.places[i].distance(to: state.places[j]) > state.releaseRadius * 1.3)
            }
        }
    }

    @Test("leaving for the answer wins every trial, without a miss")
    func transferring() {
        let run = Support.run(level, seconds: 60, policy: Support.oracle)
        #expect(run.completedSequence && run.successes == 8 && run.misses == 0 && !run.session.areLueursLatent)
    }

    @Test("ablations: never leaving the first presence, going to the answer's place too early, the centre and random gazes never complete")
    func ablations() throws {
        let initial = try #require(absence)
        let firstPlace = initial.places[initial.trials[0].from]
        let staying = Support.run(level, seconds: 60) { _, _, _ in firstPlace }
        #expect(!staying.completedSequence && staying.successes == 0 && staying.misses >= 3)
        let early = Support.run(level, seconds: 60) { _, session, _ in
            Self.state(session)?.second ?? Vector2(x: 30, y: 830)
        }
        #expect(!early.completedSequence && early.successes == 0, "without holding the presence, no answer ever comes")
        let centre = Support.run(level, seconds: 60, policy: Support.centre)
        #expect(!centre.completedSequence && centre.successes == 0)
        for seed in 1...3 {
            #expect(!Support.run(level, seconds: 60, noise: true, seed: seed, policy: Support.randomGaze).completedSequence, "seed \(seed)")
        }
    }

    @Test("the hold resets when the gaze leaves; a gap hides the presence before the answer, an overlap keeps it; a late answer is a miss and the trial starts over")
    func mechanics() throws {
        var state = try #require(absence)
        var t = 0.0
        func step(_ gaze: Vector2, _ seconds: Double = 0.05) -> [OculoChange] {
            t += seconds
            return state.update(OculoInput(seconds: seconds, gaze: gaze, gazeActive: true, head: nil, elapsed: t)).changes
        }
        let first = try #require(state.first)
        let second = try #require(state.second)
        for _ in 0..<6 { _ = step(first) }
        _ = step(Vector2(x: 30, y: 830))
        #expect(state.holdTime == 0 && state.isHolding)
        for _ in 0..<11 { _ = step(first) }
        guard case .gap = state.phase else {
            Issue.record("expected the gap of trial 1, got \(state.phase)")
            return
        }
        #expect(state.visibility(at: t + state.gap * 0.9).first < 0.2 && state.visibility(at: t).second == 0)
        for _ in 0..<7 { _ = step(first) }
        guard case .answer = state.phase else {
            Issue.record("expected the answer")
            return
        }
        #expect(state.visibility(at: t + 0.2).first == 0 && state.visibility(at: t + 0.2).second == 1, "gap trial: only the answer")
        var changes: [OculoChange] = []
        for _ in 0..<6 { changes += step(second) }
        #expect(changes == [.success] && state.trialIndex == 1 && state.isHolding)
        for _ in 0..<11 { _ = step(second) }
        guard case .answer = state.phase else {
            Issue.record("expected the overlap answer")
            return
        }
        #expect(state.visibility(at: t + 0.2).first == 1, "overlap trial: the presence still sings")
        var late: [OculoChange] = []
        for _ in 0..<45 { late += step(second) }
        #expect(late == [.miss] && state.trialIndex == 1 && state.timeouts == 1)
    }

    @Test("guided bot wins, avoidance and off-screen never; the scene opens on one held presence")
    func botsAndScene() throws {
        let guided = (1...3).map { CampaignBot(definition: level, policy: .guided, seed: $0).run(maxSeconds: 90) }
        let solved = guided.allSatisfy(\.completed)
        #expect(solved, "guided \(guided.map(\.time))")
        #expect(!CampaignBot(definition: level, policy: .avoidance).run(maxSeconds: 60).completed)
        #expect(!CampaignBot(definition: level, policy: .offScreen).run(maxSeconds: 30).completed)
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        var session = resolved.makeSession(noiseSources: [SilentNoise(), SilentNoise()])
        session.placeGaze(at: Vector2(x: 30, y: 830))
        _ = session.advance(by: Support.frame)
        let snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, marker: .hidden, diagnostics: nil)
        let presences = try #require(snapshot.oculo?.elements.filter { $0.role == .presence })
        let held = presences.filter { $0.isActive && $0.intensity == 1 }.count
        #expect(presences.count == 1 && held == 1)
    }
}
