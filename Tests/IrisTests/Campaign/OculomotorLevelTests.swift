// OculomotorLevelTests.swift
// Layer: Tests
// Purpose: PROTOTYPE chapter I level 6: the thread of balises (order, dwell, brevity, hysteresis, release of the latent
// lueur, inactive gaze), the spatial pattern it imposes, the ablation policies that must fail (central gaze, random
// gaze, brief passes, wrong order, horizontal only, vertical only), the scripted correct sequence that must win, the
// progression around an optional level, and the protection of levels 1 to 5 and of chapters II to XII

import Foundation
import Testing
@testable import Iris

@Suite("Chapter I level 6 oculomotor prototype")
struct OculomotorLevelTests {
    private let bounds = CampaignBot.referenceBounds
    private let frame = 1.0 / 60.0

    private var level: LevelDefinition { Campaign.oculomoteur }

    private func session(noise: Bool = false) -> GameSession {
        let resolved = LevelResolver.resolve(level, in: bounds)
        return resolved.makeSession(noiseSources: noise ? nil : level.lueurs.map { _ in SilentNoise() })
    }

    private func positions(_ session: GameSession) -> [Vector2] {
        session.balises?.positions ?? []
    }

    /// Holds the gaze exactly at `point` for `seconds`, collecting events.
    private func hold(_ session: inout GameSession, at point: Vector2, seconds: Double) -> [GameEvent] {
        var events: [GameEvent] = []
        for _ in 0..<Int((seconds * 60).rounded()) {
            session.placeGaze(at: point)
            events += session.advance(by: frame)
        }
        return events
    }

    // MARK: Structure and pattern

    @Test("chapter I is played with its five frozen levels then the optional sixth, reachable after level 5")
    func structure() {
        guard let chapter = Campaign.chapter(number: 1) else {
            Issue.record("chapter I missing")
            return
        }
        #expect(chapter.levels.count == 6 && chapter.levels.map(\.id) == ["1-1", "1-2", "1-3", "1-4", "1-5", "1-6"])
        #expect(Array(chapter.levels.prefix(5)) == Campaign.eveil.levels)
        #expect(Campaign.next(after: Campaign.eveil.levels[4])?.id == "1-6")
        #expect(Campaign.next(after: level)?.id == "2-1")
        #expect(Campaign.level(id: "1-6") == level)
        #expect(level.introduces == [.balise] && level.hasBalises && !level.gatesProgression)
        #expect(level.lueurs.count == 1 && !level.requiresPushing && level.hold == 0.75)
        #expect(Campaign.chapters.dropFirst().allSatisfy { !$0.levels.contains(where: \.hasBalises) }, "no balise outside chapter I")
    }

