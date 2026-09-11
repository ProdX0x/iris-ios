// SequenceOrderTests.swift
// Layer: Tests
// Purpose: R-09 targets validate only in order 1, 2, 3; physical arrival out of turn is allowed but never counts

import Testing
@testable import Iris

@Suite("SequenceOrder")
struct SequenceOrderTests {
    private let frame = SessionFixture.frame

    @Test("R-09 target 1 is validatable immediately")
    func firstTargetValidatesImmediately() {
        var session = SessionFixture.tripleRestingSession()

        let events = SessionFixture.run(&session, frames: 45)

        #expect(events.contains(.targetValidated(sequence: 1)))
        #expect(session.targets[0].isValidated)
    }

    @Test("R-09 target 2 cannot be validated before target 1")
    func secondWaitsForFirst() {
        var session = SessionFixture.tripleRestingSession()
        let farFromArrival = session.targets[0].moved(to: Vector2(x: 300, y: 700))
        session.replaceTargets([farFromArrival, session.targets[1], session.targets[2]])

        let events = SessionFixture.run(&session, frames: 90)

        #expect(!events.contains(.targetValidated(sequence: 2)))
        #expect(session.targets[1].isValidated == false)
        #expect(session.targets[1].holdTime == 0, "presence out of turn never accumulates")
    }

    @Test("R-09 target 3 cannot be validated before 1 and 2")
    func thirdWaitsForFirstTwo() {
        var session = SessionFixture.tripleRestingSession()
        session.replaceTargets([session.targets[0].validatedCopy(),
                                session.targets[1].moved(to: Vector2(x: 300, y: 700)),
                                session.targets[2]])

        let events = SessionFixture.run(&session, frames: 90)

        #expect(!events.contains(.targetValidated(sequence: 3)))
        #expect(session.targets[2].isValidated == false)
        #expect(session.targets[0].isValidated, "target 1 keeps its validation")
    }

    @Test("R-09 physical arrival out of turn is allowed: the sphere stays in its ring without validating")
    func physicalArrivalOutOfTurn() {
        var session = SessionFixture.tripleRestingSession()
        session.replaceTargets([session.targets[0].moved(to: Vector2(x: 300, y: 700)), session.targets[1], session.targets[2]])

        SessionFixture.run(&session, frames: 120)

        #expect(session.targets[1].distanceToArrival < 16, "target 2 physically rests on its arrival")
        #expect(session.targets[1].isValidated == false)
    }

    @Test("R-09 once target 1 is validated, target 2 starts its own 0.75 s and then target 3")
    func orderedValidation() {
        var session = SessionFixture.tripleRestingSession()
        var order: [Int] = []

        for _ in 0..<200 {
            for event in session.advance(by: frame) {
                if case let .targetValidated(sequence) = event { order.append(sequence) }
            }
            if session.isComplete { break }
        }

        #expect(order == [1, 2, 3])
        #expect(session.isComplete)
    }

    @Test("R-09 lowest unvalidated sequence and turn evaluation")
    func turnRule() {
        let session = SessionFixture.tripleRestingSession()
        let targets = [session.targets[0].validatedCopy(), session.targets[1], session.targets[2]]

        let lowest = TurnRule.lowestUnvalidatedSequence(in: targets)

        #expect(lowest == 2)
        #expect(TurnRule.isTurn(of: targets[0], lowestUnvalidated: lowest, isSequential: true), "validated keeps its place")
        #expect(TurnRule.isTurn(of: targets[1], lowestUnvalidated: lowest, isSequential: true))
        #expect(!TurnRule.isTurn(of: targets[2], lowestUnvalidated: lowest, isSequential: true))
        #expect(TurnRule.isTurn(of: targets[2], lowestUnvalidated: lowest, isSequential: false), "non sequential levels ignore order")
        #expect(TurnRule.lowestUnvalidatedSequence(in: targets.map { $0.validatedCopy() }) == nil)
    }
}
