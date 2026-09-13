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
            case .targetValidated, .balisesCompleted:
                // PROTOTYPE: the thread of balises completing is a closing of the same weight as a validation.
                if !completes { cues.append(.validation) }
            case .targetLost, .veilleuseOut, .lueurSwallowed:
                // A well swallowing a lueur is a setback of the same weight as a loss: the same tone.
                lossRequested = true
            case .levelCompleted:
                cues.append(.levelComplete)
            case .veilleuseLow, .braiseLit, .twinsLinked, .lueurCarried, .lueurWoken, .baliseLit:
                // A braise that lights, twins that see each other, a gust that picks a lueur up and an echo that wakes one
                // reuse the soft pulse: one idea, one sound.
                pulseRequested = true
            case .intrusion, .attentionLeftField, .attentionReturned, .veilleuseRelit, .braiseCooled, .braiseFlared, .twinsParted,
                 .lueurDropped, .echoEmitted, .lueurReturned, .lueurReleased:
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
