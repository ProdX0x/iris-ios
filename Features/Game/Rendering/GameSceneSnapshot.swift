// GameSceneSnapshot.swift
// Layer: Presentation
// Purpose: Plain values copied from the session once per frame; the only thing the canvas reads

import Foundation

struct LueurSnapshot: Hashable, Sendable {
    let sequence: Int
    let position: Vector2
    let radius: Double
    let arrival: Vector2
    let irisRadius: Double
    let progress: Double
    let isValidated: Bool
    let isIrisOpen: Bool
    let disturbance: Double
    let temperament: Temperament
    /// EXPERIMENTAL (prototype B1): heat of a braise, nil for a normal lueur.
    let heat: Double?
    let isFlaring: Bool

    init(sequence: Int, position: Vector2, radius: Double, arrival: Vector2, irisRadius: Double, progress: Double,
         isValidated: Bool, isIrisOpen: Bool, disturbance: Double, temperament: Temperament, heat: Double? = nil, isFlaring: Bool = false) {
        self.sequence = sequence
        self.position = position
        self.radius = radius
        self.arrival = arrival
        self.irisRadius = irisRadius
        self.progress = progress
        self.isValidated = isValidated
        self.isIrisOpen = isIrisOpen
        self.disturbance = disturbance
        self.temperament = temperament
        self.heat = heat
        self.isFlaring = isFlaring
    }
}

struct VeilleuseSnapshot: Hashable, Sendable {
    let position: Vector2
    let lookRadius: Double
    let charge: Double
    let isLow: Bool
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
    var scale: Double
    var lueurs: [LueurSnapshot]
    var currents: [CurrentField]
    var veils: [VeilSegment]
    var veilleuses: [VeilleuseSnapshot]
    /// Designer routes (help), empty until the help delay elapsed.
    var routes: [[Vector2]]
    var isSequential: Bool
    var time: TimeInterval
    var isAttentionOnField: Bool
    /// Visual identity of the chapter being played (chambre noire for the historical chapters).
    var theme: ChapterTheme
    /// Smoothed cursor actually used by the physics (diagnostic display only).
    var gaze: Vector2?
    var diagnostics: GazeDiagnostics?

    init(bounds: PlayfieldBounds) {
        self.bounds = bounds
        scale = 1
        lueurs = []
        currents = []
        veils = []
        veilleuses = []
        routes = []
        isSequential = false
        time = 0
        isAttentionOnField = true
        theme = .chambreNoire
        gaze = nil
        diagnostics = nil
    }

    init(session: GameSession, resolved: ResolvedLevel, showsRoute: Bool, showsGaze: Bool, diagnostics: GazeDiagnostics?,
         theme: ChapterTheme = .chambreNoire) {
        bounds = session.bounds
        scale = resolved.scale
        lueurs = session.targets.enumerated().map { index, target in
            LueurSnapshot(sequence: target.sequence,
                          position: target.position,
                          radius: session.radius(ofTargetAt: index),
                          arrival: target.arrival,
                          irisRadius: session.physics.arrivalRadius,
                          progress: target.isValidated ? 1 : target.validationProgress,
                          isValidated: target.isValidated,
                          isIrisOpen: session.isIrisOpen(for: target),
                          disturbance: target.disturbance,
                          temperament: resolved.definition.lueurs.indices.contains(index) ? resolved.definition.lueurs[index].temperament : .normale,
                          heat: session.braises[index]?.heat,
                          isFlaring: session.braises[index]?.isFlaring ?? false)
        }
        currents = session.environment.currents
        veils = session.environment.veils
        veilleuses = session.veilleuses.map {
            VeilleuseSnapshot(position: $0.position, lookRadius: $0.lookRadius, charge: $0.charge, isLow: $0.isLow)
        }
        if showsRoute {
            routes = session.targets.indices.compactMap { index in
                let route = resolved.routes[index]
                guard !route.isEmpty, !session.targets[index].isValidated else { return nil }
                let start = resolved.definition.lueurs[index].start.absolute(in: session.bounds)
                return [start] + route + [session.targets[index].arrival]
            }
        } else {
            routes = []
        }
        isSequential = session.level.isSequential
        time = session.elapsed
        isAttentionOnField = session.isAttentionOnField
        self.theme = theme
        gaze = showsGaze ? session.gaze.position : nil
        self.diagnostics = showsGaze ? diagnostics : nil
    }
}
