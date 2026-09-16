// GazeEdgeGuidanceTests.swift
// Layer: Tests
// Purpose: The halo says a side and only a side it can measure: nothing inside the playfield, the right edge or
// corner outside it, an intensity that grows with a real overshoot and saturates where the mapper stops measuring,
// and never a direction when the tracking has placed nothing

import Foundation
import Testing
@testable import Iris

@Suite("Out-of-bounds gaze guidance")
struct GazeEdgeGuidanceTests {
    private let bounds = PlayfieldBounds.referencePhone

    private func guidance(_ x: Double, _ y: Double) -> GazeEdgeGuidance? {
        GazeEdgeGuidance.from(point: Vector2(x: x, y: y), in: bounds)
    }

    @Test("inside the playfield there is nothing to point at")
    func inside() {
        #expect(guidance(bounds.width / 2, bounds.height / 2) == nil)
        #expect(guidance(1, 1) == nil)
        #expect(guidance(bounds.width - 1, bounds.height - 1) == nil)
        #expect(guidance(0, 0) == nil, "the very corner is still inside")
        #expect(guidance(bounds.width, bounds.height) == nil)
    }

    @Test("each side is named by the side the gaze actually left by")
    func sides() {
        #expect(guidance(-20, bounds.height / 2)?.direction == .left)
        #expect(guidance(bounds.width + 20, bounds.height / 2)?.direction == .right)
        #expect(guidance(bounds.width / 2, -20)?.direction == .top)
        #expect(guidance(bounds.width / 2, bounds.height + 20)?.direction == .bottom)
    }

    @Test("the four corners are named as corners, not as one side")
    func corners() {
        #expect(guidance(-20, -20)?.direction == .topLeft)
        #expect(guidance(bounds.width + 20, -20)?.direction == .topRight)
        #expect(guidance(-20, bounds.height + 20)?.direction == .bottomLeft)
        #expect(guidance(bounds.width + 20, bounds.height + 20)?.direction == .bottomRight)
    }

    @Test("a larger measured overshoot is never weaker than a smaller one")
    func intensityGrows() throws {
        let near = try #require(guidance(-10, bounds.height / 2))
        let far = try #require(guidance(-120, bounds.height / 2))
        #expect(far.intensity >= near.intensity)
        #expect(far.intensity > near.intensity, "a real difference in overshoot should be visible")
        #expect(near.intensity > 0)
    }

    @Test("the intensity saturates exactly where the pipeline stops measuring, and never claims more")
    func intensitySaturates() throws {
        // The mapper clamps at half a viewport beyond the edge; the halo must read 1 there, and still 1 past it.
        let atClamp = try #require(guidance(-bounds.width * GazeEdgeGuidance.measurableOvershoot, bounds.height / 2))
        #expect(atClamp.intensity == 1)
        let beyond = try #require(guidance(-bounds.width * 5, bounds.height / 2))
        #expect(beyond.intensity == 1, "beyond the clamp Iris knows no more, so it must not say more")
        #expect(GazeEdgeGuidance.measurableOvershoot == 0.5, "this must match GazeMapper.overshoot")
    }

    @Test("a corner takes the stronger of its two overshoots")
    func cornerIntensity() throws {
        let barelyLeftFarUp = try #require(guidance(-4, -bounds.height * 0.4))
        #expect(barelyLeftFarUp.direction == .topLeft)
        let shallow = try #require(guidance(-4, -4))
        #expect(barelyLeftFarUp.intensity > shallow.intensity)
    }

    @Test("without a placed cursor the snapshot claims no direction at all")
    func noTrackingNoClaim() throws {
        let level = try #require(Campaign.level(id: "1-1"))
        let resolved = LevelResolver.resolve(level, in: .referencePhone)
        let session = resolved.makeSession()
        // A fresh session has never ingested a gaze sample: `isActive` is false.
        #expect(!session.gaze.isActive)
        let snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, marker: .shown, diagnostics: nil)
        #expect(snapshot.edgeGuidance == nil, "an unplaced cursor must not produce a direction")
    }

    @Test("with a placed cursor outside the field the snapshot carries the direction; inside it carries none")
    func snapshotCarriesGuidance() throws {
        let level = try #require(Campaign.level(id: "1-1"))
        let resolved = LevelResolver.resolve(level, in: .referencePhone)
        var outside = resolved.makeSession()
        outside.placeGaze(at: Vector2(x: -60, y: -60))
        let outsideSnapshot = GameSceneSnapshot(session: outside, resolved: resolved, showsRoute: false, marker: .shown, diagnostics: nil)
        #expect(outsideSnapshot.edgeGuidance?.direction == .topLeft)

        var inside = resolved.makeSession()
        inside.placeGaze(at: Vector2(x: 100, y: 100))
        let insideSnapshot = GameSceneSnapshot(session: inside, resolved: resolved, showsRoute: false, marker: .shown, diagnostics: nil)
        #expect(insideSnapshot.edgeGuidance == nil)
    }

    @Test("the classic mode hides the marker yet still allows the halo")
    func haloSurvivesClassic() throws {
        let level = try #require(Campaign.level(id: "4-2"))
        let resolved = LevelResolver.resolve(level, in: .referencePhone)
        var session = resolved.makeSession()
        session.placeGaze(at: Vector2(x: -60, y: 200))
        let marker = GazeAssistancePolicy.presentation(mode: .classic, levelID: "4-2", hasCompletedLearning: true, activePlayTime: 3)
        let snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false, marker: marker, diagnostics: nil)

        #expect(snapshot.gaze == nil, "classic keeps the marker hidden")
        #expect(snapshot.gazeMarkerOpacity == 0)
        #expect(snapshot.edgeGuidance?.direction == .left, "but the halo still says which way the gaze went")
    }

    @Test("every direction has a place to sit on the screen, corners included")
    func everyDirectionHasAnAnchor() {
        let frame = CGRect(x: 0, y: 0, width: 400, height: 800)
        var anchors: Set<String> = []
        for direction in GazeEdgeGuidance.Direction.allCases {
            let anchor = GameSceneRenderer.haloAnchor(direction, in: frame)
            #expect(frame.contains(anchor) || frame.insetBy(dx: -1, dy: -1).contains(anchor))
            anchors.insert("\(anchor.x),\(anchor.y)")
        }
        #expect(GazeEdgeGuidance.Direction.allCases.count == 8)
        #expect(anchors.count == 8, "each direction must point somewhere of its own")
    }

    @Test("the halo carries no motion of its own, so Reduce Motion loses no information")
    func reduceMotionKeepsTheInformation() throws {
        let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()
            .deletingLastPathComponent().deletingLastPathComponent()
        let renderer = try String(contentsOf: root.appendingPathComponent("Features/Game/Rendering/GameSceneRenderer.swift"), encoding: .utf8)
        guard let halo = renderer.range(of: "private func drawEdgeHalo") else {
            Issue.record("the halo is gone"); return
        }
        let body = String(renderer[halo.lowerBound...].prefix(700))
        for animated in ["sin(", "cos(", "time", "phase", "repeatForever", "withAnimation"] {
            #expect(!body.contains(animated), "the halo animates with \(animated); Reduce Motion would lose it")
        }
        // Its strength comes from the measured overshoot alone.
        #expect(body.contains("guidance.intensity"))
    }
}
