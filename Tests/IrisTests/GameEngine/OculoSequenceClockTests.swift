// OculoSequenceClockTests.swift
// Layer: Tests
// Purpose: OCULOMOTOR EXPANSION: a stage placed after others starts on its own clock, after the breath, and behaves
// exactly as the same stage played alone

import Foundation
import Testing
@testable import Iris

@Suite("Oculomotor sequence clock")
struct OculoSequenceClockTests {
    private let bounds = PlayfieldBounds(width: 393, height: 852)

    @Test("the second stage starts at zero on its own clock, after the breath")
    func stageClock() throws {
        let stars = EtoilesDefinition(candidates: [Campaign.pt(0.2, 0.2), Campaign.pt(0.8, 0.8)], rounds: [[0]])
        let heart = CoeurDefinition(position: Campaign.pt(0.5, 0.5), requirement: 1, distractors: [])
        let stages: [OculoStageState] = [.coeur(CoeurStageState(definition: heart, bounds: bounds, shortSide: 393)),
                                         .etoiles(EtoilesStageState(definition: stars, bounds: bounds, shortSide: 393))]
        var sequence = OculoSequenceState(stages: stages, hidesLueurs: true, pause: 0.5)
        var t = 0.0
        let centre = Vector2(x: 196.5, y: 426)
        var changes: [OculoSequenceState.Change] = []
        while t < 1.5 {
            t += 1.0 / 60
            changes += sequence.update(OculoInput(seconds: 1.0 / 60, gaze: centre, gazeActive: true, head: nil, elapsed: t), targets: [], braisesLit: []).changes
        }
        #expect(changes.contains(.stageCompleted(stage: 0)) && sequence.currentIndex == 1)
        #expect(sequence.stageStartedAt > 1.4 && sequence.stageStartedAt < 1.6, "\(sequence.stageStartedAt)")
        guard case let .etoiles(state)? = sequence.current else {
            Issue.record("second stage missing")
            return
        }
        #expect(state.isShowing, "the stars of the second stage are shown, not skipped")
        #expect(abs(sequence.stageTime(at: sequence.stageStartedAt + 0.3) - 0.3) < 1e-9)
        #expect(sequence.suggestedGaze(at: t) == Vector2(x: 0.2 * 393, y: 0.2 * 852))
    }
}
