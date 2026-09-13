// BaliseSequenceState.swift
// Layer: GameEngine
// Purpose: PROTOTYPE (chapter I level 6) resolved thread of balises: only the balise the thread designates can wake,
// under a continuous gaze (dwell) inside its zone, with hysteresis; a gaze that is inactive freezes the dwell

import Foundation

struct BaliseSequenceState: Hashable, Sendable {
    let positions: [Vector2]
    let steps: [Int]
    let radius: Double
    let releaseRadius: Double
    let dwell: TimeInterval
    private(set) var currentStep = 0
    private(set) var dwellTime: TimeInterval = 0
    /// True while the gaze is considered on the active balise (entered within `radius`, kept until `releaseRadius`).
    private(set) var isInside = false
    /// When each balise last woke (nil if never).
    private(set) var litAt: [TimeInterval?]
    /// When each completed step woke its balise.
    private(set) var stepTimes: [TimeInterval] = []
    private(set) var completedAt: TimeInterval?

    init(positions: [Vector2], steps: [Int], radius: Double, releaseRadius: Double, dwell: TimeInterval) {
        self.positions = positions
        self.steps = steps.filter { positions.indices.contains($0) }
        self.radius = max(radius, 1)
        self.releaseRadius = max(releaseRadius, self.radius)
        self.dwell = max(dwell, 0.01)
        self.litAt = Array(repeating: nil, count: positions.count)
    }

    var isComplete: Bool { completedAt != nil }
    var activeBalise: Int? { isComplete ? nil : steps[currentStep] }
    var previousBalise: Int? { currentStep > 0 ? steps[currentStep - 1] : nil }
    var progress: Double { steps.isEmpty ? 1 : Double(currentStep) / Double(steps.count) }

    enum Change: Hashable, Sendable {
        case none
        case lit(balise: Int, step: Int)
        case completed(balise: Int)
    }

    /// Advances the dwell for `seconds` from the gaze; reports a balise waking, or the thread completing.
    mutating func update(seconds: TimeInterval, gaze: Vector2, gazeActive: Bool, elapsed: TimeInterval) -> Change {
        guard let active = activeBalise else { return .none }
        guard gazeActive else { return .none }
        let distance = gaze.distance(to: positions[active])
        if isInside {
            if distance > releaseRadius {
                isInside = false
                dwellTime = 0
            }
        } else if distance <= radius {
            isInside = true
            dwellTime = 0
        }
        guard isInside else { return .none }
        dwellTime += seconds
        guard dwellTime >= dwell - 1e-9 else { return .none }
        litAt[active] = elapsed
        stepTimes.append(elapsed)
        currentStep += 1
        isInside = false
        dwellTime = 0
        if currentStep >= steps.count {
            completedAt = elapsed
            return .completed(balise: active)
        }
        return .lit(balise: active, step: currentStep - 1)
    }
}
