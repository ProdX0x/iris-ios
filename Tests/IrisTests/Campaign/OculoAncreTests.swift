// OculoAncreTests.swift
// Layer: Tests
// Purpose: Chapter X final « l'ancre », rebuilt as two guided head loops: settling with the eyes on the point, one
// continuous circle from the right going up, back to face, then the same circle the other way. The intended play wins;
// a still head, the head without the eyes, the circle the wrong way round, poses joined through the centre, no head
// data and random gazes never do; a clear look away or lost tracking only pauses; the head is read in screen terms.

import Foundation
import Testing
@testable import Iris

@Suite("Chapter X final: ancre")
struct OculoAncreTests {
    private typealias Support = OculoStageTestSupport
    private var level: LevelDefinition { Campaign.finalGouffres }
    private static let frame = 1.0 / 60.0

    private var loops: [AncreStageState] {
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        return resolved.environment.oculo?.stages.compactMap { stage -> AncreStageState? in
            if case let .ancre(state) = stage { return state }
            return nil
        } ?? []
    }

    private static func oracleHead(_ index: Int, _ session: GameSession) -> HeadPose? {
        session.oculo?.suggestedHead ?? .neutral
    }

    /// A point of the full-size circle (degrees anticlockwise from the right), around a rest pose.
    private static func pose(_ degrees: Double, rest: HeadPose = .neutral) -> HeadPose {
        HeadPose(yaw: rest.yaw + 10 * cos(degrees * .pi / 180), pitch: rest.pitch + 8 * sin(degrees * .pi / 180))
    }

    /// After settling, out to the right and round the wrong way (down first), for ever.
    private static func wrongWay(_ index: Int, _ session: GameSession) -> HeadPose? {
        let t = Double(index) * frame
        guard t > 1.5 else { return .neutral }
        let size = min(1, (t - 1.5) / 0.5)
        let angle = -45 * max(0, t - 2) * .pi / 180
        return HeadPose(yaw: 10 * size * cos(angle), pitch: 8 * size * sin(angle))
    }

    /// After settling: right, centre, up, centre, left, centre, down, centre, each held apart, over and over.
    private static func separatePoses(_ index: Int, _ session: GameSession) -> HeadPose? {
        let t = Double(index) * frame
        guard t > 1.5 else { return .neutral }
        let slot = Int((t - 1.5) / 0.8)
        guard slot.isMultiple(of: 2) else { return .neutral }
        return pose(Double(slot / 2 % 4) * 90)
    }

    /// Settles a loop on `rest` and returns its state with the stage clock.
    private static func settled(_ state: AncreStageState, rest: HeadPose = .neutral) -> (AncreStageState, Double) {
        var state = state
        var t = 0.0
        for _ in 0..<60 {
            t += frame
            _ = state.update(OculoInput(seconds: frame, gaze: state.anchor, gazeActive: true, head: rest, elapsed: t))
        }
        return (state, t)
    }

    @Test("structure: 10-7 stays the optional final of chapter X; two loops round one point, right then left; gentle head turns; the level ends with the loops")
    func structure() throws {
        let chapter = try #require(Campaign.chapter(number: 10))
        #expect(chapter.levels.count == 7 && chapter.levels.last?.id == "10-7")
        #expect(Campaign.level(id: "10-7") == level && !level.gatesProgression && level.introduces == [.ancre])
        #expect(level.lueurs.count == 1 && !level.requiresPushing && level.gouffres.isEmpty, "no push after the loops")
        let states = loops
        #expect(states.map(\.start) == [.right, .left])
        #expect(states.map(\.turn) == [1.0, -1.0], "the second loop turns the other way")
        for state in states {
            #expect(state.anchor == states[0].anchor)
            #expect((0.4...0.6).contains(state.anchor.x / Support.bounds.width) && (0.35...0.6).contains(state.anchor.y / Support.bounds.height))
            #expect((6...14).contains(state.yawAmplitude) && (5...12).contains(state.pitchAmplitude), "small, comfortable turns")
            #expect(state.reach * state.yawAmplitude <= 7 && state.reach * state.pitchAmplitude <= 6, "the circle counts from a few degrees")
            #expect(state.holdRadius > state.radius, "the eyes are held more loosely while the head turns")
        }
        let pause = level.oculo?.pause ?? 0
        #expect(pause >= 1.2, "a breath for the stardust between the loops")
    }

    @Test("the eyes on the point and the head drawing both circles wins: ten checkpoints, two loops, no miss, the lueur released; the head never turns more than 11°")
    func twoLoops() {
        var largest = 0.0
        let run = Support.run(level, seconds: 90, head: { index, session in
            let pose = Self.oracleHead(index, session)
            largest = max(largest, abs(pose?.yaw ?? 0), abs(pose?.pitch ?? 0))
            return pose
        }, policy: Support.oracle)
        let loopsDone = run.events.filter { if case .oculoStageCompleted = $0 { return true } else { return false } }.count
        #expect(run.completedSequence && run.successes == 10 && run.misses == 0 && loopsDone == 2 && !run.session.areLueursLatent)
        #expect(largest <= 11)
        let tail = run.session.elapsed - (run.session.oculo?.completedAt ?? 0)
        #expect(run.session.isComplete && tail <= 6, "the level ends on its own \(tail) s after the two loops")
    }

