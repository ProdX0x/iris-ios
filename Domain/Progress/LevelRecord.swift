// LevelRecord.swift
// Layer: Domain
// Purpose: Best results kept for one level (no gaze data)

import Foundation

struct LevelRecord: Codable, Hashable, Sendable {
    var completions: Int
    var bestTime: TimeInterval?
    var fewestIntrusions: Int?
    var eclats: Set<Eclat>

    init(completions: Int = 0, bestTime: TimeInterval? = nil, fewestIntrusions: Int? = nil, eclats: Set<Eclat> = []) {
        self.completions = completions
        self.bestTime = bestTime
        self.fewestIntrusions = fewestIntrusions
        self.eclats = eclats
    }

    var isCompleted: Bool { completions > 0 }

    /// Merges an attempt: éclats accumulate, bests improve.
    mutating func register(_ outcome: LevelOutcome, par: LevelPar) {
        completions += 1
        bestTime = min(bestTime ?? outcome.time, outcome.time)
        fewestIntrusions = min(fewestIntrusions ?? outcome.intrusions, outcome.intrusions)
        eclats.formUnion(outcome.eclats(par: par))
    }
}
