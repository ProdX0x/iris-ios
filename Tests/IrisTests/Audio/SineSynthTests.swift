// SineSynthTests.swift
// Layer: Tests
// Purpose: The synthesizer renders the crescendo, chime and loss tones with bounded amplitude and expected pitch

import Foundation
import Testing
@testable import Iris

@Suite("SineSynth")
struct SineSynthTests {
    private let sampleRate = 44_100.0

    private func render(_ synth: SineSynth, seconds: Double) -> [Float] {
        var samples = [Float](repeating: 0, count: Int(seconds * sampleRate))
        samples.withUnsafeMutableBufferPointer { synth.render(into: $0) }
        return samples
    }

    private func dominantFrequency(_ samples: ArraySlice<Float>) -> Double {
        var crossings = 0
        var previous = samples.first ?? 0
        for sample in samples.dropFirst() {
            if (previous < 0 && sample >= 0) || (previous >= 0 && sample < 0) { crossings += 1 }
            previous = sample
        }
        return Double(crossings) / 2 / (Double(samples.count) / sampleRate)
    }

    @Test("silence when nothing is triggered")
    func silence() {
        let synth = SineSynth(configuration: SineSynth.Configuration(sampleRate: sampleRate))

        let samples = render(synth, seconds: 0.2)

        #expect(samples.allSatisfy { $0 == 0 })
    }

    @Test("a full progress voice settles at 560 Hz (220 + 340) and rises in gain")
    func progressVoice() {
        let synth = SineSynth(configuration: SineSynth.Configuration(sampleRate: sampleRate))
        synth.setProgress(voice: 0, progress: 1)

        let samples = render(synth, seconds: 1.0)
        let tail = samples[Int(sampleRate * 0.5)...]

        #expect(abs(dominantFrequency(tail) - 560) < 3)
        let peak = tail.map { abs($0) }.max() ?? 0
        #expect(abs(Double(peak) - 0.045 * 2) < 0.005, "gain 0.02 + 0.025 times the master gain")
        #expect(samples.allSatisfy { abs($0) <= 1 })
    }

    @Test("a lower progress gives a lower pitch")
    func progressPitch() {
        let synth = SineSynth(configuration: SineSynth.Configuration(sampleRate: sampleRate))
        synth.setProgress(voice: 1, progress: 0.25)

        let samples = render(synth, seconds: 1.0)

        #expect(abs(dominantFrequency(samples[Int(sampleRate * 0.5)...]) - 305) < 3)
    }

    @Test("stopping a voice fades it to silence")
    func stopFades() {
        let synth = SineSynth(configuration: SineSynth.Configuration(sampleRate: sampleRate))
        synth.setProgress(voice: 0, progress: 1)
        _ = render(synth, seconds: 0.5)

        synth.stopProgress(voice: 0)
        let samples = render(synth, seconds: 1.0)

        let tail = samples[Int(sampleRate * 0.8)...]
        #expect((tail.map { abs($0) }.max() ?? 1) < 1e-3)
    }

    @Test("the chime lasts three notes of 0.12 s then stops")
    func chime() {
        let synth = SineSynth(configuration: SineSynth.Configuration(sampleRate: sampleRate))
        synth.triggerChime()

        let samples = render(synth, seconds: 0.6)

        let during = samples[Int(sampleRate * 0.02)..<Int(sampleRate * 0.10)]
        let after = samples[Int(sampleRate * 0.40)...]
        #expect((during.map { abs($0) }.max() ?? 0) > 0.01)
        #expect(after.allSatisfy { $0 == 0 })
        #expect(abs(dominantFrequency(during) - 660) < 12)
    }

    @Test("the loss tone sweeps down from 220 Hz and ends after 0.25 s")
    func lossTone() {
        let synth = SineSynth(configuration: SineSynth.Configuration(sampleRate: sampleRate))
        synth.triggerLoss()

        let samples = render(synth, seconds: 0.5)

        let early = samples[0..<Int(sampleRate * 0.05)]
        let late = samples[Int(sampleRate * 0.18)..<Int(sampleRate * 0.24)]
        #expect(dominantFrequency(early) > dominantFrequency(late), "descending pitch")
        #expect(samples[Int(sampleRate * 0.3)...].allSatisfy { $0 == 0 })
    }

    @Test("out-of-range voices are ignored")
    func ignoresInvalidVoice() {
        let synth = SineSynth(configuration: SineSynth.Configuration(sampleRate: sampleRate))

        synth.setProgress(voice: 7, progress: 1)
        synth.stopProgress(voice: -1)

        #expect(render(synth, seconds: 0.1).allSatisfy { $0 == 0 })
    }
}

@Suite("SineSynth campaign sounds")
struct SineSynthCampaignTests {
    private let sampleRate = 44_100.0

    private func render(_ synth: SineSynth, seconds: Double) -> [Float] {
        var samples = [Float](repeating: 0, count: Int(seconds * sampleRate))
        samples.withUnsafeMutableBufferPointer { synth.render(into: $0) }
        return samples
    }

    @Test("the completion arpeggio lasts four notes of 0.16 s and cancels a pending chime")
    func completion() {
        let synth = SineSynth(configuration: SineSynth.Configuration(sampleRate: sampleRate))
        synth.triggerChime()
        synth.triggerCompletion()

        let samples = render(synth, seconds: 1.0)

        #expect((samples[Int(sampleRate * 0.05)..<Int(sampleRate * 0.12)].map { abs($0) }.max() ?? 0) > 0.01)
        #expect(samples[Int(sampleRate * 0.7)...].allSatisfy { $0 == 0 })
    }

    @Test("the veilleuse pulse is short and soft")
    func pulse() {
        let synth = SineSynth(configuration: SineSynth.Configuration(sampleRate: sampleRate))
        synth.triggerPulse()

        let samples = render(synth, seconds: 0.2)

        let peak = samples.map { abs($0) }.max() ?? 0
        #expect(peak > 0.01 && peak <= 0.05 + 1e-3)
        #expect(samples[Int(sampleRate * 0.07)...].allSatisfy { $0 == 0 })
    }

    @Test("the ambient drone fades in quietly and fades out")
    func ambient() {
        let synth = SineSynth(configuration: SineSynth.Configuration(sampleRate: sampleRate))
        synth.setAmbient(frequency: 110)

        let fadeIn = render(synth, seconds: 4)
        let settled = fadeIn[Int(sampleRate * 3)...].map { abs($0) }.max() ?? 0
        synth.setAmbient(frequency: nil)
        let fadeOut = render(synth, seconds: 8)

        #expect(settled > 0.01 && settled < 0.03, "about 0.012 x 2 master gain")
        #expect((fadeOut[Int(sampleRate * 7)...].map { abs($0) }.max() ?? 1) < 1e-3)
    }
}
