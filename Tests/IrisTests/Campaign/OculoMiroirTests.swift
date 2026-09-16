// OculoMiroirTests.swift
// Layer: Tests
// Purpose: Chapter IV final « le miroir menteur »: the door opens opposite the lure; going to the lure or letting the
// door close repeats the cycle; the first cycle is longer; going to the door wins, following the lure never does

import Foundation
import Testing
@testable import Iris

@Suite("Chapter IV final: miroir menteur")
struct OculoMiroirTests {
    private typealias Support = OculoStageTestSupport
    private var level: LevelDefinition { Campaign.finalVoiles }

    private var miroir: MiroirStageState? {
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        if case let .miroir(state)? = resolved.environment.oculo?.current { return state }
        return nil
    }

    @Test("structure: level 4-7 is the optional final of chapter IV; the lure never flashes where the gaze already rests")
    func structure() throws {
        let chapter = try #require(Campaign.chapter(number: 4))
        #expect(chapter.levels.count == 7 && chapter.levels.last?.id == "4-7")
        #expect(Campaign.level(id: "4-7") == level && !level.gatesProgression && level.introduces == [.miroir])
        let state = try #require(miroir)
        var resting: MiroirDefinition.Side? = nil
        for lure in state.cycles {
            #expect(lure != resting, "the lure flashes where the gaze rests after the previous door")
            resting = lure.opposite
        }
        let sides = Set(state.cycles)
        #expect(sides.count == 4, "every side lures at least once")
    }

    @Test("going to the door wins every cycle; the first door stays open longer")
    func doors() throws {
        var state = try #require(miroir)
        #expect(state.currentWindowDuration == state.teachingWindowDuration)
        let run = Support.run(level, seconds: 60, policy: Support.oracle)
        // The lueur then needs a push around the veil (the guided bot does it below); here the sequence and the release.
        #expect(run.completedSequence && run.successes == 8 && run.misses == 0 && !run.session.areLueursLatent)
        _ = state.update(OculoInput(seconds: 0.1, gaze: Vector2(x: 30, y: 830), gazeActive: true, head: nil, elapsed: 0.1))
        #expect(state.successes == 0)
    }

    @Test("following the lure never wins; the centre never wins; a random gaze never wins; every miss repeats the same cycle")
    func ablations() throws {
        let lured = Support.run(level, seconds: 60) { _, session, _ in
            guard case let .miroir(state)? = session.oculo?.current else { return Vector2(x: 30, y: 830) }
            if case .cycle = state.phase, let lure = state.lureSide { return state.positions[lure] }
            return Support.bounds.center
        }
        #expect(!lured.completedSequence && lured.successes == 0 && lured.misses >= 5)
        if case let .miroir(state)? = lured.session.oculo?.current {
            #expect(state.cycleIndex == 0 && state.lured >= 5, "the same first cycle repeats")
        }
        let centre = Support.run(level, seconds: 60, policy: Support.centre)
        #expect(!centre.completedSequence && centre.successes == 0)
        if case let .miroir(state)? = centre.session.oculo?.current { #expect(state.timeouts >= 5) }
        for seed in 1...3 {
            #expect(!Support.run(level, seconds: 60, noise: true, seed: seed, policy: Support.randomGaze).completedSequence, "seed \(seed)")
        }
    }

    @Test("a dwell shorter than required does not open the door; a tremble across the door edge keeps the dwell; a gaze resting on the lure at flash time is not lured")
    func dwellAndHysteresis() throws {
        var state = try #require(miroir)
        // Reach the first cycle.
        _ = state.update(OculoInput(seconds: 1.0, gaze: Support.bounds.center, gazeActive: true, head: nil, elapsed: 1.0))
        _ = state.update(OculoInput(seconds: 0.01, gaze: Support.bounds.center, gazeActive: true, head: nil, elapsed: 1.01))
        guard case let .cycle(start) = state.phase, let door = state.doorSide, let doorPosition = state.positions[door] else {
            Issue.record("no cycle")
            return
        }
        let open = start + state.windowOpensAt + 0.05
        _ = state.update(OculoInput(seconds: 0.1, gaze: doorPosition, gazeActive: true, head: nil, elapsed: open))
        #expect(state.isInDoor && state.successes == 0)
        _ = state.update(OculoInput(seconds: 0.05, gaze: doorPosition + Vector2(x: state.radius + 5, y: 0), gazeActive: true, head: nil, elapsed: open + 0.05))
        #expect(state.isInDoor && abs(state.dwellTime - 0.15) < 1e-9)
        let win = state.update(OculoInput(seconds: 0.1, gaze: doorPosition, gazeActive: true, head: nil, elapsed: open + 0.15))
        #expect(win.changes == [.success] && state.successes == 1)

        var resting = try #require(miroir)
        let firstLure = resting.cycles[0]
        let lurePosition = try #require(resting.positions[firstLure])
        _ = resting.update(OculoInput(seconds: 1.0, gaze: lurePosition, gazeActive: true, head: nil, elapsed: 1.0))
        let stay = resting.update(OculoInput(seconds: 0.3, gaze: lurePosition, gazeActive: true, head: nil, elapsed: 1.3))
        #expect(stay.changes.isEmpty && resting.lured == 0, "resting on the lure's spot when it flashes is not following it")
    }

    @Test("guided bot wins, avoidance and off-screen never; the scene shows the four doors and the flash")
    func botsAndScene() throws {
        let guided = (1...3).map { CampaignBot(definition: level, policy: .guided, seed: $0).run(maxSeconds: 90) }
        let solved = guided.allSatisfy(\.completed)
        #expect(solved, "guided \(guided.map(\.time))")
        #expect(!CampaignBot(definition: level, policy: .avoidance).run(maxSeconds: 60).completed)
        #expect(!CampaignBot(definition: level, policy: .offScreen).run(maxSeconds: 30).completed)
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        var session = resolved.makeSession(noiseSources: [SilentNoise()])
        session.placeGaze(at: Support.bounds.center)
        for _ in 0..<Int(1.2 * 60) { _ = session.advance(by: Support.frame) }
        let snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, marker: .hidden, diagnostics: nil)
        let oculo = try #require(snapshot.oculo)
        #expect(oculo.elements.filter { $0.role == .window }.count == 4)
        #expect(oculo.elements.contains { $0.role == .flash }, "the first lure flashes at 1.0 s")
    }
}
