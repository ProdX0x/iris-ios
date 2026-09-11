// IrisPath.swift
// Layer: GameEngine
// Purpose: R-27 resolved gliding iris: cosine ease between two points

import Foundation

struct IrisPath: Hashable, Sendable {
    let from: Vector2
    let to: Vector2
    let period: TimeInterval

    init(from: Vector2, to: Vector2, period: TimeInterval) {
        self.from = from
        self.to = to
        self.period = max(period, 0.1)
    }

    func position(at time: TimeInterval) -> Vector2 {
        let phase = (1 - cos(2 * Double.pi * time / period)) / 2
        return from + (to - from) * phase
    }
}
