// OculoJardinTests.swift
// Layer: Tests
// Purpose: Chapter VI final « le jardin caché »: breathing seeds sprout under a rest, lingering on a twinkling seed
// folds the batch back, glances cost nothing; searching wins, fixed, random and lingering-scan policies never do

import Foundation
import Testing
@testable import Iris

@Suite("Chapter VI final: jardin caché")
struct OculoJardinTests {
    private typealias Support = OculoStageTestSupport
    private var level: LevelDefinition { Campaign.finalClairvoyance }

    private var jardin: JardinStageState? {
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        if case let .jardin(state)? = resolved.environment.oculo?.current { return state }
        return nil
    }

    /// A gaze that visits every seed in reading order, resting `restFrames` frames on each.
    private func scan(restFrames: Int) -> (Int, GameSession, inout LinearCongruentialGenerator) -> Vector2? {
        { index, session, _ in
            guard case let .jardin(state)? = session.oculo?.current else { return Vector2(x: 30, y: 830) }
            return state.seeds[(index / restFrames) % state.seeds.count]
        }
    }

    @Test("structure: level 6-7 is the optional final of chapter VI; the seeds cover the whole field and never overlap")
    func structure() throws {
        let chapter = try #require(Campaign.chapter(number: 6))
        #expect(chapter.levels.count == 7 && chapter.levels.last?.id == "6-7")
        #expect(Campaign.level(id: "6-7") == level && !level.gatesProgression && level.introduces == [.jardin])
        let state = try #require(jardin)
        #expect(state.batches.map(\.count) == [2, 2, 2, 2] && Set(state.batches.flatMap { $0 }).count == 8)
        for i in state.seeds.indices {
            #expect((0.15...0.85).contains(state.seeds[i].x / 393) && (0.12...0.88).contains(state.seeds[i].y / 852))
            for j in state.seeds.indices where j > i {
                #expect(state.seeds[i].distance(to: state.seeds[j]) > state.releaseRadius, "seeds \(i) and \(j) too close")
            }
        }
        let xs = state.seeds.map(\.x), ys = state.seeds.map(\.y)
        #expect((xs.max() ?? 0) - (xs.min() ?? 0) > 230 && (ys.max() ?? 0) - (ys.min() ?? 0) > 540, "the garden spans the field")
        #expect(level.lueurs.first?.irisMotion.isMoving == true, "the garden opens onto chapter VI's gliding iris")
    }

    @Test("searching wins: straight to each breathing seed, eight sprouts, no fold")
    func searching() {
        let run = Support.run(level, seconds: 60, policy: Support.oracle)
        #expect(run.completedSequence && run.successes == 8 && run.misses == 0 && !run.session.areLueursLatent)
    }

    @Test("a brief-rest scan of the whole garden also wins (it is the scanning pattern); lingering on every seed never does")
    func scanning() {
        let brief = Support.run(level, seconds: 90, policy: scan(restFrames: 21))
        #expect(brief.completedSequence && brief.misses == 0, "0.35 s per seed: sprouts, never folds")
        let lingering = Support.run(level, seconds: 90, policy: scan(restFrames: 36))
        #expect(!lingering.completedSequence && lingering.misses >= 10, "0.6 s per seed: every twinkling seed folds the batch")
        if case let .jardin(state)? = lingering.session.oculo?.current { #expect(state.batchIndex == 0) }
    }

    @Test("ablations: the centre, a corner and random gazes never open the garden")
    func ablations() {
        #expect(!Support.run(level, seconds: 60, policy: Support.centre).completedSequence)
        #expect(!Support.run(level, seconds: 60, policy: Support.corner).completedSequence)
        for seed in 1...3 {
            #expect(!Support.run(level, seconds: 60, noise: true, seed: seed, policy: Support.randomGaze).completedSequence, "seed \(seed)")
        }
    }

    @Test("a glance costs nothing, lingering folds once per rest, sprouts of completed batches stay, coverage counts rested seeds")
    func mechanics() throws {
        var state = try #require(jardin)
        let target = state.currentBatch[0]
        let other = state.currentBatch[1]
        let twinkling = try #require(state.seeds.indices.first { !state.currentBatch.contains($0) })
        var t = 0.0
        func step(_ gaze: Vector2, _ seconds: Double = 0.05) -> [OculoChange] {
            t += seconds
            return state.update(OculoInput(seconds: seconds, gaze: gaze, gazeActive: true, head: nil, elapsed: t)).changes
        }
        var changes: [OculoChange] = []
        for _ in 0..<7 { changes += step(state.seeds[target]) }
        #expect(changes == [.success] && state.found == [target])
        changes = []
        for _ in 0..<8 { changes += step(state.seeds[twinkling]) }
        #expect(changes.isEmpty && state.found == [target], "0.4 s on a twinkling seed is a glance")
        for _ in 0..<12 { changes += step(state.seeds[twinkling]) }
        #expect(changes == [.miss] && state.found.isEmpty && state.folds == 1, "lingering folds once, not on every frame")
        for _ in 0..<7 { changes += step(state.seeds[target]) }
        for _ in 0..<7 { changes += step(state.seeds[other]) }
        #expect(state.batchIndex == 1 && state.garden.count == 2)
        for _ in 0..<12 { _ = step(state.seeds[twinkling]) }
        #expect(state.garden.count == 2, "a fold never undoes a completed batch")
        #expect(state.visited.contains(twinkling) && state.visited.contains(target))
        _ = state.update(OculoInput(seconds: 1, gaze: state.seeds[state.currentBatch[0]], gazeActive: false, head: nil, elapsed: t + 1))
        #expect(state.found.isEmpty && state.dwellTime == 0 || state.dwellingOn != state.currentBatch[0], "an inactive gaze sprouts nothing")
    }

    @Test("guided bot wins, avoidance and off-screen never; the scene shows twelve seeds, two breathing")
    func botsAndScene() throws {
        let guided = (1...3).map { CampaignBot(definition: level, policy: .guided, seed: $0).run(maxSeconds: 90) }
        let solved = guided.allSatisfy(\.completed)
        #expect(solved, "guided \(guided.map(\.time))")
        #expect(!CampaignBot(definition: level, policy: .avoidance).run(maxSeconds: 60).completed)
        #expect(!CampaignBot(definition: level, policy: .offScreen).run(maxSeconds: 30).completed)
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        var session = resolved.makeSession(noiseSources: [SilentNoise()])
        session.placeGaze(at: Vector2(x: 30, y: 830))
        _ = session.advance(by: Support.frame)
        let snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, showsGaze: false, diagnostics: nil)
        let seeds = try #require(snapshot.oculo?.elements.filter { $0.role == .seed })
        #expect(seeds.count == 12 && seeds.filter(\.isActive).count == 2 && seeds.allSatisfy { !$0.isLit })
    }
}
