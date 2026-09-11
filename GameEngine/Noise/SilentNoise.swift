// SilentNoise.swift
// Layer: GameEngine
// Purpose: Zero noise, used by tests and previews that need fully predictable motion

import Foundation

struct SilentNoise: NoiseSource, Hashable {
    init() {}

    func value(at time: Double) -> Double { 0 }
}
