// OculoFilTests.swift
// Layer: Tests
// Purpose: Chapter III final « le fil vivant »: the spark never stops, the account grows only while the gaze accompanies
// it and frays while away; accompanying wins, any fixed gaze or a random gaze never does, losing then recovering still wins

import Foundation
import Testing
@testable import Iris

@Suite("Chapter III final: fil vivant")
struct OculoFilTests {
    private typealias Support = OculoStageTestSupport
    private var level: LevelDefinition { Campaign.finalCourants }

    private var fil: FilStageState? {
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        if case let .fil(state)? = resolved.environment.oculo?.current { return state }
        return nil
    }

    @Test("structure: level 3-7 is the optional final of chapter III and introduces the living thread")
    func structure() throws {
        let chapter = try #require(Campaign.chapter(number: 3))
        #expect(chapter.levels.map(\.id).last == "3-7" && chapter.levels.count == 7)
        #expect(Campaign.level(id: "3-7") == level && !level.gatesProgression && level.introduces == [.filVivant])
        #expect(Campaign.next(after: level)?.id == "4-1")
    }

    @Test("the spark's loop is smooth, never faster than a comfortable pursuit, and stays in the comfort ranges")
    func loop() throws {
        let state = try #require(fil)
        var previous = state.position(at: 0)
        var maxSpeed = 0.0
        var minX = Double.infinity, maxX = -Double.infinity, minY = Double.infinity, maxY = -Double.infinity
        for step in 1...600 {
            let t = Double(step) / 60
            let point = state.position(at: t)
            maxSpeed = max(maxSpeed, point.distance(to: previous) * 60)
            previous = point
            minX = min(minX, point.x); maxX = max(maxX, point.x); minY = min(minY, point.y); maxY = max(maxY, point.y)
        }
        #expect(maxSpeed < 200, "\(maxSpeed) pt/s")
        #expect(minX / 393 >= 0.15 && maxX / 393 <= 0.85 && minY / 852 >= 0.12 && maxY / 852 <= 0.88)
        #expect(maxX - minX > 200 && maxY - minY > 300, "the loop crosses most of the field")
    }

    @Test("accompanying the spark with the real gaze filter completes the stage; the lueur is then released and settles")
    func accompanying() {
        let run = Support.run(level, seconds: 60, policy: Support.oracle)
        #expect(run.completedSequence && run.session.isComplete && run.session.elapsed < 30)
        #expect(run.misses == 0)
    }

    @Test("ablations: the centre, a corner, any fixed point and a random gaze never keep the thread alive")
    func ablations() {
        #expect(!Support.run(level, seconds: 60, policy: Support.centre).completedSequence)
        #expect(!Support.run(level, seconds: 60, policy: Support.corner).completedSequence)
        let fixedOnLoop = Support.run(level, seconds: 60) { _, session, _ in
            guard case let .fil(state)? = session.oculo?.current else { return nil }
            return state.position(at: 2.5)
        }
        #expect(!fixedOnLoop.completedSequence, "a fixed point on the loop only meets the spark once a lap")
        for seed in 1...3 {
            #expect(!Support.run(level, seconds: 60, noise: true, seed: seed, policy: Support.randomGaze).completedSequence, "seed \(seed)")
        }
    }

    @Test("losing the spark frays the thread and counts a miss; catching it again revives the thread and still wins")
    func loseAndRecover() {
        let run = Support.run(level, seconds: 90) { index, session, _ in
            guard case let .fil(state)? = session.oculo?.current else { return Vector2(x: 30, y: 830) }
            // Two seconds of accompaniment, then 0.7 s away, again and again.
            return (index % 162) < 120 ? state.position(at: session.elapsed) : Vector2(x: 40, y: 800)
        }
        #expect(run.completedSequence, "recoverable losses still win")
        #expect(run.misses >= 3 && run.session.elapsed > 8)
    }

    @Test("hysteresis, inactivity and the trail")
    func mechanics() throws {
        var state = try #require(fil)
        _ = state.update(OculoInput(seconds: 1, gaze: state.position(at: 1), gazeActive: true, head: nil, elapsed: 1))
        #expect(state.isNear && abs(state.charge - 1) < 1e-9)
        let spark = state.position(at: 1.1)
        _ = state.update(OculoInput(seconds: 0.1, gaze: spark + Vector2(x: state.radius + 5, y: 0), gazeActive: true, head: nil, elapsed: 1.1))
        #expect(state.isNear && abs(state.charge - 1.1) < 1e-9, "a tremble past the radius keeps the account")
        _ = state.update(OculoInput(seconds: 0.5, gaze: Vector2(x: 30, y: 830), gazeActive: false, head: nil, elapsed: 1.6))
        #expect(abs(state.charge - 1.1) < 1e-9, "no gaze at all freezes the account")
        let lost = state.update(OculoInput(seconds: 0.5, gaze: Vector2(x: 30, y: 830), gazeActive: true, head: nil, elapsed: 2.1))
        #expect(lost.changes == [.miss] && !state.isNear && abs(state.charge - 0.6) < 1e-9)
        for step in 0..<60 { _ = state.update(OculoInput(seconds: 1.0 / 60, gaze: .zero, gazeActive: false, head: nil, elapsed: 2.1 + Double(step) / 60)) }
        #expect(state.trail.count >= 10 && state.trail.count <= FilStageState.trailLength)
    }

    @Test("guided bot wins, avoidance and off-screen never; the scene carries the spark and its filament")
    func botsAndScene() throws {
        let guided = (1...3).map { CampaignBot(definition: level, policy: .guided, seed: $0).run(maxSeconds: 90) }
        let solved = guided.allSatisfy(\.completed)
        #expect(solved, "guided \(guided.map(\.time))")
        #expect(!CampaignBot(definition: level, policy: .avoidance).run(maxSeconds: 60).completed)
        #expect(!CampaignBot(definition: level, policy: .offScreen).run(maxSeconds: 30).completed)
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        var session = resolved.makeSession(noiseSources: [SilentNoise()])
        session.placeGaze(at: Vector2(x: 30, y: 830))
        for _ in 0..<120 { _ = session.advance(by: Support.frame) }
        let snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, marker: .hidden, diagnostics: nil)
        let oculo = try #require(snapshot.oculo)
        #expect(oculo.elements.contains { $0.role == .spark } && oculo.polylines.first.map { $0.points.count > 5 } == true)
    }
}
