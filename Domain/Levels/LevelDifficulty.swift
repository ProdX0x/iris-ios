// LevelDifficulty.swift
// Layer: Domain
// Purpose: Difficulty band parameters exactly as defined by the reference engine's `buildLevel`

import Foundation

struct LevelDifficulty: Hashable, Sendable {
    let targetCount: Int
    /// Base attention zone before the gaze multiplier (220, 190, 150).
    let baseAttentionZone: Double
    let repulsionGain: Double
    let passiveAttraction: Double

    init(targetCount: Int, baseAttentionZone: Double, repulsionGain: Double, passiveAttraction: Double) {
        self.targetCount = targetCount
        self.baseAttentionZone = baseAttentionZone
        self.repulsionGain = repulsionGain
        self.passiveAttraction = passiveAttraction
    }

    /// Levels 1-3: one target. Levels 4-8: two targets. Levels 9-14: three targets.
    static func band(forLevelIndex index: Int) -> LevelDifficulty {
        if index < 3 {
            return LevelDifficulty(targetCount: 1, baseAttentionZone: 220, repulsionGain: 0.008, passiveAttraction: 0.6)
        } else if index < 8 {
            return LevelDifficulty(targetCount: 2, baseAttentionZone: 190, repulsionGain: 0.009, passiveAttraction: 0.55)
        } else {
            return LevelDifficulty(targetCount: 3, baseAttentionZone: 150, repulsionGain: 0.013, passiveAttraction: 0.5)
        }
    }
}
