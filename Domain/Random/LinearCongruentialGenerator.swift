// LinearCongruentialGenerator.swift
// Layer: Domain
// Purpose: Deterministic generator identical to the reference engine's `rngFor` / `makeNoise1D` (9301, 49297, 233280)

import Foundation

struct LinearCongruentialGenerator: Hashable, Sendable {
    private var state: Int

    init(seed: Int) {
        state = seed
    }

    /// Next value in 0..<1, bit-for-bit equal to the JavaScript sequence for the seeds used by the engine.
    mutating func next() -> Double {
        state = (state * 9301 + 49297) % 233280
        return Double(state) / 233280
    }
}
