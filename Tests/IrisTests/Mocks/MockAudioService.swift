// MockAudioService.swift
// Layer: Tests
// Purpose: Recording mock for AudioService

import Foundation
@testable import Iris

@MainActor
final class MockAudioService: AudioService {
    private(set) var status: AudioStatus = .inactive
    var onStatusChange: (@MainActor (AudioStatus) -> Void)?
    private(set) var cues: [AudioCue] = []
    private(set) var activateCount = 0
    private(set) var deactivateCount = 0

    func activate() {
        activateCount += 1
        status = .active
        onStatusChange?(status)
    }

    func deactivate() {
        deactivateCount += 1
        status = .inactive
        onStatusChange?(status)
    }

    func apply(_ cue: AudioCue) {
        cues.append(cue)
    }

    func clearCues() {
        cues.removeAll()
    }
}
