// GameSession.swift
// Layer: GameEngine
// Purpose: Deterministic per-level simulation: physics, environment, validation, cascade, metrics and events
// (port of `step()`, extended by the campaign rules R-23 to R-28)

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
    private(set) var environment: LevelEnvironment
    private(set) var metrics = SessionMetrics()
    private(set) var isAttentionOnField = true

    private let noiseSources: [any NoiseSource]
    private let integrator: TargetPhysics
    private let validationRule: ValidationRule
    private var wasInZone: [Bool]
    /// Impulses queued for the next integration step by the expansion mechanics (one per target). Always zero in the
    /// historical chapters, whose step therefore stays bit-for-bit the reference step (a zero queue is never added).
    private var pendingImpulses: [Vector2]

    init(level: Level,
         bounds: PlayfieldBounds,
         physics: PhysicsConstants = .reference,
         validation: ValidationRules? = nil,
         environment: LevelEnvironment = .empty,
         initialGaze: Vector2? = nil,
         gazeJumpThreshold: Double = 300,
         noiseSources: [any NoiseSource]? = nil) {
        self.level = level
        self.bounds = bounds
        self.physics = physics
        let rules = validation ?? ValidationRules.reference(physics: physics)
        self.validation = rules
        self.environment = environment
        var targets = level.targets.map { Target(blueprint: $0, bounds: bounds, holdDuration: level.holdDuration) }
        for (index, path) in environment.irisPaths where targets.indices.contains(index) {
            targets[index].arrival = path.position(at: 0)
        }
        self.targets = targets
        self.gaze = GazeFilter(initialPosition: initialGaze ?? bounds.center, jumpThreshold: gazeJumpThreshold)
        self.noiseSources = noiseSources ?? level.targets.indices.map { ValueNoise1D(seed: 1000 + $0 * 137) }
        self.integrator = TargetPhysics(constants: physics, bounds: bounds)
        self.validationRule = ValidationRule(rules: rules)
        self.wasInZone = Array(repeating: false, count: targets.count)
        self.pendingImpulses = Array(repeating: .zero, count: targets.count)
        self.isAttentionOnField = true
    }

    var allValidated: Bool { targets.allSatisfy(\.isValidated) }
    var veilleuses: [VeilleuseState] { environment.veilleuses }
    /// EXPERIMENTAL (prototype B1): braises keyed by target index.
    var braises: [Int: BraiseState] { environment.braises }

    func radius(ofTargetAt index: Int) -> Double {
        environment.lueurRadii.indices.contains(index) ? environment.lueurRadii[index] : physics.targetRadius
    }

    /// Whether the iris of `target` is currently open (attention on field, every linked veilleuse lit, and, for a braise, lit).
    func isIrisOpen(for target: Target) -> Bool {
        isAttentionOnField
            && environment.veilleuses.allSatisfy { !$0.lights(sequence: target.sequence) || $0.isLit }
            && (environment.braises[target.sequence - 1]?.isLit ?? true)
    }

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
        wasInZone = Array(repeating: false, count: newTargets.count)
        pendingImpulses = Array(repeating: .zero, count: newTargets.count)
        isComplete = false
    }

    /// Queues an impulse (points per reference frame) that the next step adds to the target's velocity, on top of the
    /// currents. Used by the expansion mechanics and their tests; the queue is consumed by the next tick.
    mutating func applyImpulse(_ impulse: Vector2, toTargetAt index: Int) {
        guard pendingImpulses.indices.contains(index) else { return }
        pendingImpulses[index] += impulse
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
        let cursor = gaze.position
        updateAttention(cursor: cursor, events: &events)
        updateVeilleuses(seconds: seconds, cursor: cursor, events: &events)
        updateBraises(seconds: seconds, cursor: cursor, events: &events)

        var everyTargetValidated = true
        let lowestUnvalidated = level.isSequential ? TurnRule.lowestUnvalidatedSequence(in: targets) : nil

        for index in targets.indices {
            var target = targets[index]
            let wasHolding = target.isHolding
            if let path = environment.irisPaths[index] {
                target.arrival = path.position(at: elapsed)
            }
            detectIntrusion(index: index, target: target, cursor: cursor, events: &events)

            let noise = noiseSources[index]
            let queued = pendingImpulses[index]
            pendingImpulses[index] = .zero
            let fieldImpulse = environment.impulse(at: target.position)
            let externalImpulse = queued == .zero ? fieldImpulse : fieldImpulse + queued
            integrator.integrate(&target, gaze: cursor, noise: { noise.value(at: $0) }, frameTime: frameTime,
                                 frameFraction: frameFraction, externalImpulse: externalImpulse,
                                 behaviour: environment.braises[index]?.behaviour ?? .neutral)
            for veil in environment.veils {
                veil.resolve(&target, radius: radius(ofTargetAt: index), bounceLoss: physics.bounceLoss)
            }

            let irisOpen = isIrisOpen(for: target)
            let linkedLit = environment.veilleuses.allSatisfy { !$0.lights(sequence: target.sequence) || $0.isLit }
            if target.isValidated && !linkedLit {
                target.isValidated = false
                target.holdTime = 0
                events.append(.targetLost(sequence: target.sequence, cause: .veilleuse))
                metrics.losses += 1
            }
            let isTurn = TurnRule.isTurn(of: target, lowestUnvalidated: lowestUnvalidated, isSequential: level.isSequential)
            let transition = validationRule.apply(to: &target, isTurn: isTurn, elapsed: seconds, canAccumulate: irisOpen)

            if target.isHolding {
                if irisOpen {
                    events.append(.validationProgressed(sequence: target.sequence, progress: target.validationProgress))
                }
            } else if wasHolding {
                events.append(.validationProgressStopped(sequence: target.sequence))
            }
            switch transition {
            case .validated:
                events.append(.targetValidated(sequence: target.sequence))
            case .lost:
                events.append(.targetLost(sequence: target.sequence, cause: .drift))
                metrics.losses += 1
            case .unchanged:
                break
            }
            if !target.isValidated { everyTargetValidated = false }
            targets[index] = target
        }

        if level.isSequential {
            let cascaded = CascadeRule.apply(to: &targets)
            for sequence in cascaded {
                events.append(.targetLost(sequence: sequence, cause: .cascade))
                metrics.losses += 1
            }
            if !cascaded.isEmpty { everyTargetValidated = false }
        }

        if everyTargetValidated {
            isComplete = true
            events.append(.levelCompleted)
        }
        return events
    }

    private mutating func updateAttention(cursor: Vector2, events: inout [GameEvent]) {
        guard environment.requiresAttentionOnField else { return }
        let onField = gaze.isActive && environment.isOnField(cursor, bounds: bounds)
        guard onField != isAttentionOnField else { return }
        isAttentionOnField = onField
        if onField {
            events.append(.attentionReturned)
        } else {
            metrics.attentionExits += 1
            events.append(.attentionLeftField)
        }
    }

    private mutating func updateVeilleuses(seconds: TimeInterval, cursor: Vector2, events: inout [GameEvent]) {
        for index in environment.veilleuses.indices {
            switch environment.veilleuses[index].update(seconds: seconds, gaze: cursor, gazeActive: gaze.isActive) {
            case .becameLow: events.append(.veilleuseLow(index: index))
            case .wentOut: events.append(.veilleuseOut(index: index))
            case .relit: events.append(.veilleuseRelit(index: index))
            case .none: break
            }
        }
    }

    /// EXPERIMENTAL (prototype B1): warms or cools each braise from the gaze distance to its lueur.
    private mutating func updateBraises(seconds: TimeInterval, cursor: Vector2, events: inout [GameEvent]) {
        for index in environment.braises.keys.sorted() where targets.indices.contains(index) {
            guard var braise = environment.braises[index] else { continue }
            let distance = targets[index].position.distance(to: cursor)
            let change = braise.update(seconds: seconds, gazeDistance: distance, gazeActive: gaze.isActive)
            environment.braises[index] = braise
            switch change {
            case .lit: events.append(.braiseLit(sequence: targets[index].sequence))
            case .cooled: events.append(.braiseCooled(sequence: targets[index].sequence))
            case .flared: events.append(.braiseFlared(sequence: targets[index].sequence))
            case .none: break
            }
        }
    }

    private mutating func detectIntrusion(index: Int, target: Target, cursor: Vector2, events: inout [GameEvent]) {
        let inZone = gaze.isActive && target.position.distance(to: cursor) < target.attentionZone
        if inZone && !wasInZone[index] {
            metrics.intrusions += 1
            events.append(.intrusion(sequence: target.sequence))
        }
        wasInZone[index] = inZone
    }
}
