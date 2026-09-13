// BaliseSequenceDefinition.swift
// Layer: Domain
// Purpose: PROTOTYPE (chapter I level 6): balises wake under a brief, steady gaze, one after the other along a
// fixed thread; while the thread is incomplete the irises stay shut and the lueurs stay latent

import Foundation

struct BaliseDefinition: Hashable, Sendable {
    /// Internal name used by the DEBUG trace only (never shown to the player).
    let name: String
    let position: NormalizedPoint

    init(name: String, position: NormalizedPoint) {
        self.name = name
        self.position = position
    }
}

struct BaliseSequenceDefinition: Hashable, Sendable {
    let balises: [BaliseDefinition]
    /// Indices into `balises`, in the order the thread visits them.
    let steps: [Int]
    /// Continuous gaze inside a balise needed to wake it (an experimental gameplay parameter, not a prescription).
    let dwell: TimeInterval
    /// Gaze distance (fraction of the short side) that counts as looking at the balise.
    let radius: Double
    /// Distance beyond which a gaze that was inside is considered gone (hysteresis against tracker noise).
    let releaseRadius: Double

    init(balises: [BaliseDefinition], steps: [Int], dwell: TimeInterval = 0.25, radius: Double = 0.2, releaseRadius: Double = 0.27) {
        self.balises = balises
        self.steps = steps.filter { balises.indices.contains($0) }
        self.dwell = max(dwell, 0.05)
        self.radius = max(radius, 0.05)
        self.releaseRadius = max(releaseRadius, self.radius)
    }
}
