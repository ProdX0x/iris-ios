// OculoDefinition.swift
// Layer: Domain
// Purpose: OCULOMOTOR EXPANSION: a level may open with a sequence of gaze-contingent stages (one per paradigm),
// each a small deterministic machine; while the sequence is incomplete the lueurs may stay latent

import Foundation

/// One stage of a gaze-contingent sequence. Cases are added chapter by chapter.
enum OculoStageDefinition: Hashable, Sendable {
}

struct OculoDefinition: Hashable, Sendable {
    let stages: [OculoStageDefinition]
    /// Whether the lueurs wait, unseen and still, until the sequence completes.
    let hidesLueurs: Bool
    /// Breath between two stages (seconds).
    let pause: TimeInterval
    /// The Carnet idea this sequence embodies.
    let element: GameElement

    init(stages: [OculoStageDefinition], element: GameElement, hidesLueurs: Bool = true, pause: TimeInterval = 0.6) {
        self.stages = stages
        self.element = element
        self.hidesLueurs = hidesLueurs
        self.pause = max(pause, 0)
    }
}
