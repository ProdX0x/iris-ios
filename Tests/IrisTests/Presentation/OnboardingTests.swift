// OnboardingTests.swift
// Layer: Tests
// Purpose: The four explanation screens: what they say, that they say it about a game and nothing else, that they
// appear once and may be skipped, and that they stay reachable afterwards

import Foundation
import Testing
@testable import Iris

@Suite("Onboarding")
@MainActor
struct OnboardingTests {
    private func makeDefaults() -> UserDefaults {
        UserDefaults(suiteName: "iris.tests.onboarding.\(UUID().uuidString)") ?? .standard
    }

    @Test("there are exactly four screens, each with its own figure, and they explain the repulsion in order")
    func pages() {
        let pages = OnboardingPage.all
        #expect(pages.count == 4)
        #expect(pages.map(\.figure) == [.repulsion, .directStare, .indirectGaze, .destination])
        #expect(Set(pages.map(\.figure)).count == 4)
        #expect(Set(OnboardingPage.Figure.allCases) == Set(pages.map(\.figure)))
        for page in pages {
            #expect(!page.title.isEmpty)
            #expect(!page.detail.isEmpty)
            #expect(!page.figureDescription.isEmpty, "\(page.figure) has nothing for VoiceOver")
        }
        // The four ideas the mission asks for, in the order it asks for them.
        #expect(pages[0].title.contains("repousse"))
        #expect(pages[1].title.contains("Ne fixez pas"))
        #expect(pages[2].title.contains("autour"))
        #expect(pages[3].title.contains("Guidez"))
    }

    @Test("the explanation appears once, may be skipped, and is remembered")
    func store() {
        let defaults = makeDefaults()
        let sut = OnboardingStore(defaults: defaults)
        #expect(!sut.hasCompletedOnboarding, "it must open at the first launch")

        sut.complete()
        #expect(sut.hasCompletedOnboarding)
        #expect(OnboardingStore(defaults: defaults).hasCompletedOnboarding, "it must not come back")
    }

    @Test("the coordinator closes the explanation and can open it again from the interface")
    func coordinator() {
        let container = AppContainer.preview(hasCompletedOnboarding: false)
        let sut = container.makeAppCoordinator()
        #expect(!container.onboarding.hasCompletedOnboarding)

        sut.completeOnboarding()
        #expect(container.onboarding.hasCompletedOnboarding)

        sut.showHowToPlay()
        #expect(sut.sheet == .howToPlay)
        #expect(AppSheet.howToPlay.title == "Comment jouer")
    }

    @Test("the threshold and the settings both lead to the explanation, and nothing initialises the camera there")
    func reachability() throws {
        let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()
            .deletingLastPathComponent().deletingLastPathComponent()
        func source(_ path: String) throws -> String {
            try String(contentsOf: root.appendingPathComponent(path), encoding: .utf8)
        }
        #expect(try source("Features/Home/HomeView.swift").contains("coordinator.showHowToPlay()"))
        #expect(try source("Features/Settings/SettingsView.swift").contains("coordinator.showHowToPlay()"))
        for path in ["Features/Onboarding/OnboardingView.swift", "Features/Onboarding/OnboardingFigure.swift",
                     "Features/HowToPlay/HowToPlayView.swift"] {
            let text = try source(path)
            for forbidden in ["import ARKit", "import AVFoundation", "GazeTrackingService(", "TimelineView(",
                              "Timer.publish", "Timer.scheduledTimer", ".repeatForever"] {
                #expect(!text.contains(forbidden), "\(path) uses \(forbidden)")
            }
            #expect(text.contains("import SwiftUI"))
        }
    }
}
