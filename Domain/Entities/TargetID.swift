// TargetID.swift
// Layer: Domain
// Purpose: Typed identity of a target inside a level; the sequence number is unique per level

import Foundation

struct TargetID: Hashable, Sendable, Comparable {
    let sequence: Int

    init(sequence: Int) {
        self.sequence = sequence
    }

    static func < (lhs: TargetID, rhs: TargetID) -> Bool { lhs.sequence < rhs.sequence }
}
