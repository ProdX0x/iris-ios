// CampaignMeasurements.swift
// Layer: Tests
// Purpose: One shared, lazily computed simulation of every level (reused by all campaign validation tests)

import Foundation
@testable import Iris

struct LevelMeasurement: Sendable {
    let id: String
    let guided: [CampaignBot.Result]
    let avoidance: CampaignBot.Result
    let ignoresVeilleuses: CampaignBot.Result?
    let offScreen: CampaignBot.Result

    var guidedTime: Double { guided.map(\.time).reduce(0, +) / Double(guided.count) }
    var guidedIntrusions: Double { Double(guided.map(\.intrusions).reduce(0, +)) / Double(guided.count) }
    var guidedLosses: Double { Double(guided.map(\.losses).reduce(0, +)) / Double(guided.count) }
}

extension CampaignBot.Result: @unchecked Sendable {}

enum CampaignMeasurements {
    static let all: [String: LevelMeasurement] = {
        var results: [String: LevelMeasurement] = [:]
        for level in Campaign.levels {
            results[level.id] = LevelMeasurement(
                id: level.id,
                guided: (1...3).map { CampaignBot(definition: level, policy: .guided, seed: $0).run(maxSeconds: 90) },
                avoidance: CampaignBot(definition: level, policy: .avoidance).run(maxSeconds: 60),
                ignoresVeilleuses: level.veilleuses.isEmpty ? nil : CampaignBot(definition: level, policy: .ignoresVeilleuses).run(maxSeconds: 60),
                offScreen: CampaignBot(definition: level, policy: .offScreen).run(maxSeconds: 30))
        }
        return results
    }()

    static func of(_ level: LevelDefinition) -> LevelMeasurement {
        guard let measurement = all[level.id] else {
            preconditionFailure("unmeasured level \(level.id)")
        }
        return measurement
    }
}
