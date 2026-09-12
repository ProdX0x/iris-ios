// BraisesPrototypeTests.swift
// Layer: Tests
// Purpose: EXPERIMENTAL prototype B1: the two braise levels behave as designed, are feasible when fed and impossible
// otherwise, and leave the official campaign, its progress and its records untouched

import Foundation
import Testing
@testable import Iris

#if DEBUG
@Suite("Braises prototype")
struct BraisesPrototypeTests {
    private let bounds = CampaignBot.referenceBounds
    private let frame = 1.0 / 60.0

    private func session(_ level: LevelDefinition, gaze: Vector2) -> GameSession {
        let resolved = LevelResolver.resolve(level, in: bounds)
        var session = resolved.makeSession(noiseSources: level.lueurs.map { _ in SilentNoise() })
        session.placeGaze(at: gaze)
        return session
    }

    /// Runs `seconds`, placing the gaze each frame at `offset` from the braise (a gaze that follows what it looks at).
    private func follow(_ session: inout GameSession, index: Int, offset: Vector2, seconds: Double) -> [GameEvent] {
        var events: [GameEvent] = []
        for _ in 0..<Int(seconds * 60) {
            session.placeGaze(at: session.targets[index].position + offset)
            events += session.advance(by: frame)
        }
        return events
    }

    private func run(_ session: inout GameSession, seconds: Double) -> [GameEvent] {
        var events: [GameEvent] = []
        for _ in 0..<Int(seconds * 60) { events += session.advance(by: frame) }
        return events
    }

    @Test("A: a cold braise sleeps with a closed iris; a brief gaze lights it, makes it flee, then it settles once left alone")
    func discovery() {
        var sut = session(BraisesPrototype.a, gaze: Vector2(x: 40, y: 800))
        let start = sut.targets[0].position
        let asleep = run(&sut, seconds: 3)

        #expect(sut.targets[0].position == start, "asleep: no drift, no noise")
        #expect(!sut.isIrisOpen(for: sut.targets[0]))
        #expect(sut.braises[0]?.heat == 0)
        #expect(!asleep.contains { if case .braiseLit = $0 { return true } else { return false } })

        let fed = follow(&sut, index: 0, offset: Vector2(x: 0, y: 45), seconds: 0.6)
        #expect(fed.contains(.braiseLit(sequence: 1)))
        #expect(!fed.contains(.braiseFlared(sequence: 1)), "0.6 s of gaze lights without flaring")
        #expect(sut.braises[0]?.isLit == true)
        #expect(sut.isIrisOpen(for: sut.targets[0]))
        #expect(sut.targets[0].position.y < start.y - 30, "fed from below, it flees upward, toward its iris")
        #expect(fed.contains { if case .intrusion = $0 { return true } else { return false } })

        sut.placeGaze(at: Vector2(x: 40, y: 800))
        let left = run(&sut, seconds: 6)
        #expect(left.contains(.targetValidated(sequence: 1)))
        #expect(left.contains(.levelCompleted))
        #expect(sut.isComplete)
    }

    @Test("A: staring flares the braise, whose attention zone grows; it never loses its heat for being looked at")
    func flare() {
        var sut = session(BraisesPrototype.a, gaze: Vector2(x: 40, y: 800))
        let stared = follow(&sut, index: 0, offset: Vector2(x: 0, y: 45), seconds: 1.3)

        #expect(stared.contains(.braiseLit(sequence: 1)))
        #expect(stared.contains(.braiseFlared(sequence: 1)))
        #expect(sut.braises[0]?.isFlaring == true)
        #expect((sut.braises[0]?.behaviour.attentionZone ?? 1) > 1.2)
        #expect(sut.braises[0]?.isLit == true, "flaring is not burning out")
        #expect(sut.isIrisOpen(for: sut.targets[0]))
    }

