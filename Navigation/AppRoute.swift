// AppRoute.swift
// Layer: Presentation (Navigation)
// Purpose: Every top-level screen of Iris as one explicit state

import Foundation

struct JourneySummary: Hashable, Sendable {
    let levelCount: Int
    let playDuration: TimeInterval

    init(levelCount: Int, playDuration: TimeInterval) {
        self.levelCount = levelCount
        self.playDuration = playDuration
    }
}

enum DeviceUnavailability: Hashable, Sendable {
    case faceTrackingUnsupported
}

enum AppRoute: Hashable, Sendable {
    case home
    case cameraAccess
    case gazeSetup(GazeSetupIntent)
    case tutorial
    case game
    case journeyComplete(JourneySummary)
    case unavailable(DeviceUnavailability)
}
