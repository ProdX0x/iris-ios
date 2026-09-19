// ReadinessDetailLocalizationTests.swift
// Layer: Tests
// Purpose: The readiness checklist is the last thing a player reads before calibrating, and until now it answered in
// French whatever language the phone was set to. These tests hold the two halves of the repair: the French must come
// out exactly as it always has — the evaluator's own sentence is the witness — and every message must now have an
// identity, a key, and both languages behind it

import Foundation
import Testing
import simd
@testable import Iris

@Suite("Readiness detail localization")
struct ReadinessDetailLocalizationTests {
    private let viewport = PlayfieldBounds.referencePhone
    private let nominal = NominalDisplayGeometry.estimate(viewport: .referencePhone, displayScale: 3, isPad: false)

    private func feed(_ evaluator: inout GazeReadinessEvaluator, frames: Int, point: Vector2 = Vector2(x: 195, y: 422),
                      wobble: Double = 2, eyeOrigin: SIMD3<Double> = SIMD3(0, 0, -0.35), eyeSeparation: Double = 0.063,
                      headWobble: Double = 0, hit: Bool = true, hasBlendShapes: Bool = true) {
        for frame in 0..<frames {
            let time = Double(frame) / 60
            let wobbled = Vector2(x: point.x + sin(Double(frame)) * wobble, y: point.y + cos(Double(frame)) * wobble)
            let origin = eyeOrigin + SIMD3(sin(Double(frame)) * headWobble, 0, 0)
            var sample = SimulatedGazeTrackingServiceProbe.makeSample(point: wobbled, viewport: viewport, nominal: nominal,
                                                                     timestamp: time, eyeOrigin: origin,
                                                                     eyeSeparation: eyeSeparation, hasBlendShapes: hasBlendShapes)
            if !hit {
                sample = RawGazeSample(timestamp: time, planeHit: nil, eyeOrigin: origin, eyeSeparation: eyeSeparation,
                                       userRight: SIMD2(1, 0), deviceUp: SIMD2(0, 1), faceUp: SIMD2(0, 1),
                                       blinkLeft: 0, blinkRight: 0, hasBlendShapes: hasBlendShapes)
            }
            evaluator.ingest(sample)
        }
    }

    private func report(_ evaluator: GazeReadinessEvaluator, supported: Bool = true, authorized: Bool = true,
                        state: GazeTrackingState = .tracking(faceVisible: true)) -> GazeReadinessReport {
        evaluator.report(supportsFaceTracking: supported, cameraAuthorized: authorized, trackingState: state,
                         nominal: nominal, viewport: viewport)
    }

    /// Every situation the evaluator can actually be in, and the reports they produce. This is the corpus the parity
    /// proof runs over — not a sample of it.
    private var everyReachableReport: [(label: String, report: GazeReadinessReport)] {
        var reports: [(String, GazeReadinessReport)] = []

        var ready = GazeReadinessEvaluator(); feed(&ready, frames: 72)
        reports.append(("everything passes", report(ready)))
        reports.append(("no face tracking", report(ready, supported: false)))
        reports.append(("camera refused", report(ready, authorized: false)))
        reports.append(("session interrupted", report(ready, state: .interrupted)))
        reports.append(("session unavailable", report(ready, state: .unavailable(.faceTrackingUnsupported))))
        reports.append(("session failed", report(ready, state: .failed(message: "boom"))))
        reports.append(("session starting", report(ready, state: .starting)))
        reports.append(("session idle", report(ready, state: .idle)))
        reports.append(("face not visible", report(ready, state: .tracking(faceVisible: false))))

        var few = GazeReadinessEvaluator(); feed(&few, frames: 4)
        reports.append(("not enough samples", report(few)))

        var tooClose = GazeReadinessEvaluator(); feed(&tooClose, frames: 72, eyeOrigin: SIMD3(0, 0, -0.10))
        reports.append(("too close", report(tooClose)))
        var tooFar = GazeReadinessEvaluator(); feed(&tooFar, frames: 72, eyeOrigin: SIMD3(0, 0, -0.95))
        reports.append(("too far", report(tooFar)))
        var farButValid = GazeReadinessEvaluator(); feed(&farButValid, frames: 72, eyeOrigin: SIMD3(0, 0, -0.62))
        reports.append(("another distance", report(farButValid)))

        var offScreen = GazeReadinessEvaluator(); feed(&offScreen, frames: 72, hit: false)
        reports.append(("gaze off the screen", report(offScreen)))
        var moving = GazeReadinessEvaluator(); feed(&moving, frames: 72, headWobble: 0.2)
        reports.append(("head moving", report(moving)))
        var jittery = GazeReadinessEvaluator(); feed(&jittery, frames: 72, wobble: 600)
        reports.append(("signal unsteady", report(jittery)))
        var noBlinks = GazeReadinessEvaluator(); feed(&noBlinks, frames: 72, hasBlendShapes: false)
        reports.append(("no blend shapes", report(noBlinks)))

        // A device held so that the axes cannot be agreed on: half the frames suggest one mapping, half another,
        // which is the only way the axis check stays pending once there are enough samples.
        var confused = GazeReadinessEvaluator()
        for frame in 0..<72 {
            let time = Double(frame) / 60
            let rotated = frame.isMultiple(of: 2)
            let sample = RawGazeSample(timestamp: time, planeHit: SIMD2(0, 0), eyeOrigin: SIMD3(0, 0, -0.35),
                                       eyeSeparation: 0.063,
                                       userRight: rotated ? SIMD2(1, 0) : SIMD2(0, 1),
                                       deviceUp: rotated ? SIMD2(0, 1) : SIMD2(-1, 0),
                                       faceUp: rotated ? SIMD2(0, 1) : SIMD2(-1, 0),
                                       blinkLeft: 0, blinkRight: 0, hasBlendShapes: true)
            confused.ingest(sample)
        }
        reports.append(("axes not agreed on", report(confused)))

        return reports.map { (label: $0.0, report: $0.1) }
    }

