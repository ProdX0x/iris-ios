// OculoCourantTests.swift
// Layer: Tests
// Purpose: Chapter VIII final « la lanterne du courant »: the lantern's loop is smooth and learnable; from the second
// lap it vanishes in the mist; a gaze where it comes out catches it; predicting wins, freezing on the last seen
// position, waiting at one exit, the centre and random gazes never do

import Foundation
import Testing
@testable import Iris

@Suite("Chapter VIII final: lanterne du courant")
struct OculoCourantTests {
    private typealias Support = OculoStageTestSupport
    private var level: LevelDefinition { Campaign.finalSouffles }

    private var courant: CourantStageState? {
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        if case let .courant(state)? = resolved.environment.oculo?.current { return state }
        return nil
    }

    private static func state(_ session: GameSession) -> (CourantStageState, TimeInterval)? {
        guard let oculo = session.oculo, case let .courant(state)? = oculo.current else { return nil }
        return (state, oculo.stageTime(at: session.elapsed))
    }

    @Test("structure: level 8-7 is the optional final of chapter VIII; three mists, and a whole lap to learn before the first one")
    func structure() throws {
        let chapter = try #require(Campaign.chapter(number: 8))
        #expect(chapter.levels.count == 7 && chapter.levels.last?.id == "8-7")
        #expect(Campaign.level(id: "8-7") == level && !level.gatesProgression && level.introduces == [.lanterne])
        let state = try #require(courant)
        #expect(state.mists.count == 3 && state.mistFrom >= state.period && state.required >= state.mists.count)
        #expect(state.mist(at: state.mistFrom - 0.01) == nil)
    }

    @Test("the loop is smooth, comfortable, inside the comfort ranges, and each mist hides the lantern long enough that a frozen gaze cannot catch it")
    func loop() throws {
        let state = try #require(courant)
        var previous = state.position(at: 0)
        var fastest = 0.0
        for step in 1...Int(2 * state.period * 60) {
            let point = state.position(at: Double(step) / 60)
            fastest = max(fastest, point.distance(to: previous) * 60)
            previous = point
            #expect((0.15...0.85).contains(point.x / 393) && (0.12...0.88).contains(point.y / 852), "loop leaves the comfort ranges at \(point)")
        }
        #expect(fastest < 240, "\(fastest) pt/s")
        for (index, mist) in state.mists.enumerated() {
            let travel = state.position(atFraction: mist.start).distance(to: state.position(atFraction: mist.end))
            #expect(travel > state.catchRadius * 1.3, "mist \(index): the lantern travels only \(travel) pt while hidden")
        }
    }

    @Test("predicting wins: following the lantern through the mist catches it at every exit")
    func predicting() {
        let run = Support.run(level, seconds: 60, policy: Support.oracle)
        #expect(run.completedSequence && run.misses == 0 && run.successes >= 5 && !run.session.areLueursLatent)
    }

    @Test("ablations: freezing on the last seen position, waiting at one exit, the centre and random gazes never complete the stage")
    func ablations() {
        // A reactive player: looks where the lantern was seen 0.35 s ago (a human reaction), and freezes on the last
        // place seen while it is hidden. It never anticipates the exit.
        let frozen = Support.run(level, seconds: 60) { _, session, _ in
            guard let (state, t) = Self.state(session) else { return Vector2(x: 30, y: 830) }
            var back = max(0, t - 0.35)
            while state.mist(at: back) != nil && back > t - 5 { back -= 1.0 / 60 }
            return state.position(at: back)
        }
        #expect(!frozen.completedSequence && frozen.misses >= 3, "reactive: misses \(frozen.misses), catches \(frozen.successes)")
        let waiting = Support.run(level, seconds: 60) { _, session, _ in
            Self.state(session).map { $0.0.exits[0] } ?? Vector2(x: 30, y: 830)
        }
        #expect(!waiting.completedSequence)
        if let (state, _) = Self.state(waiting.session) { #expect(state.caught.count <= 1) }
        #expect(!Support.run(level, seconds: 60, policy: Support.centre).completedSequence)
        for seed in 1...3 {
            #expect(!Support.run(level, seconds: 60, noise: true, seed: seed, policy: Support.randomGaze).completedSequence, "seed \(seed)")
        }
    }

    @Test("the catch opens when the lantern comes out and lasts the window; late is a miss")
    func catchWindow() throws {
        let initial = try #require(courant)
        var exit = initial.mistFrom
        while initial.mist(at: exit) != 0 { exit += 1.0 / 240 }
        while initial.mist(at: exit) != nil { exit += 1.0 / 240 }
        var caught = initial
        var t = 0.0
        while t < exit - 0.05 {
            t += 1.0 / 60
            _ = caught.update(OculoInput(seconds: 1.0 / 60, gaze: Vector2(x: 30, y: 830), gazeActive: true, head: nil, elapsed: t))
        }
        var changes: [OculoChange] = []
        for _ in 0..<12 {
            t += 1.0 / 60
            changes += caught.update(OculoInput(seconds: 1.0 / 60, gaze: caught.position(at: t), gazeActive: true, head: nil, elapsed: t)).changes
        }
        #expect(changes == [.success] && caught.caught == [0])
        var late = initial
        t = 0
        var lateChanges: [OculoChange] = []
        while t < exit + late.catchWindow + 0.1 {
            t += 1.0 / 60
            lateChanges += late.update(OculoInput(seconds: 1.0 / 60, gaze: Vector2(x: 30, y: 830), gazeActive: true, head: nil, elapsed: t)).changes
        }
        #expect(lateChanges == [.miss] && late.drops == 1)
    }

    @Test("guided bot wins, avoidance and off-screen never; the scene shows the track, the mists, the exits, and no lantern while it is hidden")
    func botsAndScene() throws {
        let guided = (1...3).map { CampaignBot(definition: level, policy: .guided, seed: $0).run(maxSeconds: 90) }
        let solved = guided.allSatisfy(\.completed)
        #expect(solved, "guided \(guided.map(\.time))")
        #expect(!CampaignBot(definition: level, policy: .avoidance).run(maxSeconds: 60).completed)
        #expect(!CampaignBot(definition: level, policy: .offScreen).run(maxSeconds: 30).completed)
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        let initial = try #require(courant)
        var hiddenAt = initial.mistFrom
        while initial.mist(at: hiddenAt) == nil { hiddenAt += 1.0 / 60 }
        var session = resolved.makeSession(noiseSources: [SilentNoise()])
        session.placeGaze(at: Vector2(x: 30, y: 830))
        while session.elapsed < hiddenAt + 0.05 { _ = session.advance(by: Support.frame) }
        let snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, showsGaze: false, diagnostics: nil)
        let oculo = try #require(snapshot.oculo)
        let relays = oculo.elements.filter { $0.role == .relay }.count
        let lanterns = oculo.elements.filter { $0.role == .lantern }.count
        let mists = oculo.polylines.filter { $0.isMist }.count
        #expect(relays == 3 && mists == 3 && lanterns == 0)
    }
}
