// Eclat.swift
// Layer: Domain
// Purpose: The three mastery marks of a level

import Foundation

enum Eclat: String, Codable, Hashable, Sendable, CaseIterable, Comparable {
    case atteint
    case fluide
    case serein

    var title: String { rawValue }

    var condition: String {
        switch self {
        case .atteint: "terminer le niveau"
        case .fluide: "le terminer sans s'attarder"
        case .serein: "ne rien perdre, troubler peu"
        }
    }

    private var order: Int {
        switch self {
        case .atteint: 0
        case .fluide: 1
        case .serein: 2
        }
    }

    static func < (lhs: Eclat, rhs: Eclat) -> Bool { lhs.order < rhs.order }
}
