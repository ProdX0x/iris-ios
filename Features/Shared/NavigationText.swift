// NavigationText.swift
// Layer: Presentation (shared)
// Purpose: Stable identities for the sentences the navigation owns. Those sentences live in Navigation/, whose bytes
// are frozen by the glass suite: nothing here reads, copies or modifies those files as text — each identity is rebuilt
// from what the thing IS, and the French the frozen type already returns is passed as the fallback
//
// Two of the three hinges below are reachable today. The third is not, and says so: see `title(of:)`

import Foundation

enum NavigationText {
    // MARK: - Reachable: the level line under the threshold's main action

    /// The line `HomeSummary.detail` carries, rebuilt where it is drawn. `AppCoordinator.label(for:)` composes it
    /// inside a frozen file and hands it over already assembled, with no way to translate the chapter name or the
    /// level title it contains. HomeView has the level itself, so the same line is composed again here — from keys.
    ///
    /// Composing it twice is a risk, and the risk is answered by a test: the two must agree on every level of the
    /// campaign, character for character, or the suite fails.
    static let levelLabelKey = "navigation.levelLabel"

    static func label(for level: LevelDefinition) -> String {
        let chapter = Campaign.chapter(of: level)
        return IrisText.interface(levelLabelKey, french: "%@ · %@ — %lld · %@",
                                  chapter?.numeral ?? "",
                                  chapter.map(CampaignText.name(of:)) ?? "",
                                  level.index,
                                  CampaignText.title(of: level))
    }

    // MARK: - Reserved: blocked by the freeze

    /// Localisation debt, stated rather than worked around. `AppSheet.title` and `AppDestination.title` are drawn in
    /// exactly one place — `Navigation/RootView.swift`, frozen — which calls them directly and leaves no seam to pass
    /// through. Nothing here can change that without editing a frozen file, and no such edit will be made.
    ///
    /// What is possible is to fix the identities now, so the catalogue can be translated in full and so the day the
    /// freeze is deliberately revisited, each call site becomes a one-line change. These functions render the frozen
    /// French unchanged today; a test holds them to it.
    static func key(sheet: AppSheet) -> String { "navigation.sheet.\(sheet.rawValue).title" }

    static func key(destination: AppDestination) -> String { "navigation.destination.\(destination.rawValue).title" }

    static func title(of sheet: AppSheet) -> String {
        IrisText.interface(key(sheet: sheet), french: sheet.title)
    }

    static func title(of destination: AppDestination) -> String {
        IrisText.interface(key(destination: destination), french: destination.title)
    }
}
