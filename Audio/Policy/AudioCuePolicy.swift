// AudioCuePolicy.swift
// Layer: Audio
// Purpose: Sound policy: crescendo per target, one chime per validation (arpeggio for the last one),
// one loss tone per tick with a retrigger guard, rate-limited veilleuse pulses

import Foundation

struct AudioCuePolicy: Hashable, Sendable {
    /// Minimum spacing between two loss tones, so cascades spread over consecutive ticks do not stutter.
    /// Shared with the haptic policy through `FeedbackTiming` (R-15).
    var lossRetriggerInterval: TimeInterval
    /// Minimum spacing between two veilleuse pulses.
    var pulseInterval: TimeInterval
    private var lastLossTime: TimeInterval
    private var lastPulseTime: TimeInterval

    init(lossRetriggerInterval: TimeInterval = FeedbackTiming.lossRetriggerInterval, pulseInterval: TimeInterval = 1.0) {
        self.lossRetriggerInterval = lossRetriggerInterval
        self.pulseInterval = pulseInterval
        self.lastLossTime = -.infinity
        self.lastPulseTime = -.infinity
    }

    /// Converts the events of one tick into cues. Several losses in the same tick (drift plus cascade)
    /// collapse into a single loss tone; the validation that completes the level becomes the arpeggio.
    mutating func cues(for events: [GameEvent], at time: TimeInterval) -> [AudioCue] {
        var cues: [AudioCue] = []
        var lossRequested = false
        var pulseRequested = false
        let completes = events.contains(.levelCompleted)
        for event in events {
            switch event {
            case let .validationProgressed(sequence, progress):
                cues.append(.progress(voice: sequence - 1, progress: progress))
            case let .validationProgressStopped(sequence):
                cues.append(.stopProgress(voice: sequence - 1))
            case .targetValidated:
                if !completes { cues.append(.validation) }
            case .targetLost, .veilleuseOut:
                lossRequested = true
            case .levelCompleted:
                cues.append(.levelComplete)
            case .veilleuseLow, .braiseLit:
                // EXPERIMENTAL: a braise that lights reuses the soft pulse until the idea earns a cue of its own.
                pulseRequested = true
            case .intrusion, .attentionLeftField, .attentionReturned, .veilleuseRelit, .braiseCooled, .braiseFlared:
                break
            }
        }
        if lossRequested && time - lastLossTime >= lossRetriggerInterval {
            cues.append(.loss)
            lastLossTime = time
        }
        if pulseRequested && time - lastPulseTime >= pulseInterval {
            cues.append(.veilleuseLow)
            lastPulseTime = time
        }
        return cues
    }

    mutating func reset() {
        lastLossTime = -.infinity
        lastPulseTime = -.infinity
    }
}
