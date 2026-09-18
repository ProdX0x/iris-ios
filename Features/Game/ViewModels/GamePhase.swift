// GamePhase.swift
// Layer: Presentation
// Purpose: Single state of the game screen; every overlay derives from it

import Foundation

enum GameFailure: Hashable, Sendable {
    case faceTrackingUnsupported
    case cameraDenied
    case cameraRestricted
    case trackingError(message: String)

    var title: String {
        switch self {
        case .faceTrackingUnsupported: IrisText.interface("gaze.unavailable.title", french: "regard indisponible")
        case .cameraDenied: IrisText.interface("camera.denied.title", french: "caméra refusée")
        case .cameraRestricted: IrisText.interface("camera.restricted.title", french: "caméra restreinte")
        case .trackingError: IrisText.interface("gaze.trackingError.title", french: "erreur de suivi")
        }
    }

    var message: String {
        switch self {
        case .faceTrackingUnsupported:
            IrisText.interface("camera.unsupported.message", french: "Cet appareil ne dispose pas du suivi facial TrueDepth nécessaire pour détecter le regard.")
        case .cameraDenied:
            IrisText.interface("camera.denied.message", french: "Iris a besoin de la caméra frontale pour lire votre regard. Autorisez-la dans Réglages.")
        case .cameraRestricted:
            IrisText.interface("camera.restricted.message", french: "L'accès à la caméra est restreint sur cet appareil (temps d'écran ou profil).")
        case let .trackingError(message):
            "Le suivi du regard s'est arrêté de façon inattendue. \(message)"
        }
    }

    var canOpenSettings: Bool {
        self == .cameraDenied
    }
}

enum GamePhase: Hashable, Sendable {
    /// AR session starting, waiting for the first tracked frame.
    case initializing
    /// Level intro card: the level is visible behind it, waiting for the player.
    case ready
    case playing
    case paused
    /// Every iris closed: result screen with éclats.
    case levelComplete(LevelResult)
    /// The AR session was interrupted (call, camera taken by another app).
    case interrupted
    /// The face left the camera for more than 0.3 s while playing; resumes by itself when it is back.
    case faceLost
    /// Tracking is back after an interruption or a background trip; waiting for a tap.
    case resuming
    /// The app is in the background, or the gaze setup runs a recalibration.
    case suspended
    case failed(GameFailure)
}
