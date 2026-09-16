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
    /// May the campaign continue into this level? The game asks; it never knows what decides the answer.
    func gameMayContinue(to level: LevelDefinition) -> Bool
    /// The campaign continues into a level this player may not open: the navigator takes over.
    func gameDidReachLockedLevel(_ level: LevelDefinition)
    /// Has the player finished the levels that teach the gaze marker? The game asks; it never knows why.
    func gameHasCompletedGazeLearning() -> Bool
    func gameDidRequestChapters()
    func gameDidFinishCampaign()
    func gameDidRequestExit()
    func gameDidRequestRecalibration()
}
