// GazeMapper.swift
// Layer: AR (calibration, pure Swift)
// Purpose: Raw metric sample -> axis-resolved plane offsets -> nominal normalized -> affine calibration -> points

import Foundation
import simd

struct GazeMapper: Hashable, Sendable {
    var viewport: PlayfieldBounds
    var nominal: NominalDisplayGeometry
    var axisMapping: AxisMapping
    var calibration: AffineTransform2D?
    /// Points farther than this fraction of the viewport outside its edges are clamped.
    var overshoot: Double = 0.5

    init(viewport: PlayfieldBounds, nominal: NominalDisplayGeometry, axisMapping: AxisMapping = .standard,
         calibration: AffineTransform2D? = nil) {
        self.viewport = viewport
        self.nominal = nominal
        self.axisMapping = axisMapping
        self.calibration = calibration
    }

    init(viewport: PlayfieldBounds, profile: CalibrationProfile) {
        self.init(viewport: viewport, nominal: profile.nominalGeometry, axisMapping: profile.axisMapping,
                  calibration: profile.transform)
    }

    var isCalibrated: Bool { calibration != nil }

    /// Uncalibrated position (nominal frame), used for the raw diagnostic dot and as calibration input.
    func nominalNormalized(_ sample: RawGazeSample) -> SIMD2<Double>? {
        guard let hit = sample.planeHit else { return nil }
        let offsets = axisMapping.screenCoordinates(of: hit)
        let normalized = nominal.normalized(right: offsets.x, up: offsets.y, viewport: viewport)
        return NormalizedCoordinates.isFinite(normalized) ? normalized : nil
    }

    /// Calibrated position when a transform exists, nominal otherwise.
    func calibratedNormalized(_ sample: RawGazeSample) -> SIMD2<Double>? {
        guard let raw = nominalNormalized(sample) else { return nil }
        guard let calibration else { return raw }
        let corrected = calibration.apply(raw)
        return NormalizedCoordinates.isFinite(corrected) ? corrected : nil
    }

    func screenPoint(normalized: SIMD2<Double>) -> Vector2 {
        let point = NormalizedCoordinates.points(normalized, in: viewport)
        let marginX = viewport.width * overshoot
        let marginY = viewport.height * overshoot
        return Vector2(x: min(max(point.x, -marginX), viewport.width + marginX),
                       y: min(max(point.y, -marginY), viewport.height + marginY))
    }

    /// Calibrated, clamped playfield point.
    func screenPoint(_ sample: RawGazeSample) -> Vector2? {
        calibratedNormalized(sample).map(screenPoint(normalized:))
    }

    /// Uncalibrated, clamped playfield point (diagnostics).
    func rawScreenPoint(_ sample: RawGazeSample) -> Vector2? {
        nominalNormalized(sample).map(screenPoint(normalized:))
    }
}
