// FixationSequenceTests.swift
// Layer: Tests
// Purpose: Time-based fixation protocol: settling, collection, blink exclusion, retry, completion and failure

import Foundation
import Testing
import simd
@testable import Iris

@Suite("FixationSequence")
struct FixationSequenceTests {
    private let targets = CalibrationGrid.nine

    /// Feeds 60 Hz samples that fixate the current target with a tiny wobble.
    private func run(_ sequence: inout FixationSequence, seconds: Double, from start: TimeInterval,
                     blinkEvery: Int? = nil, missing: Bool = false) -> [FixationEvent] {
        var events: [FixationEvent] = []
        let frames = Int(seconds * 60)
        for frame in 0..<frames {
            let time = start + Double(frame) / 60
            let target = sequence.currentTarget ?? SIMD2(0.5, 0.5)
            let wobble = SIMD2(sin(Double(frame)) * 0.003, cos(Double(frame)) * 0.003)
            let blinking = blinkEvery.map { frame % $0 == 0 } ?? false
            let sample: SIMD2<Double>? = missing ? nil : target + wobble
            if let event = sequence.feed(sample: sample, isUsable: !blinking, at: time) {
                events.append(event)
            }
        }
        return events
    }

    @Test("settling produces no samples, collection fills the ring, then the next target comes")
    func settleThenCollect() {
        var sequence = FixationSequence(targets: targets)

        let first = sequence.start(at: 10)
        #expect(first == .targetChanged(index: 0))
        #expect(sequence.currentTargetIndex == 0)
        #expect(sequence.progress(at: 10.1) == 0)

        _ = sequence.feed(sample: SIMD2(0.15, 0.14), isUsable: true, at: 10.2)
        #expect(!sequence.isCollecting)
        _ = sequence.feed(sample: SIMD2(0.15, 0.14), isUsable: true, at: 10.31)
        #expect(sequence.isCollecting)
        #expect(sequence.progress(at: 10.71) > 0.45 && sequence.progress(at: 10.71) < 0.55)
    }

    @Test("nine targets complete in about ten seconds and yield nine measurements")
    func completes() {
        var sequence = FixationSequence(targets: targets)
        _ = sequence.start(at: 0)

        let events = run(&sequence, seconds: 12, from: 0)

        #expect(events.contains(.completed))
        #expect(sequence.measurements.count == 9)
        #expect(sequence.pairs.count == 9)
        for (raw, target) in sequence.pairs {
            #expect(simd_length(raw - target) < 0.005)
        }
        #expect(events.filter { if case .targetChanged = $0 { return true } else { return false } }.count == 8)
    }

    @Test("blinks are excluded but do not prevent completion")
    func blinks() {
        var sequence = FixationSequence(targets: Array(targets.prefix(2)))
        _ = sequence.start(at: 5)

        let events = run(&sequence, seconds: 4, from: 5, blinkEvery: 4)

        #expect(events.contains(.completed))
        #expect(sequence.measurements[0]?.acceptedCount ?? 0 >= 12)
    }

    @Test("a target without usable samples is retried once, then the sequence fails")
    func retryThenFail() {
        var sequence = FixationSequence(targets: Array(targets.prefix(1)))
        _ = sequence.start(at: 0)

        let events = run(&sequence, seconds: 7, from: 0, missing: true)

        #expect(events.contains(.targetChanged(index: 0)), "retry announced the same target again")
        #expect(events.contains(.failed(.insufficientSamples(target: 0))))
        #expect(sequence.isFinished)
        #expect(sequence.measurements.isEmpty)
    }

    @Test("collection extends past the nominal window when samples are scarce, then succeeds")
    func extendedCollection() {
        var sequence = FixationSequence(targets: Array(targets.prefix(1)))
        _ = sequence.start(at: 0)
        var events: [FixationEvent] = []
        for frame in 0..<180 {
            let time = Double(frame) / 60
            let usable = frame % 5 == 0 && time > 0.3
            if let event = sequence.feed(sample: SIMD2(0.15, 0.14), isUsable: usable, at: time) { events.append(event) }
        }

        #expect(events.contains(.completed))
    }

    @Test("an empty target list completes immediately and finished sequences ignore input")
    func empty() {
        var sequence = FixationSequence(targets: [])

        #expect(sequence.start(at: 0) == .completed)
        #expect(sequence.feed(sample: SIMD2(0, 0), isUsable: true, at: 1) == nil)
        #expect(sequence.isFinished)
    }
}
