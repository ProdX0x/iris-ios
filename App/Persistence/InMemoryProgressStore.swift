// InMemoryProgressStore.swift
// Layer: App (persistence adapter)
// Purpose: Volatile progress for previews, tests and debug launches

import Foundation

final class InMemoryProgressStore: ProgressStore, @unchecked Sendable {
    private let lock = NSLock()
    private var progress: CampaignProgress

    init(progress: CampaignProgress = CampaignProgress()) {
        self.progress = progress
    }

    func load() -> CampaignProgress {
        lock.withLock { progress }
    }

    func save(_ progress: CampaignProgress) {
        lock.withLock { self.progress = progress }
    }

    func reset() {
        lock.withLock { progress = CampaignProgress() }
    }
}
