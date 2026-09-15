// AppDestination.swift
// Layer: Presentation (Navigation)
// Purpose: The three permanent destinations of the tab bar and the routes they stand for; every other route is
// immersive and shows no navigation chrome

import Foundation

enum AppDestination: String, Hashable, Sendable, CaseIterable {
    case seuil
    case chapitres
    case carnet

    /// The destination a route belongs to, or nil when the route is immersive (permission, calibration, game, end).
    init?(route: AppRoute) {
        switch route {
        case .home: self = .seuil
        case .chapters: self = .chapitres
        case .carnet: self = .carnet
        case .cameraAccess, .gazeSetup, .game, .journeyComplete, .unavailable: return nil
        }
    }

    /// The route this destination shows.
    var route: AppRoute {
        switch self {
        case .seuil: .home
        case .chapitres: .chapters
        case .carnet: .carnet
        }
    }

    var title: String {
        switch self {
        case .seuil: "Seuil"
        case .chapitres: "Chapitres"
        case .carnet: "Carnet"
        }
    }

    var systemImage: String {
        switch self {
        case .seuil: "circle.dotted"
        case .chapitres: "square.stack"
        case .carnet: "book.closed"
        }
    }
}
