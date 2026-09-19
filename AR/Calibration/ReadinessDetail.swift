// ReadinessDetail.swift
// Layer: AR (calibration, pure Swift)
// Purpose: What a readiness check is saying, as a thing rather than as a sentence. The evaluator used to hand the
// screen a finished French string, and a finished string cannot be translated: the words were chosen before anyone
// knew which language would read them. This names the message instead, and carries the measured values beside it,
// so the sentence can be built last — in whichever language is asked for

import Foundation

/// The identity of a readiness message, with nothing attached. `ReadinessDetail` carries associated values, so Swift
/// synthesises no `allCases` for it; this companion is the list the catalogue and the tests count against.
enum ReadinessDetailID: String, CaseIterable, Hashable, Sendable {
    case faceTrackingAvailable
    case faceTrackingUnsupported
    case cameraGranted
    case cameraDeniedOrRestricted
    case sessionReceivingFrames
    case sessionStarting
    case sessionInterrupted
    case sessionUnavailable
    case sessionFailed
    case faceTracked
    case faceSettling
    case faceNotInFrame
    case awaitingSignal
    case faceDistance
    case faceDistanceOutOfRange
    case gazeOnScreen
    case gazeOffScreen
    case headStill
    case headMoving
    case signalSteady
    case signalUnsteady
    case blinksIgnored
    case blendShapesUnavailable
    case axesResolved
    case axesUnresolved

    /// The stable key this message answers to. Derived from the identity, never from the sentence.
    var localizationKey: String { "gazeReadiness.detail.\(rawValue)" }
}

/// One readiness message, with the values it needs to be written out. Two of them measure something; the rest say
/// only what they are.
enum ReadinessDetail: Hashable, Sendable {
    case faceTrackingAvailable
    case faceTrackingUnsupported
    case cameraGranted
    case cameraDeniedOrRestricted
    case sessionReceivingFrames
    case sessionStarting
    case sessionInterrupted
    case sessionUnavailable
    case sessionFailed
    case faceTracked
    case faceSettling
    case faceNotInFrame
    case awaitingSignal
    /// The measured face distance. Carried in centimetres as a `Double`, not rounded to an `Int`: the historical
    /// sentence is built with `%.0f`, which rounds halves to even, while `rounded()` rounds them away from zero.
    /// Keeping the double and the same format specifier is what makes the French come out character for character
    /// as it always has.
    case faceDistance(centimetres: Double)
    case faceDistanceOutOfRange
    case gazeOnScreen
    case gazeOffScreen
    case headStill
    case headMoving
    case signalSteady
    case signalUnsteady
    case blinksIgnored
    case blendShapesUnavailable
    /// Which device axis the gaze's right and up turned out to be.
    case axesResolved(right: DeviceAxis, up: DeviceAxis)
    case axesUnresolved

    var id: ReadinessDetailID {
        switch self {
        case .faceTrackingAvailable: .faceTrackingAvailable
        case .faceTrackingUnsupported: .faceTrackingUnsupported
        case .cameraGranted: .cameraGranted
        case .cameraDeniedOrRestricted: .cameraDeniedOrRestricted
        case .sessionReceivingFrames: .sessionReceivingFrames
        case .sessionStarting: .sessionStarting
        case .sessionInterrupted: .sessionInterrupted
        case .sessionUnavailable: .sessionUnavailable
        case .sessionFailed: .sessionFailed
        case .faceTracked: .faceTracked
        case .faceSettling: .faceSettling
        case .faceNotInFrame: .faceNotInFrame
        case .awaitingSignal: .awaitingSignal
        case .faceDistance: .faceDistance
        case .faceDistanceOutOfRange: .faceDistanceOutOfRange
        case .gazeOnScreen: .gazeOnScreen
        case .gazeOffScreen: .gazeOffScreen
        case .headStill: .headStill
        case .headMoving: .headMoving
        case .signalSteady: .signalSteady
        case .signalUnsteady: .signalUnsteady
        case .blinksIgnored: .blinksIgnored
        case .blendShapesUnavailable: .blendShapesUnavailable
        case .axesResolved: .axesResolved
        case .axesUnresolved: .axesUnresolved
        }
    }

    /// The values the sentence needs, in the order its format declares them. Empty for the twenty-three messages
    /// that measure nothing.
    var arguments: [any CVarArg] {
        switch self {
        case let .faceDistance(centimetres): [centimetres]
        case let .axesResolved(right, up): [right.rawValue, up.rawValue]
        default: []
        }
    }

    var localizationKey: String { id.localizationKey }
}
