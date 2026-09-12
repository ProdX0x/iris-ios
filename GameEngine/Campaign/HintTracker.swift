// HintTracker.swift
// Layer: GameEngine
// Purpose: Decides which contextual instruction is visible, from engine events and elapsed time

import Foundation

struct HintTracker: Hashable, Sendable {
    static let displayDuration: TimeInterval = 4.5

    private let hints: [LevelHint]
    private var fired: Set<Int> = []
    private(set) var current: String?
    private var shownAt: TimeInterval = 0

    init(hints: [LevelHint]) {
        self.hints = hints
    }

    /// Adds the level's generic help after `helpDelay` seconds (route display or empty-space advice).
    static func forLevel(_ level: LevelDefinition, helpDelay: TimeInterval = 45) -> HintTracker {
        let help = level.requiresPushing
            ? "La voie est tracée en pointillés."
            : "Cherchez l'espace le plus vide de l'écran."
        return HintTracker(hints: level.hints + [LevelHint(.afterSeconds(helpDelay), help)])
    }

    mutating func begin() {
        for (index, hint) in hints.enumerated() where hint.trigger == .start {
            show(index: index, at: 0)
        }
    }

    /// Returns true when the visible hint changed.
    @discardableResult
    mutating func observe(events: [GameEvent], elapsed: TimeInterval) -> Bool {
        let before = current
        if current != nil && elapsed - shownAt > Self.displayDuration {
            current = nil
        }
        for (index, hint) in hints.enumerated() where !fired.contains(index) && matches(hint.trigger, events: events, elapsed: elapsed) {
            show(index: index, at: elapsed)
        }
        return before != current
    }

    mutating func dismiss() {
        current = nil
    }

    private mutating func show(index: Int, at time: TimeInterval) {
        fired.insert(index)
        current = hints[index].text
        shownAt = time
    }

    private func matches(_ trigger: HintTrigger, events: [GameEvent], elapsed: TimeInterval) -> Bool {
        switch trigger {
        case .start:
            return false
        case let .afterSeconds(seconds):
            return elapsed >= seconds
        case .firstIntrusion:
            return events.contains { if case .intrusion = $0 { return true } else { return false } }
        case .firstHold:
            return events.contains { if case .validationProgressed = $0 { return true } else { return false } }
        case .firstValidation:
            return events.contains { if case .targetValidated = $0 { return true } else { return false } }
        case .firstLoss:
            return events.contains { if case .targetLost = $0 { return true } else { return false } }
        case .attentionLeftField:
            return events.contains(.attentionLeftField)
        case .veilleuseLow:
            return events.contains { if case .veilleuseLow = $0 { return true } else { return false } }
        case .braiseLit:
            return events.contains { if case .braiseLit = $0 { return true } else { return false } }
        case .braiseFlared:
            return events.contains { if case .braiseFlared = $0 { return true } else { return false } }
        case .twinsLinked:
            return events.contains { if case .twinsLinked = $0 { return true } else { return false } }
        }
    }
}
