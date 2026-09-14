// CoeurStageState.swift
// Layer: GameEngine
// Purpose: Chapter II final: the heart warms while the gaze rests on it (hysteresis), cools while it is away; sparks
// flare on a fixed schedule and a gaze that goes to one costs warmth, once per spark

import Foundation

struct CoeurStageState: Hashable, Sendable {
    let position: Vector2
    let radius: Double
    let releaseRadius: Double
    let requirement: TimeInterval
    let decay: Double
    let distractors: [Vector2]
    let distractorPeriod: TimeInterval
    let distractorDuration: TimeInterval
    let distractorRadius: Double
    let distractorPenalty: TimeInterval
    let firstDistractorAt: TimeInterval
    private(set) var charge: TimeInterval = 0
    private(set) var isInside = false
    private(set) var caught: Set<Int> = []
    private(set) var completedAt: TimeInterval?

    init(definition: CoeurDefinition, bounds: PlayfieldBounds, shortSide: Double) {
        position = definition.position.absolute(in: bounds)
        radius = definition.radius * shortSide
        releaseRadius = definition.releaseRadius * shortSide
        requirement = definition.requirement
        decay = definition.decay
        distractors = definition.distractors.map { $0.absolute(in: bounds) }
        distractorPeriod = definition.distractorPeriod
        distractorDuration = definition.distractorDuration
        distractorRadius = definition.distractorRadius * shortSide
        distractorPenalty = definition.distractorPenalty
        firstDistractorAt = definition.firstDistractorAt
    }

    var isComplete: Bool { completedAt != nil }
    var progress: Double { min(1, charge / requirement) }

    /// The spark flaring at `time`, if any: its index in the schedule, its position and its age.
    func activeDistractor(at time: TimeInterval) -> (ordinal: Int, position: Vector2, age: TimeInterval)? {
        guard !distractors.isEmpty, time >= firstDistractorAt else { return nil }
        let ordinal = Int((time - firstDistractorAt) / distractorPeriod)
        let age = time - firstDistractorAt - Double(ordinal) * distractorPeriod
        guard age <= distractorDuration else { return nil }
        return (ordinal, distractors[(ordinal * 3) % distractors.count], age)
    }

    mutating func update(_ input: OculoInput) -> OculoOutcome {
        var outcome = OculoOutcome()
        guard !isComplete else { return outcome }
        if input.gazeActive {
            let distance = input.gaze.distance(to: position)
            if isInside {
                if distance > releaseRadius { isInside = false }
            } else if distance <= radius {
                isInside = true
            }
            if isInside {
                charge += input.seconds
            } else {
                charge = max(0, charge - decay * input.seconds)
            }
            if let spark = activeDistractor(at: input.elapsed), !caught.contains(spark.ordinal),
               input.gaze.distance(to: spark.position) <= distractorRadius {
                caught.insert(spark.ordinal)
                charge = max(0, charge - distractorPenalty)
                outcome.changes.append(.miss)
            }
        }
        if charge >= requirement {
            completedAt = input.elapsed
            outcome.changes.append(.success)
            outcome.changes.append(.completed)
        }
        return outcome
    }
}
