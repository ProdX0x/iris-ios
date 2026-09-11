// RobustAggregatorTests.swift
// Layer: Tests
// Purpose: Median-based aggregation with outlier rejection

import Foundation
import Testing
import simd
@testable import Iris

@Suite("RobustAggregator")
struct RobustAggregatorTests {
    @Test("a tight cluster returns its centre with no rejection")
    func cluster() {
        var samples: [SIMD2<Double>] = []
        for index in 0..<30 {
            let x: Double = 0.5 + Double(index % 3) * 0.001
            let y: Double = 0.4 - Double(index % 2) * 0.001
            samples.append(SIMD2(x, y))
        }

        let result = RobustAggregator.aggregate(samples, minimumAccepted: 10)

        #expect(result != nil)
        #expect(abs((result?.center.x ?? 0) - 0.501) < 0.002)
        #expect(result?.rejectedCount == 0)
        #expect(result?.acceptedCount == 30)
    }

    @Test("a few far outliers (a glance away) are rejected and do not move the centre")
    func outliers() {
        var samples: [SIMD2<Double>] = []
        for index in 0..<40 {
            let angle = Double(index)
            let x: Double = 0.30 + sin(angle) * 0.005
            let y: Double = 0.60 + cos(angle) * 0.005
            samples.append(SIMD2(x, y))
        }
        samples.append(SIMD2(0.9, 0.1))
        samples.append(SIMD2(0.95, 0.05))
        samples.append(SIMD2(0.1, 0.95))

        let result = RobustAggregator.aggregate(samples, minimumAccepted: 10)

        #expect(result?.rejectedCount == 3)
        #expect(abs((result?.center.x ?? 0) - 0.30) < 0.01)
        #expect(abs((result?.center.y ?? 0) - 0.60) < 0.01)
    }

    @Test("non finite samples are dropped and too few samples give nil")
    func invalid() {
        let samples = [SIMD2(0.5, 0.5), SIMD2(.nan, 0.5), SIMD2(0.5, .infinity), SIMD2(0.51, 0.5)]

        #expect(RobustAggregator.aggregate(samples, minimumAccepted: 3) == nil)
        #expect(RobustAggregator.aggregate(samples, minimumAccepted: 2)?.acceptedCount == 2)
        #expect(RobustAggregator.aggregate([], minimumAccepted: 1) == nil)
    }

    @Test("median handles odd and even counts")
    func median() {
        #expect(RobustAggregator.median([3, 1, 2]) == 2)
        #expect(RobustAggregator.median([4, 1, 2, 3]) == 2.5)
        #expect(RobustAggregator.median([]).isNaN)
    }
}
