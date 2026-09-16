// GazeLearningFlowTests.swift
// Layer: Tests
// Purpose: The first three levels teach the marker and then let go: visible, visible, fading; from the fourth the
// player's own mode applies; and once the learning is behind them, replaying those levels obeys the mode too

import Foundation
import Testing
@testable import Iris

@Suite("Chapter I gaze learning")
@MainActor
struct GazeLearningFlowTests {
    private func learning(_ levelID: String, mode: GazeAssistanceMode = .classic, at time: TimeInterval = 0) -> GazeMarkerPresentation {
        GazeAssistancePolicy.presentation(mode: mode, levelID: levelID, hasCompletedLearning: false, activePlayTime: time)
    }

    private func afterLearning(_ levelID: String, mode: GazeAssistanceMode, at time: TimeInterval = 0) -> GazeMarkerPresentation {
        GazeAssistancePolicy.presentation(mode: mode, levelID: levelID, hasCompletedLearning: true, activePlayTime: time)
    }

    @Test("the three teaching levels are the first three of chapter I, and they really exist")
    func levels() {
        #expect(GazeAssistancePolicy.learningLevelIDs == ["1-1", "1-2", "1-3"])
        #expect(GazeAssistancePolicy.learningFinalLevelID == "1-3")
        for id in GazeAssistancePolicy.learningLevelIDs {
            let level = Campaign.level(id: id)
            #expect(level != nil, "\(id) is not in the campaign")
            #expect(level?.chapter == 1)
        }
        #expect(GazeAssistancePolicy.learningStage(for: "1-1") == 1)
        #expect(GazeAssistancePolicy.learningStage(for: "1-3") == 3)
        #expect(GazeAssistancePolicy.learningStage(for: "1-4") == nil)
    }

    @Test("FIRST I-1: the marker is forced visible, whatever the player chose")
    func firstLevelOne() {
        for mode in GazeAssistanceMode.allCases {
            for time in stride(from: 0.0, through: 60.0, by: 2) {
                let presentation = learning("1-1", mode: mode, at: time)
                #expect(presentation.opacity == 1, "\(mode) dimmed the marker on 1-1 at \(time) s")
            }
        }
    }

    @Test("FIRST I-2: still forced visible, long enough to notice the marker is never quite still")
    func firstLevelTwo() {
        for mode in GazeAssistanceMode.allCases {
            for time in stride(from: 0.0, through: 60.0, by: 2) {
                #expect(learning("1-2", mode: mode, at: time).opacity == 1, "\(mode) dimmed the marker on 1-2")
            }
        }
    }

    @Test("FIRST I-3: whole at the start, then fading gently, and gone by the end")
    func firstLevelThree() {
        let hold = GazeAssistancePolicy.learningHold
        let fade = GazeAssistancePolicy.learningFade

        #expect(learning("1-3", at: 0).opacity == 1, "1-3 must begin with the marker")
        #expect(learning("1-3", at: hold).opacity == 1, "the marker is whole until the hold is over")

        // It decreases, and never comes back up.
        var previous = 1.0
        for time in stride(from: hold, through: hold + fade, by: 0.5) {
            let opacity = learning("1-3", at: time).opacity
            #expect(opacity <= previous + 1e-9, "the marker brightened again at \(time) s")
            previous = opacity
        }
        // Half way through the fade it is genuinely partial: neither on nor off.
        let midway = learning("1-3", at: hold + fade / 2).opacity
        #expect(midway > 0.2 && midway < 0.8, "the fade should be progressive, measured \(midway)")

        #expect(learning("1-3", at: hold + fade).opacity == 0, "the marker must be gone when the fade ends")
        #expect(!learning("1-3", at: hold + fade + 30).isMarkerVisible, "and it must stay gone")
    }

    @Test("FIRST I-4: no teaching any more — the player's mode applies")
    func firstLevelFour() {
        #expect(!learning("1-4", mode: .classic).isMarkerVisible)
        #expect(learning("1-4", mode: .visible).opacity == 1)
        #expect(GazeAssistancePolicy.guidedOpacity(at: GazeAssistancePolicy.guidedFade) == 1)
        #expect(learning("1-4", mode: .guided, at: GazeAssistancePolicy.guidedFade).opacity == 1)
    }

