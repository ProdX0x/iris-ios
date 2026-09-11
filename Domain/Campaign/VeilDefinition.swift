// VeilDefinition.swift
// Layer: Domain
// Purpose: R-25 an impenetrable segment

import Foundation

struct VeilDefinition: Hashable, Sendable {
    let a: NormalizedPoint
    let b: NormalizedPoint

    init(a: NormalizedPoint, b: NormalizedPoint) {
        self.a = a
        self.b = b
    }
}
