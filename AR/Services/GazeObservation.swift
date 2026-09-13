// GazeObservation.swift
// Layer: AR
// Purpose: PROTOTYPE observation only: head orientation and eye geometry ARKit already provides for every frame,
// exposed next to the gaze sample for DEBUG traces. Nothing in the gaze computation reads it.

import Foundation
import simd

struct GazeObservation: Hashable, Sendable {
    /// Head orientation in the interface-oriented camera view frame, degrees. Yaw is positive when the face turns
    /// toward the view's +x, pitch positive when it turns toward +y, roll positive when the face's up axis leans
    /// toward +x. Signs are a convention for deltas, not a clinical measure.
    let headYaw: Double
    let headPitch: Double
    let headRoll: Double
    /// Eye centres and ARKit's look-at point, view frame, metres.
    let leftEye: SIMD3<Double>
    let rightEye: SIMD3<Double>
    let lookAt: SIMD3<Double>

    init(headYaw: Double, headPitch: Double, headRoll: Double, leftEye: SIMD3<Double>, rightEye: SIMD3<Double>, lookAt: SIMD3<Double>) {
        self.headYaw = headYaw
        self.headPitch = headPitch
        self.headRoll = headRoll
        self.leftEye = leftEye
        self.rightEye = rightEye
        self.lookAt = lookAt
    }
}