    @Test("AFTER the learning: replaying I-1, I-2 and I-3 obeys the chosen mode")
    func replayAfterLearning() {
        for id in GazeAssistancePolicy.learningLevelIDs {
            #expect(!afterLearning(id, mode: .classic, at: 5).isMarkerVisible, "\(id) still forced the marker in classic")
            #expect(afterLearning(id, mode: .visible, at: 5).opacity == 1, "\(id) hid the marker in visible")
            // Guided keeps its cycle on these levels too.
            #expect(afterLearning(id, mode: .guided, at: GazeAssistancePolicy.guidedFade).opacity == 1)
            #expect(!afterLearning(id, mode: .guided, at: GazeAssistancePolicy.guidedPeriod - 0.01).isMarkerVisible)
        }
        #expect(!GazeAssistancePolicy.isLearning(levelID: "1-1", hasCompletedLearning: true))
        #expect(GazeAssistancePolicy.isLearning(levelID: "1-1", hasCompletedLearning: false))
    }

    @Test("the learning is over when 1-3 is completed: it is read from the progress, not stored twice")
    func completionComesFromProgress() throws {
        let fresh = AppContainer.preview().makeAppCoordinator()
        #expect(!fresh.hasCompletedGazeLearning, "a new player has not finished the learning")

        let done = AppContainer.preview(progressStore: InMemoryProgressStore(progress: LaunchOptions.progress(for: .through("1-3"))))
            .makeAppCoordinator()
        #expect(done.hasCompletedGazeLearning, "completing 1-3 ends the learning")

        // Completing only the first two does not end it.
        let partway = AppContainer.preview(progressStore: InMemoryProgressStore(progress: LaunchOptions.progress(for: .through("1-2"))))
            .makeAppCoordinator()
        #expect(!partway.hasCompletedGazeLearning)
    }

    @Test("the introduction is shown once before the very first level, then never holds it up again")
    func introductionBeforeFirstLevel() throws {
        let container = AppContainer.preview(hasSeenGazeIntroduction: false)
        let sut = container.makeAppCoordinator()
        let first = try #require(Campaign.level(id: "1-1"))

        sut.play(first)
        #expect(sut.sheet == .gazeIntroduction, "the first level must explain the marker first")
        #expect(sut.route == .home, "and it must not start the level yet")

        sut.completeGazeIntroduction()
        #expect(container.onboarding.hasSeenGazeIntroduction)
        #expect(sut.sheet == nil)
        #expect(sut.route == .gazeSetup(.firstRun), "the level it was holding must then go ahead")

        // Second time, it goes straight through.
        let again = AppContainer.preview(hasSeenGazeIntroduction: true).makeAppCoordinator()
        again.play(first)
        #expect(again.sheet == nil)
        #expect(again.route == .gazeSetup(.firstRun))
    }

    @Test("the introduction can be reopened from the settings without starting anything")
    func introductionOnDemand() {
        let sut = AppContainer.preview().makeAppCoordinator()
        sut.showGazeIntroduction()
        #expect(sut.sheet == .gazeIntroduction)

        sut.completeGazeIntroduction()
        #expect(sut.sheet == nil)
        #expect(sut.route == .home, "reading it again must not start a level")
    }

    @Test("the three screens say what they must, with no jargon and no promise about health")
    func introductionCopy() {
        let pages = GazeIntroductionPage.all
        #expect(pages.count == 3)
        #expect(pages[0].title.contains("n'est pas un point fixe"))
        #expect(pages[1].title.contains("accompagne"))
        #expect(pages[2].title.contains("choix"))
        #expect(pages[2].note?.contains("0 %") == true, "the calibration reference belongs on the last screen")
        #expect(GazeIntroductionPage.actionTitle(atIndex: 0) == "Suivant")
        #expect(GazeIntroductionPage.actionTitle(atIndex: 2) == "Commencer")

        let forbidden = ["diagnostic", "debug", "yaw", "pitch", "valid_inside",
                         "rééduc", "thérap", "clinique", "améliore la vue", "soigne"]
        for page in pages {
            let text = (page.title + " " + page.detail + " " + (page.note ?? "")).lowercased()
            for word in forbidden {
                #expect(!text.contains(word), "the introduction says \(word)")
            }
        }
    }
}
