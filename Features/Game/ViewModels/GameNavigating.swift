// GameNavigating.swift
// Layer: Presentation
// Purpose: Navigation intents emitted by the game screen

import Foundation

@MainActor
protocol GameNavigating: AnyObject {
    func gameDidFinishJourney(summary: JourneySummary)
    func gameDidRequestExit()
    func gameDidRequestRecalibration()
}
