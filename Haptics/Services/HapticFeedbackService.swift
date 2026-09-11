// HapticFeedbackService.swift
// Layer: Haptics (service contract consumed by Presentation)
// Purpose: Touch output abstraction: cues in, nothing out

import Foundation

@MainActor
protocol HapticFeedbackService: AnyObject {
    func play(_ cue: HapticCue)
}
