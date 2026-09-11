// LinearCongruentialGeneratorTests.swift
// Layer: Tests
// Purpose: The generator reproduces the reference JavaScript sequence exactly

import Testing
@testable import Iris

@Suite("LinearCongruentialGenerator")
struct LinearCongruentialGeneratorTests {
    @Test("reproduces the JavaScript sequence for seed 2000 (level 1 seed)")
    func seed2000MatchesJavaScript() {
        var generator = LinearCongruentialGenerator(seed: 2000)
        let expected = [0.9524048353909464, 0.5286951303155006, 0.6047282235939644,
                        0.7885288065843621, 0.31775120027434844, 0.6152349108367627]

        for value in expected {
            #expect(abs(generator.next() - value) < 1e-15)
        }
    }

    @Test("reproduces the JavaScript sequence for seed 1000 (noise table of target 0)")
    func seed1000MatchesJavaScript() {
        var generator = LinearCongruentialGenerator(seed: 1000)
        let expected = [0.08186299725651577, 0.6190586419753087, 0.07575017146776405, 0.7636659807956104]

        for value in expected {
            #expect(abs(generator.next() - value) < 1e-15)
        }
    }

    @Test("values stay inside 0..<1")
    func valuesStayInRange() {
        var generator = LinearCongruentialGenerator(seed: 42)

        for _ in 0..<5000 {
            let value = generator.next()
            #expect(value >= 0 && value < 1)
        }
    }
}
