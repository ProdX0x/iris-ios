// AncreSceneSnapshot.swift
// Layer: Presentation
// Purpose: Chapter X final « l'ancre »: plain description of the loop scene (silhouette, segmented ring, checkpoints,
// the head's direction, the point to hold, the stardust between the two loops and after the last one), built from the
// engine state once per frame. Nothing in it follows the gaze while the head draws a circle: the point and the ring are
// fixed on screen, the lit bars come from the head's path, and the eyes only show during a fixation

import Foundation

struct AncreSceneSnapshot: Hashable, Sendable {
    struct Checkpoint: Hashable, Sendable {
        /// Screen angle, radians clockwise from the right.
        let angle: Double
        let isReached: Bool
        /// Seconds since it was reached; nil while it is not.
        let age: Double?
        let isNext: Bool
    }

    static let barCount = 72
    /// Face half-width of the silhouette, in ring radii.
    static let faceScale = 1.28
    /// Seconds the last ring takes to scatter once both loops are done.
    static let completionDuration = 2.4

    let center: Vector2
    let ringRadius: Double
    let phase: AncreStageState.Phase
    /// Seconds in the current phase.
    let phaseTime: Double
    let loop: Int
    let loopCount: Int
    /// Screen angle of the loop's starting side, and its sense on screen (+1 clockwise).
    let startAngle: Double
    let screenTurn: Double
    /// Degrees of the loop lit on the ring, 0...360.
    let litSweep: Double
    let checkpoints: [Checkpoint]
    /// 0...1 fixation of the point while the gaze is the criterion.
    let fixationProgress: Double
    /// True during a fixation, when the eyes decide; false while the head alone counts.
    let gazeIsCriterion: Bool
    /// Whether the eyes rest on the point during a fixation; always false otherwise, so the gaze changes nothing then.
    let gazeOnPoint: Bool
    /// True while the head alone counts (to the starting side, the circle, the return): no gaze mark is drawn then.
    let isHeadOnly: Bool
    /// The head's direction on screen (x right, y down), 1 long when the head is on the circle.
    let head: Vector2?
    /// True while the silhouette shows the movement: anchored, the head not yet under way.
    let demonstrates: Bool
    /// Opacity of the current loop's ring (it fades in after the breath between loops).
    let ringOpacity: Double
    /// Opacity of a completed ring that is scattering, and the scattering itself (0...1, nil when nothing scatters).
    let scatteringRingOpacity: Double
    let stardust: Double?
    let silhouetteOpacity: Double
    let pointOpacity: Double

    /// The scene of the current loop, of the breath after a loop, or of the last loop once the sequence is complete;
    /// nil when the level has no ancre.
    static func make(sequence: OculoSequenceState, elapsed: TimeInterval) -> AncreSceneSnapshot? {
        let loops = sequence.stages.filter { if case .ancre = $0 { true } else { false } }.count
        guard loops > 0 else { return nil }
        if sequence.isComplete {
            guard case let .ancre(last)? = sequence.stages.last, let completedAt = sequence.completedAt else { return nil }
            let t = min(1, max(0, elapsed - completedAt) / completionDuration)
            return AncreSceneSnapshot(state: last, loop: loops - 1, loopCount: loops, ringOpacity: 0, scatteringRingOpacity: max(0, 1 - t / 0.3),
                                      stardust: t, silhouetteOpacity: 1 - 0.7 * t, pointOpacity: max(0, 1 - t / 0.5))
        }
        guard case let .ancre(state)? = sequence.current else { return nil }
        let loop = sequence.stages.prefix(sequence.currentIndex).filter { if case .ancre = $0 { true } else { false } }.count
        if sequence.isBreathing, sequence.currentIndex > 0, case .ancre = sequence.stages[sequence.currentIndex - 1] {
            // The drawn ring bursts into stardust, then the next loop's ring fades in.
            let t = sequence.pause > 0 ? min(1, max(0, 1 - sequence.pauseRemaining / sequence.pause)) : 1
            let fadeIn = min(1, max(0, (t - 0.6) / 0.4))
            return AncreSceneSnapshot(state: state, loop: loop, loopCount: loops, ringOpacity: fadeIn * fadeIn * (3 - 2 * fadeIn),
                                      scatteringRingOpacity: max(0, 1 - t / 0.25), stardust: t, silhouetteOpacity: 1, pointOpacity: 1)
        }
        return AncreSceneSnapshot(state: state, loop: loop, loopCount: loops, ringOpacity: 1, scatteringRingOpacity: 0, stardust: nil,
                                  silhouetteOpacity: 1, pointOpacity: 1)
    }

    init(state: AncreStageState, loop: Int, loopCount: Int, ringOpacity: Double, scatteringRingOpacity: Double, stardust: Double?,
         silhouetteOpacity: Double, pointOpacity: Double) {
        center = state.anchor
        ringRadius = state.ringRadius
        phase = state.phase
        phaseTime = max(0, state.clock - state.phaseStartedAt)
        self.loop = loop
        self.loopCount = loopCount
        startAngle = -state.startAngle * .pi / 180
        screenTurn = -state.turn
        switch state.phase {
        case .fixating, .seeking: litSweep = 0
        case .circling: litSweep = state.sweep
        case .returning: litSweep = state.sweep + (360 - state.sweep) * state.returnProgress
        case .refixating, .done: litSweep = 360
        }
        let reached = state.checkpointTimes.count
        let guiding = state.phase == .seeking || state.phase == .circling
        checkpoints = AncreStageState.checkpoints.enumerated().map { index, degrees in
            Checkpoint(angle: -(state.startAngle + state.turn * degrees) * .pi / 180, isReached: index < reached,
                       age: index < reached ? max(0, state.clock - state.checkpointTimes[index]) : nil, isNext: guiding && index == reached)
        }
        fixationProgress = state.fixationProgress
        gazeIsCriterion = state.gazeIsCriterion
        gazeOnPoint = state.gazeIsCriterion && state.isOnAnchor
        isHeadOnly = state.isHeadOnly
        head = state.isHeadOnly ? state.headOffset.map { Vector2(x: $0.x / state.reach, y: -$0.y / state.reach) } : nil
        demonstrates = state.phase == .seeking && (head?.length ?? 0) < 0.35
        self.ringOpacity = ringOpacity
        self.scatteringRingOpacity = scatteringRingOpacity
        self.stardust = stardust
        self.silhouetteOpacity = silhouetteOpacity
        self.pointOpacity = pointOpacity
    }

    /// Screen angle of the loop's point `degrees` from its start.
    func screenAngle(alongLoop degrees: Double) -> Double {
        startAngle + screenTurn * degrees * .pi / 180
    }

    /// Degrees along the loop, 0..<360, of a screen angle.
    func loopDegrees(atScreenAngle angle: Double) -> Double {
        let degrees = ((angle - startAngle) * screenTurn * 180 / .pi).truncatingRemainder(dividingBy: 360)
        let value = degrees < 0 ? degrees + 360 : degrees
        return value > 359.999 ? 0 : value
    }
}
