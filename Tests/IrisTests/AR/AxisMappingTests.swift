// AxisMappingTests.swift
// Layer: Tests
// Purpose: Axis resolution from the eye line and gravity, including the "phone flipped 180 degrees" case

import Foundation
import Testing
import simd
@testable import Iris

@Suite("AxisMapping")
struct AxisMappingTests {
    @Test("standard frame: user right along +x and gravity up along +y")
    func standard() {
        let mapping = AxisResolver.resolve(userRight: SIMD2(1, 0), deviceUp: SIMD2(0, 1), faceUp: SIMD2(0, 1))

        #expect(mapping == .standard)
        #expect(mapping?.isRightHanded == true)
    }

    @Test("a frame rotated 180 degrees (phone upside down) maps right to -x and up to -y")
    func rotated180() {
        let mapping = AxisResolver.resolve(userRight: SIMD2(-0.98, 0.1), deviceUp: SIMD2(0.05, -0.9), faceUp: SIMD2(0, -1))

        #expect(mapping == AxisMapping(right: .negativeX, up: .negativeY))
    }

    @Test("a mirrored frame (right along -x, up along +y) is resolved and flagged left-handed")
    func mirrored() {
        let mapping = AxisResolver.resolve(userRight: SIMD2(-1, 0), deviceUp: SIMD2(0, 1), faceUp: SIMD2(0, 1))

        #expect(mapping == AxisMapping(right: .negativeX, up: .positiveY))
        #expect(mapping?.isRightHanded == false)
    }

    @Test("a frame rotated 90 degrees maps right to a y axis")
    func rotated90() {
        let mapping = AxisResolver.resolve(userRight: SIMD2(0, 1), deviceUp: SIMD2(-1, 0), faceUp: SIMD2(-1, 0))

        #expect(mapping == AxisMapping(right: .positiveY, up: .negativeX))
    }

    @Test("gravity is used when available, the face fallback when the device lies flat")
    func gravityFallback() {
        let gravity = AxisResolver.resolve(userRight: SIMD2(1, 0), deviceUp: SIMD2(0, -1), faceUp: SIMD2(0, 1))
        let flat = AxisResolver.resolve(userRight: SIMD2(1, 0), deviceUp: SIMD2(0.01, -0.02), faceUp: SIMD2(0, 1))

        #expect(gravity == AxisMapping(right: .positiveX, up: .negativeY))
        #expect(flat == .standard)
    }

    @Test("degenerate or conflicting directions give no mapping")
    func degenerate() {
        #expect(AxisResolver.resolve(userRight: SIMD2(0.01, 0), deviceUp: SIMD2(0, 1), faceUp: SIMD2(0, 1)) == nil)
        #expect(AxisResolver.resolve(userRight: SIMD2(1, 0), deviceUp: SIMD2(1, 0.1), faceUp: SIMD2(1, 0)) == nil, "both on x")
        #expect(AxisResolver.resolve(userRight: SIMD2(.nan, 0), deviceUp: SIMD2(0, 1), faceUp: SIMD2(0, 1)) == nil)
    }

    @Test("screen coordinates and plane points are inverses for every mapping")
    func roundTrip() {
        for right in DeviceAxis.allCases {
            for up in DeviceAxis.allCases where up.isHorizontal != right.isHorizontal {
                let mapping = AxisMapping(right: right, up: up)
                let plane = mapping.planePoint(right: 0.02, up: -0.05)
                let back = mapping.screenCoordinates(of: plane)

                #expect(abs(back.x - 0.02) < 1e-12)
                #expect(abs(back.y - (-0.05)) < 1e-12)
            }
        }
    }

    @Test("votes pick the majority and report confidence")
    func voting() {
        var vote = AxisVote()
        for _ in 0..<9 { vote.add(.standard) }
        vote.add(AxisMapping(right: .negativeX, up: .negativeY))

        #expect(vote.majority == .standard)
        #expect(abs(vote.confidence - 0.9) < 1e-12)
        #expect(vote.total == 10)
        vote.reset()
        #expect(vote.majority == nil)
        #expect(vote.confidence == 0)
    }
}
