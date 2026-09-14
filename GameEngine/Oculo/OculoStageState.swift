// OculoStageState.swift
// Layer: GameEngine
// Purpose: OCULOMOTOR EXPANSION: the resolved gaze-contingent stages of a level and their sequence. Every stage is a
// small deterministic machine fed with the smoothed gaze, its activity and the head pose; it reports successes,
// misses and its completion, and can suggest the ideal gaze and head (the simulated player's oracle).

import Foundation

/// What a stage receives every tick.
struct OculoInput: Hashable, Sendable {
    let seconds: TimeInterval
    let gaze: Vector2
    let gazeActive: Bool
    let head: HeadPose?
    let elapsed: TimeInterval

    init(seconds: TimeInterval, gaze: Vector2, gazeActive: Bool, head: HeadPose?, elapsed: TimeInterval) {
        self.seconds = seconds
        self.gaze = gaze
        self.gazeActive = gazeActive
        self.head = head
        self.elapsed = elapsed
    }
}

enum OculoChange: Hashable, Sendable {
    case success
    case miss
    case completed
}

/// What a stage returns: its changes, and impulses to give lueurs (chapter XI only).
struct OculoOutcome: Hashable, Sendable {
    var changes: [OculoChange] = []
    var impulses: [OculoImpulse] = []
}

struct OculoImpulse: Hashable, Sendable {
    let target: Int
    let impulse: Vector2
}

/// One resolved stage. Cases are added chapter by chapter; each delegates to its own state.
enum OculoStageState: Hashable, Sendable {
    case coeur(CoeurStageState)
    case fil(FilStageState)
    case miroir(MiroirStageState)
    case etoiles(EtoilesStageState)
    case jardin(JardinStageState)
}

extension OculoStageState {
    /// Resolves an authored stage on the playfield.
    init(definition: OculoStageDefinition, bounds: PlayfieldBounds, shortSide: Double, scale: Double) {
        switch definition {
        case let .coeur(coeur): self = .coeur(CoeurStageState(definition: coeur, bounds: bounds, shortSide: shortSide))
        case let .fil(fil): self = .fil(FilStageState(definition: fil, bounds: bounds, shortSide: shortSide))
        case let .miroir(miroir): self = .miroir(MiroirStageState(definition: miroir, bounds: bounds, shortSide: shortSide))
        case let .etoiles(etoiles): self = .etoiles(EtoilesStageState(definition: etoiles, bounds: bounds, shortSide: shortSide))
        case let .jardin(jardin): self = .jardin(JardinStageState(definition: jardin, bounds: bounds, shortSide: shortSide))
        }
    }

    mutating func update(_ input: OculoInput, targets: [Target], braisesLit: [Int]) -> OculoOutcome {
        switch self {
        case var .coeur(state):
            let outcome = state.update(input)
            self = .coeur(state)
            return outcome
        case var .fil(state):
            let outcome = state.update(input)
            self = .fil(state)
            return outcome
        case var .miroir(state):
            let outcome = state.update(input)
            self = .miroir(state)
            return outcome
        case var .etoiles(state):
            let outcome = state.update(input)
            self = .etoiles(state)
            return outcome
        case var .jardin(state):
            let outcome = state.update(input)
            self = .jardin(state)
            return outcome
        }
    }

    var isComplete: Bool {
        switch self {
        case let .coeur(state): state.isComplete
        case let .fil(state): state.isComplete
        case let .miroir(state): state.isComplete
        case let .etoiles(state): state.isComplete
        case let .jardin(state): state.isComplete
        }
    }

    /// 0...1 progress of the stage.
    var progress: Double {
        switch self {
        case let .coeur(state): state.progress
        case let .fil(state): state.progress
        case let .miroir(state): state.progress
        case let .etoiles(state): state.progress
        case let .jardin(state): state.progress
        }
    }

    /// Where the ideal player looks now (nil: anywhere), for the simulated player only.
    func suggestedGaze(at elapsed: TimeInterval) -> Vector2? {
        switch self {
        case let .coeur(state): state.position
        case let .fil(state): state.position(at: elapsed)
        case let .miroir(state): state.suggestedGaze(at: elapsed)
        case let .etoiles(state): state.suggestedGaze(at: elapsed)
        case let .jardin(state): state.suggestedGaze
        }
    }

    /// The head orientation the ideal player adopts now (nil: no preference).
    var suggestedHead: HeadPose? {
        switch self {
        case .coeur, .fil, .miroir, .etoiles, .jardin: nil
        }
    }
}

/// The stages of a level, played one after the other with a breath between them.
struct OculoSequenceState: Hashable, Sendable {
    private(set) var stages: [OculoStageState]
    let hidesLueurs: Bool
    let pause: TimeInterval
    private(set) var currentIndex = 0
    /// While a stage just completed, the breath before the next one.
    private(set) var pauseRemaining: TimeInterval = 0
    private(set) var completedAt: TimeInterval?
    private(set) var successes = 0
    private(set) var misses = 0

    init(stages: [OculoStageState], hidesLueurs: Bool, pause: TimeInterval) {
        self.stages = stages
        self.hidesLueurs = hidesLueurs
        self.pause = pause
        if stages.isEmpty { completedAt = 0 }
    }

    var isComplete: Bool { completedAt != nil }
    var isBreathing: Bool { pauseRemaining > 0 }
    var current: OculoStageState? { stages.indices.contains(currentIndex) ? stages[currentIndex] : nil }
    var stageCount: Int { stages.count }

    var progress: Double {
        guard !stages.isEmpty else { return 1 }
        if isComplete { return 1 }
        return (Double(currentIndex) + (current?.progress ?? 0)) / Double(stages.count)
    }

    enum Change: Hashable, Sendable {
        case success(stage: Int)
        case miss(stage: Int)
        case stageCompleted(stage: Int)
        case completed
    }

    mutating func update(_ input: OculoInput, targets: [Target], braisesLit: [Int]) -> (changes: [Change], impulses: [OculoImpulse]) {
        guard !isComplete, stages.indices.contains(currentIndex) else { return ([], []) }
        if pauseRemaining > 0 {
            pauseRemaining = max(0, pauseRemaining - input.seconds)
            return ([], [])
        }
        let outcome = stages[currentIndex].update(input, targets: targets, braisesLit: braisesLit)
        var changes: [Change] = []
        for change in outcome.changes {
            switch change {
            case .success:
                successes += 1
                changes.append(.success(stage: currentIndex))
            case .miss:
                misses += 1
                changes.append(.miss(stage: currentIndex))
            case .completed:
                changes.append(.stageCompleted(stage: currentIndex))
            }
        }
        if stages[currentIndex].isComplete {
            if !changes.contains(.stageCompleted(stage: currentIndex)) { changes.append(.stageCompleted(stage: currentIndex)) }
            currentIndex += 1
            if currentIndex >= stages.count {
                completedAt = input.elapsed
                changes.append(.completed)
            } else {
                pauseRemaining = pause
            }
        }
        return (changes, outcome.impulses)
    }

    func suggestedGaze(at elapsed: TimeInterval) -> Vector2? {
        guard !isComplete, pauseRemaining <= 0 else { return nil }
        return current?.suggestedGaze(at: elapsed)
    }

    var suggestedHead: HeadPose? {
        guard !isComplete, pauseRemaining <= 0 else { return nil }
        return current?.suggestedHead
    }
}
