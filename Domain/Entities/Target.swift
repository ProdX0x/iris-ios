// Target.swift
// Layer: Domain
// Purpose: Runtime state of one sphere: position, velocity, destination, hold progress and validation

import Foundation

struct Target: Identifiable, Hashable, Sendable {
    let id: TargetID
    var position: Vector2
    var velocity: Vector2
    /// Iris position; mutable because an iris may glide (R-27).
    var arrival: Vector2
    let attentionZone: Double
    let repulsionGain: Double
    let passiveAttraction: Double
    let noiseAmplitude: Double
    /// Continuous time required inside the arrival zone before validation.
    let requiredHoldTime: TimeInterval
    /// Continuous time spent inside the arrival zone while it is this target's turn.
    var holdTime: TimeInterval
    var isValidated: Bool
    /// 0...1 share of the maximum repulsion felt during the last step (visual trouble only, no physics effect).
    var disturbance: Double = 0

    init(id: TargetID, position: Vector2, velocity: Vector2 = .zero, arrival: Vector2, attentionZone: Double,
         repulsionGain: Double, passiveAttraction: Double, noiseAmplitude: Double, requiredHoldTime: TimeInterval,
         holdTime: TimeInterval = 0, isValidated: Bool = false) {
        self.id = id
        self.position = position
        self.velocity = velocity
        self.arrival = arrival
        self.attentionZone = attentionZone
        self.repulsionGain = repulsionGain
        self.passiveAttraction = passiveAttraction
        self.noiseAmplitude = noiseAmplitude
        self.requiredHoldTime = requiredHoldTime
        self.holdTime = holdTime
        self.isValidated = isValidated
    }

    init(blueprint: TargetBlueprint, bounds: PlayfieldBounds, holdDuration: TimeInterval) {
        self.init(id: TargetID(sequence: blueprint.sequence),
                  position: blueprint.start.absolute(in: bounds),
                  arrival: blueprint.arrival.absolute(in: bounds),
                  attentionZone: blueprint.attentionZone,
                  repulsionGain: blueprint.repulsionGain,
                  passiveAttraction: blueprint.passiveAttraction,
                  noiseAmplitude: blueprint.noiseAmplitude,
                  requiredHoldTime: holdDuration)
    }

    var sequence: Int { id.sequence }
    var speed: Double { velocity.length }
    var distanceToArrival: Double { position.distance(to: arrival) }

    /// 0...1 progress toward validation (`holdFrames / holdRequired` in the reference engine).
    var validationProgress: Double {
        guard requiredHoldTime > 0 else { return 1 }
        return min(1, holdTime / requiredHoldTime)
    }

    /// True while the target accumulates presence but is not validated yet (drives the audio crescendo).
    var isHolding: Bool { !isValidated && holdTime > 0 }
}
