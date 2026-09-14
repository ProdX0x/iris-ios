// OculoSnapshot.swift
// Layer: Presentation
// Purpose: OCULOMOTOR EXPANSION: plain scene description of the current gaze stage, built from the engine state once
// per frame; the renderer draws elements by role with the chapter palette

import Foundation

enum OculoRole: Hashable, Sendable {
    /// A zone the gaze should rest in (dotted circle), and the thing at its centre.
    case target
    /// A tempting thing to ignore.
    case distractor
    /// A moving light the gaze follows.
    case spark
    /// A sudden bright burst.
    case flash
    /// An opening that accepts the gaze for a while.
    case window
    /// A remembered light.
    case star
    /// A seed of the garden, sprouted or not.
    case seed
    /// A resting place of the twins.
    case cradle
    /// The light carried along the loop, and a relay ahead of it.
    case lantern
    case relay
    /// A presence that glows, fades, answers.
    case presence
    /// The anchor of the gaze and the compass the head turns.
    case anchor
    case compass
    /// A braise the level announces.
    case announce
    /// A star of the final constellation.
    case constellation
}

struct OculoElementSnapshot: Hashable, Sendable {
    let role: OculoRole
    let position: Vector2
    let radius: Double
    /// 0...1 brightness or charge.
    let intensity: Double
    /// 0...1 animation phase when meaningful.
    let phase: Double
    let isActive: Bool
    let isLit: Bool
    let index: Int

    init(role: OculoRole, position: Vector2, radius: Double, intensity: Double = 1, phase: Double = 0, isActive: Bool = false, isLit: Bool = false, index: Int = 0) {
        self.role = role
        self.position = position
        self.radius = radius
        self.intensity = intensity
        self.phase = phase
        self.isActive = isActive
        self.isLit = isLit
        self.index = index
    }
}

struct OculoPolylineSnapshot: Hashable, Sendable {
    let points: [Vector2]
    let intensity: Double
    let isClosed: Bool
    /// A soft, wide band of mist rather than a line.
    let isMist: Bool

    init(points: [Vector2], intensity: Double, isClosed: Bool = false, isMist: Bool = false) {
        self.points = points
        self.intensity = intensity
        self.isClosed = isClosed
        self.isMist = isMist
    }
}

/// An arc drawn around a centre (compass bands, charge rings): angles in radians, screen convention.
struct OculoArcSnapshot: Hashable, Sendable {
    let center: Vector2
    let radius: Double
    let start: Double
    let end: Double
    let intensity: Double
    let isActive: Bool
}

struct OculoSnapshot: Hashable, Sendable {
    let stageIndex: Int
    let stageCount: Int
    let progress: Double
    let stageProgress: Double
    let isBreathing: Bool
    let isComplete: Bool
    let elements: [OculoElementSnapshot]
    let polylines: [OculoPolylineSnapshot]
    let arcs: [OculoArcSnapshot]

    init(sequence: OculoSequenceState, elapsed: TimeInterval, head: HeadPose?) {
        stageIndex = min(sequence.currentIndex, max(0, sequence.stageCount - 1))
        stageCount = sequence.stageCount
        progress = sequence.progress
        isBreathing = sequence.isBreathing
        isComplete = sequence.isComplete
        var elements: [OculoElementSnapshot] = []
        var polylines: [OculoPolylineSnapshot] = []
        var arcs: [OculoArcSnapshot] = []
        var stageProgress = 1.0
        if let stage = sequence.current, !sequence.isComplete {
            stageProgress = stage.progress
            let scene = OculoSceneBuilder.scene(for: stage, elapsed: sequence.stageTime(at: elapsed), head: head)
            elements = scene.elements
            polylines = scene.polylines
            arcs = scene.arcs
        }
        self.stageProgress = stageProgress
        self.elements = elements
        self.polylines = polylines
        self.arcs = arcs
    }
}

/// Builds the scene of one stage; one case per stage kind, added chapter by chapter.
enum OculoSceneBuilder {
    struct Scene {
        var elements: [OculoElementSnapshot] = []
        var polylines: [OculoPolylineSnapshot] = []
        var arcs: [OculoArcSnapshot] = []
    }

