// OculoCroisementTests.swift
// Layer: Tests
// Purpose: Chapter VII final « croisement »: the breathing twin is acquired then hands over across the diagonal; legs
// change diagonal and amplitude (near to far, then far to near); answering across wins, one quadrant, the centre,
// horizontal alternation and random gazes never do; the twins fuse once the sequence ends

import Foundation
import Testing
@testable import Iris

@Suite("Chapter VII final: croisement")
struct OculoCroisementTests {
    private typealias Support = OculoStageTestSupport
    private var level: LevelDefinition { Campaign.finalJumelles }

    private var croisement: CroisementStageState? {
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        if case let .croisement(state)? = resolved.environment.oculo?.current { return state }
        return nil
    }

    @Test("structure: level 7-7 is the optional final of chapter VII; amplitudes grow then shrink over both diagonals, all in the comfort ranges")
    func structure() throws {
        let chapter = try #require(Campaign.chapter(number: 7))
        #expect(chapter.levels.count == 7 && chapter.levels.last?.id == "7-7")
        #expect(Campaign.level(id: "7-7") == level && !level.gatesProgression && level.introduces == [.croisement] && level.hasTwins)
        let state = try #require(croisement)
        let spans = state.legPositions.map { $0.0.distance(to: $0.1) }
        #expect(spans[0] < spans[1] && spans[1] < spans[2] && spans[3] > spans[4] && spans[4] > spans[5], "near to far, far to near: \(spans)")
        #expect(spans.min() ?? 0 > state.releaseRadius * 1.5, "even the nearest twins are clearly separate")
        for (first, second) in state.legPositions {
            for point in [first, second] {
                #expect((0.15...0.85).contains(point.x / 393) && (0.12...0.88).contains(point.y / 852))
                #expect(point.distance(to: state.center) > state.radius, "no twin can be acquired from the centre")
            }
            #expect(abs(first.x - second.x) > 50 && abs(first.y - second.y) > 50, "a real diagonal")
        }
        #expect((state.legPositions[0].0.x - state.center.x) * (state.legPositions[3].0.x - state.center.x) < 0, "the second half uses the other diagonal")
    }

    @Test("answering across wins twelve exchanges; the released twins then fuse and the level ends")
    func answering() {
        let run = Support.run(level, seconds: 60, policy: Support.oracle)
        #expect(run.completedSequence && run.successes == 12 && run.session.isComplete)
    }

    @Test("ablations: one quadrant, the centre, a left-right alternation and random gazes never complete the crossing")
    func ablations() throws {
        let state = try #require(croisement)
        let quadrant = state.legPositions[0].0
        let stay = Support.run(level, seconds: 60) { _, _, _ in quadrant }
        #expect(!stay.completedSequence && stay.successes <= 1)
        #expect(!Support.run(level, seconds: 60, policy: Support.centre).completedSequence)
        let horizontal = Support.run(level, seconds: 60) { index, _, _ in
            (index / 36).isMultiple(of: 2) ? Vector2(x: 0.2 * 393, y: 426) : Vector2(x: 0.8 * 393, y: 426)
        }
        #expect(!horizontal.completedSequence && horizontal.successes == 0)
        for seed in 1...3 {
            #expect(!Support.run(level, seconds: 60, noise: true, seed: seed, policy: Support.randomGaze).completedSequence, "seed \(seed)")
        }
    }

    @Test("a brief pass does not count, the active twin alternates, the twins glide to the next leg")
    func mechanics() throws {
        var state = try #require(croisement)
        var t = 0.0
        func step(_ gaze: Vector2, _ seconds: Double = 0.05) -> [OculoChange] {
            t += seconds
            return state.update(OculoInput(seconds: seconds, gaze: gaze, gazeActive: true, head: nil, elapsed: t)).changes
        }
        let first = state.activePosition(at: 0)
        _ = step(first, 0.1)
        _ = step(Vector2(x: 30, y: 830), 0.1)
        #expect(state.successes == 0 && state.dwellTime == 0, "0.1 s is a pass")
        var changes: [OculoChange] = []
        for _ in 0..<6 { changes += step(first) }
        #expect(changes == [.success] && state.active == 1)
        let second = state.activePosition(at: t)
        for _ in 0..<6 { changes += step(second) }
        #expect(state.legIndex == 1 && state.active == 0 && state.legStartedAt != nil)
        let mid = state.twins(at: t + state.glide / 2).0
        let from = state.legPositions[0].0, to = state.legPositions[1].0
        #expect(mid.distance(to: from) > 5 && mid.distance(to: to) > 5, "halfway through the glide")
        #expect(state.twins(at: t + state.glide + 0.01).0 == to)
        _ = state.update(OculoInput(seconds: 1, gaze: state.activePosition(at: t + 1), gazeActive: false, head: nil, elapsed: t + 1))
        #expect(state.successes == 2, "an inactive gaze acquires nothing")
    }

    @Test("guided bot wins, avoidance and off-screen never; the scene shows two cradles, one breathing, and their thread")
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
        let snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, showsGaze: false, diagnostics: nil)
        let cradles = try #require(snapshot.oculo?.elements.filter { $0.role == .cradle })
        let breathing = cradles.filter { $0.isActive }.count
        let threads = snapshot.oculo?.polylines.count ?? 0
        #expect(cradles.count == 2 && breathing == 1 && threads == 1)
        let latent = snapshot.lueurs.allSatisfy { $0.isLatent }
        #expect(latent)
    }
}
