// HistoricalCampaignFingerprintTests.swift
// Layer: Tests
// Purpose: Protection of the historical campaign (chapters I to VI, 34 levels) and of the frozen engine: the canonical
// dump must match its fixture byte for byte, the frozen source files must keep their checksum, and the historical
// levels must carry none of the expansion mechanics

import CryptoKit
import Foundation
import Testing
@testable import Iris

@Suite("Historical campaign protection")
struct HistoricalCampaignFingerprintTests {
    static let historicalIDs = ["1-1", "1-2", "1-3", "1-4", "1-5",
                                "2-1", "2-2", "2-3", "2-4", "2-5",
                                "3-1", "3-2", "3-3", "3-4", "3-5", "3-6",
                                "4-1", "4-2", "4-3", "4-4", "4-5", "4-6",
                                "5-1", "5-2", "5-3", "5-4", "5-5", "5-6",
                                "6-1", "6-2", "6-3", "6-4", "6-5", "6-6"]

    /// SHA-256 of the sources that the expansion must never change: the six historical chapters, the Gaze Engine,
    /// the gaze filter and the physics integrator. Any legitimate change must be deliberate and update this table.
    /// PROTOTYPE branch (chapter I level 6): `GazeTrackingService.swift` and `ARKitGazeTrackingService.swift` were
    /// re-hashed after one additive change each, an optional `observation` (head pose, eye geometry) that nothing in
    /// the gaze computation reads; no threshold, filter, mapping or state behaviour changed (README, prototype section).
    static let frozenSources: [String: String] = [
        "AR/Calibration/AffineTransform2D.swift": "358b3235b9d2601a0057da899d2fb670d89befc5e41156fe961137c8b166ffe9",
        "AR/Calibration/AxisMapping.swift": "4aafc40399ebfaaef2213f5f43185e052cefcd2b461dad03cc0079fbc775e9f7",
        "AR/Calibration/BlinkDetector.swift": "0dcece8ae830dda53afaa43751c098389d65a52eb663ac4b9bfcc9cf0d53e942",
        "AR/Calibration/CalibrationGrid.swift": "42ba061f8aef76349e0c17e8b10e6809c0d1c2dfd7ab60422f9cbb9cec1facfd",
        "AR/Calibration/CalibrationProfile.swift": "0107e1fce4f08b30ac76e242d3c8e59f14847167e8cc57031c139450ba1b1a4e",
        "AR/Calibration/CalibrationResult.swift": "29468b5255186c19a7cd085045390e122bbf9a4e4537a053de59cdfe31213518",
        "AR/Calibration/CalibrationStore.swift": "e2a3c0663811b3fd10741ee6f85871afe7ea8be67b205bdeb83d6460d1713355",
        "AR/Calibration/DeviceAxis.swift": "7c022865a8eb376245b584023b91ca36b6b12eb66c3299d92524afd150387b6a",
        "AR/Calibration/FixationSequence.swift": "8aa0a84b2ef3289de5ca8526c26e9abaf8c037b7e5c2bd135e7436bb8a29bc7e",
        "AR/Calibration/GazeMapper.swift": "d0b01b54094e84d08b8896d590b91422ce0b95522a924994da67b1b2fcece89a",
        "AR/Calibration/GazeReadinessEvaluator.swift": "a0b6829b186bb344c6c14d17d0a23d5e4a3866fdb5da9aded5c978d30717680a",
        "AR/Calibration/GazeReadinessReport.swift": "bae4252722685054e13d4bdde591721fdd1d62a902988d2201c72b9d087c853d",
        "AR/Calibration/NominalDisplayGeometry.swift": "12010e81c1ad9818265b3e90992adc41a5c34a3bee9b20421b6f052d4f7dbd1b",
        "AR/Calibration/NormalizedCoordinates.swift": "23d95ae7c14de0e91142e69e330a82c90006a4aca0cd4c9784d37abadfb444d9",
        "AR/Calibration/RobustAggregator.swift": "a7b66f5ed18601dd18845acfae0ec4c27cc1938d79f2c6248a3fb78983e3e7df",
        "AR/Projection/GazeRay.swift": "7e10dbfc01f549c18ae0e4575fb85e499b65fd5fb952acdf619cf69afe1d30f7",
        "AR/Services/ARKitGazeTrackingService.swift": "05f2d7f2f364c48da0b115ed55e6b15ea2b2f983cf67f0cc703a4be610fa45cc",
        "AR/Services/CameraAuthorizationService.swift": "84337ff6957b8decd5e703be995386467cc34a3310ccba4b66a8dcdf78c1f3f4",
        "AR/Services/DeviceCapabilities.swift": "aaf35bcce665d7e6cedba423948898b5994218b4f0172301f9680ff11863c3bb",
        "AR/Services/GazeTrackingService.swift": "bb319fd4e4340e51462e99045ed0b38fa54a5f7d72e93b27c8138a2b30236432",
        "AR/Services/InterfaceOrientationProvider.swift": "ca7e8439fa236446e9d3af74e66fd4a11f06868c0d108d8810f3b88c45816766",
        "AR/Services/SimulatedGazeTrackingService.swift": "d16b5dd7d0ee423ce85addf40aef0f0d21143b45daf82d05a7283a0653aa98a7",
        "Domain/Campaign/Campaign+Clairvoyance.swift": "2d9f0f2b3b4680bd1b3313667ae23b2b65504018001ca75c2bf3856ff654868d",
        "Domain/Campaign/Campaign+Courants.swift": "8151505f821032102ed440be21aff6368d765e421f36edd7552ebee4e70cfa4a",
        "Domain/Campaign/Campaign+Eveil.swift": "0b21c291944269ac775e8f2917a82b1de7cd939b5f37450d6d17561db30752e3",
        "Domain/Campaign/Campaign+Partage.swift": "13e7102e71722994256bc0f8a4cbdc507316f868b508b9e43cbf31222b9f9e71",
        "Domain/Campaign/Campaign+Veilleuses.swift": "fdb63a4e6948521543e79d6033aff37bf011a50a169f885db53bbf4a2ffa57fa",
        "Domain/Campaign/Campaign+Voiles.swift": "800f7005d9338f3cdb3885049cb1f9614f4164cdf15eec3571849af7773a02b0",
        // Human-validated chapters VII to XII and chapter I level 6 (oculomotor expansion branch): frozen as well.
        "Domain/Campaign/Campaign+Jumelles.swift": "5fae102a59f4eded604b10b9d4eb73f29ac423c57a3991a3e4ce1579f61d03e9",
        "Domain/Campaign/Campaign+Souffles.swift": "08551e3452bd051428927704889910df712d9ea8f2f0e1d5bab7bead707bb361",
        "Domain/Campaign/Campaign+Echos.swift": "4df729bf64d83c8976db098ea483e0cd3e6bc09535b27edfc8a250bf202b1c7e",
        "Domain/Campaign/Campaign+Gouffres.swift": "7b63ee242f5e9c1f57b49e3760a59e27978eb692e555beb76105a68da8bc4854",
        "Domain/Campaign/Campaign+Braises.swift": "f11acafdbb93ca18d4a5d6248aee30287781943ee00500bb3712c7d8e2e050d4",
        "Domain/Campaign/Campaign+Constellation.swift": "e343c0c7d44550310a293e8da1ffce4a9c6ef7b6c8376b863c5cbcbc3bc26281",
        "Domain/Campaign/Campaign+Oculomoteur.swift": "0c257f7899f7cc161be637305bb72a49d2161b27088fbe56f211d32efb989b10",
        "GameEngine/Gaze/GazeFilter.swift": "e2b8f50ec196e3013229370c5343cc117649cf39cfed291d1bb9e38f39557693",
        "GameEngine/Physics/TargetPhysics.swift": "99e15cc5116499c7bfa443742f9b9733fda80c82b457eadb56f9b2f774ca6639",
    ]

