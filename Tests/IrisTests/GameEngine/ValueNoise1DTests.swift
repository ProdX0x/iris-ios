// ValueNoise1DTests.swift
// Layer: Tests
// Purpose: R-03 organic noise port: table values, smoothstep interpolation, wrap-around, subtle range

import Testing
@testable import Iris

@Suite("ValueNoise1D")
struct ValueNoise1DTests {
    private let noise = ValueNoise1D(seed: 1000)

    @Test("integer times return the raw table values of the JavaScript engine")
    func integerTimesMatchTable() {
        #expect(abs(noise.value(at: 0) - (-0.8362740054869684)) < 1e-15)
        #expect(abs(noise.value(at: 1) - 0.23811728395061738) < 1e-15)
        #expect(abs(noise.value(at: 2) - (-0.8484996570644718)) < 1e-15)
    }

    @Test("half-way values use smoothstep interpolation exactly like the reference")
    func halfwayMatchesReference() {
        #expect(abs(noise.value(at: 0.5) - (-0.2990783607681755)) < 1e-15)
    }

    @Test("the table wraps around after 256 entries")
    func wrapsAround() {
        #expect(abs(noise.value(at: 255.25) - 0.6082789459019204) < 1e-15)
        #expect(abs(noise.value(at: 256) - noise.value(at: 0)) < 1e-15)
    }

    @Test("values stay within -1...1 and vary smoothly")
    func rangeAndContinuity() {
        var previous = noise.value(at: 0)
        var step = 0.0
        while step < 300 {
            let value = noise.value(at: step)
            #expect(value >= -1 && value <= 1)
            #expect(abs(value - previous) < 0.2)
            previous = value
            step += 0.02
        }
    }

    @Test("same seed gives the same sequence, different seeds differ")
    func determinism() {
        let twin = ValueNoise1D(seed: 1000)
        let other = ValueNoise1D(seed: 1137)

        #expect(twin == noise)
        #expect(other.value(at: 3.3) != noise.value(at: 3.3))
    }
}
