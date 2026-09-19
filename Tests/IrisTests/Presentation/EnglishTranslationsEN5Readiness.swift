// EnglishTranslationsEN5Readiness.swift
// Layer: Tests (support)
// Purpose: The English of the twenty-five readiness messages — the checklist a player reads just before calibrating.
// Every term here is one the catalogues already settled: steady rather than stable, dot rather than point, blinks,
// deviation, device. Two of them carry a measurement, and the measurement is never touched

import Foundation

enum EnglishTranslationsEN5Readiness {
    static let byKey: [String: String] = [
        "gazeReadiness.detail.faceTrackingAvailable": "ARKit face tracking available",
        "gazeReadiness.detail.faceTrackingUnsupported": "Device without face tracking",
        "gazeReadiness.detail.cameraGranted": "Granted",
        "gazeReadiness.detail.cameraDeniedOrRestricted": "Denied or restricted",
        "gazeReadiness.detail.sessionReceivingFrames": "Frames received",
        "gazeReadiness.detail.sessionStarting": "Starting",
        "gazeReadiness.detail.sessionInterrupted": "Session interrupted",
        "gazeReadiness.detail.sessionUnavailable": "Unavailable",
        "gazeReadiness.detail.sessionFailed": "Error",
        "gazeReadiness.detail.faceTracked": "Face tracked",
        "gazeReadiness.detail.faceSettling": "One moment…",
        "gazeReadiness.detail.faceNotInFrame": "Put your face in front of the screen",
        "gazeReadiness.detail.awaitingSignal": "Waiting for the signal",
        "gazeReadiness.detail.faceDistance": "Distance %.0f cm",
        "gazeReadiness.detail.faceDistanceOutOfRange": "Move closer to or further from the screen (20 to 80 cm)",
        "gazeReadiness.detail.gazeOnScreen": "Gaze directed at the screen",
        "gazeReadiness.detail.gazeOffScreen": "Look at the screen",
        "gazeReadiness.detail.headStill": "Head still",
        "gazeReadiness.detail.headMoving": "Keep your head still",
        "gazeReadiness.detail.signalSteady": "Consistent",
        "gazeReadiness.detail.signalUnsteady": "Keep your gaze on the dot in the centre",
        "gazeReadiness.detail.blinksIgnored": "Blinks will be ignored",
        "gazeReadiness.detail.blendShapesUnavailable": "Blend shapes unavailable",
        "gazeReadiness.detail.axesResolved": "Axes resolved (right = %@, up = %@)",
        "gazeReadiness.detail.axesUnresolved": "Hold the iPhone straight in front of you",
    ]

    /// French and English legitimately identical: the measurement line is the same sentence in both languages.
    static let identicalByDesign: Set<String> = ["gazeReadiness.detail.faceDistance"]

    /// What a translator needs to know, message by message.
    static let comments: [String: String] = [
        "gazeReadiness.detail.faceTrackingAvailable": "Gaze diagnostic, shown before calibration. State of the TrueDepth face-tracking check when the device supports it.",
        "gazeReadiness.detail.faceTrackingUnsupported": "FUNCTIONAL: the device has no face tracking at all. Nothing the player does can change it.",
        "gazeReadiness.detail.cameraGranted": "State of the camera-permission check when access has been granted. One word, in a checklist row.",
        "gazeReadiness.detail.cameraDeniedOrRestricted": "FUNCTIONAL: camera access is refused, or restricted by Screen Time or a profile. Both cases share this one line.",
        "gazeReadiness.detail.sessionReceivingFrames": "State of the AR session check when frames are arriving.",
        "gazeReadiness.detail.sessionStarting": "State of the AR session check while it is still starting up.",
        "gazeReadiness.detail.sessionInterrupted": "FUNCTIONAL: the AR session was interrupted. Distinct from unavailable and from an error.",
        "gazeReadiness.detail.sessionUnavailable": "FUNCTIONAL: the AR session cannot run here. Distinct from interrupted and from an error.",
        "gazeReadiness.detail.sessionFailed": "FUNCTIONAL: the AR session failed. Distinct from interrupted and from unavailable.",
        "gazeReadiness.detail.faceTracked": "State of the face check when the face is being tracked and enough samples have arrived.",
        "gazeReadiness.detail.faceSettling": "Shown while the face is visible but not enough samples have arrived yet. A few seconds at most.",
        "gazeReadiness.detail.faceNotInFrame": "Instruction shown when no face is visible to the camera. Tells the player where to put their face.",
        "gazeReadiness.detail.awaitingSignal": "Shown on every signal check while there are not yet enough samples to judge anything.",
        "gazeReadiness.detail.faceDistance": "The measured distance between the face and the device. %.0f is that distance in centimetres, already rounded. Keep the unit in cm: it is what the app measures.",
        "gazeReadiness.detail.faceDistanceOutOfRange": "FUNCTIONAL: the face is too close or too far. The range in brackets is the one the app actually accepts.",
        "gazeReadiness.detail.gazeOnScreen": "State of the gaze-direction check when the gaze lands on the screen.",
        "gazeReadiness.detail.gazeOffScreen": "Instruction shown when the gaze is not landing on the screen.",
        "gazeReadiness.detail.headStill": "State of the head check when the head is steady enough.",
        "gazeReadiness.detail.headMoving": "Instruction shown when the head is moving too much for calibration.",
        "gazeReadiness.detail.signalSteady": "State of the signal check when the gaze signal is steady enough. The row's title above it already reads « Signal steady », so this line says the same thing in another word, as the French does with « stable » and « régulier ».",
        "gazeReadiness.detail.signalUnsteady": "Instruction shown when the gaze signal is too unsteady. The dot is the fixation mark at the centre of the screen.",
        "gazeReadiness.detail.blinksIgnored": "PRIVACY-ADJACENT FACTUAL CLAIM: blinks are detected and then discarded, not acted on. Do not turn this into a promise about anything else.",
        "gazeReadiness.detail.blendShapesUnavailable": "FUNCTIONAL: ARKit is not supplying blend shapes, so blinks cannot be recognised. « Blend shapes » is Apple's own term and stays in English.",
        "gazeReadiness.detail.axesResolved": "State of the axis check once the gaze axes are resolved. %@ is the device axis that turned out to be right, then the one that turned out to be up; both are technical identifiers such as positiveX and are never translated.",
        "gazeReadiness.detail.axesUnresolved": "Instruction shown when the axes are not resolved yet: the player must hold the device upright and facing them.",
    ]
}
