// AbsenceStageState.swift
// Layer: GameEngine
// Purpose: Chapter IX final: trials of a presence held by the gaze, then an answer elsewhere; in a gap trial the
// presence fades before the answer appears, in an overlap trial it stays; the gaze must leave for the answer within
// the window, otherwise the answer fades and the trial starts over after a breath

import Foundation

struct AbsenceStageState: Hashable, Sendable {
    let places: [Vector2]
    let trials: [AbsenceDefinition.Trial]
    let hold: TimeInterval
    let gap: TimeInterval
    let answerWindow: TimeInterval
    let dwell: TimeInterval
    let radius: Double
    let releaseRadius: Double
    let pause: TimeInterval

    enum Phase: Hashable, Sendable {
        case hold
        case gap(start: TimeInterval)
        case answer(start: TimeInterval)
        case breath(until: TimeInterval)
        case done
    }

    private(set) var phase: Phase = .hold
    private(set) var trialIndex = 0
    private(set) var holdTime: TimeInterval = 0
    private(set) var isOnFirst = false
    private(set) var isOnSecond = false
    private(set) var dwellTime: TimeInterval = 0
    private(set) var successes = 0
    private(set) var timeouts = 0
    /// Seconds from the answer's appearance to the gaze reaching it, for each success (trace only).
    private(set) var transferTimes: [TimeInterval] = []
    private var reachedAt: TimeInterval?

    init(definition: AbsenceDefinition, bounds: PlayfieldBounds, shortSide: Double) {
        places = definition.places.map { $0.absolute(in: bounds) }
        trials = definition.trials
        hold = definition.hold
        gap = definition.gap
        answerWindow = definition.answerWindow
        dwell = definition.dwell
        radius = definition.radius * shortSide
        releaseRadius = definition.releaseRadius * shortSide
        pause = definition.pause
        if trials.isEmpty { phase = .done }
    }

    var isComplete: Bool { phase == .done }
    var progress: Double { trials.isEmpty ? 1 : Double(successes) / Double(trials.count) }
    var trial: AbsenceDefinition.Trial? { trials.indices.contains(trialIndex) ? trials[trialIndex] : nil }
    var first: Vector2? { trial.map { places[$0.from] } }
    var second: Vector2? { trial.map { places[$0.to] } }
    var isHolding: Bool { phase == .hold }

    /// 0...1 visibility of the held presence and of the answer at `time`.
    func visibility(at time: TimeInterval) -> (first: Double, second: Double) {
        guard let trial else { return (0, 0) }
        switch phase {
        case .hold, .breath:
            return (1, 0)
        case let .gap(start):
            return (max(0, 1 - (time - start) / max(gap, 0.01)), 0)
        case let .answer(start):
            return (trial.mode == .overlap ? 1 : 0, min(1, max(0, time - start) / 0.15))
        case .done:
            return (0, 0)
        }
    }

    private static func track(_ inside: inout Bool, distance: Double, radius: Double, release: Double) {
        if inside {
            if distance > release { inside = false }
        } else if distance <= radius {
            inside = true
        }
    }

    mutating func update(_ input: OculoInput) -> OculoOutcome {
        var outcome = OculoOutcome()
        let now = input.elapsed
        switch phase {
        case .done:
            return outcome
        case let .breath(until):
            if now >= until {
                phase = .hold
                holdTime = 0
                isOnFirst = false
            }
            return outcome
        case .hold:
            guard input.gazeActive, let first, let trial else { return outcome }
            Self.track(&isOnFirst, distance: input.gaze.distance(to: first), radius: radius, release: releaseRadius)
            holdTime = isOnFirst ? holdTime + input.seconds : 0
            if holdTime >= hold - 1e-9 {
                isOnSecond = false
                dwellTime = 0
                reachedAt = nil
                phase = trial.mode == .gap ? .gap(start: now) : .answer(start: now)
            }
            return outcome
        case let .gap(start):
            if now - start >= gap { phase = .answer(start: now) }
            return outcome
        case let .answer(start):
            if input.gazeActive, let second {
                Self.track(&isOnSecond, distance: input.gaze.distance(to: second), radius: radius, release: releaseRadius)
                if isOnSecond {
                    if reachedAt == nil { reachedAt = now - start }
                    dwellTime += input.seconds
                    if dwellTime >= dwell - 1e-9 {
                        successes += 1
                        transferTimes.append(reachedAt ?? 0)
                        trialIndex += 1
                        outcome.changes.append(.success)
                        if trialIndex >= trials.count {
                            phase = .done
                            outcome.changes.append(.completed)
                        } else {
                            // The answer becomes the presence to hold; the gaze is already there.
                            phase = .hold
                            holdTime = 0
                            isOnFirst = true
                        }
                        return outcome
                    }
                } else {
                    dwellTime = 0
                }
            }
            if now - start > answerWindow {
                timeouts += 1
                outcome.changes.append(.miss)
                phase = .breath(until: now + pause)
            }
            return outcome
        }
    }

    /// The ideal player holds the presence, then goes to the answer as soon as it appears.
    func suggestedGaze(at time: TimeInterval) -> Vector2? {
        switch phase {
        case .hold, .gap, .breath: first
        case .answer: second
        case .done: nil
        }
    }
}