    /// Project root, derived from this file's compile-time path (Tests/IrisTests/Campaign/...).
    private static var projectRoot: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
    }

    @Test("the canonical dump of the 34 historical levels matches Fixtures/historical_campaign.txt byte for byte")
    func dumpMatchesFixture() throws {
        let bundle = Bundle(for: GoldenTraceBundleLocator.self)
        let url = try #require(bundle.url(forResource: "historical_campaign", withExtension: "txt"), "fixture missing from the test bundle")
        let expected = try String(contentsOf: url, encoding: .utf8)
        let actual = HistoricalCampaignDump.render()
        if actual != expected {
            let expectedLines = expected.components(separatedBy: "\n")
            let actualLines = actual.components(separatedBy: "\n")
            var report: [String] = []
            for index in 0..<max(expectedLines.count, actualLines.count) where report.count < 12 {
                let before = index < expectedLines.count ? expectedLines[index] : "<missing>"
                let after = index < actualLines.count ? actualLines[index] : "<missing>"
                if before != after {
                    report.append("line \(index + 1)\n  fixture: \(before)\n  now:     \(after)")
                }
            }
            let details: String = report.joined(separator: "\n")
            Issue.record(Comment(rawValue: "historical campaign changed (\(expectedLines.count) fixture lines, \(actualLines.count) now):\n\(details)"))
        }
        #expect(actual == expected)
    }

    @Test("the frozen sources (historical chapters, Gaze Engine, gaze filter, physics integrator) keep their checksum")
    func frozenSourcesUnchanged() throws {
        let root = Self.projectRoot
        for (path, expected) in Self.frozenSources.sorted(by: { $0.key < $1.key }) {
            let data = try Data(contentsOf: root.appendingPathComponent(path))
            let digest: String = SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
            #expect(digest == expected, "\(path) changed")
        }
    }

    @Test("the historical chapters keep their ids, order, names, theme and carry no expansion mechanic")
    func purity() {
        #expect(Campaign.historicalLevels.map(\.id) == Self.historicalIDs)
        #expect(Campaign.historicalChapters.map(\.name) == ["éveil", "partage", "courants", "voiles", "veilleuses", "clairvoyance"])
        #expect(Campaign.historicalChapters.map(\.ambientFrequency) == [110, 123.47, 98, 130.81, 116.54, 146.83])
        #expect(Campaign.historicalChapters.allSatisfy { $0.theme == .chambreNoire && $0.isHistorical })
        for level in Campaign.historicalLevels {
            #expect(!level.hasBraises && !level.isExperimental, "\(level.id)")
            #expect(level.lueurs.allSatisfy { $0.braise == nil && $0.twin == nil && !$0.asleep }, "\(level.id)")
            #expect(!level.hasTwins && level.souffles.isEmpty && level.echo == nil && !level.hasSleepers && level.gouffres.isEmpty, "\(level.id)")
            #expect(level.balises == nil && level.oculo == nil && level.gatesProgression, "\(level.id)")
        }
        #expect(Campaign.chapters.dropFirst(6).allSatisfy { !$0.isHistorical })
    }
}
