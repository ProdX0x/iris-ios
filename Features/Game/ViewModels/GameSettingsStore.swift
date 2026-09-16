// GameSettingsStore.swift
// Layer: Presentation
// Purpose: Small persisted preferences (sound effects, ambience, haptics, gaze assistance). No gaze data is ever stored.

import Foundation
import Observation

@MainActor
@Observable
final class GameSettingsStore {
    private enum Key {
        static let gazeAssistance = "iris.gazeAssistance"
        static let soundEffectsEnabled = "iris.soundEffectsEnabled"
        static let ambienceEnabled = "iris.ambienceEnabled"
        static let hapticsEnabled = "iris.hapticsEnabled"
        /// Single "Son" switch of the versions up to B1.1; split into effects and ambience on 12 September 2026.
        static let legacySoundEnabled = "iris.soundEnabled"
        /// The « Points de regard (diagnostic) » switch of the versions up to Gate 2. It became the gaze
        /// assistance mode on 16 September 2026, and is migrated once.
        static let legacyGazeIndicator = "iris.showsGazeIndicator"
        static let legacyKeys = ["iris.mirrorHorizontal", "iris.hasSeenTutorial"]
        #if DEBUG
        /// Developer overlay only. It is not a product setting and has never been one.
        static let developerGazeDiagnostics = "iris.debug.gazeDiagnostics"
        #endif
    }

    /// How much help the player wants seeing where Iris thinks they are looking. THE product setting: there is no
    /// other, and no view decides this for itself.
    var gazeAssistance: GazeAssistanceMode {
        didSet { defaults.set(gazeAssistance.rawValue, forKey: Key.gazeAssistance) }
    }

    #if DEBUG
    /// The raw and calibrated points and the tracking badges. A developer overlay, never shown to a player.
    var showsDeveloperGazeDiagnostics: Bool {
        didSet { defaults.set(showsDeveloperGazeDiagnostics, forKey: Key.developerGazeDiagnostics) }
    }
    #endif
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
        // Gaze assistance: the stored mode wins. Failing that, the old diagnostic switch is migrated once — a
        // player who had the points on keeps a visible marker, everyone else starts on the default — and the old
        // key is removed so the two can never disagree afterwards.
        if let stored = defaults.string(forKey: Key.gazeAssistance), let mode = GazeAssistanceMode(rawValue: stored) {
            gazeAssistance = mode
        } else if let legacy = defaults.object(forKey: Key.legacyGazeIndicator) as? Bool {
            gazeAssistance = legacy ? .visible : .classic
        } else {
            gazeAssistance = .default
        }
        #if DEBUG
        showsDeveloperGazeDiagnostics = defaults.bool(forKey: Key.developerGazeDiagnostics)
        #endif
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
        if defaults.object(forKey: Key.legacyGazeIndicator) != nil {
            defaults.set(gazeAssistance.rawValue, forKey: Key.gazeAssistance)
            defaults.removeObject(forKey: Key.legacyGazeIndicator)
        }
        for key in Key.legacyKeys {
            defaults.removeObject(forKey: key)
        }
    }
}
