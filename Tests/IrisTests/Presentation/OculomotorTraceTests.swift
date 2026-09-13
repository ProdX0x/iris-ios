// OculomotorTraceTests.swift
// Layer: Tests
// Purpose: PROTOTYPE instrumentation: gaze states as the mapper really provides them, viewport exits without any
// invented position, head pose logged without touching the game, transitions measured, and the historical face-lost
// warning untouched on level 6

import Foundation
import Testing
@testable import Iris

@Suite("Oculomotor trace")
@MainActor
struct OculomotorTraceTests {
    private let bounds = PlayfieldBounds(width: 393, height: 852)

    private func sample(_ time: TimeInterval, observation: GazeObservation? = nil) -> RawGazeSample {
        RawGazeSample(timestamp: time, planeHit: SIMD2(0, 0), eyeOrigin: SIMD3(0, 0, -0.35), eyeSeparation: 0.063,
                      userRight: SIMD2(1, 0), deviceUp: SIMD2(0, 1), faceUp: SIMD2(0, 1), blinkLeft: 0, blinkRight: 0,
                      hasBlendShapes: true, observation: observation)
    }

    @Test("VALID_INSIDE, VALID_OUTSIDE (the mapper produced a projection beyond the viewport) and INVALID (no projection)")
    func states() {
        let trace = OculomotorTrace(names: ["CENTER"])
        trace.observeSample(mapped: Vector2(x: 200, y: 400), sample: sample(0), bounds: bounds)
        #expect(trace.state == .validInside && trace.lastEdge == nil)
        trace.observeSample(mapped: Vector2(x: 420, y: 400), sample: sample(0.1), bounds: bounds)
        #expect(trace.state == .validOutside && trace.lastEdge == .right)
        trace.observeSample(mapped: nil, sample: sample(0.2), bounds: bounds)
        #expect(trace.state == .invalid)
        trace.observeSample(mapped: Vector2(x: 380, y: 400), sample: sample(0.3), bounds: bounds)
        #expect(trace.state == .validInside && trace.lastEdge == nil)
    }

    @Test("the mapper really produces projections outside the viewport (clamped at half a viewport), so VALID_OUTSIDE is not invented")
    func mapperOvershoot() {
        let mapper = GazeMapper(viewport: bounds, nominal: NominalDisplayGeometry.estimate(viewport: bounds, displayScale: 3, isPad: false))
        let far = mapper.screenPoint(normalized: SIMD2(1.3, 0.5))
        #expect(far.x > bounds.width && far.x <= bounds.width * 1.5 + 1e-9)
        let beyond = mapper.screenPoint(normalized: SIMD2(4, 0.5))
        #expect(abs(beyond.x - bounds.width * 1.5) < 1e-9, "capped by the mapper")
    }

    @Test("an exit toward the right edge that becomes invalid keeps only the last inside position and the last observed direction; no position is invented")
    func exitWithoutInvention() {
        let trace = OculomotorTrace(names: ["CENTER"])
        trace.observeSample(mapped: Vector2(x: 300, y: 400), sample: sample(0), bounds: bounds)
        trace.observeSample(mapped: Vector2(x: 340, y: 402), sample: sample(0.05), bounds: bounds)
        trace.observeSample(mapped: Vector2(x: 380, y: 405), sample: sample(0.1), bounds: bounds)
        trace.observeSample(mapped: nil, sample: sample(0.15), bounds: bounds)
        #expect(trace.excursions.count == 1)
        guard let excursion = trace.excursions.first else { return }
        #expect(excursion.state == .invalid && excursion.projected == nil && !excursion.isCapped)
        #expect(excursion.lastValidPosition == Vector2(x: 380, y: 405) && excursion.lastDirection == .right)
        #expect(trace.lastEdge == .right)
        trace.observeSample(mapped: Vector2(x: 360, y: 400), sample: sample(0.6), bounds: bounds)
        #expect(trace.excursions.first?.reentry == Vector2(x: 360, y: 400))
        #expect(abs((trace.excursions.first?.duration ?? 0) - 0.45) < 1e-9)
        #expect(trace.lines.contains { $0.contains("exit state=INVALID edge=RIGHT") && $0.contains("projected=none") })
    }

    @Test("an exit with a projection beyond the top edge records that projection and its edge; a last direction far from any edge gives no edge when invalid")
    func exitWithProjection() {
        let trace = OculomotorTrace(names: ["CENTER"])
        trace.observeSample(mapped: Vector2(x: 200, y: 100), sample: sample(0), bounds: bounds)
        trace.observeSample(mapped: Vector2(x: 200, y: -60), sample: sample(0.05), bounds: bounds)
        #expect(trace.excursions.first?.projected == Vector2(x: 200, y: -60) && trace.excursions.first?.state == .validOutside && trace.lastEdge == .top)
        let centred = OculomotorTrace(names: ["CENTER"])
        centred.observeSample(mapped: Vector2(x: 190, y: 420), sample: sample(0), bounds: bounds)
        centred.observeSample(mapped: Vector2(x: 200, y: 425), sample: sample(0.05), bounds: bounds)
        centred.observeSample(mapped: nil, sample: sample(0.1), bounds: bounds)
        #expect(centred.lastEdge == nil, "a loss from the middle of the field points at no edge")
        #expect(centred.excursions.first?.projected == nil)
    }

