// GazeSetupViewModel.swift
// Layer: Presentation
// Purpose: Runs diagnostic, nine-point calibration, five-point validation and persists the profile

import Foundation
import Observation
import os
import simd

@MainActor
@Observable
final class GazeSetupViewModel {
    private(set) var phase: GazeSetupPhase = .starting
    private(set) var gazeState: GazeTrackingState = .idle
    /// Live positions in normalized coordinates (diagnostic dots and the "Regard prêt" verification).
    private(set) var liveRaw: SIMD2<Double>?
    private(set) var liveCalibrated: SIMD2<Double>?
    let intent: GazeSetupIntent

    var isSimulatedGaze: Bool { gaze is SimulatedGazeTrackingService }

    /// Readiness must stay green this long before the calibration starts by itself.
    static let readinessHold: TimeInterval = 1.0

    @ObservationIgnored private var bounds: PlayfieldBounds = .referencePhone
    @ObservationIgnored private var nominal: NominalDisplayGeometry?
    @ObservationIgnored private var mapper: GazeMapper?
    @ObservationIgnored private var evaluator = GazeReadinessEvaluator()
    @ObservationIgnored private var blinkDetector = BlinkDetector()
    @ObservationIgnored private var sequence: FixationSequence?
    @ObservationIgnored private var readySince: TimeInterval?
    @ObservationIgnored private var lastReportTime: TimeInterval = -1
    @ObservationIgnored private var attempts = 0
    @ObservationIgnored private var storedProfile: CalibrationProfile?
    @ObservationIgnored private var isPrepared = false
    @ObservationIgnored private var lastCalibration: CalibrationResult?
    /// True while this ViewModel owns the shared gaze tracker's callbacks (see GameViewModel.ownsGaze).
    @ObservationIgnored private var ownsGaze = false

    @ObservationIgnored private let gaze: any GazeTrackingService
    @ObservationIgnored private let calibrationStore: any CalibrationStore
    @ObservationIgnored private let capabilities: any DeviceCapabilities
    @ObservationIgnored private let cameraAuthorization: any CameraAuthorizationService
    @ObservationIgnored private let orientation: any InterfaceOrientationProvider
    @ObservationIgnored private let settings: GameSettingsStore
    @ObservationIgnored private let criteria: GazeQualityCriteria
    @ObservationIgnored private let isPad: Bool
    @ObservationIgnored private weak var navigator: (any GazeSetupNavigating)?
    @ObservationIgnored private let logger = Logger(subsystem: "net.steve-s.iris", category: "calibration")

    init(intent: GazeSetupIntent,
         gaze: any GazeTrackingService,
         calibrationStore: any CalibrationStore,
         capabilities: any DeviceCapabilities,
         cameraAuthorization: any CameraAuthorizationService,
         orientation: any InterfaceOrientationProvider,
         settings: GameSettingsStore,
         criteria: GazeQualityCriteria = GazeQualityCriteria(),
         isPad: Bool,
         navigator: any GazeSetupNavigating) {
        self.intent = intent
        self.gaze = gaze
        self.calibrationStore = calibrationStore
        self.capabilities = capabilities
        self.cameraAuthorization = cameraAuthorization
        self.orientation = orientation
        self.settings = settings
        self.criteria = criteria
        self.isPad = isPad
        self.navigator = navigator
    }

    var viewport: PlayfieldBounds { bounds }

    // MARK: Lifecycle

    func prepare(width: Double, height: Double, displayScale: Double) {
        let newBounds = PlayfieldBounds(width: width, height: height)
        let geometry = NominalDisplayGeometry.estimate(viewport: newBounds, displayScale: displayScale, isPad: isPad)
        if isPrepared {
            gaze.updateViewport(GazeViewport(bounds: bounds, nominal: geometry))
            return
        }
        isPrepared = true
        bounds = newBounds
        nominal = geometry
        let orientationName = orientation.interfaceOrientation.irisName
        storedProfile = calibrationStore.load().flatMap { profile in
            profile.isCompatible(viewport: bounds, interfaceOrientation: orientationName, now: Date()) ? profile : nil
        }
        logger.info("setup \(String(describing: self.intent), privacy: .public) viewport \(width, format: .fixed(precision: 0))x\(height, format: .fixed(precision: 0)) orientation \(orientationName, privacy: .public) stored profile \(self.storedProfile != nil)")
        startTracking()
    }

    func viewDisappeared() {
        guard ownsGaze else { return }
        teardown()
    }

    func suspend() {
        guard isPrepared, ownsGaze, phase != .suspended else { return }
        gaze.pause()
        phase = .suspended
    }

    func wake() {
        guard phase == .suspended else { return }
        startTracking()
    }

    // MARK: Intents

    /// Restarts the whole setup from the diagnostic (after a failure or a poor validation).
    func recalibrate() {
        attempts += 1
        storedProfile = nil
        startTracking()
    }

