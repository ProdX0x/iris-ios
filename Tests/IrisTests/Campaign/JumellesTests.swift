// JumellesTests.swift
// Layer: Tests
// Purpose: Chapter VII, jumelles: twin rules in the engine (reach hysteresis, mutual iris, poste, validation),
// the chapter's structure and geometry, and the proof that twins never meet without the player

import Foundation
import Testing
@testable import Iris

@Suite("Chapter VII jumelles")
struct JumellesTests {
    private let bounds = CampaignBot.referenceBounds
    private let frame = 1.0 / 60.0

    private var chapter: ChapterDefinition {
        guard let chapter = Campaign.chapter(number: 7) else { preconditionFailure("chapter VII missing") }
        return ChapterDefinition(number: chapter.number, name: chapter.name, principle: chapter.principle, ambientFrequency: chapter.ambientFrequency,
                                 theme: chapter.theme, levels: chapter.levels.filter(\.gatesProgression))
    }

    /// Two twins alone on an open field, no noise, gaze parked far away.
    private func twinSession(a: Vector2, b: Vector2, ordered: Bool = false) -> GameSession {
        let level = LevelDefinition(chapter: 7, index: 99, title: "staged", principle: "", ordered: ordered, zone: 0.46,
                                    lueurs: [LueurDefinition(start: Campaign.pt(0.2, 0.2), iris: Campaign.pt(0.3, 0.3), twin: 2),
                                             LueurDefinition(start: Campaign.pt(0.8, 0.8), iris: Campaign.pt(0.7, 0.7), twin: 1)],
                                    par: LevelPar(time: 10, intrusions: 1))
        let resolved = LevelResolver.resolve(level, in: bounds)
        var session = resolved.makeSession(noiseSources: [SilentNoise(), SilentNoise()])
        var targets = session.targets
        targets[0].position = a
        targets[1].position = b
        session.replaceTargets(targets)
        session.placeGaze(at: Vector2(x: 20, y: 830))
        return session
    }

    private func run(_ session: inout GameSession, seconds: Double) -> [GameEvent] {
        var events: [GameEvent] = []
        for _ in 0..<Int(seconds * 60) { events += session.advance(by: frame) }
        return events
    }

    @Test("resolution: twins are mutual, each waits at its poste, reach and release scale with the short side")
    func resolution() {
        let level = chapter.levels[0]
        let resolved = LevelResolver.resolve(level, in: bounds)
        #expect(resolved.environment.twins.count == 2)
        #expect(resolved.environment.twins[0]?.partner == 1 && resolved.environment.twins[1]?.partner == 0)
        #expect(resolved.environment.twins[0]?.poste == level.lueurs[0].iris.absolute(in: bounds))
        #expect(resolved.environment.twins[0]?.reach == LevelResolver.twinReach * 393)
        #expect(resolved.environment.twins[0]?.release == LevelResolver.twinRelease * 393)
        #expect(resolved.environment.twins[0]?.isLinked == false)
        #expect(level.hasTwins && level.elementKinds == [.jumelles] && level.requiresPushing)
    }

    @Test("out of reach, a twin drifts to its poste with a closed iris and never accumulates presence there")
    func poste() {
        var sut = twinSession(a: Vector2(x: 118, y: 256), b: Vector2(x: 275, y: 596))
        let events = run(&sut, seconds: 4)
        let poste = sut.twins[0]?.poste ?? .zero
        #expect(sut.targets[0].position.distance(to: poste) < 20, "drifted to its poste")
        #expect(sut.targets[0].arrival == poste)
        #expect(!sut.isIrisOpen(for: sut.targets[0]))
        #expect(sut.targets[0].holdTime == 0 && !sut.targets[0].isValidated)
        #expect(!events.contains { if case .twinsLinked = $0 { return true } else { return false } })
        #expect(!events.contains { if case .targetValidated = $0 { return true } else { return false } })
    }

