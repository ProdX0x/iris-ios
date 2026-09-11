// TargetPhysicsTests.swift
// Layer: Tests
// Purpose: R-01...R-07 and R-14: attraction, repulsion, friction, cap, bounce and frame-rate independence

import Foundation
import Testing
@testable import Iris

@Suite("TargetPhysics")
struct TargetPhysicsTests {
    private let physics = TargetPhysics(bounds: .referencePhone)

    private func target(at position: Vector2, arrival: Vector2, zone: Double = 240, attraction: Double = 0.5) -> Target {
        Target(id: TargetID(sequence: 1), position: position, arrival: arrival, attentionZone: zone,
               repulsionGain: 0.013, passiveAttraction: attraction, noiseAmplitude: 0.15, requiredHoldTime: 0.75)
    }

    private func silent(_ time: Double) -> Double { 0 }

    @Test("R-01 a sphere out of gaze reach is attracted toward its arrival")
    func attractionTowardArrival() {
        var sphere = target(at: Vector2(x: 100, y: 400), arrival: Vector2(x: 300, y: 400))
        let farGaze = Vector2(x: 330, y: 800)

        physics.integrate(&sphere, gaze: farGaze, noise: silent, frameTime: 1, frameFraction: 1)

        #expect(sphere.velocity.x > 0)
        #expect(abs(sphere.velocity.y) < 1e-12)
        #expect(sphere.position.x > 100)
        #expect(abs(sphere.velocity.x - 0.5 * 0.94) < 1e-12)
    }

    @Test("R-02 a sphere under the gaze is pushed away from it")
    func repulsionAwayFromGaze() {
        var sphere = target(at: Vector2(x: 200, y: 400), arrival: Vector2(x: 100, y: 400))
        let gaze = Vector2(x: 150, y: 400)

        physics.integrate(&sphere, gaze: gaze, noise: silent, frameTime: 1, frameFraction: 1)

        #expect(sphere.velocity.x > 0, "pushed away from the gaze, even though the arrival is on the other side")
        #expect(sphere.position.x > 200)
    }

    @Test("R-02 repulsion grows as the gaze gets closer (proportional to zone - distance)")
    func repulsionIsProportional() {
        // Both impulses stay under the 2.2 speed cap so the proportional law is observable directly.
        let expectedFar = 0.013 * (240 - 200) * 0.94
        let expectedNear = 0.013 * (240 - 100) * 0.94
        var far = target(at: Vector2(x: 200, y: 400), arrival: Vector2(x: 100, y: 400))
        var near = far

        physics.integrate(&far, gaze: Vector2(x: 0, y: 400), noise: silent, frameTime: 1, frameFraction: 1)
        physics.integrate(&near, gaze: Vector2(x: 100, y: 400), noise: silent, frameTime: 1, frameFraction: 1)

        #expect(abs(far.velocity.x - expectedFar) < 1e-12)
        #expect(abs(near.velocity.x - expectedNear) < 1e-12)
        #expect(near.velocity.x > far.velocity.x)
    }

    @Test("R-02 exactly at the attention zone boundary the sphere is attracted, just inside it is repelled")
    func zoneBoundary() {
        var atBoundary = target(at: Vector2(x: 240, y: 400), arrival: Vector2(x: 0, y: 400))
        var inside = target(at: Vector2(x: 239.9, y: 400), arrival: Vector2(x: 0, y: 400))

        physics.integrate(&atBoundary, gaze: Vector2(x: 0, y: 400), noise: silent, frameTime: 1, frameFraction: 1)
        physics.integrate(&inside, gaze: Vector2(x: 0, y: 400), noise: silent, frameTime: 1, frameFraction: 1)

        #expect(atBoundary.velocity.x < 0, "attracted toward the arrival at x = 0")
        #expect(inside.velocity.x > 0, "repelled away from the gaze at x = 0")
    }

    @Test("R-03 noise only acts while the sphere is attracted, never inside the attention zone")
    func noiseOnlyWhenAttracted() {
        var attracted = target(at: Vector2(x: 200, y: 200), arrival: Vector2(x: 200, y: 600))
        var repelled = target(at: Vector2(x: 200, y: 200), arrival: Vector2(x: 200, y: 600))
        let loudNoise: (Double) -> Double = { _ in 1 }

        physics.integrate(&attracted, gaze: Vector2(x: 330, y: 800), noise: loudNoise, frameTime: 1, frameFraction: 1)
        physics.integrate(&repelled, gaze: Vector2(x: 200, y: 150), noise: loudNoise, frameTime: 1, frameFraction: 1)

        #expect(abs(attracted.velocity.x - 0.15 * 0.94) < 1e-12, "noise amplitude 0.15 on x while attracted")
        #expect(abs(repelled.velocity.x) < 1e-12, "no noise while repelled")
    }

    @Test("R-04 speed never exceeds 2.2 points per reference frame")
    func speedCap() {
        var sphere = target(at: Vector2(x: 200, y: 400), arrival: Vector2(x: 100, y: 400))
        sphere.velocity = Vector2(x: 50, y: 50)

        physics.integrate(&sphere, gaze: Vector2(x: 330, y: 800), noise: silent, frameTime: 1, frameFraction: 1)

        #expect(sphere.speed <= 2.2 + 1e-12)
        #expect(abs(sphere.speed - 2.2 * 0.94) < 1e-9, "capped to 2.2 then friction 0.94 like the reference")
    }