    /// Keeps a calibration that failed the quality criteria; the profile is stored as not validated.
    func continueAnyway() {
        guard case let .insufficient(result, _) = phase, let lastCalibration, let mapper else { return }
        saveProfile(transform: lastCalibration.transform, mapper: mapper, validation: result, isValid: false)
        finish()
    }

    /// From "Regard prêt".
    func finish() {
        teardown()
        navigator?.gazeSetupCompleted(intent: intent)
    }

    func cancel() {
        teardown()
        navigator?.gazeSetupCancelled(intent: intent)
    }

    // MARK: Tracking

    private func startTracking() {
        guard let nominal else { return }
        evaluator.reset()
        readySince = nil
        sequence = nil
        liveRaw = nil
        liveCalibrated = nil
        mapper = GazeMapper(viewport: bounds, nominal: nominal)
        phase = .starting
        ownsGaze = true
        gaze.onStateChange = { [weak self] state in self?.handleGazeState(state) }
        gaze.onSample = { [weak self] sample in self?.handleSample(sample) }
        gazeState = gaze.state
        gaze.start(viewport: GazeViewport(bounds: bounds, nominal: nominal))
        simulateFixation(at: SIMD2(0.5, 0.5))
    }

    private func teardown() {
        guard ownsGaze else { return }
        ownsGaze = false
        gaze.onSample = nil
        gaze.onStateChange = nil
        gaze.stop()
    }

    private func handleGazeState(_ state: GazeTrackingState) {
        gazeState = state
        switch state {
        case .tracking:
            if phase == .starting {
                publishReadiness(now: gaze.latestSample?.timestamp ?? 0, force: true)
            }
        case .interrupted:
            if case .readiness = phase { return }
            if case .starting = phase { return }
            // A fixation in progress cannot survive an interruption: back to the diagnostic.
            startTracking()
        case let .unavailable(reason):
            phase = .failed(Self.failure(for: reason))
        case let .failed(message):
            phase = .failed(.trackingError(message: message))
        case .idle, .starting:
            break
        }
    }

    private func handleSample(_ sample: RawGazeSample) {
        guard let mapper else { return }
        let isBlinking = blinkDetector.isBlinking(left: sample.blinkLeft, right: sample.blinkRight, at: sample.timestamp)
        updateLive(sample, mapper: mapper)
        switch phase {
        case .starting, .readiness:
            evaluator.ingest(sample)
            publishReadiness(now: sample.timestamp, force: false)
        case .calibrating:
            feedSequence(sample: mapper.nominalNormalized(sample), isUsable: !isBlinking, at: sample.timestamp, mapper: mapper)
        case .validating:
            feedSequence(sample: mapper.calibratedNormalized(sample), isUsable: !isBlinking, at: sample.timestamp, mapper: mapper)
        case .insufficient, .ready, .suspended, .failed:
            break
        }
    }

    private func updateLive(_ sample: RawGazeSample, mapper: GazeMapper) {
        let wantsLive: Bool
        switch phase {
        case .ready: wantsLive = true
        // Outside the verification step the live marks follow the player's own choice: they are the same help.
        default: wantsLive = settings.gazeAssistance == .visible
        }
        guard wantsLive else {
            if liveRaw != nil { liveRaw = nil; liveCalibrated = nil }
            return
        }
        liveRaw = mapper.nominalNormalized(sample)
        liveCalibrated = mapper.calibratedNormalized(sample)
    }

    // MARK: Readiness

    private func publishReadiness(now: TimeInterval, force: Bool) {
        guard let nominal else { return }
        guard force || now - lastReportTime >= 0.1 else { return }
        lastReportTime = now
        let report = evaluator.report(supportsFaceTracking: capabilities.supportsFaceTracking,
                                      cameraAuthorized: cameraAuthorization.currentStatus() == .authorized,
                                      trackingState: gazeState, nominal: nominal, viewport: bounds)
        if report.isBlocked {
            if !capabilities.supportsFaceTracking {
                phase = .failed(.faceTrackingUnsupported)
            } else {
                phase = .failed(cameraAuthorization.currentStatus() == .restricted ? .cameraRestricted : .cameraDenied)
            }
            return
        }
        if case let .readiness(previous) = phase, previous == report {
            // unchanged
        } else {
            phase = .readiness(report)
        }
        if report.isReady {
            if readySince == nil { readySince = now }
            if let readySince, now - readySince >= Self.readinessHold, let mapping = report.axisMapping {
                beginFixations(axisMapping: mapping)
            }
        } else {
            readySince = nil
        }
    }

    // MARK: Fixations

