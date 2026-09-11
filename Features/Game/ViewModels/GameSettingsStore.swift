// GameSettingsStore.swift
// Layer: Presentation
// Purpose: Small persisted preferences (diagnostic display, tutorial seen). No gaze data is ever stored.

import Foundation
import Observation

@MainActor
@Observable
final class GameSettingsStore {
    private enum Key {
        static let showsGazeIndicator = "iris.showsGazeIndicator"
        static let hasSeenTutorial = "iris.hasSeenTutorial"
        static let legacyMirror = "iris.mirrorHorizontal"
    }

    var showsGazeIndicator: Bool {
        didSet { defaults.set(showsGazeIndicator, forKey: Key.showsGazeIndicator) }
    }
    var hasSeenTutorial: Bool {
        didSet { defaults.set(hasSeenTutorial, forKey: Key.hasSeenTutorial) }
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        showsGazeIndicator = defaults.bool(forKey: Key.showsGazeIndicator)
        hasSeenTutorial = defaults.bool(forKey: Key.hasSeenTutorial)
        // The manual mirror toggle of Gaze Engine v1 is gone: axes are resolved automatically.
        defaults.removeObject(forKey: Key.legacyMirror)
    }
}
