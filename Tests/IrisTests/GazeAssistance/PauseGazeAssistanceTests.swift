// PauseGazeAssistanceTests.swift
// Layer: Tests
// Purpose: The pause offers the same gaze assistance choice as the settings, over the same stored value, and it
// never pretends to override the chapter I learning

import Foundation
import Testing
@testable import Iris

@Suite("Pause gaze assistance")
@MainActor
struct PauseGazeAssistanceTests {
    private let gaze = SimulatedGazeTrackingService()
    private let audio = MockAudioService()
    private let haptics = MockHapticFeedbackService()
    private let clock = ManualGameClock()
    private let navigator = MockNavigator()
    private let calibration = InMemoryCalibrationStore()
    private let suiteName = "iris.tests.pauseGaze.\(UUID().uuidString)"

    private var defaults: UserDefaults { UserDefaults(suiteName: suiteName) ?? .standard }

    /// A level that asks nothing of the player, at any position in the campaign.
    private func level(chapter: Int, index: Int) -> LevelDefinition {
        LevelDefinition(chapter: chapter, index: index, title: "repos", principle: "p", zone: 0.46, noise: 0,
                        lueurs: [LueurDefinition(start: NormalizedPoint(x: 0.62, y: 0.3), iris: NormalizedPoint(x: 0.62, y: 0.3))],
                        hints: [], par: LevelPar(time: 10, intrusions: 2))
    }

    private func makeSUT(chapter: Int = 2, index: Int = 1,
                         settings: GameSettingsStore,
                         hasCompletedLearning: Bool = true) -> GameViewModel {
        navigator.hasCompletedGazeLearning = hasCompletedLearning
        let sut = GameViewModel(level: level(chapter: chapter, index: index), gaze: gaze, audio: audio, haptics: haptics,
                                clock: clock, settings: settings, calibrationStore: calibration,
                                orientation: FixedOrientationProvider(), isPad: false, autoplay: false, navigator: navigator)
        sut.prepare(width: 390, height: 844, displayScale: 3)
        return sut
    }

    // MARK: One value, two screens

    @Test("the pause and the settings read and write the very same value: there is no second selection")
    func oneSourceOfTruth() {
        let settings = GameSettingsStore(defaults: defaults)
        let sut = makeSUT(settings: settings)

        // What the settings screen binds to is `settings.gazeAssistance`; what the pause binds to is
        // `viewModel.gazeAssistance`. If these were two states, one of the two directions below would fail.
        sut.gazeAssistance = .visible
        #expect(settings.gazeAssistance == .visible, "a pause change did not reach the settings")

        settings.gazeAssistance = .guided
        #expect(sut.gazeAssistance == .guided, "a settings change did not reach the pause")
    }

    @Test("the settings screen shows a pause change immediately, without reloading anything")
    func settingsReflectPauseImmediately() {
        let settings = GameSettingsStore(defaults: defaults)
        let sut = makeSUT(settings: settings)
        settings.gazeAssistance = .classic

        sut.gazeAssistance = .guided
        // The value the settings section is handed is the store's own property, read live.
        #expect(settings.gazeAssistance == .guided)

        sut.gazeAssistance = .visible
        #expect(settings.gazeAssistance == .visible)
    }

    @Test("CLASSIC chosen in the pause is persisted, and found again by the next launch")
    func classicPersists() {
        let settings = GameSettingsStore(defaults: defaults)
        let sut = makeSUT(settings: settings)
        sut.gazeAssistance = .visible

        sut.gazeAssistance = .classic

        #expect(GameSettingsStore(defaults: defaults).gazeAssistance == .classic)
        #expect(sut.gazeMarker.isMarkerVisible == false, "classic must take effect on this level at once")
    }

    @Test("GUIDED chosen in the pause is persisted, and found again by the next launch")
    func guidedPersists() {
        let settings = GameSettingsStore(defaults: defaults)
        let sut = makeSUT(settings: settings)

        sut.gazeAssistance = .guided

        #expect(GameSettingsStore(defaults: defaults).gazeAssistance == .guided)
    }

    @Test("VISIBLE chosen in the pause is persisted, and found again by the next launch")
    func visiblePersists() {
        let settings = GameSettingsStore(defaults: defaults)
        let sut = makeSUT(settings: settings)

        sut.gazeAssistance = .visible

        #expect(GameSettingsStore(defaults: defaults).gazeAssistance == .visible)
        #expect(sut.gazeMarker.isMarkerVisible, "visible must take effect on this level at once")
    }

