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
    static func detail(of check: ReadinessCheck) -> String? {
        guard let detail = check.detail else { return nil }
        return IrisText.interface(detailKey(for: check.kind, status: check.status), french: detail)
    }
}