    // MARK: - The canonical registry

    @Test("A: twenty-five identities, each with its own key")
    func registryIsComplete() {
        #expect(ReadinessDetailID.allCases.count == 25)
        let keys = ReadinessDetailID.allCases.map(\.localizationKey)
        #expect(Set(keys).count == keys.count, "two identities share a key")
        for id in ReadinessDetailID.allCases {
            #expect(id.localizationKey == "gazeReadiness.detail.\(id.rawValue)")
            #expect(!GazeReadinessText.french(for: id).isEmpty, "\(id) has no French")
        }
    }

    @Test("B: every identity has a catalogue entry, and the catalogue holds no other readiness detail")
    func registryMatchesTheCatalogue() throws {
        let entries = try LocalizationCatalog.read(table: IrisText.interfaceTable)
        let catalogued = Set(entries.map(\.key).filter { $0.hasPrefix("gazeReadiness.detail.") })
        let expected = Set(ReadinessDetailID.allCases.map(\.localizationKey))
        #expect(catalogued == expected, "missing \(expected.subtracting(catalogued)), orphan \(catalogued.subtracting(expected))")
        for entry in entries where entry.key.hasPrefix("gazeReadiness.detail.") {
            #expect(!entry.french.isEmpty, "\(entry.key) has no French")
            let english = try #require(entry.english, "\(entry.key) has no English")
            #expect(!english.isEmpty)
            #expect(!entry.comment.isEmpty, "\(entry.key) gives a translator no context")
            #expect(entry.key != entry.french, "a sentence is being used as its own key")
        }
    }

    // MARK: - The French has not moved

    @Test("C: the French each message shows is the sentence the evaluator itself builds")
    func historicalDetailParity() throws {
        var seen: Set<ReadinessDetailID> = []
        var compared = 0
        for (label, report) in everyReachableReport {
            for check in report.checks {
                let reason = try #require(check.reason, "\(label)/\(check.kind) carries no identity")
                let detail = try #require(check.detail, "\(label)/\(check.kind) carries no sentence")
                let rebuilt = String(format: GazeReadinessText.french(for: reason.id),
                                     locale: Locale(identifier: "fr_FR"), arguments: reason.arguments)
                #expect(rebuilt == detail, "\(label)/\(check.kind): « \(rebuilt) » ≠ « \(detail) »")
                seen.insert(reason.id)
                compared += 1
            }
        }
        #expect(compared >= 150, "only \(compared) checks were compared")
        // Every identity the evaluator can reach was actually exercised, not assumed.
        let unreached = Set(ReadinessDetailID.allCases).subtracting(seen)
        #expect(unreached.isEmpty, "never produced by any situation: \(unreached.map(\.rawValue).sorted())")
    }

    @Test("D: the checks themselves are untouched — same kinds, same order, same count")
    func checksAreUnchanged() {
        let expectedOrder: [ReadinessCheckKind] = [.faceTracking, .cameraAccess, .session, .faceDetected,
                                                   .eyeTracking, .gazeDirection, .headStable, .signalStable,
                                                   .blinkDetection, .axisMapping]
        let waitingOrder: [ReadinessCheckKind] = [.faceTracking, .cameraAccess, .session, .faceDetected,
                                                  .eyeTracking, .gazeDirection, .headStable, .signalStable,
                                                  .blinkDetection, .axisMapping]
        for (label, report) in everyReachableReport {
            #expect(report.checks.count == 10, "\(label) produced \(report.checks.count) checks")
            let order = report.checks.map(\.kind)
            #expect(order == expectedOrder || order == waitingOrder, "\(label) reordered the checks: \(order)")
            #expect(Set(order).count == 10, "\(label) repeats a check")
        }
    }

    // MARK: - The two measured messages

    @Test("E: the measured messages carry values, not sentences")
    func dynamicMessagesCarryData() throws {
        var ready = GazeReadinessEvaluator(); feed(&ready, frames: 72)
        let result = report(ready)

        let eyes = try #require(result.checks.first { $0.kind == .eyeTracking })
        guard case let .faceDistance(centimetres) = try #require(eyes.reason) else {
            Issue.record("the distance message lost its measurement"); return
        }
        #expect(centimetres > 0)
        #expect(String(format: "Distance %.0f cm", centimetres) == eyes.detail)

