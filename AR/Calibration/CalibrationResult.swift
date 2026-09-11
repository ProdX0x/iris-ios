// CalibrationResult.swift
// Layer: AR (calibration, pure Swift)
// Purpose: Outcome of a calibration fit and of a validation pass

import Foundation
import simd

struct CalibrationResult: Hashable, Sendable {
    let transform: AffineTransform2D
    /// Residuals of the fitted points in normalized units.
    let residualMean: Double
    let residualMax: Double
    let pointCount: Int

    init(transform: AffineTransform2D, residualMean: Double, residualMax: Double, pointCount: Int) {
        self.transform = transform
        self.residualMean = residualMean
        self.residualMax = residualMax
        self.pointCount = pointCount
    }

    static func fit(pairs: [(raw: SIMD2<Double>, target: SIMD2<Double>)]) throws(CalibrationFitError) -> CalibrationResult {
        let transform = try AffineTransform2D.fit(pairs)
        let residuals = transform.residuals(pairs)
        return CalibrationResult(transform: transform,
                                 residualMean: residuals.reduce(0, +) / Double(max(residuals.count, 1)),
                                 residualMax: residuals.max() ?? 0,
                                 pointCount: pairs.count)
    }
}

struct ValidationResult: Hashable, Sendable {
    struct Measurement: Hashable, Sendable {
        let target: SIMD2<Double>
        let measured: SIMD2<Double>
        /// Error in points divided by the shorter viewport side.
        let error: Double
    }

    let measurements: [Measurement]
    let meanError: Double
    let maxError: Double

    init(measurements: [Measurement]) {
        self.measurements = measurements
        let errors = measurements.map(\.error)
        meanError = errors.reduce(0, +) / Double(max(errors.count, 1))
        maxError = errors.max() ?? 0
    }

    init(pairs: [(measured: SIMD2<Double>, target: SIMD2<Double>)], viewport: PlayfieldBounds) {
        self.init(measurements: pairs.map {
            Measurement(target: $0.target, measured: $0.measured,
                        error: NormalizedCoordinates.error(between: $0.measured, and: $0.target, in: viewport))
        })
    }
}

/// Accepts a calibration when the validation error stays within a fraction of the shorter screen side.
/// 18 percent mean / 30 percent max: tolerant to ARKit's few-centimetre gaze accuracy, strict enough to reject
/// an inverted axis (errors above 50 percent) or a wrong scale.
struct GazeQualityCriteria: Hashable, Sendable {
    var meanErrorLimit: Double
    var maxErrorLimit: Double

    init(meanErrorLimit: Double = 0.18, maxErrorLimit: Double = 0.30) {
        self.meanErrorLimit = meanErrorLimit
        self.maxErrorLimit = maxErrorLimit
    }

    func accepts(_ result: ValidationResult) -> Bool {
        result.meanError.isFinite && result.maxError.isFinite
            && result.meanError <= meanErrorLimit && result.maxError <= maxErrorLimit
    }
}
