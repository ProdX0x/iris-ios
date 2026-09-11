// CascadeRuleTests.swift
// Layer: Tests
// Purpose: R-11 losing a validation invalidates every higher rank, never a lower one

import Testing
@testable import Iris

@Suite("CascadeRule")
struct CascadeRuleTests {
    private let frame = SessionFixture.frame

    private func fullyValidatedSession() -> GameSession {
        var session = SessionFixture.tripleRestingSession()
        session.replaceTargets(session.targets.map { $0.validatedCopy() })
        return session
    }

    @Test("R-11 rule level: losing 3 leaves 1 and 2 validated")
    func ruleLosingThird() {
        let session = fullyValidatedSession()
        var targets = session.targets
        targets[2].isValidated = false

        let invalidated = CascadeRule.apply(to: &targets)

        #expect(invalidated.isEmpty)
        #expect(targets.map(\.isValidated) == [true, true, false])
    }

    @Test("R-11 rule level: losing 2 invalidates 2 and 3, keeps 1")
    func ruleLosingSecond() {
        let session = fullyValidatedSession()
        var targets = session.targets
        targets[1].isValidated = false

        let invalidated = CascadeRule.apply(to: &targets)

        #expect(invalidated == [3])
        #expect(targets.map(\.isValidated) == [true, false, false])
        #expect(targets[2].holdTime == 0)
    }

    @Test("R-11 rule level: losing 1 invalidates 1, 2 and 3")
    func ruleLosingFirst() {
        let session = fullyValidatedSession()
        var targets = session.targets
        targets[0].isValidated = false

        let invalidated = CascadeRule.apply(to: &targets)

        #expect(invalidated == [2, 3])
        #expect(targets.map(\.isValidated) == [false, false, false])
    }

    @Test("R-11 session level: target 3 drifting out does not affect 1 and 2")
    func sessionLosingThird() {
        var session = fullyValidatedSession()
        let drifted = session.targets[2].moved(to: session.targets[2].arrival + Vector2(x: 40, y: 0))
        session.replaceTargets([session.targets[0], session.targets[1], drifted])

        let events = session.advance(by: frame)

        #expect(session.targets.map(\.isValidated) == [true, true, false])
        #expect(events.contains(.targetLost(sequence: 3, cause: .drift)))
        #expect(!events.contains(.targetLost(sequence: 2, cause: .cascade)))
    }

    @Test("R-11 session level: target 2 drifting out invalidates 2 and 3, keeps 1")
    func sessionLosingSecond() {
        var session = fullyValidatedSession()
        let drifted = session.targets[1].moved(to: session.targets[1].arrival + Vector2(x: 0, y: 40))
        session.replaceTargets([session.targets[0], drifted, session.targets[2]])

        let events = session.advance(by: frame)

        #expect(session.targets.map(\.isValidated) == [true, false, false])
        #expect(events.contains(.targetLost(sequence: 2, cause: .drift)))
        #expect(events.contains(.targetLost(sequence: 3, cause: .cascade)))
        #expect(!session.isComplete)
    }

    @Test("R-11 session level: target 1 drifting out invalidates everything")
    func sessionLosingFirst() {
        var session = fullyValidatedSession()
        let drifted = session.targets[0].moved(to: session.targets[0].arrival + Vector2(x: -40, y: 0))
        session.replaceTargets([drifted, session.targets[1], session.targets[2]])

        let events = session.advance(by: frame)

        #expect(session.targets.map(\.isValidated) == [false, false, false])
        #expect(events.contains(.targetLost(sequence: 1, cause: .drift)))
        #expect(events.contains(.targetLost(sequence: 2, cause: .cascade)))
        #expect(events.contains(.targetLost(sequence: 3, cause: .cascade)))
    }

    @Test("R-11 after a cascade, higher targets must wait again for their turn")
    func cascadeRestoresOrder() {
        var session = fullyValidatedSession()
        let drifted = session.targets[0].moved(to: Vector2(x: 300, y: 700))
        session.replaceTargets([drifted, session.targets[1], session.targets[2]])

        SessionFixture.run(&session, frames: 60)

        #expect(session.targets[1].isValidated == false)
        #expect(session.targets[1].holdTime == 0, "target 2 rests on its arrival but is not its turn")
        #expect(session.targets[2].isValidated == false)
    }

    @Test("R-11 on a non sequential level nothing cascades")
    func noCascadeWhenNotSequential() {
        var session = SessionFixture.restingSession()
        SessionFixture.run(&session, frames: 45)
        #expect(session.targets[0].isValidated)
        #expect(session.level.isSequential == false)
    }
}