    @Test("R-05 friction multiplies velocity by 0.94 per reference frame once the sphere rests on its arrival")
    func frictionDecay() {
        var sphere = target(at: Vector2(x: 200, y: 400), arrival: Vector2(x: 200, y: 400))
        sphere.velocity = Vector2(x: 1, y: 0)

        physics.integrate(&sphere, gaze: Vector2(x: 330, y: 800), noise: silent, frameTime: 1, frameFraction: 1)

        #expect(abs(sphere.velocity.x - 0.94) < 1e-9)
    }

    @Test("R-14 fractional step factors are exactly 1 at one frame and compose over two half frames")
    func fractionalStepFactors() {
        let whole = FractionalStep(friction: 0.94, frameFraction: 1)
        let half = FractionalStep(friction: 0.94, frameFraction: 0.5)

        #expect(whole.frictionFactor == 0.94)
        #expect(whole.impulseScale == 1)
        #expect(whole.capScale == 1)
        // v -> k^0.5 (v + a g) twice must equal v -> k (v + a): k^0.5 * (k^0.5 * a * g) + k^0.5 * a * g == k * a
        let composed = half.frictionFactor * half.frictionFactor * half.impulseScale + half.frictionFactor * half.impulseScale
        #expect(abs(composed - 0.94) < 1e-12)
        #expect(abs(half.capScale * half.frictionFactor - 0.94) < 1e-12, "capped speed after friction equals the reference")
    }

    @Test("R-14 two half frames of friction equal one full frame (pow(0.94, dt * 60))")
    func frictionTimeEquivalence() {
        // No attraction so that only friction acts (the sphere leaves its arrival point while coasting).
        var whole = target(at: Vector2(x: 200, y: 400), arrival: Vector2(x: 200, y: 400), attraction: 0)
        whole.velocity = Vector2(x: 1, y: 0)
        var halves = whole

        physics.integrate(&whole, gaze: Vector2(x: 330, y: 800), noise: silent, frameTime: 1, frameFraction: 1)
        physics.integrate(&halves, gaze: Vector2(x: 330, y: 800), noise: silent, frameTime: 0.5, frameFraction: 0.5)
        physics.integrate(&halves, gaze: Vector2(x: 330, y: 800), noise: silent, frameTime: 1, frameFraction: 0.5)

        #expect(abs(whole.velocity.x - halves.velocity.x) < 1e-9)
    }

    @Test("R-07 a sphere crossing the edge is clamped to the 60 pt margin and bounces with half its speed")
    func bounceIsDamped() {
        var sphere = target(at: Vector2(x: 61, y: 400), arrival: Vector2(x: -500, y: 400))
        sphere.velocity = Vector2(x: -2, y: 0)

        physics.integrate(&sphere, gaze: Vector2(x: 330, y: 800), noise: silent, frameTime: 1, frameFraction: 1)

        #expect(sphere.position.x == 60)
        #expect(sphere.velocity.x > 0, "velocity reversed")
        // -2 plus the 0.5 attraction impulse exceeds the cap: clamped to 2.2, friction, then half of it reversed.
        let expectedBeforeBounce = -2.2 * 0.94
        #expect(abs(sphere.velocity.x - (-expectedBeforeBounce * 0.5)) < 1e-9, "bounce keeps 50 percent")
    }

    @Test("R-07 every edge keeps the sphere inside the playable area")
    func allEdges() {
        let corners = [Vector2(x: 0, y: 0), Vector2(x: 390, y: 0), Vector2(x: 0, y: 844), Vector2(x: 390, y: 844)]
        for corner in corners {
            var sphere = target(at: corner, arrival: corner)
            sphere.velocity = Vector2(x: corner.x == 0 ? -2 : 2, y: corner.y == 0 ? -2 : 2)

            physics.integrate(&sphere, gaze: Vector2(x: 195, y: 422), noise: silent, frameTime: 1, frameFraction: 1)

            #expect(sphere.position.x >= 60 && sphere.position.x <= 330)
            #expect(sphere.position.y >= 60 && sphere.position.y <= 784)
        }
    }

    @Test("R-14 one simulated second lands on the same trajectory at 30, 60 and 120 Hz")
    func frameRateIndependence() {
        let rates: [Double] = [30, 60, 120]
        var finals: [Vector2] = []
        for rate in rates {
            var sphere = target(at: Vector2(x: 100, y: 300), arrival: Vector2(x: 300, y: 600))
            let fraction = 60 / rate
            var frameTime = 0.0
            for _ in 0..<Int(rate) {
                frameTime += fraction
                physics.integrate(&sphere, gaze: Vector2(x: 330, y: 800), noise: silent, frameTime: frameTime, frameFraction: fraction)
            }
            finals.append(sphere.position)
        }
        // Cruise speed is exactly equivalent at every rate; only the transient differs by a fraction of a point.
        let reference = finals[1]
        for position in finals {
            #expect(position.distance(to: reference) < 1, "within one point after one second of cruise")
        }
    }

    @Test("R-14 the integrator stays finite and bounded for many deltaTime values")
    func stabilityAcrossDeltaTimes() {
        for fraction in [0.05, 0.25, 0.5, 1.0, 1.5, 2.0, 3.0] {
            var sphere = target(at: Vector2(x: 100, y: 300), arrival: Vector2(x: 300, y: 600))
            for step in 0..<600 {
                physics.integrate(&sphere, gaze: Vector2(x: 200, y: 450), noise: { sin($0) }, frameTime: Double(step) * fraction, frameFraction: fraction)
                #expect(sphere.position.x.isFinite && sphere.position.y.isFinite)
                #expect(sphere.position.x >= 60 && sphere.position.x <= 330)
                #expect(sphere.position.y >= 60 && sphere.position.y <= 784)
                #expect(sphere.speed <= 2.2 * fraction + 1e-9 || sphere.speed <= 2.2 + 1e-9)
            }
        }
    }
}
