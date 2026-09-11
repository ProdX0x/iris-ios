// LevelLabTests.swift
// Layer: Tests
// Purpose: Prints the measured table of every campaign level (design tool; always passes)

import Foundation
import Testing
@testable import Iris

@Suite("Level lab")
struct LevelLabTests {
    @Test("measure every level")
    func measure() {
        var lines = ["id | guided (3 seeds) done | time | intr | loss | avoid | ignoresV | offscreen | free | cross | guard | diff | route | turn"]
        for level in Campaign.levels {
            let measurement = CampaignMeasurements.of(level)
            let guided = measurement.guided
            let avoidance = measurement.avoidance
            let ignores = measurement.ignoresVeilleuses
            let off = measurement.offScreen
            let done = guided.filter(\.completed).count
            let time = measurement.guidedTime
            let intrusions = measurement.guidedIntrusions
            let losses = measurement.guidedLosses
            let analysis = LevelAnalysis(level)
            let line = String(format: "%@ | %d/3 | %.1f | %.1f | %.1f | %@ %.0f | %@ | %@ | %.2f | %d | %d | %.2f | %.2f | %.0f",
                              level.id, done, time, intrusions, losses,
                              avoidance.completed ? "yes" : "no", avoidance.time,
                              ignores.map { $0.completed ? "yes" : "no" } ?? "-",
                              off.completed ? "yes" : "no",
                              analysis.freeArea, analysis.crossings, analysis.guardPressure, analysis.difficulty(botTime: time),
                              analysis.longestRoute, analysis.turning)
            lines.append(line)
        }
        print("LEVEL-LAB\n" + lines.joined(separator: "\n") + "\nLEVEL-LAB-END")
    }
}
