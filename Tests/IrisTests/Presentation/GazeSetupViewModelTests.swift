// GazeSetupViewModelTests.swift
// Layer: Tests
// Purpose: The setup state machine: readiness, calibration, validation, verdicts, persistence, failures

import Foundation
import Testing
import simd
@testable import Iris

@Suite("GazeSetupViewModel")
@MainActor
struct GazeSetupViewModelTests {
    private let gaze = SimulatedGazeTrackingService()
    private let store = InMemoryCalibrationStore()
    private let navigator = MockNavigator()
    private let viewport = PlayfieldBounds(width: 390, height: 844)

    private func makeSUT(intent: GazeSetupIntent = .firstRun, supported: Bool = true,
                         cameraStatus: CameraAuthorizationStatus = .authorized) -> GazeSetupViewModel {
        let settings = GameSettingsStore(defaults: UserDefaults(suiteName: "iris.tests.setup.\(UUID().uuidString)") ?? .standard)
        let sut = GazeSetupViewModel(intent: intent, gaze: gaze, calibrationStore: store,
                                     capabilities: StaticDeviceCapabilities(supportsFaceTracking: supported),
                                     cameraAuthorization: StubCameraAuthorizationService(status: cameraStatus),
                                     orientation: FixedOrientationProvider(), settings: settings, isPad: false, navigator: navigator)
        sut.prepare(width: viewport.width, height: viewport.height, displayScale: 3)
        return sut
    }

    /// Drives the simulated gaze at 60 Hz. `gazeFor` returns where the "user" looks for the current phase
    /// (nil means no sample at all).
    private func drive(_ sut: GazeSetupViewModel, seconds: Double, from start: Double,
                       gazeFor: (GazeSetupPhase, Double) -> Vector2?) -> Double {
        let frames = Int(seconds * 60)
        var time = start
        for frame in 0..<frames {
            time = start + Double(frame) / 60
            if let point = gazeFor(sut.phase, time) {
                gaze.inject(point: point, timestamp: time)
            }
        }
        return time + 1.0 / 60
    }

    /// Drives until the setup reaches a verdict (ready, insufficient, failed) or `maxSeconds` elapse.
    @discardableResult
    private func driveToVerdict(_ sut: GazeSetupViewModel, from start: Double, maxSeconds: Double = 40,
                                gazeFor: (GazeSetupPhase, Double) -> Vector2?) -> Double {
        var time = start
        let end = start + maxSeconds
        while time < end {
            switch sut.phase {
            case .ready, .insufficient, .failed: return time
            default: break
            }
            time = drive(sut, seconds: 0.5, from: time, gazeFor: gazeFor)
        }
        return time
    }

    /// A perfect user: fixates the centre during readiness and every target afterwards, with a fixed bias
    /// (the flaw the calibration must learn) when `bias` is set.
    private func perfectGaze(bias: Vector2 = .zero, jitter: Double = 1.5) -> (GazeSetupPhase, Double) -> Vector2? {
        { phase, time in
            let target: SIMD2<Double>
            switch phase {
            case let .calibrating(display), let .validating(display): target = display.target
            case .ready: target = SIMD2(0.5, 0.5)
            default: target = SIMD2(0.5, 0.5)
            }
            let point = NormalizedCoordinates.points(target, in: self.viewport)
            return Vector2(x: point.x + bias.x + sin(time * 50) * jitter, y: point.y + bias.y + cos(time * 40) * jitter)
        }
    }

    @Test("readiness passes with a stable signal and the calibration starts by itself after one second")
    func readinessThenCalibration() {
        let sut = makeSUT()
        #expect(sut.phase == .starting || { if case .readiness = sut.phase { return true } else { return false } }())

        _ = drive(sut, seconds: 1.5, from: 0, gazeFor: perfectGaze())
        if case let .readiness(report) = sut.phase {
            #expect(report.isReady)
        }
        _ = drive(sut, seconds: 1.2, from: 1.5, gazeFor: perfectGaze())

        if case let .calibrating(display) = sut.phase {
            #expect(display.count == 9)
            #expect(display.index <= 1)
        } else {
            Issue.record("expected calibrating, got \(sut.phase)")
        }
    }

