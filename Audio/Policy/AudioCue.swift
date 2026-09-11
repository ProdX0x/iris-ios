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
    /// Ascending arpeggio closing a level (replaces the validation chime of the last iris).
    case levelComplete
    /// Soft pulse of a weakening veilleuse.
    case veilleuseLow
    /// Chapter drone (two sines a fifth apart); nil frequency fades it out.
    case ambient(frequency: Double?)
}
