// GameSettingsStore.swift
// Layer: Presentation
// Purpose: Small persisted preferences (sound effects, ambience, haptics, gaze diagnostics). No gaze data is ever stored.

import Foundation
import Observation

@MainActor
@Observable
final class GameSettingsStore {
    private enum Key {
        static let showsGazeIndicator = "iris.showsGazeIndicator"
        static let soundEffectsEnabled = "iris.soundEffectsEnabled"
        static let ambienceEnabled = "iris.ambienceEnabled"
        static let hapticsEnabled = "iris.hapticsEnabled"
        /// Single "Son" switch of the versions up to B1.1; split into effects and ambience on 12 September 2026.
        static let legacySoundEnabled = "iris.soundEnabled"
        static let legacyKeys = ["iris.mirrorHorizontal", "iris.hasSeenTutorial"]
    }

    var showsGazeIndicator: Bool {
        didSet { defaults.set(showsGazeIndicator, forKey: Key.showsGazeIndicator) }
    }
    /// Event sounds: crescendo, chime, loss, arpeggio, pulses. They carry information; on by default.
    var soundEffectsEnabled: Bool {
        didSet { defaults.set(soundEffectsEnabled, forKey: Key.soundEffectsEnabled) }
    }
    /// The chapter drone. Pure atmosphere, judged dull and unpleasant on device on 12 September 2026; off by default.
    var ambienceEnabled: Bool {
        didSet { defaults.set(ambienceEnabled, forKey: Key.ambienceEnabled) }
    }
    var hapticsEnabled: Bool {
        didSet { defaults.set(hapticsEnabled, forKey: Key.hapticsEnabled) }
    }

    /// True when the audio engine has anything to play.
    var wantsAudio: Bool { soundEffectsEnabled || ambienceEnabled }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        showsGazeIndicator = defaults.bool(forKey: Key.showsGazeIndicator)
        hapticsEnabled = defaults.object(forKey: Key.hapticsEnabled) as? Bool ?? true

        // Migration of the single "Son" switch: what the player had stays exactly what they get. Off stays fully off
        // (nothing is switched back on behind their back); on keeps the ambience they were already hearing.
        // A player who never touched the switch gets the new defaults: effects on, ambience off.
        let legacy = defaults.object(forKey: Key.legacySoundEnabled) as? Bool
        soundEffectsEnabled = defaults.object(forKey: Key.soundEffectsEnabled) as? Bool ?? legacy ?? true
        ambienceEnabled = defaults.object(forKey: Key.ambienceEnabled) as? Bool ?? legacy ?? false
        if legacy != nil {
            defaults.set(soundEffectsEnabled, forKey: Key.soundEffectsEnabled)
            defaults.set(ambienceEnabled, forKey: Key.ambienceEnabled)
            defaults.removeObject(forKey: Key.legacySoundEnabled)
        }
        for key in Key.legacyKeys {
            defaults.removeObject(forKey: key)
        }
    }
}
