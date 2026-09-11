// ValidationRuleTests.swift
// Layer: Tests
// Purpose: R-08 continuous 0.75 s presence and R-10 wobble tolerance, at rule and session level

import Testing
@testable import Iris

@Suite("ValidationRule")
struct ValidationRuleTests {
    private let frame = SessionFixture.frame

    @Test("R-08 entering the arrival zone starts accumulating presence")
    func enteringStartsHold() {
        var session = SessionFixture.restingSession()

        let events = SessionFixture.run(&session, frames: 1)

        #expect(session.targets[0].holdTime > 0)
        #expect(session.targets[0].isValidated == false)
        #expect(events.contains(.validationProgressed(sequence: 1, progress: session.targets[0].validationProgress)))
    }

    @Test("R-08 the target is not validated after 44 frames (0.733 s)")
    func notValidatedBeforeHoldDuration() {
        var session = SessionFixture.restingSession()

        let events = SessionFixture.run(&session, frames: 44)

        #expect(session.targets[0].isValidated == false)
        #expect(!events.contains(.targetValidated(sequence: 1)))
        #expect(session.targets[0].validationProgress < 1)
    }

    @Test("R-08 the target is validated on the 45th consecutive frame (0.75 s)")
    func validatedAfterHoldDuration() {
        var session = SessionFixture.restingSession()

        SessionFixture.run(&session, frames: 44)
        let events = session.advance(by: frame)

        #expect(session.targets[0].isValidated)
        #expect(events.contains(.targetValidated(sequence: 1)))
        #expect(events.contains(.levelCompleted))
    }

    @Test("R-08 validation also happens at 120 Hz and 30 Hz after 0.75 s of wall time")
    func validationIsTimeBased() {
        for rate in [30.0, 120.0] {
            var session = SessionFixture.restingSession()
            let dt = 1 / rate
            var validatedAt: Double?
            for step in 1...Int(rate) {
                if session.advance(by: dt).contains(.targetValidated(sequence: 1)) {
                    validatedAt = Double(step) * dt
                    break
                }
            }
            #expect(validatedAt != nil)
            if let validatedAt {
                #expect(abs(validatedAt - 0.75) < dt + 1e-9, "rate \(rate)")
            }
        }
    }

    @Test("R-08 leaving the zone before validation resets the progress to zero")
    func leavingResetsProgress() {
        var session = SessionFixture.restingSession()
        SessionFixture.run(&session, frames: 30)
        #expect(session.targets[0].holdTime > 0)

        let outside = session.targets[0].moved(to: session.targets[0].arrival + Vector2(x: 17, y: 0))
        session.replaceTargets([outside])
        let events = session.advance(by: frame)

        #expect(session.targets[0].holdTime == 0)
        #expect(events.contains(.validationProgressStopped(sequence: 1)))
    }

    @Test("R-08 presence counts only strictly inside the 16 pt settle radius")
    func settleRadius() {
        let rule = ValidationRule()
        var inside = Target(id: TargetID(sequence: 1), position: Vector2(x: 15.9, y: 0), arrival: .zero, attentionZone: 1,
                            repulsionGain: 0, passiveAttraction: 0, noiseAmplitude: 0, requiredHoldTime: 0.75)
        var edge = inside.moved(to: Vector2(x: 16, y: 0))

        _ = rule.apply(to: &inside, isTurn: true, elapsed: frame)
        _ = rule.apply(to: &edge, isTurn: true, elapsed: frame)

        #expect(inside.holdTime > 0)
        #expect(edge.holdTime == 0)
    }

    @Test("R-10 a validated target keeps its validation while wobbling within 36 pt")
    func validatedTargetTolerance() {
        var session = SessionFixture.restingSession()
        SessionFixture.run(&session, frames: 45)
        #expect(session.targets[0].isValidated)

        let wobbling = session.targets[0].moved(to: session.targets[0].arrival + Vector2(x: 35, y: 0))
        session.replaceTargets([wobbling])
        let events = session.advance(by: frame)

        #expect(session.targets[0].isValidated)
        #expect(!events.contains(.targetLost(sequence: 1, cause: .drift)))
    }

    @Test("R-10 beyond the 36 pt tolerance the validation is lost immediately")
    func validatedTargetLoss() {
        var session = SessionFixture.restingSession()
        SessionFixture.run(&session, frames: 45)

        let drifted = session.targets[0].moved(to: session.targets[0].arrival + Vector2(x: 37, y: 0))
        session.replaceTargets([drifted])
        let events = session.advance(by: frame)

        #expect(session.targets[0].isValidated == false)
        #expect(session.targets[0].holdTime == 0)
        #expect(events.contains(.targetLost(sequence: 1, cause: .drift)))
    }

    @Test("progress reported by events climbs from 1/45 to 1")
    func progressEvents() {
        var session = SessionFixture.restingSession()
        var lastProgress = 0.0
        for _ in 0..<45 {
            for event in session.advance(by: frame) {
                if case let .validationProgressed(_, progress) = event {
                    #expect(progress > lastProgress)
                    lastProgress = progress
                }
            }
        }
        #expect(lastProgress > 0.97)
    }
}
