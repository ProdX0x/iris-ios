// AffineTransform2DTests.swift
// Layer: Tests
// Purpose: Affine calibration model: identity, offsets, scales, flips, synthetic recovery, residuals, failures

import Foundation
import Testing
import simd
@testable import Iris

@Suite("AffineTransform2D")
struct AffineTransform2DTests {
    private let grid = CalibrationGrid.nine

    private func pairs(applying transform: AffineTransform2D, noise: Double = 0) -> [(raw: SIMD2<Double>, target: SIMD2<Double>)] {
        grid.enumerated().map { index, target in
            // raw = inverse image of target under `transform`; here we generate raw first and compute target.
            let raw = target
            var mapped = transform.apply(raw)
            if noise > 0 {
                let angle = Double(index) * 1.3
                mapped += SIMD2(cos(angle), sin(angle)) * noise
            }
            return (raw, mapped)
        }
    }

    private func expectClose(_ lhs: AffineTransform2D, _ rhs: AffineTransform2D, tolerance: Double = 1e-9) {
        #expect(abs(lhs.a0 - rhs.a0) < tolerance)
        #expect(abs(lhs.a1 - rhs.a1) < tolerance)
        #expect(abs(lhs.a2 - rhs.a2) < tolerance)
        #expect(abs(lhs.b0 - rhs.b0) < tolerance)
        #expect(abs(lhs.b1 - rhs.b1) < tolerance)
        #expect(abs(lhs.b2 - rhs.b2) < tolerance)
    }

    @Test("identity is recovered from an exact grid")
    func identity() throws {
        let fitted = try AffineTransform2D.fit(pairs(applying: .identity))

        expectClose(fitted, .identity)
        #expect(fitted.residuals(pairs(applying: .identity)).allSatisfy { $0 < 1e-9 })
    }

    @Test("pure offsets on x and y are recovered")
    func offsets() throws {
        let offsetX = AffineTransform2D(a0: 0.08, a1: 1, a2: 0, b0: 0, b1: 0, b2: 1)
        let offsetY = AffineTransform2D(a0: 0, a1: 1, a2: 0, b0: -0.05, b1: 0, b2: 1)

        expectClose(try AffineTransform2D.fit(pairs(applying: offsetX)), offsetX)
        expectClose(try AffineTransform2D.fit(pairs(applying: offsetY)), offsetY)
    }

    @Test("scales on x and y are recovered")
    func scales() throws {
        let scaleX = AffineTransform2D(a0: -0.1, a1: 1.3, a2: 0, b0: 0, b1: 0, b2: 1)
        let scaleY = AffineTransform2D(a0: 0, a1: 1, a2: 0, b0: 0.2, b1: 0, b2: 0.7)

        expectClose(try AffineTransform2D.fit(pairs(applying: scaleX)), scaleX)
        expectClose(try AffineTransform2D.fit(pairs(applying: scaleY)), scaleY)
    }

    @Test("a full affine combination with shear and an axis flip is recovered")
    func combination() throws {
        let transform = AffineTransform2D(a0: 0.9, a1: -1.1, a2: 0.15, b0: -0.05, b1: 0.08, b2: 1.2)

        expectClose(try AffineTransform2D.fit(pairs(applying: transform)), transform)
    }

    @Test("an inverted axis (mirror) is corrected by the fit")
    func mirrorCorrection() throws {
        let mirror = AffineTransform2D(a0: 1, a1: -1, a2: 0, b0: 0, b1: 0, b2: 1)
        let fitted = try AffineTransform2D.fit(pairs(applying: mirror))

        let corrected = fitted.apply(SIMD2(0.2, 0.3))
        #expect(abs(corrected.x - 0.8) < 1e-9)
        #expect(abs(corrected.y - 0.3) < 1e-9)
    }

    @Test("noisy synthetic data gives small residuals and near coefficients")
    func noisyRecovery() throws {
        let transform = AffineTransform2D(a0: 0.05, a1: 0.9, a2: 0.02, b0: -0.03, b1: -0.01, b2: 1.1)
        let noisy = pairs(applying: transform, noise: 0.01)

        let fitted = try AffineTransform2D.fit(noisy)
        let residuals = fitted.residuals(noisy)

        expectClose(fitted, transform, tolerance: 0.05)
        #expect(residuals.max() ?? 1 < 0.02)
        #expect(residuals.reduce(0, +) / 9 < 0.012)
    }

    @Test("fewer than three points is refused")
    func insufficient() {
        #expect(throws: CalibrationFitError.insufficientPoints(2)) {
            try AffineTransform2D.fit([(SIMD2(0, 0), SIMD2(0, 0)), (SIMD2(1, 1), SIMD2(1, 1))])
        }
    }

    @Test("non finite input is refused")
    func nonFinite() {
        let bad: [(raw: SIMD2<Double>, target: SIMD2<Double>)] = [(SIMD2(0, 0), SIMD2(0, 0)), (SIMD2(1, 0), SIMD2(.nan, 0)), (SIMD2(0, 1), SIMD2(0, 1))]

        #expect(throws: CalibrationFitError.nonFiniteInput) { try AffineTransform2D.fit(bad) }
    }

    @Test("collinear points are degenerate")
    func degenerate() {
        let line: [(raw: SIMD2<Double>, target: SIMD2<Double>)] = (0..<9).map { index in
            let t = Double(index) / 8
            return (SIMD2(t, t), SIMD2(t, t))
        }

        #expect(throws: CalibrationFitError.degenerateGeometry) { try AffineTransform2D.fit(line) }
    }

    @Test("CalibrationResult reports mean and max residual")
    func result() throws {
        let transform = AffineTransform2D(a0: 0.02, a1: 1.05, a2: 0, b0: 0, b1: 0, b2: 0.95)
        let result = try CalibrationResult.fit(pairs: pairs(applying: transform, noise: 0.005))

        #expect(result.pointCount == 9)
        #expect(result.residualMean <= result.residualMax)
        #expect(result.residualMax < 0.01)
    }
}
