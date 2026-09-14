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

    init(points: [Vector2], intensity: Double, isClosed: Bool = false) {
        self.points = points
        self.intensity = intensity
        self.isClosed = isClosed
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
            let scene = OculoSceneBuilder.scene(for: stage, elapsed: elapsed, head: head)
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
        }
    }
}
