// GameClock.swift
// Layer: GameEngine
// Purpose: Frame source abstraction: delivers deltaTime ticks to the game loop

import Foundation

@MainActor
protocol GameClock: AnyObject {
    var isRunning: Bool { get }
    func start(_ onTick: @escaping @MainActor (TimeInterval) -> Void)
    func stop()
}
