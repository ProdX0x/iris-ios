// SouffleDefinition.swift
// Layer: Domain
// Purpose: Chapter VIII: a gust that travels a track periodically and carries the lueurs it crosses, over veils

import Foundation

struct SouffleDefinition: Hashable, Sendable {
    /// Track of the gust, at least two points; it appears at the first and vanishes at the last.
    let path: [NormalizedPoint]
    /// Seconds between two gusts.
    let period: TimeInterval
    /// Share of the period during which the gust exists and travels (the rest is the pause before the next one).
    let duty: Double
    /// Radius of the gust (fraction of the short side): a lueur inside it is carried.
    let radius: Double
    /// Impulse per reference frame at scale 1, along the track. Stronger than a current, weaker than a close gaze.
    let strength: Double
    /// Initial phase (0...1), to stagger several gusts.
    let phase: Double

    init(path: [NormalizedPoint], period: TimeInterval = 7, duty: Double = 0.7, radius: Double = 0.16,
         strength: Double = 1.6, phase: Double = 0) {
        self.path = path
        self.period = max(period, 1)
        self.duty = min(max(duty, 0.2), 0.95)
        self.radius = max(radius, 0.05)
        self.strength = max(strength, 0)
        self.phase = phase - phase.rounded(.down)
    }
}
