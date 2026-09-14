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
    /// Chapter IV: anti-saccade (inhibitory control).
    case miroir(MiroirDefinition)
    /// Chapter V: memory-guided saccades.
    case etoiles(EtoilesDefinition)
    /// Chapter VI: visual search and systematic scanning.
    case jardin(JardinDefinition)
    /// Chapter VII: diagonal saccades of variable amplitude.
    case croisement(CroisementDefinition)
    /// Chapter VIII: predictive pursuit.
    case courant(CourantDefinition)
    /// Chapter IX: fixation disengagement (gap and overlap shifts).
    case absence(AbsenceDefinition)
    /// Chapter X: gaze stabilisation while the head turns (VOR-inspired).
    case ancre(AncreDefinition)
    /// Chapter XI: eye-head coordination (saccade-first gaze shift).
    case tourner(TournerDefinition)
}

/// Chapter XI, « d'abord les yeux »: braises light at the edge one after another; reaching one with the eyes first and
/// letting the head follow gives all its warmth, the head before the eyes half, the eyes alone a third.
struct TournerDefinition: Hashable, Sendable {
    let places: [NormalizedPoint]
    /// The order in which the braises light (indices into `places`, repeated as needed).
    let order: [Int]
    let radius: Double
    let releaseRadius: Double
    /// Rest on a braise that counts as reaching it.
    let dwell: TimeInterval
    /// Head motion (|Δyaw| + |Δpitch|, degrees) when the eyes arrive under which the head has not moved yet.
    let headStill: Double
    /// Head motion, after the eyes arrived, that counts as the head following.
    let headTurn: Double
    let followWindow: TimeInterval
    let announceTimeout: TimeInterval
    let pause: TimeInterval
    /// Warmth needed, and the warmth each coordination gives.
    let goal: Double
    let fullYield: Double
    let headFirstYield: Double
    let eyesOnlyYield: Double

    init(places: [NormalizedPoint], order: [Int], radius: Double = 0.2, releaseRadius: Double = 0.27, dwell: TimeInterval = 0.2,
         headStill: Double = 3, headTurn: Double = 5, followWindow: TimeInterval = 1.5, announceTimeout: TimeInterval = 4,
         pause: TimeInterval = 0.6, goal: Double = 4, fullYield: Double = 1, headFirstYield: Double = 0.5, eyesOnlyYield: Double = 0.34) {
        self.places = places
        self.order = order.filter { places.indices.contains($0) }
        self.radius = max(radius, 0.05)
        self.releaseRadius = max(releaseRadius, self.radius)
        self.dwell = max(dwell, 0.05)
        self.headStill = max(headStill, 0)
        self.headTurn = max(headTurn, self.headStill)
        self.followWindow = max(followWindow, 0.2)
        self.announceTimeout = max(announceTimeout, 1)
        self.pause = max(pause, 0)
        self.goal = max(goal, 0)
        self.fullYield = max(fullYield, 0)
        self.headFirstYield = max(headFirstYield, 0)
        self.eyesOnlyYield = max(eyesOnlyYield, 0.01)
    }
}

/// Chapter X, « l'ancre »: the eyes hold a point at the centre of a silhouette while the head draws one slow circle
/// around it (to the starting side, up, across, down, back to face), then the same circle the other way. The gaze is the
/// criterion only around a circle: a short fixation before it (head still and roughly facing the screen) and, after the
/// last one, a closing fixation. While the head turns the projected gaze drifts, so only the head's continuous path
/// counts then. Head angles arrive oriented like the screen (see `HeadPose`).
struct AncreDefinition: Hashable, Sendable {
    /// The side a loop starts from. Every loop rises first: from the right it turns anticlockwise on screen (right, up,
    /// left, down), from the left clockwise (left, up, right, down).
    enum Side: String, Hashable, Sendable {
        case right
        case left
    }

    let anchor: NormalizedPoint
    let start: Side
    /// Gaze zone that counts as looking at the point during a fixation (fraction of the short side), and its release.
    let radius: Double
    let releaseRadius: Double
    /// Radius of the segmented ring around the point (fraction of the short side).
    let ringRadius: Double
    /// Comfortable head turn (degrees from the rest pose) that draws the circle at full size.
    let yawAmplitude: Double
    let pitchAmplitude: Double
    /// Share of the amplitude from which the head is on the circle (nothing fills below it).
    let reach: Double
    /// Share of the amplitude under which the head faces the screen again.
    let rest: Double
    /// Seconds of fixation (eyes on the point, head still) before the circle begins.
    let fixation: TimeInterval
    /// Seconds of fixation after the circle, back facing the screen; nil when the loop ends at the return (the next
    /// loop opens with its own fixation).
    let closingFixation: TimeInterval?
    /// Largest drift of the head (degrees) that still counts as still during a fixation.
    let stillness: Double
    /// Largest head angles (degrees, screen-oriented) still taken as roughly facing the screen during a fixation.
    let neutralYaw: Double
    let neutralPitch: Double
    /// Seconds back facing the screen that close the circle.
    let returnHold: TimeInterval
    /// Fastest the ring fills (degrees per second): a faster head waits for it.
    let maxSweepSpeed: Double
    /// Pace of the ideal player (degrees per second), for the simulated player and the silhouette's demonstration.
    let guidePace: Double

