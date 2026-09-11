// GameSettingsStore.swift
// Layer: Presentation
// Purpose: Small persisted preferences (sound, haptics, gaze diagnostics). No gaze data is ever stored.

import Foundation
import Observation

@MainActor
@Observable
final class GameSettingsStore {
    private enum Key {
        static let showsGazeIndicator = "iris.showsGazeIndicator"
        static let soundEnabled = "iris.soundEnabled"
        static let hapticsEnabled = "iris.hapticsEnabled"
        static let legacyKeys = ["iris.mirrorHorizontal", "iris.hasSeenTutorial"]
    }

    var showsGazeIndicator: Bool {
        didSet { defaults.set(showsGazeIndicator, forKey: Key.showsGazeIndicator) }
    }
    var soundEnabled: Bool {
        didSet { defaults.set(soundEnabled, forKey: Key.soundEnabled) }
    }
    var hapticsEnabled: Bool {
        didSet { defaults.set(hapticsEnabled, forKey: Key.hapticsEnabled) }
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        showsGazeIndicator = defaults.bool(forKey: Key.showsGazeIndicator)
        soundEnabled = defaults.object(forKey: Key.soundEnabled) as? Bool ?? true
        hapticsEnabled = defaults.object(forKey: Key.hapticsEnabled) as? Bool ?? true
        for key in Key.legacyKeys {
            defaults.removeObject(forKey: key)
        }
    }
}
