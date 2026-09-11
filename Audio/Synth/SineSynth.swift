// SineSynth.swift
// Layer: Audio
// Purpose: Allocation-free sine synthesizer reproducing the reference engine's Web Audio graph
// (per-target crescendo, three-note chime, descending loss tone); render side owned by the audio thread.

import Foundation
import os

final class SineSynth: @unchecked Sendable {
    struct Configuration: Hashable, Sendable {
        var sampleRate: Double
        /// Up to `SineSynth.maximumVoices` (one per simultaneous target).
        var voiceCount: Int = 3
        /// Web Audio gains were tuned for desktop speakers; the iPhone speaker needs a little more, ratios are kept.
        var masterGain: Double = 2.0
        /// `setTargetAtTime` time constant used for crescendo frequency and gain.
        var smoothingTimeConstant: Double = 0.05
        /// Time constant used to fade a stopped crescendo (`stopCrescendo`).
        var releaseTimeConstant: Double = 0.08
        var progressBaseFrequency: Double = 220
        var progressFrequencySpan: Double = 340
        var progressBaseGain: Double = 0.02
        var progressGainSpan: Double = 0.025
        var chimeFrequencies: [Double] = [660, 880, 1100]
        var chimeNoteDuration: Double = 0.12
        var chimeGain: Double = 0.05
        var lossStartFrequency: Double = 220
        var lossEndFrequency: Double = 120
        var lossDuration: Double = 0.25
        var lossGain: Double = 0.05

        init(sampleRate: Double) {
            self.sampleRate = sampleRate
        }
    }

    struct VoiceCommand: Hashable, Sendable {
        var isActive = false
        var frequency: Double = 220
        var gain: Double = 0
    }

    /// Fixed-size storage: copying it never touches the heap, so the render thread stays allocation-free.
    private struct Commands: Sendable {
        var voice0 = VoiceCommand()
        var voice1 = VoiceCommand()
        var voice2 = VoiceCommand()
        var chimeGeneration: UInt32 = 0
        var lossGeneration: UInt32 = 0

        subscript(voice voice: Int) -> VoiceCommand {
            get {
                switch voice {
                case 0: voice0
                case 1: voice1
                default: voice2
                }
            }
            set {
                switch voice {
                case 0: voice0 = newValue
                case 1: voice1 = newValue
                default: voice2 = newValue
                }
            }
        }

        mutating func deactivateAll() {
            voice0.isActive = false
            voice1.isActive = false
            voice2.isActive = false
        }
    }

    static let maximumVoices = 3

    private struct VoiceRuntime {
        var phase: Double = 0
        var frequency: Double = 220
        var gain: Double = 0
    }

    private struct OneShotRuntime {
        var startSample: Int64 = -1
        var phase: Double = 0
    }

    let configuration: Configuration
    private let commands: OSAllocatedUnfairLock<Commands>

    // Render-thread state. Arrays are allocated once and mutated in place.
    private var voices: [VoiceRuntime]
    private var lastCommands: Commands
    private var chime = OneShotRuntime()
    private var loss = OneShotRuntime()
    private var sampleClock: Int64 = 0
    private let smoothingCoefficient: Double
    private let releaseCoefficient: Double
    private let twoPiOverSampleRate: Double

    init(configuration: Configuration) {
        var configuration = configuration
        configuration.voiceCount = min(max(configuration.voiceCount, 1), Self.maximumVoices)
        self.configuration = configuration
        let initial = Commands()
        commands = OSAllocatedUnfairLock(initialState: initial)
        lastCommands = initial
        voices = Array(repeating: VoiceRuntime(), count: configuration.voiceCount)
        smoothingCoefficient = 1 - exp(-1 / (configuration.smoothingTimeConstant * configuration.sampleRate))
        releaseCoefficient = 1 - exp(-1 / (configuration.releaseTimeConstant * configuration.sampleRate))
        twoPiOverSampleRate = 2 * .pi / configuration.sampleRate
    }

    // MARK: Control side (any thread)