    @Test("within reach the twins link once (event for the pair), each becomes the iris of the other, and they validate together")
    func rendezVous() {
        var sut = twinSession(a: Vector2(x: 160, y: 400), b: Vector2(x: 240, y: 430))
        let first = sut.advance(by: frame)
        #expect(first.contains(.twinsLinked(sequence: 1)))
        #expect(first.filter { if case .twinsLinked = $0 { return true } else { return false } }.count == 1, "one event per pair")
        #expect(sut.twins[0]?.isLinked == true && sut.twins[1]?.isLinked == true)
        #expect(sut.isIrisOpen(for: sut.targets[0]) && sut.isIrisOpen(for: sut.targets[1]))

        let events = run(&sut, seconds: 3)
        #expect(events.contains(.targetValidated(sequence: 1)) && events.contains(.targetValidated(sequence: 2)))
        #expect(events.contains(.levelCompleted))
        #expect(sut.targets[0].position.distance(to: sut.targets[1].position) < 16)
        #expect(!events.contains { if case .twinsParted = $0 { return true } else { return false } })
    }

    @Test("hysteresis: linked twins part only beyond the release distance, then wait at their postes again")
    func hysteresis() {
        var sut = twinSession(a: Vector2(x: 160, y: 400), b: Vector2(x: 240, y: 430))
        _ = sut.advance(by: frame)
        #expect(sut.twins[0]?.isLinked == true)

        var apart = sut.targets
        apart[0].position = Vector2(x: 150, y: 400)
        apart[1].position = Vector2(x: 255, y: 400)
        sut.replaceTargets(apart)
        let between = sut.advance(by: frame)
        #expect(sut.twins[0]?.isLinked == true, "105 pt is beyond reach (94) but within release (118)")
        #expect(!between.contains { if case .twinsParted = $0 { return true } else { return false } })

        var far = sut.targets
        far[0].position = Vector2(x: 120, y: 400)
        far[1].position = Vector2(x: 260, y: 400)
        sut.replaceTargets(far)
        let parted = sut.advance(by: frame)
        #expect(parted.contains(.twinsParted(sequence: 1)))
        #expect(sut.twins[0]?.isLinked == false && sut.twins[1]?.isLinked == false)
        #expect(sut.targets[0].arrival == sut.twins[0]?.poste)
        #expect(!sut.isIrisOpen(for: sut.targets[0]))
    }

    @Test("R-23 still applies: twins within reach do not accumulate presence while the gaze is off the screen")
    func offScreenTwins() {
        var sut = twinSession(a: Vector2(x: 190, y: 400), b: Vector2(x: 210, y: 405))
        sut.placeGaze(at: Vector2(x: 196, y: -300))
        let events = run(&sut, seconds: 3)
        #expect(!sut.targets[0].isValidated && !sut.targets[1].isValidated)
        #expect(!events.contains { if case .targetValidated = $0 { return true } else { return false } })
    }

    @Test("ordered levels: the twins validate one after the other, then the next rank; losing them cascades")
    func ordered() {
        var sut = twinSession(a: Vector2(x: 190, y: 400), b: Vector2(x: 210, y: 405), ordered: true)
        let events = run(&sut, seconds: 3)
        let validated = events.compactMap { event -> Int? in
            if case let .targetValidated(sequence) = event { return sequence }
            return nil
        }
        #expect(validated == [1, 2])
        #expect(sut.isComplete)
    }

    @Test("the hint tracker shows the twins hint when they first come within reach")
    func hint() {
        var tracker = HintTracker(hints: [LevelHint(.twinsLinked, "vues")])
        let changed = tracker.observe(events: [.twinsLinked(sequence: 1)], elapsed: 2)
        #expect(changed && tracker.current == "vues")
    }

