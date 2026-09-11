// GazeCalibrationStatus.swift
// Layer: Presentation
// Purpose: What the game knows about the calibration in use (pause panel readout)

import Foundation

enum GazeCalibrationStatus: Hashable, Sendable {
    case uncalibrated
    case calibrated(meanError: Double?, isValid: Bool)

    var description: String {
        switch self {
        case .uncalibrated:
            return "Regard non calibré : projection nominale."
        case let .calibrated(meanError, isValid):
            let quality = isValid ? "validée" : "non validée"
            if let meanError {
                return "Calibration \(quality), erreur moyenne \(Int((meanError * 100).rounded())) % de la largeur."
            }
            return "Calibration \(quality)."
        }
    }
}
