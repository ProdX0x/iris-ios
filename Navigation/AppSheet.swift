// AppSheet.swift
// Layer: Presentation (Navigation)
// Purpose: Modal sheets presented above the current route

import Foundation

enum AppSheet: String, Identifiable, Hashable, Sendable, CaseIterable {
    case settings
    /// What the full access is and how to get it; opened by a locked chapter or by a locked level.
    case paywall
    /// The four explanations, available for good.
    case howToPlay

    var id: String { rawValue }

    var title: String {
        switch self {
        case .settings: "Réglages"
        case .paywall: "Accès complet"
        case .howToPlay: "Comment jouer"
        }
    }
}