    func setProgress(voice: Int, progress: Double) {
        guard voice >= 0 && voice < configuration.voiceCount else { return }
        let clamped = min(max(progress, 0), 1)
        let command = VoiceCommand(isActive: true,
                                   frequency: configuration.progressBaseFrequency + clamped * configuration.progressFrequencySpan,
                                   gain: configuration.progressBaseGain + clamped * configuration.progressGainSpan)
        commands.withLock { $0[voice: voice] = command }
    }

    func stopProgress(voice: Int) {
        guard voice >= 0 && voice < configuration.voiceCount else { return }
        commands.withLock { $0[voice: voice].isActive = false }
    }

    func stopAllProgress() {
        commands.withLock { $0.deactivateAll() }
    }

    func triggerChime() {
        commands.withLock { $0.chimeGeneration &+= 1 }
    }

    func triggerLoss() {
        commands.withLock { $0.lossGeneration &+= 1 }
    }

    // MARK: Render side (audio thread only)

    /// Fills `buffer` with mono samples. Never blocks: if the control lock is busy the previous commands are reused.
    func render(into buffer: UnsafeMutableBufferPointer<Float>) {
        if let fresh = commands.withLockIfAvailable({ $0 }) {
            if fresh.chimeGeneration != lastCommands.chimeGeneration {
                chime.startSample = sampleClock
                chime.phase = 0
            }
            if fresh.lossGeneration != lastCommands.lossGeneration {
                loss.startSample = sampleClock
                loss.phase = 0
            }
            lastCommands = fresh
        }
        let commandsNow = lastCommands
        let master = configuration.masterGain
        for frame in 0..<buffer.count {
            var mix = 0.0
            for index in voices.indices {
                let command = commandsNow[voice: index]
                var voice = voices[index]
                if command.isActive {
                    voice.frequency += (command.frequency - voice.frequency) * smoothingCoefficient
                    voice.gain += (command.gain - voice.gain) * smoothingCoefficient
                } else {
                    voice.gain += (0 - voice.gain) * releaseCoefficient
                }
                if voice.gain > 1e-5 {
                    voice.phase += voice.frequency * twoPiOverSampleRate
                    if voice.phase > 2 * .pi { voice.phase -= 2 * .pi }
                    mix += sin(voice.phase) * voice.gain
                }
                voices[index] = voice
            }
            mix += renderChime()
            mix += renderLoss()
            buffer[frame] = Float(mix * master)
            sampleClock += 1
        }
    }

    private func renderChime() -> Double {
        guard chime.startSample >= 0 else { return 0 }
        let elapsed = Double(sampleClock - chime.startSample) / configuration.sampleRate
        let noteDuration = configuration.chimeNoteDuration
        let total = noteDuration * Double(configuration.chimeFrequencies.count)
        if elapsed >= total {
            chime.startSample = -1
            return 0
        }
        let noteIndex = min(Int(elapsed / noteDuration), configuration.chimeFrequencies.count - 1)
        let noteTime = elapsed - Double(noteIndex) * noteDuration
        let attack = noteDuration * 0.3
        let envelope: Double
        if noteTime < attack {
            envelope = configuration.chimeGain * (noteTime / attack)
        } else {
            envelope = configuration.chimeGain * (1 - (noteTime - attack) / (noteDuration - attack))
        }
        let frequency = configuration.chimeFrequencies[noteIndex]
        return sin(2 * .pi * frequency * noteTime) * max(envelope, 0)
    }

    private func renderLoss() -> Double {
        guard loss.startSample >= 0 else { return 0 }
        let elapsed = Double(sampleClock - loss.startSample) / configuration.sampleRate
        if elapsed >= configuration.lossDuration {
            loss.startSample = -1
            return 0
        }
        let progress = elapsed / configuration.lossDuration
        let frequency = configuration.lossStartFrequency + (configuration.lossEndFrequency - configuration.lossStartFrequency) * progress
        let gain = configuration.lossGain * (1 - progress)
        loss.phase += frequency * twoPiOverSampleRate
        if loss.phase > 2 * .pi { loss.phase -= 2 * .pi }
        return sin(loss.phase) * gain
    }
}
