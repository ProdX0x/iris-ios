// VeilSegment.swift
// Layer: GameEngine
// Purpose: R-25 resolved veil and its circle-segment collision response

import Foundation

struct VeilSegment: Hashable, Sendable {
    let a: Vector2
    let b: Vector2
    let halfThickness: Double

    init(a: Vector2, b: Vector2, halfThickness: Double) {
        self.a = a
        self.b = b
        self.halfThickness = halfThickness
    }

    func closestPoint(to point: Vector2) -> Vector2 {
        let ab = b - a
        let lengthSquared = ab.x * ab.x + ab.y * ab.y
        guard lengthSquared > 1e-12 else { return a }
        let t = min(max(((point.x - a.x) * ab.x + (point.y - a.y) * ab.y) / lengthSquared, 0), 1)
        return a + ab * t
    }

    func distance(to point: Vector2) -> Double {
        point.distance(to: closestPoint(to: point))
    }

    /// Pushes a disc of `radius` out of the veil and reflects the inward velocity with `bounceLoss`.
    func resolve(_ target: inout Target, radius: Double, bounceLoss: Double) {
        let closest = closestPoint(to: target.position)
        let offset = target.position - closest
        let distance = offset.length
        let minimum = radius + halfThickness
        guard distance < minimum else { return }
        let normal: Vector2
        if distance > 1e-9 {
            normal = offset / distance
        } else {
            let ab = b - a
            let length = ab.length
            normal = length > 1e-12 ? Vector2(x: -ab.y / length, y: ab.x / length) : Vector2(x: 0, y: -1)
        }
        target.position = closest + normal * minimum
        let inward = target.velocity.x * normal.x + target.velocity.y * normal.y
        if inward < 0 {
            target.velocity = target.velocity - normal * (inward * (1 + bounceLoss))
        }
    }
}
