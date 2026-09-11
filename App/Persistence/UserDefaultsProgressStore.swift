// UserDefaultsProgressStore.swift
// Layer: App (persistence adapter)
// Purpose: Campaign progress stored as JSON in UserDefaults (records and éclats only, no gaze data)

import Foundation

final class UserDefaultsProgressStore: ProgressStore, @unchecked Sendable {
    private static let key = "iris.campaign.progress"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> CampaignProgress {
        guard let data = defaults.data(forKey: Self.key),
              let progress = try? JSONDecoder().decode(CampaignProgress.self, from: data),
              progress.version == CampaignProgress.currentVersion else {
            return CampaignProgress()
        }
        return progress
    }

    func save(_ progress: CampaignProgress) {
        guard let data = try? JSONEncoder().encode(progress) else { return }
        defaults.set(data, forKey: Self.key)
    }

    func reset() {
        defaults.removeObject(forKey: Self.key)
    }
}