    @Test("the guided player, who feeds, completes both prototypes; the player who never feeds cannot; nor can an off-screen gaze")
    func feasibilityAndNecessity() {
        for level in BraisesPrototype.levels {
            let guided = (1...3).map { CampaignBot(definition: level, policy: .guided, seed: $0).run(maxSeconds: 90) }
            let solved = guided.allSatisfy(\.completed)
            #expect(solved, "\(level.id) guided: \(guided.map(\.time))")
            let avoidance = CampaignBot(definition: level, policy: .avoidance).run(maxSeconds: 60)
            #expect(!avoidance.completed, "\(level.id) must need feeding")
            let offScreen = CampaignBot(definition: level, policy: .offScreen).run(maxSeconds: 30)
            #expect(!offScreen.completed, "\(level.id) off screen")
            let meanTime = guided.map(\.time).reduce(0, +) / 3
            let meanIntrusions = Double(guided.map(\.intrusions).reduce(0, +)) / 3
            #expect(level.par.time >= meanTime * 1.4 && level.par.time <= meanTime * 3 + 10, "\(level.id) par time \(level.par.time) vs bot \(meanTime)")
            #expect(Double(level.par.intrusions) >= meanIntrusions.rounded(.up) + 1, "\(level.id) par intrusions \(level.par.intrusions) vs bot \(meanIntrusions)")
            print("braises lab \(level.id): time \(meanTime) intrusions \(meanIntrusions) losses \(guided.map(\.losses))")
        }
    }

    // MARK: B1.1 — the conflict of B exists physically and depends on when the braise is woken

    private struct Run {
        var events: [(time: Double, event: GameEvent)] = []
        var maxDisturbanceOfOne = 0.0
        var time = 0.0
        var losses = 0
        var complete = false
        func times(of predicate: (GameEvent) -> Bool) -> [Double] { events.filter { predicate($0.event) }.map(\.time) }
    }

    /// Plays B with a smoothed gaze like the real game: rests at `rest`, wakes the braise (looking 20 pt under it until it
    /// lights) as soon as `wakeWhen` says so, then rests again.
    private func playB(rest: Vector2, wakeWhen: (GameSession) -> Bool) -> Run {
        let level = BraisesPrototype.b
        let resolved = LevelResolver.resolve(level, in: bounds)
        var session = resolved.makeSession(noiseSources: level.lueurs.map { _ in SilentNoise() })
        session.placeGaze(at: rest)
        var run = Run()
        var waking = false
        var woken = false
        for _ in 0..<Int(20 * 60) {
            if !woken && !waking && wakeWhen(session) { waking = true }
            if waking && session.braises[1]?.isLit == true { waking = false; woken = true }
            let gaze = waking ? session.targets[1].position + Vector2(x: 0, y: 20) : rest
            session.ingestGaze(gaze)
            let events = session.advance(by: frame)
            run.events += events.map { (session.elapsed, $0) }
            run.maxDisturbanceOfOne = max(run.maxDisturbanceOfOne, session.targets[0].disturbance)
            if session.isComplete { break }
        }
        run.time = session.elapsed
        run.losses = session.metrics.losses
        run.complete = session.isComplete
        return run
    }

    @Test("B geometry: the sleeping braise sits inside the zone of a gaze on the first lueur's iris; its own iris is far from it")
    func geometryOfB() {
        let level = BraisesPrototype.b
        let resolved = LevelResolver.resolve(level, in: bounds)
        let zone = resolved.level.targets[0].attentionZone
        let irisOne = level.lueurs[0].iris.absolute(in: bounds)
        let braiseStart = level.lueurs[1].start.absolute(in: bounds)
        let braiseIris = level.lueurs[1].iris.absolute(in: bounds)
        #expect(abs(braiseStart.distance(to: irisOne) - 120) < 2, "a gaze that wakes the braise is 120 pt from iris 1: inside the 181 pt zone")
        #expect(braiseIris.distance(to: irisOne) > 150, "the lit braise waits far enough from iris 1")
        #expect(level.ordered && level.lueurs[0].braise == nil && level.lueurs[1].braise != nil)
        #expect(level.lueurs[1].braise == .prototype, "B uses exactly the braise tuning validated in A")
        #expect(braiseStart.y >= 0.12 * bounds.height && braiseIris.y >= 0.12 * bounds.height, "nothing to look at in the top margin")
        // B1.2: the experimental rule is stated on the intro card and its consequence at the start; the loss names the cause.
        #expect(level.principle == "Réveillez la braise avant que la 1 n'atteigne son iris.")
        #expect(level.hints.map(\.trigger) == [.start, .braiseFlared, .firstLoss])
        #expect(level.hints[0].text == "Trop tard, votre regard chassera la 1.")
        #expect(level.hints[2].text == "Trop tard : votre regard sur la braise a chassé la 1.")
        #expect(level.hints.allSatisfy { $0.text.split(separator: " ").count <= 12 }, "one short line each")
    }

