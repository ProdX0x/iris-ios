// SoufflesTests.swift
// Layer: Tests
// Purpose: Chapter VIII, souffles: the gust's motion and presence, carrying and lifting over veils, spilling by the
// gaze, the chapter's structure and geometry, and the necessity proof by ablation (without gusts, the walls hold)

import Foundation
import Testing
@testable import Iris

@Suite("Chapter VIII souffles")
struct SoufflesTests {
    private let bounds = CampaignBot.referenceBounds
    private let frame = 1.0 / 60.0

    private var chapter: ChapterDefinition {
        guard let chapter = Campaign.chapter(number: 8) else { preconditionFailure("chapter VIII missing") }
        return chapter
    }

    /// One lueur above a full-width veil, its iris below, a gust crossing the veil at x = 0.5; no noise.
    private func wallLevel(start: NormalizedPoint = Campaign.pt(0.5, 0.35), souffles: Bool = true) -> LevelDefinition {
        LevelDefinition(chapter: 8, index: 99, title: "staged", principle: "", zone: 0.46, noise: 0,
                        lueurs: [LueurDefinition(start: start, iris: Campaign.pt(0.5, 0.82))],
                        veils: [VeilDefinition(a: Campaign.pt(0, 0.5), b: Campaign.pt(1, 0.5))],
                        souffles: souffles ? [SouffleDefinition(path: [Campaign.pt(0.5, 0.28), Campaign.pt(0.5, 0.72)], period: 7, duty: 0.7)] : [],
                        par: LevelPar(time: 10, intrusions: 1))
    }

    private func session(_ level: LevelDefinition, gaze: Vector2 = Vector2(x: 20, y: 830)) -> GameSession {
        let resolved = LevelResolver.resolve(level, in: bounds)
        var session = resolved.makeSession(noiseSources: level.lueurs.map { _ in SilentNoise() })
        session.placeGaze(at: gaze)
        return session
    }

    private func run(_ session: inout GameSession, seconds: Double) -> [GameEvent] {
        var events: [GameEvent] = []
        for _ in 0..<Int(seconds * 60) { events += session.advance(by: frame) }
        return events
    }

    @Test("the gust travels its track at constant speed during its duty share, fades at both ends, and is absent in between")
    func motion() {
        let field = SouffleField(path: [Vector2(x: 100, y: 100), Vector2(x: 100, y: 500)], period: 8, duty: 0.5, radius: 60, strength: 1.6, phase: 0)
        #expect(field.length == 400 && field.speed == 100)
        let start = field.state(at: 0)
        #expect(start?.position == Vector2(x: 100, y: 100) && start?.direction == Vector2(x: 0, y: 1) && start?.presence == 0)
        let middle = field.state(at: 2)
        #expect(middle?.position == Vector2(x: 100, y: 300) && middle?.presence == 1)
        let nearEnd = field.state(at: 3.99)?.position.y ?? 0
        #expect(nearEnd > 498)
        #expect(field.state(at: 4.5) == nil && field.state(at: 7.9) == nil, "absent during the pause")
        let nextGust = field.state(at: 8.4)?.position.y ?? 0
        #expect(abs(nextGust - 140) < 1e-9, "the next gust starts again at the head of the track")
        #expect(field.contains(Vector2(x: 130, y: 300), at: 2) && !field.contains(Vector2(x: 170, y: 300), at: 2))
        #expect(field.impulse(at: Vector2(x: 100, y: 300), time: 2) == Vector2(x: 0, y: 1.6))
        #expect(field.impulse(at: Vector2(x: 100, y: 300), time: 5) == .zero)
        let phased = SouffleField(path: [Vector2(x: 100, y: 100), Vector2(x: 100, y: 500)], period: 8, duty: 0.5, radius: 60, strength: 1.6, phase: 0.5)
        #expect(phased.state(at: 0) == nil && phased.state(at: 4)?.position == Vector2(x: 100, y: 100))
    }

