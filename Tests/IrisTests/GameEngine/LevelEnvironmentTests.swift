// LevelEnvironmentTests.swift
// Layer: Tests
// Purpose: R-23 to R-28: attention on field, currents, veils, veilleuses, gliding irises, temperaments, metrics

import Foundation
import Testing
@testable import Iris

@Suite("LevelEnvironment")
struct LevelEnvironmentTests {
    private let bounds = PlayfieldBounds(width: 393, height: 852)
    private let frame = 1.0 / 60.0

    private func definition(lueurs: [LueurDefinition], ordered: Bool = false, currents: [CurrentDefinition] = [],
                            veils: [VeilDefinition] = [], veilleuses: [VeilleuseDefinition] = [], zone: Double = 0.48) -> LevelDefinition {
        LevelDefinition(chapter: 9, index: 1, title: "test", principle: "test", ordered: ordered, zone: zone, noise: 0,
                        lueurs: lueurs, currents: currents, veils: veils, veilleuses: veilleuses, par: LevelPar(time: 30, intrusions: 3))
    }

    private func session(_ definition: LevelDefinition, gaze: Vector2? = Vector2(x: 196, y: 60)) -> GameSession {
        let resolved = LevelResolver.resolve(definition, in: bounds)
        var session = resolved.makeSession(noiseSources: definition.lueurs.map { _ in SilentNoise() })
        if let gaze { session.placeGaze(at: gaze) }
        return session
    }

    private func run(_ session: inout GameSession, seconds: Double) -> [GameEvent] {
        var events: [GameEvent] = []
        for _ in 0..<Int(seconds * 60) { events += session.advance(by: frame) }
        return events
    }

    private func point(_ x: Double, _ y: Double) -> NormalizedPoint { NormalizedPoint(x: x, y: y) }

    @Test("resolver scales zone, forces and radii with the short side")
    func resolverScale() {
        let level = definition(lueurs: [LueurDefinition(start: point(0.5, 0.8), iris: point(0.5, 0.3), temperament: .vive)], zone: 0.5)
        let phone = LevelResolver.resolve(level, in: bounds)
        let pad = LevelResolver.resolve(level, in: PlayfieldBounds(width: 786, height: 1100))

        #expect(phone.scale == 1)
        #expect(abs(pad.scale - 2) < 1e-12)
        #expect(abs(phone.level.targets[0].attentionZone - 196.5) < 1e-9)
        #expect(abs(pad.level.targets[0].attentionZone - 393) < 1e-9)
        #expect(abs(phone.level.targets[0].repulsionGain * 196.5 - 2.4 * 1.45) < 1e-9, "force at contact = 2.4 x vive")
        #expect(abs(pad.physics.maxSpeed - 4.4) < 1e-12)
        #expect(abs(phone.environment.lueurRadii[0] - 16) < 1e-9)
        #expect(phone.environment.requiresAttentionOnField)
        #expect(abs(phone.validation.settleRadius - 16) < 1e-12)
    }

    @Test("R-23 a gaze off the screen freezes presence and prevents validation; back on screen it resumes")
    func attentionOnField() {
        let level = definition(lueurs: [LueurDefinition(start: point(0.5, 0.52), iris: point(0.5, 0.5))])
        var onScreen = session(level)
        var offScreen = session(level, gaze: Vector2(x: 196, y: -200))

        let onEvents = run(&onScreen, seconds: 1.5)
        let offEvents = run(&offScreen, seconds: 3)

        #expect(onEvents.contains(.levelCompleted))
        #expect(!offEvents.contains(.levelCompleted))
        #expect(offEvents.contains(.attentionLeftField))
        #expect(offScreen.metrics.attentionExits == 1)
        #expect(!offScreen.isAttentionOnField)

        offScreen.placeGaze(at: Vector2(x: 196, y: 60))
        let back = run(&offScreen, seconds: 1.5)
        #expect(back.contains(.attentionReturned))
        #expect(back.contains(.levelCompleted))
    }

