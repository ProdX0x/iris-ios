// TournerStageState.swift
// Layer: GameEngine
// Purpose: Chapter XI final: braises light up at the edge of the field one after another; the gaze reaches each one,
// and the head may then follow. Eyes first and the head after gives all the warmth, the head before the eyes half,
// the eyes alone a third: every coordination progresses, the natural eye-then-head shift progresses fastest.

import Foundation

struct TournerStageState: Hashable, Sendable {
    let places: [Vector2]
    let order: [Int]
    let center: Vector2
    let radius: Double
    let releaseRadius: Double
    let dwell: TimeInterval
    let headStill: Double
    let headTurn: Double
    let followWindow: TimeInterval
    let announceTimeout: TimeInterval
    let pause: TimeInterval
    let goal: Double
    let fullYield: Double
    let headFirstYield: Double
    let eyesOnlyYield: Double

    enum Phase: Hashable, Sendable {
        case rest(until: TimeInterval)
        case announce(start: TimeInterval)
        case follow(start: TimeInterval)
        case done
    }

    private(set) var phase: Phase = .rest(until: 0.8)
    private(set) var announcement = 0
    private(set) var energy = 0.0
    private(set) var isOn = false
    private(set) var dwellTime: TimeInterval = 0
    /// Head pose when the braise lit up; head motion is measured from it.
    private(set) var pose0: HeadPose = .neutral
    private(set) var lastHead: HeadPose?
    /// Head motion (|Δyaw| + |Δpitch|, degrees) at the moment the gaze reached the braise.
    private(set) var entryMotion: Double?
    /// The warmth each braise gave, in order (trace and tests).
    private(set) var yields: [Double] = []
    private(set) var timeouts = 0
    private(set) var completedAt: TimeInterval?

    init(definition: TournerDefinition, bounds: PlayfieldBounds, shortSide: Double) {
        places = definition.places.map { $0.absolute(in: bounds) }
        order = definition.order
        center = bounds.center
        radius = definition.radius * shortSide
        releaseRadius = definition.releaseRadius * shortSide
        dwell = definition.dwell
        headStill = definition.headStill
        headTurn = definition.headTurn
        followWindow = definition.followWindow
        announceTimeout = definition.announceTimeout
        pause = definition.pause
        goal = definition.goal
        fullYield = definition.fullYield
        headFirstYield = definition.headFirstYield
        eyesOnlyYield = definition.eyesOnlyYield
        if order.isEmpty { phase = .done }
    }

    var isComplete: Bool { phase == .done }
    var progress: Double { goal <= 0 ? 1 : min(1, energy / goal) }
    var place: Vector2? { order.isEmpty ? nil : places[order[announcement % order.count]] }

    static func motion(_ head: HeadPose?, from pose: HeadPose) -> Double {
        guard let head else { return 0 }
        return abs(head.yaw - pose.yaw) + abs(head.pitch - pose.pitch)
    }

    private mutating func track(_ gaze: Vector2, to place: Vector2) {
        let distance = gaze.distance(to: place)
        if isOn {
            if distance > releaseRadius { isOn = false }
        } else if distance <= radius {
            isOn = true
        }
    }

    mutating func update(_ input: OculoInput) -> OculoOutcome {
        var outcome = OculoOutcome()
        if let head = input.head { lastHead = head }
        let now = input.elapsed
        switch phase {
        case .done:
            return outcome
        case let .rest(until):
            if now >= until {
                phase = .announce(start: now)
                pose0 = lastHead ?? .neutral
                isOn = false
                dwellTime = 0
                entryMotion = nil
            }
            return outcome
        case let .announce(start):
            guard let place else {
                phase = .done
                return outcome
            }
            if input.gazeActive {
                let wasOn = isOn
                track(input.gaze, to: place)
                if isOn && !wasOn { entryMotion = Self.motion(input.head, from: pose0) }
                if isOn {
                    dwellTime += input.seconds
                } else {
                    dwellTime = 0
                    entryMotion = nil
                }
                if isOn && dwellTime >= dwell - 1e-9 {
                    if (entryMotion ?? 0) >= headStill {
                        resolve(headFirstYield, at: now, into: &outcome)
                    } else {
                        phase = .follow(start: now)
                    }
                    return outcome
                }
            }
            if now - start > announceTimeout {
                timeouts += 1
                announcement += 1
                outcome.changes.append(.miss)
                phase = .rest(until: now + pause)
            }
            return outcome
        case let .follow(start):
            guard let place else {
                phase = .done
                return outcome
            }
            if input.gazeActive {
                track(input.gaze, to: place)
            } else {
                isOn = false
            }
            if !isOn {
                resolve(eyesOnlyYield, at: now, into: &outcome)
            } else if Self.motion(input.head, from: pose0) >= headTurn {
                resolve(fullYield, at: now, into: &outcome)
            } else if now - start > followWindow {
                resolve(eyesOnlyYield, at: now, into: &outcome)
            }
            return outcome
        }
    }

    private mutating func resolve(_ yield: Double, at now: TimeInterval, into outcome: inout OculoOutcome) {
        energy += yield
        yields.append(yield)
        announcement += 1
        outcome.changes.append(.success)
        if energy >= goal - 1e-9 {
            phase = .done
            completedAt = now
            outcome.changes.append(.completed)
        } else {
            phase = .rest(until: now + pause)
        }
    }

    /// The ideal player looks at the braise, then lets the head follow.
    func suggestedGaze(at time: TimeInterval) -> Vector2? {
        switch phase {
        case .announce, .follow: place
        case .rest, .done: nil
        }
    }

    var suggestedHead: HeadPose? {
        switch phase {
        case .announce: pose0
        case .follow: HeadPose(yaw: pose0.yaw + headTurn + 2, pitch: pose0.pitch)
        case .rest: lastHead ?? .neutral
        case .done: nil
        }
    }
}
