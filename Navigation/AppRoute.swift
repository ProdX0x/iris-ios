// AppRoute.swift
// Layer: Presentation (Navigation)
// Purpose: Every top-level screen of Iris as one explicit state

import Foundation

struct JourneySummary: Hashable, Sendable {
    let levelCount: Int
    let playDuration: TimeInterval
    let eclats: Int
    let maxEclats: Int

    init(levelCount: Int, playDuration: TimeInterval, eclats: Int, maxEclats: Int) {
        self.levelCount = levelCount
        self.playDuration = playDuration
        self.eclats = eclats
        self.maxEclats = maxEclats
    }
}

enum DeviceUnavailability: Hashable, Sendable {
    case faceTrackingUnsupported
}

enum AppRoute: Hashable, Sendable {
    case home
    case cameraAccess
    case gazeSetup(GazeSetupIntent)
    case chapters
    case carnet
    case game
    case journeyComplete(JourneySummary)
    case unavailable(DeviceUnavailability)
}
