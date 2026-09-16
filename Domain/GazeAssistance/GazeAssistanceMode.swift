// GazeAssistanceMode.swift
// Layer: Domain
// Purpose: How much help the player wants seeing where Iris thinks they are looking. A product choice, not a
// diagnostic switch: three states, one of them the default for a new player

import Foundation

enum GazeAssistanceMode: String, CaseIterable, Hashable, Sendable, Codable {
    /// No marker during play; the edge halo still says when the gaze leaves the useful area.
    case classic
    /// The marker appears briefly, on a fixed cycle, then fades out again.
    case guided
    /// The marker stays while the tracking gives a valid position.
    case visible

    /// What a new player gets.
    static let `default`: GazeAssistanceMode = .classic

    var title: String {
        switch self {
        case .classic: "Classique"
        case .guided: "Guidé"
        case .visible: "Visible"
        }
    }

    /// One sentence, in the player's terms. Nothing here is a diagnostic name.
    var summary: String {
        switch self {
        case .classic: "Le repère reste masqué. Un halo discret vous indique seulement quand votre regard sort de la zone utile."
        case .guided: "Le repère apparaît brièvement, de temps en temps, pour vous aider à vous recaler."
        case .visible: "Le repère reste visible pendant le jeu."
        }
    }
}
