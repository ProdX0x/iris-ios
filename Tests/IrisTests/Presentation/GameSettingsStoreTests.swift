// GameSettingsStoreTests.swift
// Layer: Tests
// Purpose: Preferences defaults, persistence, and the migration of the single "Son" switch into effects and ambience

import Foundation
import Testing
@testable import Iris

@Suite("GameSettingsStore")
@MainActor
struct GameSettingsStoreTests {
    @Test("haptics and sound effects default to on, the ambience and the gaze indicator to off")
    func defaults() {
        let defaults = UserDefaults(suiteName: "iris.tests.settings.\(UUID().uuidString)") ?? .standard
        let store = GameSettingsStore(defaults: defaults)

        #expect(store.hapticsEnabled)
        #expect(store.soundEffectsEnabled)
        #expect(!store.ambienceEnabled)
        #expect(store.wantsAudio)
        #expect(!store.showsGazeIndicator)
    }

    @Test("the old single sound switch migrates without switching anything back on: off stays fully off, on keeps its ambience")
    func migration() {
        let wasOff = UserDefaults(suiteName: "iris.tests.settings.\(UUID().uuidString)") ?? .standard
        wasOff.set(false, forKey: "iris.soundEnabled")
        let silent = GameSettingsStore(defaults: wasOff)
        #expect(!silent.soundEffectsEnabled && !silent.ambienceEnabled && !silent.wantsAudio)
        #expect(wasOff.object(forKey: "iris.soundEnabled") == nil, "the legacy key is consumed")
        #expect(wasOff.object(forKey: "iris.soundEffectsEnabled") as? Bool == false)
        #expect(wasOff.object(forKey: "iris.ambienceEnabled") as? Bool == false)

        let wasOn = UserDefaults(suiteName: "iris.tests.settings.\(UUID().uuidString)") ?? .standard
        wasOn.set(true, forKey: "iris.soundEnabled")
        let full = GameSettingsStore(defaults: wasOn)
        #expect(full.soundEffectsEnabled && full.ambienceEnabled)
        #expect(wasOn.object(forKey: "iris.soundEnabled") == nil)

        let explicit = UserDefaults(suiteName: "iris.tests.settings.\(UUID().uuidString)") ?? .standard
        explicit.set(false, forKey: "iris.soundEnabled")
        explicit.set(true, forKey: "iris.soundEffectsEnabled")
        let split = GameSettingsStore(defaults: explicit)
        #expect(split.soundEffectsEnabled && !split.ambienceEnabled, "an explicit new key wins over the legacy one")
    }

    @Test("a changed preference survives a new store on the same defaults")
    func persistence() {
        let defaults = UserDefaults(suiteName: "iris.tests.settings.\(UUID().uuidString)") ?? .standard
        let store = GameSettingsStore(defaults: defaults)
        store.hapticsEnabled = false
        store.soundEffectsEnabled = false
        store.ambienceEnabled = true
        store.showsGazeIndicator = true

        let reloaded = GameSettingsStore(defaults: defaults)

        #expect(!reloaded.hapticsEnabled)
        #expect(!reloaded.soundEffectsEnabled)
        #expect(reloaded.ambienceEnabled)
        #expect(reloaded.showsGazeIndicator)
    }
}
