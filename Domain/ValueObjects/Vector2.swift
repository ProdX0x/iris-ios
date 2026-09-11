// Vector2.swift
// Layer: Domain
// Purpose: Two-dimensional vector in playfield points (the reference engine's canvas pixels)

import Foundation

struct Vector2: Hashable, Sendable, Codable {
    var x: Double
    var y: Double

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    static let zero = Vector2(x: 0, y: 0)

    var length: Double { (x * x + y * y).squareRoot() }

    func distance(to other: Vector2) -> Double { (self - other).length }

    static func + (lhs: Vector2, rhs: Vector2) -> Vector2 { Vector2(x: lhs.x + rhs.x, y: lhs.y + rhs.y) }
    static func - (lhs: Vector2, rhs: Vector2) -> Vector2 { Vector2(x: lhs.x - rhs.x, y: lhs.y - rhs.y) }
    static func * (lhs: Vector2, rhs: Double) -> Vector2 { Vector2(x: lhs.x * rhs, y: lhs.y * rhs) }
    static func / (lhs: Vector2, rhs: Double) -> Vector2 { Vector2(x: lhs.x / rhs, y: lhs.y / rhs) }
    static func += (lhs: inout Vector2, rhs: Vector2) { lhs = lhs + rhs }
}
