// LevelID.swift
// Layer: Domain
// Purpose: Typed identity of a level (`level_01` ... `level_14` in the reference engine)

import Foundation

struct LevelID: Hashable, Sendable, CustomStringConvertible {
    let raw: String

    init(raw: String) {
        self.raw = raw
    }

    init(number: Int) {
        let padded = number < 10 ? "0\(number)" : "\(number)"
        self.raw = "level_\(padded)"
    }

    var description: String { raw }
}
