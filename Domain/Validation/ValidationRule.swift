// ValidationRule.swift
// Layer: Domain
// Purpose: R-08 continuous 0.75 s presence and R-10 wobble tolerance loss, applied to one target per tick

import Foundation

struct ValidationRule: Hashable, Sendable {
    let rules: ValidationRules

    init(rules: ValidationRules = .reference) {
        self.rules = rules
    }

    /// Mirrors the reference engine: a validated target loses its place beyond the wobble tolerance;
    /// an unvalidated target accumulates presence only inside the settle radius and only on its turn;
    /// anything else resets the accumulated presence to zero.
    func apply(to target: inout Target, isTurn: Bool, elapsed: TimeInterval) -> ValidationTransition {
        let distance = target.distanceToArrival
        let wasValidated = target.isValidated
        if target.isValidated {
            if distance > rules.wobbleTolerance {
                target.isValidated = false
                target.holdTime = 0
            }
        } else if distance < rules.settleRadius && isTurn {
            target.holdTime += elapsed
            target.isValidated = target.holdTime >= target.requiredHoldTime - rules.holdEpsilon
        } else {
            target.holdTime = 0
        }
        if target.isValidated && !wasValidated { return .validated }
        if !target.isValidated && wasValidated { return .lost }
        return .unchanged
    }
}
