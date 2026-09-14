// OculoAncreTests.swift
// Layer: Tests
// Purpose: Chapter X final « l'ancre », option A: the eyes are checked before each circle and after the last one, the
// head alone draws the circles. The fixations then a correct head path win; a gaze far away or missing during a circle
// changes nothing; a still head, the wrong sense, separate poses and random gazes never win; a lost head pose only
// pauses; no re-fixation holds the second circle and no closing fixation holds the end; the other finals are untouched.

import CryptoKit
import Foundation
import simd
import Testing
@testable import Iris

@Suite("Chapter X final: ancre")
struct OculoAncreTests {
    private typealias Support = OculoStageTestSupport
    private var level: LevelDefinition { Campaign.finalGouffres }
    private static let frame = 1.0 / 60.0
    private static let farAway = Vector2(x: -180, y: -260)

    /// SHA-256 of the other oculomotor finals and of the stage machines they run, as played on device; X·7's work must
    /// leave them byte for byte.
    static let otherFinals: [String: String] = [
        "Domain/Campaign/Campaign+FinalBraises.swift": "7391c5964b89675aba28e1a8ba7bba4d8f6fba0eeb0a49a648afdc836d2931c5",
        "Domain/Campaign/Campaign+FinalClairvoyance.swift": "14f3db3fae248ee613aea4144070b0521244143458c4c58049277ddee4001428",
        "Domain/Campaign/Campaign+FinalConstellation.swift": "cb06cd48a2e1b97996caf62cc2da5f106fa15a344a1f7efd7802df4ec230d2c0",
        "Domain/Campaign/Campaign+FinalCourants.swift": "27b19cc477516a3b6c59e2bab6f730514ac60f58c5257c4242cfbcf45ce76fe8",
        "Domain/Campaign/Campaign+FinalEchos.swift": "b46da0f67730b41504493ad5fe2357a4ded9270a1eeb669b3da6ad48203336a6",
        "Domain/Campaign/Campaign+FinalJumelles.swift": "23888502105f9f3ca43c10b8a5ba6856f959ecaa87ec4b981599df38f4f2b7e8",
        "Domain/Campaign/Campaign+FinalPartage.swift": "e3f8bde2c3b47117d28142327422c464bff34d80a7eb31c2261162ba5339750d",
        "Domain/Campaign/Campaign+FinalSouffles.swift": "cca2f4aebeb468c7930bea905859d09f01b0e1405c1a5d4efdc021630229ad84",
        "Domain/Campaign/Campaign+FinalVeilleuses.swift": "787081d1dcd13288fec7f0ee5fb96a67e54d0a8f9ea5d66e6f6bbd2e7f14b38a",
        "Domain/Campaign/Campaign+FinalVoiles.swift": "af91cb34dddfde77a890893a4977076b0655ee719e28ae08e885679ba8fcbec9",
        "GameEngine/Oculo/AbsenceStageState.swift": "a916975104a7be49d054abd3b4aa9a7f13ba079497565ea39210afc19f5a6593",
        "GameEngine/Oculo/CoeurStageState.swift": "20eac6599b7598c929c9085bcf2c9d5f367aadd329bf42cc3a56f569da708081",
        "GameEngine/Oculo/CourantStageState.swift": "40d249e5869452c18f39409546a621cfcb3746d9eb8d0c8b48f946fb2a00e7d8",
        "GameEngine/Oculo/CroisementStageState.swift": "131a1a181dfdc8537f60f869fdc094abe7ee8ca29b536bfa9ea1428c1750483e",
        "GameEngine/Oculo/EtoilesStageState.swift": "20c898eb0a473b67350ebfcdefc605bf8fbe6175e4b0f5db08dc23d4fb5243bc",
        "GameEngine/Oculo/FilStageState.swift": "6375449a67b5eb0bf992fc3d27b15bdd327b57cadd224c3913e6162b544268a4",
        "GameEngine/Oculo/JardinStageState.swift": "c56d65f0a8a01fb4ce79089010e182d5a4be2d05e8cd8e4fc29e7cf4051dcadc",
        "GameEngine/Oculo/MiroirStageState.swift": "15478b4f64b352fd5f32d863d98e5a7b55eeda697761c03f95a66aed877d6118",
        "GameEngine/Oculo/OculoStageState.swift": "9c4928c9cba83afd10f946623173ffa5ab6159a62882922b46538f9fd9b1412e",
        "GameEngine/Oculo/TournerStageState.swift": "872d3b88f78c72fe9634d3db1c4dd6596cb1f5f49badc23b0e03de08438eed1a",
    ]