    @Test("a lueur pinned against the wall on the track is picked up, lifted over the veil, dropped at the end of the track, and reaches its iris")
    func ferry() {
        var sut = session(wallLevel())
        let events = run(&sut, seconds: 14)
        #expect(events.contains(.lueurCarried(sequence: 1)))
        #expect(events.contains(.lueurDropped(sequence: 1)))
        #expect(events.contains(.targetValidated(sequence: 1)) && sut.isComplete, "carried over the wall then validated")
        let carriedIndex = events.firstIndex(of: .lueurCarried(sequence: 1)) ?? 0
        let validatedIndex = events.firstIndex(of: .targetValidated(sequence: 1)) ?? 0
        #expect(carriedIndex < validatedIndex)
    }

    @Test("ablation: without the gust the wall holds; with it the guided player crosses on every level of the chapter")
    func necessity() {
        var wall = session(wallLevel(souffles: false))
        let events = run(&wall, seconds: 20)
        #expect(!events.contains(.targetValidated(sequence: 1)) && !wall.isComplete)
        #expect(wall.targets[0].position.y < 0.5 * bounds.height, "still above the veil")

        for level in chapter.levels {
            // Left alone, no lueur ever drifts onto a track: the gust carries nothing without the player.
            var passive = LevelResolver.resolve(level, in: bounds).makeSession()
            passive.placeGaze(at: Vector2(x: -400, y: -400))
            var carried = false
            for _ in 0..<(40 * 60) where !carried {
                let events = passive.advance(by: frame)
                if events.contains(where: { if case .lueurCarried = $0 { return true } else { return false } }) { carried = true }
            }
            #expect(!carried, "\(level.id) a lueur was carried without the player")
            let ablated = LevelDefinition(chapter: level.chapter, index: level.index, title: level.title, principle: level.principle,
                                          introduces: level.introduces, ordered: level.ordered, zone: level.zone,
                                          repulsionForce: level.repulsionForce, attraction: level.attraction, noise: level.noise,
                                          hold: level.hold, lueurs: level.lueurs, currents: level.currents, veils: level.veils,
                                          veilleuses: level.veilleuses, souffles: [], hints: level.hints, par: level.par)
            let without = CampaignBot(definition: ablated, policy: .guided).run(maxSeconds: 60)
            #expect(!without.completed, "\(level.id) solvable without its gusts")
            let solved = CampaignMeasurements.of(level).guided.allSatisfy(\.completed)
            #expect(solved, "\(level.id) not solved with its gusts")
        }
    }

    @Test("a close gaze spills the carried lueur out of the gust, which goes on without it")
    func spill() {
        var sut = session(wallLevel())
        var carried = false
        for _ in 0..<(14 * 60) where !carried {
            let events = sut.advance(by: frame)
            if events.contains(.lueurCarried(sequence: 1)) { carried = true }
        }
        #expect(carried)
        // Look right beside the flying lueur: the repulsion pushes it out of the disc.
        var dropped: [GameEvent] = []
        for _ in 0..<60 {
            sut.placeGaze(at: sut.targets[0].position + Vector2(x: -40, y: 0))
            dropped += sut.advance(by: frame)
        }
        #expect(dropped.contains(.lueurDropped(sequence: 1)))
        #expect(!sut.isCarried(targetAt: 0))
    }

    @Test("carried, the lueur ignores the veils; dropped, it collides with them again")
    func lift() {
        let level = wallLevel()
        let resolved = LevelResolver.resolve(level, in: bounds)
        var sut = resolved.makeSession(noiseSources: [SilentNoise()])
        sut.placeGaze(at: Vector2(x: 20, y: 830))
        var targets = sut.targets
        targets[0].position = Vector2(x: 196.5, y: 420)
        targets[0].velocity = Vector2(x: 0, y: 2)
        sut.replaceTargets(targets)
        // The gust is at the head of its track at t = 0 and reaches the wall (y = 426) after (426 - 238.6) / speed seconds.
        let speed = resolved.environment.souffles[0].speed
        let arrival = (426 - 0.28 * bounds.height) / speed
        for _ in 0..<Int((arrival + 1.5) * 60) { _ = sut.advance(by: frame) }
        #expect(sut.targets[0].position.y > 426 + 30, "carried through the wall")
    }

