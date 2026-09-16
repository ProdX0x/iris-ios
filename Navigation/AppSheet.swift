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
    /// The three screens that introduce the gaze marker, before the very first level.
    case gazeIntroduction

    var id: String { rawValue }

    var title: String {
        switch self {
        case .settings: "Réglages"
        case .paywall: "Accès complet"
        case .howToPlay: "Comment jouer"
        case .gazeIntroduction: "Aide au regard"
        }
    }
}
