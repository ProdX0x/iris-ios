// GazeSetupPhase.swift
// Layer: Presentation
// Purpose: Single state of the gaze setup screen: readiness, calibration, validation, verdicts and failures

import Foundation
import simd

struct FixationDisplay: Hashable, Sendable {
    let target: SIMD2<Double>
    let index: Int
    let count: Int
    let progress: Double
    let isCollecting: Bool

    init(target: SIMD2<Double>, index: Int, count: Int, progress: Double, isCollecting: Bool) {
        self.target = target
        self.index = index
        self.count = count
        self.progress = progress
        self.isCollecting = isCollecting
    }
}

enum GazeSetupFailure: Hashable, Sendable {
    case faceTrackingUnsupported
    case cameraDenied
    case cameraRestricted
    case trackingError(message: String)
    case insufficientSignal(target: Int)
    case fitFailed

    var title: String {
        switch self {
        case .faceTrackingUnsupported: "regard indisponible"
        case .cameraDenied: "caméra refusée"
        case .cameraRestricted: "caméra restreinte"
        case .trackingError: "erreur de suivi"
        case .insufficientSignal: "signal insuffisant"
        case .fitFailed: "calibration impossible"
        }
    }

    var message: String {
        switch self {
        case .faceTrackingUnsupported:
            "Cet appareil ne dispose pas du suivi facial TrueDepth nécessaire pour détecter le regard."
        case .cameraDenied:
            "Iris a besoin de la caméra frontale pour lire votre regard. Autorisez-la dans Réglages."
        case .cameraRestricted:
            "L'accès à la caméra est restreint sur cet appareil."
        case let .trackingError(message):
            "Le suivi du regard s'est arrêté. \(message)"
        case let .insufficientSignal(target):
            "Le regard n'a pas pu être mesuré sur le point \(target + 1). Gardez la tête immobile, évitez les reflets et recommencez."
        case .fitFailed:
            "Les mesures ne permettent pas de calculer une correction. Recommencez en suivant chaque point des yeux."
        }
    }
}

enum GazeSetupPhase: Hashable, Sendable {
    case starting
    case readiness(GazeReadinessReport)
    case calibrating(FixationDisplay)
    case validating(FixationDisplay)
    /// Validation passed the protocol but not the quality criteria.
    case insufficient(ValidationResult, attempts: Int)
    case ready(ValidationResult)
    case suspended
    case failed(GazeSetupFailure)
}
