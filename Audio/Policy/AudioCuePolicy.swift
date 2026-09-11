// AudioCuePolicy.swift
// Layer: Audio
// Purpose: Sound policy: crescendo per target, one chime per validation, one loss tone per tick with a retrigger guard

import Foundation

struct AudioCuePolicy: Hashable, Sendable {
    /// Minimum spacing between two loss tones, so cascades spread over consecutive ticks do not stutter.
    var lossRetriggerInterval: TimeInterval
    private var lastLossTime: TimeInterval

    init(lossRetriggerInterval: TimeInterval = 0.15) {
        self.lossRetriggerInterval = lossRetriggerInterval
        self.lastLossTime = -.infinity
    }

    /// Converts the events of one tick into cues. Several losses in the same tick (drift plus cascade)
    /// collapse into a single loss tone.
    mutating func cues(for events: [GameEvent], at time: TimeInterval) -> [AudioCue] {
        var cues: [AudioCue] = []
        var lossRequested = false
        for event in events {
            switch event {
            case let .validationProgressed(sequence, progress):
                cues.append(.progress(voice: sequence - 1, progress: progress))
            case let .validationProgressStopped(sequence):
                cues.append(.stopProgress(voice: sequence - 1))
            case .targetValidated:
                cues.append(.validation)
            case .targetLost:
                lossRequested = true
            case .levelCompleted:
                break
            }
        }
        if lossRequested && time - lastLossTime >= lossRetriggerInterval {
            cues.append(.loss)
            lastLossTime = time
        }
        return cues
    }

    mutating func reset() {
        lastLossTime = -.infinity
    }
}