    @Test("the thread imposes centre, right, left, centre, up, down, centre, then right/left twice, up/down twice, centre")
    func pattern() throws {
        let thread = try #require(level.balises)
        let names = thread.steps.map { thread.balises[$0].name }
        #expect(names == ["CENTER", "RIGHT", "LEFT", "CENTER", "TOP", "BOTTOM", "CENTER",
                          "RIGHT", "LEFT", "RIGHT", "LEFT", "TOP", "BOTTOM", "TOP", "BOTTOM", "CENTER"])
        #expect((0.15...0.35).contains(thread.dwell), "an experimental dwell within 150 to 350 ms")
        for balise in thread.balises {
            #expect((0.15...0.85).contains(balise.position.x) && (0.12...0.88).contains(balise.position.y), "\(balise.name) within the comfort ranges")
        }
        let right = thread.balises[1].position.absolute(in: bounds)
        let left = thread.balises[2].position.absolute(in: bounds)
        let top = thread.balises[3].position.absolute(in: bounds)
        let bottom = thread.balises[4].position.absolute(in: bounds)
        #expect(right.x - left.x >= 0.6 * bounds.width && bottom.y - top.y >= 0.6 * bounds.height, "clearly separated targets")
        #expect(thread.radius * 393 >= 70, "zone wide enough for the tracker's error")
    }

    // MARK: Engine rules

    @Test("only the designated balise wakes, after a continuous dwell inside its zone; a brief pass does nothing")
    func dwellAndOrder() {
        var sut = session()
        let points = positions(sut)
        #expect(sut.balises?.activeBalise == 0 && sut.areLueursLatent)
        // Wrong balise (right while the centre is designated): nothing, for as long as you like.
        let wrong = hold(&sut, at: points[1], seconds: 2)
        #expect(!wrong.contains { if case .baliseLit = $0 { return true } else { return false } })
        #expect(sut.balises?.currentStep == 0)
        // Too brief on the right one.
        let brief = hold(&sut, at: points[0], seconds: 0.15)
        #expect(!brief.contains { if case .baliseLit = $0 { return true } else { return false } })
        _ = hold(&sut, at: Vector2(x: 40, y: 40), seconds: 0.5)
        // Long enough.
        let lit = hold(&sut, at: points[0], seconds: 0.4)
        #expect(lit.contains(.baliseLit(balise: 0, step: 0)))
        #expect(sut.balises?.currentStep == 1 && sut.balises?.activeBalise == 1)
        #expect(sut.areLueursLatent && !sut.isIrisOpen(for: sut.targets[0]))
    }

    @Test("hysteresis: a gaze that trembles just beyond the zone keeps its dwell; leaving beyond the release radius resets it")
    func hysteresis() {
        var sut = session()
        let centre = positions(sut)[0]
        let radius = sut.balises?.radius ?? 0
        let release = sut.balises?.releaseRadius ?? 0
        _ = hold(&sut, at: centre, seconds: 0.15)
        _ = hold(&sut, at: centre + Vector2(x: radius + 5, y: 0), seconds: 0.05)
        #expect(sut.balises?.isInside == true, "still inside between the radius and the release radius")
        let lit = hold(&sut, at: centre, seconds: 0.08)
        #expect(lit.contains(.baliseLit(balise: 0, step: 0)), "the dwell continued across the tremble")
        let right = positions(sut)[1]
        _ = hold(&sut, at: right, seconds: 0.15)
        _ = hold(&sut, at: right + Vector2(x: 0, y: release + 10), seconds: 0.05)
        #expect(sut.balises?.isInside == false && sut.balises?.dwellTime == 0, "gone beyond the release radius: reset")
    }

    @Test("an inactive gaze freezes the thread and never crashes; the latent lueur neither moves nor validates")
    func inactiveGaze() {
        var sut = session()
        let start = sut.targets[0].position
        var events: [GameEvent] = []
        for _ in 0..<(5 * 60) { events += sut.advance(by: frame) }
        #expect(sut.balises?.currentStep == 0 && sut.balises?.dwellTime == 0)
        #expect(sut.targets[0].position == start && !sut.isComplete)
        #expect(!events.contains { if case .baliseLit = $0 { return true } else { return false } })
        #expect(sut.metrics.intrusions == 0, "a latent lueur feels no intrusion")
    }

    @Test("the correct sequence completes the thread, opens the iris, releases the lueur, and the level ends by avoidance")
    func correctSequence() {
        var sut = session()
        let points = positions(sut)
        guard let thread = sut.balises else {
            Issue.record("no thread")
            return
        }
        var events: [GameEvent] = []
        for step in thread.steps {
            events += hold(&sut, at: points[step], seconds: 0.45)
        }
        #expect(events.contains(.balisesCompleted) && events.contains(.lueurReleased(sequence: 1)))
        #expect(sut.balises?.isComplete == true && !sut.areLueursLatent)
        #expect(sut.isIrisOpen(for: sut.targets[0]))
        let lit = events.filter { if case .baliseLit = $0 { return true } else { return false } }.count
        #expect(lit == thread.steps.count)
        events += hold(&sut, at: Vector2(x: 40, y: 830), seconds: 8)
        #expect(events.contains(.targetValidated(sequence: 1)) && sut.isComplete)
    }

    // MARK: Ablation policies

    private func run(_ gazeAt: (Int, GameSession, inout LinearCongruentialGenerator) -> Vector2, seconds: Double, seed: Int = 1) -> GameSession {
        var sut = session(noise: true)
        var generator = LinearCongruentialGenerator(seed: 99 + seed * 31)
        for frameIndex in 0..<Int(seconds * 60) {
            let point = gazeAt(frameIndex, sut, &generator)
            sut.ingestGaze(point)
            _ = sut.advance(by: frame)
            if sut.isComplete { break }
        }
        return sut
    }

    @Test("a permanent central gaze never wins: the thread stops at its second balise")
    func centralGaze() {
        let sut = run({ _, session, _ in session.balises?.positions[0] ?? .zero }, seconds: 90)
        #expect(!sut.isComplete && (sut.balises?.currentStep ?? 0) <= 1)
    }

    @Test("waiting never wins")
    func waiting() {
        let sut = run({ _, _, _ in Vector2(x: 40, y: 830) }, seconds: 90)
        #expect(!sut.isComplete && sut.balises?.currentStep == 0)
    }

    @Test("a random gaze, three seeds, never completes the thread within 90 s")
    func randomGaze() {
        for seed in 1...3 {
            let sut = run({ frameIndex, _, generator in
                if frameIndex % 6 == 0 {
                    return Vector2(x: generator.next() * bounds.width, y: generator.next() * bounds.height)
                }
                return Vector2(x: -1, y: -1)
            }, seconds: 90, seed: seed)
            #expect(!sut.isComplete, "seed \(seed) completed by chance")
            #expect((sut.balises?.currentStep ?? 0) < 8, "seed \(seed) went far by chance")
        }
    }

    @Test("brief passes over the designated balise (130 ms) never wake it")
    func briefPasses() {
        let sut = run({ frameIndex, session, _ in
            guard let thread = session.balises, let active = thread.activeBalise else { return Vector2(x: 40, y: 830) }
            return frameIndex % 30 < 8 ? thread.positions[active] : Vector2(x: 40, y: 830)
        }, seconds: 60)
        #expect(!sut.isComplete && sut.balises?.currentStep == 0)
    }

    @Test("horizontal alternation alone never wins (the up and down balises are required), nor vertical alone")
    func alternationsNecessary() {
        let horizontal = run({ frameIndex, session, _ in
            guard let thread = session.balises, let active = thread.activeBalise, [0, 1, 2].contains(active) else { return Vector2(x: 40, y: 830) }
            return thread.positions[active]
        }, seconds: 90)
        #expect(!horizontal.isComplete && horizontal.balises?.activeBalise == 3, "stuck at the top balise")
        let vertical = run({ frameIndex, session, _ in
            guard let thread = session.balises, let active = thread.activeBalise, [0, 3, 4].contains(active) else { return Vector2(x: 40, y: 830) }
            return thread.positions[active]
        }, seconds: 90)
        #expect(!vertical.isComplete && vertical.balises?.activeBalise == 1, "stuck at the right balise")
    }

    @Test("following the designated balise with the real gaze filter completes the thread in a reasonable time; the guided bot too, avoidance never")
    func scriptedWin() {
        let sut = run({ _, session, _ in
            guard let thread = session.balises, let active = thread.activeBalise else { return Vector2(x: 40, y: 830) }
            return thread.positions[active]
        }, seconds: 90)
        #expect(sut.isComplete && sut.elapsed < 40)
        let guided = (1...3).map { CampaignBot(definition: level, policy: .guided, seed: $0).run(maxSeconds: 90) }
        let solved = guided.allSatisfy(\.completed)
        #expect(solved, "guided \(guided.map(\.time))")
        #expect(!CampaignBot(definition: level, policy: .avoidance).run(maxSeconds: 60).completed)
        #expect(!CampaignBot(definition: level, policy: .offScreen).run(maxSeconds: 30).completed)
    }

    // MARK: Progression and protection

    @Test("level 6 unlocks after level 5; being optional it never holds chapter II, which still unlocks from level 5")
    func progression() {
        var progress = CampaignProgress()
        let campaign = Campaign.levels
        for id in ["1-1", "1-2", "1-3", "1-4"] {
            guard let done = Campaign.level(id: id) else { continue }
            progress.register(LevelOutcome(time: 10, intrusions: 1, losses: 0), for: done)
        }
        #expect(!progress.isUnlocked(level, in: campaign))
        guard let five = Campaign.level(id: "1-5"), let two = Campaign.level(id: "2-1") else { return }
        #expect(!progress.isUnlocked(two, in: campaign))
        progress.register(LevelOutcome(time: 10, intrusions: 1, losses: 0), for: five)
        #expect(progress.isUnlocked(level, in: campaign))
        #expect(progress.isUnlocked(two, in: campaign), "chapter II does not wait for the optional level")
        #expect(progress.nextLevel(in: campaign)?.id == "1-6")
        progress.register(LevelOutcome(time: 20, intrusions: 1, losses: 0), for: level)
        #expect(progress.nextLevel(in: campaign)?.id == "2-1")
    }

    @Test("levels 1 to 5, chapters II to XII and every frozen source are untouched")
    func protection() {
        #expect(Campaign.historicalChapters[0].levels.count == 5 && Campaign.historicalLevels.count == 34)
        #expect(Campaign.historicalLevels.allSatisfy { !$0.hasBalises && $0.gatesProgression })
        let expansionIDs = Campaign.expansionChapters.flatMap(\.levels).map(\.id)
        #expect(expansionIDs.count == 36 && expansionIDs.first == "7-1" && expansionIDs.last == "12-6")
        #expect(Campaign.levels.count == 71 && Campaign.chapters.count == 12)
        #expect(Campaign.chapters.dropFirst().map(\.levels) == Array(Campaign.historicalChapters.dropFirst().map(\.levels)) + Campaign.expansionChapters.map(\.levels))
    }

    @Test("feedback: a balise waking reuses the soft pulse, the thread completing the validation chime and pulse; nothing new")
    func feedback() {
        var audio = AudioCuePolicy()
        let lit = audio.cues(for: [.baliseLit(balise: 0, step: 0)], at: 1)
        #expect(lit == [.veilleuseLow])
        let done = audio.cues(for: [.balisesCompleted, .lueurReleased(sequence: 1)], at: 5)
        #expect(done == [.validation])
        var haptics = HapticCuePolicy()
        #expect(haptics.cues(for: [.baliseLit(balise: 0, step: 0)], at: 1).isEmpty)
        #expect(haptics.cues(for: [.balisesCompleted], at: 5) == [.validation])
    }
}
