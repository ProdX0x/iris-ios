// MiroirStageState.swift
// Layer: GameEngine
// Purpose: Chapter IV final: cycles of a lure flashing on one side and a door open on the opposite side; a gaze that
// enters the lure zone during the cycle, or a door that closes unanswered, repeats the cycle after a breath; a dwell
// in the open door succeeds

import Foundation

struct MiroirStageState: Hashable, Sendable {
    let positions: [MiroirDefinition.Side: Vector2]
    let cycles: [MiroirDefinition.Side]
    let radius: Double
    let releaseRadius: Double
    let flashDuration: TimeInterval
    let windowOpensAt: TimeInterval
    let windowDuration: TimeInterval
    let teachingCycles: Int
    let teachingWindowDuration: TimeInterval
    let dwell: TimeInterval
    let pause: TimeInterval

    enum Phase: Hashable, Sendable {
        /// Breath before the cycle `next` starts at `until`.
        case breath(until: TimeInterval)
        case cycle(start: TimeInterval)
        case done
    }

    private(set) var phase: Phase = .breath(until: 1.0)
    private(set) var cycleIndex = 0
    private(set) var successes = 0
    private(set) var lured = 0
    private(set) var timeouts = 0
    private(set) var dwellTime: TimeInterval = 0
    private(set) var isInDoor = false
    /// Whether the gaze sat inside the lure zone when the cycle started (then it cannot be lured by it).
    private var startedInLure = false
    private var lastDoor: MiroirDefinition.Side?

    init(definition: MiroirDefinition, bounds: PlayfieldBounds, shortSide: Double) {
        positions = [.right: definition.right.absolute(in: bounds), .left: definition.left.absolute(in: bounds),
                     .top: definition.top.absolute(in: bounds), .bottom: definition.bottom.absolute(in: bounds)]
        cycles = definition.cycles
        radius = definition.radius * shortSide
        releaseRadius = definition.releaseRadius * shortSide
        flashDuration = definition.flashDuration
        windowOpensAt = definition.windowOpensAt
        windowDuration = definition.windowDuration
        teachingCycles = definition.teachingCycles
        teachingWindowDuration = definition.teachingWindowDuration
        dwell = definition.dwell
        pause = definition.pause
        if cycles.isEmpty { phase = .done }
    }

    var isComplete: Bool { phase == .done }
    var progress: Double { cycles.isEmpty ? 1 : Double(successes) / Double(cycles.count) }
    var lureSide: MiroirDefinition.Side? { cycles.indices.contains(cycleIndex) ? cycles[cycleIndex] : nil }
    var doorSide: MiroirDefinition.Side? { lureSide?.opposite }
    var currentWindowDuration: TimeInterval { successes < teachingCycles ? teachingWindowDuration : windowDuration }

    /// The lure's age (nil when not flashing) and whether the door is open, at `time`.
    func flashAge(at time: TimeInterval) -> TimeInterval? {
        guard case let .cycle(start) = phase, time - start <= flashDuration else { return nil }
        return time - start
    }

    func isDoorOpen(at time: TimeInterval) -> Bool {
        guard case let .cycle(start) = phase else { return false }
        let age = time - start
        return age >= windowOpensAt && age <= windowOpensAt + currentWindowDuration
    }

    mutating func update(_ input: OculoInput) -> OculoOutcome {
        var outcome = OculoOutcome()
        switch phase {
        case .done:
            return outcome
        case let .breath(until):
            if input.elapsed >= until, let lure = lureSide, let lurePosition = positions[lure] {
                phase = .cycle(start: input.elapsed)
                startedInLure = input.gazeActive && input.gaze.distance(to: lurePosition) <= releaseRadius
                dwellTime = 0
                isInDoor = false
            }
            return outcome
        case let .cycle(start):
            guard let lure = lureSide, let lurePosition = positions[lure], let doorPosition = positions[lure.opposite] else {
                phase = .done
                return outcome
            }
            let age = input.elapsed - start
            if input.gazeActive {
                let lureDistance = input.gaze.distance(to: lurePosition)
                if startedInLure {
                    if lureDistance > releaseRadius { startedInLure = false }
                } else if lureDistance <= radius, age > 0.05 {
                    lured += 1
                    outcome.changes.append(.miss)
                    phase = .breath(until: input.elapsed + pause)
                    return outcome
                }
                let doorDistance = input.gaze.distance(to: doorPosition)
                if isInDoor {
                    if doorDistance > releaseRadius {
                        isInDoor = false
                        dwellTime = 0
                    }
                } else if doorDistance <= radius {
                    isInDoor = true
                    dwellTime = 0
                }
                if isInDoor && isDoorOpen(at: input.elapsed) {
                    dwellTime += input.seconds
                    if dwellTime >= dwell - 1e-9 {
                        successes += 1
                        cycleIndex += 1
                        lastDoor = lure.opposite
                        outcome.changes.append(.success)
                        if cycleIndex >= cycles.count {
                            phase = .done
                            outcome.changes.append(.completed)
                        } else {
                            phase = .breath(until: input.elapsed + pause)
                        }
                        return outcome
                    }
                }
            }
            if age > windowOpensAt + currentWindowDuration {
                timeouts += 1
                outcome.changes.append(.miss)
                phase = .breath(until: input.elapsed + pause)
            }
            return outcome
        }
    }

    /// The ideal player rests on the door of the current cycle (or the last door while breathing), never on a lure.
    func suggestedGaze(at time: TimeInterval) -> Vector2? {
        if case .cycle = phase, let door = doorSide { return positions[door] }
        if let lastDoor { return positions[lastDoor] }
        return nil
    }
}