    @Test("structure: chapter VII opens the expansion with six levels of twins, at most three lueurs, historical tuning bounds")
    func structure() {
        #expect(Campaign.expansionChapters.first?.number == 7)
        #expect(chapter.name == "jumelles" && chapter.theme == .jumelles && chapter.numeral == "VII" && !chapter.isHistorical)
        #expect(chapter.levels.count == 6)
        #expect(chapter.levels.map(\.id) == ["7-1", "7-2", "7-3", "7-4", "7-5", "7-6"])
        #expect(chapter.levels[0].introduces == [.jumelles] && chapter.levels[0].lueurs.count == 2 && chapter.levels[0].elementKinds == [.jumelles])
        #expect(Campaign.next(after: Campaign.chapter(number: 6)?.levels.last ?? Campaign.historicalLevels[33])?.id == "7-1")
        for level in chapter.levels {
            #expect(level.hasTwins && level.requiresPushing, "\(level.id)")
            #expect((2...3).contains(level.lueurs.count), "\(level.id)")
            #expect(level.hold == 0.75 && (0.40...0.52).contains(level.zone) && (1.6...3.2).contains(level.repulsionForce), "\(level.id)")
            #expect(level.elementKinds.count <= 2, "\(level.id)")
            #expect(!level.hasBraises && level.lueurs.allSatisfy { !$0.irisMotion.isMoving }, "\(level.id)")
            for (index, lueur) in level.lueurs.enumerated() {
                guard let twin = lueur.twin else { continue }
                #expect((1...level.lueurs.count).contains(twin) && twin != index + 1, "\(level.id) twin out of range")
                #expect(level.lueurs[twin - 1].twin == index + 1, "\(level.id) twin not mutual")
            }
        }
    }

    @Test("geometry: postes and starts of a pair are far beyond reach, twins wait in the field, routes end within reach of the partner's poste")
    func geometry() {
        let shortSide = min(bounds.width, bounds.height)
        for level in chapter.levels {
            for (index, lueur) in level.lueurs.enumerated() {
                guard let twin = lueur.twin else { continue }
                let partner = level.lueurs[twin - 1]
                let postes = lueur.iris.absolute(in: bounds).distance(to: partner.iris.absolute(in: bounds))
                let starts = lueur.start.absolute(in: bounds).distance(to: partner.start.absolute(in: bounds))
                #expect(postes >= shortSide * 0.45, "\(level.id) postes within reach")
                #expect(starts >= shortSide * 0.40, "\(level.id) starts within reach")
                #expect((0.15...0.85).contains(lueur.iris.x) && (0.12...0.88).contains(lueur.iris.y), "\(level.id) poste near the edge")
                if let last = lueur.route.last {
                    let remaining = last.absolute(in: bounds).distance(to: partner.iris.absolute(in: bounds))
                    #expect(remaining <= LevelResolver.twinReach * shortSide, "\(level.id) lueur \(index + 1) route ends out of reach (\(remaining) pt)")
                }
            }
        }
    }

    @Test("necessity: without any push the twins settle at their postes and never see each other, on every level of the chapter")
    func necessity() {
        for level in chapter.levels {
            let resolved = LevelResolver.resolve(level, in: bounds)
            var session = resolved.makeSession()
            session.placeGaze(at: Vector2(x: -400, y: -400))
            var linked = false
            for _ in 0..<(25 * 60) {
                let events = session.advance(by: frame)
                if events.contains(where: { if case .twinsLinked = $0 { return true } else { return false } }) { linked = true }
            }
            #expect(!linked, "\(level.id) twins met without the player")
            #expect(!session.isComplete, "\(level.id)")
            #expect(CampaignMeasurements.of(level).avoidance.completed == false, "\(level.id) solvable by avoidance")
        }
    }

    @Test("the snapshot exposes postes, partners, links and pairs for twins only")
    func snapshot() {
        let level = chapter.levels[2]
        let resolved = LevelResolver.resolve(level, in: bounds)
        let session = resolved.makeSession()
        let snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: true, marker: .hidden, diagnostics: nil, theme: .jumelles)
        #expect(snapshot.theme == .jumelles)
        #expect(snapshot.lueurs[0].isTwin && snapshot.lueurs[1].isTwin && !snapshot.lueurs[2].isTwin)
        #expect(snapshot.lueurs[0].partner == session.targets[1].position)
        #expect(snapshot.lueurs[2].poste == nil && snapshot.lueurs[2].partner == nil)
        #expect(snapshot.pairs.count == 1 && snapshot.pairs[0].sequence == 1 && !snapshot.pairs[0].isLinked)
        #expect(snapshot.routes.count == 1 && snapshot.routes[0].last == session.targets[1].position)
    }
}
