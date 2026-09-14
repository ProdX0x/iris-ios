// HeadPose.swift
// Layer: Domain
// Purpose: Head orientation the game may read (degrees, deltas only make sense within a session); provided by the
// gaze observation, oriented like the screen by the calibration's axis mapping, nil when unknown

import Foundation

struct HeadPose: Hashable, Sendable {
    /// Positive when the face turns toward the right of the screen, as the player sees it.
    let yaw: Double
    /// Positive when the face turns toward the top of the screen.
    let pitch: Double

    init(yaw: Double, pitch: Double) {
        self.yaw = yaw
        self.pitch = pitch
    }

    static let neutral = HeadPose(yaw: 0, pitch: 0)
}
