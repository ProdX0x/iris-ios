// NormalizedCoordinatesTests.swift
// Layer: Tests
// Purpose: Points to normalized conversions on several viewports

import Foundation
import Testing
import simd
@testable import Iris

@Suite("NormalizedCoordinates")
struct NormalizedCoordinatesTests {
    private let viewports = [PlayfieldBounds(width: 390, height: 844), PlayfieldBounds(width: 430, height: 932), PlayfieldBounds(width: 834, height: 1194)]

    @Test("corners and centre map to 0, 0.5 and 1 on every viewport")
    func corners() {
        for viewport in viewports {
            #expect(NormalizedCoordinates.normalized(Vector2(x: 0, y: 0), in: viewport) == SIMD2(0, 0))
            #expect(NormalizedCoordinates.normalized(Vector2(x: viewport.width, y: viewport.height), in: viewport) == SIMD2(1, 1))
            let centre = NormalizedCoordinates.normalized(viewport.center, in: viewport)
            #expect(abs(centre.x - 0.5) < 1e-12 && abs(centre.y - 0.5) < 1e-12)
        }
    }

    @Test("round trip is exact")
    func roundTrip() {
        for viewport in viewports {
            let point = Vector2(x: 123.4, y: 567.8)
            let back = NormalizedCoordinates.points(NormalizedCoordinates.normalized(point, in: viewport), in: viewport)
            #expect(abs(back.x - point.x) < 1e-9 && abs(back.y - point.y) < 1e-9)
        }
    }

    @Test("error is measured in points relative to the short side")
    func error() {
        let viewport = PlayfieldBounds(width: 400, height: 800)
        let error = NormalizedCoordinates.error(between: SIMD2(0.5, 0.5), and: SIMD2(0.6, 0.55), in: viewport)

        #expect(abs(error - ((40.0 * 40 + 40 * 40).squareRoot() / 400)) < 1e-12)
        #expect(!NormalizedCoordinates.isFinite(SIMD2(.nan, 0)))
    }

    @Test("the nine-point grid and validation targets stay inside the margins")
    func grids() {
        #expect(CalibrationGrid.nine.count == 9)
        #expect(CalibrationGrid.validation.count == 5)
        for target in CalibrationGrid.nine + CalibrationGrid.validation {
            #expect(target.x >= 0.15 && target.x <= 0.85)
            #expect(target.y >= 0.14 && target.y <= 0.86)
        }
        #expect(CalibrationGrid.nine[4] == SIMD2(0.5, 0.5))
    }
}
