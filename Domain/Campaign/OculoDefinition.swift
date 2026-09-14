// OculoDefinition.swift
// Layer: Domain
// Purpose: OCULOMOTOR EXPANSION: a level may open with a sequence of gaze-contingent stages (one per paradigm),
// each a small deterministic machine; while the sequence is incomplete the lueurs may stay latent

import Foundation

/// One stage of a gaze-contingent sequence. Cases are added chapter by chapter.
enum OculoStageDefinition: Hashable, Sendable {
    /// Chapter II: fixation stability with distractor inhibition.
    case coeur(CoeurDefinition)
    /// Chapter III: smooth pursuit.
    case fil(FilDefinition)
}

/// Chapter III, « le fil vivant »: a spark travels a smooth closed curve without ever stopping; the filament it leaves
/// stays alive while the gaze accompanies it and frays while the gaze is away.
struct FilDefinition: Hashable, Sendable {
    let center: NormalizedPoint
    /// Half-amplitudes of the curve (fractions of the width and height): x = cx + ax·sin(ωt), y = cy + ay·sin(ωt + phase) + wobble·sin(3ωt).
    let amplitudeX: Double
    let amplitudeY: Double
    let phase: Double
    let wobble: Double
    /// Seconds per lap.
    let period: TimeInterval
    /// Gaze distance (fraction of the short side) that counts as accompanying; release beyond `releaseRadius`.
    let radius: Double
    let releaseRadius: Double
    /// Seconds of accompaniment needed; the account frays at `decay` per second while the gaze is away.
    let requirement: TimeInterval
    let decay: Double

    init(center: NormalizedPoint, amplitudeX: Double = 0.3, amplitudeY: Double = 0.28, phase: Double = .pi / 3, wobble: Double = 0.05,
         period: TimeInterval = 10, radius: Double = 0.2, releaseRadius: Double = 0.27, requirement: TimeInterval = 8, decay: Double = 1) {
        self.center = center
        self.amplitudeX = amplitudeX
        self.amplitudeY = amplitudeY
        self.phase = phase
        self.wobble = wobble
        self.period = max(period, 2)
        self.radius = max(radius, 0.05)
        self.releaseRadius = max(releaseRadius, self.radius)
        self.requirement = max(requirement, 0.5)
        self.decay = max(decay, 0)
    }
}

/// Chapter II, « le cœur de verre »: a cold heart warms while the gaze rests on it; sparks flare around it and steal
/// some warmth from a gaze that goes to them.
struct CoeurDefinition: Hashable, Sendable {
    let position: NormalizedPoint
    /// Gaze distance (fraction of the short side) that counts as resting on the heart; release beyond `releaseRadius`.
    let radius: Double
    let releaseRadius: Double
    /// Seconds of rest needed (a continuity account: it drains at `decay` per second while the gaze is away).
    let requirement: TimeInterval
    let decay: Double
    /// Where sparks flare, one at a time, every `distractorPeriod` seconds for `distractorDuration`, from `firstDistractorAt`.
    let distractors: [NormalizedPoint]
    let distractorPeriod: TimeInterval
    let distractorDuration: TimeInterval
    let distractorRadius: Double
    /// Seconds of rest lost when the gaze goes to a spark.
    let distractorPenalty: TimeInterval
    let firstDistractorAt: TimeInterval

    init(position: NormalizedPoint, radius: Double = 0.2, releaseRadius: Double = 0.27, requirement: TimeInterval = 6, decay: Double = 1,
         distractors: [NormalizedPoint], distractorPeriod: TimeInterval = 2.4, distractorDuration: TimeInterval = 1.1,
         distractorRadius: Double = 0.15, distractorPenalty: TimeInterval = 0.6, firstDistractorAt: TimeInterval = 3) {
        self.position = position
        self.radius = max(radius, 0.05)
        self.releaseRadius = max(releaseRadius, self.radius)
        self.requirement = max(requirement, 0.5)
        self.decay = max(decay, 0)
        self.distractors = distractors
        self.distractorPeriod = max(distractorPeriod, 0.5)
        self.distractorDuration = min(max(distractorDuration, 0.2), self.distractorPeriod)
        self.distractorRadius = max(distractorRadius, 0.05)
        self.distractorPenalty = max(distractorPenalty, 0)
        self.firstDistractorAt = max(firstDistractorAt, 0)
    }
}

struct OculoDefinition: Hashable, Sendable {
    let stages: [OculoStageDefinition]
    /// Whether the lueurs wait, unseen and still, until the sequence completes.
    let hidesLueurs: Bool
    /// Breath between two stages (seconds).
    let pause: TimeInterval
    /// The Carnet idea this sequence embodies.
    let element: GameElement

    init(stages: [OculoStageDefinition], element: GameElement, hidesLueurs: Bool = true, pause: TimeInterval = 0.6) {
        self.stages = stages
        self.element = element
        self.hidesLueurs = hidesLueurs
        self.pause = max(pause, 0)
    }
}
