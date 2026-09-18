// HomeText.swift
// Layer: Presentation (shared)
// Purpose: Gives the threshold's main action a stable identity. Its three sentences live in Navigation/HomeSummary,
// whose bytes are frozen: the identity is rebuilt here from what the action IS, and the French it already carries is
// the fallback. Nothing in Navigation is read as a key, copied, or modified

import Foundation

enum HomeText {
    /// A stable token per action, written out case by case — never `String(describing:)`.
    static func token(for action: HomeSummary.Action) -> String {
        switch action {
        case .begin: "begin"
        case .resume: "resume"
        case .replay: "replay"
        }
    }

    static func key(for action: HomeSummary.Action) -> String { "home.action.\(token(for: action))" }

    /// What the main button says, localised.
    static func primaryTitle(of summary: HomeSummary) -> String {
        IrisText.interface(key(for: summary.action), french: summary.primaryTitle)
    }
}