    @Test("a look away in the middle of the first loop costs one miss; the ideal player then finishes both loops")
    func lookAwayThenFinish() {
        var away = 0
        let run = Support.run(level, seconds: 90, head: Self.oracleHead, policy: { index, session, generator in
            if case let .ancre(state)? = session.oculo?.current, session.oculo?.currentIndex == 0, state.phase == .circling, state.sweep >= 100, away < 60 {
                away += 1
                return Vector2(x: 30, y: 830)
            }
            return Support.oracle(index, session, &generator)
        })
        #expect(run.completedSequence && run.misses == 1 && run.successes == 10, "misses \(run.misses), successes \(run.successes)")
    }

    @Test("ablations: a still head, the head without the eyes, the circle the wrong way, poses joined through the centre, no head data and random gazes never complete")
    func ablations() {
        let still = Support.run(level, seconds: 45, head: { _, _ in .neutral }, policy: Support.oracle)
        #expect(!still.completedSequence && still.successes == 1, "anchored, then nothing without the head")
        let headOnly = Support.run(level, seconds: 45, head: Self.oracleHead, policy: Support.corner)
        #expect(!headOnly.completedSequence && headOnly.successes == 0, "no loop begins without the eyes on the point")
        let wrongWay = Support.run(level, seconds: 45, head: Self.wrongWay, policy: Support.oracle)
        #expect(!wrongWay.completedSequence && wrongWay.successes == 2, "right then down: the ring waits at its start")
        let poses = Support.run(level, seconds: 45, head: Self.separatePoses, policy: Support.oracle)
        #expect(!poses.completedSequence && poses.successes == 2, "right, up, left and down held apart are not a circle")
        let noHead = Support.run(level, seconds: 45, policy: Support.oracle)
        #expect(!noHead.completedSequence && noHead.successes == 0)
        for seed in 1...3 {
            let random = Support.run(level, seconds: 45, noise: true, seed: seed, head: Self.oracleHead, policy: Support.randomGaze)
            #expect(!random.completedSequence && random.successes == 0, "seed \(seed)")
        }
    }

