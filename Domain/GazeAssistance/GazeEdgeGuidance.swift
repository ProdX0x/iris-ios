// GazeEdgeGuidance.swift
// Layer: Domain
// Purpose: Which edge the gaze has left the playfield by, and how far — using only what the pipeline really
// measures. It never invents a position: beyond the mapper's own clamp the intensity simply saturates

import Foundation

struct GazeEdgeGuidance: Hashable, Sendable {
    enum Direction: String, Hashable, Sendable, CaseIterable {
        case left, right, top, bottom
        case topLeft, topRight, bottomLeft, bottomRight
    }

    let direction: Direction
    /// 0 just outside the edge, 1 where the mapper stops measuring. Never beyond: Iris does not know.
    let intensity: Double

    init(direction: Direction, intensity: Double) {
        self.direction = direction
        self.intensity = min(max(intensity, 0), 1)
    }

    /// The fraction of a viewport side the gaze mapper still projects outside it before clamping
    /// (`GazeMapper.overshoot`). The intensity is normalised by this, so a saturated overshoot reads as 1 and
    /// nothing claims to know more.
    static let measurableOvershoot = 0.5

    /// Nil while the gaze is inside the playfield: there is nothing to point at.
    static func from(point: Vector2, in bounds: PlayfieldBounds) -> GazeEdgeGuidance? {
        let left = -point.x
        let right = point.x - bounds.width
        let top = -point.y
        let bottom = point.y - bounds.height
        let spanX = bounds.width * measurableOvershoot
        let spanY = bounds.height * measurableOvershoot

        let horizontal: (side: Direction, amount: Double)? =
            left > 0 ? (.left, left / spanX) : (right > 0 ? (.right, right / spanX) : nil)
        let vertical: (side: Direction, amount: Double)? =
            top > 0 ? (.top, top / spanY) : (bottom > 0 ? (.bottom, bottom / spanY) : nil)

        switch (horizontal, vertical) {
        case (nil, nil):
            return nil
        case let (side?, nil):
            return GazeEdgeGuidance(direction: side.side, intensity: side.amount)
        case let (nil, side?):
            return GazeEdgeGuidance(direction: side.side, intensity: side.amount)
        case let (h?, v?):
            return GazeEdgeGuidance(direction: corner(horizontal: h.side, vertical: v.side),
                                    intensity: max(h.amount, v.amount))
        }
    }

    private static func corner(horizontal: Direction, vertical: Direction) -> Direction {
        switch (vertical, horizontal) {
        case (.top, .left): .topLeft
        case (.top, .right): .topRight
        case (.bottom, .left): .bottomLeft
        default: .bottomRight
        }
    }
}
