// PlayfieldBounds.swift
// Layer: Domain
// Purpose: Size of the game space in points; the reference engine used the browser window size

import Foundation

struct PlayfieldBounds: Hashable, Sendable {
    var width: Double
    var height: Double

    init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }

    var center: Vector2 { Vector2(x: width / 2, y: height / 2) }

    /// A portrait iPhone playfield used by tests, previews and golden traces.
    static let referencePhone = PlayfieldBounds(width: 390, height: 844)
}
