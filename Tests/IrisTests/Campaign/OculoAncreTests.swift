// OculoAncreTests.swift
// Layer: Tests
// Purpose: Chapter X final « l'ancre »: the gaze on the anchor plus a gentle head turn into each band wins; the head
// alone, the gaze alone, a head that always turns the same way, no head data and random gazes never do; the sign of
// each axis is learned from the player

import Foundation
import Testing
@testable import Iris

@Suite("Chapter X final: ancre")
struct OculoAncreTests {
    private typealias Support = OculoStageTestSupport
    private var level: LevelDefinition { Campaign.finalGouffres }

    private var ancre: AncreStageState? {
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        if case let .ancre(state)? = resolved.environment.oculo?.current { return state }
        return nil
    }

    private static func oracleHead(_ index: Int, _ session: GameSession) -> HeadPose? {
        session.oculo?.suggestedHead ?? .neutral
    }

    @Test("structure: level 10-7 is the optional final of chapter X; both axes, each opened by a first turn, thresholds gentle")
    func structure() throws {
        let chapter = try #require(Campaign.chapter(number: 10))
        #expect(chapter.levels.count == 7 && chapter.levels.last?.id == "10-7")
        #expect(Campaign.level(id: "10-7") == level && !level.gatesProgression && level.introduces == [.ancre])
        let state = try #require(ancre)
        #expect(state.bands.count == 6)
        for axis in [AncreDefinition.Axis.yaw, .pitch] {
            let onAxis = state.bands.filter { $0.axis == axis }
            #expect(onAxis.first?.direction == .first && onAxis.count >= 2, "\(axis)")
        }
        #expect((4...8).contains(state.yawThreshold) && (3...7).contains(state.pitchThreshold), "small, comfortable turns")
        #expect((0.15...0.85).contains(state.anchor.x / 393) && (0.12...0.88).contains(state.anchor.y / 852))
    }

    @Test("the gaze on the anchor and a gentle turn into each band wins six bands without a slip; the head never turns more than 9°")
    func stabilising() throws {
        var largest = 0.0
        let run = Support.run(level, seconds: 60, head: { index, session in
            let pose = Self.oracleHead(index, session)
            largest = max(largest, abs(pose?.yaw ?? 0), abs(pose?.pitch ?? 0))
            return pose
        }, policy: Support.oracle)
        #expect(run.completedSequence && run.successes == 6 && run.misses == 0 && !run.session.areLueursLatent)
        #expect(largest <= 9)
    }

    @Test("ablations: gaze alone (head still), head alone (gaze away), a head that always turns the same way, no head data and random gazes never complete")
    func ablations() {
        let still = Support.run(level, seconds: 45, head: { _, _ in .neutral }, policy: Support.oracle)
        #expect(!still.completedSequence && still.successes == 0)
        let headOnly = Support.run(level, seconds: 45, head: Self.oracleHead, policy: Support.corner)
        #expect(!headOnly.completedSequence && headOnly.successes == 0)
        let oneWay = Support.run(level, seconds: 45, head: { _, _ in HeadPose(yaw: 9, pitch: 0) }, policy: Support.oracle)
        #expect(!oneWay.completedSequence && oneWay.successes <= 1, "the second band needs the other way (and a return to rest)")
        let noHead = Support.run(level, seconds: 45, policy: Support.oracle)
        #expect(!noHead.completedSequence && noHead.successes == 0)
        for seed in 1...3 {
            let random = Support.run(level, seconds: 45, noise: true, seed: seed, head: Self.oracleHead, policy: Support.randomGaze)
            #expect(!random.completedSequence, "seed \(seed)")
        }
    }

    @Test("a first turn to the left is learned as the player's own direction; a return to rest opens the next band; leaving the anchor mid-band is one slip")
    func mechanics() throws {
        var state = try #require(ancre)
        var t = 0.0
        func step(_ head: HeadPose, gaze: Vector2? = nil, _ seconds: Double = 0.05) -> [OculoChange] {
            t += seconds
            return state.update(OculoInput(seconds: seconds, gaze: gaze ?? state.anchor, gazeActive: true, head: head, elapsed: t)).changes
        }
        _ = step(.neutral)
        var changes: [OculoChange] = []
        for _ in 0..<14 { changes += step(HeadPose(yaw: -8, pitch: 0)) }
        #expect(changes == [.success] && state.yawSign == -1 && state.awaitingReturn)
        _ = step(HeadPose(yaw: 8, pitch: 0))
        #expect(state.holdTime == 0, "no band counts before the head comes back to rest")
        _ = step(.neutral)
        #expect(!state.awaitingReturn)
        changes = []
        for _ in 0..<6 { changes += step(HeadPose(yaw: 8, pitch: 0)) }
        changes += step(HeadPose(yaw: 8, pitch: 0), gaze: Vector2(x: 30, y: 830))
        #expect(changes == [.miss] && state.slips == 1, "the opposite of a left turn is a right turn; leaving the anchor slips once")
        changes = []
        for _ in 0..<14 { changes += step(HeadPose(yaw: 8, pitch: 0)) }
        #expect(changes == [.success] && state.bandIndex == 2)
        let offset = state.screenOffset()
        #expect(offset.x < 0, "a right turn, for this player, points away from their first band")
        _ = state.update(OculoInput(seconds: 1, gaze: state.anchor, gazeActive: true, head: nil, elapsed: t + 1))
        #expect(state.bandIndex == 2, "no head data: nothing changes, nothing crashes")
    }

    @Test("guided bot wins, avoidance and off-screen never; the scene shows the anchor, the compass and the designated arc")
    func botsAndScene() throws {
        let guided = (1...3).map { CampaignBot(definition: level, policy: .guided, seed: $0).run(maxSeconds: 90) }
        let solved = guided.allSatisfy(\.completed)
        #expect(solved, "guided \(guided.map(\.time))")
        #expect(!CampaignBot(definition: level, policy: .avoidance).run(maxSeconds: 60).completed)
        #expect(!CampaignBot(definition: level, policy: .offScreen).run(maxSeconds: 30).completed)
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        var session = resolved.makeSession(noiseSources: [SilentNoise()])
        session.placeGaze(at: Vector2(x: 30, y: 830))
        session.ingestHeadPose(.neutral)
        _ = session.advance(by: Support.frame)
        let snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, showsGaze: false, diagnostics: nil)
        let oculo = try #require(snapshot.oculo)
        let anchors = oculo.elements.filter { $0.role == .anchor }.count
        let compasses = oculo.elements.filter { $0.role == .compass }.count
        let activeArcs = oculo.arcs.filter { $0.isActive }.count
        #expect(anchors == 1 && compasses == 1 && activeArcs == 1)
    }
}
