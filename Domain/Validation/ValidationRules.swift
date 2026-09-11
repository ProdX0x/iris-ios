// ValidationRules.swift
// Layer: Domain
// Purpose: Distances governing validation and its loss (R-08, R-10)

import Foundation

struct ValidationRules: Hashable, Sendable {
    /// `SETTLE_RADIUS = RADIUS_ARRIVAL - RADIUS_TARGET`: distance to the arrival under which presence counts.
    var settleRadius: Double
    /// Extra tolerance granted once validated (`WOBBLE_TOLERANCE = SETTLE_RADIUS + 20`).
    var wobbleMargin: Double
    /// Floating point slack when comparing accumulated hold time with the required duration.
    var holdEpsilon: TimeInterval

    init(settleRadius: Double, wobbleMargin: Double = 20, holdEpsilon: TimeInterval = 1e-6) {
        self.settleRadius = settleRadius
        self.wobbleMargin = wobbleMargin
        self.holdEpsilon = holdEpsilon
    }

    var wobbleTolerance: Double { settleRadius + wobbleMargin }

    static func reference(physics: PhysicsConstants = .reference) -> ValidationRules {
        ValidationRules(settleRadius: physics.arrivalRadius - physics.targetRadius)
    }

    static let reference = ValidationRules.reference()
}
