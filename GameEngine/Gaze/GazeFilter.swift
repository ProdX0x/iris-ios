// GazeFilter.swift
// Layer: GameEngine
// Purpose: R-13 port of the reference gaze listener: exponential smoothing (alpha 0.1) and sustained-jump gating

import Foundation

struct GazeFilter: Hashable, Sendable {
    /// `alpha = 0.1`: stability over reactivity.
    var smoothing: Double
    /// A raw sample farther than this from the cursor is a "big jump" (blink or glitch).
    var jumpThreshold: Double
    /// Number of consecutive big jumps needed before the jump is trusted as a real gaze move.
    var sustainedJumpCount: Int

    private(set) var position: Vector2
    private(set) var isActive: Bool
    private var consecutiveBigJumps: Int

    init(initialPosition: Vector2, smoothing: Double = 0.1, jumpThreshold: Double = 300, sustainedJumpCount: Int = 3) {
        self.position = initialPosition
        self.smoothing = smoothing
        self.jumpThreshold = jumpThreshold
        self.sustainedJumpCount = sustainedJumpCount
        self.isActive = false
        self.consecutiveBigJumps = 0
    }

    /// Feeds one raw sample. Returns false when the sample was ignored as an isolated big jump.
    @discardableResult
    mutating func ingest(_ raw: Vector2) -> Bool {
        let jump = raw.distance(to: position)
        if jump > jumpThreshold && isActive {
            consecutiveBigJumps += 1
            if consecutiveBigJumps < sustainedJumpCount { return false }
        } else {
            consecutiveBigJumps = 0
        }
        position = position + (raw - position) * smoothing
        isActive = true
        return true
    }

    /// Places the cursor exactly, bypassing smoothing (used by tests, golden traces and previews).
    mutating func place(at point: Vector2) {
        position = point
        isActive = true
        consecutiveBigJumps = 0
    }
}
