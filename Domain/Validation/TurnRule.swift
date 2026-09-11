// TurnRule.swift
// Layer: Domain
// Purpose: R-09 sequence rule: validation only counts for the lowest unvalidated sequence number

import Foundation

enum TurnRule {
    /// Lowest sequence number among unvalidated targets, or nil when every target is validated.
    static func lowestUnvalidatedSequence(in targets: [Target]) -> Int? {
        targets.lazy.filter { !$0.isValidated }.map(\.sequence).min()
    }

    /// A target may accumulate presence when the level is not sequential, when it is already validated
    /// (it keeps its place), or when it carries the lowest unvalidated sequence number.
    static func isTurn(of target: Target, lowestUnvalidated: Int?, isSequential: Bool) -> Bool {
        !isSequential || target.isValidated || target.sequence == lowestUnvalidated
    }
}
