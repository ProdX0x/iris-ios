// AncreSceneTests.swift
// Layer: Tests
// Purpose: Chapter X final « l'ancre », the scene: the silhouette traced from the reference image is framed around the
// point; the scene follows the fixations and the circles; during a circle nothing drawn depends on the gaze (point,
// ring, bars and head light stay identical whatever the gaze does, and no gaze mark is drawn); the DEBUG trace and
// capture call the gaze ignored during a circle, even outside the screen; control images render every moment (PNG
// files when IRIS_SNAPSHOT_DIR is set, plus an overlay on the reference image when it is present)

import Foundation
import SwiftUI
import Testing
import UIKit
@testable import Iris

@Suite("Chapter X final: ancre scene")
@MainActor
struct AncreSceneTests {
    private typealias Support = OculoStageTestSupport
    private var level: LevelDefinition { Campaign.finalGouffres }
    private static let outside = Vector2(x: -150, y: 1_200)

    private static var projectRoot: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
    }

    /// Plays the level: the eyes on the point unless `gaze` decides, the oracle's head unless `head` does; stops when
    /// `done` holds, the level completes or `frames` pass.
    private static func drive(_ session: inout GameSession, frames: Int = 60 * 90, gaze: ((GameSession, Int) -> Vector2)? = nil,
                              head: HeadPose? = nil, until done: (GameSession) -> Bool = { _ in false }) {
        for index in 0..<frames {
            if done(session) || session.isComplete { return }
            let ideal = session.oculo.flatMap { $0.isComplete ? nil : $0.suggestedGaze(at: session.elapsed) } ?? Vector2(x: 30, y: 830)
            session.placeGaze(at: gaze?(session, index) ?? ideal)
            session.ingestHeadPose(head ?? session.oculo?.suggestedHead ?? .neutral)
            _ = session.advance(by: Support.frame)
        }
    }

    private static func loop(_ session: GameSession) -> AncreStageState? {
        if case let .ancre(state)? = session.oculo?.current { return state }
        return nil
    }

    private static func isCircling(_ session: GameSession) -> Bool {
        (loop(session)?.isHeadOnly ?? false) && session.oculo?.isBreathing == false
    }

    /// Far off screen, jumping every frame, while the head alone counts; on the point otherwise.
    private static func wildGaze(_ session: GameSession, _ index: Int) -> Vector2 {
        guard isCircling(session) else { return session.oculo?.suggestedGaze(at: session.elapsed) ?? Vector2(x: 30, y: 830) }
        return Vector2(x: index.isMultiple(of: 2) ? -400 : 900, y: Double(index % 5) * 400 - 600)
    }

    private func scene(_ session: GameSession, _ resolved: ResolvedLevel) -> AncreSceneSnapshot? {
        GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, marker: .hidden, diagnostics: nil).oculo?.ancre
    }

    @Test("the silhouette is symmetric and framed on the phone around the point, clear of the top bar and of the hint, with the ring inside the face")
    func silhouette() throws {
        let contour = AncreSilhouette.headContour
        for point in AncreSilhouette.headRight {
            let mirrored = contour.contains { abs($0.x + point.x) < 1e-9 && abs($0.y - point.y) < 1e-9 }
            #expect(mirrored, "\(point)")
        }
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        guard case let .ancre(state)? = resolved.environment.oculo?.current else {
            Issue.record("no ancre loop")
            return
        }
        let face = CGFloat(state.ringRadius * AncreSceneSnapshot.faceScale)
        let center = CGPoint(x: state.anchor.x, y: state.anchor.y)
        let head = AncreSilhouette.headPath(center: center, scale: face).boundingRect
        let right = AncreSilhouette.shoulderPath(center: center, scale: face, mirrored: false).boundingRect
        let left = AncreSilhouette.shoulderPath(center: center, scale: face, mirrored: true).boundingRect
        let whole = head.union(right).union(left)
        #expect(whole.minX >= 8 && whole.maxX <= Support.bounds.width - 8, "\(whole)")
        #expect(whole.minY >= 120 && whole.maxY <= Support.bounds.height - 150, "\(whole)")
        #expect(abs(head.midX - center.x) < 0.5, "centred on the point")
        #expect(head.width > 2 * state.ringRadius + 30, "the ring sits inside the face")
    }

    @Test("the scene follows the loops: a fixation where the gaze decides, a circle where only the head does, stardust in the breath, the re-fixation, the closing fixation, the end")
    func sceneFollowsLoops() throws {
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        var session = resolved.makeSession(noiseSources: [SilentNoise()])
        Self.drive(&session, frames: 10)
        let fixating = try #require(scene(session, resolved))
        #expect(fixating.phase == .fixating && fixating.gazeIsCriterion && !fixating.isHeadOnly && fixating.litSweep == 0 && fixating.head == nil)
        #expect(fixating.loop == 0 && fixating.loopCount == 2 && abs(fixating.startAngle) < 1e-9 && fixating.screenTurn == -1)
        #expect(fixating.checkpoints.count == 4 && !fixating.checkpoints.contains(where: \.isReached))
        #expect(abs(sin(fixating.checkpoints[1].angle) + 1) < 1e-9, "the first loop's second checkpoint is at the top of the screen")

        Self.drive(&session, until: { (Self.loop($0)?.sweep ?? 0) >= 100 })
        let circling = try #require(scene(session, resolved))
        let head = try #require(circling.head)
        #expect(circling.phase == .circling && circling.isHeadOnly && !circling.gazeIsCriterion && !circling.gazeOnPoint)
        #expect(circling.checkpoints.filter(\.isReached).count == 2 && circling.checkpoints[2].isNext)
        #expect(head.length >= 1 && head.y < 0, "past the top-right, the head lights the ring's upper half")
        let lit = (0..<AncreSceneSnapshot.barCount).filter { index in
            circling.loopDegrees(atScreenAngle: 2 * Double.pi * Double(index) / Double(AncreSceneSnapshot.barCount)) <= circling.litSweep
        }.count
        #expect((19...23).contains(lit), "\(lit) bars lit for \(circling.litSweep)°")

        Self.drive(&session, until: { $0.oculo?.isBreathing == true })
        Self.drive(&session, frames: 30)
        let breath = try #require(scene(session, resolved))
        let stardust = try #require(breath.stardust)
        #expect(stardust > 0 && stardust < 1 && breath.loop == 1 && abs(cos(breath.startAngle) + 1) < 1e-9 && breath.screenTurn == 1)
        #expect(breath.phase == .fixating, "the next loop waits for its re-fixation")

        Self.drive(&session, until: { $0.oculo?.currentIndex == 1 && Self.loop($0)?.phase == .refixating })
        let closing = try #require(scene(session, resolved))
        #expect(closing.phase == .refixating && closing.gazeIsCriterion && !closing.isHeadOnly && closing.litSweep == 360)

        Self.drive(&session, until: { $0.oculo?.isComplete == true })
        Self.drive(&session, frames: 30)
        let end = try #require(scene(session, resolved))
        #expect(end.phase == .done && end.ringOpacity == 0 && end.stardust != nil)
    }

    @Test("K: gaze coordinates swinging far off screen during the circles change nothing drawn: point, ring, bars, head light and every scene value stay identical, and no gaze mark is drawn")
    func gazeChangesNothingDuringCircles() throws {
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        var steady = resolved.makeSession(noiseSources: [SilentNoise()])
        var wild = resolved.makeSession(noiseSources: [SilentNoise()])
        let start = try #require(scene(steady, resolved))
        var headOnlyFrames = 0
        var mismatches = 0
        var moved = 0
        var marked = 0
        for _ in 0..<(60 * 60) {
            Self.drive(&steady, frames: 1)
            Self.drive(&wild, frames: 1, gaze: Self.wildGaze)
            guard let a = scene(steady, resolved), let b = scene(wild, resolved) else { break }
            if a != b { mismatches += 1 }
            if b.center != start.center || b.ringRadius != start.ringRadius { moved += 1 }
            if b.isHeadOnly {
                headOnlyFrames += 1
                let snapshot = GameSceneSnapshot(session: wild, resolved: resolved, showsRoute: false, marker: .shown,
                                                 diagnostics: GazeDiagnostics(raw: wild.gaze.position, calibrated: wild.gaze.position))
                if snapshot.gaze != nil || snapshot.diagnostics != nil { marked += 1 }
            }
            if steady.oculo?.isComplete == true { break }
        }
        #expect(headOnlyFrames > 600 && mismatches == 0 && moved == 0 && marked == 0,
                "head-only frames \(headOnlyFrames), scene mismatches \(mismatches), moves \(moved), gaze marks \(marked)")
        let fresh = resolved.makeSession(noiseSources: [SilentNoise()])
        let fixation = GameSceneSnapshot(session: fresh, resolved: resolved, showsRoute: false, marker: .shown, diagnostics: GazeDiagnostics(raw: fresh.gaze.position))
        #expect(fixation.gaze != nil && fixation.diagnostics != nil, "during a fixation the gaze mark is drawn as before")
    }

    @Test("the DEBUG trace calls the gaze ignored during a circle even outside the screen, criterion during a fixation, and never logs a miss")
    func traceLabelsGazeRole() {
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        var session = resolved.makeSession(noiseSources: [SilentNoise()])
        let trace = OculomotorTrace(names: ["stage1", "stage2"])
        var sweeps: [Double] = []
        for index in 0..<(60 * 20) {
            let circling = Self.isCircling(session)
            let ideal = session.oculo?.suggestedGaze(at: session.elapsed) ?? Vector2(x: 30, y: 830)
            let gaze = circling ? Self.outside : ideal
            session.placeGaze(at: gaze)
            session.ingestHeadPose(session.oculo?.suggestedHead ?? .neutral)
            let events = session.advance(by: Support.frame)
            let sample = RawGazeSample(timestamp: Double(index) * Support.frame, planeHit: nil, eyeOrigin: .zero, eyeSeparation: 0.06,
                                       userRight: SIMD2(1, 0), deviceUp: SIMD2(0, 1), faceUp: SIMD2(0, 1), blinkLeft: 0, blinkRight: 0, hasBlendShapes: false)
            trace.observeSample(mapped: gaze, sample: sample, bounds: Support.bounds)
            trace.observeTick(session: session, events: events)
            if circling, let state = Self.loop(session), state.phase == .circling { sweeps.append(state.sweep) }
            if session.oculo?.currentIndex == 1 { break }
        }
        let lines = trace.lines.filter { $0.contains("ancre") }
        let outsideIgnored = lines.contains { $0.contains("gazeState=VALID_OUTSIDE") && $0.contains("gaze=ignored") && $0.contains("the circle goes on") }
        let fixationCriterion = lines.contains { $0.contains("phase=fixating") && $0.contains("gaze=criterion") }
        let anyMiss = trace.lines.contains { $0.contains(" miss ") }
        #expect(outsideIgnored && fixationCriterion && !anyMiss)
        #expect((sweeps.last ?? 0) > (sweeps.first ?? 0) + 200, "the sweep kept growing while the gaze was outside")
    }

    #if DEBUG
    @Test("the DEBUG capture writes gazeState VALID_OUTSIDE next to a growing sweep with the gaze role ignored, criterion during the fixation, and no eyes-left event")
    func captureShowsOutsideGazeWithProgress() throws {
        let capture = try #require(AncreCapture(level: level, requested: true))
        defer { try? FileManager.default.removeItem(at: capture.url) }
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        var session = resolved.makeSession(noiseSources: [SilentNoise()])
        for index in 0..<(60 * 20) {
            let circling = Self.isCircling(session)
            let ideal = session.oculo?.suggestedGaze(at: session.elapsed) ?? Vector2(x: 30, y: 830)
            let gaze = circling ? Self.outside : ideal
            session.placeGaze(at: gaze)
            session.ingestHeadPose(session.oculo?.suggestedHead ?? .neutral)
            let events = session.advance(by: Support.frame)
            capture.observeSample(session: session, phase: .playing, faceTracked: true, observation: nil, screenHead: session.headPose, mapped: gaze,
                                  gazeState: circling ? "VALID_OUTSIDE" : "VALID_INSIDE", bounds: Support.bounds, timestamp: Double(index) * Support.frame)
            capture.observeTick(session: session, phase: .playing, events: events)
            if session.oculo?.currentIndex == 1 { break }
        }
        capture.stop(reason: "test")
        capture.waitForWrites()
        let text = try String(contentsOf: capture.url, encoding: .utf8)
        let records = text.split(separator: "\n").compactMap { line -> [String: Any]? in
            (try? JSONSerialization.jsonObject(with: Data(line.utf8))) as? [String: Any]
        }
        let circlingSamples = records.filter { ($0["loopPhase"] as? String) == "circling" && ($0["kind"] as? String) == "sample" }
        let allOutsideIgnored = circlingSamples.allSatisfy { ($0["gazeState"] as? String) == "VALID_OUTSIDE" && ($0["gazeRole"] as? String) == "ignored" }
        let sweeps = circlingSamples.compactMap { $0["sweepDeg"] as? Double }
        let fixationCriterion = records.contains { ($0["loopPhase"] as? String) == "fixating" && ($0["gazeRole"] as? String) == "criterion" }
        let events = records.compactMap { $0["event"] as? String }
        #expect(!circlingSamples.isEmpty && allOutsideIgnored && fixationCriterion)
        #expect((sweeps.last ?? 0) > (sweeps.first ?? 0) + 200, "sweep \(sweeps.first ?? -1) to \(sweeps.last ?? -1)")
        #expect(events.contains("fixationAcquired") && events.contains("loopCompleted") && !events.contains("eyesLeftPoint"))
    }
    #endif

    @Test("control images: every moment of the level renders on a phone (PNG files when IRIS_SNAPSHOT_DIR is set)")
    func controlImages() throws {
        let chapter = try #require(Campaign.chapter(number: 10))
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        var session = resolved.makeSession(noiseSources: [SilentNoise()])
        var moments: [(String, GameSceneSnapshot)] = []
        func capture(_ name: String) {
            moments.append((name, GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, marker: .hidden, diagnostics: nil,
                                                    theme: chapter.theme)))
        }
        Self.drive(&session, frames: 30)
        capture("1-fixation")
        Self.drive(&session, until: { Self.loop($0)?.phase == .seeking })
        Self.drive(&session, frames: 150, head: .neutral)
        capture("2-demonstration")
        Self.drive(&session, gaze: Self.wildGaze, until: { (Self.loop($0)?.sweep ?? 0) >= 95 })
        capture("3-loop1-quarter-gaze-away")
        Self.drive(&session, gaze: Self.wildGaze, until: { (Self.loop($0)?.sweep ?? 0) >= 250 })
        capture("4-loop1-three-quarters")
        Self.drive(&session, until: { Self.loop($0)?.phase == .returning })
        capture("5-loop1-returning")
        Self.drive(&session, until: { $0.oculo?.isBreathing == true })
        Self.drive(&session, frames: 45)
        capture("6-breath-stardust")
        Self.drive(&session, until: { $0.oculo?.currentIndex == 1 && $0.oculo?.isBreathing == false })
        Self.drive(&session, frames: 25)
        capture("7-loop2-refixation")
        Self.drive(&session, gaze: Self.wildGaze, until: { $0.oculo?.currentIndex == 1 && (Self.loop($0)?.sweep ?? 0) >= 180 })
        #expect(session.oculo?.currentIndex == 1 && (Self.loop(session)?.sweep ?? 0) >= 180)
        capture("8-loop2-half")
        Self.drive(&session, until: { $0.oculo?.currentIndex == 1 && Self.loop($0)?.phase == .refixating })
        Self.drive(&session, frames: 20)
        capture("9-closing-fixation")
        Self.drive(&session, until: { $0.oculo?.isComplete == true })
        #expect(session.oculo?.isComplete == true)
        Self.drive(&session, frames: 40)
        capture("10-completion")
        #expect(moments.count == 10)

        let directory = ProcessInfo.processInfo.environment["IRIS_SNAPSHOT_DIR"].map { URL(fileURLWithPath: $0, isDirectory: true) }
        for (name, snapshot) in moments {
            let content = ZStack {
                DSBackground()
                GameCanvasView(snapshot: snapshot, reduceMotion: false)
            }
            .frame(width: Support.bounds.width, height: Support.bounds.height)
            let renderer = ImageRenderer(content: content)
            renderer.scale = 2
            let image = try #require(renderer.uiImage, "\(name)")
            #expect(abs(image.size.width - Support.bounds.width) < 0.5, "\(name)")
            if let directory, let data = image.pngData() {
                try data.write(to: directory.appendingPathComponent("x7-\(name).png"))
            }
        }
    }

    @Test("the silhouette follows the reference image: an overlay is written when IRIS_SNAPSHOT_DIR is set and the reference is present")
    func referenceOverlay() throws {
        let path = Self.projectRoot.appendingPathComponent("x7_silhouette_reference.png").path
        guard let directory = ProcessInfo.processInfo.environment["IRIS_SNAPSHOT_DIR"], let reference = UIImage(contentsOfFile: path) else { return }
        // Measured on the reference: a face half-width of 279.5 px around (470.5, 700), on 941 × 1672 px.
        let size = CGSize(width: 941, height: 1672)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let image = UIGraphicsImageRenderer(size: size, format: format).image { context in
            reference.draw(in: CGRect(origin: .zero, size: size))
            let center = CGPoint(x: 470.5, y: 700)
            let cg = context.cgContext
            cg.setStrokeColor(UIColor.systemRed.cgColor)
            cg.setLineWidth(2)
            cg.addPath(AncreSilhouette.headPath(center: center, scale: 279.5).cgPath)
            cg.addPath(AncreSilhouette.shoulderPath(center: center, scale: 279.5, mirrored: false).cgPath)
            cg.addPath(AncreSilhouette.shoulderPath(center: center, scale: 279.5, mirrored: true).cgPath)
            cg.strokePath()
        }
        let data = try #require(image.pngData())
        try data.write(to: URL(fileURLWithPath: directory, isDirectory: true).appendingPathComponent("x7-reference-overlay.png"))
    }
}
