// OculoCoeurTests.swift
// Layer: Tests
// Purpose: Chapter II final « le cœur de verre »: the heart warms only under a gaze that stays, cools when it leaves,
// loses warmth to every spark the gaze visits; a steady gaze wins, a wandering or spark-chasing gaze never does

import Foundation
import Testing
@testable import Iris

@Suite("Chapter II final: cœur de verre")
struct OculoCoeurTests {
    private typealias Support = OculoStageTestSupport
    private var level: LevelDefinition { Campaign.finalPartage }

    private var coeur: CoeurStageState? {
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        if case let .coeur(state)? = resolved.environment.oculo?.current { return state }
        return nil
    }

    @Test("structure: level 2-6 is the optional final of chapter II, introduces the heart, releases two lueurs")
    func structure() throws {
        let chapter = try #require(Campaign.chapter(number: 2))
        #expect(chapter.levels.map(\.id) == ["2-1", "2-2", "2-3", "2-4", "2-5", "2-6"])
        #expect(Campaign.level(id: "2-6") == level && !level.gatesProgression && level.introduces == [.coeur])
        #expect(level.oculo?.stages.count == 1 && level.lueurs.count == 2 && level.oculo?.hidesLueurs == true)
        #expect(Campaign.next(after: level)?.id == "3-1")
        var progress = CampaignProgress()
        for id in ["1-1", "1-2", "1-3", "1-4", "1-5", "2-1", "2-2", "2-3", "2-4"] {
            if let done = Campaign.level(id: id) { progress.register(LevelOutcome(time: 10, intrusions: 1, losses: 0), for: done) }
        }
        #expect(!progress.isUnlocked(level, in: Campaign.levels))
        if let five = Campaign.level(id: "2-5"), let three = Campaign.level(id: "3-1") {
            progress.register(LevelOutcome(time: 10, intrusions: 1, losses: 0), for: five)
            #expect(progress.isUnlocked(level, in: Campaign.levels) && progress.isUnlocked(three, in: Campaign.levels))
        }
    }

    @Test("a steady gaze on the heart completes the stage after the requirement, releases the lueurs, and the level ends")
    func steadyGaze() throws {
        let heart = try #require(coeur)
        let run = Support.run(level, seconds: 40, policy: Support.oracle)
        #expect(run.completedSequence && run.session.isComplete)
        let completion = run.events.firstIndex(of: .oculoCompleted).map { Double($0) } // events are not per frame; use elapsed of session instead
        _ = completion
        #expect(run.events.contains(.lueurReleased(sequence: 1)) && run.events.contains(.lueurReleased(sequence: 2)))
        #expect(run.misses == 0, "the ideal gaze never visits a spark")
        #expect(run.session.elapsed > heart.requirement && run.session.elapsed < 30)
    }

    @Test("a gaze that keeps leaving the heart never warms it; a gaze that chases the sparks cools it; waiting and a random gaze never win")
    func ablations() {
        let leaving = Support.run(level, seconds: 60) { index, session, _ in
            guard let oculo = session.oculo, let gaze = oculo.suggestedGaze(at: session.elapsed) else { return Vector2(x: 30, y: 830) }
            return (index / 30).isMultiple(of: 2) ? gaze : Vector2(x: 40, y: 800)
        }
        #expect(!leaving.completedSequence, "half a second in, half a second out: the account never fills")
        let chasing = Support.run(level, seconds: 60) { _, session, _ in
            guard case let .coeur(state)? = session.oculo?.current else { return Vector2(x: 30, y: 830) }
            if let spark = state.activeDistractor(at: session.elapsed) { return spark.position }
            return state.position
        }
        #expect(!chasing.completedSequence && chasing.misses >= 3, "every spark visited costs warmth")
        #expect(!Support.run(level, seconds: 60, policy: Support.corner).completedSequence)
        for seed in 1...3 {
            #expect(!Support.run(level, seconds: 60, noise: true, seed: seed, policy: Support.randomGaze).completedSequence, "seed \(seed)")
        }
    }

    @Test("hysteresis and inactivity: a tremble beyond the radius keeps the account, an inactive gaze freezes it")
    func hysteresisAndInactivity() throws {
        var heart = try #require(coeur)
        let on = OculoInput(seconds: 0.5, gaze: heart.position, gazeActive: true, head: nil, elapsed: 0.5)
        _ = heart.update(on)
        #expect(abs(heart.charge - 0.5) < 1e-9)
        let tremble = OculoInput(seconds: 0.2, gaze: heart.position + Vector2(x: heart.radius + 6, y: 0), gazeActive: true, head: nil, elapsed: 0.7)
        _ = heart.update(tremble)
        #expect(heart.isInside && abs(heart.charge - 0.7) < 1e-9, "between the radius and the release radius the gaze still rests")
        let inactive = OculoInput(seconds: 1, gaze: Vector2(x: 30, y: 830), gazeActive: false, head: nil, elapsed: 1.7)
        _ = heart.update(inactive)
        #expect(abs(heart.charge - 0.7) < 1e-9, "no gaze at all: nothing changes")
        let away = OculoInput(seconds: 0.4, gaze: Vector2(x: 30, y: 830), gazeActive: true, head: nil, elapsed: 2.1)
        _ = heart.update(away)
        #expect(abs(heart.charge - 0.3) < 1e-9 && !heart.isInside, "away for 0.4 s: 0.4 s of warmth lost")
    }

    @Test("a spark costs warmth once; the ideal player and the avoidance player behave as the level expects")
    func sparksAndBots() throws {
        var heart = try #require(coeur)
        let when = heart.firstDistractorAt + 0.2
        let spark = try #require(heart.activeDistractor(at: when))
        _ = heart.update(OculoInput(seconds: 2, gaze: heart.position, gazeActive: true, head: nil, elapsed: 2))
        let before = heart.charge
        let first = heart.update(OculoInput(seconds: 0.1, gaze: spark.position, gazeActive: true, head: nil, elapsed: when))
        #expect(first.changes == [.miss] && abs(heart.charge - (before - heart.distractorPenalty - 0.1)) < 1e-9)
        let again = heart.update(OculoInput(seconds: 0.1, gaze: spark.position, gazeActive: true, head: nil, elapsed: when + 0.1))
        #expect(again.changes.isEmpty, "the same spark never costs twice")
        let guided = (1...3).map { CampaignBot(definition: level, policy: .guided, seed: $0).run(maxSeconds: 90) }
        let solved = guided.allSatisfy(\.completed)
        #expect(solved, "guided \(guided.map(\.time))")
        #expect(!CampaignBot(definition: level, policy: .avoidance).run(maxSeconds: 60).completed)
        #expect(!CampaignBot(definition: level, policy: .offScreen).run(maxSeconds: 30).completed)
    }

    @Test("the scene shows the heart, its warmth ring and the flaring spark; the lueurs stay latent until the heart opens")
    func scene() throws {
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        var session = resolved.makeSession(noiseSources: [SilentNoise(), SilentNoise()])
        session.placeGaze(at: Vector2(x: 30, y: 830))
        for _ in 0..<Int(3.3 * 60) { _ = session.advance(by: Support.frame) }
        let snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, showsGaze: false, diagnostics: nil)
        let oculo = try #require(snapshot.oculo)
        #expect(oculo.elements.contains { $0.role == .target } && oculo.elements.contains { $0.role == .distractor })
        #expect(oculo.arcs.count == 1 && snapshot.lueurs.allSatisfy(\.isLatent))
        #expect(session.areLueursLatent && !session.isIrisOpen(for: session.targets[0]))
    }
}
