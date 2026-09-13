// LaunchOptionsTests.swift
// Layer: Tests
// Purpose: Debug launch argument parsing and seeded progress

import Foundation
import Testing
@testable import Iris

@Suite("LaunchOptions")
struct LaunchOptionsTests {
    @Test("parses route, level, progress, autoplay and oracle gaze")
    func parse() {
        let options = LaunchOptions.parse(["Iris", "--iris-route", "chapters", "--iris-level", "4-3", "--iris-progress", "all",
                                           "--iris-autoplay", "--iris-oracle-gaze", "--iris-gaze", "10,20"])

        #expect(options.initialRoute == .chapters)
        #expect(options.level == "4-3")
        #expect(options.seededProgress == .all)
        #expect(options.autoplay)
        #expect(options.oracleGaze)
        #expect(options.parkedGaze == Vector2(x: 10, y: 20))
    }

    @Test("ignores unknown arguments and invalid values")
    func invalid() {
        let options = LaunchOptions.parse(["Iris", "-NSFoo", "--iris-route", "nowhere", "--iris-level", "9-9", "--iris-progress", "x"])

        #expect(options.initialRoute == nil)
        #expect(options.level == nil)
        #expect(options.seededProgress == nil)
    }

    @Test("seeded progress completes levels up to the given one with varied éclats")
    func seeded() {
        let through = LaunchOptions.progress(for: .through("2-1"))
        let all = LaunchOptions.progress(for: .all)

        // PROTOTYPE branch: the optional level 1-6 precedes 2-1, so seven levels are completed.
        #expect(through.completedCount(in: Campaign.levels) == 7)
        #expect(through.nextLevel(in: Campaign.levels)?.id == "2-2")
        #expect(all.nextLevel(in: Campaign.levels) == nil)
        let counts = Set(Campaign.levels.map { all.record(for: $0).eclats.count })
        #expect(counts.count >= 2)
        #expect(all.encounteredElements == Set(GameElement.allCases))
    }
}
