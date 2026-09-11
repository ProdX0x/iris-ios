// AppEnvironment.swift
// Layer: App (DI)
// Purpose: Runtime flavour of the composition root

import Foundation

enum AppEnvironment: Hashable, Sendable {
    /// Real device: ARKit gaze, AVAudioEngine sound, display link clock.
    case live
    /// iOS Simulator: pointer-driven gaze (no TrueDepth), real audio engine, display link clock.
    case simulator
    /// Xcode previews and tests: simulated gaze, silent audio, manual clock.
    case preview
}
