// AffineTransform2D.swift
// Layer: AR (calibration, pure Swift)
// Purpose: Six-coefficient affine correction (offset, scale, shear, axis flips) fitted by least squares

import Foundation
import simd

enum CalibrationFitError: Error, Hashable, Sendable {
    case insufficientPoints(Int)
    case nonFiniteInput
    case degenerateGeometry
}

struct AffineTransform2D: Codable, Hashable, Sendable {
    var a0: Double
    var a1: Double
    var a2: Double
    var b0: Double
    var b1: Double
    var b2: Double

    init(a0: Double, a1: Double, a2: Double, b0: Double, b1: Double, b2: Double) {
        self.a0 = a0
        self.a1 = a1
        self.a2 = a2
        self.b0 = b0
        self.b1 = b1
        self.b2 = b2
    }

    static let identity = AffineTransform2D(a0: 0, a1: 1, a2: 0, b0: 0, b1: 0, b2: 1)

    /// `x' = a0 + a1 x + a2 y`, `y' = b0 + b1 x + b2 y`
    func apply(_ point: SIMD2<Double>) -> SIMD2<Double> {
        SIMD2(a0 + a1 * point.x + a2 * point.y, b0 + b1 * point.x + b2 * point.y)
    }

    var isFinite: Bool {
        [a0, a1, a2, b0, b1, b2].allSatisfy(\.isFinite)
    }

    /// Least-squares fit of raw -> target pairs through the normal equations of a 3-parameter linear model per axis.
    /// Needs at least three pairs that are not collinear; non-finite inputs are refused.
    static func fit(_ pairs: [(raw: SIMD2<Double>, target: SIMD2<Double>)]) throws(CalibrationFitError) -> AffineTransform2D {
        guard pairs.count >= 3 else { throw .insufficientPoints(pairs.count) }
        guard pairs.allSatisfy({ NormalizedCoordinates.isFinite($0.raw) && NormalizedCoordinates.isFinite($0.target) }) else {
            throw .nonFiniteInput
        }
        var matrix = [[Double]](repeating: [Double](repeating: 0, count: 3), count: 3)
        var rhsX = [Double](repeating: 0, count: 3)
        var rhsY = [Double](repeating: 0, count: 3)
        for pair in pairs {
            let basis = [1.0, pair.raw.x, pair.raw.y]
            for row in 0..<3 {
                for column in 0..<3 {
                    matrix[row][column] += basis[row] * basis[column]
                }
                rhsX[row] += basis[row] * pair.target.x
                rhsY[row] += basis[row] * pair.target.y
            }
        }
        guard let coefficientsX = LinearSolver3.solve(matrix, rhsX), let coefficientsY = LinearSolver3.solve(matrix, rhsY) else {
            throw .degenerateGeometry
        }
        let transform = AffineTransform2D(a0: coefficientsX[0], a1: coefficientsX[1], a2: coefficientsX[2],
                                          b0: coefficientsY[0], b1: coefficientsY[1], b2: coefficientsY[2])
        guard transform.isFinite else { throw .degenerateGeometry }
        return transform
    }

    /// Euclidean residual of every pair in the target space.
    func residuals(_ pairs: [(raw: SIMD2<Double>, target: SIMD2<Double>)]) -> [Double] {
        pairs.map { simd_length(apply($0.raw) - $0.target) }
    }
}

/// Gaussian elimination with partial pivoting for a 3x3 system.
enum LinearSolver3 {
    static func solve(_ matrix: [[Double]], _ rhs: [Double]) -> [Double]? {
        var a = matrix
        var b = rhs
        let scale = max(1e-300, a.flatMap { $0 }.map { abs($0) }.max() ?? 1)
        for column in 0..<3 {
            var pivot = column
            for row in column + 1..<3 where abs(a[row][column]) > abs(a[pivot][column]) {
                pivot = row
            }
            if abs(a[pivot][column]) <= 1e-12 * scale { return nil }
            if pivot != column {
                a.swapAt(pivot, column)
                b.swapAt(pivot, column)
            }
            for row in column + 1..<3 {
                let factor = a[row][column] / a[column][column]
                for k in column..<3 {
                    a[row][k] -= factor * a[column][k]
                }
                b[row] -= factor * b[column]
            }
        }
        var solution = [Double](repeating: 0, count: 3)
        for row in stride(from: 2, through: 0, by: -1) {
            var sum = b[row]
            for k in row + 1..<3 {
                sum -= a[row][k] * solution[k]
            }
            solution[row] = sum / a[row][row]
        }
        return solution.allSatisfy(\.isFinite) ? solution : nil
    }
}
