// OculoEtoilesTests.swift
// Layer: Tests
// Purpose: Chapter V final « les étoiles absentes »: stars shown then hidden come back only where the gaze dwells at
// their place; wrong places count a miss without penalty; a round not recalled in time is shown again; remembering
// wins, fixed and random gazes never do

import Foundation
import Testing
@testable import Iris

@Suite("Chapter V final: étoiles absentes")
struct OculoEtoilesTests {
    private typealias Support = OculoStageTestSupport
    private var level: LevelDefinition { Campaign.finalVeilleuses }

    private var etoiles: EtoilesStageState? {
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        if case let .etoiles(state)? = resolved.environment.oculo?.current { return state }
        return nil
    }

    @Test("structure: level 5-7 is the optional final of chapter V, rounds grow from two to three stars, candidates in the comfort ranges")
    func structure() throws {
        let chapter = try #require(Campaign.chapter(number: 5))
        #expect(chapter.levels.count == 7 && chapter.levels.last?.id == "5-7")
        #expect(Campaign.level(id: "5-7") == level && !level.gatesProgression && level.introduces == [.etoileAbsente])
        let state = try #require(etoiles)
        #expect(state.rounds.map(\.count) == [2, 2, 3, 3])
        for candidate in state.candidates {
            #expect((0.15...0.85).contains(candidate.x / 393) && (0.12...0.88).contains(candidate.y / 852))
        }
        for i in state.candidates.indices {
            for j in state.candidates.indices where j > i {
                #expect(state.candidates[i].distance(to: state.candidates[j]) > state.releaseRadius, "candidates \(i) and \(j) overlap")
            }
        }
        #expect(!level.veilleuses.isEmpty, "the flame of chapter V lights the iris at the end")
    }

    @Test("remembering the stars wins: watch, wait, return to each place; the constellation grows and the iris opens")
    func remembering() throws {
        let run = Support.run(level, seconds: 90, policy: Support.oracle)
        #expect(run.completedSequence && run.misses == 0)
        let state = try #require(etoiles)
        #expect(run.successes == state.totalStars)
        #expect(!run.session.areLueursLatent)
    }

    @Test("ablations: a fixed gaze never recalls, a random gaze never draws the constellation, every timeout shows the round again")
    func ablations() {
        let centre = Support.run(level, seconds: 60, policy: Support.centre)
        #expect(!centre.completedSequence && centre.successes == 0)
        if case let .etoiles(state)? = centre.session.oculo?.current { #expect(state.repeats >= 3, "the round is shown again after every recall limit") }
        for seed in 1...3 {
            let random = Support.run(level, seconds: 60, noise: true, seed: seed, policy: Support.randomGaze)
            #expect(!random.completedSequence, "seed \(seed)")
        }
    }

    @Test("during recall a wrong place counts one miss and nothing else; the right place counts once; hysteresis keeps the dwell across a tremble")
    func recall() throws {
        var state = try #require(etoiles)
        // Through show and blank.
        _ = state.update(OculoInput(seconds: state.showDuration + 0.01, gaze: Support.bounds.center, gazeActive: true, head: nil, elapsed: state.showDuration + 0.01))
        _ = state.update(OculoInput(seconds: state.blankDuration + 0.01, gaze: Support.bounds.center, gazeActive: true, head: nil, elapsed: state.showDuration + state.blankDuration + 0.02))
        #expect(state.isRecalling)
        let round = state.currentRound
        let wrong = try #require(state.candidates.indices.first { !round.contains($0) })
        var t = state.showDuration + state.blankDuration + 0.1
        var events: [OculoChange] = []
        for _ in 0..<20 {
            t += 0.05
            events += state.update(OculoInput(seconds: 0.05, gaze: state.candidates[wrong], gazeActive: true, head: nil, elapsed: t)).changes
        }
        #expect(events == [.miss] && state.found.isEmpty, "one miss, no penalty, no repeat")
        let right = round[0]
        t += 0.05
        _ = state.update(OculoInput(seconds: 0.05, gaze: state.candidates[right], gazeActive: true, head: nil, elapsed: t))
        t += 0.05
        _ = state.update(OculoInput(seconds: 0.05, gaze: state.candidates[right] + Vector2(x: state.radius + 5, y: 0), gazeActive: true, head: nil, elapsed: t))
        #expect(state.dwellingOn == right && abs(state.dwellTime - 0.1) < 1e-9, "a tremble past the radius keeps the dwell")
        var found: [OculoChange] = []
        for _ in 0..<4 {
            t += 0.05
            found += state.update(OculoInput(seconds: 0.05, gaze: state.candidates[right], gazeActive: true, head: nil, elapsed: t)).changes
        }
        #expect(found == [.success] && state.found == [right])
    }

    @Test("guided bot wins, the player blind to the flame and the avoidance player never; the scene hides the stars during recall")
    func botsAndScene() throws {
        let guided = (1...3).map { CampaignBot(definition: level, policy: .guided, seed: $0).run(maxSeconds: 90) }
        let solved = guided.allSatisfy(\.completed)
        #expect(solved, "guided \(guided.map(\.time))")
        #expect(!CampaignBot(definition: level, policy: .avoidance).run(maxSeconds: 60).completed)
        #expect(!CampaignBot(definition: level, policy: .ignoresVeilleuses).run(maxSeconds: 60).completed)
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        var session = resolved.makeSession(noiseSources: [SilentNoise()])
        session.placeGaze(at: Support.bounds.center)
        for _ in 0..<30 { _ = session.advance(by: Support.frame) }
        let showing = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, showsGaze: false, diagnostics: nil)
        #expect(showing.oculo?.elements.filter { $0.role == .star && $0.intensity > 0 }.count == 2, "two stars shine")
        for _ in 0..<Int(2.2 * 60) { _ = session.advance(by: Support.frame) }
        let recalling = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, showsGaze: false, diagnostics: nil)
        #expect(recalling.oculo?.elements.allSatisfy { $0.role != .star || ($0.intensity == 0 && !$0.isLit && !$0.isActive) } == true, "nothing reveals the places")
    }
}
