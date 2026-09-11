// HapticCuePolicyTests.swift
// Layer: Tests
// Purpose: Touch policy: one pulse per logical event, one loss per cascade, shared retrigger guard, prepare hint

import Testing
@testable import Iris

@Suite("HapticCuePolicy")
struct HapticCuePolicyTests {
    @Test("a validation pulses once")
    func validation() {
        var policy = HapticCuePolicy()

        #expect(policy.cues(for: [.targetValidated(sequence: 1)], at: 0) == [.validation])
    }

    @Test("a loss pulses once, whatever its cause")
    func loss() {
        var policy = HapticCuePolicy()

        #expect(policy.cues(for: [.targetLost(sequence: 1, cause: .drift)], at: 0) == [.loss])
        #expect(policy.cues(for: [.targetLost(sequence: 1, cause: .veilleuse), .veilleuseOut(index: 0)], at: 1) == [.loss])
    }

    @Test("a cascade in one tick is a single loss pulse")
    func cascadeCoalesced() {
        var policy = HapticCuePolicy()

        let cues = policy.cues(for: [.targetLost(sequence: 1, cause: .drift),
                                     .targetLost(sequence: 2, cause: .cascade),
                                     .targetLost(sequence: 3, cause: .cascade)], at: 1)

        #expect(cues == [.loss])
    }

    @Test("a loss outranks a validation in the same tick: one pulse only")
    func onePulsePerTick() {
        var policy = HapticCuePolicy()

        let cues = policy.cues(for: [.targetValidated(sequence: 2),
                                     .targetLost(sequence: 1, cause: .drift),
                                     .targetLost(sequence: 2, cause: .cascade)], at: 0)

        #expect(cues == [.loss])
    }

    @Test("pulses closer than the shared feedback guard do not stack; the guard is the audio loss guard")
    func retriggerGuard() {
        var policy = HapticCuePolicy()
        #expect(policy.minimumInterval == FeedbackTiming.lossRetriggerInterval)
        #expect(policy.minimumInterval == AudioCuePolicy().lossRetriggerInterval)

        // Times sit clearly inside and clearly beyond the guard: the exact boundary is a floating point coincidence, not a rule.
        let first = policy.cues(for: [.targetLost(sequence: 3, cause: .drift)], at: 1.0)
        let tooSoon = policy.cues(for: [.targetLost(sequence: 2, cause: .drift)], at: 1.0 + FeedbackTiming.lossRetriggerInterval / 3)
        let validationTooSoon = policy.cues(for: [.targetValidated(sequence: 1)], at: 1.0 + FeedbackTiming.lossRetriggerInterval / 2)
        let later = policy.cues(for: [.targetLost(sequence: 1, cause: .drift)], at: 1.0 + 2 * FeedbackTiming.lossRetriggerInterval)

        #expect(first == [.loss])
        #expect(tooSoon.isEmpty)
        #expect(validationTooSoon.isEmpty)
        #expect(later == [.loss])
    }

    @Test("the validation that completes the level is the completion pulse, never guarded")
    func completion() {
        var policy = HapticCuePolicy()

        _ = policy.cues(for: [.targetLost(sequence: 1, cause: .drift)], at: 5.0)
        let cues = policy.cues(for: [.targetValidated(sequence: 3), .levelCompleted], at: 5.01)

        #expect(cues == [.levelComplete])
    }

    @Test("a hold prepares the generator once; the pulse or a stop re-arms it")
    func prepareHint() {
        var policy = HapticCuePolicy()

        let start = policy.cues(for: [.validationProgressed(sequence: 1, progress: 0.02)], at: 0)
        let again = policy.cues(for: [.validationProgressed(sequence: 1, progress: 0.04)], at: 0.02)
        let stop = policy.cues(for: [.validationProgressStopped(sequence: 1)], at: 0.1)
        let restart = policy.cues(for: [.validationProgressed(sequence: 1, progress: 0.02)], at: 0.2)
        let validated = policy.cues(for: [.validationProgressed(sequence: 1, progress: 1), .targetValidated(sequence: 1)], at: 1)
        let nextHold = policy.cues(for: [.validationProgressed(sequence: 2, progress: 0.02)], at: 1.1)

        #expect(start == [.prepare])
        #expect(again.isEmpty)
        #expect(stop.isEmpty)
        #expect(restart == [.prepare])
        #expect(validated == [.validation])
        #expect(nextHold == [.prepare])
    }

    @Test("events without touch meaning produce nothing; reset forgets the guard")
    func silenceAndReset() {
        var policy = HapticCuePolicy()

        #expect(policy.cues(for: [.intrusion(sequence: 1), .attentionLeftField, .attentionReturned,
                                  .veilleuseLow(index: 0), .veilleuseRelit(index: 0)], at: 0).isEmpty)
        _ = policy.cues(for: [.targetLost(sequence: 1, cause: .drift)], at: 1)
        policy.reset()
        #expect(policy.cues(for: [.targetLost(sequence: 1, cause: .drift)], at: 1.01) == [.loss])
    }
}
