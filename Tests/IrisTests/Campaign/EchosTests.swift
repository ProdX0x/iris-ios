// EchosTests.swift
// Layer: Tests
// Purpose: Chapter IX, échos: sleepers stay still with a closed iris, the ring of a closing iris wakes and launches them
// within reach, a closed iris keeps breathing, the chapter's structure, and the ablation proof (silent irises never wake)

import Foundation
import Testing
@testable import Iris

@Suite("Chapter IX échos")
struct EchosTests {
    private let bounds = CampaignBot.referenceBounds
    private let frame = 1.0 / 60.0

    private var chapter: ChapterDefinition {
        guard let chapter = Campaign.chapter(number: 9) else { preconditionFailure("chapter IX missing") }
        return ChapterDefinition(number: chapter.number, name: chapter.name, principle: chapter.principle, ambientFrequency: chapter.ambientFrequency,
                                 theme: chapter.theme, levels: chapter.levels.filter(\.gatesProgression))
    }

    /// An awake lueur resting on its iris and a sleeper `apart` points away from that iris; no noise.
    private func staged(apart: Double, echo: EchoDefinition? = .standard) -> LevelDefinition {
        LevelDefinition(chapter: 9, index: 99, title: "staged", principle: "", zone: 0.46, noise: 0,
                        lueurs: [LueurDefinition(start: Campaign.pt(0.5, 0.2), iris: Campaign.pt(0.5, 0.42)),
                                 LueurDefinition(start: Campaign.pt(0.5, 0.42 + apart / bounds.height), iris: Campaign.pt(0.5, 0.9), asleep: true)],
                        echo: echo, par: LevelPar(time: 10, intrusions: 1))
    }

    private func session(_ level: LevelDefinition) -> GameSession {
        let resolved = LevelResolver.resolve(level, in: bounds)
        var session = resolved.makeSession(noiseSources: level.lueurs.map { _ in SilentNoise() })
        session.placeGaze(at: Vector2(x: 20, y: 830))
        return session
    }

    private func run(_ session: inout GameSession, seconds: Double) -> [GameEvent] {
        var events: [GameEvent] = []
        for _ in 0..<Int(seconds * 60) { events += session.advance(by: frame) }
        return events
    }

    @Test("asleep: no drift, no jitter, a closed iris; the closing of the first iris emits a ring that wakes and launches it")
    func wake() {
        var sut = session(staged(apart: 120))
        let start = sut.targets[1].position
        var events: [GameEvent] = []
        var wokenAt: TimeInterval?
        var closedAt: TimeInterval?
        for _ in 0..<(8 * 60) {
            let tick = sut.advance(by: frame)
            events += tick
            if tick.contains(.targetValidated(sequence: 1)) { closedAt = sut.elapsed }
            if tick.contains(.lueurWoken(sequence: 2)), wokenAt == nil {
                wokenAt = sut.elapsed
                #expect(sut.targets[1].position.distance(to: start) < 5, "asleep it never moved (only the launch of this very tick)")
            }
        }
        #expect(sut.isAsleep(targetAt: 1) == false)
        #expect(events.contains(.echoEmitted(sequence: 1)) && events.contains(.lueurWoken(sequence: 2)))
        if let closedAt, let wokenAt {
            let expected = 120 / (0.9 * 393)
            #expect(abs((wokenAt - closedAt) - expected) < 0.1, "the ring travels at 0.9 short side per second")
        } else {
            Issue.record("no closing or no waking")
        }
        #expect(sut.targets[1].position.y > start.y + 40, "launched away from the iris, toward its own")
        #expect(events.contains(.targetValidated(sequence: 2)) && sut.isComplete)
    }

    @Test("out of reach the ring passes without waking; a closed iris breathes every four seconds so that a sleeper brought near wakes later")
    func reachAndBreathing() {
        var sut = session(staged(apart: 260))
        let events = run(&sut, seconds: 7.5)
        #expect(events.contains(.targetValidated(sequence: 1)))
        #expect(!events.contains(.lueurWoken(sequence: 2)), "260 pt is beyond the reach (177 pt)")
        #expect(sut.isAsleep(targetAt: 1))
        let breaths = events.filter { $0 == .echoEmitted(sequence: 1) }.count
        #expect(breaths >= 2, "closing plus at least one breath in seven seconds")

        var moved = sut.targets
        moved[1].position = sut.targets[0].arrival + Vector2(x: 0, y: 100)
        sut.replaceTargets(moved)
        let later = run(&sut, seconds: 5)
        #expect(later.contains(.lueurWoken(sequence: 2)), "the next breath wakes it")
    }

    @Test("a sleeper is still repelled by the gaze, and cannot accumulate presence even on its iris")
    func sleeperAndGaze() {
        var level = staged(apart: 260)
        level = LevelDefinition(chapter: 9, index: 98, title: "staged2", principle: "", zone: 0.46, noise: 0,
                                lueurs: [LueurDefinition(start: Campaign.pt(0.2, 0.2), iris: Campaign.pt(0.2, 0.9)),
                                         LueurDefinition(start: Campaign.pt(0.7, 0.5), iris: Campaign.pt(0.7, 0.5), asleep: true)],
                                echo: .standard, par: level.par)
        var sut = session(level)
        _ = run(&sut, seconds: 2)
        #expect(sut.targets[1].holdTime == 0 && !sut.targets[1].isValidated, "asleep on its own iris, nothing accumulates")
        let before = sut.targets[1].position
        sut.placeGaze(at: before + Vector2(x: -60, y: 0))
        _ = run(&sut, seconds: 0.5)
        #expect(sut.targets[1].position.x > before.x + 20, "pushed away by the gaze while asleep")
    }