    init(anchor: NormalizedPoint, start: Side, radius: Double = 0.2, releaseRadius: Double = 0.27, ringRadius: Double = 0.235,
         yawAmplitude: Double = 10, pitchAmplitude: Double = 8, reach: Double = 0.6, rest: Double = 0.4,
         fixation: TimeInterval = 0.8, closingFixation: TimeInterval? = nil, stillness: Double = 2.5,
         neutralYaw: Double = 30, neutralPitch: Double = 40, returnHold: TimeInterval = 0.3, maxSweepSpeed: Double = 120,
         guidePace: Double = 45) {
        self.anchor = anchor
        self.start = start
        self.radius = max(radius, 0.05)
        self.releaseRadius = max(releaseRadius, self.radius)
        self.ringRadius = max(ringRadius, 0.05)
        self.yawAmplitude = max(yawAmplitude, 2)
        self.pitchAmplitude = max(pitchAmplitude, 2)
        self.reach = min(max(reach, 0.2), 1)
        self.rest = min(max(rest, 0.05), self.reach * 0.8)
        self.fixation = max(fixation, 0.1)
        self.closingFixation = closingFixation.map { max($0, 0.1) }
        self.stillness = max(stillness, 0.5)
        self.neutralYaw = max(neutralYaw, 5)
        self.neutralPitch = max(neutralPitch, 5)
        self.returnHold = max(returnHold, 0.05)
        self.maxSweepSpeed = max(maxSweepSpeed, 30)
        self.guidePace = min(max(guidePace, 10), self.maxSweepSpeed)
    }
}

/// Chapter IX, « l'absence »: a presence held by the gaze, then an answer elsewhere; in a gap trial the presence fades
/// before the answer appears, in an overlap trial it keeps singing while the answer appears.
struct AbsenceDefinition: Hashable, Sendable {
    enum Mode: Hashable, Sendable {
        case gap
        case overlap
    }

    struct Trial: Hashable, Sendable {
        let from: Int
        let to: Int
        let mode: Mode

        init(_ from: Int, _ to: Int, _ mode: Mode) {
            self.from = from
            self.to = to
            self.mode = mode
        }
    }

    let places: [NormalizedPoint]
    let trials: [Trial]
    /// Continuous rest on the presence before the answer comes.
    let hold: TimeInterval
    /// Silence between the presence fading and the answer appearing (gap trials).
    let gap: TimeInterval
    /// Seconds the answer waits for the gaze.
    let answerWindow: TimeInterval
    let dwell: TimeInterval
    let radius: Double
    let releaseRadius: Double
    /// Breath before a missed trial starts over.
    let pause: TimeInterval

    init(places: [NormalizedPoint], trials: [Trial], hold: TimeInterval = 0.5, gap: TimeInterval = 0.3, answerWindow: TimeInterval = 1.8,
         dwell: TimeInterval = 0.25, radius: Double = 0.2, releaseRadius: Double = 0.27, pause: TimeInterval = 0.7) {
        self.places = places
        self.trials = trials.filter { places.indices.contains($0.from) && places.indices.contains($0.to) && $0.from != $0.to }
        self.hold = max(hold, 0.1)
        self.gap = max(gap, 0)
        self.answerWindow = max(answerWindow, 0.5)
        self.dwell = max(dwell, 0.05)
        self.radius = max(radius, 0.05)
        self.releaseRadius = max(releaseRadius, self.radius)
        self.pause = max(pause, 0)
    }
}

/// Chapter VIII, « la lanterne du courant »: a lantern carried around a closed loop by a periodic current; from the
/// second lap it vanishes in mist patches and must be met where it comes out.
struct CourantDefinition: Hashable, Sendable {
    /// A stretch of the loop, as fractions of its length.
    struct Mist: Hashable, Sendable {
        let start: Double
        let end: Double

        init(start: Double, end: Double) {
            self.start = min(max(start, 0), 1)
            self.end = min(max(end, self.start), 1)
        }
    }

