// AxisMapping.swift
// Layer: AR (calibration, pure Swift)
// Purpose: Which in-plane camera axes are the screen's right and up, resolved from the user's eyes and gravity
// instead of from assumptions about ARKit's front-camera conventions

import Foundation
import simd

struct AxisMapping: Codable, Hashable, Sendable {
    var right: DeviceAxis
    var up: DeviceAxis

    init(right: DeviceAxis, up: DeviceAxis) {
        self.right = right
        self.up = up
    }

    /// The mapping one would assume for a view frame with x to the right and y up.
    static let standard = AxisMapping(right: .positiveX, up: .positiveY)

    /// Metres to the right and up of the camera for a device-plane point.
    func screenCoordinates(of planePoint: SIMD2<Double>) -> SIMD2<Double> {
        SIMD2(right.component(of: planePoint), up.component(of: planePoint))
    }

    /// Inverse of `screenCoordinates` (used by the simulator).
    func planePoint(right rightMetres: Double, up upMetres: Double) -> SIMD2<Double> {
        right.vector * rightMetres + up.vector * upMetres
    }

    /// True when (right, up, toward the user) form a right-handed frame; recorded for diagnostics only.
    var isRightHanded: Bool {
        right.vector.x * up.vector.y - right.vector.y * up.vector.x > 0
    }
}

enum AxisResolver {
    /// - userRight: from the user's left eye to their right eye, projected on the device plane (any length).
    /// - deviceUp: direction opposite to gravity projected on the device plane; near zero when the device lies flat.
    /// - faceUp: fallback up direction derived from the face, used when gravity is degenerate.
    /// Returns nil when a direction is too short to be trusted or when both map to the same physical axis.
    static func resolve(userRight: SIMD2<Double>, deviceUp: SIMD2<Double>, faceUp: SIMD2<Double>,
                        minimumLength: Double = 0.2) -> AxisMapping? {
        guard let right = dominantAxis(of: userRight, minimumLength: minimumLength) else { return nil }
        let upSource = simd_length(deviceUp) >= minimumLength ? deviceUp : faceUp
        guard let up = dominantAxis(of: upSource, minimumLength: minimumLength), up.isHorizontal != right.isHorizontal else {
            return nil
        }
        return AxisMapping(right: right, up: up)
    }

    static func dominantAxis(of direction: SIMD2<Double>, minimumLength: Double) -> DeviceAxis? {
        guard direction.x.isFinite, direction.y.isFinite, simd_length(direction) >= minimumLength else { return nil }
        if abs(direction.x) >= abs(direction.y) {
            return direction.x >= 0 ? .positiveX : .negativeX
        }
        return direction.y >= 0 ? .positiveY : .negativeY
    }
}

/// Majority vote over many frames so that a momentary head tilt never flips the mapping.
struct AxisVote: Hashable, Sendable {
    private var counts: [AxisMapping: Int] = [:]
    private(set) var total = 0

    init() {}

    mutating func add(_ mapping: AxisMapping) {
        counts[mapping, default: 0] += 1
        total += 1
    }

    mutating func reset() {
        counts.removeAll()
        total = 0
    }

    var majority: AxisMapping? {
        counts.max { lhs, rhs in lhs.value < rhs.value }?.key
    }

    /// Share of votes won by the majority mapping (0 when empty).
    var confidence: Double {
        guard total > 0, let majority, let count = counts[majority] else { return 0 }
        return Double(count) / Double(total)
    }
}
