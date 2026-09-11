// AudioCuePolicyTests.swift
// Layer: Tests
// Purpose: Sound policy: crescendo per target, chime on validation, one loss tone per cascade

import Testing
@testable import Iris

@Suite("AudioCuePolicy")
struct AudioCuePolicyTests {
    @Test("progress events map to per-target crescendo voices")
    func progressMapping() {
        var policy = AudioCuePolicy()

        let cues = policy.cues(for: [.validationProgressed(sequence: 2, progress: 0.5),
                                     .validationProgressStopped(sequence: 1)], at: 0)

        #expect(cues == [.progress(voice: 1, progress: 0.5), .stopProgress(voice: 0)])
    }

    @Test("a validation plays the chime")
    func validation() {
        var policy = AudioCuePolicy()

        #expect(policy.cues(for: [.targetValidated(sequence: 1)], at: 0) == [.validation])
    }

    @Test("a cascade in one tick produces a single loss tone")
    func cascadeCoalesced() {
        var policy = AudioCuePolicy()

        let cues = policy.cues(for: [.targetLost(sequence: 1, cause: .drift),
                                     .targetLost(sequence: 2, cause: .cascade),
                                     .targetLost(sequence: 3, cause: .cascade)], at: 1)

        #expect(cues == [.loss])
    }

    @Test("losses closer than the retrigger interval do not stack")
    func retriggerGuard() {
        var policy = AudioCuePolicy(lossRetriggerInterval: 0.15)

        let first = policy.cues(for: [.targetLost(sequence: 3, cause: .drift)], at: 1.0)
        let tooSoon = policy.cues(for: [.targetLost(sequence: 2, cause: .drift)], at: 1.05)
        let later = policy.cues(for: [.targetLost(sequence: 1, cause: .drift)], at: 1.2)

        #expect(first == [.loss])
        #expect(tooSoon.isEmpty)
        #expect(later == [.loss])
    }

    @Test("the validation that completes the level plays the arpeggio instead of the chime")
    func levelCompletedArpeggio() {
        var policy = AudioCuePolicy()

        let cues = policy.cues(for: [.targetValidated(sequence: 3), .levelCompleted], at: 0)

        #expect(cues == [.levelComplete])
    }

    @Test("a dying veilleuse loses like a validation, and its pulse is rate limited")
    func veilleuseSounds() {
        var policy = AudioCuePolicy(pulseInterval: 1)

        let low = policy.cues(for: [.veilleuseLow(index: 0)], at: 0)
        let tooSoon = policy.cues(for: [.veilleuseLow(index: 1)], at: 0.5)
        let out = policy.cues(for: [.veilleuseOut(index: 0), .targetLost(sequence: 1, cause: .veilleuse)], at: 2)

        #expect(low == [.veilleuseLow])
        #expect(tooSoon.isEmpty)
        #expect(out == [.loss])
        #expect(policy.cues(for: [.intrusion(sequence: 1), .attentionLeftField, .attentionReturned, .veilleuseRelit(index: 0)], at: 3).isEmpty)
    }
}
