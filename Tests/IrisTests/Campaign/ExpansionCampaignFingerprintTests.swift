// ExpansionCampaignFingerprintTests.swift
// Layer: Tests
// Purpose: Protection of the human-validated chapters VII to XII and of chapter I level 6: their canonical dump must
// match Fixtures/expansion_campaign.txt byte for byte, and the played chapters must start with those exact levels

import Foundation
import Testing
@testable import Iris

@Suite("Expansion campaign protection")
struct ExpansionCampaignFingerprintTests {
    @Test("the canonical dump of chapters VII to XII and of level 1-6 matches Fixtures/expansion_campaign.txt byte for byte")
    func dumpMatchesFixture() throws {
        let bundle = Bundle(for: GoldenTraceBundleLocator.self)
        let url = try #require(bundle.url(forResource: "expansion_campaign", withExtension: "txt"), "fixture missing from the test bundle")
        let expected = try String(contentsOf: url, encoding: .utf8)
        let actual = ExpansionCampaignDump.render()
        if actual != expected {
            let expectedLines = expected.components(separatedBy: "\n")
            let actualLines = actual.components(separatedBy: "\n")
            var report: [String] = []
            for index in 0..<max(expectedLines.count, actualLines.count) where report.count < 12 {
                let before = index < expectedLines.count ? expectedLines[index] : "<missing>"
                let after = index < actualLines.count ? actualLines[index] : "<missing>"
                if before != after { report.append("line \(index + 1)\n  fixture: \(before)\n  now:     \(after)") }
            }
            let details: String = report.joined(separator: "\n")
            Issue.record(Comment(rawValue: "validated expansion changed (\(expectedLines.count) fixture lines, \(actualLines.count) now):\n\(details)"))
        }
        #expect(actual == expected)
    }

    @Test("every played chapter starts with its validated levels, in order; only optional levels may follow")
    func playedChaptersKeepValidatedLevels() {
        for (base, played) in zip(Campaign.baseChapters, Campaign.chapters) {
            #expect(base.number == played.number && base.name == played.name && base.theme == played.theme, "chapter \(base.number)")
            #expect(Array(played.levels.prefix(base.levels.count)) == base.levels, "chapter \(base.number)")
            #expect(played.levels.dropFirst(base.levels.count).allSatisfy { !$0.gatesProgression }, "chapter \(base.number)")
            #expect(played.levels.dropFirst(base.levels.count).count <= 1, "chapter \(base.number): at most one added level")
        }
        #expect(Campaign.baseChapters.map(\.levels.count) == [6, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6])
    }
}
