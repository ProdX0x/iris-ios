// GameEvent.swift
// Layer: GameEngine
// Purpose: Facts produced by one engine tick, consumed by audio, haptics and presentation

import Foundation

enum LossCause: Hashable, Sendable {
    /// The validated sphere drifted beyond the wobble tolerance.
    case drift
    /// A lower-ranked sphere lost its validation (R-11).
    case cascade
}

enum GameEvent: Hashable, Sendable {
    case validationProgressed(sequence: Int, progress: Double)
    case validationProgressStopped(sequence: Int)
    case targetValidated(sequence: Int)
    case targetLost(sequence: Int, cause: LossCause)
    case levelCompleted
}
