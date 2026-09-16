// OculoTournerTests.swift
// Layer: Tests
// Purpose: Chapter XI final « d'abord les yeux »: eyes first then the head gives full warmth, the head first half,
// the eyes alone a third; all progress, the eye-then-head shift fastest; a gaze that never reaches the braises, or a
// head that turns without the eyes, never completes

import Foundation
import Testing
@testable import Iris

@Suite("Chapter XI final: d'abord les yeux")
struct OculoTournerTests {
    private typealias Support = OculoStageTestSupport
    private var level: LevelDefinition { Campaign.finalBraises }

    private var tourner: TournerStageState? {
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        if case let .tourner(state)? = resolved.environment.oculo?.current { return state }
        return nil
    }

    private static func state(_ session: GameSession) -> TournerStageState? {
        if case let .tourner(state)? = session.oculo?.current { return state }
        return nil
    }

    private static func eyesThenHead(_ index: Int, _ session: GameSession) -> HeadPose? {
        session.oculo?.suggestedHead ?? .neutral
    }

    /// The head turns as soon as a braise lights up, before the eyes get there.
    private static func headFirst(_ index: Int, _ session: GameSession) -> HeadPose? {
        guard let state = state(session) else { return .neutral }
        switch state.phase {
        case .announce, .follow: return HeadPose(yaw: state.pose0.yaw + 8, pitch: state.pose0.pitch)
        case .rest, .done: return state.lastHead ?? .neutral
        }
    }

    @Test("structure: level 11-7 is the optional final of chapter XI; the braises light at the edges, in the comfort ranges; braise A waits at the end")
    func structure() throws {
        let chapter = try #require(Campaign.chapter(number: 11))
        #expect(chapter.levels.count == 7 && chapter.levels.last?.id == "11-7")
        #expect(Campaign.level(id: "11-7") == level && !level.gatesProgression && level.introduces == [.premierRegard])
        #expect(level.lueurs.first?.braise == .prototype)
        let state = try #require(tourner)
        #expect(state.fullYield > state.headFirstYield && state.headFirstYield > state.eyesOnlyYield && state.eyesOnlyYield > 0)
        for place in state.places {
            #expect((0.15...0.85).contains(place.x / 393) && (0.12...0.88).contains(place.y / 852))
            #expect(place.distance(to: state.center) > 150, "a braise at the edge, not near the centre")
        }
    }

    @Test("eyes first, then the head: four braises give all the warmth")
    func eyesThenHeadWins() {
        let run = Support.run(level, seconds: 60, head: Self.eyesThenHead, policy: Support.oracle)
        #expect(run.completedSequence && run.successes == 4 && run.misses == 0)
        if let state = Self.state(run.session) { #expect(state.yields.allSatisfy { $0 == state.fullYield }) }
    }

    @Test("the coordination is distinguished: head first takes twice the braises, eyes alone three times, both slower than eyes then head")
    func coordinationMatters() {
        let ideal = Support.run(level, seconds: 90, head: Self.eyesThenHead, policy: Support.oracle)
        let headFirst = Support.run(level, seconds: 90, head: Self.headFirst, policy: Support.oracle)
        let eyesOnly = Support.run(level, seconds: 90, head: { _, _ in .neutral }, policy: Support.oracle)
        #expect(ideal.completedSequence && headFirst.completedSequence && eyesOnly.completedSequence, "every coordination progresses")
        #expect(ideal.successes == 4 && headFirst.successes == 8 && eyesOnly.successes == 12)
        // Compare when the warmth was gathered (the braise lueur then waits for its own gaze, which these runs never give).
        let idealDone = ideal.session.oculo?.completedAt ?? .infinity
        let headFirstDone = headFirst.session.oculo?.completedAt ?? .infinity
        let eyesOnlyDone = eyesOnly.session.oculo?.completedAt ?? .infinity
        #expect(idealDone < headFirstDone && headFirstDone < eyesOnlyDone, "\(idealDone) \(headFirstDone) \(eyesOnlyDone)")
        if let state = Self.state(headFirst.session) { #expect(state.yields.allSatisfy { $0 == state.headFirstYield }) }
    }

    @Test("ablations: a gaze that never reaches the braises (corner, centre), a head that turns without the eyes, and random gazes never complete")
    func ablations() {
        let corner = Support.run(level, seconds: 45, head: Self.headFirst, policy: Support.corner)
        #expect(!corner.completedSequence && corner.successes == 0 && corner.misses >= 5)
        #expect(!Support.run(level, seconds: 45, head: Self.eyesThenHead, policy: Support.centre).completedSequence)
        for seed in 1...3 {
            #expect(!Support.run(level, seconds: 45, noise: true, seed: seed, head: Self.eyesThenHead, policy: Support.randomGaze).completedSequence, "seed \(seed)")
        }
    }

    @Test("no head data (simulator) still progresses as eyes alone; a gaze that leaves the braise before the head follows gives the eyes-only warmth")
    func mechanics() throws {
        let noHead = Support.run(level, seconds: 90, policy: Support.oracle)
        #expect(noHead.completedSequence && noHead.successes == 12)
        var state = try #require(tourner)
        var t = 0.0
        func step(_ gaze: Vector2, head: HeadPose? = .neutral, _ seconds: Double = 0.05) -> [OculoChange] {
            t += seconds
            return state.update(OculoInput(seconds: seconds, gaze: gaze, gazeActive: true, head: head, elapsed: t)).changes
        }
        for _ in 0..<17 { _ = step(Vector2(x: 30, y: 830)) }
        let place = try #require(state.place)
        for _ in 0..<5 { _ = step(place) }
        guard case .follow = state.phase else {
            Issue.record("expected the follow phase, got \(state.phase)")
            return
        }
        let left = step(Vector2(x: 30, y: 830))
        #expect(left == [.success] && state.yields == [state.eyesOnlyYield])
    }

    @Test("guided bot wins, avoidance and off-screen never; the scene shows the lit braise and the warmth gathered")
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
        for _ in 0..<60 { _ = session.advance(by: Support.frame) }
        let snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, marker: .hidden, diagnostics: nil)
        let oculo = try #require(snapshot.oculo)
        let announced = oculo.elements.filter { $0.role == .announce }.count
        #expect(announced == 1 && oculo.arcs.count == 1)
    }
}
