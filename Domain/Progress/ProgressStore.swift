// ProgressStore.swift
// Layer: Domain (contract)
// Purpose: Persistence contract of the campaign progress

import Foundation

protocol ProgressStore: AnyObject, Sendable {
    func load() -> CampaignProgress
    func save(_ progress: CampaignProgress)
    func reset()
}
