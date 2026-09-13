// HapticCuePolicy.swift
// Layer: Haptics
// Purpose: Touch policy: at most one pulse per tick (completion over loss over validation), one loss per cascade,
// pulses spaced by the shared feedback guard, a prepare hint when a hold starts

import Foundation

struct HapticCuePolicy: Hashable, Sendable {
    /// Minimum spacing between two pulses. Defaults to the loss guard shared with the audio policy (R-15).
    var minimumInterval: TimeInterval
    private var lastPulseTime: TimeInterval
    private var isPrepared: Bool

    init(minimumInterval: TimeInterval = FeedbackTiming.lossRetriggerInterval) {
        self.minimumInterval = minimumInterval
        self.lastPulseTime = -.infinity
        self.isPrepared = false
    }

    /// Converts the events of one tick into cues. One logical event, one pulse: several losses in the same tick
    /// (drift plus cascade) collapse into a single loss; the validation that completes the level becomes the
    /// completion pulse; a loss outranks a validation. Pulses closer than `minimumInterval` to the previous one are
    /// dropped, except the completion, which ends the loop.
    mutating func cues(for events: [GameEvent], at time: TimeInterval) -> [HapticCue] {
        var cues: [HapticCue] = []
        var validated = false
        var lost = false
        var completed = false
        var holding = false
        var stopped = false
        for event in events {
            switch event {
            case .targetValidated:
                validated = true
            case .targetLost, .veilleuseOut:
                lost = true
            case .levelCompleted:
                completed = true
            case .validationProgressed:
                holding = true
            case .validationProgressStopped:
                stopped = true
            case .intrusion, .attentionLeftField, .attentionReturned, .veilleuseLow, .veilleuseRelit,
                 .braiseLit, .braiseCooled, .braiseFlared, .twinsLinked, .twinsParted, .lueurCarried, .lueurDropped,
                 .echoEmitted, .lueurWoken:
                break
            }
        }
        if stopped && !holding {
            isPrepared = false
        }
        let pulse: HapticCue? = completed ? .levelComplete : (lost ? .loss : (validated ? .validation : nil))
        if let pulse {
            if pulse == .levelComplete || time - lastPulseTime >= minimumInterval {
                cues.append(pulse)
                lastPulseTime = time
                isPrepared = false
            }
        } else if holding && !isPrepared {
            cues.append(.prepare)
            isPrepared = true
        }
        return cues
    }

    mutating func reset() {
        lastPulseTime = -.infinity
        isPrepared = false
    }
}
