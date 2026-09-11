// Temperament.swift
// Layer: Domain
// Purpose: R-28 how strongly a lueur reacts to the gaze and to its iris

import Foundation

enum Temperament: String, Hashable, Sendable, CaseIterable {
    case normale
    case lourde
    case vive

    var repulsionMultiplier: Double {
        switch self {
        case .normale: 1
        case .lourde: 0.6
        case .vive: 1.45
        }
    }

    var attractionMultiplier: Double {
        switch self {
        case .normale: 1
        case .lourde: 0.6
        case .vive: 1.2
        }
    }

    var radiusMultiplier: Double {
        switch self {
        case .normale: 1
        case .lourde: 1.2
        case .vive: 0.8
        }
    }
}