    @Test("B: the waking gaze physically reaches the settled lueur: woken first, nothing is lost; woken after the lueur settled, it is chased")
    func timingConflict() {
        for rest in [Vector2(x: 350, y: 800), Vector2(x: 350, y: 60)] {
            let prudent = playB(rest: rest) { _ in true }
            let conflict = playB(rest: rest) { $0.targets[0].isValidated }

            #expect(prudent.complete && prudent.losses == 0, "wake first: \(prudent.time) s")
            #expect(prudent.times(of: { $0 == .targetValidated(sequence: 1) }).count == 1)
            #expect(prudent.time < 7)

            #expect(conflict.complete, "the level stays completable after the conflict")
            #expect(conflict.losses == 1)
            let validatedOne = conflict.times(of: { $0 == .targetValidated(sequence: 1) })
            let lostOne = conflict.times(of: { $0 == .targetLost(sequence: 1, cause: .drift) })
            #expect(validatedOne.count == 2 && lostOne.count == 1, "settled, chased by the waking gaze, settled again")
            if let firstValidation = validatedOne.first, let loss = lostOne.first {
                #expect(loss > firstValidation && loss - firstValidation < 1.2, "the loss follows the waking gaze within a second")
            }
            #expect(conflict.maxDisturbanceOfOne > 0.25, "the same gaze that wakes the braise pushes the lueur (0.25 already reaches the speed cap)")
            #expect(conflict.time > prudent.time + 1.5, "waiting is not free")
            #expect(prudent.maxDisturbanceOfOne < 0.45, "woken first, the lueur is at most brushed while rising")
        }
    }

