// EchoDefinition.swift
// Layer: Domain
// Purpose: Chapter IX: the echo of a closing iris, a ring that wakes the sleeping lueurs it reaches and launches them;
// a closed iris keeps breathing the same ring at a slow interval

import Foundation

struct EchoDefinition: Hashable, Sendable {
    /// How far the ring reaches (fraction of the short side).
    let radius: Double
    /// Speed of the ring front (short sides per second).
    let speed: Double
    /// Seconds between two breaths of a closed iris.
    let interval: TimeInterval
    /// Impulse (points per reference frame at scale 1) given to a lueur the ring wakes, away from the iris.
    let burst: Double

    init(radius: Double = 0.45, speed: Double = 0.9, interval: TimeInterval = 4, burst: Double = 6) {
        self.radius = max(radius, 0.05)
        self.speed = max(speed, 0.1)
        self.interval = max(interval, 0.5)
        self.burst = max(burst, 0)
    }

    static let standard = EchoDefinition()
}
