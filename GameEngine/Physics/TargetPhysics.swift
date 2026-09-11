// TargetPhysics.swift
// Layer: GameEngine
// Purpose: R-01...R-07 frame-rate independent integration of one target, equivalent to the reference engine at 60 Hz

import Foundation

struct TargetPhysics: Hashable, Sendable {
    let constants: PhysicsConstants
    let bounds: PlayfieldBounds

    init(constants: PhysicsConstants = .reference, bounds: PlayfieldBounds) {
        self.constants = constants
        self.bounds = bounds
    }

    /// Advances `target` by `frameFraction` reference frames (1.0 is exactly one 60 Hz frame of the original engine).
    /// - R-01 attraction toward the arrival when the gaze is outside the attention zone
    /// - R-02 repulsion proportional to `attentionZone - distance` when the gaze is inside it
    /// - R-03 organic noise only while attracted (as in the reference engine)
    /// - R-04 speed cap, R-05 friction `pow(friction, frameFraction)`, R-06 integration, R-07 damped bounce
    ///
    /// R-14: the per-frame map of the reference engine is `v <- friction * (v + impulse)`. Its exact fractional
    /// power is `v <- friction^f * (v + impulse * impulseScale(f))` with
    /// `impulseScale(f) = friction^(1 - f) * (1 - friction^f) / (1 - friction)`; the cap is raised to
    /// `maxSpeed * friction^(1 - f)` so that the post-friction cruise speed is identical at every rate.
    /// At f = 1 every factor is exactly 1 and the step is bit-for-bit the reference step.
    func integrate(_ target: inout Target, gaze: Vector2, noise: (Double) -> Double, frameTime: Double, frameFraction: Double) {
        let scaling = FractionalStep(friction: constants.friction, frameFraction: frameFraction)
        let fromGaze = target.position - gaze
        let gazeDistance = nonZero(fromGaze.length)
        if gazeDistance < target.attentionZone {
            let force = target.repulsionGain * (target.attentionZone - gazeDistance)
            target.velocity += (fromGaze / gazeDistance) * (force * scaling.impulseScale)
        } else {
            let toArrival = target.arrival - target.position
            let arrivalDistance = nonZero(toArrival.length)
            target.velocity += (toArrival / arrivalDistance) * (target.passiveAttraction * scaling.impulseScale)
            target.velocity.x += noise(frameTime * 0.02) * target.noiseAmplitude * scaling.impulseScale
            target.velocity.y += noise(frameTime * 0.02 + 50) * target.noiseAmplitude * scaling.impulseScale
        }

        let speed = target.velocity.length
        let cap = constants.maxSpeed * scaling.capScale
        if speed > cap {
            target.velocity = target.velocity / speed * cap
        }

        target.velocity = target.velocity * scaling.frictionFactor
        target.position += target.velocity * frameFraction
        bounce(&target)
    }

    private func bounce(_ target: inout Target) {
        let margin = constants.edgeMargin
        if target.position.x < margin {
            target.position.x = margin
            target.velocity.x *= -constants.bounceLoss
        }
        if target.position.x > bounds.width - margin {
            target.position.x = bounds.width - margin
            target.velocity.x *= -constants.bounceLoss
        }
        if target.position.y < margin {
            target.position.y = margin
            target.velocity.y *= -constants.bounceLoss
        }
        if target.position.y > bounds.height - margin {
            target.position.y = bounds.height - margin
            target.velocity.y *= -constants.bounceLoss
        }
    }

    /// The reference engine replaces a zero distance by 0.0001 (`Math.hypot(...) || 0.0001`).
    private func nonZero(_ distance: Double) -> Double {
        distance == 0 ? 0.0001 : distance
    }
}

/// Factors that turn one reference frame into a fraction of it (R-14).
struct FractionalStep: Hashable, Sendable {
    let frictionFactor: Double
    let impulseScale: Double
    let capScale: Double

    init(friction: Double, frameFraction: Double) {
        if frameFraction == 1 {
            frictionFactor = friction
            impulseScale = 1
            capScale = 1
        } else {
            let frictionToFraction = pow(friction, frameFraction)
            let remainder = pow(friction, 1 - frameFraction)
            frictionFactor = frictionToFraction
            impulseScale = friction < 1 ? remainder * (1 - frictionToFraction) / (1 - friction) : frameFraction
            capScale = remainder
        }
    }
}