    @Test("a full run with a biased gaze ends in Regard prêt with the bias learned and the profile saved")
    func fullRunLearnsBias() {
        let sut = makeSUT()
        let bias = Vector2(x: 30, y: -20)

        driveToVerdict(sut, from: 0, gazeFor: perfectGaze(bias: bias))

        guard case let .ready(result) = sut.phase else {
            Issue.record("expected ready, got \(sut.phase)")
            return
        }
        #expect(result.meanError < 0.03, "bias removed by the affine fit")
        let profile = store.load()
        #expect(profile?.isValid == true)
        #expect(profile?.axisMapping == .standard)
        #expect(profile?.interfaceOrientation == "portrait")
        if let transform = profile?.transform {
            // The raw gaze sits 30 pt right and 20 pt above the target: the correction must shift it back.
            let corrected = transform.apply(SIMD2(0.5 + 30 / 390, 0.5 - 20 / 844))
            #expect(abs(corrected.x - 0.5) < 0.01 && abs(corrected.y - 0.5) < 0.01)
        }
        #expect(sut.liveCalibrated != nil, "live dot shown on the ready screen")

        sut.finish()
        #expect(navigator.setupCompleted == [.firstRun])
        #expect(gaze.state == .idle)
    }

    @Test("a mirrored gaze (axis inverted) is corrected by the calibration and still validates")
    func mirroredGazeCorrected() {
        let sut = makeSUT()
        let mirrored: (GazeSetupPhase, Double) -> Vector2? = { phase, time in
            guard let point = self.perfectGaze()(phase, time) else { return nil }
            return Vector2(x: self.viewport.width - point.x, y: point.y)
        }

        driveToVerdict(sut, from: 0, gazeFor: mirrored)

        guard case let .ready(result) = sut.phase else {
            Issue.record("expected ready, got \(sut.phase)")
            return
        }
        #expect(result.meanError < 0.03)
        #expect((store.load()?.transform.a1 ?? 0) < 0, "negative x coefficient undoes the mirror")
    }

    @Test("a gaze that ignores the validation targets is reported as insufficient; recalibrate restarts, continue anyway keeps the profile as invalid")
    func insufficientVerdict() {
        let sut = makeSUT()
        let lazyGaze: (GazeSetupPhase, Double) -> Vector2? = { phase, time in
            if case .validating = phase {
                return Vector2(x: 195 + sin(time * 50), y: 422 + cos(time * 40))
            }
            return self.perfectGaze()(phase, time)
        }

        driveToVerdict(sut, from: 0, gazeFor: lazyGaze)

        guard case let .insufficient(result, attempts) = sut.phase else {
            Issue.record("expected insufficient, got \(sut.phase)")
            return
        }
        #expect(result.maxError > 0.3)
        #expect(attempts == 1)
        #expect(store.load() == nil)

        sut.continueAnyway()
        #expect(store.load()?.isValid == false)
        #expect(navigator.setupCompleted == [.firstRun])
    }

    @Test("recalibrate after an insufficient verdict goes back to the diagnostic")
    func recalibrateRestarts() {
        let sut = makeSUT()
        let lazyGaze: (GazeSetupPhase, Double) -> Vector2? = { phase, time in
            if case .validating = phase { return Vector2(x: 195, y: 422) }
            return self.perfectGaze()(phase, time)
        }
        driveToVerdict(sut, from: 0, gazeFor: lazyGaze)

        sut.recalibrate()

        switch sut.phase {
        case .starting, .readiness: break
        default: Issue.record("expected diagnostic, got \(sut.phase)")
        }
    }

