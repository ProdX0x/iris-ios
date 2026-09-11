// CalibrationGrid.swift
// Layer: AR (calibration, pure Swift)
// Purpose: Target layouts in normalized viewport coordinates, away from the physical edges

import Foundation
import simd

enum CalibrationGrid {
    static let horizontalMargin = 0.15
    static let verticalMargin = 0.14

    /// Nine targets on a 3 x 3 grid in reading order.
    static var nine: [SIMD2<Double>] {
        let xs = [horizontalMargin, 0.5, 1 - horizontalMargin]
        let ys = [verticalMargin, 0.5, 1 - verticalMargin]
        return ys.flatMap { y in xs.map { x in SIMD2(x, y) } }
    }

    /// Five control targets: centre, left, right, top, bottom.
    static var validation: [SIMD2<Double>] {
        [SIMD2(0.5, 0.5),
         SIMD2(horizontalMargin, 0.5),
         SIMD2(1 - horizontalMargin, 0.5),
         SIMD2(0.5, verticalMargin),
         SIMD2(0.5, 1 - verticalMargin)]
    }
}