    private func beginFixations(axisMapping: AxisMapping) {
        guard let nominal else { return }
        logger.info("readiness passed, axes \(GazeReadinessEvaluator.describe(axisMapping), privacy: .public) right-handed \(axisMapping.isRightHanded)")
        if intent == .revalidate, let storedProfile, storedProfile.axisMapping == axisMapping {
            mapper = GazeMapper(viewport: bounds, profile: storedProfile)
            lastCalibration = CalibrationResult(transform: storedProfile.transform, residualMean: 0, residualMax: 0, pointCount: 0)
            startSequence(targets: CalibrationGrid.validation, validating: true)
        } else {
            mapper = GazeMapper(viewport: bounds, nominal: nominal, axisMapping: axisMapping)
            startSequence(targets: CalibrationGrid.nine, validating: false)
        }
    }

    private func startSequence(targets: [SIMD2<Double>], validating: Bool) {
        var sequence = FixationSequence(targets: targets)
        let time = gaze.latestSample?.timestamp ?? 0
        _ = sequence.start(at: time)
        self.sequence = sequence
        publishFixation(validating: validating, at: time)
        simulateFixation(at: sequence.currentTarget)
    }

    private func feedSequence(sample: SIMD2<Double>?, isUsable: Bool, at time: TimeInterval, mapper: GazeMapper) {
        guard var sequence else { return }
        let validating: Bool
        if case .validating = phase { validating = true } else { validating = false }
        let event = sequence.feed(sample: sample, isUsable: isUsable, at: time)
        self.sequence = sequence
        switch event {
        case .targetChanged:
            simulateFixation(at: sequence.currentTarget)
            publishFixation(validating: validating, at: time)
        case .targetMeasured, .none:
            publishFixation(validating: validating, at: time)
        case .completed:
            if validating {
                completeValidation(sequence: sequence, mapper: mapper)
            } else {
                completeCalibration(sequence: sequence, mapper: mapper)
            }
        case let .failed(failure):
            switch failure {
            case let .insufficientSamples(target):
                logger.error("fixation failed on target \(target)")
                phase = .failed(.insufficientSignal(target: target))
            }
        }
    }

    private func publishFixation(validating: Bool, at time: TimeInterval) {
        guard let sequence, let target = sequence.currentTarget, let index = sequence.currentTargetIndex else { return }
        let display = FixationDisplay(target: target, index: index, count: sequence.targets.count,
                                      progress: sequence.progress(at: time), isCollecting: sequence.isCollecting)
        phase = validating ? .validating(display) : .calibrating(display)
    }

    private func completeCalibration(sequence: FixationSequence, mapper: GazeMapper) {
        do {
            let result = try CalibrationResult.fit(pairs: sequence.pairs)
            lastCalibration = result
            var calibrated = mapper
            calibrated.calibration = result.transform
            self.mapper = calibrated
            logger.info("calibration fitted: residual mean \(result.residualMean, format: .fixed(precision: 4)) max \(result.residualMax, format: .fixed(precision: 4))")
            startSequence(targets: CalibrationGrid.validation, validating: true)
        } catch {
            logger.error("calibration fit failed: \(String(describing: error), privacy: .public)")
            phase = .failed(.fitFailed)
        }
    }

    private func completeValidation(sequence: FixationSequence, mapper: GazeMapper) {
        let pairs = sequence.pairs.map { (measured: $0.raw, target: $0.target) }
        let result = ValidationResult(pairs: pairs, viewport: bounds)
        logger.info("validation: mean \(result.meanError, format: .fixed(precision: 3)) max \(result.maxError, format: .fixed(precision: 3)) accepted \(self.criteria.accepts(result))")
        guard let lastCalibration else {
            phase = .failed(.fitFailed)
            return
        }
        if criteria.accepts(result) {
            saveProfile(transform: lastCalibration.transform, mapper: mapper, validation: result, isValid: true)
            phase = .ready(result)
            simulateFixation(at: nil)
        } else {
            phase = .insufficient(result, attempts: attempts + 1)
        }
    }

    private func saveProfile(transform: AffineTransform2D, mapper: GazeMapper, validation: ValidationResult, isValid: Bool) {
        let profile = CalibrationProfile(transform: transform,
                                         axisMapping: mapper.axisMapping,
                                         interfaceOrientation: orientation.interfaceOrientation.irisName,
                                         viewport: bounds,
                                         nominalGeometry: mapper.nominal,
                                         createdAt: Date(),
                                         validationMeanError: validation.meanError,
                                         validationMaxError: validation.maxError,
                                         isValid: isValid)
        calibrationStore.save(profile)
        logger.info("calibration profile saved (valid \(isValid))")
    }

    private func simulateFixation(at target: SIMD2<Double>?) {
        (gaze as? SimulatedGazeTrackingService)?.simulateFixation(at: target)
    }

    private static func failure(for reason: GazeUnavailabilityReason) -> GazeSetupFailure {
        switch reason {
        case .faceTrackingUnsupported: .faceTrackingUnsupported
        case .cameraDenied: .cameraDenied
        case .cameraRestricted: .cameraRestricted
        }
    }
}
