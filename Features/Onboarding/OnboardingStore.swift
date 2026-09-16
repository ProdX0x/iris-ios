// OnboardingStore.swift
// Layer: Presentation
// Purpose: Whether the explanations have already been shown: the four screens of the first launch, and the three
// that introduce the gaze marker before the very first level. Two flags on the device, nothing else

import Foundation
import Observation

@MainActor
@Observable
final class OnboardingStore {
    private enum Key {
        static let completed = "iris.onboarding.completed"
        static let gazeIntroduction = "iris.onboarding.gazeIntroduction"
    }

    /// False on the very first launch: the explanation opens by itself, and may be skipped.
    var hasCompletedOnboarding: Bool {
        didSet { defaults.set(hasCompletedOnboarding, forKey: Key.completed) }
    }

    /// False until the three gaze-marker screens have been read once, just before the first level. It cannot be
    /// derived from the campaign progress: a player may open the first level without finishing it.
    var hasSeenGazeIntroduction: Bool {
        didSet { defaults.set(hasSeenGazeIntroduction, forKey: Key.gazeIntroduction) }
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        hasCompletedOnboarding = defaults.bool(forKey: Key.completed)
        hasSeenGazeIntroduction = defaults.bool(forKey: Key.gazeIntroduction)
    }

    func complete() {
        hasCompletedOnboarding = true
    }

    func completeGazeIntroduction() {
        hasSeenGazeIntroduction = true
    }
}
