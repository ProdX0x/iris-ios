// LevelPar.swift
// Layer: Domain
// Purpose: Reference time and intrusion count behind the "fluide" and "serein" éclats

import Foundation

struct LevelPar: Hashable, Sendable {
    let time: TimeInterval
    let intrusions: Int

    init(time: TimeInterval, intrusions: Int) {
        self.time = time
        self.intrusions = intrusions
    }
}