    @Test("choosing from the pause writes no new key: the Gate 3 preference is the only one")
    func noSecondKey() {
        let store = defaults
        let before = Set(store.dictionaryRepresentation().keys)
        let settings = GameSettingsStore(defaults: store)
        let sut = makeSUT(settings: settings)

        sut.gazeAssistance = .guided
        sut.gazeAssistance = .visible
        sut.gazeAssistance = .classic

        let added = Set(store.dictionaryRepresentation().keys).subtracting(before)
        #expect(added == ["iris.gazeAssistance"], "the pause introduced another stored key: \(added.sorted())")
    }

    // MARK: The learning keeps the last word

    @Test("FIRST I-1: the pause says so and cannot override the teaching")
    func firstLevelOneProtected() {
        let settings = GameSettingsStore(defaults: defaults)
        let sut = makeSUT(chapter: 1, index: 1, settings: settings, hasCompletedLearning: false)

        #expect(sut.isGazeLearningActive, "the pause must present the choice as guided on the first I-1")
        for mode in GazeAssistanceMode.allCases {
            sut.gazeAssistance = mode
            #expect(sut.gazeMarker.opacity == 1, "\(mode) changed what I-1 teaches")
        }
    }

    @Test("FIRST I-2: same — the choice is recorded, the level is not changed")
    func firstLevelTwoProtected() {
        let settings = GameSettingsStore(defaults: defaults)
        let sut = makeSUT(chapter: 1, index: 2, settings: settings, hasCompletedLearning: false)

        #expect(sut.isGazeLearningActive)
        for mode in GazeAssistanceMode.allCases {
            sut.gazeAssistance = mode
            #expect(sut.gazeMarker.opacity == 1, "\(mode) changed what I-2 teaches")
            // The choice is still stored: it is what will apply from I-4 on.
            #expect(settings.gazeAssistance == mode)
        }
    }

    @Test("FIRST I-3: the fade belongs to the level, not to the pause")
    func firstLevelThreeProtected() {
        let settings = GameSettingsStore(defaults: defaults)
        let sut = makeSUT(chapter: 1, index: 3, settings: settings, hasCompletedLearning: false)

        #expect(sut.isGazeLearningActive)
        for mode in GazeAssistanceMode.allCases {
            sut.gazeAssistance = mode
            #expect(sut.gazeMarker.opacity == 1, "\(mode) skipped the start of the I-3 fade")
        }
    }

    @Test("I-4 is already out of the teaching: the pause is live there, on the very first pass")
    func fourthLevelIsFree() {
        let settings = GameSettingsStore(defaults: defaults)
        let sut = makeSUT(chapter: 1, index: 4, settings: settings, hasCompletedLearning: false)

        #expect(sut.isGazeLearningActive == false)
        sut.gazeAssistance = .classic
        #expect(sut.gazeMarker.isMarkerVisible == false)
        sut.gazeAssistance = .visible
        #expect(sut.gazeMarker.isMarkerVisible)
    }

    @Test("once I-3 is completed the pause selector is live everywhere, replays included")
    func activeAfterLearning() {
        let settings = GameSettingsStore(defaults: defaults)
        for index in 1...3 {
            let sut = makeSUT(chapter: 1, index: index, settings: settings, hasCompletedLearning: true)

            #expect(sut.isGazeLearningActive == false, "replaying 1-\(index) must not lock the choice again")
            sut.gazeAssistance = .classic
            #expect(sut.gazeMarker.isMarkerVisible == false, "1-\(index) ignored the chosen mode on replay")
            sut.gazeAssistance = .visible
            #expect(sut.gazeMarker.isMarkerVisible, "1-\(index) ignored the chosen mode on replay")
        }
    }

    // MARK: What the panel says

    @Test("the note explains the teaching in the player's words, with no diagnostic vocabulary")
    func learningNote() {
        let note = GazeAssistancePicker.learningNote
        #expect(note == "L'aide au regard est guidée pendant les premiers niveaux d'apprentissage.")
        for word in ["diagnostic", "VALID", "YAW", "PITCH", "debug", "tracking", "override"] {
            #expect(note.localizedCaseInsensitiveContains(word) == false, "the note says \(word)")
        }
        // Nothing here may sound like a health claim: Iris is a game.
        for word in ["vue", "yeux", "thérap", "rééduc", "soigne", "corrige"] {
            #expect(note.localizedCaseInsensitiveContains(word) == false, "the note claims \(word)")
        }
    }

    @Test("the pause offers exactly the three modes, each one saying what it does")
    func compactVariantKeepsTheChoices() {
        #expect(GazeAssistanceMode.allCases.map(\.title) == ["Classique", "Guidé", "Visible"])
        // Both variants draw the same three rows from the same case list. They differ only in how much of the
        // mode they explain, and PauseGazeCopyTests holds that difference to its exact words.
        for mode in GazeAssistanceMode.allCases {
            #expect(mode.summary.isEmpty == false)
            #expect(mode.compactSummary.isEmpty == false)
        }
    }
}
