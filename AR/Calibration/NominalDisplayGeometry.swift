// NominalDisplayGeometry.swift
// Layer: AR (calibration, pure Swift)
// Purpose: Rough physical model of the screen used ONLY as a first guess before calibration and for the
// uncalibrated diagnostic dot. The calibrated path never depends on these numbers: the affine calibration
// learns the real scale and offset on top of this nominal frame.

import Foundation
import simd

struct NominalDisplayGeometry: Codable, Hashable, Sendable {
    /// Nominal physical size of one point in metres.
    var metersPerPoint: Double
    /// Nominal camera position in viewport points (top centre of the screen).
    var cameraOrigin: Vector2

    init(metersPerPoint: Double, cameraOrigin: Vector2) {
        self.metersPerPoint = metersPerPoint
        self.cameraOrigin = cameraOrigin
    }

    /// Order-of-magnitude estimate from the display scale and idiom (3x iPhones about 460 ppi, 2x iPhones 326 ppi,
    /// iPads 264 ppi). A few percent of error is expected and absorbed by the calibration.
    static func estimate(viewport: PlayfieldBounds, displayScale: Double, isPad: Bool) -> NominalDisplayGeometry {
        let pixelsPerInch: Double
        if isPad {
            pixelsPerInch = viewport.width <= 744 ? 326 : 264
        } else {
            pixelsPerInch = displayScale >= 2.5 ? 460 : 326
        }
        let metersPerPoint = displayScale * 0.0254 / pixelsPerInch
        let cameraY: Double = isPad ? -40 : 12
        return NominalDisplayGeometry(metersPerPoint: metersPerPoint, cameraOrigin: Vector2(x: viewport.width / 2, y: cameraY))
    }

    /// Nominal normalized viewport coordinates (0...1 inside the screen) of a point `right` metres to the right
    /// of the camera and `up` metres above it.
    func normalized(right: Double, up: Double, viewport: PlayfieldBounds) -> SIMD2<Double> {
        let x = (cameraOrigin.x + right / metersPerPoint) / viewport.width
        let y = (cameraOrigin.y - up / metersPerPoint) / viewport.height
        return SIMD2(x, y)
    }

    /// Inverse of `normalized(right:up:viewport:)`.
    func planeOffsets(normalized: SIMD2<Double>, viewport: PlayfieldBounds) -> (right: Double, up: Double) {
        let right = (normalized.x * viewport.width - cameraOrigin.x) * metersPerPoint
        let up = (cameraOrigin.y - normalized.y * viewport.height) * metersPerPoint
        return (right, up)
    }
}
