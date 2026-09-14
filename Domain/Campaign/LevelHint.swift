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
    /// Chapter IX: the first time an echo wakes a sleeping lueur.
    case firstWake
    /// Chapter X: the first time a well swallows a lueur.
    case firstSwallow
    /// PROTOTYPE: the first balise woke; the whole thread is complete.
    case firstBalise
    case balisesCompleted
    /// OCULOMOTOR EXPANSION: first success of a stage, first miss, the whole sequence complete.
    case firstOculoSuccess
    case firstOculoMiss
    case oculoCompleted
}

struct LevelHint: Hashable, Sendable {
    let trigger: HintTrigger
    let text: String

    init(_ trigger: HintTrigger, _ text: String) {
        self.trigger = trigger
        self.text = text
    }
}
