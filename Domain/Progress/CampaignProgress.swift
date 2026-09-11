// CampaignProgress.swift
// Layer: Domain
// Purpose: Unlock rules and records of the campaign

import Foundation

struct CampaignProgress: Codable, Hashable, Sendable {
    static let currentVersion = 1

    var version: Int
    var records: [String: LevelRecord]
    var totalPlayTime: TimeInterval
    var encounteredElements: Set<GameElement>

    init(records: [String: LevelRecord] = [:], totalPlayTime: TimeInterval = 0, encounteredElements: Set<GameElement> = []) {
        self.version = Self.currentVersion
        self.records = records
        self.totalPlayTime = totalPlayTime
        self.encounteredElements = encounteredElements
    }

    func record(for level: LevelDefinition) -> LevelRecord {
        records[level.id] ?? LevelRecord()
    }

    func isCompleted(_ level: LevelDefinition) -> Bool {
        record(for: level).isCompleted
    }

    /// The first level is always open; any other opens once the level before it (campaign order) is completed.
    func isUnlocked(_ level: LevelDefinition, in campaign: [LevelDefinition]) -> Bool {
        guard let index = campaign.firstIndex(where: { $0.id == level.id }) else { return false }
        return index == 0 || isCompleted(campaign[index - 1])
    }

    func isUnlocked(_ chapter: ChapterDefinition, in campaign: [LevelDefinition]) -> Bool {
        guard let first = chapter.levels.first else { return false }
        return isUnlocked(first, in: campaign)
    }

    /// Next level to play: the first unlocked, not completed level; nil once everything is completed.
    func nextLevel(in campaign: [LevelDefinition]) -> LevelDefinition? {
        campaign.first { isUnlocked($0, in: campaign) && !isCompleted($0) }
    }

    func completedCount(in levels: [LevelDefinition]) -> Int {
        levels.filter(isCompleted).count
    }

    func eclatCount(in levels: [LevelDefinition]) -> Int {
        levels.reduce(0) { $0 + record(for: $1).eclats.count }
    }

    mutating func register(_ outcome: LevelOutcome, for level: LevelDefinition) {
        var record = record(for: level)
        record.register(outcome, par: level.par)
        records[level.id] = record
        totalPlayTime += outcome.time
    }

    mutating func encounter(_ elements: [GameElement]) {
        encounteredElements.formUnion(elements)
    }
}