    @Test("R-23 a gaze slightly outside the edge (within tolerance) still counts as on screen")
    func fieldTolerance() {
        let level = definition(lueurs: [LueurDefinition(start: point(0.5, 0.52), iris: point(0.5, 0.5))])
        var nearEdge = session(level, gaze: Vector2(x: -20, y: 400))

        let events = run(&nearEdge, seconds: 1.5)

        #expect(events.contains(.levelCompleted))
    }

    @Test("R-24 a current stronger than the attraction keeps a lueur from crossing it passively")
    func currentBlocks() {
        let blocked = definition(lueurs: [LueurDefinition(start: point(0.5, 0.85), iris: point(0.5, 0.2))],
                                 currents: [CurrentDefinition(area: NormalizedRect(minX: 0, minY: 0.45, maxX: 1, maxY: 0.58),
                                                              direction: Vector2(x: 0, y: 1))])
        var session = session(blocked, gaze: Vector2(x: 40, y: 60))

        let events = run(&session, seconds: 20)

        #expect(!events.contains(.levelCompleted))
        #expect(session.targets[0].position.y > 0.45 * 852, "held below the band")
    }

    @Test("R-24 pushing from behind with the gaze carries the lueur through the current")
    func currentPushedThrough() {
        let level = definition(lueurs: [LueurDefinition(start: point(0.5, 0.85), iris: point(0.5, 0.2))],
                               currents: [CurrentDefinition(area: NormalizedRect(minX: 0, minY: 0.45, maxX: 1, maxY: 0.58),
                                                            direction: Vector2(x: 0, y: 1))])
        var session = session(level)
        var crossed = false
        for _ in 0..<(60 * 20) {
            let target = session.targets[0]
            if target.position.y > 0.40 * 852 {
                session.placeGaze(at: Vector2(x: target.position.x, y: min(target.position.y + 90, 852)))
            } else {
                crossed = true
                session.placeGaze(at: Vector2(x: 196, y: 800))
            }
            _ = session.advance(by: frame)
            if session.isComplete { break }
        }

        #expect(crossed)
        #expect(session.isComplete)
    }

    @Test("R-25 a veil stops a lueur pulled straight into it and never lets it through")
    func veilBlocks() {
        let level = definition(lueurs: [LueurDefinition(start: point(0.5, 0.8), iris: point(0.5, 0.2))],
                               veils: [VeilDefinition(a: point(0.16, 0.5), b: point(0.72, 0.5))])
        var session = session(level, gaze: Vector2(x: 40, y: 60))

        let events = run(&session, seconds: 25)

        #expect(!events.contains(.levelCompleted))
        #expect(session.targets[0].position.y >= 0.5 * 852 + 16 + 3 - 1e-6, "resting against the veil")
    }

    @Test("R-25 collision pushes out and reflects only the inward velocity with loss")
    func veilResponse() {
        let veil = VeilSegment(a: Vector2(x: 0, y: 100), b: Vector2(x: 200, y: 100), halfThickness: 3)
        var target = Target(id: TargetID(sequence: 1), position: Vector2(x: 100, y: 110), velocity: Vector2(x: 1, y: -2),
                            arrival: .zero, attentionZone: 1, repulsionGain: 0, passiveAttraction: 0, noiseAmplitude: 0, requiredHoldTime: 1)

        veil.resolve(&target, radius: 20, bounceLoss: 0.5)

        #expect(abs(target.position.y - 123) < 1e-9)
        #expect(abs(target.velocity.y - 1) < 1e-9)
        #expect(abs(target.velocity.x - 1) < 1e-9)
    }

