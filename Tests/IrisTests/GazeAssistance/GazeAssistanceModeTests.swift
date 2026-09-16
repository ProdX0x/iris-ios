// GazeAssistanceModeTests.swift
// Layer: Tests
// Purpose: The three modes as a rule: what a new player gets, what each mode shows during ordinary play, that the
// guided cycle is deterministic, that the choice survives a relaunch, and that the old diagnostic switch migrates

import Foundation
import Testing
@testable import Iris

@Suite("Gaze assistance modes")
@MainActor
struct GazeAssistanceModeTests {
    private func defaults() -> UserDefaults {
        UserDefaults(suiteName: "iris.tests.gaze.\(UUID().uuidString)") ?? .standard
    }

    /// Ordinary play: a level that teaches nothing, for a player who has finished the learning.
    private func ordinary(_ mode: GazeAssistanceMode, at time: TimeInterval = 0) -> GazeMarkerPresentation {
        GazeAssistancePolicy.presentation(mode: mode, levelID: "4-2", hasCompletedLearning: true, activePlayTime: time)
    }

    @Test("a new player gets the classic mode")
    func newUserDefault() {
        #expect(GazeAssistanceMode.default == .classic)
        #expect(GameSettingsStore(defaults: defaults()).gazeAssistance == .classic)
        #expect(GazeAssistanceMode.allCases == [.classic, .guided, .visible])
    }

    @Test("CLASSIC: the marker stays hidden during ordinary play, and the edge halo is still allowed")
    func classic() {
        let presentation = ordinary(.classic)
        #expect(!presentation.isMarkerVisible)
        #expect(presentation.opacity == 0)
        #expect(presentation.showsEdgeGuidance)
        // Whatever the moment, it never appears on its own.
        for time in stride(from: 0.0, through: 30.0, by: 0.25) {
            #expect(!ordinary(.classic, at: time).isMarkerVisible, "classic showed the marker at \(time) s")
        }
    }

    @Test("VISIBLE: the marker is shown whenever the gaze gives a valid position")
    func visible() {
        for time in stride(from: 0.0, through: 30.0, by: 0.25) {
            let presentation = ordinary(.visible, at: time)
            #expect(presentation.opacity == 1, "visible dimmed the marker at \(time) s")
            #expect(presentation.showsEdgeGuidance)
        }
    }

    @Test("GUIDED: not permanent, appears and disappears on a fixed cycle, and repeats exactly")
    func guided() {
        let period = GazeAssistancePolicy.guidedPeriod
        let fade = GazeAssistancePolicy.guidedFade
        let hold = GazeAssistancePolicy.guidedHold

        // It is never permanent: over one period there is a moment fully shown and a moment fully hidden.
        var sawFull = false
        var sawNone = false
        for step in stride(from: 0.0, to: period, by: 0.05) {
            let opacity = GazeAssistancePolicy.guidedOpacity(at: step)
            if opacity >= 1 { sawFull = true }
            if opacity <= 0 { sawNone = true }
        }
        #expect(sawFull && sawNone, "guided must both appear and disappear inside one cycle")

        // The shape of one cycle, at the moments that define it.
        #expect(GazeAssistancePolicy.guidedOpacity(at: 0) == 0)
        #expect(GazeAssistancePolicy.guidedOpacity(at: fade) == 1)
        #expect(GazeAssistancePolicy.guidedOpacity(at: fade + hold) == 1)
        #expect(GazeAssistancePolicy.guidedOpacity(at: fade + hold + fade) == 0)
        #expect(GazeAssistancePolicy.guidedOpacity(at: period - 0.01) == 0)

        // Deterministic: the same instant of the next cycle gives the same value, every time. Compared with a
        // tolerance because the argument itself carries floating-point error, not the function.
        for step in stride(from: 0.0, to: period, by: 0.1) {
            let first = GazeAssistancePolicy.guidedOpacity(at: step)
            #expect(abs(GazeAssistancePolicy.guidedOpacity(at: step + period) - first) < 1e-6, "cycle differs at \(step) s")
            #expect(abs(GazeAssistancePolicy.guidedOpacity(at: step + period * 7) - first) < 1e-6, "cycle drifts at \(step) s")
        }
        #expect(ordinary(.guided, at: fade).isMarkerVisible)
        #expect(!ordinary(.guided, at: period - 0.01).isMarkerVisible)
    }

    @Test("the choice is persisted and restored")
    func persistence() {
        let store = defaults()
        let first = GameSettingsStore(defaults: store)
        first.gazeAssistance = .guided
        #expect(GameSettingsStore(defaults: store).gazeAssistance == .guided)

        first.gazeAssistance = .visible
        #expect(GameSettingsStore(defaults: store).gazeAssistance == .visible)
    }

    @Test("the old diagnostic switch migrates once: on becomes visible, off becomes classic, and the old key goes")
    func migration() {
        let legacyKey = "iris.showsGazeIndicator"

        let hadItOn = defaults()
        hadItOn.set(true, forKey: legacyKey)
        let migratedOn = GameSettingsStore(defaults: hadItOn)
        #expect(migratedOn.gazeAssistance == .visible)
        #expect(hadItOn.object(forKey: legacyKey) == nil, "the old key must not survive the migration")
        #expect(GameSettingsStore(defaults: hadItOn).gazeAssistance == .visible, "the migrated choice is kept")

        let hadItOff = defaults()
        hadItOff.set(false, forKey: legacyKey)
        let migratedOff = GameSettingsStore(defaults: hadItOff)
        #expect(migratedOff.gazeAssistance == .classic)
        #expect(hadItOff.object(forKey: legacyKey) == nil)

        // A player who never touched it gets the default, and nothing is written for them to inherit later.
        let untouched = defaults()
        #expect(GameSettingsStore(defaults: untouched).gazeAssistance == .classic)
    }

    @Test("a stored mode always wins over the old switch, so the two can never disagree")
    func storedModeWins() {
        let store = defaults()
        store.set(true, forKey: "iris.showsGazeIndicator")
        store.set(GazeAssistanceMode.guided.rawValue, forKey: "iris.gazeAssistance")
        #expect(GameSettingsStore(defaults: store).gazeAssistance == .guided)
    }

    @Test("every mode names itself and explains itself, without a diagnostic word in sight")
    func copy() {
        let forbidden = ["diagnostic", "debug", "capteur", "pointeur", "VALID", "YAW", "PITCH"]
        for mode in GazeAssistanceMode.allCases {
            #expect(!mode.title.isEmpty)
            #expect(!mode.summary.isEmpty)
            for word in forbidden {
                #expect(!mode.title.lowercased().contains(word.lowercased()), "\(mode) title says \(word)")
                #expect(!mode.summary.lowercased().contains(word.lowercased()), "\(mode) summary says \(word)")
            }
        }
        #expect(GazeAssistanceMode.classic.title == "Classique")
        #expect(GazeAssistanceMode.guided.title == "Guidé")
        #expect(GazeAssistanceMode.visible.title == "Visible")
    }
}
