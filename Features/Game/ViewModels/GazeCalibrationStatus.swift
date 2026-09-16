// GazeCalibrationStatus.swift
// Layer: Presentation
// Purpose: What the game knows about the calibration in use, said in the player's words. The figure is the
// engine's own mean validation error: nothing here recomputes it, rounds it differently or grades it

import Foundation

enum GazeCalibrationStatus: Hashable, Sendable {
    case uncalibrated
    case calibrated(meanError: Double?, isValid: Bool)

    /// One short line for the pause panel.
    var description: String {
        switch self {
        case .uncalibrated:
            return "Regard non calibré."
        case let .calibrated(meanError, isValid):
            let headline = isValid ? "Calibration réussie" : "Calibration à refaire"
            guard let meanError else { return headline + "." }
            return "\(headline) — écart moyen \(Self.percentage(meanError)) %."
        }
    }

    /// The line under the figure. A percentage means nothing on its own: this says which way is better, without
    /// suggesting that zero is required or that anyone reaches it.
    var explanation: String? {
        switch self {
        case .uncalibrated:
            return "Recalibrez pour qu'Iris suive votre regard plus précisément."
        case .calibrated:
            return "Plus l'écart est faible, plus le suivi du regard est précis."
        }
    }

    /// The engine's mean validation error as a whole percentage. The value is untouched; only its presentation is.
    private static func percentage(_ meanError: Double) -> Int {
        Int((meanError * 100).rounded())
    }
}
