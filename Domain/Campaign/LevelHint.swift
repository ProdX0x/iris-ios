// LevelHint.swift
// Layer: Domain
// Purpose: Contextual instruction shown once when the player does (or fails to do) something

import Foundation

enum HintTrigger: Hashable, Sendable {
    case start
    case afterSeconds(TimeInterval)
    case firstIntrusion
    case firstHold
    case firstValidation
    case firstLoss
    case attentionLeftField
    case veilleuseLow
    /// EXPERIMENTAL (prototype B1).
    case braiseLit
    case braiseFlared
    /// Chapter VII: the first time two twins come within reach of each other.
    case twinsLinked
    /// Chapter VIII: the first time a gust carries a lueur.
    case firstCarried
}

struct LevelHint: Hashable, Sendable {
    let trigger: HintTrigger
    let text: String

    init(_ trigger: HintTrigger, _ text: String) {
        self.trigger = trigger
        self.text = text
    }
}
