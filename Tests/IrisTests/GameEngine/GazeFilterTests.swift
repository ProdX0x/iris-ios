// GazeFilterTests.swift
// Layer: Tests
// Purpose: R-13 exponential smoothing and sustained-jump gating of the reference gaze listener

import Foundation
import Testing
@testable import Iris

@Suite("GazeFilter")
struct GazeFilterTests {
    @Test("the first sample activates the filter and moves 10 percent of the way")
    func firstSample() {
        var filter = GazeFilter(initialPosition: Vector2(x: 0, y: 0))

        let accepted = filter.ingest(Vector2(x: 100, y: 0))

        #expect(accepted)
        #expect(filter.isActive)
        #expect(abs(filter.position.x - 10) < 1e-12)
    }

    @Test("repeated samples converge exponentially (alpha 0.1)")
    func convergence() {
        var filter = GazeFilter(initialPosition: .zero)
        for _ in 0..<60 { filter.ingest(Vector2(x: 100, y: 50)) }

        let expected = 100 * (1 - pow(0.9, 60.0))
        #expect(abs(filter.position.x - expected) < 1e-9)
        #expect(abs(filter.position.y - expected / 2) < 1e-9)
    }

    @Test("an isolated big jump (blink) is ignored twice, the third consecutive one is trusted")
    func jumpGating() {
        var filter = GazeFilter(initialPosition: .zero)
        filter.ingest(Vector2(x: 0, y: 0))

        let first = filter.ingest(Vector2(x: 500, y: 0))
        #expect(first == false)
        #expect(filter.position.x == 0)
        let second = filter.ingest(Vector2(x: 500, y: 0))
        #expect(second == false)
        let third = filter.ingest(Vector2(x: 500, y: 0))
        #expect(third == true)
        #expect(abs(filter.position.x - 50) < 1e-12)
    }

    @Test("a small sample between jumps resets the jump counter")
    func jumpCounterReset() {
        var filter = GazeFilter(initialPosition: .zero)
        filter.ingest(.zero)

        let jump = filter.ingest(Vector2(x: 500, y: 0))
        let small = filter.ingest(Vector2(x: 1, y: 0))
        let jumpAgain = filter.ingest(Vector2(x: 500, y: 0))
        let secondJump = filter.ingest(Vector2(x: 500, y: 0))

        #expect(jump == false)
        #expect(small == true)
        #expect(jumpAgain == false)
        #expect(secondJump == false)
    }

    @Test("jumps are never gated before the filter is active")
    func inactiveFilterAcceptsJumps() {
        var filter = GazeFilter(initialPosition: .zero)

        let accepted = filter.ingest(Vector2(x: 900, y: 900))

        #expect(accepted)
    }

    @Test("placing the cursor bypasses smoothing")
    func placement() {
        var filter = GazeFilter(initialPosition: .zero)

        filter.place(at: Vector2(x: 42, y: 24))

        #expect(filter.position == Vector2(x: 42, y: 24))
        #expect(filter.isActive)
    }
}