        let axes = try #require(result.checks.first { $0.kind == .axisMapping })
        guard case let .axesResolved(right, up) = try #require(axes.reason) else {
            Issue.record("the axes message lost its mapping"); return
        }
        #expect(result.axisMapping?.right == right)
        #expect(result.axisMapping?.up == up)
        #expect(axes.detail?.contains(right.rawValue) == true)
        #expect(axes.detail?.contains(up.rawValue) == true)

        // The same identity, rendered in both languages, keeps the same numbers and the same axis names.
        for value in [15.0, 33.4, 44.5, 45.5, 61.0, 89.9] {
            let reason = ReadinessDetail.faceDistance(centimetres: value)
            let fr = String(format: GazeReadinessText.french(for: reason.id), locale: Locale(identifier: "fr_FR"),
                            arguments: reason.arguments)
            #expect(fr == String(format: "Distance %.0f cm", value), "\(value)")
        }
    }

    @Test("F: French and English declare the same placeholders")
    func placeholdersMatch() throws {
        func placeholders(_ text: String) -> [String] {
            text.matches(of: /%(?:\d+\$)?(@|lld|ld|d|\.0f|f)/).map { String($0.output.1) }
        }
        for entry in try LocalizationCatalog.read(table: IrisText.interfaceTable)
        where entry.key.hasPrefix("gazeReadiness.detail.") {
            let english = try #require(entry.english)
            #expect(placeholders(entry.french).sorted() == placeholders(english).sorted(),
                    "\(entry.key): \(placeholders(entry.french)) vs \(placeholders(english))")
        }
    }

    // MARK: - Both languages actually answer

    @Test("G: each language bundle answers for all twenty-five, and never with French in English")
    func bothBundlesAnswer() throws {
        func bundle(_ language: String) throws -> Bundle {
            let path = try #require(Bundle.main.path(forResource: language, ofType: "lproj"))
            return try #require(Bundle(path: path))
        }
        let french = try bundle("fr")
        let english = try bundle("en")
        let marker = "\u{0}"
        for id in ReadinessDetailID.allCases {
            let fr = french.localizedString(forKey: id.localizationKey, value: marker, table: IrisText.interfaceTable)
            let en = english.localizedString(forKey: id.localizationKey, value: marker, table: IrisText.interfaceTable)
            #expect(fr != marker, "fr.lproj has no \(id.localizationKey)")
            #expect(en != marker, "en.lproj has no \(id.localizationKey)")
            #expect(fr == GazeReadinessText.french(for: id), "fr/\(id.rawValue) answered « \(fr) »")
            let expectedEnglish = try #require(EnglishTranslationsEN5Readiness.byKey[id.localizationKey])
            #expect(en == expectedEnglish, "en/\(id.rawValue) answered « \(en) »")
            if !EnglishTranslationsEN5Readiness.identicalByDesign.contains(id.localizationKey) {
                #expect(en != fr, "en/\(id.rawValue) is still the French")
            }
            #expect(fr != id.localizationKey && en != id.localizationKey)
        }
    }

    // MARK: - The blocker cannot come back

    @Test("H: no readiness sentence can be written without an identity")
    func everySentenceHasAnIdentity() throws {
        let source = try String(contentsOf: LocalizationCatalog.projectRoot
            .appendingPathComponent("AR/Calibration/GazeReadinessEvaluator.swift"), encoding: .utf8)
        // Follow each ReadinessCheck( to its closing parenthesis and require a reason inside it.
        var calls = 0
        var index = source.startIndex
        while let found = source.range(of: "ReadinessCheck(", range: index..<source.endIndex) {
            var depth = 1
            var cursor = found.upperBound
            while depth > 0, cursor < source.endIndex {
                if source[cursor] == "(" { depth += 1 }
                if source[cursor] == ")" { depth -= 1 }
                cursor = source.index(after: cursor)
            }
            let call = String(source[found.upperBound..<cursor])
            #expect(call.contains("reason:"), "a ReadinessCheck is built without a reason: \(call.prefix(80))")
            calls += 1
            index = cursor
        }
        #expect(calls == 11, "\(calls) ReadinessCheck call sites, not 11")
    }

    @Test("I: the pairs the evaluator never produces are still never produced")
    func unreachablePairsStayUnreachable() {
        var produced: Set<String> = []
        for (_, report) in everyReachableReport {
            for check in report.checks { produced.insert("\(check.kind.rawValue).\(check.status)") }
        }
        let unreachable = ["faceTracking.pending", "cameraAccess.pending", "faceDetected.fail",
                           "headStable.fail", "signalStable.fail", "axisMapping.fail"]
        for pair in unreachable {
            #expect(!produced.contains(pair), "\(pair) became reachable")
        }
        #expect(unreachable.count == 6)
    }
}
