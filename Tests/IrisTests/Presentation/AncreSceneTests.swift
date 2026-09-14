// AncreSceneTests.swift
// Layer: Tests
// Purpose: Chapter X final « l'ancre », the scene: the silhouette traced from the reference image is symmetric and
// framed on the phone around the point; the scene description follows the loops (ring lit with the sweep,
// checkpoints, the head's direction, stardust in the breath and after the last loop); control images of each moment
// render on a phone (PNG files when IRIS_SNAPSHOT_DIR is set, plus an overlay on the reference image when present)

import SwiftUI
import Testing
import UIKit
@testable import Iris

@Suite("Chapter X final: ancre scene")
@MainActor
struct AncreSceneTests {
    private typealias Support = OculoStageTestSupport
    private var level: LevelDefinition { Campaign.finalGouffres }

    private static var projectRoot: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
    }

    /// Plays the level with the ideal player (eyes on the point, the oracle's head unless `head` says otherwise) until
    /// `done` holds, the level completes or `frames` pass.
    private static func drive(_ session: inout GameSession, frames: Int = 60 * 90, gaze: Vector2? = nil, head: HeadPose? = nil,
                              until done: (GameSession) -> Bool = { _ in false }) {
        for _ in 0..<frames {
            if done(session) || session.isComplete { return }
            let ideal = session.oculo.flatMap { $0.isComplete ? nil : $0.suggestedGaze(at: session.elapsed) } ?? Vector2(x: 30, y: 830)
            session.placeGaze(at: gaze ?? ideal)
            session.ingestHeadPose(head ?? session.oculo?.suggestedHead ?? .neutral)
            _ = session.advance(by: Support.frame)
        }
    }

    private static func loop(_ session: GameSession) -> AncreStageState? {
        if case let .ancre(state)? = session.oculo?.current { return state }
        return nil
    }

    private func scene(_ session: GameSession, _ resolved: ResolvedLevel) -> AncreSceneSnapshot? {
        GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, showsGaze: false, diagnostics: nil).oculo?.ancre
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

    @Test("the scene follows the loops: settling, a ring lit with the sweep and its checkpoints, the head's direction, stardust in the breath and after the last loop")
    func sceneFollowsLoops() throws {
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        var session = resolved.makeSession(noiseSources: [SilentNoise()])
        Self.drive(&session, frames: 10)
        let settling = try #require(scene(session, resolved))
        #expect(settling.phase == .settling && settling.litSweep == 0 && settling.head == nil && settling.stardust == nil)
        #expect(settling.loop == 0 && settling.loopCount == 2 && abs(settling.startAngle) < 1e-9 && settling.screenTurn == -1)
        #expect(settling.checkpoints.count == 4 && !settling.checkpoints.contains(where: \.isReached))
        #expect(abs(sin(settling.checkpoints[1].angle) + 1) < 1e-9, "the first loop's second checkpoint is at the top of the screen")

        Self.drive(&session, until: { (Self.loop($0)?.sweep ?? 0) >= 100 })
        let circling = try #require(scene(session, resolved))
        let head = try #require(circling.head)
        #expect(circling.phase == .circling && abs(circling.litSweep - (Self.loop(session)?.sweep ?? 0)) < 1e-9)
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

        Self.drive(&session, until: { $0.oculo?.isComplete == true })
        Self.drive(&session, frames: 30)
        let end = try #require(scene(session, resolved))
        #expect(end.phase == .done && end.ringOpacity == 0 && end.stardust != nil)
    }

    @Test("control images: every moment of the level renders on a phone (PNG files when IRIS_SNAPSHOT_DIR is set)")
    func controlImages() throws {
        let chapter = try #require(Campaign.chapter(number: 10))
        let resolved = LevelResolver.resolve(level, in: Support.bounds)
        var session = resolved.makeSession(noiseSources: [SilentNoise()])
        var moments: [(String, GameSceneSnapshot)] = []
        func capture(_ name: String) {
            moments.append((name, GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, showsGaze: false, diagnostics: nil,
                                                    theme: chapter.theme)))
        }
        Self.drive(&session, frames: 30)
        capture("1-settling")
        Self.drive(&session, until: { Self.loop($0)?.phase == .seeking })
        Self.drive(&session, frames: 150, head: .neutral)
        capture("2-demonstration")
        Self.drive(&session, until: { (Self.loop($0)?.sweep ?? 0) >= 95 })
        capture("3-loop1-quarter")
        Self.drive(&session, until: { (Self.loop($0)?.sweep ?? 0) >= 250 })
        capture("4-loop1-three-quarters")
        Self.drive(&session, until: { Self.loop($0)?.phase == .returning })
        capture("5-loop1-returning")
        Self.drive(&session, until: { $0.oculo?.isBreathing == true })
        Self.drive(&session, frames: 45)
        capture("6-breath-stardust")
        Self.drive(&session, until: { ($0.oculo?.currentIndex ?? 0) == 1 && (Self.loop($0)?.sweep ?? 0) >= 60 })
        capture("7-loop2-start")
        Self.drive(&session, frames: 40, gaze: Vector2(x: 30, y: 830))
        capture("8-loop2-look-away")
        Self.drive(&session, until: { ($0.oculo?.currentIndex ?? 0) == 1 && (Self.loop($0)?.sweep ?? 0) >= 200 })
        #expect(session.oculo?.currentIndex == 1 && (Self.loop(session)?.sweep ?? 0) >= 200, "the ideal player resumes after looking away")
        capture("9-loop2-two-thirds")
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
