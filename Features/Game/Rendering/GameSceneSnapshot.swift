// GameSceneSnapshot.swift
// Layer: Presentation
// Purpose: Plain value copied from the session once per frame; the only thing the canvas reads

import Foundation

struct SceneTargetSnapshot: Hashable, Sendable {
    let sequence: Int
    let position: Vector2
    let arrival: Vector2
    let speed: Double
    let progress: Double
    let isValidated: Bool
}

/// Diagnostic gaze points: uncalibrated (nominal) and calibrated but unfiltered positions.
struct GazeDiagnostics: Hashable, Sendable {
    var raw: Vector2?
    var calibrated: Vector2?

    init(raw: Vector2? = nil, calibrated: Vector2? = nil) {
        self.raw = raw
        self.calibrated = calibrated
    }
}

struct GameSceneSnapshot: Hashable, Sendable {
    var bounds: PlayfieldBounds
    var targets: [SceneTargetSnapshot]
    var isSequential: Bool
    /// Smoothed cursor actually used by the physics (diagnostic display only).
    var gaze: Vector2?
    var diagnostics: GazeDiagnostics?

    init(bounds: PlayfieldBounds, targets: [SceneTargetSnapshot] = [], isSequential: Bool = false, gaze: Vector2? = nil,
         diagnostics: GazeDiagnostics? = nil) {
        self.bounds = bounds
        self.targets = targets
        self.isSequential = isSequential
        self.gaze = gaze
        self.diagnostics = diagnostics
    }

    init(session: GameSession, showsGaze: Bool, diagnostics: GazeDiagnostics? = nil) {
        bounds = session.bounds
        targets = session.targets.map {
            SceneTargetSnapshot(sequence: $0.sequence, position: $0.position, arrival: $0.arrival,
                                speed: $0.speed, progress: $0.validationProgress, isValidated: $0.isValidated)
        }
        isSequential = session.level.isSequential
        gaze = showsGaze ? session.gaze.position : nil
        self.diagnostics = showsGaze ? diagnostics : nil
    }
}
