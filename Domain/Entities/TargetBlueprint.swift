// TargetBlueprint.swift
// Layer: Domain
// Purpose: Static description of one target of a level (the reference engine's level target config)

import Foundation

struct TargetBlueprint: Hashable, Sendable {
    /// Validation order, 1-based (`seq` in the reference engine).
    let sequence: Int
    let start: NormalizedPoint
    let arrival: NormalizedPoint
    /// Gaze distance under which the sphere is repelled (`zone_attention`, points).
    let attentionZone: Double
    /// Repulsion gain (`k_repulsion`), points per frame per point of intrusion.
    let repulsionGain: Double
    /// Attraction impulse toward the arrival (`attraction_passive`), points per frame.
    let passiveAttraction: Double
    /// Organic drift amplitude (`amplitude_bruit`), points per frame.
    let noiseAmplitude: Double

    init(sequence: Int, start: NormalizedPoint, arrival: NormalizedPoint, attentionZone: Double,
         repulsionGain: Double, passiveAttraction: Double, noiseAmplitude: Double) {
        self.sequence = sequence
        self.start = start
        self.arrival = arrival
        self.attentionZone = attentionZone
        self.repulsionGain = repulsionGain
        self.passiveAttraction = passiveAttraction
        self.noiseAmplitude = noiseAmplitude
    }
}
