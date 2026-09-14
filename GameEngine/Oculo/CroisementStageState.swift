// CroisementStageState.swift
// Layer: GameEngine
// Purpose: Chapter VII final: two twins on a diagonal; the breathing one is acquired by a dwell and hands over to her
// sister; after a leg's exchanges both glide to the next leg (diagonal and amplitude change)

import Foundation

struct CroisementStageState: Hashable, Sendable {
    let center: Vector2
    /// Positions of the twins (first, second) for each leg, in points.
    let legPositions: [(Vector2, Vector2)]
    let exchanges: [Int]
    let radius: Double
    let releaseRadius: Double
    let dwell: TimeInterval
    let glide: TimeInterval
    private(set) var legIndex = 0
    private(set) var exchangesOnLeg = 0
    /// 0: the first twin breathes, 1: the second.
    private(set) var active = 0
    private(set) var dwellTime: TimeInterval = 0
    private(set) var isInside = false
    private(set) var successes = 0
    private(set) var legStartedAt: TimeInterval?
    private(set) var completedAt: TimeInterval?

    init(definition: CroisementDefinition, bounds: PlayfieldBounds, shortSide: Double) {
        let center = definition.center.absolute(in: bounds)
        self.center = center
        legPositions = definition.legs.map { leg in
            let offset = Vector2(x: leg.dx * bounds.width, y: leg.dy * bounds.height)
            switch leg.diagonal {
            case .falling: return (center - offset, center + offset)
            case .rising: return (Vector2(x: center.x + offset.x, y: center.y - offset.y), Vector2(x: center.x - offset.x, y: center.y + offset.y))
            }
        }
        exchanges = definition.legs.map(\.exchanges)
        radius = definition.radius * shortSide
        releaseRadius = definition.releaseRadius * shortSide
        dwell = definition.dwell
        glide = definition.glide
        if legPositions.isEmpty { completedAt = 0 }
    }

    static func == (lhs: CroisementStageState, rhs: CroisementStageState) -> Bool {
        lhs.center == rhs.center && lhs.legIndex == rhs.legIndex && lhs.exchangesOnLeg == rhs.exchangesOnLeg && lhs.active == rhs.active
            && lhs.dwellTime == rhs.dwellTime && lhs.isInside == rhs.isInside && lhs.successes == rhs.successes
            && lhs.legStartedAt == rhs.legStartedAt && lhs.completedAt == rhs.completedAt
            && lhs.legPositions.map(\.0) == rhs.legPositions.map(\.0) && lhs.legPositions.map(\.1) == rhs.legPositions.map(\.1)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(legIndex)
        hasher.combine(exchangesOnLeg)
        hasher.combine(active)
        hasher.combine(successes)
    }

    var isComplete: Bool { completedAt != nil }
    var totalExchanges: Int { exchanges.reduce(0, +) }
    var progress: Double { totalExchanges == 0 ? 1 : Double(successes) / Double(totalExchanges) }

    /// Where the twins are at `time`: gliding from the previous leg for `glide` seconds after a leg change.
    func twins(at time: TimeInterval) -> (Vector2, Vector2) {
        guard legPositions.indices.contains(legIndex) else { return legPositions.last ?? (center, center) }
        let target = legPositions[legIndex]
        guard legIndex > 0, let started = legStartedAt, glide > 0, time - started < glide else { return target }
        let from = legPositions[legIndex - 1]
        let t = max(0, time - started) / glide
        let ease = (1 - cos(Double.pi * t)) / 2
        return (from.0 + (target.0 - from.0) * ease, from.1 + (target.1 - from.1) * ease)
    }

    func activePosition(at time: TimeInterval) -> Vector2 {
        let pair = twins(at: time)
        return active == 0 ? pair.0 : pair.1
    }

    mutating func update(_ input: OculoInput) -> OculoOutcome {
        var outcome = OculoOutcome()
        guard !isComplete, input.gazeActive else { return outcome }
        let target = activePosition(at: input.elapsed)
        let distance = input.gaze.distance(to: target)
        if isInside {
            if distance > releaseRadius {
                isInside = false
                dwellTime = 0
            }
        } else if distance <= radius {
            isInside = true
            dwellTime = 0
        }
        guard isInside else { return outcome }
        dwellTime += input.seconds
        guard dwellTime >= dwell - 1e-9 else { return outcome }
        successes += 1
        exchangesOnLeg += 1
        active = 1 - active
        isInside = false
        dwellTime = 0
        outcome.changes.append(.success)
        if exchangesOnLeg >= exchanges[legIndex] {
            legIndex += 1
            exchangesOnLeg = 0
            legStartedAt = input.elapsed
            if legIndex >= legPositions.count {
                completedAt = input.elapsed
                outcome.changes.append(.completed)
            }
        }
        return outcome
    }
}