    /// The loop passes through these points, smoothed and closed.
    let waypoints: [NormalizedPoint]
    /// Seconds per lap.
    let period: TimeInterval
    /// Amplitude (seconds) of the gentle breathing of the pace.
    let drift: TimeInterval
    let mists: [Mist]
    /// Mists hide the lantern only after this time (a first lap to learn the way).
    let mistFrom: TimeInterval
    let catchRadius: Double
    /// Seconds after the lantern comes out during which a gaze within reach still catches it.
    let catchWindow: TimeInterval
    /// Catches needed (and every mist caught at least once).
    let catches: Int

    init(waypoints: [NormalizedPoint], period: TimeInterval = 8, drift: TimeInterval = 0.25, mists: [Mist], mistFrom: TimeInterval = 8,
         catchRadius: Double = 0.2, catchWindow: TimeInterval = 0.3, catches: Int = 5) {
        self.waypoints = waypoints
        self.period = max(period, 2)
        self.drift = min(max(drift, 0), self.period / 20)
        self.mists = mists
        self.mistFrom = max(mistFrom, 0)
        self.catchRadius = max(catchRadius, 0.05)
        self.catchWindow = max(catchWindow, 0.05)
        self.catches = max(catches, 1)
    }
}

/// Chapter VII, « croisement »: the twins call each other from opposite corners of a diagonal; the one that breathes
/// waits for the gaze, then calls her sister across. Legs change diagonal and amplitude; the twins glide between legs.
struct CroisementDefinition: Hashable, Sendable {
    enum Diagonal: Hashable, Sendable {
        /// Top-left and bottom-right.
        case falling
        /// Top-right and bottom-left.
        case rising
    }

    struct Leg: Hashable, Sendable {
        let diagonal: Diagonal
        /// Half-offsets of each twin from the centre (fractions of the width and height).
        let dx: Double
        let dy: Double
        /// Acquisitions on this leg before the twins glide to the next one.
        let exchanges: Int

        init(_ diagonal: Diagonal, dx: Double, dy: Double, exchanges: Int = 2) {
            self.diagonal = diagonal
            self.dx = dx
            self.dy = dy
            self.exchanges = max(exchanges, 1)
        }
    }

    let center: NormalizedPoint
    let legs: [Leg]
    let radius: Double
    let releaseRadius: Double
    let dwell: TimeInterval
    /// Seconds the twins take to glide from one leg to the next.
    let glide: TimeInterval

    init(center: NormalizedPoint, legs: [Leg], radius: Double = 0.2, releaseRadius: Double = 0.27, dwell: TimeInterval = 0.25, glide: TimeInterval = 0.6) {
        self.center = center
        self.legs = legs
        self.radius = max(radius, 0.05)
        self.releaseRadius = max(releaseRadius, self.radius)
        self.dwell = max(dwell, 0.05)
        self.glide = max(glide, 0)
    }
}

/// Chapter VI, « le jardin caché »: seeds all over the field; in each batch a few of them breathe slowly among seeds that
/// only twinkle. A gaze that rests on a breathing seed makes it sprout; lingering on a seed that only twinkles folds the
/// sprouts of the current batch back (a local retry). Sprouts stay once their batch is complete.
struct JardinDefinition: Hashable, Sendable {
    let seeds: [NormalizedPoint]
    /// The breathing seeds of each batch (indices into `seeds`).
    let batches: [[Int]]
    let radius: Double
    let releaseRadius: Double
    /// Rest on a breathing seed that makes it sprout.
    let dwell: TimeInterval
    /// Lingering on a twinkling seed that folds the batch back (longer than `dwell`: a passing glance costs nothing).
    let lingerDwell: TimeInterval

    init(seeds: [NormalizedPoint], batches: [[Int]], radius: Double = 0.18, releaseRadius: Double = 0.24, dwell: TimeInterval = 0.3,
         lingerDwell: TimeInterval = 0.5) {
        self.seeds = seeds
        self.batches = batches.map { $0.filter { seeds.indices.contains($0) } }.filter { !$0.isEmpty }
        self.radius = max(radius, 0.05)
        self.releaseRadius = max(releaseRadius, self.radius)
        self.dwell = max(dwell, 0.05)
        self.lingerDwell = max(lingerDwell, self.dwell)
    }
}

