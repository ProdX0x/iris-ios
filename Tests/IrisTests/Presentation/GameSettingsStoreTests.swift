// GameSettingsStoreTests.swift
// Layer: Tests
// Purpose: Preferences default to on and persist across store instances

import Foundation
import Testing
@testable import Iris

@Suite("GameSettingsStore")
@MainActor
struct GameSettingsStoreTests {
    @Test("haptics and sound default to on, the gaze indicator to off")
    func defaults() {
        let defaults = UserDefaults(suiteName: "iris.tests.settings.\(UUID().uuidString)") ?? .standard
        let store = GameSettingsStore(defaults: defaults)

        #expect(store.hapticsEnabled)
        #expect(store.soundEnabled)
        #expect(!store.showsGazeIndicator)
    }

    @Test("a changed preference survives a new store on the same defaults")
    func persistence() {
        let defaults = UserDefaults(suiteName: "iris.tests.settings.\(UUID().uuidString)") ?? .standard
        let store = GameSettingsStore(defaults: defaults)
        store.hapticsEnabled = false
        store.soundEnabled = false
        store.showsGazeIndicator = true

        let reloaded = GameSettingsStore(defaults: defaults)

        #expect(!reloaded.hapticsEnabled)
        #expect(!reloaded.soundEnabled)
        #expect(reloaded.showsGazeIndicator)
    }
}
