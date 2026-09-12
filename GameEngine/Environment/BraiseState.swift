// BraiseState.swift
// Layer: GameEngine
// Purpose: EXPERIMENTAL (prototype B1): resolved braise and its heat; lit with hysteresis, flaring above a threshold

import Foundation

struct BraiseState: Hashable, Sendable {
    let chargeRadius: Double
    let releaseRadius: Double
    let heatDuration: TimeInterval
    let coolDuration: TimeInterval
    let acceptHeat: Double
    let releaseHeat: Double
    let flareHeat: Double
    let flareAttention: Double
    private(set) var heat: Double
    /// True while a gaze is warming the braise (hysteresis between the two radii).
    private(set) var isCharging = false
    /// Lit: awake, drifting to its iris, accepted by it. Cold: asleep, refused.
    private(set) var isLit: Bool

    init(definition: BraiseDefinition, shortSide: Double) {
        chargeRadius = definition.chargeRadius * shortSide
        releaseRadius = definition.releaseRadius * shortSide
        heatDuration = definition.heatDuration
        coolDuration = definition.coolDuration
        acceptHeat = definition.acceptHeat
        releaseHeat = definition.releaseHeat
        flareHeat = definition.flareHeat
        flareAttention = definition.flareAttention
        heat = definition.initialHeat
        isLit = definition.initialHeat >= definition.acceptHeat
    }

    var isFlaring: Bool { heat >= flareHeat }

    /// How the braise's behaviour departs from a normal lueur: asleep it neither drifts nor jitters;
    /// flaring, its attention zone grows linearly up to `flareAttention` at full heat.
    var behaviour: BehaviourScale {
        var scale = BehaviourScale.neutral
        if !isLit { scale.drift = 0 }
        if isFlaring && flareHeat < 1 {
            scale.attentionZone = 1 + (flareAttention - 1) * (heat - flareHeat) / (1 - flareHeat)
        }
        return scale
    }

    enum Change: Hashable, Sendable {
        case none
        case lit
        case cooled
        case flared
    }

    /// Updates the heat for `seconds` given the gaze distance to the braise; reports the most important threshold crossed.
    mutating func update(seconds: TimeInterval, gazeDistance: Double, gazeActive: Bool) -> Change {
        let wasLit = isLit
        let wasFlaring = isFlaring
        let radius = isCharging ? releaseRadius : chargeRadius
        isCharging = gazeActive && gazeDistance <= radius
        if isCharging {
            heat = min(1, heat + seconds / heatDuration)
        } else {
            heat = max(0, heat - seconds / coolDuration)
        }
        if !isLit && heat >= acceptHeat {
            isLit = true
        } else if isLit && heat < releaseHeat {
            isLit = false
        }
        if !wasFlaring && isFlaring { return .flared }
        if !wasLit && isLit { return .lit }
        if wasLit && !isLit { return .cooled }
        return .none
    }
}

/// Per-step multipliers applied by the integrator; neutral for every lueur that is not a braise, so the reference
/// step stays bit-for-bit identical (multiplying by 1.0 is exact).
struct BehaviourScale: Hashable, Sendable {
    /// Multiplies the attention zone (and therefore the reach of the repulsion).
    var attentionZone: Double
    /// Multiplies the passive attraction and the organic noise (0 freezes an asleep braise).
    var drift: Double

    init(attentionZone: Double = 1, drift: Double = 1) {
        self.attentionZone = attentionZone
        self.drift = drift
    }

    static let neutral = BehaviourScale()
}
