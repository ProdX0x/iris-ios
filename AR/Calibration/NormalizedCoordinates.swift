// NormalizedCoordinates.swift
// Layer: AR (calibration, pure Swift)
// Purpose: Conversions between viewport points and resolution-independent 0...1 coordinates

import Foundation
import simd

enum NormalizedCoordinates {
    static func normalized(_ point: Vector2, in viewport: PlayfieldBounds) -> SIMD2<Double> {
        SIMD2(point.x / viewport.width, point.y / viewport.height)
    }

    static func points(_ normalized: SIMD2<Double>, in viewport: PlayfieldBounds) -> Vector2 {
        Vector2(x: normalized.x * viewport.width, y: normalized.y * viewport.height)
    }

    /// Distance between two normalized positions measured in points, divided by the shorter viewport side.
    static func error(between lhs: SIMD2<Double>, and rhs: SIMD2<Double>, in viewport: PlayfieldBounds) -> Double {
        let dx = (lhs.x - rhs.x) * viewport.width
        let dy = (lhs.y - rhs.y) * viewport.height
        return (dx * dx + dy * dy).squareRoot() / min(viewport.width, viewport.height)
    }

    static func isFinite(_ value: SIMD2<Double>) -> Bool {
        value.x.isFinite && value.y.isFinite
    }
}
