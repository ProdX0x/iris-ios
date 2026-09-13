// ARKitGazeTrackingService+Observation.swift
// Layer: AR
// Purpose: PROTOTYPE observation only: derives head yaw, pitch and roll from the face anchor's rotation in the view
// frame, next to the eye positions the service already computes. Pure geometry, no effect on the gaze sample.

import Foundation
import simd

extension ARKitGazeTrackingService {
    /// The face anchor's +z axis points out of the face toward the camera; its +y axis is the face's up.
    static func observation(anchorToView: simd_float4x4, leftEye: SIMD3<Double>, rightEye: SIMD3<Double>, lookAt: SIMD3<Double>) -> GazeObservation {
        let forward = anchorToView * SIMD4<Float>(0, 0, 1, 0)
        let up = anchorToView * SIMD4<Float>(0, 1, 0, 0)
        let fx = Double(forward.x), fy = Double(forward.y), fz = Double(forward.z)
        let yaw = atan2(fx, fz) * 180 / .pi
        let pitch = atan2(fy, (fx * fx + fz * fz).squareRoot()) * 180 / .pi
        let roll = atan2(Double(up.x), Double(up.y)) * 180 / .pi
        return GazeObservation(headYaw: yaw, headPitch: pitch, headRoll: roll, leftEye: leftEye, rightEye: rightEye, lookAt: lookAt)
    }
}
