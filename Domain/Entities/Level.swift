// Level.swift
// Layer: Domain
// Purpose: One of the fourteen levels: its targets, hold duration and sequencing mode

import Foundation

struct Level: Hashable, Sendable, Identifiable {
    let id: LevelID
    /// 1-based level number shown to the player.
    let number: Int
    let targets: [TargetBlueprint]
    /// Continuous presence required inside the arrival zone before validation (0.75 s, 45 frames at 60 Hz).
    let holdDuration: TimeInterval
    /// When true, validation only counts in sequence order 1, 2, 3.
    let isSequential: Bool

    init(id: LevelID, number: Int, targets: [TargetBlueprint], holdDuration: TimeInterval, isSequential: Bool) {
        self.id = id
        self.number = number
        self.targets = targets
        self.holdDuration = holdDuration
        self.isSequential = isSequential
    }

    var targetCount: Int { targets.count }
}