    static func scene(for stage: OculoStageState, elapsed: TimeInterval, head: HeadPose?) -> Scene {
        switch stage {
        case let .coeur(state):
            var scene = Scene()
            scene.elements.append(OculoElementSnapshot(role: .target, position: state.position, radius: state.radius, intensity: state.progress, isActive: true))
            scene.arcs.append(OculoArcSnapshot(center: state.position, radius: state.radius * 0.55, start: -.pi / 2, end: -.pi / 2 + 2 * .pi * state.progress,
                                               intensity: state.progress, isActive: true))
            if let spark = state.activeDistractor(at: elapsed) {
                let fade = max(0, 1 - spark.age / state.distractorDuration)
                scene.elements.append(OculoElementSnapshot(role: .distractor, position: spark.position, radius: state.distractorRadius,
                                                           intensity: fade, phase: spark.age / state.distractorDuration, index: spark.ordinal))
            }
            return scene
        case let .fil(state):
            var scene = Scene()
            let spark = state.position(at: elapsed)
            scene.polylines.append(OculoPolylineSnapshot(points: state.trail + [spark], intensity: 0.15 + 0.85 * state.progress))
            scene.elements.append(OculoElementSnapshot(role: .spark, position: spark, radius: state.radius, intensity: 0.4 + 0.6 * state.progress,
                                                       isActive: true, isLit: state.isNear))
            return scene
        case let .miroir(state):
            var scene = Scene()
            let doorOpen = state.isDoorOpen(at: elapsed)
            for (side, position) in state.positions.sorted(by: { "\($0.key)" < "\($1.key)" }) {
                let isDoor = state.doorSide == side
                scene.elements.append(OculoElementSnapshot(role: .window, position: position, radius: state.radius, intensity: isDoor && doorOpen ? 1 : 0.2,
                                                           isActive: isDoor && doorOpen, isLit: isDoor && state.isInDoor && doorOpen))
            }
            if let age = state.flashAge(at: elapsed), let lure = state.lureSide, let position = state.positions[lure] {
                scene.elements.append(OculoElementSnapshot(role: .flash, position: position, radius: state.radius, intensity: 1 - age / state.flashDuration,
                                                           phase: age / state.flashDuration))
            }
            return scene
        case let .etoiles(state):
            var scene = Scene()
            let showing = state.isShowing
            for (index, position) in state.candidates.enumerated() {
                let inRound = state.currentRound.contains(index)
                let lit = state.constellation.contains(index) || state.found.contains(index)
                let shining = showing && inRound
                scene.elements.append(OculoElementSnapshot(role: .star, position: position, radius: state.radius, intensity: shining ? 1 : 0,
                                                           isActive: false, isLit: lit, index: index))
            }
            let drawn = state.constellation + state.found
            if drawn.count >= 2 {
                scene.polylines.append(OculoPolylineSnapshot(points: drawn.map { state.candidates[$0] }, intensity: 0.5))
            }
            return scene
        case let .jardin(state):
            var scene = Scene()
            for (index, position) in state.seeds.enumerated() {
                scene.elements.append(OculoElementSnapshot(role: .seed, position: position, radius: state.radius,
                                                           intensity: state.isSprouted(index) ? 1 : (state.dwellingOn == index ? min(1, state.dwellTime / state.dwell) : 0),
                                                           isActive: state.isBreathing(index), isLit: state.isSprouted(index), index: index))
            }
            return scene
        case let .croisement(state):
            var scene = Scene()
            let pair = state.twins(at: elapsed)
            scene.polylines.append(OculoPolylineSnapshot(points: [pair.0, pair.1], intensity: 0.15 + 0.85 * state.progress))
            for (index, position) in [pair.0, pair.1].enumerated() {
                let isActive = index == state.active
                scene.elements.append(OculoElementSnapshot(role: .cradle, position: position, radius: state.radius,
                                                           intensity: isActive && state.isInside ? min(1, state.dwellTime / state.dwell) : 0,
                                                           isActive: isActive, isLit: !isActive, index: index))
            }
            return scene
        case let .courant(state):
            var scene = Scene()
            let track = stride(from: 0, to: state.samples.count, by: 4).map { state.samples[$0] }
            scene.polylines.append(OculoPolylineSnapshot(points: track, intensity: 0.14, isClosed: true))
            if elapsed >= state.mistFrom - 1 {
                let fadeIn = min(1, max(0, elapsed - (state.mistFrom - 1)))
                for index in state.mists.indices {
                    scene.polylines.append(OculoPolylineSnapshot(points: state.mistTrail(index), intensity: fadeIn, isMist: true))
                    scene.elements.append(OculoElementSnapshot(role: .relay, position: state.exits[index], radius: state.catchRadius,
                                                               isActive: state.hiddenIn == index || state.catchMist == index,
                                                               isLit: state.caught.contains(index), index: index))
                }
            }
            if state.mist(at: elapsed) == nil {
                scene.elements.append(OculoElementSnapshot(role: .lantern, position: state.position(at: elapsed), radius: state.catchRadius,
                                                           intensity: 0.5 + 0.5 * state.progress))
            }
            return scene
        }
    }
}
