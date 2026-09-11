// GazeReadinessEvaluatorTests.swift
// Layer: Tests
// Purpose: Readiness checks pass for a stable signal and flag distance, direction, stability and hardware problems

import Foundation
import Testing
import simd
@testable import Iris

@Suite("GazeReadinessEvaluator")
struct GazeReadinessEvaluatorTests {
    private let viewport = PlayfieldBounds.referencePhone
    private let nominal = NominalDisplayGeometry.estimate(viewport: .referencePhone, displayScale: 3, isPad: false)

    private func feed(_ evaluator: inout GazeReadinessEvaluator, frames: Int, point: Vector2 = Vector2(x: 195, y: 422),
                      wobble: Double = 2, eyeOrigin: SIMD3<Double> = SIMD3(0, 0, -0.35), eyeSeparation: Double = 0.063,
                      headWobble: Double = 0, hit: Bool = true, hasBlendShapes: Bool = true) {
        for frame in 0..<frames {
            let time = Double(frame) / 60
            let wobbled = Vector2(x: point.x + sin(Double(frame)) * wobble, y: point.y + cos(Double(frame)) * wobble)
            let origin = eyeOrigin + SIMD3(sin(Double(frame)) * headWobble, 0, 0)
            var sample = SimulatedGazeTrackingServiceProbe.makeSample(point: wobbled, viewport: viewport, nominal: nominal,
                                                                       timestamp: time, eyeOrigin: origin, eyeSeparation: eyeSeparation,
                                                                       hasBlendShapes: hasBlendShapes)
            if !hit {
                sample = RawGazeSample(timestamp: time, planeHit: nil, eyeOrigin: origin, eyeSeparation: eyeSeparation,
                                       userRight: SIMD2(1, 0), deviceUp: SIMD2(0, 1), faceUp: SIMD2(0, 1),
                                       blinkLeft: 0, blinkRight: 0, hasBlendShapes: hasBlendShapes)
            }
            evaluator.ingest(sample)
        }
    }

    private func report(_ evaluator: GazeReadinessEvaluator, supported: Bool = true, authorized: Bool = true,
                        state: GazeTrackingState = .tracking(faceVisible: true)) -> GazeReadinessReport {
        evaluator.report(supportsFaceTracking: supported, cameraAuthorized: authorized, trackingState: state, nominal: nominal, viewport: viewport)
    }

    @Test("a stable centred signal passes every check and resolves the standard axes")
    func ready() {
        var evaluator = GazeReadinessEvaluator()
        feed(&evaluator, frames: 72)

        let result = report(evaluator)

        #expect(result.isReady)
        #expect(result.axisMapping == .standard)
        #expect(result.axisConfidence == 1)
        #expect(result.checks.count == ReadinessCheckKind.allCases.count)
    }

    @Test("before enough samples the signal checks are pending, not failed")
    func pending() {
        var evaluator = GazeReadinessEvaluator()
        feed(&evaluator, frames: 5)

        let result = report(evaluator)

        #expect(!result.isReady)
        #expect(!result.isBlocked)
        #expect(result.checks.first { $0.kind == .signalStable }?.status == .pending)
    }

    @Test("unsupported hardware or a denied camera block readiness")
    func blocked() {
        var evaluator = GazeReadinessEvaluator()
        feed(&evaluator, frames: 72)

        #expect(report(evaluator, supported: false).isBlocked)
        #expect(report(evaluator, authorized: false).isBlocked)
        #expect(!report(evaluator, state: .interrupted).isReady)
    }

    @Test("a face too far or with implausible eye separation fails the eye check")
    func eyes() {
        var far = GazeReadinessEvaluator()
        feed(&far, frames: 72, eyeOrigin: SIMD3(0, 0, -1.4))
        var tiny = GazeReadinessEvaluator()
        feed(&tiny, frames: 72, eyeSeparation: 0.01)

        #expect(report(far).checks.first { $0.kind == .eyeTracking }?.status == .fail)
        #expect(report(tiny).checks.first { $0.kind == .eyeTracking }?.status == .fail)
    }

    @Test("a gaze that never reaches the screen fails the direction check")
    func direction() {
        var evaluator = GazeReadinessEvaluator()
        feed(&evaluator, frames: 72, hit: false)

        #expect(report(evaluator).checks.first { $0.kind == .gazeDirection }?.status == .fail)
    }

    @Test("a moving head or a wandering gaze keep the stability checks pending")
    func stability() {
        var head = GazeReadinessEvaluator()
        feed(&head, frames: 72, headWobble: 0.06)
        var gaze = GazeReadinessEvaluator()
        feed(&gaze, frames: 72, wobble: 120)

        #expect(report(head).checks.first { $0.kind == .headStable }?.status == .pending)
        #expect(report(gaze).checks.first { $0.kind == .signalStable }?.status == .pending)
    }

    @Test("missing blend shapes fail the blink check and the window forgets old samples")
    func blendShapesAndWindow() {
        var evaluator = GazeReadinessEvaluator()
        feed(&evaluator, frames: 72, hasBlendShapes: false)
        #expect(report(evaluator).checks.first { $0.kind == .blinkDetection }?.status == .fail)

        #expect(evaluator.sampleCount == 72)
        evaluator.reset()
        #expect(evaluator.sampleCount == 0)
    }
}
