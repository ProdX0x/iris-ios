// EchoField.swift
// Layer: GameEngine
// Purpose: Chapter IX resolved echo: the reach, speed, breathing interval and launch of the rings that closing irises
// emit, the rings in flight, and the sleep state of the lueurs they can wake

import Foundation

struct EchoField: Hashable, Sendable {
    /// Reach of a ring (points).
    let radius: Double
    /// Speed of the ring front (points per second).
    let speed: Double
    /// Seconds between two breaths of a closed iris.
    let interval: TimeInterval
    /// Impulse (points per reference frame) given to a woken lueur, away from the iris.
    let burst: Double

    init(definition: EchoDefinition, shortSide: Double, scale: Double) {
        radius = definition.radius * shortSide
        speed = definition.speed * shortSide
        interval = definition.interval
        burst = definition.burst * scale
    }
}

/// One ring in flight, emitted by the iris of `source` at `origin`.
struct EchoWave: Hashable, Sendable {
    let source: Int
    let origin: Vector2
    let startTime: TimeInterval
    /// Targets the front has already passed.
    var reached: Set<Int>

    init(source: Int, origin: Vector2, startTime: TimeInterval, reached: Set<Int> = []) {
        self.source = source
        self.origin = origin
        self.startTime = startTime
        self.reached = reached
    }

    func front(at time: TimeInterval, speed: Double) -> Double {
        max(0, time - startTime) * speed
    }
}

struct SleeperState: Hashable, Sendable {
    private(set) var isAwake: Bool
    private(set) var wokenAt: TimeInterval?

    init(isAwake: Bool = false) {
        self.isAwake = isAwake
        self.wokenAt = nil
    }

    mutating func wake(at time: TimeInterval) {
        isAwake = true
        wokenAt = time
    }

    /// Asleep: no drift, no jitter (the gaze still repels).
    var behaviour: BehaviourScale {
        isAwake ? .neutral : BehaviourScale(attentionZone: 1, drift: 0)
    }
}
