// HeadPose.swift
// Layer: Domain
// Purpose: Head orientation the game may read (degrees, deltas only make sense within a session); provided by the
// gaze observation, nil when unknown

import Foundation

struct HeadPose: Hashable, Sendable {
    let yaw: Double
    let pitch: Double

    init(yaw: Double, pitch: Double) {
        self.yaw = yaw
        self.pitch = pitch
    }

    static let neutral = HeadPose(yaw: 0, pitch: 0)
}
