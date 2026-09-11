// SessionMetrics.swift
// Layer: GameEngine
// Purpose: What the session measured for the mastery éclats (counts only, no gaze trace)

import Foundation

struct SessionMetrics: Hashable, Sendable {
    var intrusions = 0
    var losses = 0
    var attentionExits = 0

    init() {}
}
