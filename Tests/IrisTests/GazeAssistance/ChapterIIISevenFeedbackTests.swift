// ChapterIIISevenFeedbackTests.swift
// Layer: Tests
// Purpose: Chapter III level 7 answers the gaze with light — and changes nothing else. The signal is the engine's
// own accompaniment, so the feedback cannot drift from the rule it reflects

import Foundation
import Testing
@testable import Iris

@Suite("Chapter III-7 gaze-follow feedback")
struct ChapterIIISevenFeedbackTests {
    private func resolvedLevel() throws -> (LevelDefinition, ResolvedLevel) {
        let level = try #require(Campaign.level(id: "3-7"))
        return (level, LevelResolver.resolve(level, in: .referencePhone))
    }

    /// Runs the level's spark stage with the gaze either on it or far from it, and returns the scene each frame.
    private func run(followingSpark: Bool, frames: Int = 120) throws -> [OculoElementSnapshot] {
        let (_, resolved) = try resolvedLevel()
        var session = resolved.makeSession()
        var sparks: [OculoElementSnapshot] = []
        let step = 1.0 / 60.0
        for _ in 0..<frames {
            if let fil = filState(session) {
                let spark = fil.position(at: session.elapsed)
                session.placeGaze(at: followingSpark ? spark : Vector2(x: spark.x + 4000, y: spark.y + 4000))
            }
            _ = session.advance(by: step)
            let snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, marker: .hidden, diagnostics: nil)
            if let element = snapshot.oculo?.elements.first(where: { $0.role == .spark }) {
                sparks.append(element)
            }
        }
        return sparks
    }

    private func filState(_ session: GameSession) -> FilStageState? {
        guard case let .fil(state)? = session.oculo?.current else { return nil }
        return state
    }

    @Test("the level really is the spark level, and the engine already counts the accompaniment")
    func theLevel() throws {
        let (level, _) = try resolvedLevel()
        #expect(level.chapter == 3 && level.index == 7)
        #expect(level.oculo?.element == .filVivant)
        #expect(!level.gatesProgression, "it is an optional final and must stay one")
    }

    @Test("gaze away from the spark: no feedback")
    func gazeAway() throws {
        let sparks = try run(followingSpark: false)
        #expect(!sparks.isEmpty)
        #expect(sparks.allSatisfy { !$0.isLit }, "the spark answered a gaze that was never on it")
    }

    @Test("gaze on the spark: the feedback turns on")
    func gazeOnIt() throws {
        let sparks = try run(followingSpark: true)
        #expect(!sparks.isEmpty)
        #expect(sparks.contains { $0.isLit }, "following the spark produced no feedback at all")
    }

    @Test("the gaze leaves: the feedback goes away with it")
    func gazeLeaves() throws {
        let (_, resolved) = try resolvedLevel()
        var session = resolved.makeSession()
        let step = 1.0 / 60.0
        // Follow it long enough to be counted as accompanying.
        for _ in 0..<90 {
            if let fil = filState(session) { session.placeGaze(at: fil.position(at: session.elapsed)) }
            _ = session.advance(by: step)
        }
        #expect(filState(session)?.isNear == true, "the gaze should be accompanying by now")

        // Then look right away from it.
        for _ in 0..<60 {
            if let fil = filState(session) {
                let spark = fil.position(at: session.elapsed)
                session.placeGaze(at: Vector2(x: spark.x + 4000, y: spark.y + 4000))
            }
            _ = session.advance(by: step)
        }
        let snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, marker: .hidden, diagnostics: nil)
        let spark = snapshot.oculo?.elements.first { $0.role == .spark }
        #expect(spark?.isLit == false, "the feedback outlived the gaze that earned it")
    }

    @Test("the feedback is the engine's own accompaniment, so it can never disagree with the rule")
    func feedbackMirrorsTheEngine() throws {
        let (_, resolved) = try resolvedLevel()
        var session = resolved.makeSession()
        let step = 1.0 / 60.0
        var comparisons = 0
        for frame in 0..<240 {
            if let fil = filState(session) {
                let spark = fil.position(at: session.elapsed)
                // Alternate between following and looking away, so both states are exercised.
                session.placeGaze(at: frame % 80 < 40 ? spark : Vector2(x: spark.x + 4000, y: spark.y + 4000))
            }
            _ = session.advance(by: step)
            guard let fil = filState(session) else { continue }
            let snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, marker: .hidden, diagnostics: nil)
            guard let spark = snapshot.oculo?.elements.first(where: { $0.role == .spark }) else { continue }
            #expect(spark.isLit == fil.isNear, "the light and the rule disagreed at frame \(frame)")
            comparisons += 1
        }
        #expect(comparisons > 100)
    }

    @Test("the feedback changes nothing: same trajectory, same charge, same completion, whatever is drawn")
    func nothingElseChanges() throws {
        let (_, resolved) = try resolvedLevel()
        let step = 1.0 / 60.0

        /// Plays the level identically twice; the only difference is whether a snapshot is built each frame.
        func play(buildingSnapshots: Bool) -> (positions: [Vector2], charge: Double, complete: Bool, lost: Int) {
            var session = resolved.makeSession()
            var positions: [Vector2] = []
            for _ in 0..<600 {
                if let fil = filState(session) {
                    let spark = fil.position(at: session.elapsed)
                    positions.append(spark)
                    session.placeGaze(at: spark)
                }
                _ = session.advance(by: step)
                if buildingSnapshots {
                    _ = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, marker: .shown, diagnostics: nil)
                }
            }
            let fil = filState(session)
            return (positions, fil?.charge ?? -1, fil?.isComplete ?? false, fil?.lostCount ?? -1)
        }

        let drawn = play(buildingSnapshots: true)
        let undrawn = play(buildingSnapshots: false)
        #expect(drawn.positions == undrawn.positions, "the trajectory differed")
        #expect(drawn.charge == undrawn.charge, "the accompaniment charge differed")
        #expect(drawn.complete == undrawn.complete, "completion differed")
        #expect(drawn.lost == undrawn.lost, "the miss count differed")
        #expect(drawn.positions.count > 400)
    }

    @Test("the renderer reads the engine's signal and invents no threshold of its own")
    func rendererUsesTheEngineSignal() throws {
        let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()
            .deletingLastPathComponent().deletingLastPathComponent()
        let source = try String(contentsOf: root.appendingPathComponent("Features/Game/Rendering/GameSceneRenderer+Oculo.swift"), encoding: .utf8)
        guard let start = source.range(of: "case .spark:") else {
            Issue.record("the spark is no longer drawn on its own"); return
        }
        let body = String(source[start.lowerBound...].prefix(900))
        #expect(body.contains("element.isLit"), "the feedback must come from the engine's own accompaniment")
        // What would betray a threshold of its own: measuring a distance, or comparing against the follow radius.
        for invented in ["distance(", "sqrt(", "threshold", "element.radius >", "element.radius <"] {
            #expect(!body.contains(invented), "the spark drawing computes \(invented) for itself")
        }
    }
}
