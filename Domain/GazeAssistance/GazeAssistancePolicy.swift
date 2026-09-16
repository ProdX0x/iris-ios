// GazeAssistancePolicy.swift
// Layer: Domain
// Purpose: THE single place that decides how visible the gaze marker is. It takes the player's mode, where they
// are in the campaign and how long the level has really been played, and returns a presentation. No view asks
// "is this chapter one, level three"; they ask this

import Foundation

enum GazeAssistancePolicy {
    // MARK: The constants, gathered so a human test can move them in one place

    /// GUIDED: one appearance every `guidedPeriod`, visible for `guidedHold`, with `guidedFade` in and out.
    /// Chosen to help a player re-centre without becoming a blinking light: roughly one gentle breath every six
    /// seconds. Deterministic, so a test can assert it exactly.
    static let guidedPeriod: TimeInterval = 6
    static let guidedHold: TimeInterval = 1.2
    static let guidedFade: TimeInterval = 0.5

    /// LEARNING, chapter I level 3: the marker is whole for `learningHold` seconds of real play, then fades out
    /// over `learningFade`. Twelve seconds is long enough to start the level with the marker; eighteen more is a
    /// slow enough fade that nobody sees it switch off.
    static let learningHold: TimeInterval = 12
    static let learningFade: TimeInterval = 18

    /// The three levels that teach the marker, in order.
    static let learningLevelIDs = ["1-1", "1-2", "1-3"]
    /// Completing this level ends the learning: the player's own mode applies everywhere afterwards.
    static let learningFinalLevelID = "1-3"

    // MARK: The decision

    /// `activePlayTime` must be time the level was really being played, pauses excluded.
    static func presentation(mode: GazeAssistanceMode,
                             levelID: String,
                             hasCompletedLearning: Bool,
                             activePlayTime: TimeInterval) -> GazeMarkerPresentation {
        if !hasCompletedLearning, let stage = learningStage(for: levelID) {
            return learningPresentation(stage: stage, activePlayTime: activePlayTime)
        }
        switch mode {
        case .classic:
            return .hidden
        case .visible:
            return .shown
        case .guided:
            return GazeMarkerPresentation(opacity: guidedOpacity(at: activePlayTime), showsEdgeGuidance: true)
        }
    }

    /// True while the three teaching levels still apply to this player.
    static func isLearning(levelID: String, hasCompletedLearning: Bool) -> Bool {
        !hasCompletedLearning && learningStage(for: levelID) != nil
    }

    /// 1, 2 or 3 for the teaching levels; nil for every other level.
    static func learningStage(for levelID: String) -> Int? {
        learningLevelIDs.firstIndex(of: levelID).map { $0 + 1 }
    }

    // MARK: Shapes

    /// Levels 1 and 2 keep the marker whole. Level 3 holds it, then lets it go.
    private static func learningPresentation(stage: Int, activePlayTime: TimeInterval) -> GazeMarkerPresentation {
        guard stage == 3 else { return .shown }
        let faded = activePlayTime - learningHold
        guard faded > 0 else { return .shown }
        let remaining = 1 - faded / learningFade
        return GazeMarkerPresentation(opacity: remaining, showsEdgeGuidance: true)
    }

    /// A deterministic cycle: hold at full, fade out, stay away, fade back in. Same input, same output, always.
    static func guidedOpacity(at time: TimeInterval) -> Double {
        guard time >= 0 else { return 0 }
        let position = time.truncatingRemainder(dividingBy: guidedPeriod)
        if position < guidedFade {
            return position / guidedFade
        }
        if position < guidedFade + guidedHold {
            return 1
        }
        let fadingFor = position - guidedFade - guidedHold
        if fadingFor < guidedFade {
            return 1 - fadingFor / guidedFade
        }
        return 0
    }
}
