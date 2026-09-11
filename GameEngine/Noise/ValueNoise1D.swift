// ValueNoise1D.swift
// Layer: GameEngine
// Purpose: Port of `makeNoise1D`: 256 random values, smoothstep interpolation (Perlin-like value noise)

import Foundation

struct ValueNoise1D: NoiseSource, Hashable {
    private static let tableSize = 256
    private let table: [Double]

    init(seed: Int) {
        var generator = LinearCongruentialGenerator(seed: seed)
        table = (0..<Self.tableSize).map { _ in generator.next() * 2 - 1 }
    }

    func value(at time: Double) -> Double {
        let floored = time.rounded(.down)
        let base = Int(floored)
        let index = ((base % Self.tableSize) + Self.tableSize) % Self.tableSize
        let fraction = time - floored
        let a = table[index]
        let b = table[(index + 1) % Self.tableSize]
        let u = fraction * fraction * (3 - 2 * fraction)
        return a * (1 - u) + b * u
    }
}