/// Chapter V, « les étoiles absentes »: a few stars shine briefly, vanish, and reappear only where the gaze returns
/// to their remembered place; each round adds them to a constellation.
struct EtoilesDefinition: Hashable, Sendable {
    /// Every place a star can shine.
    let candidates: [NormalizedPoint]
    /// The stars of each round (indices into `candidates`).
    let rounds: [[Int]]
    let showDuration: TimeInterval
    let blankDuration: TimeInterval
    /// Seconds allowed to find every star of a round before it is shown again.
    let recallLimit: TimeInterval
    let radius: Double
    let releaseRadius: Double
    let dwell: TimeInterval

    init(candidates: [NormalizedPoint], rounds: [[Int]], showDuration: TimeInterval = 1.4, blankDuration: TimeInterval = 0.5,
         recallLimit: TimeInterval = 8, radius: Double = 0.2, releaseRadius: Double = 0.27, dwell: TimeInterval = 0.25) {
        self.candidates = candidates
        self.rounds = rounds.map { $0.filter { candidates.indices.contains($0) } }.filter { !$0.isEmpty }
        self.showDuration = max(showDuration, 0.3)
        self.blankDuration = max(blankDuration, 0)
        self.recallLimit = max(recallLimit, 1)
        self.radius = max(radius, 0.05)
        self.releaseRadius = max(releaseRadius, self.radius)
        self.dwell = max(dwell, 0.05)
    }
}

/// Chapter IV, « le miroir menteur »: a lure flashes on one side while the door opens on the opposite side for a
/// while; a gaze that goes to the lure closes the door, the cycle repeats until the gaze goes to the door instead.
struct MiroirDefinition: Hashable, Sendable {
    enum Side: Hashable, Sendable {
        case right, left, top, bottom

        var opposite: Side {
            switch self {
            case .right: .left
            case .left: .right
            case .top: .bottom
            case .bottom: .top
            }
        }
    }

    /// Where each side lies.
    let right: NormalizedPoint
    let left: NormalizedPoint
    let top: NormalizedPoint
    let bottom: NormalizedPoint
    /// The side of each lure, in order; the door is always opposite.
    let cycles: [Side]
    let radius: Double
    let releaseRadius: Double
    let flashDuration: TimeInterval
    /// The door opens `windowOpensAt` after the flash and stays open `windowDuration` (the first `teachingCycles` cycles longer).
    let windowOpensAt: TimeInterval
    let windowDuration: TimeInterval
    let teachingCycles: Int
    let teachingWindowDuration: TimeInterval
    let dwell: TimeInterval
    /// Breath after a success, and after a miss before the same cycle repeats.
    let pause: TimeInterval

    init(right: NormalizedPoint, left: NormalizedPoint, top: NormalizedPoint, bottom: NormalizedPoint, cycles: [Side],
         radius: Double = 0.2, releaseRadius: Double = 0.27, flashDuration: TimeInterval = 0.5, windowOpensAt: TimeInterval = 0.15,
         windowDuration: TimeInterval = 1.8, teachingCycles: Int = 1, teachingWindowDuration: TimeInterval = 3, dwell: TimeInterval = 0.2,
         pause: TimeInterval = 0.8) {
        self.right = right
        self.left = left
        self.top = top
        self.bottom = bottom
        self.cycles = cycles
        self.radius = max(radius, 0.05)
        self.releaseRadius = max(releaseRadius, self.radius)
        self.flashDuration = max(flashDuration, 0.1)
        self.windowOpensAt = max(windowOpensAt, 0)
        self.windowDuration = max(windowDuration, 0.5)
        self.teachingCycles = max(teachingCycles, 0)
        self.teachingWindowDuration = max(teachingWindowDuration, self.windowDuration)
        self.dwell = max(dwell, 0.05)
        self.pause = max(pause, 0)
    }

    func position(of side: Side) -> NormalizedPoint {
        switch side {
        case .right: right
        case .left: left
        case .top: top
        case .bottom: bottom
        }
    }
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
    /// Each completed stage lights a star of a constellation that comes alive once the sequence is complete.
    let showsConstellation: Bool
    /// The late help line of this sequence; nil keeps the generic oculomotor help.
    let help: String?

    init(stages: [OculoStageDefinition], element: GameElement, hidesLueurs: Bool = true, pause: TimeInterval = 0.6, showsConstellation: Bool = false,
         help: String? = nil) {
        self.stages = stages
        self.element = element
        self.hidesLueurs = hidesLueurs
        self.pause = max(pause, 0)
        self.showsConstellation = showsConstellation
        self.help = help
    }
}

extension OculoDefinition {
    /// Chapter X final: its circles follow the head alone, so the head pose is read even when a gaze sample has no
    /// projection (the projection drifts or fails while the head is turned).
    var readsHeadWithoutGaze: Bool {
        stages.contains { stage in
            if case .ancre = stage { return true }
            return false
        }
    }
}
