// AppSheet.swift
// Layer: Presentation (Navigation)
// Purpose: Modal sheets presented above the current route

import Foundation

enum AppSheet: String, Identifiable, Hashable, Sendable {
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .settings: "Réglages"
        }
    }
}
