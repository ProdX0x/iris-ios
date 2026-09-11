// ValidationTransition.swift
// Layer: Domain
// Purpose: Outcome of applying the validation rule to one target during one tick

import Foundation

enum ValidationTransition: Hashable, Sendable {
    case unchanged
    case validated
    case lost
}
