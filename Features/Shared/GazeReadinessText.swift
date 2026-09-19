// GazeReadinessText.swift
// Layer: Presentation (shared)
// Purpose: Gives the readiness checks of the gaze diagnostic a stable identity. Their sentences are written in the AR
// layer, whose files are frozen: the identity is rebuilt here, from what a check IS — its kind and its status — and the
// French it already carries is the fallback. Nothing in AR/Calibration is read as a key, copied, or modified

import Foundation

enum GazeReadinessText {
    /// A stable token per status, written out rather than derived: it moves only if someone changes this switch.
    static func token(for status: ReadinessStatus) -> String {
        switch status {
        case .pending: "pending"
        case .pass: "pass"
        case .fail: "fail"
        }
    }

    static func titleKey(for kind: ReadinessCheckKind) -> String {
        "gazeReadiness.check.\(kind.rawValue).title"
    }

    static func detailKey(for kind: ReadinessCheckKind, status: ReadinessStatus) -> String {
        "gazeReadiness.check.\(kind.rawValue).\(token(for: status))"
    }

    /// What a check calls itself, localised.
    static func title(of check: ReadinessCheck) -> String {
        IrisText.interface(titleKey(for: check.kind), french: check.kind.title)
    }

    /// What a check says about its state, localised. A check without a sentence stays without one.
    ///
    /// The key comes from what the message IS, not from the check's kind and status: five (kind, status) pairs can
    /// carry two or three different messages, so keying on them would have merged, for instance, an interrupted
    /// session with an unavailable one. When a check carries no reason — nothing in the app produces one, but the
    /// field is optional — the old behaviour is kept and the French is shown.
    static func detail(of check: ReadinessCheck) -> String? {
        guard let detail = check.detail else { return nil }
        guard let reason = check.reason else {
            return IrisText.interface(detailKey(for: check.kind, status: check.status), french: detail)
        }
        return IrisText.format(key: reason.localizationKey, french: french(for: reason.id),
                               table: IrisText.interfaceTable, arguments: reason.arguments)
    }

    /// The French each message has always shown, as a format. The evaluator still builds the very same sentence into
    /// `check.detail`; a test renders both and refuses to let them differ by a character.
    static func french(for id: ReadinessDetailID) -> String {
        switch id {
        case .faceTrackingAvailable: "Suivi facial ARKit disponible"
        case .faceTrackingUnsupported: "Appareil sans suivi facial"
        case .cameraGranted: "Autorisé"
        case .cameraDeniedOrRestricted: "Refusé ou restreint"
        case .sessionReceivingFrames: "Frames reçues"
        case .sessionStarting: "Démarrage"
        case .sessionInterrupted: "Session interrompue"
        case .sessionUnavailable: "Indisponible"
        case .sessionFailed: "Erreur"
        case .faceTracked: "Visage suivi"
        case .faceSettling: "Un instant…"
        case .faceNotInFrame: "Placez votre visage face à l'écran"
        case .awaitingSignal: "En attente du signal"
        case .faceDistance: "Distance %.0f cm"
        case .faceDistanceOutOfRange: "Rapprochez-vous ou éloignez-vous de l'écran (20 à 80 cm)"
        case .gazeOnScreen: "Regard dirigé vers l'écran"
        case .gazeOffScreen: "Regardez l'écran"
        case .headStill: "Tête immobile"
        case .headMoving: "Gardez la tête immobile"
        case .signalSteady: "Signal régulier"
        case .signalUnsteady: "Fixez le point au centre"
        case .blinksIgnored: "Les clignements seront ignorés"
        case .blendShapesUnavailable: "Blend shapes indisponibles"
        case .axesResolved: "Axes résolus (droite = %@, haut = %@)"
        case .axesUnresolved: "Tenez l'iPhone droit devant vous"
        }
    }
}
