// GameSession.swift
// Layer: GameEngine
// Purpose: Deterministic per-level simulation: physics, validation, cascade and events (port of `step()`)

import Foundation

struct GameSession: Sendable {
    let level: Level
    let bounds: PlayfieldBounds
    let physics: PhysicsConstants
    let validation: ValidationRules
    /// Largest wall-clock delta accepted per `advance`; anything longer is treated as a stall.
    var maxDeltaTime: TimeInterval = 0.1

    private(set) var targets: [Target]
    private(set) var gaze: GazeFilter
    /// Accumulated reference frames (`t` in the reference engine), drives the noise time.
    private(set) var frameTime: Double = 0
    private(set) var elapsed: TimeInterval = 0
    private(set) var isComplete = false

    private let noiseSources: [any NoiseSource]
    private let integrator: TargetPhysics
    private let validationRule: ValidationRule

    init(level: Level,
         bounds: PlayfieldBounds,
         physics: PhysicsConstants = .reference,
         validation: ValidationRules? = nil,
         initialGaze: Vector2? = nil,
         noiseSources: [any NoiseSource]? = nil) {
        self.level = level
        self.bounds = bounds
        self.physics = physics
        let rules = validation ?? ValidationRules.reference(physics: physics)
        self.validation = rules
        self.targets = level.targets.map { Target(blueprint: $0, bounds: bounds, holdDuration: level.holdDuration) }
        self.gaze = GazeFilter(initialPosition: initialGaze ?? bounds.center)
        self.noiseSources = noiseSources ?? level.targets.indices.map { ValueNoise1D(seed: 1000 + $0 * 137) }
        self.integrator = TargetPhysics(constants: physics, bounds: bounds)
        self.validationRule = ValidationRule(rules: rules)
    }

    var allValidated: Bool { targets.allSatisfy(\.isValidated) }

    /// Smoothed gaze input (what the reference engine's gaze listener did).
    mutating func ingestGaze(_ point: Vector2) {
        gaze.ingest(point)
    }

    /// Exact gaze placement without smoothing (tests, golden traces, previews).
    mutating func placeGaze(at point: Vector2) {
        gaze.place(at: point)
    }

    /// Replaces the runtime targets; used by tests and previews to stage a scene.
    mutating func replaceTargets(_ newTargets: [Target]) {
        targets = newTargets
        isComplete = false
    }

    /// R-14: advances the simulation by `deltaTime` seconds. The delta is clamped, then split into
    /// sub-steps no longer than one reference frame so that frame drops reproduce what 60 Hz would have done.
    mutating func advance(by deltaTime: TimeInterval) -> [GameEvent] {
        guard !isComplete else { return [] }
        let clamped = min(max(deltaTime, 0), maxDeltaTime)
        guard clamped > 0 else { return [] }
        let referenceFrames = clamped * physics.referenceFrameRate
        let substeps = max(1, Int((referenceFrames - 1e-9).rounded(.up)))
        let subSeconds = clamped / Double(substeps)
        let frameFraction = subSeconds * physics.referenceFrameRate
        var events: [GameEvent] = []
        for _ in 0..<substeps {
            events += tick(seconds: subSeconds, frameFraction: frameFraction)
            if isComplete { break }
        }
        return events
    }

    private mutating func tick(seconds: TimeInterval, frameFraction: Double) -> [GameEvent] {
        frameTime += frameFraction
        elapsed += seconds
        var events: [GameEvent] = []
        var everyTargetValidated = true
        let lowestUnvalidated = level.isSequential ? TurnRule.lowestUnvalidatedSequence(in: targets) : nil
        let cursor = gaze.position

        for index in targets.indices {
            var target = targets[index]
            let wasHolding = target.isHolding
            let noise = noiseSources[index]
            integrator.integrate(&target, gaze: cursor, noise: { noise.value(at: $0) }, frameTime: frameTime, frameFraction: frameFraction)
            let isTurn = TurnRule.isTurn(of: target, lowestUnvalidated: lowestUnvalidated, isSequential: level.isSequential)
            let transition = validationRule.apply(to: &target, isTurn: isTurn, elapsed: seconds)

            if target.isHolding {
                events.append(.validationProgressed(sequence: target.sequence, progress: target.validationProgress))
            } else if wasHolding {
                events.append(.validationProgressStopped(sequence: target.sequence))
            }
            switch transition {
            case .validated: events.append(.targetValidated(sequence: target.sequence))
            case .lost: events.append(.targetLost(sequence: target.sequence, cause: .drift))
            case .unchanged: break
            }
            if !target.isValidated { everyTargetValidated = false }
            targets[index] = target
        }

        if level.isSequential {
            let cascaded = CascadeRule.apply(to: &targets)
            for sequence in cascaded {
                events.append(.targetLost(sequence: sequence, cause: .cascade))
            }
            if !cascaded.isEmpty { everyTargetValidated = false }
        }

        if everyTargetValidated {
            isComplete = true
            events.append(.levelCompleted)
        }
        return events
    }
}
