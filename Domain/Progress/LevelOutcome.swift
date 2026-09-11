// LevelOutcome.swift
// Layer: Domain
// Purpose: Measurements of one completed attempt and the éclats they earn

import Foundation

struct LevelOutcome: Codable, Hashable, Sendable {
    let time: TimeInterval
    let intrusions: Int
    let losses: Int

    init(time: TimeInterval, intrusions: Int, losses: Int) {
        self.time = time
        self.intrusions = intrusions
        self.losses = losses
    }

    /// Atteint always; fluide when under par time; serein when nothing was lost and intrusions stay within par.
    func eclats(par: LevelPar) -> Set<Eclat> {
        var earned: Set<Eclat> = [.atteint]
        if time <= par.time { earned.insert(.fluide) }
        if losses == 0 && intrusions <= par.intrusions { earned.insert(.serein) }
        return earned
    }
}
