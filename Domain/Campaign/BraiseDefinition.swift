// BraiseDefinition.swift
// Layer: Domain
// Purpose: EXPERIMENTAL (prototype B1, not in the campaign): tuning of a braise, a cold lueur that the gaze warms and
// wakes, and that flees the gaze like any lueur; too much gaze makes it skittish for a while

import Foundation

struct BraiseDefinition: Hashable, Sendable {
    /// Gaze distance (fraction of the short side) within which the braise warms. Wide on purpose: 0.22 is 86 pt on the
    /// reference phone, above the 71 pt mean error of a calibration accepted at the limit.
    let chargeRadius: Double
    /// Distance (fraction) beyond which a warming gaze is considered gone (hysteresis against a trembling gaze).
    let releaseRadius: Double
    /// Seconds of gaze to go from cold (0) to full heat (1).
    let heatDuration: TimeInterval
    /// Seconds without gaze to go from full heat to cold.
    let coolDuration: TimeInterval
    /// Heat at which the braise lights: it wakes, drifts to its iris, and the iris accepts it.
    let acceptHeat: Double
    /// Heat under which a lit braise goes back to sleep (hysteresis).
    let releaseHeat: Double
    /// Heat at which the braise flares: its attention zone grows, it flees from farther away.
    let flareHeat: Double
    /// Attention zone multiplier at full heat.
    let flareAttention: Double
    let initialHeat: Double

    init(chargeRadius: Double = 0.22, releaseRadius: Double = 0.28, heatDuration: TimeInterval = 0.9,
         coolDuration: TimeInterval = 30, acceptHeat: Double = 0.5, releaseHeat: Double = 0.4,
         flareHeat: Double = 0.85, flareAttention: Double = 1.5, initialHeat: Double = 0) {
        self.chargeRadius = chargeRadius
        self.releaseRadius = max(releaseRadius, chargeRadius)
        self.heatDuration = max(heatDuration, 0.05)
        self.coolDuration = max(coolDuration, 0.1)
        self.acceptHeat = min(max(acceptHeat, 0), 1)
        self.releaseHeat = min(max(releaseHeat, 0), self.acceptHeat)
        self.flareHeat = min(max(flareHeat, self.acceptHeat), 1)
        self.flareAttention = max(flareAttention, 1)
        self.initialHeat = min(max(initialHeat, 0), 1)
    }

    /// The tuning under test in prototype B1.
    static let prototype = BraiseDefinition()
}