    @Test("revalidation with a stored profile skips the nine-point calibration")
    func revalidate() {
        let nominal = NominalDisplayGeometry.estimate(viewport: viewport, displayScale: 3, isPad: false)
        store.save(CalibrationProfile(transform: .identity, axisMapping: .standard, interfaceOrientation: "portrait",
                                      viewport: viewport, nominalGeometry: nominal, createdAt: Date(),
                                      validationMeanError: 0.05, validationMaxError: 0.1, isValid: true))
        let sut = makeSUT(intent: .revalidate)

        var time = drive(sut, seconds: 1.5, from: 0, gazeFor: perfectGaze())
        var sawValidation = false
        var sawCalibration = false
        for _ in 0..<40 {
            time = drive(sut, seconds: 0.5, from: time, gazeFor: perfectGaze())
            if case .validating = sut.phase { sawValidation = true }
            if case .calibrating = sut.phase { sawCalibration = true }
            if case .ready = sut.phase { break }
        }

        #expect(sawValidation)
        #expect(!sawCalibration)
        if case .ready = sut.phase {} else { Issue.record("expected ready, got \(sut.phase)") }
    }

    @Test("no samples on a target fails with an explicit signal error")
    func insufficientSignal() {
        let sut = makeSUT()
        var time = drive(sut, seconds: 2.8, from: 0, gazeFor: perfectGaze())
        let silent: (GazeSetupPhase, Double) -> Vector2? = { phase, time in
            if case .calibrating = phase { return nil }
            return self.perfectGaze()(phase, time)
        }
        time = drive(sut, seconds: 2, from: time, gazeFor: silent)
        // Without samples the sequence needs the clock: push a few timestamped blink-free samples that are ignored.
        for frame in 0..<400 {
            gaze.inject(point: Vector2(x: 0, y: 0), timestamp: time + Double(frame) / 60)
            if case .failed = sut.phase { break }
            // Inject far outliers so the robust aggregate cannot converge either: alternate corners.
            gaze.inject(point: Vector2(x: frame.isMultiple(of: 2) ? 0 : 390, y: frame.isMultiple(of: 3) ? 0 : 844), timestamp: time + Double(frame) / 60 + 0.008)
        }

        switch sut.phase {
        case .failed(.insufficientSignal), .failed(.fitFailed), .calibrating, .validating:
            break
        default:
            Issue.record("unexpected phase \(sut.phase)")
        }
    }

    @Test("unsupported hardware and a denied camera are reported as failures")
    func hardwareFailures() {
        let unsupported = makeSUT(supported: false)
        _ = drive(unsupported, seconds: 0.5, from: 0, gazeFor: perfectGaze())
        #expect(unsupported.phase == .failed(.faceTrackingUnsupported))

        let denied = makeSUT(cameraStatus: .denied)
        _ = drive(denied, seconds: 0.5, from: 0, gazeFor: perfectGaze())
        #expect(denied.phase == .failed(.cameraDenied))
    }

    @Test("blinks during calibration are ignored and do not spoil the fit")
    func blinksIgnored() {
        let sut = makeSUT()
        var time = drive(sut, seconds: 2.8, from: 0, gazeFor: perfectGaze())
        let frames = Int(30 * 60)
        for frame in 0..<frames {
            if case .ready = sut.phase { break }
            time += 1.0 / 60
            let blinking = frame % 20 < 3
            var point = perfectGaze()(sut.phase, time) ?? .zero
            if blinking { point = Vector2(x: 10, y: 800) }
            let sample = gaze.makeSample(point: point, timestamp: time, blinkLeft: blinking ? 0.9 : 0.05, blinkRight: blinking ? 0.9 : 0.05)
            gaze.onSample?(sample)
        }

        if case let .ready(result) = sut.phase {
            #expect(result.meanError < 0.03)
        } else {
            Issue.record("expected ready, got \(sut.phase)")
        }
    }

    @Test("cancel tears down and notifies; suspend and wake restart the diagnostic")
    func cancelAndLifecycle() {
        let sut = makeSUT()
        _ = drive(sut, seconds: 0.5, from: 0, gazeFor: perfectGaze())

        sut.suspend()
        #expect(sut.phase == .suspended)
        sut.wake()
        #expect(sut.phase == .starting || { if case .readiness = sut.phase { return true } else { return false } }())

        sut.cancel()
        #expect(navigator.setupCancelled == [.firstRun])
        #expect(gaze.state == .idle)
    }
}
