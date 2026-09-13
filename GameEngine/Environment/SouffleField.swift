// SouffleField.swift
// Layer: GameEngine
// Purpose: Chapter VIII resolved gust: a disc travelling its track at constant speed, present during the duty share of
// each period, carrying (and lifting over veils) every lueur inside it

import Foundation

struct SouffleField: Hashable, Sendable {
    let path: [Vector2]
    let period: TimeInterval
    let duty: Double
    let radius: Double
    /// Impulse per reference frame along the track.
    let strength: Double
    let phase: Double
    /// Cumulative length at each vertex of the track.
    private let cumulative: [Double]

    init(path: [Vector2], period: TimeInterval, duty: Double, radius: Double, strength: Double, phase: Double) {
        let points = path.count >= 2 ? path : (path + [path.first ?? .zero, path.first ?? .zero])
        self.path = points
        self.period = max(period, 1)
        self.duty = min(max(duty, 0.2), 0.95)
        self.radius = max(radius, 1)
        self.strength = max(strength, 0)
        self.phase = phase - phase.rounded(.down)
        var cumulative = [0.0]
        for index in 1..<points.count {
            cumulative.append(cumulative[index - 1] + points[index].distance(to: points[index - 1]))
        }
        self.cumulative = cumulative
    }

    var length: Double { cumulative.last ?? 0 }
    /// Travel speed in points per second.
    var speed: Double { length / (duty * period) }

    /// Where the gust is on its track and which way it goes; nil while it is absent (pause between two gusts).
    func state(at time: TimeInterval) -> (position: Vector2, direction: Vector2, presence: Double)? {
        let cycle = time / period + phase
        let progress = cycle - cycle.rounded(.down)
        guard progress < duty else { return nil }
        let along = progress / duty
        let distance = along * length
        var segment = 1
        while segment < path.count - 1 && cumulative[segment] < distance { segment += 1 }
        let from = path[segment - 1]
        let to = path[segment]
        let segmentLength = max(cumulative[segment] - cumulative[segment - 1], 1e-9)
        let t = min(max((distance - cumulative[segment - 1]) / segmentLength, 0), 1)
        let direction = (to - from) / segmentLength
        // Fades in over the first tenth of its life and out over the last tenth.
        let presence = min(1, min(along, 1 - along) / 0.1)
        return (from + (to - from) * t, direction, presence)
    }

    func contains(_ point: Vector2, at time: TimeInterval) -> Bool {
        guard let state = state(at: time) else { return false }
        return point.distance(to: state.position) <= radius
    }

    /// Impulse on a lueur at `point`: full strength inside three quarters of the radius, fading to nothing at the rim.
    func impulse(at point: Vector2, time: TimeInterval) -> Vector2 {
        guard let state = state(at: time) else { return .zero }
        let distance = point.distance(to: state.position)
        guard distance <= radius else { return .zero }
        let rim = min(1, (radius - distance) / (0.25 * radius))
        return state.direction * (strength * rim)
    }
}
