// OnboardingStore.swift
// Layer: Presentation
// Purpose: Whether the four explanation screens have already been shown. One flag on the device, nothing else

import Foundation
import Observation

@MainActor
@Observable
final class OnboardingStore {
    private enum Key {
        static let completed = "iris.onboarding.completed"
    }

    /// False on the very first launch: the explanation opens by itself, and may be skipped.
    var hasCompletedOnboarding: Bool {
        didSet { defaults.set(hasCompletedOnboarding, forKey: Key.completed) }
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        hasCompletedOnboarding = defaults.bool(forKey: Key.completed)
    }

    func complete() {
        hasCompletedOnboarding = true
    }
}
