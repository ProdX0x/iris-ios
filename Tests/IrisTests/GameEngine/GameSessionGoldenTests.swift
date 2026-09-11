// GameSessionGoldenTests.swift
// Layer: Tests
// Purpose: The Swift engine reproduces the reference JavaScript engine frame by frame (golden traces)

import Testing
import Foundation
@testable import Iris

@Suite("GameSession golden traces")
struct GameSessionGoldenTests {
    private let tolerance = 1e-6

    private func compare(_ session: GameSession, with samples: [GoldenTrace.Sample], frame: Int) {
        #expect(session.targets.count == samples.count)
        for (target, sample) in zip(session.targets, samples) {
            #expect(abs(target.position.x - sample.x) < tolerance, "x frame \(frame) seq \(target.sequence)")
            #expect(abs(target.position.y - sample.y) < tolerance, "y frame \(frame) seq \(target.sequence)")
            #expect(abs(target.velocity.x - sample.vx) < tolerance, "vx frame \(frame) seq \(target.sequence)")
            #expect(abs(target.velocity.y - sample.vy) < tolerance, "vy frame \(frame) seq \(target.sequence)")
            #expect(Int((target.holdTime * 60).rounded()) == sample.hold, "hold frame \(frame) seq \(target.sequence)")
            #expect(target.isValidated == sample.settled, "settled frame \(frame) seq \(target.sequence)")
        }
    }

    @Test("level 1 scripted gaze: repulsion, bounces, then attraction and validation match the reference")
    func level1Scripted() throws {
        let golden = try GoldenTrace.load(named: "golden_level1_scripted")
        var session = GameSession(level: LevelCatalog.all[golden.levelIndex],
                                  bounds: PlayfieldBounds(width: golden.canvas.width, height: golden.canvas.height))
        var validatedFrame: Int?
        var completedFrame: Int?

        for frame in 1...golden.frames {
            session.placeGaze(at: frame <= 150 ? Vector2(x: 230, y: 560) : Vector2(x: 60, y: 60))
            let events = session.advance(by: 1.0 / 60.0)
            compare(session, with: golden.trace[frame - 1], frame: frame)
            if events.contains(.targetValidated(sequence: 1)) { validatedFrame = frame }
            if events.contains(.levelCompleted) { completedFrame = frame }
        }

        let goldenValidated = golden.events.first { $0.type == "validated" }?.frame
        let goldenCompleted = golden.events.first { $0.type == "levelCompleted" }?.frame
        #expect(validatedFrame == goldenValidated)
        #expect(completedFrame == goldenCompleted)
        #expect(session.isComplete)
    }

    @Test("level 9 with a parked gaze: three spheres validate in order 1, 2, 3 exactly like the reference")
    func level9Ordered() throws {
        let golden = try GoldenTrace.load(named: "golden_level9_far")
        var session = GameSession(level: LevelCatalog.all[golden.levelIndex],
                                  bounds: PlayfieldBounds(width: golden.canvas.width, height: golden.canvas.height))
        var validations: [(frame: Int, sequence: Int)] = []

        for frame in 1...golden.frames {
            session.placeGaze(at: Vector2(x: 330, y: 784))
            for event in session.advance(by: 1.0 / 60.0) {
                if case let .targetValidated(sequence) = event { validations.append((frame, sequence)) }
            }
            compare(session, with: golden.trace[frame - 1], frame: frame)
        }

        let goldenValidations = golden.events.filter { $0.type == "validated" }.map { ($0.frame, $0.seq ?? -1) }
        #expect(validations.map(\.sequence) == goldenValidations.map(\.1))
        #expect(validations.map(\.frame) == goldenValidations.map(\.0))
        #expect(session.isComplete)
    }
}
