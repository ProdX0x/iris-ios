// BraiseStateTests.swift
// Layer: Tests
// Purpose: EXPERIMENTAL prototype B1: heat, hysteresis of charging and lighting, flare, behaviour scale, determinism

import Foundation
import Testing
@testable import Iris

@Suite("BraiseState")
struct BraiseStateTests {
    private let frame = 1.0 / 60.0

    private func braise(_ definition: BraiseDefinition = .prototype) -> BraiseState {
        BraiseState(definition: definition, shortSide: 393)
    }

    @Test("radii resolve against the short side and the definition clamps its thresholds")
    func resolution() {
        let state = braise()
        #expect(abs(state.chargeRadius - 0.22 * 393) < 1e-9)
        #expect(abs(state.releaseRadius - 0.28 * 393) < 1e-9)
        #expect(state.heat == 0 && !state.isLit && !state.isFlaring)

        let odd = BraiseDefinition(chargeRadius: 0.3, releaseRadius: 0.1, acceptHeat: 0.5, releaseHeat: 0.9, flareHeat: 0.2)
        #expect(odd.releaseRadius == 0.3)
        #expect(odd.releaseHeat == 0.5)
        #expect(odd.flareHeat == 0.5)
    }

    @Test("a gaze inside the charge radius warms the braise; it lights at the accept heat, asleep before")
    func warming() {
        var state = braise()
        var changes: [BraiseState.Change] = []
        for _ in 0..<60 { changes.append(state.update(seconds: frame, gazeDistance: 40, gazeActive: true)) }

        #expect(abs(state.heat - 1.0 / 0.9) < 0.02 || state.heat == 1)
        #expect(state.isLit)
        #expect(changes.filter { $0 == .lit }.count == 1)
        #expect(changes.filter { $0 == .flared }.count == 1)
        #expect(changes.firstIndex(of: .lit)! < changes.firstIndex(of: .flared)!)
        #expect(changes.firstIndex(of: .lit)! >= Int(0.5 * 0.9 * 60) - 1)
    }

    @Test("charging has hysteresis: it starts inside the charge radius and only stops beyond the release radius")
    func chargingHysteresis() {
        var state = braise()
        _ = state.update(seconds: frame, gazeDistance: 100, gazeActive: true)
        #expect(!state.isCharging, "100 pt is beyond the 86 pt charge radius")
        _ = state.update(seconds: frame, gazeDistance: 80, gazeActive: true)
        #expect(state.isCharging)
        _ = state.update(seconds: frame, gazeDistance: 105, gazeActive: true)
        #expect(state.isCharging, "still charging until 110 pt")
        _ = state.update(seconds: frame, gazeDistance: 112, gazeActive: true)
        #expect(!state.isCharging)
        _ = state.update(seconds: frame, gazeDistance: 10, gazeActive: false)
        #expect(!state.isCharging, "an inactive gaze never charges")
    }

    @Test("lighting has hysteresis: lit at 0.5, back to sleep only under 0.4, with a cooled change")
    func lightingHysteresis() {
        var state = braise()
        for _ in 0..<Int(0.55 * 0.9 * 60) { _ = state.update(seconds: frame, gazeDistance: 20, gazeActive: true) }
        #expect(state.isLit)
        let heatWhenReleased = state.heat

        var changes: [BraiseState.Change] = []
        var secondsToSleep = 0.0
        while state.isLit && secondsToSleep < 60 {
            changes.append(state.update(seconds: frame, gazeDistance: 500, gazeActive: true))
            secondsToSleep += frame
        }
        #expect(!state.isLit)
        #expect(changes.last == .cooled)
        let expected = (heatWhenReleased - 0.4) * 30
        #expect(abs(secondsToSleep - expected) < 0.1, "cooling takes 30 s from 1 to 0")
    }

    @Test("behaviour: asleep it does not drift; lit it drifts normally; flaring its attention zone grows up to 1.5")
    func behaviour() {
        var state = braise()
        #expect(state.behaviour == BehaviourScale(attentionZone: 1, drift: 0))
        for _ in 0..<40 { _ = state.update(seconds: frame, gazeDistance: 20, gazeActive: true) }
        #expect(state.isLit && !state.isFlaring)
        #expect(state.behaviour == .neutral)
        for _ in 0..<60 { _ = state.update(seconds: frame, gazeDistance: 20, gazeActive: true) }
        #expect(state.heat == 1 && state.isFlaring)
        #expect(abs(state.behaviour.attentionZone - 1.5) < 1e-9)
        #expect(state.behaviour.drift == 1)
        for _ in 0..<Int(0.2 * 30 * 60) { _ = state.update(seconds: frame, gazeDistance: 500, gazeActive: true) }
        #expect(!state.isFlaring, "back under 0.85 after 0.15 of cooling")
        #expect(state.isLit)
    }

    @Test("an initially warm braise starts lit; the same inputs always give the same heat")
    func determinismAndInitialHeat() {
        let warm = braise(BraiseDefinition(initialHeat: 0.7))
        #expect(warm.isLit && !warm.isFlaring)

        var first = braise()
        var second = braise()
        for step in 0..<300 {
            let distance = Double(step % 7) * 20
            _ = first.update(seconds: frame, gazeDistance: distance, gazeActive: true)
            _ = second.update(seconds: frame, gazeDistance: distance, gazeActive: true)
        }
        #expect(first == second)
    }
}
