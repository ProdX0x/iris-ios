// GameNavigating.swift
// Layer: Presentation
// Purpose: Intents and progress reports emitted by the game screen

import Foundation

@MainActor
protocol GameNavigating: AnyObject {
    /// A level is loaded (its new elements become known to the Carnet).
    func gameDidStart(level: LevelDefinition)
    /// A level is completed; the navigator records the outcome and returns the record as it was before.
    func gameDidComplete(level: LevelDefinition, outcome: LevelOutcome) -> LevelRecord
    func gameDidRequestChapters()
    func gameDidFinishCampaign()
    func gameDidRequestExit()
    func gameDidRequestRecalibration()
}
