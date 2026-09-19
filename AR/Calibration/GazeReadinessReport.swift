// GazeReadinessReport.swift
// Layer: AR (calibration, pure Swift)
// Purpose: Readiness check kinds, statuses and the report shown before calibration

import Foundation
import simd

enum ReadinessStatus: Hashable, Sendable {
    case pending
    case pass
    case fail
}

enum ReadinessCheckKind: String, CaseIterable, Hashable, Sendable {
    case faceTracking
    case cameraAccess
    case session
    case faceDetected
    case eyeTracking
    case gazeDirection
    case headStable
    case signalStable
    case blinkDetection
    case axisMapping

    var title: String {
        switch self {
        case .faceTracking: "Caméra TrueDepth"
        case .cameraAccess: "Accès caméra"
        case .session: "Session AR"
        case .faceDetected: "Visage détecté"
        case .eyeTracking: "Suivi des yeux"
        case .gazeDirection: "Direction du regard"
        case .headStable: "Tête stable"
        case .signalStable: "Signal stable"
        case .blinkDetection: "Clignements détectés"
        case .axisMapping: "Orientation du regard"
        }
    }

    /// Hardware or permission checks that can never pass by waiting.
    var isBlocking: Bool {
        self == .faceTracking || self == .cameraAccess
    }
}

struct ReadinessCheck: Hashable, Sendable, Identifiable {
    let kind: ReadinessCheckKind
    let status: ReadinessStatus
    let detail: String?
    /// What the detail is saying, as an identity rather than a sentence. The French `detail` above stays exactly as
    /// it was and remains the witness that nothing about this check moved; `reason` is what lets a screen say the
    /// same thing in another language. Optional, so no existing caller has to change.
    let reason: ReadinessDetail?

    init(kind: ReadinessCheckKind, status: ReadinessStatus, detail: String? = nil, reason: ReadinessDetail? = nil) {
        self.kind = kind
        self.status = status
        self.detail = detail
        self.reason = reason
    }

    var id: ReadinessCheckKind { kind }
}

struct GazeReadinessReport: Hashable, Sendable {
    let checks: [ReadinessCheck]
    let axisMapping: AxisMapping?
    let axisConfidence: Double
    let sampleCount: Int

    init(checks: [ReadinessCheck], axisMapping: AxisMapping?, axisConfidence: Double, sampleCount: Int) {
        self.checks = checks
        self.axisMapping = axisMapping
        self.axisConfidence = axisConfidence
        self.sampleCount = sampleCount
    }

    var isReady: Bool { checks.allSatisfy { $0.status == .pass } }
    var isBlocked: Bool { checks.contains { $0.kind.isBlocking && $0.status == .fail } }
    var passedCount: Int { checks.filter { $0.status == .pass }.count }
}
