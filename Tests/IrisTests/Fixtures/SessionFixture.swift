// SessionFixture.swift
// Layer: Tests
// Purpose: Helpers to stage deterministic sessions (no noise, explicit positions)

import Foundation
@testable import Iris

enum SessionFixture {
    static let bounds = PlayfieldBounds.referencePhone
    static let frame: TimeInterval = 1.0 / 60.0
    /// A gaze point far from every staged target (bottom-right corner, inside the playfield).
    static let farGaze = Vector2(x: 330, y: 784)

    struct Placement {
        var start: Vector2
        var arrival: Vector2
    }

    static func level(placements: [Placement],
                      number: Int = 1,
                      sequential: Bool? = nil,
                      attentionZone: Double = 240,
                      repulsionGain: Double = 0.013,
                      passiveAttraction: Double = 0.5,
                      noiseAmplitude: Double = 0) -> Level {
        let targets = placements.enumerated().map { index, placement in
            TargetBlueprint(sequence: index + 1,
                            start: NormalizedPoint(x: placement.start.x / bounds.width, y: placement.start.y / bounds.height),
                            arrival: NormalizedPoint(x: placement.arrival.x / bounds.width, y: placement.arrival.y / bounds.height),
                            attentionZone: attentionZone,
                            repulsionGain: repulsionGain,
                            passiveAttraction: passiveAttraction,
                            noiseAmplitude: noiseAmplitude)
        }
        return Level(id: LevelID(raw: "fixture_\(number)"), number: number, targets: targets,
                     holdDuration: LevelCatalog.holdDuration, isSequential: sequential ?? (placements.count > 1))
    }

    /// Session without noise, gaze parked far away.
    static func session(level: Level, gaze: Vector2 = farGaze) -> GameSession {
        var session = GameSession(level: level, bounds: bounds,
                                  noiseSources: level.targets.map { _ in SilentNoise() })
        session.placeGaze(at: gaze)
        return session
    }

    /// Single target already resting on its arrival point.
    static func restingSession(at point: Vector2 = Vector2(x: 200, y: 500)) -> GameSession {
        session(level: level(placements: [Placement(start: point, arrival: point)]))
    }

    /// Three targets, each resting on its own arrival point, sequential rules.
    static func tripleRestingSession() -> GameSession {
        let points = [Vector2(x: 120, y: 300), Vector2(x: 200, y: 500), Vector2(x: 280, y: 400)]
        return session(level: level(placements: points.map { Placement(start: $0, arrival: $0) }, sequential: true))
    }

    @discardableResult
    static func run(_ session: inout GameSession, frames: Int, dt: TimeInterval = frame) -> [GameEvent] {
        var events: [GameEvent] = []
        for _ in 0..<frames { events += session.advance(by: dt) }
        return events
    }

    /// Runs frames until the first target is validated (or the frame budget runs out).
    @discardableResult
    static func runUntilValidated(_ session: inout GameSession, sequence: Int, maxFrames: Int = 600) -> Int {
        for frame in 1...maxFrames {
            let events = session.advance(by: frame == 0 ? 0 : SessionFixture.frame)
            if events.contains(.targetValidated(sequence: sequence)) { return frame }
        }
        return -1
    }
}

extension Target {
    /// Copy of the target moved to `position`, keeping every other property.
    func moved(to newPosition: Vector2) -> Target {
        var copy = self
        copy.position = newPosition
        return copy
    }

    func validatedCopy() -> Target {
        var copy = self
        copy.isValidated = true
        copy.holdTime = requiredHoldTime
        return copy
    }
}
