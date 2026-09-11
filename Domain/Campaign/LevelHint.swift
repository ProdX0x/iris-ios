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
}

struct LevelHint: Hashable, Sendable {
    let trigger: HintTrigger
    let text: String

    init(_ trigger: HintTrigger, _ text: String) {
        self.trigger = trigger
        self.text = text
    }
}
