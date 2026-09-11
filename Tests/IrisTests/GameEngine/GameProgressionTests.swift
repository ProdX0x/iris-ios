// GameProgressionTests.swift
// Layer: Tests
// Purpose: R-12 progression across the fourteen levels

import Testing
@testable import Iris

@Suite("GameProgression")
struct GameProgressionTests {
    @Test("starts at level 1 of 14")
    func start() {
        let progression = GameProgression()

        #expect(progression.levelCount == 14)
        #expect(progression.currentNumber == 1)
        #expect(progression.currentLevel.targetCount == 1)
        #expect(!progression.isFinished)
    }

    @Test("completing a level moves to the next one until the journey finishes after level 14")
    func advance() {
        var progression = GameProgression()
        var visited = [progression.currentNumber]

        while true {
            switch progression.completeCurrentLevel() {
            case let .nextLevel(level):
                visited.append(level.number)
                continue
            case .journeyFinished:
                break
            }
            break
        }

        #expect(visited == Array(1...14))
        #expect(progression.isFinished)
        #expect(progression.isLastLevel)
    }

    @Test("restart goes back to level 1")
    func restart() {
        var progression = GameProgression()
        _ = progression.completeCurrentLevel()
        _ = progression.completeCurrentLevel()

        progression.restart()

        #expect(progression.currentNumber == 1)
        #expect(!progression.isFinished)
    }

    @Test("an empty level list falls back to the catalog")
    func emptyFallsBack() {
        let progression = GameProgression(levels: [])

        #expect(progression.levelCount == 14)
    }
}
