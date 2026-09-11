// GazeRay.swift
// Layer: AR (pure Swift)
// Purpose: Intersection of the eye-to-lookAtPoint ray with the device plane (z = 0 of the interface-oriented camera
// frame). Makes no assumption about which side of the plane the face is on or about the sign of the in-plane axes.

import Foundation
import simd

enum GazeRay {
    /// Returns the in-plane hit point (metres) of the ray from `eyeOrigin` through `lookAt`, or nil when the ray
    /// does not travel toward the plane (looking away) or when inputs are not finite.
    static func planeHit(eyeOrigin: SIMD3<Double>, lookAt: SIMD3<Double>) -> SIMD2<Double>? {
        guard eyeOrigin.x.isFinite, eyeOrigin.y.isFinite, eyeOrigin.z.isFinite,
              lookAt.x.isFinite, lookAt.y.isFinite, lookAt.z.isFinite else { return nil }
        let direction = lookAt - eyeOrigin
        guard abs(direction.z) > 1e-9, abs(eyeOrigin.z) > 1e-6 else { return nil }
        let travel = -eyeOrigin.z / direction.z
        guard travel > 0, travel.isFinite else { return nil }
        let hit = eyeOrigin + direction * travel
        guard hit.x.isFinite, hit.y.isFinite else { return nil }
        return SIMD2(hit.x, hit.y)
    }
}
