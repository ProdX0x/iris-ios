// AudioService.swift
// Layer: Audio (service contract consumed by Presentation)
// Purpose: Sound output abstraction: cues in, status out

import Foundation

enum AudioStatus: Hashable, Sendable {
    case inactive
    case active
    case interrupted
    case unavailable(message: String)
}

@MainActor
protocol AudioService: AnyObject {
    var status: AudioStatus { get }
    var onStatusChange: (@MainActor (AudioStatus) -> Void)? { get set }

    func activate()
    func deactivate()
    func apply(_ cue: AudioCue)
}
