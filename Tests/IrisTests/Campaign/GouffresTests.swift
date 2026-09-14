// GouffresTests.swift
// Layer: Tests
// Purpose: Chapter X, gouffres: the pull, the swallow (held, then sent back to the start), the loss of a validated lueur,
// the chapter's structure and geometry, and the proof that the straight line never works while the detour does

import Foundation
import Testing
@testable import Iris

@Suite("Chapter X gouffres")
struct GouffresTests {
    private let bounds = CampaignBot.referenceBounds
    private let frame = 1.0 / 60.0

    private var chapter: ChapterDefinition {
        guard let chapter = Campaign.chapter(number: 10) else { preconditionFailure("chapter X missing") }
        return ChapterDefinition(number: chapter.number, name: chapter.name, principle: chapter.principle, ambientFrequency: chapter.ambientFrequency,
                                 theme: chapter.theme, levels: chapter.levels.filter(\.gatesProgression))
    }

    /// One lueur above a well, its iris below it, no noise: left alone it drifts straight into the mouth.
    private func wellLevel(gouffres: Bool = true) -> LevelDefinition {
        LevelDefinition(chapter: 10, index: 99, title: "staged", principle: "", zone: 0.46, noise: 0,
                        lueurs: [LueurDefinition(start: Campaign.pt(0.5, 0.2), iris: Campaign.pt(0.5, 0.8))],
                        gouffres: gouffres ? [GouffreDefinition(center: Campaign.pt(0.5, 0.5))] : [],
                        par: LevelPar(time: 10, intrusions: 1))
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

    @Test("the pull is nothing beyond its radius, full at the mouth, toward the centre")
    func pull() {
        let well = GouffreField(center: Vector2(x: 200, y: 400), radius: 35, pullRadius: 79, strength: 0.9)
        #expect(well.impulse(at: Vector2(x: 200, y: 300)) == .zero)
        let near = well.impulse(at: Vector2(x: 200, y: 340))
        #expect(near.x == 0 && near.y > 0 && near.y < 0.9, "pulled down toward the centre, part strength")
        let mouth = well.impulse(at: Vector2(x: 200 + 35, y: 400))
        #expect(abs(mouth.x + 0.9) < 1e-9 && abs(mouth.y) < 1e-9)
        #expect(well.swallows(Vector2(x: 210, y: 400)) && !well.swallows(Vector2(x: 240, y: 400)))
    }

    @Test("a lueur drifting into the mouth is swallowed, held at the centre with a closed iris, then sent back to its start after 0.7 s")
    func swallow() {
        var sut = session(wellLevel())
        var swallowedAt: TimeInterval?
        var returnedAt: TimeInterval?
        for _ in 0..<(6 * 60) {
            let events = sut.advance(by: frame)
            if events.contains(.lueurSwallowed(sequence: 1)), swallowedAt == nil {
                swallowedAt = sut.elapsed
                #expect(sut.isSwallowed(targetAt: 0) && sut.targets[0].position == sut.gouffres[0].center)
                #expect(!sut.isIrisOpen(for: sut.targets[0]))
            }
            if events.contains(.lueurReturned(sequence: 1)), returnedAt == nil {
                returnedAt = sut.elapsed
                #expect(sut.targets[0].position == Campaign.pt(0.5, 0.2).absolute(in: bounds))
                #expect(sut.targets[0].velocity == .zero)
            }
        }
        #expect(swallowedAt != nil && returnedAt != nil)
        if let swallowedAt, let returnedAt {
            #expect(abs((returnedAt - swallowedAt) - SwallowState.duration) < 0.05)
        }
        #expect(!sut.isComplete, "it drifts back into the well forever")
    }

    @Test("a validated lueur pushed into a well loses its place and comes back to its start")
    func validatedLoss() {
        // A second lueur walled off from its iris keeps the level from completing once the first one is validated.
        let level = LevelDefinition(chapter: 10, index: 98, title: "staged2", principle: "", zone: 0.46, noise: 0,
                                    lueurs: [LueurDefinition(start: Campaign.pt(0.5, 0.2), iris: Campaign.pt(0.5, 0.36)),
                                             LueurDefinition(start: Campaign.pt(0.85, 0.92), iris: Campaign.pt(0.85, 0.7))],
                                    veils: [VeilDefinition(a: Campaign.pt(0.6, 0.8), b: Campaign.pt(0.98, 0.8))],
                                    gouffres: [GouffreDefinition(center: Campaign.pt(0.5, 0.6))],
                                    par: LevelPar(time: 10, intrusions: 1))
        var sut = session(level)
        let settled = run(&sut, seconds: 4)
        #expect(settled.contains(.targetValidated(sequence: 1)) && !sut.isComplete)
        sut.placeGaze(at: sut.targets[0].position + Vector2(x: 0, y: -50))
        var events: [GameEvent] = []
        for _ in 0..<(4 * 60) {
            if !sut.isSwallowed(targetAt: 0) { sut.placeGaze(at: sut.targets[0].position + Vector2(x: 0, y: -50)) }
            events += sut.advance(by: frame)
        }
        // Pushed out of its iris first (drift), or straight into the mouth (gouffre): a loss either way.
        let lost = events.contains { if case .targetLost(1, _) = $0 { return true } else { return false } }
        #expect(lost)
        #expect(events.contains(.lueurSwallowed(sequence: 1)) && events.contains(.lueurReturned(sequence: 1)))
        #expect(sut.metrics.losses >= 1)
    }

    @Test("the straight line never works: blind to the routes the player is swallowed forever; the detour succeeds; without wells the straight line succeeds")
    func necessity() {
        for level in chapter.levels {
            // Where a current carries the lueur into the well, the straight push and the detour coincide (both leave the
            // band early); the proof there is the avoidance failure of the generic necessity test.
            if level.currents.isEmpty {
                let straight = CampaignBot(definition: level, policy: .straight).run(maxSeconds: 60)
                #expect(!straight.completed, "\(level.id) solved straight")
            }
            let solved = CampaignMeasurements.of(level).guided.allSatisfy(\.completed)
            #expect(solved, "\(level.id) not solved by the detour")
            let ablated = LevelDefinition(chapter: level.chapter, index: level.index, title: level.title, principle: level.principle,
                                          introduces: level.introduces, ordered: level.ordered, zone: level.zone,
                                          repulsionForce: level.repulsionForce, attraction: level.attraction, noise: level.noise,
                                          hold: level.hold, lueurs: level.lueurs, currents: level.currents, veils: level.veils,
                                          veilleuses: level.veilleuses, souffles: level.souffles, echo: level.echo, gouffres: [],
                                          hints: level.hints, par: level.par)
            let without = CampaignBot(definition: ablated, policy: .straight).run(maxSeconds: 60)
            #expect(without.completed, "\(level.id) without its wells the straight line should work")
        }
    }

    @Test("the hint tracker shows the swallow hint on the first swallow")
    func hint() {
        var tracker = HintTracker(hints: [LevelHint(.firstSwallow, "avalée")])
        let changed = tracker.observe(events: [.lueurSwallowed(sequence: 1)], elapsed: 2)
        #expect(changed && tracker.current == "avalée")
    }

    @Test("structure: chapter X has six levels with wells, every level routed, tuning within bounds")
    func structure() {
        #expect(Array(Campaign.expansionChapters.map(\.number).prefix(4)) == [7, 8, 9, 10])
        #expect(chapter.name == "gouffres" && chapter.theme == .gouffres && chapter.numeral == "X")
        #expect(chapter.levels.map(\.id) == ["10-1", "10-2", "10-3", "10-4", "10-5", "10-6"])
        #expect(chapter.levels[0].introduces == [.gouffre] && chapter.levels[0].lueurs.count == 1)
        for level in chapter.levels {
            #expect(!level.gouffres.isEmpty && level.requiresPushing, "\(level.id)")
            #expect((1...3).contains(level.lueurs.count) && level.gouffres.count <= 2, "\(level.id)")
            #expect(level.hold == 0.75 && (0.40...0.52).contains(level.zone) && (1.6...3.2).contains(level.repulsionForce), "\(level.id)")
            #expect(level.elementKinds.count <= 3, "\(level.id)")
            for well in level.gouffres {
                #expect((0.06...0.14).contains(well.radius) && (0.15...0.25).contains(well.pull) && (0.5...1.2).contains(well.strength), "\(level.id)")
            }
        }
    }

    @Test("geometry: wells sit inside the field, clear of every iris, start and waypoint, and the straight path of some lueur crosses a pull")
    func geometry() {
        let shortSide = min(bounds.width, bounds.height)
        for level in chapter.levels {
            let resolved = LevelResolver.resolve(level, in: bounds)
            var someStraightPathThreatened = false
            for well in resolved.environment.gouffres {
                #expect(well.center.x - well.pullRadius >= 0 && well.center.x + well.pullRadius <= bounds.width, "\(level.id) well off the field")
                #expect(well.center.y - well.pullRadius >= 0 && well.center.y + well.pullRadius <= bounds.height, "\(level.id) well off the field")
                for lueur in level.lueurs {
                    let clearance = well.pullRadius + 0.04 * shortSide
                    #expect(lueur.iris.absolute(in: bounds).distance(to: well.center) >= clearance, "\(level.id) iris within a pull")
                    #expect(lueur.start.absolute(in: bounds).distance(to: well.center) >= clearance, "\(level.id) start within a pull")
                    for point in lueur.route {
                        #expect(point.absolute(in: bounds).distance(to: well.center) >= well.pullRadius, "\(level.id) waypoint within a pull")
                    }
                    let segment = VeilSegment(a: lueur.start.absolute(in: bounds), b: lueur.iris.absolute(in: bounds), halfThickness: 0)
                    if segment.distance(to: well.center) < well.pullRadius { someStraightPathThreatened = true }
                }
            }
            #expect(someStraightPathThreatened, "\(level.id) no straight path meets a well")
        }
    }

    @Test("the snapshot exposes wells, the swallow and the rebirth")
    func snapshot() {
        let level = wellLevel()
        let resolved = LevelResolver.resolve(level, in: bounds)
        var session = resolved.makeSession(noiseSources: [SilentNoise()])
        session.placeGaze(at: Vector2(x: 20, y: 830))
        var swallowSeen = false
        var rebirthSeen = false
        for _ in 0..<(6 * 60) {
            _ = session.advance(by: frame)
            let snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, showsGaze: false, diagnostics: nil, theme: .gouffres)
            #expect(snapshot.gouffres.count == 1)
            if snapshot.lueurs[0].swallow != nil { swallowSeen = true }
            if snapshot.lueurs[0].rebirth != nil { rebirthSeen = true }
        }
        #expect(swallowSeen && rebirthSeen)
    }
}
