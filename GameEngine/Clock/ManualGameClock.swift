// ManualGameClock.swift
// Layer: GameEngine
// Purpose: Deterministic clock driven by tests and previews

import Foundation

@MainActor
final class ManualGameClock: GameClock {
    private(set) var isRunning = false
    private var onTick: (@MainActor (TimeInterval) -> Void)?

    init() {}

    func start(_ onTick: @escaping @MainActor (TimeInterval) -> Void) {
        self.onTick = onTick
        isRunning = true
    }

    func stop() {
        isRunning = false
        onTick = nil
    }

    /// Delivers one tick of `deltaTime` seconds when running.
    func tick(_ deltaTime: TimeInterval) {
        guard isRunning else { return }
        onTick?(deltaTime)
    }

    func tick(frames: Int, frameDuration: TimeInterval = 1.0 / 60.0) {
        for _ in 0..<frames { tick(frameDuration) }
    }
}
