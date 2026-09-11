// DeviceAxis.swift
// Layer: AR (calibration, pure Swift)
// Purpose: One of the four in-plane directions of the interface-oriented camera frame

import Foundation
import simd

enum DeviceAxis: String, Codable, Hashable, Sendable, CaseIterable {
    case positiveX
    case negativeX
    case positiveY
    case negativeY

    var vector: SIMD2<Double> {
        switch self {
        case .positiveX: SIMD2(1, 0)
        case .negativeX: SIMD2(-1, 0)
        case .positiveY: SIMD2(0, 1)
        case .negativeY: SIMD2(0, -1)
        }
    }

    var isHorizontal: Bool { self == .positiveX || self == .negativeX }

    /// Signed length of `point` along this axis.
    func component(of point: SIMD2<Double>) -> Double {
        simd_dot(point, vector)
    }
}
