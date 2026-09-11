// CascadeRule.swift
// Layer: Domain
// Purpose: R-11 cascade: losing a validation invalidates every validated target of higher rank

import Foundation

enum CascadeRule {
    /// Invalidates every validated target whose sequence is greater than the first unvalidated one
    /// (array order, which is sequence order). Returns the sequences that were invalidated, in array order.
    @discardableResult
    static func apply(to targets: inout [Target]) -> [Int] {
        guard let broken = targets.first(where: { !$0.isValidated })?.sequence else { return [] }
        var invalidated: [Int] = []
        for index in targets.indices where targets[index].isValidated && targets[index].sequence > broken {
            targets[index].isValidated = false
            targets[index].holdTime = 0
            invalidated.append(targets[index].sequence)
        }
        return invalidated
    }
}
