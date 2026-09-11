// AVAudioEngineAudioService.swift
// Layer: Audio
// Purpose: AVAudioEngine host for the sine synthesizer, with audio session, interruption and reset handling

import Foundation
import AVFoundation

@MainActor
final class AVAudioEngineAudioService: AudioService {
    private(set) var status: AudioStatus = .inactive {
        didSet { if status != oldValue { onStatusChange?(status) } }
    }
    var onStatusChange: (@MainActor (AudioStatus) -> Void)?

    private var engine: AVAudioEngine?
    private var synth: SineSynth?
    private let observers = NotificationObserverBag()
    private var wantsActivation = false

    init() {
        installObservers()
    }

    func activate() {
        wantsActivation = true
        do {
            try configureSession()
            try startEngine()
            status = .active
        } catch {
            status = .unavailable(message: error.localizedDescription)
        }
    }

    func deactivate() {
        wantsActivation = false
        synth?.stopAllProgress()
        engine?.stop()
        try? AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
        status = .inactive
    }

    func apply(_ cue: AudioCue) {
        guard let synth, status == .active else { return }
        switch cue {
        case let .progress(voice, progress): synth.setProgress(voice: voice, progress: progress)
        case let .stopProgress(voice): synth.stopProgress(voice: voice)
        case .validation: synth.triggerChime()
        case .loss: synth.triggerLoss()
        case .levelComplete: synth.triggerCompletion()
        case .veilleuseLow: synth.triggerPulse()
        case let .ambient(frequency): synth.setAmbient(frequency: frequency)
        }
    }

    // MARK: Engine

    private func configureSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
        try session.setActive(true)
    }

    private func startEngine() throws {
        if let engine, engine.isRunning { return }
        let engine = AVAudioEngine()
        let sampleRate = engine.outputNode.outputFormat(forBus: 0).sampleRate
        let effectiveRate = sampleRate > 0 ? sampleRate : 44_100
        let synth = SineSynth(configuration: SineSynth.Configuration(sampleRate: effectiveRate))
        guard let format = AVAudioFormat(standardFormatWithSampleRate: effectiveRate, channels: 1) else {
            throw AudioServiceError.unsupportedFormat
        }
        // Explicitly `@Sendable`: the block runs on the real-time audio thread and must not inherit the
        // main-actor isolation of this method. It only touches the synthesizer, which is thread-safe by design.
        let source = AVAudioSourceNode(format: format) { @Sendable _, _, frameCount, audioBufferList -> OSStatus in
            let buffers = UnsafeMutableAudioBufferListPointer(audioBufferList)
            guard let first = buffers.first, let data = first.mData else { return noErr }
            let pointer = data.bindMemory(to: Float.self, capacity: Int(frameCount))
            synth.render(into: UnsafeMutableBufferPointer(start: pointer, count: Int(frameCount)))
            for extra in buffers.dropFirst() {
                if let extraData = extra.mData {
                    extraData.copyMemory(from: data, byteCount: Int(frameCount) * MemoryLayout<Float>.size)
                }
            }
            return noErr
        }
        engine.attach(source)
        engine.connect(source, to: engine.mainMixerNode, format: format)
        engine.connect(engine.mainMixerNode, to: engine.outputNode, format: nil)
        engine.mainMixerNode.outputVolume = 1
        engine.prepare()
        try engine.start()
        self.engine = engine
        self.synth = synth
    }

    private func rebuildEngine() {
        engine?.stop()
        engine = nil
        synth = nil
        guard wantsActivation else { return }
        activate()
    }

    // MARK: Notifications

    private func installObservers() {
        let center = NotificationCenter.default
        observers.add(center.addObserver(forName: AVAudioSession.interruptionNotification, object: nil, queue: .main) { [weak self] notification in
            let typeValue = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt
            let optionsValue = notification.userInfo?[AVAudioSessionInterruptionOptionKey] as? UInt
            MainActor.assumeIsolated {
                self?.handleInterruption(typeValue: typeValue, optionsValue: optionsValue)
            }
        })
        observers.add(center.addObserver(forName: .AVAudioEngineConfigurationChange, object: nil, queue: .main) { [weak self] _ in
            MainActor.assumeIsolated { self?.rebuildEngine() }
        })
        observers.add(center.addObserver(forName: AVAudioSession.mediaServicesWereResetNotification, object: nil, queue: .main) { [weak self] _ in
            MainActor.assumeIsolated { self?.rebuildEngine() }
        })
    }

    private func handleInterruption(typeValue: UInt?, optionsValue: UInt?) {
        guard let typeValue, let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }
        switch type {
        case .began:
            synth?.stopAllProgress()
            engine?.pause()
            if status == .active { status = .interrupted }
        case .ended:
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue ?? 0)
            guard wantsActivation, options.contains(.shouldResume) || status == .interrupted else { return }
            activate()
        @unknown default:
            break
        }
    }
}

enum AudioServiceError: Error {
    case unsupportedFormat
}
