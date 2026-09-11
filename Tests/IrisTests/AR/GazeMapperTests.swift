// GazeMapperTests.swift
// Layer: Tests
// Purpose: Raw sample to points pipeline, nominal geometry inverse, ray-plane intersection, blink detector

import Foundation
import Testing
import simd
@testable import Iris

@Suite("GazeMapper and projection")
struct GazeMapperTests {
    private let viewport = PlayfieldBounds.referencePhone
    private let nominal = NominalDisplayGeometry.estimate(viewport: .referencePhone, displayScale: 3, isPad: false)

    @Test("nominal geometry normalizes and inverts consistently")
    func nominalRoundTrip() {
        let offsets = nominal.planeOffsets(normalized: SIMD2(0.25, 0.75), viewport: viewport)
        let back = nominal.normalized(right: offsets.right, up: offsets.up, viewport: viewport)

        #expect(abs(back.x - 0.25) < 1e-12 && abs(back.y - 0.75) < 1e-12)
        #expect(abs(nominal.metersPerPoint - 3 * 0.0254 / 460) < 1e-12)
        let pad = NominalDisplayGeometry.estimate(viewport: PlayfieldBounds(width: 834, height: 1194), displayScale: 2, isPad: true)
        #expect(abs(pad.metersPerPoint - 2 * 0.0254 / 264) < 1e-12)
        #expect(pad.cameraOrigin.y < 0)
    }

    @Test("ray-plane intersection works whichever side of the plane the face is on")
    func planeHit() {
        let front = GazeRay.planeHit(eyeOrigin: SIMD3(0, 0, -0.35), lookAt: SIMD3(0.02, -0.03, -0.05))
        let behind = GazeRay.planeHit(eyeOrigin: SIMD3(0, 0, 0.35), lookAt: SIMD3(0.02, -0.03, 0.05))

        #expect(front != nil && behind != nil)
        if let front, let behind {
            let expectedX = 0.02 * 0.35 / 0.30
            #expect(abs(front.x - expectedX) < 1e-9 && abs(behind.x - expectedX) < 1e-9)
            #expect(abs(front.y - (-0.03 * 0.35 / 0.30)) < 1e-9)
        }
    }

    @Test("looking away from the device or non finite input gives no hit")
    func noHit() {
        #expect(GazeRay.planeHit(eyeOrigin: SIMD3(0, 0, -0.35), lookAt: SIMD3(0, 0, -0.6)) == nil)
        #expect(GazeRay.planeHit(eyeOrigin: SIMD3(0, 0, -0.35), lookAt: SIMD3(0.1, 0.1, -0.35)) == nil, "parallel")
        #expect(GazeRay.planeHit(eyeOrigin: SIMD3(.nan, 0, -0.35), lookAt: SIMD3(0, 0, 0)) == nil)
    }

    @Test("an uncalibrated mapper reproduces the simulated pointer position")
    func uncalibratedRoundTrip() {
        let mapper = GazeMapper(viewport: viewport, nominal: nominal)
        let sample = SimulatedGazeTrackingServiceProbe.makeSample(point: Vector2(x: 60, y: 700), viewport: viewport, nominal: nominal)

        let point = mapper.screenPoint(sample)

        #expect(point != nil)
        if let point {
            #expect(abs(point.x - 60) < 1e-9 && abs(point.y - 700) < 1e-9)
        }
        #expect(!mapper.isCalibrated)
        #expect(mapper.rawScreenPoint(sample) == point)
    }

    @Test("axis mapping is applied before the nominal frame, so a flipped device still maps correctly")
    func axisMappingApplied() {
        let flipped = AxisMapping(right: .negativeX, up: .negativeY)
        let mapper = GazeMapper(viewport: viewport, nominal: nominal, axisMapping: flipped)
        // A hit at plane (-0.01, +0.02) means 1 cm to the user's right and 2 cm below the camera on a flipped device.
        let sample = RawGazeSample(timestamp: 0, planeHit: SIMD2(-0.01, 0.02), eyeOrigin: SIMD3(0, 0, -0.35), eyeSeparation: 0.063,
                                   userRight: SIMD2(-1, 0), deviceUp: SIMD2(0, -1), faceUp: SIMD2(0, -1),
                                   blinkLeft: 0, blinkRight: 0, hasBlendShapes: true)

        let normalized = mapper.nominalNormalized(sample)

        #expect(normalized != nil)
        if let normalized {
            #expect(normalized.x > 0.5, "to the right of the camera")
            #expect(normalized.y > 0, "below the camera")
            let expectedX = (viewport.width / 2 + 0.01 / nominal.metersPerPoint) / viewport.width
            #expect(abs(normalized.x - expectedX) < 1e-9)
        }
        #expect(sample.suggestedAxisMapping == flipped)
    }

    @Test("calibration is applied once and the result is clamped to the overshoot band")
    func calibrationAndClamp() {
        let transform = AffineTransform2D(a0: 0.5, a1: 2, a2: 0, b0: 0, b1: 0, b2: 1)
        let mapper = GazeMapper(viewport: viewport, nominal: nominal, calibration: transform)
        let sample = SimulatedGazeTrackingServiceProbe.makeSample(point: Vector2(x: 390, y: 422), viewport: viewport, nominal: nominal)

        let normalized = mapper.calibratedNormalized(sample)
        let point = mapper.screenPoint(sample)

        #expect(abs((normalized?.x ?? 0) - 2.5) < 1e-9)
        #expect(point?.x == viewport.width * 1.5, "clamped to +50 percent overshoot")
    }

    @Test("a sample without plane hit maps to nothing")
    func missingHit() {
        let mapper = GazeMapper(viewport: viewport, nominal: nominal)
        let sample = RawGazeSample(timestamp: 0, planeHit: nil, eyeOrigin: SIMD3(0, 0, -0.35), eyeSeparation: 0.063,
                                   userRight: SIMD2(1, 0), deviceUp: SIMD2(0, 1), faceUp: SIMD2(0, 1),
                                   blinkLeft: 0, blinkRight: 0, hasBlendShapes: true)

        #expect(mapper.screenPoint(sample) == nil)
        #expect(mapper.nominalNormalized(sample) == nil)
    }

    @Test("blink detector flags blinks and a short hold-off after them")
    func blinks() {
        var detector = BlinkDetector(threshold: 0.5, holdOff: 0.12)

        let open = detector.isBlinking(left: 0.1, right: 0.2, at: 1.0)
        let blink = detector.isBlinking(left: 0.9, right: 0.1, at: 1.1)
        let holdOff = detector.isBlinking(left: 0.0, right: 0.0, at: 1.2)
        let after = detector.isBlinking(left: 0.0, right: 0.0, at: 1.3)

        #expect(!open)
        #expect(blink)
        #expect(holdOff, "hold-off")
        #expect(!after)
    }
}