    @Test("A is frozen: the definition validated by the human test of 416feb9 is byte for byte the same")
    func aIsFrozen() {
        let a = BraisesPrototype.a
        #expect(a.id == "0-1" && a.title == "braise" && a.principle == "Elle dort, froide. Votre regard la réveille.")
        #expect(a.introduces.isEmpty && !a.ordered && a.zone == 0.46 && a.repulsionForce == 2.4 && a.attraction == 0.5)
        #expect(a.noise == 0.15 && a.hold == 0.75)
        #expect(a.currents.isEmpty && a.veils.isEmpty && a.veilleuses.isEmpty)
        #expect(a.lueurs.count == 1)
        let lueur = a.lueurs[0]
        #expect(lueur.start == NormalizedPoint(x: 0.5, y: 0.74) && lueur.iris == NormalizedPoint(x: 0.5, y: 0.32))
        #expect(lueur.temperament == .normale && lueur.irisMotion == .fixed && lueur.route.isEmpty)
        let expectedBraise = BraiseDefinition(chargeRadius: 0.22, releaseRadius: 0.28, heatDuration: 0.9, coolDuration: 30,
                                              acceptHeat: 0.5, releaseHeat: 0.4, flareHeat: 0.85, flareAttention: 1.5, initialHeat: 0)
        #expect(lueur.braise == expectedBraise)
        #expect(BraiseDefinition.prototype == expectedBraise, "the shared tuning is the one the human validated")
        #expect(a.hints.map(\.trigger) == [.start, .braiseLit, .braiseFlared, .afterSeconds(30)])
        #expect(a.hints.map(\.text) == ["Elle est froide. Regardez-la.",
                                        "Elle s'allume et fuit. Laissez-la venir.",
                                        "Trop regardée, elle s'affole.",
                                        "Un regard bref suffit. Puis regardez ailleurs."])
        #expect(a.par == LevelPar(time: 14, intrusions: 4))
        let resolved = LevelResolver.resolve(a, in: bounds)
        #expect(resolved.environment.braises.count == 1 && resolved.environment.braises[0]?.chargeRadius == 0.22 * 393)
    }

    @Test("A, human-observed behaviour: a flaring braise is pushed by a gaze that a calm lit braise ignores")
    func flareReach() {
        /// Looks at the braise until it lights (calm), or until it is fully hot (flare at its strongest, zone x 1.5).
        func woken(until flare: Bool) -> GameSession {
            var sut = session(BraisesPrototype.a, gaze: Vector2(x: 40, y: 800))
            for _ in 0..<Int(2.5 * 60) {
                sut.placeGaze(at: sut.targets[0].position + Vector2(x: 0, y: 45))
                _ = sut.advance(by: frame)
                let braise = sut.braises[0]
                if flare ? (braise?.heat ?? 0) >= 0.99 : braise?.isLit == true { break }
            }
            return sut
        }
        func pushed(_ start: GameSession) -> Double {
            var sut = start
            let origin = sut.targets[0].position
            sut.placeGaze(at: origin + Vector2(x: 230, y: 0))
            for _ in 0..<Int(0.4 * 60) {
                sut.placeGaze(at: sut.gaze.position)
                _ = sut.advance(by: frame)
            }
            return origin.x - sut.targets[0].position.x
        }

        let calm = woken(until: false)
        let flaring = woken(until: true)
        #expect(calm.braises[0]?.isLit == true && calm.braises[0]?.isFlaring == false)
        #expect(flaring.braises[0]?.isFlaring == true)
        let calmPush = pushed(calm)
        let flarePush = pushed(flaring)
        #expect(abs(calmPush) < 4, "230 pt is beyond the 181 pt zone: a calm braise is not moved sideways")
        #expect(flarePush > 20, "flaring, the zone reaches 271 pt: the same distant gaze pushes it away")
    }

    @Test("hints, audio and haptics: lighting shows its hint and reuses the soft pulse; flaring and cooling are silent")
    func feedback() {
        var tracker = HintTracker(hints: BraisesPrototype.a.hints)
        tracker.begin()
        #expect(tracker.current == "Elle est froide. Regardez-la.")
        let litChanged = tracker.observe(events: [.braiseLit(sequence: 1)], elapsed: 2)
        #expect(litChanged)
        #expect(tracker.current == "Elle s'allume et fuit. Laissez-la venir.")
        let flaredChanged = tracker.observe(events: [.braiseFlared(sequence: 1)], elapsed: 3)
        #expect(flaredChanged)
        #expect(tracker.current == "Trop regardée, elle s'affole.")

        var audio = AudioCuePolicy()
        let litCues = audio.cues(for: [.braiseLit(sequence: 1)], at: 0)
        let silentCues = audio.cues(for: [.braiseFlared(sequence: 1), .braiseCooled(sequence: 1)], at: 5)
        #expect(litCues == [.veilleuseLow])
        #expect(silentCues.isEmpty)
        var haptics = HapticCuePolicy()
        let pulses = haptics.cues(for: [.braiseLit(sequence: 1), .braiseFlared(sequence: 1), .braiseCooled(sequence: 1)], at: 0)
        #expect(pulses.isEmpty)
    }

    @Test("the official campaign is untouched: six chapters, the same 34 ids in the same order, no braise, no chapter 0")
    func officialCampaignUntouched() {
        let expectedIDs = ["1-1", "1-2", "1-3", "1-4", "1-5",
                           "2-1", "2-2", "2-3", "2-4", "2-5",
                           "3-1", "3-2", "3-3", "3-4", "3-5", "3-6",
                           "4-1", "4-2", "4-3", "4-4", "4-5", "4-6",
                           "5-1", "5-2", "5-3", "5-4", "5-5", "5-6",
                           "6-1", "6-2", "6-3", "6-4", "6-5", "6-6"]
        #expect(Campaign.chapters.count == 6)
        #expect(Campaign.chapters.map(\.name) == ["éveil", "partage", "courants", "voiles", "veilleuses", "clairvoyance"])
        #expect(Campaign.levels.map(\.id) == expectedIDs)
        #expect(Campaign.levels.allSatisfy { !$0.hasBraises && !$0.isExperimental })
        #expect(Campaign.levels.allSatisfy { LevelResolver.resolve($0, in: bounds).environment.braises.isEmpty })
        #expect(BraisesPrototype.levels.map(\.id) == ["0-1", "0-2"])
        #expect(BraisesPrototype.levels.allSatisfy { $0.isExperimental && $0.hasBraises && Campaign.level(id: $0.id) == nil })
        #expect(BraisesPrototype.chapter.numeral == "P")
    }

    @Test("the coordinator never unlocks, records or counts a prototype; it still starts one on demand in DEBUG")
    @MainActor
    func coordinatorIsolation() {
        let store = InMemoryProgressStore()
        let sut = AppContainer.preview(progressStore: store).makeAppCoordinator()

        sut.play(BraisesPrototype.a)
        #expect(sut.route == .home, "the campaign path ignores a level that is not in the campaign")

        let record = sut.gameDidComplete(level: BraisesPrototype.a, outcome: LevelOutcome(time: 5, intrusions: 1, losses: 0))
        #expect(record == LevelRecord())
        #expect(sut.progress.records.isEmpty)
        #expect(store.load().records.isEmpty)
        #expect(sut.homeSummary.action == .begin && sut.homeSummary.eclats == 0)

        sut.playPrototype(BraisesPrototype.b)
        #expect(sut.route == .gazeSetup(.firstRun))
        sut.gazeSetupCompleted(intent: .firstRun)
        #expect(sut.route == .game)
        #expect(sut.gameViewModel?.level.id == "0-2")
        #expect(sut.gameViewModel?.chapter.numeral == "P")
        #expect(sut.progress.records.isEmpty)
    }

    @Test("a completed prototype offers the next prototype, then the chapters, never the campaign finale")
    @MainActor
    func resultFlow() {
        let gaze = SimulatedGazeTrackingService()
        let clock = ManualGameClock()
        let navigator = MockNavigator()
        let settings = GameSettingsStore(defaults: UserDefaults(suiteName: "iris.tests.braises.\(UUID().uuidString)") ?? .standard)
        let last = LevelDefinition(chapter: 0, index: 2, title: "test", principle: "p", zone: 0.46, noise: 0,
                                   lueurs: [LueurDefinition(start: NormalizedPoint(x: 0.62, y: 0.3), iris: NormalizedPoint(x: 0.62, y: 0.3),
                                                            braise: BraiseDefinition(initialHeat: 1))],
                                   par: LevelPar(time: 10, intrusions: 2))
        let sut = GameViewModel(level: last, gaze: gaze, audio: MockAudioService(), haptics: MockHapticFeedbackService(), clock: clock,
                                settings: settings, calibrationStore: InMemoryCalibrationStore(), orientation: FixedOrientationProvider(),
                                isPad: false, navigator: navigator)
        sut.prepare(width: 390, height: 844, displayScale: 3)
        gaze.inject(point: Vector2(x: 40, y: 800), timestamp: 0)
        sut.primaryAction()
        clock.tick(frames: 50)

        guard case let .levelComplete(result) = sut.phase else {
            Issue.record("expected result, got \(sut.phase)")
            return
        }
        #expect(!result.hasNextLevel && !result.isCampaignEnd && !result.isChapterEnd)
        #expect(result.primaryTitle == "Chapitres")
        sut.primaryAction()
        #expect(navigator.chaptersCount == 1)
        #expect(navigator.finishCampaignCount == 0)
    }
}
#endif
