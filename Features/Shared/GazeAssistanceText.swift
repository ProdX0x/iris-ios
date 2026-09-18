// GazeAssistanceText.swift
// Layer: Presentation (shared)
// Purpose: Gives each gaze-assistance mode a stable identity. The three modes and their wording belong to the Domain,
// which must not know about bundles or languages: the identity is rebuilt here from the mode itself, and the French
// the Domain already holds is the fallback. Same hinge as GazeReadinessText, for the same reason

import Foundation

enum GazeAssistanceText {
    /// What a row is saying about a mode: its name, the sentence the settings afford, the two words the pause affords.
    enum Facet: String {
        case title
        case summary
        case compact
    }

    static func key(_ facet: Facet, for mode: GazeAssistanceMode) -> String {
        "gazeAssistance.mode.\(mode.rawValue).\(facet.rawValue)"
    }

    static func title(of mode: GazeAssistanceMode) -> String {
        IrisText.interface(key(.title, for: mode), french: mode.title)
    }

    static func summary(of mode: GazeAssistanceMode) -> String {
        IrisText.interface(key(.summary, for: mode), french: mode.summary)
    }

    static func compactSummary(of mode: GazeAssistanceMode) -> String {
        IrisText.interface(key(.compact, for: mode), french: mode.compactSummary)
    }
}
