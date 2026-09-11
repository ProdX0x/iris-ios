// HintTrackerTests.swift
// Layer: Tests
// Purpose: Contextual instructions appear once, when the player does the thing, and fade after 4.5 s

import Foundation
import Testing
@testable import Iris

@Suite("HintTracker")
struct HintTrackerTests {
    private let hints = [LevelHint(.start, "début"),
                         LevelHint(.firstIntrusion, "fuite"),
                         LevelHint(.firstHold, "tenir"),
                         LevelHint(.firstLoss, "perdu"),
                         LevelHint(.attentionLeftField, "écran"),
                         LevelHint(.veilleuseLow, "flamme"),
                         LevelHint(.firstValidation, "fermé"),
                         LevelHint(.afterSeconds(20), "aide")]

    @Test("start hint on begin, then each trigger fires once")
    func triggers() {
        var tracker = HintTracker(hints: hints)
        tracker.begin()
        #expect(tracker.current == "début")

        tracker.observe(events: [.intrusion(sequence: 1)], elapsed: 1)
        #expect(tracker.current == "fuite")
        tracker.observe(events: [.validationProgressed(sequence: 1, progress: 0.1)], elapsed: 2)
        #expect(tracker.current == "tenir")
        tracker.observe(events: [.intrusion(sequence: 1)], elapsed: 3)
        #expect(tracker.current == "tenir", "intrusion hint does not come back")
        tracker.observe(events: [.targetLost(sequence: 1, cause: .drift)], elapsed: 3.5)
        #expect(tracker.current == "perdu")
        tracker.observe(events: [.attentionLeftField], elapsed: 4)
        #expect(tracker.current == "écran")
        tracker.observe(events: [.veilleuseLow(index: 0)], elapsed: 5)
        #expect(tracker.current == "flamme")
        tracker.observe(events: [.targetValidated(sequence: 1)], elapsed: 6)
        #expect(tracker.current == "fermé")
    }

    @Test("a hint fades after the display duration and the timed help appears on time")
    func timing() {
        var tracker = HintTracker(hints: hints)
        tracker.begin()

        let faded = tracker.observe(events: [], elapsed: 5)
        #expect(faded)
        #expect(tracker.current == nil)
        tracker.observe(events: [], elapsed: 19.9)
        #expect(tracker.current == nil)
        tracker.observe(events: [], elapsed: 20)
        #expect(tracker.current == "aide")
        tracker.dismiss()
        #expect(tracker.current == nil)
    }

    @Test("generic help depends on whether the level needs pushing")
    func genericHelp() {
        guard let avoidance = Campaign.level(id: "1-2"), let pushing = Campaign.level(id: "3-1") else {
            Issue.record("missing levels")
            return
        }
        var calm = HintTracker.forLevel(avoidance, helpDelay: 10)
        var push = HintTracker.forLevel(pushing, helpDelay: 10)

        calm.observe(events: [], elapsed: 10)
        push.observe(events: [], elapsed: 10)

        #expect(calm.current == "Cherchez l'espace le plus vide de l'écran.")
        #expect(push.current == "La voie est tracée en pointillés.")
    }
}

@Suite("ProgressStore")
struct ProgressStoreTests {
    @Test("UserDefaults store round trips progress and resets")
    func userDefaults() {
        let defaults = UserDefaults(suiteName: "iris.tests.progress.\(UUID().uuidString)") ?? .standard
        let store = UserDefaultsProgressStore(defaults: defaults)
        var progress = CampaignProgress()
        guard let level = Campaign.level(id: "1-1") else {
            Issue.record("missing level")
            return
        }
        progress.register(LevelOutcome(time: 8, intrusions: 1, losses: 0), for: level)
        progress.encounter([.lueur, .iris])

        store.save(progress)
        let loaded = store.load()

        #expect(loaded == progress)
        #expect(loaded.record(for: level).eclats == [.atteint, .fluide, .serein])
        store.reset()
        #expect(store.load() == CampaignProgress())
    }

    @Test("in-memory store keeps what it is given")
    func inMemory() {
        let store = InMemoryProgressStore()
        var progress = CampaignProgress()
        progress.totalPlayTime = 42
        store.save(progress)
        #expect(store.load().totalPlayTime == 42)
        store.reset()
        #expect(store.load().totalPlayTime == 0)
    }
}
