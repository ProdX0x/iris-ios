// MockGameNavigating.swift
// Layer: Tests
// Purpose: Recording mock for GameNavigating and CameraAccessNavigating

import Foundation
@testable import Iris

@MainActor
final class MockNavigator: GameNavigating, CameraAccessNavigating, GazeSetupNavigating {
    private(set) var finishedSummaries: [JourneySummary] = []
    private(set) var exitCount = 0
    private(set) var recalibrationCount = 0
    private(set) var cameraGrantedCount = 0
    private(set) var cameraAbandonedCount = 0
    private(set) var setupCompleted: [GazeSetupIntent] = []
    private(set) var setupCancelled: [GazeSetupIntent] = []

    func gameDidFinishJourney(summary: JourneySummary) {
        finishedSummaries.append(summary)
    }

    func gameDidRequestExit() {
        exitCount += 1
    }

    func gameDidRequestRecalibration() {
        recalibrationCount += 1
    }

    func gazeSetupCompleted(intent: GazeSetupIntent) {
        setupCompleted.append(intent)
    }

    func gazeSetupCancelled(intent: GazeSetupIntent) {
        setupCancelled.append(intent)
    }

    func cameraAccessGranted() {
        cameraGrantedCount += 1
    }

    func cameraAccessAbandoned() {
        cameraAbandonedCount += 1
    }
}
