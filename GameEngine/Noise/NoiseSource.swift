// NoiseSource.swift
// Layer: GameEngine
// Purpose: One-dimensional organic noise abstraction so the engine can be driven by deterministic or silent noise

import Foundation

protocol NoiseSource: Sendable {
    /// Value in -1...1 for the given continuous time.
    func value(at time: Double) -> Double
}
