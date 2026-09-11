// RobustAggregator.swift
// Layer: AR (calibration, pure Swift)
// Purpose: Median-based fixation estimate with MAD outlier rejection, so a blink or a glance never skews a point

import Foundation
import simd

enum RobustAggregator {
    struct Result: Hashable, Sendable {
        /// Mean of the accepted samples (trimmed mean around the per-axis median).
        let center: SIMD2<Double>
        let acceptedCount: Int
        let rejectedCount: Int
        /// Root mean square distance of accepted samples to the centre (normalized units).
        let dispersion: Double
    }

    /// - madMultiplier: samples farther than this many median absolute deviations from the median are rejected.
    /// - madFloor: minimum tolerated deviation so that an extremely tight cluster never rejects everything.
    static func aggregate(_ samples: [SIMD2<Double>], madMultiplier: Double = 3.5, madFloor: Double = 0.01,
                          minimumAccepted: Int) -> Result? {
        let finite = samples.filter(NormalizedCoordinates.isFinite)
        guard finite.count >= minimumAccepted, finite.count > 0 else { return nil }
        let medianX = median(finite.map(\.x))
        let medianY = median(finite.map(\.y))
        let deviations = finite.map { simd_length($0 - SIMD2(medianX, medianY)) }
        let mad = max(median(deviations), madFloor)
        let accepted = zip(finite, deviations).filter { $0.1 <= madMultiplier * mad }.map(\.0)
        guard accepted.count >= minimumAccepted else { return nil }
        let sum = accepted.reduce(SIMD2<Double>(0, 0), +)
        let center = sum / Double(accepted.count)
        let squared = accepted.reduce(0.0) { $0 + simd_length_squared($1 - center) }
        return Result(center: center,
                      acceptedCount: accepted.count,
                      rejectedCount: finite.count - accepted.count,
                      dispersion: (squared / Double(accepted.count)).squareRoot())
    }

    static func median(_ values: [Double]) -> Double {
        guard !values.isEmpty else { return .nan }
        let sorted = values.sorted()
        let middle = sorted.count / 2
        return sorted.count.isMultiple(of: 2) ? (sorted[middle - 1] + sorted[middle]) / 2 : sorted[middle]
    }
}