    @Test("the hint tracker shows the carried hint on the first lift")
    func hint() {
        var tracker = HintTracker(hints: [LevelHint(.firstCarried, "vole")])
        let changed = tracker.observe(events: [.lueurCarried(sequence: 1)], elapsed: 2)
        #expect(changed && tracker.current == "vole")
    }

    @Test("structure: chapter VIII has six levels of gusts, every level needs a gust, tuning within the historical bounds")
    func structure() {
        #expect(Array(Campaign.expansionChapters.map(\.number).prefix(2)) == [7, 8])
        #expect(chapter.name == "souffles" && chapter.theme == .brume && chapter.numeral == "VIII")
        #expect(chapter.levels.map(\.id) == ["8-1", "8-2", "8-3", "8-4", "8-5", "8-6"])
        #expect(chapter.levels[0].introduces == [.souffle] && chapter.levels[0].lueurs.count == 1)
        for level in chapter.levels {
            #expect(!level.souffles.isEmpty && !level.veils.isEmpty && level.requiresPushing, "\(level.id)")
            #expect((1...3).contains(level.lueurs.count), "\(level.id)")
            #expect(level.hold == 0.75 && (0.40...0.52).contains(level.zone) && (1.6...3.2).contains(level.repulsionForce), "\(level.id)")
            #expect(level.elementKinds.count <= 3, "\(level.id)")
            for souffle in level.souffles {
                #expect((5...9).contains(souffle.period) && (0.5...0.85).contains(souffle.duty), "\(level.id)")
                #expect((0.12...0.22).contains(souffle.radius) && (1.2...2.0).contains(souffle.strength), "\(level.id)")
            }
        }
    }

    @Test("geometry: gusts are slower than a lueur, cross a veil, and keep clear of irises and postes")
    func geometry() {
        let shortSide = min(bounds.width, bounds.height)
        for level in chapter.levels {
            let resolved = LevelResolver.resolve(level, in: bounds)
            for (index, field) in resolved.environment.souffles.enumerated() {
                #expect(field.speed <= 0.85 * resolved.physics.maxSpeed * 60, "\(level.id) gust \(index) faster than a lueur")
                let crossesVeil = resolved.environment.veils.contains { veil in
                    (1..<field.path.count).contains { LevelAnalysis.intersects(field.path[$0 - 1], field.path[$0], veil.a, veil.b) }
                }
                #expect(crossesVeil, "\(level.id) gust \(index) crosses no veil")
                for lueur in level.lueurs {
                    let iris = lueur.iris.absolute(in: bounds)
                    let clearance = (1..<field.path.count).map { VeilSegment(a: field.path[$0 - 1], b: field.path[$0], halfThickness: 0).distance(to: iris) }.min() ?? .infinity
                    #expect(clearance >= field.radius + 0.06 * shortSide, "\(level.id) iris within reach of a gust track")
                }
                for point in field.path {
                    #expect((0.1...0.9).contains(point.x / bounds.width) && (0.08...0.92).contains(point.y / bounds.height), "\(level.id) track off the field")
                }
            }
        }
    }

    @Test("the snapshot exposes the gusts and the lift")
    func snapshot() {
        let level = chapter.levels[0]
        let resolved = LevelResolver.resolve(level, in: bounds)
        let session = resolved.makeSession()
        let snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, showsGaze: false, diagnostics: nil, theme: .brume)
        #expect(snapshot.souffles.count == 1 && snapshot.souffles[0].path.count == 2 && snapshot.souffles[0].position != nil)
        #expect(!snapshot.lueurs[0].isCarried)
    }
}
