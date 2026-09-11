// CurrentDefinition.swift
// Layer: Domain
// Purpose: R-24 a band where lueurs are carried in one direction

import Foundation

struct CurrentDefinition: Hashable, Sendable {
    let area: NormalizedRect
    /// Unit direction in screen axes (x right, y down).
    let direction: Vector2
    /// Impulse per reference frame at scale 1 (always stronger than the attraction).
    let strength: Double

    init(area: NormalizedRect, direction: Vector2, strength: Double = 0.85) {
        let length = direction.length
        self.area = area
        self.direction = length > 0 ? direction / length : Vector2(x: 0, y: 1)
        self.strength = strength
    }
}
