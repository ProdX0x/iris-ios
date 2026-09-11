// SilentHapticFeedbackService.swift
// Layer: Haptics
// Purpose: No-op touch feedback used by previews

import Foundation

@MainActor
final class SilentHapticFeedbackService: HapticFeedbackService {
    func play(_ cue: HapticCue) {}
}
