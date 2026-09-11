// MockGameNavigating.swift
// Layer: Tests
// Purpose: Recording mock for GameNavigating, CameraAccessNavigating and GazeSetupNavigating

import Foundation
@testable import Iris

@MainActor
final class MockNavigator: GameNavigating, CameraAccessNavigating, GazeSetupNavigating {
    private(set) var startedLevels: [String] = []
    private(set) var completions: [(level: String, outcome: LevelOutcome)] = []
    private(set) var chaptersCount = 0
    private(set) var finishCampaignCount = 0
    private(set) var exitCount = 0
    private(set) var recalibrationCount = 0
    private(set) var cameraGrantedCount = 0
    private(set) var cameraAbandonedCount = 0
    private(set) var setupCompleted: [GazeSetupIntent] = []
    private(set) var setupCancelled: [GazeSetupIntent] = []
    var recordToReturn = LevelRecord()

    func gameDidStart(level: LevelDefinition) {
        startedLevels.append(level.id)
    }

    func gameDidComplete(level: LevelDefinition, outcome: LevelOutcome) -> LevelRecord {
        completions.append((level.id, outcome))
        return recordToReturn
    }

    func gameDidRequestChapters() {
        chaptersCount += 1
    }

    func gameDidFinishCampaign() {
        finishCampaignCount += 1
    }

    func gameDidRequestExit() {
        exitCount += 1
    }

    func gameDidRequestRecalibration() {
        recalibrationCount += 1
    }

    func cameraAccessGranted() {
        cameraGrantedCount += 1
    }

    func cameraAccessAbandoned() {
        cameraAbandonedCount += 1
    }

    func gazeSetupCompleted(intent: GazeSetupIntent) {
        setupCompleted.append(intent)
    }

    func gazeSetupCancelled(intent: GazeSetupIntent) {
        setupCancelled.append(intent)
    }
}
