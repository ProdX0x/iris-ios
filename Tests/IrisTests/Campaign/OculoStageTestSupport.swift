// OculoStageTestSupport.swift
// Layer: Tests
// Purpose: OCULOMOTOR EXPANSION: scripted gaze runs over a level's session (a policy chooses the gaze, and the head,
// every frame) to prove that the intended play wins and that trivial or wrong policies do not

import Foundation
@testable import Iris

enum OculoStageTestSupport {
    static let bounds = CampaignBot.referenceBounds
    static let frame = 1.0 / 60.0

    struct Run {
        let session: GameSession
        let events: [GameEvent]
        var completedSequence: Bool { events.contains(.oculoCompleted) }
        var successes: Int { events.filter { if case .oculoSuccess = $0 { return true } else { return false } }.count }
        var misses: Int { events.filter { if case .oculoMiss = $0 { return true } else { return false } }.count }
    }

    /// Runs `seconds` of a level, the gaze placed each frame by `policy` (frame index, session, generator) and the head by
    /// `head`; noise silenced unless `noise`. Stops when the level completes.
    static func run(_ level: LevelDefinition, seconds: Double, noise: Bool = false, seed: Int = 1,
                    head: ((Int, GameSession) -> HeadPose?)? = nil,
                    policy: (Int, GameSession, inout LinearCongruentialGenerator) -> Vector2?) -> Run {
        let resolved = LevelResolver.resolve(level, in: bounds)
        var session = resolved.makeSession(noiseSources: noise ? nil : level.lueurs.map { _ in SilentNoise() })
        var generator = LinearCongruentialGenerator(seed: 77 + seed * 131)
        var events: [GameEvent] = []
        for index in 0..<Int(seconds * 60) {
            if let point = policy(index, session, &generator) {
                session.placeGaze(at: point)
            }
            session.ingestHeadPose(head?(index, session))
            events += session.advance(by: frame)
            if session.isComplete { break }
        }
        return Run(session: session, events: events)
    }

    /// The oracle policy: the stage's suggested gaze, then a corner once the sequence is complete (the lueurs finish alone).
    static func oracle(_ index: Int, _ session: GameSession, _ generator: inout LinearCongruentialGenerator) -> Vector2? {
        if let oculo = session.oculo, !oculo.isComplete {
            return oculo.suggestedGaze(at: session.elapsed) ?? Vector2(x: 30, y: 830)
        }
        return Vector2(x: 30, y: 830)
    }

    static func randomGaze(_ index: Int, _ session: GameSession, _ generator: inout LinearCongruentialGenerator) -> Vector2? {
        guard index % 6 == 0 else { return nil }
        return Vector2(x: generator.next() * bounds.width, y: generator.next() * bounds.height)
    }

    static func corner(_ index: Int, _ session: GameSession, _ generator: inout LinearCongruentialGenerator) -> Vector2? {
        Vector2(x: 30, y: 830)
    }

    static func centre(_ index: Int, _ session: GameSession, _ generator: inout LinearCongruentialGenerator) -> Vector2? {
        bounds.center
    }
}
