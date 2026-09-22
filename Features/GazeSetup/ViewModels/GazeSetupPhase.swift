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
        case .faceTrackingUnsupported: IrisText.interface("gaze.unavailable.title", french: "regard indisponible")
        case .cameraDenied: IrisText.interface("camera.denied.title", french: "caméra refusée")
        case .cameraRestricted: IrisText.interface("camera.restricted.title", french: "caméra restreinte")
        case .trackingError: IrisText.interface("gaze.trackingError.title", french: "erreur de suivi")
        case .insufficientSignal: IrisText.interface("gazeSetup.weakSignal.title", french: "signal insuffisant")
        case .fitFailed: IrisText.interface("gazeSetup.impossible.title", french: "calibration impossible")
        }
    }

    var message: String {
        switch self {
        case .faceTrackingUnsupported:
            IrisText.interface("camera.unsupported.message", french: "Cet appareil ne prend pas en charge le suivi facial ARKit nécessaire au contrôle par le regard.")
        case .cameraDenied:
            IrisText.interface("camera.denied.message", french: "Iris a besoin de la caméra frontale pour lire votre regard. Autorisez-la dans Réglages.")
        case .cameraRestricted:
            IrisText.interface("gazeSetup.camera.restricted.message", french: "L'accès à la caméra est restreint sur cet appareil.")
        case let .trackingError(message):
            IrisText.interface("gazeSetup.trackingError.message", french: "Le suivi du regard s'est arrêté. %@", message)
        case let .insufficientSignal(target):
            IrisText.interface("gazeSetup.insufficientSignal.message",
                               french: "Le regard n'a pas pu être mesuré sur le point %lld. Gardez la tête immobile, évitez les reflets et recommencez.",
                               target + 1)
        case .fitFailed:
            IrisText.interface("gazeSetup.failure.noCorrection", french: "Les mesures ne permettent pas de calculer une correction. Recommencez en suivant chaque point des yeux.")
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
