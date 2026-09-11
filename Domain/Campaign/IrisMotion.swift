// IrisMotion.swift
// Layer: Domain
// Purpose: R-27 whether an iris stays still or glides back and forth

import Foundation

enum IrisMotion: Hashable, Sendable {
    case fixed
    /// Glides from the iris to `to` and back with a cosine ease, full cycle in `period` seconds.
    case oscillate(to: NormalizedPoint, period: TimeInterval)

    var isMoving: Bool {
        if case .oscillate = self { return true }
        return false
    }
}
