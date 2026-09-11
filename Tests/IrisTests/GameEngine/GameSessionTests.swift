// GameSessionTests.swift
// Layer: Tests
// Purpose: R-12 and R-14 session behaviour: completion, delta clamping, sub-stepping, gaze handling

import Testing
@testable import Iris

@Suite("GameSession")
struct GameSessionTests {
    private let frame = SessionFixture.frame

    @Test("loading a level places every target at its start with zero velocity")
    func loadsLevel() {
        let session = GameSession(level: PrototypeLevelCatalog.all[8], bounds: .referencePhone)

        #expect(session.targets.count == 3)
        #expect(session.targets.map(\.sequence) == [1, 2, 3])
        #expect(session.targets.allSatisfy { $0.velocity == .zero })
        #expect(session.targets.allSatisfy { !$0.isValidated && $0.holdTime == 0 })
        #expect(abs(session.targets[0].position.x - 0.7351671810699587 * 390) < 1e-9)
        #expect(session.gaze.position == PlayfieldBounds.referencePhone.center)
    }

    @Test("R-12 the level completes when every target is validated and then stops advancing")
    func completion() {
        var session = SessionFixture.restingSession()

        let events = SessionFixture.run(&session, frames: 45)
        let after = session.advance(by: frame)

        #expect(events.last == .levelCompleted)
        #expect(session.isComplete)
        #expect(after.isEmpty)
    }

    @Test("R-14 a long stall is clamped to 0.1 s and split into 60 Hz sub-steps")
    func stallClamp() {
        var stalled = SessionFixture.restingSession()
        var smooth = SessionFixture.restingSession()

        _ = stalled.advance(by: 2.0)
        SessionFixture.run(&smooth, frames: 6)

        #expect(abs(stalled.elapsed - 0.1) < 1e-12)
        #expect(abs(stalled.frameTime - 6) < 1e-9)
        #expect(abs(stalled.targets[0].holdTime - smooth.targets[0].holdTime) < 1e-9)
    }

    @Test("R-14 a 30 Hz frame equals two 60 Hz frames exactly")
    func thirtyHertzEqualsTwoFrames() {
        var slow = SessionFixture.session(level: PrototypeLevelCatalog.all[0])
        var fast = SessionFixture.session(level: PrototypeLevelCatalog.all[0])

        for _ in 0..<120 {
            _ = slow.advance(by: 1.0 / 30.0)
            _ = fast.advance(by: frame)
            _ = fast.advance(by: frame)
        }

        #expect(slow.targets[0].position.distance(to: fast.targets[0].position) < 1e-6)
        #expect(abs(slow.frameTime - fast.frameTime) < 1e-9)
    }

    /// Straight attraction run with the gaze far away, no noise: a pure cruise toward the arrival.
    private func cruiseLevel() -> Level {
        SessionFixture.level(placements: [SessionFixture.Placement(start: Vector2(x: 100, y: 300), arrival: Vector2(x: 300, y: 700))])
    }

    @Test("R-14 a 120 Hz cruise stays on the 60 Hz trajectory")
    func hundredTwentyHertzIsClose() {
        var half = SessionFixture.session(level: cruiseLevel(), gaze: Vector2(x: 330, y: 60))
        var whole = SessionFixture.session(level: cruiseLevel(), gaze: Vector2(x: 330, y: 60))

        for _ in 0..<120 {
            _ = half.advance(by: 1.0 / 120.0)
            _ = half.advance(by: 1.0 / 120.0)
            _ = whole.advance(by: frame)
        }

        #expect(half.targets[0].position.distance(to: whole.targets[0].position) < 1)
    }

    @Test("R-14 cruise speed after friction is identical at 60 Hz and 120 Hz")
    func cruiseSpeedEquivalence() {
        var half = SessionFixture.session(level: cruiseLevel(), gaze: Vector2(x: 330, y: 60))
        var whole = SessionFixture.session(level: cruiseLevel(), gaze: Vector2(x: 330, y: 60))

        for _ in 0..<60 {
            _ = half.advance(by: 1.0 / 120.0)
            _ = half.advance(by: 1.0 / 120.0)
            _ = whole.advance(by: frame)
        }

        #expect(abs(half.targets[0].speed - whole.targets[0].speed) < 1e-6)
        #expect(abs(whole.targets[0].speed - 2.2 * 0.94) < 1e-9, "reference cruise: capped then friction")
    }

    @Test("R-14 on a real level with repulsion, 120 Hz stays within a few points of 60 Hz over three seconds")
    func hundredTwentyHertzWithRepulsion() {
        var half = SessionFixture.session(level: PrototypeLevelCatalog.all[0])
        var whole = SessionFixture.session(level: PrototypeLevelCatalog.all[0])

        for _ in 0..<180 {
            _ = half.advance(by: 1.0 / 120.0)
            _ = half.advance(by: 1.0 / 120.0)
            _ = whole.advance(by: frame)
        }

        // The attention-zone boundary is a discontinuity: sub-frame stepping can flip the branch one
        // sub-step earlier, which is why a small residual difference is expected here.
        #expect(half.targets[0].position.distance(to: whole.targets[0].position) < 12)
    }

    @Test("zero or negative deltas do nothing")
    func nonPositiveDelta() {
        var session = SessionFixture.restingSession()

        #expect(session.advance(by: 0).isEmpty)
        #expect(session.advance(by: -1).isEmpty)
        #expect(session.elapsed == 0)
    }

    @Test("R-13 ingested gaze is smoothed toward the raw sample")
    func gazeSmoothing() {
        var session = SessionFixture.session(level: PrototypeLevelCatalog.all[0], gaze: Vector2(x: 100, y: 100))

        session.ingestGaze(Vector2(x: 200, y: 100))

        #expect(abs(session.gaze.position.x - 110) < 1e-9)
    }
}
