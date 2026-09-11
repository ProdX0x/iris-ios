// SilentAudioService.swift
// Layer: Audio
// Purpose: No-op audio used by previews and by the app when the audio engine cannot start

import Foundation

@MainActor
final class SilentAudioService: AudioService {
    private(set) var status: AudioStatus
    var onStatusChange: (@MainActor (AudioStatus) -> Void)?

    init(status: AudioStatus = .unavailable(message: "audio désactivé")) {
        self.status = status
    }

    func activate() {}
    func deactivate() {}
    func apply(_ cue: AudioCue) {}
}
