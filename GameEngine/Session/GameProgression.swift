// GameProgression.swift
// Layer: GameEngine
// Purpose: R-12 progression through the fourteen levels

import Foundation

struct GameProgression: Hashable, Sendable {
    enum Outcome: Hashable, Sendable {
        case nextLevel(Level)
        case journeyFinished
    }

    let levels: [Level]
    private(set) var currentIndex: Int
    private(set) var isFinished: Bool

    init(levels: [Level] = LevelCatalog.all, startingIndex: Int = 0) {
        let resolved = levels.isEmpty ? LevelCatalog.all : levels
        self.levels = resolved
        self.currentIndex = min(max(startingIndex, 0), resolved.count - 1)
        self.isFinished = false
    }

    var levelCount: Int { levels.count }
    var currentLevel: Level { levels[currentIndex] }
    var currentNumber: Int { currentIndex + 1 }
    var isLastLevel: Bool { currentIndex == levels.count - 1 }

    /// Moves to the next level, or marks the journey as finished after the last one.
    mutating func completeCurrentLevel() -> Outcome {
        let next = currentIndex + 1
        guard next < levels.count else {
            isFinished = true
            return .journeyFinished
        }
        currentIndex = next
        return .nextLevel(levels[next])
    }

    mutating func restart() {
        currentIndex = 0
        isFinished = false
    }
}
