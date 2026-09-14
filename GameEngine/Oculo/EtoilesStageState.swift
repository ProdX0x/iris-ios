// EtoilesStageState.swift
// Layer: GameEngine
// Purpose: Chapter V final: rounds of stars shown, hidden, then recalled by dwelling where they were; a wrong place
// counts a miss without penalty, a round not recalled in time is shown again

import Foundation

struct EtoilesStageState: Hashable, Sendable {
    let candidates: [Vector2]
    let rounds: [[Int]]
    let showDuration: TimeInterval
    let blankDuration: TimeInterval
    let recallLimit: TimeInterval
    let radius: Double
    let releaseRadius: Double
    let dwell: TimeInterval

    enum Phase: Hashable, Sendable {
        case show(start: TimeInterval)
        case blank(start: TimeInterval)
        case recall(start: TimeInterval)
        case done
    }

    private(set) var phase: Phase = .show(start: 0)
    private(set) var roundIndex = 0
    /// Stars found in the current round.
    private(set) var found: Set<Int> = []
    /// Stars of completed rounds, for the constellation.
    private(set) var constellation: [Int] = []
    private(set) var repeats = 0
    private(set) var wrongDwells = 0
    private(set) var dwellTime: TimeInterval = 0
    private(set) var dwellingOn: Int?
    private var blamed: Set<Int> = []

    init(definition: EtoilesDefinition, bounds: PlayfieldBounds, shortSide: Double) {
        candidates = definition.candidates.map { $0.absolute(in: bounds) }
        rounds = definition.rounds
        showDuration = definition.showDuration
        blankDuration = definition.blankDuration
        recallLimit = definition.recallLimit
        radius = definition.radius * shortSide
        releaseRadius = definition.releaseRadius * shortSide
        dwell = definition.dwell
        if rounds.isEmpty { phase = .done }
    }

    var isComplete: Bool { phase == .done }
    var currentRound: [Int] { rounds.indices.contains(roundIndex) ? rounds[roundIndex] : [] }
    var totalStars: Int { rounds.reduce(0) { $0 + $1.count } }
    var progress: Double { totalStars == 0 ? 1 : Double(constellation.count + found.count) / Double(totalStars) }
    var isShowing: Bool { if case .show = phase { return true } else { return false } }
    var isRecalling: Bool { if case .recall = phase { return true } else { return false } }
    var missing: [Int] { currentRound.filter { !found.contains($0) } }

    mutating func update(_ input: OculoInput) -> OculoOutcome {
        var outcome = OculoOutcome()
        switch phase {
        case .done:
            return outcome
        case let .show(start):
            if input.elapsed - start >= showDuration { phase = .blank(start: input.elapsed) }
            return outcome
        case let .blank(start):
            if input.elapsed - start >= blankDuration {
                phase = .recall(start: input.elapsed)
                dwellTime = 0
                dwellingOn = nil
                blamed = []
            }
            return outcome
        case let .recall(start):
            guard input.gazeActive else { return outcome }
            // Which candidate the gaze rests on, with hysteresis on the one it already rests on.
            if let on = dwellingOn, input.gaze.distance(to: candidates[on]) <= releaseRadius {
                dwellTime += input.seconds
            } else {
                dwellingOn = candidates.indices.first { input.gaze.distance(to: candidates[$0]) <= radius }
                dwellTime = dwellingOn == nil ? 0 : input.seconds
            }
            if let on = dwellingOn, dwellTime >= dwell - 1e-9 {
                if currentRound.contains(on), !found.contains(on) {
                    found.insert(on)
                    outcome.changes.append(.success)
                    dwellTime = 0
                    dwellingOn = nil
                    if missing.isEmpty {
                        constellation += currentRound
                        roundIndex += 1
                        found = []
                        if roundIndex >= rounds.count {
                            phase = .done
                            outcome.changes.append(.completed)
                        } else {
                            phase = .show(start: input.elapsed)
                        }
                    }
                    return outcome
                } else if !currentRound.contains(on), !blamed.contains(on) {
                    blamed.insert(on)
                    wrongDwells += 1
                    outcome.changes.append(.miss)
                }
            }
            if input.elapsed - start > recallLimit {
                repeats += 1
                found = []
                outcome.changes.append(.miss)
                phase = .show(start: input.elapsed)
            }
            return outcome
        }
    }

    /// The ideal player watches the stars while they shine and returns to the first missing one afterwards.
    func suggestedGaze(at time: TimeInterval) -> Vector2? {
        switch phase {
        case .show, .blank:
            return currentRound.first.map { candidates[$0] }
        case .recall:
            return missing.first.map { candidates[$0] }
        case .done:
            return nil
        }
    }
}
