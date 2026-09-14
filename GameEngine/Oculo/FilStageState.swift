// FilStageState.swift
// Layer: GameEngine
// Purpose: Chapter III final: the spark's smooth loop (two harmonics), the accompaniment account that grows while
// the gaze is near (hysteresis) and frays while it is away, and the trail kept for the filament

import Foundation

struct FilStageState: Hashable, Sendable {
    let center: Vector2
    let amplitude: Vector2
    let phase: Double
    let wobble: Double
    let period: TimeInterval
    let radius: Double
    let releaseRadius: Double
    let requirement: TimeInterval
    let decay: Double
    private(set) var charge: TimeInterval = 0
    private(set) var isNear = false
    /// Recent positions of the spark (oldest first), for the filament.
    private(set) var trail: [Vector2] = []
    private(set) var lostCount = 0
    private(set) var completedAt: TimeInterval?
    private var trailClock: TimeInterval = 0

    static let trailLength = 28
    static let trailInterval: TimeInterval = 0.08

    init(definition: FilDefinition, bounds: PlayfieldBounds, shortSide: Double) {
        center = definition.center.absolute(in: bounds)
        amplitude = Vector2(x: definition.amplitudeX * bounds.width, y: definition.amplitudeY * bounds.height)
        phase = definition.phase
        wobble = definition.wobble * bounds.height
        period = definition.period
        radius = definition.radius * shortSide
        releaseRadius = definition.releaseRadius * shortSide
        requirement = definition.requirement
        decay = definition.decay
    }

    var isComplete: Bool { completedAt != nil }
    var progress: Double { min(1, charge / requirement) }

    func position(at time: TimeInterval) -> Vector2 {
        let omega = 2 * Double.pi / period
        return Vector2(x: center.x + amplitude.x * sin(omega * time),
                       y: center.y + amplitude.y * sin(omega * time + phase) + wobble * sin(3 * omega * time))
    }

    mutating func update(_ input: OculoInput) -> OculoOutcome {
        var outcome = OculoOutcome()
        guard !isComplete else { return outcome }
        let spark = position(at: input.elapsed)
        trailClock += input.seconds
        if trailClock >= Self.trailInterval {
            trailClock = 0
            trail.append(spark)
            if trail.count > Self.trailLength { trail.removeFirst(trail.count - Self.trailLength) }
        }
        if input.gazeActive {
            let distance = input.gaze.distance(to: spark)
            if isNear {
                if distance > releaseRadius {
                    isNear = false
                    lostCount += 1
                    outcome.changes.append(.miss)
                }
            } else if distance <= radius {
                isNear = true
            }
            if isNear {
                charge += input.seconds
            } else {
                charge = max(0, charge - decay * input.seconds)
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