    private static var projectRoot: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
    }

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

    private static func loop(_ session: GameSession) -> AncreStageState? {
        if case let .ancre(state)? = session.oculo?.current { return state }
        return nil
    }

    /// A point of the full-size circle (degrees anticlockwise from the right), around a rest pose.
    private static func pose(_ degrees: Double, rest: HeadPose = .neutral) -> HeadPose {
        HeadPose(yaw: rest.yaw + 10 * cos(degrees * .pi / 180), pitch: rest.pitch + 8 * sin(degrees * .pi / 180))
    }

    /// After the opening fixation, out to the right and round the wrong way (down first), for ever.
    private static func wrongWay(_ index: Int, _ session: GameSession) -> HeadPose? {
        let t = Double(index) * frame
        guard t > 1.5 else { return .neutral }
        let size = min(1, (t - 1.5) / 0.5)
        let angle = -45 * max(0, t - 2) * .pi / 180
        return HeadPose(yaw: 10 * size * cos(angle), pitch: 8 * size * sin(angle))
    }

    /// After the opening fixation: right, centre, up, centre, left, centre, down, centre, each held apart, over and over.
    private static func separatePoses(_ index: Int, _ session: GameSession) -> HeadPose? {
        let t = Double(index) * frame
        guard t > 1.5 else { return .neutral }
        let slot = Int((t - 1.5) / 0.8)
        guard slot.isMultiple(of: 2) else { return .neutral }
        return pose(Double(slot / 2 % 4) * 90)
    }

    /// One loop run frame by frame, the gaze and the head chosen by the caller.
    private struct Driver {
        var state: AncreStageState
        var t = 0.0
        var changes: [OculoChange] = []

        mutating func step(head: HeadPose?, gaze: Vector2? = nil, gazeActive: Bool = true) {
            t += OculoAncreTests.frame
            changes += state.update(OculoInput(seconds: OculoAncreTests.frame, gaze: gaze ?? state.anchor, gazeActive: gazeActive, head: head, elapsed: t)).changes
        }

        /// The opening fixation: the eyes on the point and the head still at `rest` for a second.
        mutating func fixate(rest: HeadPose = .neutral) {
            for _ in 0..<60 { step(head: rest) }
        }

        /// Round the circle from `from` to `to` degrees at `speed` degrees per second, the gaze as given.
        mutating func circle(from: Double, to: Double, speed: Double = 60, rest: HeadPose = .neutral, gaze: Vector2? = nil, gazeActive: Bool = true) {
            var angle = from
            let stepSize = speed * OculoAncreTests.frame * (to >= from ? 1 : -1)
            while to >= from ? angle < to : angle > to {
                angle += stepSize
                step(head: OculoAncreTests.pose(angle, rest: rest), gaze: gaze, gazeActive: gazeActive)
            }
        }
    }

    // MARK: Structure

    @Test("structure: 10-7 stays the optional final of chapter X; two loops right then left, each opened by a fixation, the last closed by one; only this level reads the head without the gaze")
    func structure() throws {
        let chapter = try #require(Campaign.chapter(number: 10))
        #expect(chapter.levels.count == 7 && chapter.levels.last?.id == "10-7")
        #expect(Campaign.level(id: "10-7") == level && !level.gatesProgression && level.introduces == [.ancre])
        #expect(level.lueurs.count == 1 && !level.requiresPushing && level.gouffres.isEmpty, "no push after the loops")
        let states = loops
        #expect(states.map(\.start) == [.right, .left] && states.map(\.turn) == [1.0, -1.0])
        #expect((0.7...0.9).contains(states[0].fixation) && states[0].closingFixation == nil, "a steady opening fixation, no closing one")
        #expect((0.6...0.8).contains(states[1].fixation) && (0.6...0.8).contains(states[1].closingFixation ?? 0), "a short re-fixation, then a closing one")
        for state in states {
            #expect(state.anchor == states[0].anchor)
            #expect((6...14).contains(state.yawAmplitude) && (5...12).contains(state.pitchAmplitude), "small, comfortable turns")
            #expect(state.neutralYaw >= 20 && state.neutralPitch >= 20, "roughly facing the screen, not exactly")
        }
        let pause = level.oculo?.pause ?? 0
        #expect(pause >= 1.2, "a breath for the stardust between the loops")
        #expect(level.oculo?.readsHeadWithoutGaze == true)
        #expect(Campaign.levels.filter { $0.oculo?.readsHeadWithoutGaze == true }.map(\.id) == ["10-7"])
    }

    // MARK: A to J

    @Test("A: the opening fixation then a correct head path: the first circle begins and progresses through its checkpoints")
    func fixationThenCircle() throws {
        var loop = Driver(state: try #require(loops.first))
        let rest = HeadPose(yaw: 3, pitch: -2)
        loop.fixate(rest: rest)
        #expect(loop.state.phase == .seeking && loop.state.restPose == rest && loop.changes == [.success])
        for _ in 0..<30 { loop.step(head: Self.pose(90, rest: rest)) }
        #expect(loop.state.phase == .seeking, "the circle starts on the right, not at the top")
        for _ in 0..<20 { loop.step(head: Self.pose(0, rest: rest)) }
        #expect(loop.state.phase == .circling && loop.changes == [.success, .success])
        loop.circle(from: 0, to: 150, rest: rest)
        #expect(loop.state.sweep >= 140 && loop.state.checkpointTimes.count == 2 && loop.changes.count == 3)
        loop.circle(from: 150, to: 305, rest: rest)
        for _ in 0..<30 { loop.step(head: rest) }
        #expect(loop.state.isComplete && loop.changes.last == .completed && loop.changes.filter { $0 == .success }.count == 5)
    }

    @Test("B: during a circle the gaze far off screen changes nothing: the ring fills exactly as with the eyes on the point, no pause, no miss; the whole level still ends")
    func farGazeDuringCircle() throws {
        var onPoint = Driver(state: try #require(loops.first))
        var away = onPoint
        onPoint.fixate()
        away.fixate()
        for _ in 0..<20 {
            onPoint.step(head: Self.pose(0))
            away.step(head: Self.pose(0), gaze: Self.farAway)
        }
        onPoint.circle(from: 0, to: 305)
        away.circle(from: 0, to: 305, gaze: Self.farAway)
        #expect(away.state.sweep == onPoint.state.sweep && away.state.phase == .returning && away.state.checkpointTimes.count == 4)
        #expect(away.changes == onPoint.changes && !away.changes.contains(.miss))
        for _ in 0..<30 { away.step(head: .neutral, gaze: Self.farAway) }
        #expect(away.state.isComplete, "the first loop closes at the return, whatever the gaze")

        let run = Support.run(level, seconds: 90, head: Self.oracleHead, policy: { index, session, generator in
            if let state = Self.loop(session), state.isHeadOnly, session.oculo?.isBreathing == false {
                return Vector2(x: -180 + Double(index % 7) * 110, y: index.isMultiple(of: 2) ? -260 : 1_200)
            }
            return Support.oracle(index, session, &generator)
        })
        #expect(run.completedSequence && run.successes == 11 && run.misses == 0 && run.session.isComplete)
    }

    @Test("C: during a circle no gaze at all, with a valid head pose: nothing is cancelled or paused")
    func missingGazeDuringCircle() throws {
        var withGaze = Driver(state: try #require(loops.first))
        var without = withGaze
        withGaze.fixate()
        without.fixate()
        for _ in 0..<20 {
            withGaze.step(head: Self.pose(0))
            without.step(head: Self.pose(0), gazeActive: false)
        }
        withGaze.circle(from: 0, to: 200)
        without.circle(from: 0, to: 200, gazeActive: false)
        #expect(without.state.sweep == withGaze.state.sweep && without.state.sweep > 180 && without.changes == withGaze.changes)
    }

    @Test("D: a still head with a perfect gaze never validates a circle")
    func stillHead() {
        let run = Support.run(level, seconds: 45, head: { _, _ in .neutral }, policy: Support.oracle)
        let loopsDone = run.events.filter { if case .oculoStageCompleted = $0 { return true } else { return false } }.count
        #expect(!run.completedSequence && run.successes == 1 && loopsDone == 0, "the fixation, then nothing")
        #expect(Self.loop(run.session)?.phase == .seeking)
    }

    @Test("E: the circle the wrong way round never validates")
    func wrongSense() throws {
        let run = Support.run(level, seconds: 45, head: Self.wrongWay, policy: Support.oracle)
        #expect(!run.completedSequence && run.successes == 2, "fixation and start, then the ring waits")
        var loop = Driver(state: try #require(loops.first))
        loop.fixate()
        for _ in 0..<20 { loop.step(head: Self.pose(0)) }
        loop.circle(from: 0, to: -340)
        #expect(loop.state.phase == .circling && loop.state.sweep < 1)
    }

    @Test("F: separate poses joined through the centre, or jumps across the circle, never make a circle")
    func separatePosesNeverWin() throws {
        let run = Support.run(level, seconds: 45, head: Self.separatePoses, policy: Support.oracle)
        #expect(!run.completedSequence && run.successes == 2)
        var loop = Driver(state: try #require(loops.first))
        loop.fixate()
        for _ in 0..<20 { loop.step(head: Self.pose(0)) }
        for angle in [90.0, 180, 270, 0, 90, 180, 270] {
            for _ in 0..<30 { loop.step(head: Self.pose(angle)) }
        }
        #expect(loop.state.sweep < 1 && loop.state.checkpointTimes.count == 1)
    }

    @Test("G: a real loss of head pose suspends the circle: nothing moves, nothing is invented, and it goes on with the head")
    func headLossSuspends() throws {
        var loop = Driver(state: try #require(loops.first))
        loop.fixate()
        for _ in 0..<20 { loop.step(head: Self.pose(0)) }
        loop.circle(from: 0, to: 90)
        let kept = loop.state.sweep
        for _ in 0..<60 { loop.step(head: nil, gaze: Self.farAway, gazeActive: false) }
        #expect(loop.state.sweep == kept && loop.state.phase == .circling && loop.state.headGap >= 0.99)
        for _ in 0..<20 { loop.step(head: Self.pose(120)) }
        #expect(loop.state.sweep == kept, "a head found further on, standing still, adds nothing")
        loop.circle(from: 90, to: 160)
        #expect(loop.state.sweep > kept + 50)

        let noHead = Support.run(level, seconds: 45, policy: Support.oracle)
        #expect(!noHead.completedSequence && noHead.successes == 0, "no head pose: not even the fixation")
    }

    @Test("H: the first circle done but no re-fixation of the point: the second circle never begins, even with the head drawing it")
    func noRefixation() {
        var reverseStart: Int?
        let run = Support.run(level, seconds: 40, head: { index, session in
            guard session.oculo?.currentIndex == 1, session.oculo?.isBreathing == false else { return Self.oracleHead(index, session) }
            let start = reverseStart ?? index
            reverseStart = start
            return Self.pose(180 - 45 * Double(index - start) * Self.frame)
        }, policy: { index, session, generator in
            if (session.oculo?.currentIndex ?? 0) >= 1 { return Vector2(x: 30, y: 830) }
            return Support.oracle(index, session, &generator)
        })
        let loopsDone = run.events.filter { if case .oculoStageCompleted = $0 { return true } else { return false } }.count
        #expect(loopsDone == 1 && run.successes == 5 && !run.completedSequence)
        #expect(run.session.oculo?.currentIndex == 1 && Self.loop(run.session)?.phase == .fixating)
    }

    @Test("I: the second circle drawn but no closing fixation: the level does not end; the eyes back on the point end it")
    func noClosingFixation() {
        var eyesBack = false
        let run = Support.run(level, seconds: 40, head: Self.oracleHead, policy: { index, session, generator in
            if !eyesBack, session.oculo?.currentIndex == 1, Self.loop(session)?.phase == .refixating { return Vector2(x: 30, y: 830) }
            return Support.oracle(index, session, &generator)
        })
        #expect(!run.completedSequence && !run.session.isComplete && run.successes == 11)
        #expect(Self.loop(run.session)?.phase == .refixating)

        eyesBack = true
        var session = run.session
        var events: [GameEvent] = []
        for _ in 0..<60 {
            session.placeGaze(at: session.oculo?.suggestedGaze(at: session.elapsed) ?? Vector2(x: 30, y: 830))
            session.ingestHeadPose(session.oculo?.suggestedHead ?? .neutral)
            events += session.advance(by: Self.frame)
        }
        #expect(events.contains(.oculoCompleted), "a closing fixation of well under a second completes the loops")
    }

    @Test("J: two correct circles with the required fixations end the level: eleven successes, no miss, the lueur released; the head never turns more than 11°")
    func twoLoops() {
        var largest = 0.0
        let run = Support.run(level, seconds: 90, head: { index, session in
            let pose = Self.oracleHead(index, session)
            largest = max(largest, abs(pose?.yaw ?? 0), abs(pose?.pitch ?? 0))
            return pose
        }, policy: Support.oracle)
        let loopsDone = run.events.filter { if case .oculoStageCompleted = $0 { return true } else { return false } }.count
        #expect(run.completedSequence && run.successes == 11 && run.misses == 0 && loopsDone == 2 && !run.session.areLueursLatent)
        #expect(largest <= 11)
        let tail = run.session.elapsed - (run.session.oculo?.completedAt ?? 0)
        #expect(run.session.isComplete && tail <= 6, "the level ends on its own \(tail) s after the loops")
    }

    // MARK: Fixations, pace, sense

    @Test("the opening fixation needs the eyes on the point, a head present, still and roughly facing the screen")
    func fixationRequirements() throws {
        let first = try #require(loops.first)
        var gazeAway = Driver(state: first)
        for _ in 0..<90 { gazeAway.step(head: .neutral, gaze: Self.farAway) }
        var turned = Driver(state: first)
        for _ in 0..<90 { turned.step(head: HeadPose(yaw: 45, pitch: 0)) }
        var moving = Driver(state: first)
        for index in 0..<90 { moving.step(head: HeadPose(yaw: index.isMultiple(of: 20) ? 0 : 4, pitch: 0)) }
        var noHead = Driver(state: first)
        for _ in 0..<90 { noHead.step(head: nil) }
        var steady = Driver(state: first)
        steady.fixate()
        #expect([gazeAway, turned, moving, noHead].allSatisfy { $0.state.phase == .fixating && $0.changes.isEmpty })
        #expect(steady.state.phase == .seeking)
    }

    @Test("the second loop starts on the left and turns the other way, then asks for the closing fixation; the first loop's sense does nothing for it")
    func reverseLoop() throws {
        let second = try #require(loops.last)
        var clockwise = Driver(state: second)
        clockwise.fixate()
        clockwise.circle(from: 180, to: -160)
        for _ in 0..<30 { clockwise.step(head: .neutral, gaze: Self.farAway) }
        #expect(clockwise.state.phase == .refixating && clockwise.state.checkpointTimes.count == 4)
        for _ in 0..<60 { clockwise.step(head: .neutral) }
        #expect(clockwise.state.isComplete)
        var anticlockwise = Driver(state: second)
        anticlockwise.fixate()
        anticlockwise.circle(from: 180, to: 520)
        #expect(anticlockwise.state.phase == .circling && anticlockwise.state.sweep < 1)
    }

    @Test("the ring fills at a calm pace: a head spinning at 400°/s gets ahead of it and waits, a calm one draws the circle")
    func pace() throws {
        let first = try #require(loops.first)
        func spinning(_ speed: Double) -> AncreStageState {
            var loop = Driver(state: first)
            loop.fixate()
            var angle = 0.0
            for _ in 0..<300 {
                loop.step(head: Self.pose(angle))
                angle += speed * Self.frame
            }
            return loop.state
        }
        let calm = spinning(60)
        let fast = spinning(400)
        #expect(calm.phase == .returning || calm.sweep >= 290)
        #expect(fast.sweep < calm.sweep / 2, "fast \(fast.sweep), calm \(calm.sweep)")
    }

    @Test("roll is never the circle: a pure roll of the face leaves yaw and pitch at zero, a turn does not")
    @MainActor
    func rollIsNotACircle() {
        func observation(_ rotation: simd_quatf) -> GazeObservation {
            ARKitGazeTrackingService.observation(anchorToView: simd_float4x4(rotation), leftEye: .zero, rightEye: .zero, lookAt: .zero)
        }
        let roll = observation(simd_quatf(angle: 20 * .pi / 180, axis: SIMD3<Float>(0, 0, 1)))
        #expect(abs(roll.headYaw) < 1e-4 && abs(roll.headPitch) < 1e-4 && abs(abs(roll.headRoll) - 20) < 0.01)
        let turn = observation(simd_quatf(angle: 12 * .pi / 180, axis: SIMD3<Float>(0, 1, 0)))
        #expect(abs(abs(turn.headYaw) - 12) < 0.01 && abs(turn.headPitch) < 1e-4)
    }

    // MARK: Texts, head orientation, bots, other finals

    @Test("the steps are told in order: the point, the circle from the right, back to the point, the other way, a last look; the late help speaks of the head; no clinical word")
    func instructions() {
        #expect(level.principle.components(separatedBy: "\n").count == 3)
        var tracker = HintTracker.forLevel(level)
        tracker.begin()
        #expect(tracker.current == "Gardez les yeux sur le point.")
        tracker.observe(events: [.oculoSuccess(stage: 0)], elapsed: 3)
        #expect(tracker.current?.contains("cercle avec la tête") == true)
        tracker.observe(events: [.oculoStageCompleted(stage: 0)], elapsed: 15)
        #expect(tracker.current?.contains("les yeux sur le point") == true)
        tracker.observe(events: [.oculoSuccess(stage: 1)], elapsed: 18)
        #expect(tracker.current?.contains("autre sens") == true)
        for second in 19...22 { tracker.observe(events: [.oculoSuccess(stage: 1)], elapsed: Double(second)) }
        #expect(tracker.current?.contains("dernière fois") != true)
        tracker.observe(events: [.oculoSuccess(stage: 1)], elapsed: 26)
        #expect(tracker.current?.contains("dernière fois") == true)
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

    @Test("L: the other oculomotor finals and the stage machines they run are untouched, byte for byte")
    func otherFinalsUntouched() throws {
        #expect(Self.otherFinals.count == 20)
        for (path, expected) in Self.otherFinals.sorted(by: { $0.key < $1.key }) {
            let data = try Data(contentsOf: Self.projectRoot.appendingPathComponent(path))
            let digest = SHA256.hash(data: data).map { byte -> String in
                let hex = String(byte, radix: 16)
                return hex.count == 1 ? "0" + hex : hex
            }.joined()
            #expect(digest == expected, "\(path)")
        }
        for number in [2, 3, 4, 5, 6, 7, 8, 9, 11, 12] {
            #expect(Campaign.oculomotorFinal(forChapter: number)?.oculo?.readsHeadWithoutGaze == false, "chapter \(number)")
        }
    }
}
