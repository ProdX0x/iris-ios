// MockHapticFeedbackService.swift
// Layer: Tests
// Purpose: Recording mock for HapticFeedbackService

import Foundation
@testable import Iris

@MainActor
final class MockHapticFeedbackService: HapticFeedbackService {
    private(set) var cues: [HapticCue] = []

    func play(_ cue: HapticCue) {
        cues.append(cue)
    }

    /// Cues that reach the Taptic Engine as a pulse (everything but the prepare hint).
    var pulses: [HapticCue] { cues.filter { $0 != .prepare } }
}