    @Test("ablation: with silent irises the sleeper never wakes and the level cannot be completed; with echoes every level is solved")
    func necessity() {
        var silent = session(staged(apart: 120, echo: nil))
        let events = run(&silent, seconds: 20)
        #expect(events.contains(.targetValidated(sequence: 1)) && !events.contains(.lueurWoken(sequence: 2)))
        #expect(!silent.isComplete)

        for level in chapter.levels {
            let ablated = LevelDefinition(chapter: level.chapter, index: level.index, title: level.title, principle: level.principle,
                                          introduces: level.introduces, ordered: level.ordered, zone: level.zone,
                                          repulsionForce: level.repulsionForce, attraction: level.attraction, noise: level.noise,
                                          hold: level.hold, lueurs: level.lueurs, currents: level.currents, veils: level.veils,
                                          veilleuses: level.veilleuses, souffles: level.souffles, echo: nil, hints: level.hints, par: level.par)
            let without = CampaignBot(definition: ablated, policy: .guided).run(maxSeconds: 60)
            #expect(!without.completed, "\(level.id) solvable with silent irises")
            let solved = CampaignMeasurements.of(level).guided.allSatisfy(\.completed)
            #expect(solved, "\(level.id) not solved with echoes")
        }
    }

    @Test("the hint tracker shows the wake hint on the first wake")
    func hint() {
        var tracker = HintTracker(hints: [LevelHint(.firstWake, "réveil")])
        let changed = tracker.observe(events: [.lueurWoken(sequence: 2)], elapsed: 2)
        #expect(changed && tracker.current == "réveil")
    }

    @Test("structure: chapter IX has six levels with echoes, at least one awake lueur and one sleeper each, tuning within bounds")
    func structure() {
        #expect(Array(Campaign.expansionChapters.map(\.number).prefix(3)) == [7, 8, 9])
        #expect(chapter.name == "échos" && chapter.theme == .echo && chapter.numeral == "IX")
        #expect(chapter.levels.map(\.id) == ["9-1", "9-2", "9-3", "9-4", "9-5", "9-6"])
        #expect(chapter.levels[0].introduces == [.dormeuse, .echo])
        for level in chapter.levels {
            #expect(level.echo != nil && level.hasSleepers, "\(level.id)")
            #expect(level.lueurs.contains { !$0.asleep }, "\(level.id) nobody awake")
            #expect((2...3).contains(level.lueurs.count), "\(level.id)")
            #expect(level.hold == 0.75 && (0.40...0.52).contains(level.zone) && (1.6...3.2).contains(level.repulsionForce), "\(level.id)")
            #expect(level.elementKinds.count <= 4, "\(level.id)")
            #expect(level.lueurs.allSatisfy { !$0.isTwin && $0.braise == nil }, "\(level.id)")
        }
    }

    @Test("geometry: in every level each sleeper can be woken by a chain of echoes, and the first sleeper of the discovery level lies within reach")
    func geometry() {
        for level in chapter.levels {
            let resolved = LevelResolver.resolve(level, in: bounds)
            guard let echo = resolved.environment.echo else { continue }
            // A sleeper wakes when brought within reach of an awake lueur's iris; an awake iris is any that is not a sleeper's
            // own until that sleeper is woken. Check the chain from the initially awake irises.
            var awake = Set(level.lueurs.indices.filter { !level.lueurs[$0].asleep })
            var changed = true
            while changed {
                changed = false
                for index in level.lueurs.indices where !awake.contains(index) {
                    let iris = level.lueurs[index].iris.absolute(in: bounds)
                    let reachable = awake.contains { source in
                        // The sleeper can be pushed anywhere on the field: it is wakeable if any awake iris is reachable, which is always;
                        // what must hold is that the chain has a source at all.
                        level.lueurs[source].iris.absolute(in: bounds).distance(to: iris) < 4 * echo.radius
                    }
                    if reachable {
                        awake.insert(index)
                        changed = true
                    }
                }
            }
            #expect(awake.count == level.lueurs.count, "\(level.id) a sleeper has no echo to wake it")
        }
        let first = chapter.levels[0]
        let sleeper = first.lueurs[1].start.absolute(in: bounds)
        let source = first.lueurs[0].iris.absolute(in: bounds)
        #expect(sleeper.distance(to: source) < LevelResolver.resolve(first, in: bounds).environment.echo?.radius ?? 0, "9-1 wakes without a push")
    }

    @Test("the snapshot exposes sleepers, echo sources, reach and rings")
    func snapshot() {
        let level = chapter.levels[0]
        let resolved = LevelResolver.resolve(level, in: bounds)
        var session = resolved.makeSession()
        session.placeGaze(at: Vector2(x: 20, y: 830))
        _ = run(&session, seconds: 4)
        let snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, marker: .hidden, diagnostics: nil, theme: .echo)
        #expect(snapshot.echoReach == 0.45 * 393)
        #expect(snapshot.lueurs[0].echoes && !snapshot.lueurs[0].isAsleep)
        #expect(!snapshot.waves.isEmpty || !snapshot.lueurs[1].isAsleep)
    }
}