    @Test("R-26 a veilleuse left alone goes out, closes its iris and costs the validation; looking relights it")
    func veilleuseCycle() {
        let level = definition(lueurs: [LueurDefinition(start: point(0.3, 0.82), iris: point(0.3, 0.8)),
                                        LueurDefinition(start: point(0.7, 0.2), iris: point(0.7, 0.18))],
                               veilleuses: [VeilleuseDefinition(position: point(0.5, 0.5), decay: 2, recharge: 0.5, initialCharge: 1, linked: [1])])
        var session = session(level, gaze: Vector2(x: 350, y: 426))
        session.replaceTargets(session.targets.enumerated().map { index, target in
            var copy = target
            if index == 1 { copy.position = Vector2(x: 60, y: 60) }
            return copy
        })

        var events = run(&session, seconds: 1)
        #expect(events.contains(.targetValidated(sequence: 1)))
        events = run(&session, seconds: 1.5)
        #expect(events.contains(.veilleuseLow(index: 0)))
        #expect(events.contains(.veilleuseOut(index: 0)))
        #expect(events.contains(.targetLost(sequence: 1, cause: .veilleuse)))
        #expect(session.metrics.losses >= 1)
        #expect(!session.isIrisOpen(for: session.targets[0]))
        #expect(session.isIrisOpen(for: session.targets[1]), "unlinked iris stays open")

        session.placeGaze(at: Vector2(x: 196, y: 426))
        events = run(&session, seconds: 0.2)
        #expect(events.contains(.veilleuseRelit(index: 0)))
        #expect(session.isIrisOpen(for: session.targets[0]))
    }

    @Test("R-26 veilleuse charge arithmetic")
    func veilleuseCharge() {
        var flame = VeilleuseState(position: Vector2(x: 0, y: 0), lookRadius: 10, decay: 4, recharge: 1, initialCharge: 0.5, linked: [])

        #expect(flame.update(seconds: 0.5, gaze: Vector2(x: 100, y: 0), gazeActive: true) == .none)
        #expect(abs(flame.charge - 0.375) < 1e-12)
        #expect(flame.update(seconds: 0.5, gaze: Vector2(x: 5, y: 0), gazeActive: true) == .none)
        #expect(abs(flame.charge - 0.875) < 1e-12)
        #expect(flame.update(seconds: 2.5, gaze: Vector2(x: 5, y: 0), gazeActive: false) == .becameLow)
        #expect(flame.update(seconds: 5, gaze: .zero, gazeActive: false) == .wentOut)
        #expect(flame.update(seconds: 0.1, gaze: .zero, gazeActive: true) == .relit)
        #expect(flame.lights(sequence: 3))
    }

    @Test("R-27 a gliding iris moves with a cosine ease and the lueur follows it")
    func irisPath() {
        let path = IrisPath(from: Vector2(x: 0, y: 0), to: Vector2(x: 100, y: 0), period: 4)
        #expect(path.position(at: 0) == Vector2(x: 0, y: 0))
        #expect(abs(path.position(at: 2).x - 100) < 1e-9)
        #expect(abs(path.position(at: 1).x - 50) < 1e-9)

        let level = definition(lueurs: [LueurDefinition(start: point(0.5, 0.8), iris: point(0.3, 0.5),
                                                        irisMotion: .oscillate(to: point(0.7, 0.5), period: 12))])
        var session = session(level, gaze: Vector2(x: 196, y: 60))
        let events = run(&session, seconds: 20)
        #expect(events.contains(.levelCompleted))
    }

    @Test("intrusions count entries into the zone, not frames spent inside")
    func intrusions() {
        let level = definition(lueurs: [LueurDefinition(start: point(0.5, 0.5), iris: point(0.5, 0.2))])
        var session = session(level, gaze: Vector2(x: 196, y: 500))

        _ = run(&session, seconds: 0.5)
        session.placeGaze(at: Vector2(x: 30, y: 840))
        _ = run(&session, seconds: 0.1)
        let target = session.targets[0].position
        session.placeGaze(at: Vector2(x: target.x, y: target.y + 40))
        let events = run(&session, seconds: 0.2)

        #expect(session.metrics.intrusions == 2)
        #expect(events.contains(.intrusion(sequence: 1)))
        #expect(session.targets[0].disturbance > 0)
    }

    @Test("prototype sessions keep an empty environment and never freeze presence")
    func prototypeUnaffected() {
        var prototype = GameSession(level: PrototypeLevelCatalog.all[0], bounds: .referencePhone)
        prototype.placeGaze(at: Vector2(x: -900, y: -900))

        #expect(prototype.environment == .empty)
        #expect(prototype.isAttentionOnField)
        _ = prototype.advance(by: frame)
        #expect(prototype.isAttentionOnField)
    }
}
