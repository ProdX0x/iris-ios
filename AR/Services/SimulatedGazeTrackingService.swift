// SimulatedGazeTrackingService.swift
// Layer: AR
// Purpose: Pointer-driven or scripted gaze for the simulator, previews and tests (no camera involved)

import Foundation
import simd

@MainActor
final class SimulatedGazeTrackingService: GazeTrackingService {
    private(set) var state: GazeTrackingState = .idle {
        didSet { if state != oldValue { onStateChange?(state) } }
    }
    private(set) var latestSample: RawGazeSample?
    var onStateChange: (@MainActor (GazeTrackingState) -> Void)?
    var onSample: (@MainActor (RawGazeSample) -> Void)?

    /// Simulated physical geometry: the eyes 35 cm in front of the camera, 6.3 cm apart, device upright.
    static let eyeOrigin = SIMD3<Double>(0, 0, -0.35)
    static let eyeSeparation = 0.063

    private var viewport: GazeViewport?
    private let startsUnavailable: GazeUnavailabilityReason?
    private let parkedPoint: Vector2?
    private let oracle: Bool
    private var fixation: SIMD2<Double>?
    private var timer: Timer?
    private var tick = 0

    /// - oracle: emits samples at the fixation target set through `simulateFixation`, 60 times per second,
    ///   so that the calibration flow can be exercised without a face.
    init(startsUnavailable: GazeUnavailabilityReason? = nil, parkedPoint: Vector2? = nil, oracle: Bool = false) {
        self.startsUnavailable = startsUnavailable
        self.parkedPoint = parkedPoint
        self.oracle = oracle
    }

    func start(viewport: GazeViewport) {
        self.viewport = viewport
        if let startsUnavailable {
            state = .unavailable(startsUnavailable)
            return
        }
        if let parkedPoint {
            latestSample = makeSample(point: parkedPoint, timestamp: 0)
        }
        state = .tracking(faceVisible: true)
        if oracle { startOracle() }
    }

    func pause() {
        stopOracle()
        state = .idle
    }

    func resume() {
        guard viewport != nil else { return }
        state = startsUnavailable.map { .unavailable($0) } ?? .tracking(faceVisible: true)
        if oracle, case .tracking = state { startOracle() }
    }

    func stop() {
        stopOracle()
        state = .idle
        latestSample = nil
    }

    func updateViewport(_ viewport: GazeViewport) {
        self.viewport = viewport
    }

    /// Injects a pointer position as if it were a gaze sample.
    func inject(point: Vector2, timestamp: TimeInterval) {
        guard case .tracking = state else { return }
        emit(makeSample(point: point, timestamp: timestamp))
    }

    /// Oracle mode: the simulated gaze fixates this normalized target (nil parks it on the last one).
    func simulateFixation(at normalized: SIMD2<Double>?) {
        fixation = normalized
    }

    /// Test hook to drive the state machine (interruptions, failures).
    func simulate(state newState: GazeTrackingState) {
        state = newState
    }

    /// Builds a raw sample whose nominal mapping lands exactly on `point`.
    func makeSample(point: Vector2, timestamp: TimeInterval, blinkLeft: Double = 0, blinkRight: Double = 0) -> RawGazeSample {
        let viewport = self.viewport ?? GazeViewport(bounds: .referencePhone,
                                                     nominal: NominalDisplayGeometry.estimate(viewport: .referencePhone, displayScale: 3, isPad: false))
        let normalized = NormalizedCoordinates.normalized(point, in: viewport.bounds)
        let offsets = viewport.nominal.planeOffsets(normalized: normalized, viewport: viewport.bounds)
        let hit = AxisMapping.standard.planePoint(right: offsets.right, up: offsets.up)
        return RawGazeSample(timestamp: timestamp,
                             planeHit: hit,
                             eyeOrigin: Self.eyeOrigin,
                             eyeSeparation: Self.eyeSeparation,
                             userRight: SIMD2(1, 0),
                             deviceUp: SIMD2(0, 1),
                             faceUp: SIMD2(0, 1),
                             blinkLeft: blinkLeft,
                             blinkRight: blinkRight,
                             hasBlendShapes: true)
    }

    private func emit(_ sample: RawGazeSample) {
        latestSample = sample
        onSample?(sample)
    }

    private func startOracle() {
        stopOracle()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated { self?.oracleTick() }
        }
    }

    private func stopOracle() {
        timer?.invalidate()
        timer = nil
    }

    private func oracleTick() {
        guard case .tracking = state, let viewport else { return }
        tick += 1
        let target = fixation ?? SIMD2(0.5, 0.5)
        let jitter = SIMD2(sin(Double(tick) * 0.7) * 0.004, cos(Double(tick) * 0.9) * 0.004)
        let point = NormalizedCoordinates.points(target + jitter, in: viewport.bounds)
        emit(makeSample(point: point, timestamp: ProcessInfo.processInfo.systemUptime))
    }
}
