// GazeIntroductionPage.swift
// Layer: Presentation
// Purpose: The three things a player must understand before the very first level: the marker is an estimate, Iris
// shows it at the start, and the choice stays theirs. Iris is a game; nothing here promises anything about health

import Foundation

struct GazeIntroductionPage: Hashable, Sendable, Identifiable {
    let title: String
    let detail: String
    /// A second, quieter paragraph; nil on the pages that do not need one.
    let note: String?

    var id: String { title }

    static let all: [GazeIntroductionPage] = [
        GazeIntroductionPage(
            title: "Votre regard n'est pas un point fixe",
            detail: "Le point lumineux montre où Iris estime que vous regardez. Il peut bouger légèrement même quand vous pensez fixer exactement le même endroit.",
            note: nil),
        GazeIntroductionPage(
            title: "Iris vous accompagne au début",
            detail: "Dans les deux premiers niveaux, le repère reste visible. Au troisième, il disparaît progressivement pour vous apprendre à jouer sans lui.",
            note: nil),
        GazeIntroductionPage(
            title: "Vous gardez toujours le choix",
            detail: "Vous pouvez réactiver une aide à tout moment dans Réglages, « Aide au regard ».",
            note: "Plus le pourcentage d'écart de calibration est faible, plus la calibration correspond précisément à votre regard. 0 % est une référence idéale : un écart nul n'est pas attendu en usage réel."),
    ]

    /// What the main action says on each page.
    static func actionTitle(atIndex index: Int) -> String {
        index >= all.count - 1 ? "Commencer" : "Suivant"
    }
}
