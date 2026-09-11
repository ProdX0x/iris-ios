// ResolvedLevel.swift
// Layer: GameEngine
// Purpose: A campaign level turned into engine values for one playfield size

import Foundation

struct ResolvedLevel: Sendable {
    let definition: LevelDefinition
    let bounds: PlayfieldBounds
    /// Short side / 393 pt: every per-frame quantity is multiplied by it.
    let scale: Double
    let level: Level
    let physics: PhysicsConstants
    let validation: ValidationRules
    let environment: LevelEnvironment
    /// Designer routes in points, per target index.
    let routes: [[Vector2]]
    let gazeJumpThreshold: Double

    init(definition: LevelDefinition, bounds: PlayfieldBounds, scale: Double, level: Level, physics: PhysicsConstants,
         validation: ValidationRules, environment: LevelEnvironment, routes: [[Vector2]], gazeJumpThreshold: Double) {
        self.definition = definition
        self.bounds = bounds
        self.scale = scale
        self.level = level
        self.physics = physics
        self.validation = validation
        self.environment = environment
        self.routes = routes
        self.gazeJumpThreshold = gazeJumpThreshold
    }

    func makeSession(noiseSources: [any NoiseSource]? = nil) -> GameSession {
        GameSession(level: level, bounds: bounds, physics: physics, validation: validation, environment: environment,
                    gazeJumpThreshold: gazeJumpThreshold, noiseSources: noiseSources)
    }
}
