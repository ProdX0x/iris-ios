// NormalizedPoint.swift
// Layer: Domain
// Purpose: Resolution-independent position (0...1 on both axes), resolved against the playfield at load time

import Foundation

struct NormalizedPoint: Hashable, Sendable {
    var x: Double
    var y: Double

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    func absolute(in bounds: PlayfieldBounds) -> Vector2 {
        Vector2(x: x * bounds.width, y: y * bounds.height)
    }
}
