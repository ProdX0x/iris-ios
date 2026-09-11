// AudioCue.swift
// Layer: Audio
// Purpose: Sound intents derived from game events, independent from AVAudioEngine

import Foundation

enum AudioCue: Hashable, Sendable {
    /// Crescendo voice for one target (voice index is `sequence - 1`).
    case progress(voice: Int, progress: Double)
    case stopProgress(voice: Int)
    case validation
    case loss
}
