// CalibrationProfileTests.swift
// Layer: Tests
// Purpose: Persistence and compatibility rules of the calibration profile

import Foundation
import Testing
@testable import Iris

@Suite("CalibrationProfile")
struct CalibrationProfileTests {
    private let viewport = PlayfieldBounds.referencePhone
    private let nominal = NominalDisplayGeometry.estimate(viewport: .referencePhone, displayScale: 3, isPad: false)
    private let now = Date(timeIntervalSince1970: 1_800_000_000)

    private func profile(version: Int = CalibrationProfile.currentVersion, isValid: Bool = true, age: TimeInterval = 0,
                         orientation: String = "portrait", viewport: PlayfieldBounds? = nil) -> CalibrationProfile {
        CalibrationProfile(version: version,
                           transform: AffineTransform2D(a0: 0.01, a1: 1.02, a2: 0, b0: -0.02, b1: 0, b2: 0.98),
                           axisMapping: .standard,
                           interfaceOrientation: orientation,
                           viewport: viewport ?? self.viewport,
                           nominalGeometry: nominal,
                           createdAt: now.addingTimeInterval(-age),
                           validationMeanError: 0.08,
                           validationMaxError: 0.14,
                           isValid: isValid)
    }

    @Test("save then load round trips through the in-memory and UserDefaults stores")
    func roundTrip() {
        let original = profile()
        let memory = InMemoryCalibrationStore()
        let defaults = UserDefaultsCalibrationStore(defaults: UserDefaults(suiteName: "iris.tests.calibration.\(UUID().uuidString)") ?? .standard)

        memory.save(original)
        defaults.save(original)

        #expect(memory.load() == original)
        #expect(defaults.load() == original)
        memory.clear()
        defaults.clear()
        #expect(memory.load() == nil)
        #expect(defaults.load() == nil)
    }

    @Test("a fresh valid profile for the same viewport and orientation is compatible")
    func compatible() {
        #expect(profile().isCompatible(viewport: viewport, interfaceOrientation: "portrait", now: now))
        #expect(profile(age: 3600 * 24 * 10).isCompatible(viewport: viewport, interfaceOrientation: "portrait", now: now))
    }

    @Test("version mismatch, invalidation, other orientation, other viewport or old age make it incompatible")
    func incompatible() {
        #expect(!profile(version: 0).isCompatible(viewport: viewport, interfaceOrientation: "portrait", now: now))
        #expect(!profile(isValid: false).isCompatible(viewport: viewport, interfaceOrientation: "portrait", now: now))
        #expect(!profile().isCompatible(viewport: viewport, interfaceOrientation: "landscapeLeft", now: now))
        #expect(!profile().isCompatible(viewport: PlayfieldBounds(width: 430, height: 932), interfaceOrientation: "portrait", now: now))
        #expect(!profile(age: 3600 * 24 * 40).isCompatible(viewport: viewport, interfaceOrientation: "portrait", now: now))
    }

    @Test("a small viewport difference (safe area rounding) is tolerated")
    func tolerance() {
        #expect(profile().isCompatible(viewport: PlayfieldBounds(width: 392, height: 846), interfaceOrientation: "portrait", now: now))
    }

    @Test("the mapper built from a profile applies its transform")
    func mapperFromProfile() {
        let service = SimulatedGazeTrackingServiceProbe.makeSample(point: Vector2(x: 195, y: 422), viewport: viewport, nominal: nominal)
        let mapper = GazeMapper(viewport: viewport, profile: profile())

        let raw = mapper.nominalNormalized(service)
        let calibrated = mapper.calibratedNormalized(service)

        #expect(raw != nil && calibrated != nil)
        if let raw, let calibrated {
            #expect(abs(raw.x - 0.5) < 1e-9 && abs(raw.y - 0.5) < 1e-9)
            #expect(abs(calibrated.x - (0.01 + 1.02 * 0.5)) < 1e-9)
            #expect(abs(calibrated.y - (-0.02 + 0.98 * 0.5)) < 1e-9)
        }
        #expect(mapper.isCalibrated)
    }
}

/// Builds raw samples the way the simulated service does, without needing a main-actor instance.
enum SimulatedGazeTrackingServiceProbe {
    static func makeSample(point: Vector2, viewport: PlayfieldBounds, nominal: NominalDisplayGeometry,
                           timestamp: TimeInterval = 0, blinkLeft: Double = 0, blinkRight: Double = 0,
                           eyeOrigin: SIMD3<Double> = SIMD3(0, 0, -0.35), eyeSeparation: Double = 0.063,
                           hasBlendShapes: Bool = true) -> RawGazeSample {
        let normalized = NormalizedCoordinates.normalized(point, in: viewport)
        let offsets = nominal.planeOffsets(normalized: normalized, viewport: viewport)
        let hit = AxisMapping.standard.planePoint(right: offsets.right, up: offsets.up)
        return RawGazeSample(timestamp: timestamp, planeHit: hit, eyeOrigin: eyeOrigin, eyeSeparation: eyeSeparation,
                             userRight: SIMD2(1, 0), deviceUp: SIMD2(0, 1), faceUp: SIMD2(0, 1),
                             blinkLeft: blinkLeft, blinkRight: blinkRight, hasBlendShapes: hasBlendShapes)
    }
}
