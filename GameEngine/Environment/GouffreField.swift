// GouffreField.swift
// Layer: GameEngine
// Purpose: Chapter X resolved well: mouth, pull and the swallow it inflicts (a hold, then the return to the start)

import Foundation

struct GouffreField: Hashable, Sendable {
    let center: Vector2
    let radius: Double
    let pullRadius: Double
    /// Impulse per reference frame at the mouth.
    let strength: Double

    init(center: Vector2, radius: Double, pullRadius: Double, strength: Double) {
        self.center = center
        self.radius = max(radius, 1)
        self.pullRadius = max(pullRadius, self.radius + 1)
        self.strength = max(strength, 0)
    }

    func swallows(_ point: Vector2) -> Bool {
        point.distance(to: center) < radius
    }

    /// Pull toward the centre: nothing beyond the pull radius, full strength at the mouth, linear in between.
    func impulse(at point: Vector2) -> Vector2 {
        let toCenter = center - point
        let distance = toCenter.length
        guard distance < pullRadius, distance > 1e-9 else { return .zero }
        let share = min(1, (pullRadius - distance) / (pullRadius - radius))
        return toCenter / distance * (strength * share)
    }
}

/// Chapter X: a lueur inside a well, held at its centre until the well sends it back to its start.
struct SwallowState: Hashable, Sendable {
    static let duration: TimeInterval = 0.7

    let center: Vector2
    let since: TimeInterval

    init(center: Vector2, since: TimeInterval) {
        self.center = center
        self.since = since
    }

    func progress(at time: TimeInterval) -> Double {
        min(1, max(0, (time - since) / Self.duration))
    }

    func isOver(at time: TimeInterval) -> Bool {
        time - since >= Self.duration
    }
}
