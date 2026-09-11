// LaunchOptionsTests.swift
// Layer: Tests
// Purpose: Debug launch argument parsing

import Foundation
import Testing
@testable import Iris

@Suite("LaunchOptions")
struct LaunchOptionsTests {
    @Test("parses route, level and autoplay")
    func parse() {
        let options = LaunchOptions.parse(["Iris", "--iris-route", "game", "--iris-level", "9", "--iris-autoplay"])

        #expect(options.initialRoute == .game)
        #expect(options.startingLevel == 9)
        #expect(options.autoplay)
    }

    @Test("ignores unknown arguments and bad values")
    func ignoresUnknown() {
        let options = LaunchOptions.parse(["Iris", "-NSFoo", "--iris-route", "nowhere", "--iris-level", "x"])

        #expect(options.initialRoute == nil)
        #expect(options.startingLevel == nil)
        #expect(!options.autoplay)
    }

    @Test("progression clamps the starting level into range")
    func startingIndexClamp() {
        #expect(GameProgression(startingIndex: 99).currentNumber == 14)
        #expect(GameProgression(startingIndex: -3).currentNumber == 1)
        #expect(GameProgression(startingIndex: 8).currentNumber == 9)
    }
}
