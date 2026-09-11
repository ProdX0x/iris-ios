// VeilleuseDefinition.swift
// Layer: Domain
// Purpose: R-26 a flame that dies unless looked at; while dark it closes the irises it lights

import Foundation

struct VeilleuseDefinition: Hashable, Sendable {
    let position: NormalizedPoint
    /// Gaze distance (fraction of the short side) that counts as looking at the flame.
    let lookRadius: Double
    /// Seconds for a full flame to die when not looked at.
    let decay: TimeInterval
    /// Seconds of looking to refill an empty flame.
    let recharge: TimeInterval
    let initialCharge: Double
    /// Sequences of the lueurs whose iris this flame lights; empty means all.
    let linked: [Int]

    init(position: NormalizedPoint, lookRadius: Double = 0.14, decay: TimeInterval = 8, recharge: TimeInterval = 0.8,
         initialCharge: Double = 0.4, linked: [Int] = []) {
        self.position = position
        self.lookRadius = lookRadius
        self.decay = decay
        self.recharge = recharge
        self.initialCharge = min(max(initialCharge, 0), 1)
        self.linked = linked
    }

    func lights(sequence: Int) -> Bool {
        linked.isEmpty || linked.contains(sequence)
    }
}
