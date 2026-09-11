// CurrentField.swift
// Layer: GameEngine
// Purpose: R-24 resolved current: an axis-aligned band applying a constant impulse

import Foundation

struct CurrentField: Hashable, Sendable {
    let minX: Double
    let minY: Double
    let maxX: Double
    let maxY: Double
    /// Impulse per reference frame (points).
    let impulse: Vector2

    init(minX: Double, minY: Double, maxX: Double, maxY: Double, impulse: Vector2) {
        self.minX = minX
        self.minY = minY
        self.maxX = maxX
        self.maxY = maxY
        self.impulse = impulse
    }

    func contains(_ point: Vector2) -> Bool {
        point.x >= minX && point.x <= maxX && point.y >= minY && point.y <= maxY
    }
}
