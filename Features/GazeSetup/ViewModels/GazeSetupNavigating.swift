// GazeSetupNavigating.swift
// Layer: Presentation
// Purpose: Navigation intents emitted by the gaze setup screen

import Foundation

@MainActor
protocol GazeSetupNavigating: AnyObject {
    func gazeSetupCompleted(intent: GazeSetupIntent)
    func gazeSetupCancelled(intent: GazeSetupIntent)
}