    @Test("head yaw and pitch are recorded per transition and never influence the session")
    func headPose() {
        guard let level = Campaign.level(id: "1-6") else { return }
        let resolved = LevelResolver.resolve(level, in: bounds)
        var traced = resolved.makeSession(noiseSources: [SilentNoise()])
        var plain = resolved.makeSession(noiseSources: [SilentNoise()])
        let trace = OculomotorTrace(names: level.balises?.balises.map(\.name) ?? [])
        let points = traced.balises?.positions ?? []
        var time = 0.0
        for step in 0..<3 {
            let target = points[traced.balises?.activeBalise ?? 0]
            for _ in 0..<30 {
                time += 1.0 / 60
                let yaw = 2.0 + Double(step) * 3
                trace.observeSample(mapped: target, sample: sample(time, observation: GazeObservation(headYaw: yaw, headPitch: 0.5, headRoll: 0, leftEye: .zero, rightEye: .zero, lookAt: .zero)), bounds: bounds)
                traced.placeGaze(at: target)
                plain.placeGaze(at: target)
                let events = traced.advance(by: 1.0 / 60)
                _ = plain.advance(by: 1.0 / 60)
                trace.observeTick(session: traced, events: events)
            }
        }
        #expect(traced.targets == plain.targets && traced.balises == plain.balises && traced.elapsed == plain.elapsed && traced.isComplete == plain.isComplete,
                "the trace observes, the session does not depend on it")
        #expect(trace.transitions.count == 3)
        #expect(trace.transitions.allSatisfy { $0.acquisition != nil && $0.dwell != nil && $0.validation != nil })
        #expect(trace.transitions[1].from == "CENTER" && trace.transitions[1].to == "RIGHT")
        #expect(trace.headYaw == 8 && trace.headPitch == 0.5)
        #expect(trace.lines.contains { $0.contains("transition=CENTER->RIGHT") && $0.contains("headYawDelta=") })
    }

    @Test("the historical face-lost warning behaves on level 6 exactly as on level 1: 0.3 s without a face pauses, the face back resumes")
    func faceLostUnchanged() {
        guard let six = Campaign.level(id: "1-6"), let one = Campaign.level(id: "1-1") else { return }
        for level in [one, six] {
            let gaze = SimulatedGazeTrackingService()
            let clock = ManualGameClock()
            let navigator = MockNavigator()
            let settings = GameSettingsStore(defaults: UserDefaults(suiteName: "iris.tests.oculo.\(UUID().uuidString)") ?? .standard)
            let sut = GameViewModel(level: level, gaze: gaze, audio: MockAudioService(), haptics: MockHapticFeedbackService(), clock: clock,
                                    settings: settings, calibrationStore: InMemoryCalibrationStore(), orientation: FixedOrientationProvider(),
                                    isPad: false, navigator: navigator)
            sut.prepare(width: 390, height: 844, displayScale: 3)
            gaze.inject(point: Vector2(x: 40, y: 800), timestamp: 0)
            sut.primaryAction()
            #expect(sut.phase == .playing, "\(level.id)")
            gaze.simulate(state: .tracking(faceVisible: false))
            clock.tick(frames: 10)
            #expect(sut.phase == .playing, "\(level.id)")
            clock.tick(frames: 12)
            #expect(sut.phase == .faceLost, "\(level.id)")
            gaze.simulate(state: .tracking(faceVisible: true))
            #expect(sut.phase == .playing, "\(level.id)")
            #if DEBUG
            #expect((level.id == "1-6") == (sut.oculoTrace != nil), "the trace exists only for the prototype level")
            if level.id == "1-6" { #expect(sut.oculoTrace?.state == .invalid) }
            #endif
        }
    }

    @Test("R-23 still closes the irises when the gaze leaves the field; the trace merely names the edge")
    func attentionOffFieldUnchanged() {
        guard let level = Campaign.level(id: "1-6") else { return }
        let resolved = LevelResolver.resolve(level, in: bounds)
        var session = resolved.makeSession(noiseSources: [SilentNoise()])
        session.placeGaze(at: Vector2(x: 200, y: 400))
        _ = session.advance(by: 1.0 / 60)
        #expect(session.isAttentionOnField)
        session.placeGaze(at: Vector2(x: 200, y: -60))
        let events = session.advance(by: 1.0 / 60)
        #expect(events.contains(.attentionLeftField) && !session.isAttentionOnField)
    }
}