    @Test("one loop: settling measures the rest pose; up first or a jump to the left do nothing; the circle fills in order; back to face closes it")
    func loopMechanics() throws {
        let rest = HeadPose(yaw: 3, pitch: -2)
        var (state, t) = Self.settled(try #require(loops.first), rest: rest)
        var changes: [OculoChange] = [.success]
        func step(_ head: HeadPose?) {
            t += Self.frame
            changes += state.update(OculoInput(seconds: Self.frame, gaze: state.anchor, gazeActive: true, head: head, elapsed: t)).changes
        }
        #expect(state.phase == .seeking && state.restPose == rest)
        for _ in 0..<30 { step(Self.pose(90, rest: rest)) }
        #expect(state.phase == .seeking, "the loop starts on the right, not at the top")
        for _ in 0..<20 { step(Self.pose(0, rest: rest)) }
        #expect(state.phase == .circling && changes == [.success, .success])
        for _ in 0..<30 { step(Self.pose(180, rest: rest)) }
        #expect(state.sweep < 1, "a jump across the circle does not count")
        var angle = 0.0
        while angle < 305 {
            angle += 1
            step(Self.pose(angle, rest: rest))
        }
        #expect(state.phase == .returning && state.checkpointTimes.count == 4 && changes.count == 5)
        #expect(state.checkpointTimes == state.checkpointTimes.sorted())
        for _ in 0..<30 { step(rest) }
        #expect(state.isComplete && changes.last == .completed && changes.filter { $0 == .success }.count == 5)
    }

    @Test("the second loop starts on the left and turns the other way; the first loop's sense does nothing for it")
    func reverseLoop() throws {
        let second = try #require(loops.last)
        func turning(_ sense: Double) -> AncreStageState {
            var (state, t) = Self.settled(second)
            var angle = 180.0
            for _ in 0..<340 {
                t += Self.frame
                _ = state.update(OculoInput(seconds: Self.frame, gaze: state.anchor, gazeActive: true, head: Self.pose(angle), elapsed: t))
                angle -= sense
            }
            return state
        }
        let clockwise = turning(1)
        #expect(clockwise.phase == .returning && clockwise.checkpointTimes.count == 4)
        let anticlockwise = turning(-1)
        #expect(anticlockwise.phase == .circling && anticlockwise.sweep < 1)
    }

    @Test("a tremble of the estimate costs nothing; a clear look away pauses the ring once without undoing it; lost head and gaze only pause it")
    func leniency() throws {
        var (state, t) = Self.settled(try #require(loops.first))
        var changes: [OculoChange] = []
        func step(_ head: HeadPose?, gaze: Vector2? = nil, active: Bool = true) {
            t += Self.frame
            changes += state.update(OculoInput(seconds: Self.frame, gaze: gaze ?? state.anchor, gazeActive: active, head: head, elapsed: t)).changes
        }
        var angle = 0.0
        for _ in 0..<60 {
            step(Self.pose(angle))
            angle += 1
        }
        #expect(state.phase == .circling && state.sweep > 50)
        let tremble = Vector2(x: state.anchor.x, y: state.anchor.y + 150)
        for _ in 0..<12 {
            step(Self.pose(angle), gaze: tremble)
            angle += 1
        }
        #expect(state.isFocused && !changes.contains(.miss))
        let held = state.sweep
        for _ in 0..<60 {
            step(Self.pose(angle), gaze: Vector2(x: 30, y: 830))
            angle += 0.5
        }
        #expect(changes.filter { $0 == .miss }.count == 1 && !state.isFocused && state.sweep < held + 12)
        let paused = state.sweep
        for _ in 0..<60 {
            step(Self.pose(angle))
            angle += 0.5
        }
        #expect(state.isFocused && state.sweep > paused + 10)
        let kept = state.sweep
        for _ in 0..<60 { step(nil, active: false) }
        #expect(state.sweep == kept && state.phase == .circling && state.headGap >= 0.99)
        for _ in 0..<40 {
            step(Self.pose(angle))
            angle += 1
        }
        #expect(state.sweep > kept + 20)
    }

    @Test("the ring fills at a calm pace: a head spinning at 400°/s gets ahead of it and waits, a calm one draws the circle")
    func pace() throws {
        let first = try #require(loops.first)
        func spinning(_ degreesPerSecond: Double) -> AncreStageState {
            var (state, t) = Self.settled(first)
            var angle = 0.0
            for _ in 0..<300 {
                t += Self.frame
                _ = state.update(OculoInput(seconds: Self.frame, gaze: state.anchor, gazeActive: true, head: Self.pose(angle), elapsed: t))
                angle += degreesPerSecond * Self.frame
            }
            return state
        }
        let calm = spinning(60)
        let fast = spinning(400)
        #expect(calm.phase == .returning || calm.sweep >= 290)
        #expect(fast.sweep < calm.sweep / 2, "fast \(fast.sweep), calm \(calm.sweep)")
    }

    @Test("the three steps are told in order: the point, the head round from the right, the other way; the late help speaks of the head; no clinical word")
    func instructions() {
        #expect(level.principle.components(separatedBy: "\n").count == 3)
        var tracker = HintTracker.forLevel(level)
        tracker.begin()
        #expect(tracker.current == "Regardez le point au centre.")
        tracker.observe(events: [.oculoSuccess(stage: 0)], elapsed: 5)
        #expect(tracker.current?.contains("à droite") == true)
        tracker.observe(events: [.oculoStageCompleted(stage: 0)], elapsed: 20)
        #expect(tracker.current?.contains("autre sens") == true)
        tracker.observe(events: [], elapsed: 46)
        #expect(tracker.current == level.oculo?.help)
        let words = ([level.principle, level.oculo?.help ?? "", GameElement.ancre.summary] + level.hints.map(\.text)).joined(separator: " ").lowercased()
        for word in ["vestibul", "réflexe", "thérap", "médic", "rééduc", "clinique", "guéri"] {
            #expect(!words.contains(word), "\(word)")
        }
    }

    @Test("the head is read like the screen: the calibration's axis mapping turns camera-frame angles into right and up")
    func screenOrientedHead() {
        let observation = GazeObservation(headYaw: 7, headPitch: -3, headRoll: 1, leftEye: .zero, rightEye: .zero, lookAt: .zero)
        #expect(GameViewModel.screenHead(observation, mapping: .standard) == HeadPose(yaw: 7, pitch: -3))
        #expect(GameViewModel.screenHead(observation, mapping: AxisMapping(right: .negativeX, up: .positiveY)) == HeadPose(yaw: -7, pitch: -3))
        #expect(GameViewModel.screenHead(observation, mapping: AxisMapping(right: .positiveY, up: .negativeX)) == HeadPose(yaw: -3, pitch: -7))
    }

    @Test("guided bot wins within its par, avoidance and off-screen never")
    func bots() {
        let guided = (1...3).map { CampaignBot(definition: level, policy: .guided, seed: $0).run(maxSeconds: 90) }
        let solved = guided.allSatisfy(\.completed)
        #expect(solved, "guided \(guided.map(\.time))")
        #expect(!CampaignBot(definition: level, policy: .avoidance).run(maxSeconds: 60).completed)
        #expect(!CampaignBot(definition: level, policy: .offScreen).run(maxSeconds: 30).completed)
        let measurement = CampaignMeasurements.of(level)
        let formula = (1.8 * measurement.guidedTime + 6).rounded()
        #expect(abs(Double(level.par.time) - formula) < 0.5, "par from the historical formula: guided \(measurement.guidedTime) s gives \(formula)")
        #expect(Double(level.par.intrusions) == measurement.guidedIntrusions.rounded(.up) + 2, "guided intrusions \(measurement.guidedIntrusions)")
    }
}
