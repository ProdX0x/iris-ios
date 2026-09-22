// EnglishTranslationsEN5Interface.swift
// Layer: Tests (support)
// Purpose: The English of the interface sentences EN-4 deferred — everything that teaches the gesture, measures it,
// or promises something. The gaze pushes: wherever the player looks, a sphere moves away. Every direction below was
// read from the sentence that describes the behaviour, not guessed from the French word order

import Foundation

enum EnglishTranslationsEN5Interface {
    static let byKey: [String: String] = [
        // MARK: Spoken by VoiceOver, never drawn
        "common.next": "Next",
        "gazeSetup.calibration.eyebrow": "calibration",
        "result.intrusions.label": "intrusions",
        "result.losses.label": "losses",
        "result.time.label": "time",
        "journey.levels.label": "levels",
        "progress.label": "progress",
        "status.available": "available",
        "status.warning": "warning",
        "status.unavailable": "unavailable",

        // MARK: Legal and access
        "about.terms.detail": "Iris is covered by Apple's standard licence agreement.",
        "access.full.summary": "Iris is fully unlocked on this Apple Account.",
        "access.promotional.detail": "Iris stays fully unlocked for the duration of your access.",
        "access.promotional.summary": "Temporary access unlocks all of Iris. When it ends, the free chapters stay open.",

        // MARK: Camera permission
        "camera.allow.action": "Allow Camera",
        "camera.denied.detail": "Camera access was denied. Without your gaze, Iris cannot work. You can allow it in Settings, then come back here.",
        "camera.denied.message": "Iris needs the front camera to read your gaze. Allow it in Settings.",
        "camera.denied.title": "camera denied",
        "camera.eyebrow": "before you play",
        "camera.headline": "the camera reads your gaze",
        "camera.later.action": "Later",
        "camera.localProcessing.detail": "No image is recorded or sent. Nothing leaves the device.",
        "camera.localProcessing.title": "On-device processing",
        "camera.noCalibration.detail": "The game starts as soon as your face is detected.",
        "camera.noCalibration.title": "No calibration",
        "camera.request.detail": "iOS will ask for permission to use the front camera. It is used only to detect where you are looking.",
        "camera.requesting": "Requesting access…",
        "camera.restricted.detail": "Camera access is restricted on this device (Screen Time, management profile). Iris cannot read your gaze while that restriction is active.",
        "camera.restricted.message": "Camera access is restricted on this device (Screen Time or a profile).",
        "camera.restricted.title": "camera restricted",
        "camera.trueDepth.detail": "Estimates the direction of your gaze, about sixty times a second.",
        "camera.trueDepth.title": "Front camera",
        "camera.unsupported.message": "This device does not support the ARKit face tracking required for gaze control.",

        // MARK: Places and things of Iris
        "carnet.title": "journal",
        "common.threshold": "Threshold",
        "navigation.destination.carnet.title": "Journal",
        "navigation.destination.seuil.title": "Threshold",
        "navigation.sheet.gazeIntroduction.title": "Gaze Assistance",
        "navigation.sheet.howToPlay.title": "How to Play",

        // MARK: Glints — the three marks a level awards
        "eclats.outOfThree.value": "%lld glints out of 3",
        "eclats.total.value": "%lld glints out of %lld",
        "journey.eclats.label": "glints",
        "result.eclat.notEarned": "not earned",
        "result.title": "reached",
        "settings.reset.confirm": "Erase every level reached and every glint?",

        // MARK: In-game
        "common.recalibrate": "Recalibrate",
        "game.cameraBusy.detail": "The camera is in use elsewhere. The game will resume as soon as your gaze is found again.",
        "game.faceLost.detail": "Move back in front of the screen. The game resumes on its own.",
        "game.faceLost.title": "face lost",
        "game.gazeWaking": "the gaze is waking…",
        "game.trackingError.message": "Gaze tracking stopped unexpectedly. %@",
        "gaze.trackingError.title": "tracking error",
        "gaze.unavailable.title": "gaze unavailable",
        "pause.gaze.eyebrow": "gaze",
        "result.lastIris.eyebrow": "last iris",
        "result.nextChapter.action": "Next Chapter",

        // MARK: Gaze assistance
        "gazeAssistance.detail": "The marker shows where Iris thinks you are looking.",
        "gazeAssistance.eyebrow": "gaze assistance",
        "gazeAssistance.learning.note": "Iris sets the gaze assistance itself during the first few learning levels.",
        "gazeAssistance.mode.classic.compact": "No marker",
        "gazeAssistance.mode.classic.summary": "The marker stays hidden. A discreet halo tells you only when your gaze leaves the useful area.",
        "gazeAssistance.mode.classic.title": "Classic",
        "gazeAssistance.mode.guided.compact": "Occasional marker",
        "gazeAssistance.mode.guided.summary": "The marker appears briefly, now and then, to help you find your bearings again.",
        "gazeAssistance.mode.guided.title": "Guided",
        "gazeAssistance.mode.visible.compact": "Permanent marker",
        "gazeAssistance.mode.visible.summary": "The marker stays visible while you play.",
        "gazeAssistance.mode.visible.title": "Visible",
        "gazeAssistance.replay.action": "See the Explanation Again",
        "gazeAssistance.title": "Gaze Assistance",

        // MARK: Learning the marker
        "gazeLearning.accuracy.note": "The lower the calibration deviation, the more closely the calibration matches your gaze. 0% is an ideal reference: no deviation at all is not expected in real use.",
        "gazeLearning.choice.detail": "You can turn assistance back on at any time in Settings, under “Gaze Assistance”.",
        "gazeLearning.choice.figure": "The marker fading away little by little.",
        "gazeLearning.choice.title": "The choice is always yours",
        "gazeLearning.drift.detail": "The bright dot shows where Iris thinks you are looking. It can move slightly even when you believe you are looking at exactly the same place.",
        "gazeLearning.drift.figure": "Three positions close together around the marker, showing that it moves slightly.",
        "gazeLearning.drift.title": "Your gaze is not a fixed point",
        "gazeLearning.guided.detail": "In the first two levels, the marker stays visible. In the third, it fades away to teach you to play without it.",
        "gazeLearning.guided.figure": "The marker, clearly visible.",
        "gazeLearning.guided.title": "Iris guides you at the start",

        // MARK: Readiness checks
        "gazeReadiness.check.axisMapping.title": "Gaze orientation",
        "gazeReadiness.check.blinkDetection.title": "Blinks detected",
        "gazeReadiness.check.cameraAccess.title": "Camera access",
        "gazeReadiness.check.eyeTracking.title": "Eye tracking",
        "gazeReadiness.check.faceDetected.title": "Face detected",
        "gazeReadiness.check.faceTracking.title": "Face tracking",
        "gazeReadiness.check.gazeDirection.title": "Gaze direction",
        "gazeReadiness.check.headStable.title": "Head steady",
        "gazeReadiness.check.session.title": "AR session",
        "gazeReadiness.check.signalStable.title": "Signal steady",
        "gazeReadiness.eyebrow": "gaze diagnostics",
        "gazeReadiness.ready.detail": "Calibration starts in a moment. Keep your head still.",
        "gazeReadiness.ready.headline": "gaze ready for calibration",
        "gazeReadiness.waiting.detail": "Hold the iPhone straight in front of you, 30 to 40 cm away, and look at the dot.",
        "gazeReadiness.waiting.headline": "look at the dot",

        // MARK: Calibration
        "gazeSetup.camera.restricted.message": "Camera access is restricted on this device.",
        "gazeSetup.failure.noCorrection": "The measurements do not allow a correction to be calculated. Start again, following each dot with your eyes.",
        "gazeSetup.fixation.instruction": "follow the dot with your eyes, without moving your head",
        "gazeSetup.impossible.title": "calibration not possible",
        "gazeSetup.insufficientSignal.message": "Your gaze could not be measured on dot %lld. Keep your head still, avoid reflections, and start again.",
        "gazeSetup.starting": "starting gaze tracking…",
        "gazeSetup.trackingError.message": "Gaze tracking stopped. %@",
        "gazeSetup.verification.eyebrow": "check",
        "gazeSetup.weakSignal.title": "signal too weak",

        // MARK: Calibration state
        "gazeStatus.accuracy.note": "The smaller the deviation, the more precisely your gaze is tracked.",
        "gazeStatus.calibrated.headline": "Calibration successful",
        "gazeStatus.imprecise.advice": "Recalibrate so that Iris follows your gaze more precisely.",
        "gazeStatus.imprecise.headline": "Calibration needs redoing",
        "gazeStatus.line": "%@.",
        "gazeStatus.meanError.line": "%@ — mean deviation %lld%%.",
        "gazeStatus.uncalibrated": "Gaze not calibrated.",

        // MARK: Calibration verdict
        "gazeVerdict.continueAnyway.action": "Continue Anyway",
        "gazeVerdict.error.note": "as a percentage of the screen's short side (thresholds 18% and 30%)",
        "gazeVerdict.fail.detail": "The check targets were not found precisely enough. Recalibrate, holding the iPhone straight, without moving your head.",
        "gazeVerdict.fail.eyebrow": "accuracy too low",
        "gazeVerdict.fail.headline": "accuracy can be improved",
        "gazeVerdict.maxError.label": "maximum error",
        "gazeVerdict.meanError.label": "mean error",
        "gazeVerdict.pass.detail": "The mint dot follows your gaze. Check that it lands where you are looking, then continue.",
        "gazeVerdict.pass.eyebrow": "calibration confirmed",
        "gazeVerdict.pass.headline": "gaze ready",
        "gazeVerdict.percent.value": "%lld%%",

        // MARK: Threshold and how to play
        "home.tagline": "What you look at moves away.",
        "howToPlay.comfort.detail": "Hold the iPhone at eye level, an arm's length away, in even light. If your gaze drifts, recalibrate from the settings.",
        "howToPlay.comfort.eyebrow": "comfort",
        "howToPlay.eyebrow": "how to play",
        "howToPlay.intro": "Iris is played with your eyes. The front camera estimates the direction of your gaze; the rest comes down to four ideas.",
        "howToPlay.title": "How to Play",
        "journey.detail": "Every glimmer has found its iris. You have learned to look in the right place, not to look more.",
        "journey.eyebrow": "the last iris",

        // MARK: Onboarding — the four ideas
        "onboarding.destination.detail": "Every sphere has an iris waiting for it. Bring it there, and the level is reached.",
        "onboarding.destination.figure": "A sphere reaching the open iris at the end of its path.",
        "onboarding.destination.title": "Guide the spheres to their iris",
        "onboarding.directStare.detail": "Looking straight at it drives it away — often far from where you meant to take it.",
        "onboarding.directStare.figure": "A gaze resting on the sphere, which moves off away from the iris.",
        "onboarding.directStare.title": "Do not stare at the sphere",
        "onboarding.indirectGaze.detail": "Rest your attention beside the sphere: it slides gently to the opposite side.",
        "onboarding.indirectGaze.figure": "A gaze resting to the left of the sphere, which slides to the right.",
        "onboarding.indirectGaze.title": "Look around it to guide it",
        "onboarding.repulsion.detail": "Iris follows the direction of your gaze. Wherever you look, the sphere moves away.",
        "onboarding.repulsion.figure": "A gaze on the left, a sphere on the right moving away from it.",
        "onboarding.repulsion.title": "Your gaze pushes the spheres away",

        // MARK: Commerce
        "paywall.freeChapters": "Chapters %@ stay free, for good.",
        "paywall.notASubscription": "One-time purchase. No subscription, no renewal.",
        "paywall.promotionalAccessEnded": "Your temporary access has ended. The free chapters stay open, and your progress is untouched.",
        "paywall.whatIsBought": "Full access opens all the other chapters of Iris, and those still to come.",
        "purchase.nothingToRestore": "No purchase to restore on this Apple Account.",
        "purchase.pending": "Purchase waiting for approval.",
        "purchase.unverified": "This purchase could not be verified by the App Store.",

        // MARK: Settings
        "settings.gaze.eyebrow": "gaze",
        "settings.privacy.detail": "Your gaze is computed on the iPhone, in real time. No image, no video and no face data is recorded or sent. Only the calibration coefficients and your progress are kept on the device.",
        "settings.recalibrate.action": "Recalibrate Gaze",
        "settings.understand.eyebrow": "understanding iris",

        // MARK: Unsupported device
        "unavailable.detail": "Iris is played with your gaze alone, estimated with ARKit face tracking and the front camera. This device does not support this feature.",
        "unavailable.devices.detail": "Checked on this device by ARKit",
        "unavailable.devices.label": "Compatibility",
        "unavailable.eyebrow": "device",
        "unavailable.faceTracking.detail": "Not supported on this device",
        "unavailable.faceTracking.label": "ARKit face tracking",
    ]
}
