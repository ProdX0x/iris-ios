// VeilleuseState.swift
// Layer: GameEngine
// Purpose: R-26 resolved veilleuse and its charge

import Foundation

struct VeilleuseState: Hashable, Sendable {
    static let lowThreshold = 0.3

    let position: Vector2
    let lookRadius: Double
    let decay: TimeInterval
    let recharge: TimeInterval
    let linked: [Int]
    private(set) var charge: Double

    init(position: Vector2, lookRadius: Double, decay: TimeInterval, recharge: TimeInterval, initialCharge: Double, linked: [Int]) {
        self.position = position
        self.lookRadius = lookRadius
        self.decay = max(decay, 0.1)
        self.recharge = max(recharge, 0.05)
        self.linked = linked
        self.charge = min(max(initialCharge, 0), 1)
    }

    var isLit: Bool { charge > 0 }
    var isLow: Bool { charge < Self.lowThreshold }

    func lights(sequence: Int) -> Bool {
        linked.isEmpty || linked.contains(sequence)
    }

    func isLooked(at gaze: Vector2, gazeActive: Bool) -> Bool {
        gazeActive && gaze.distance(to: position) <= lookRadius
    }

    enum Change: Hashable, Sendable {
        case none
        case becameLow
        case wentOut
        case relit
    }

    /// Updates the charge for `seconds` and reports the threshold crossed, if any.
    mutating func update(seconds: TimeInterval, gaze: Vector2, gazeActive: Bool) -> Change {
        let before = charge
        if isLooked(at: gaze, gazeActive: gazeActive) {
            charge = min(1, charge + seconds / recharge)
        } else {
            charge = max(0, charge - seconds / decay)
        }
        if before > 0 && charge == 0 { return .wentOut }
        if before == 0 && charge > 0 { return .relit }
        if before >= Self.lowThreshold && charge < Self.lowThreshold { return .becameLow }
        return .none
    }
}
