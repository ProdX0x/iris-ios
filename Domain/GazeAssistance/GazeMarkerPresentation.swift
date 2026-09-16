// GazeMarkerPresentation.swift
// Purpose: What the interface should do with the gaze marker right now: how visible it is, and whether the edge
// halo may be shown. The engine never produces this; the policy does, and only the presentation reads it
// Layer: Domain

import Foundation

struct GazeMarkerPresentation: Hashable, Sendable {
    /// 0 hides the marker, 1 shows it fully. Values between the two are the progressive fade of the third level.
    let opacity: Double
    /// Whether a halo may tell the player their gaze has left the useful area.
    let showsEdgeGuidance: Bool

    init(opacity: Double, showsEdgeGuidance: Bool) {
        self.opacity = min(max(opacity, 0), 1)
        self.showsEdgeGuidance = showsEdgeGuidance
    }

    var isMarkerVisible: Bool { opacity > 0 }

    static let hidden = GazeMarkerPresentation(opacity: 0, showsEdgeGuidance: true)
    static let shown = GazeMarkerPresentation(opacity: 1, showsEdgeGuidance: true)
}
