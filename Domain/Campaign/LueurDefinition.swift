// LueurDefinition.swift
// Layer: Domain
// Purpose: One authored lueur: start, iris, temperament, iris motion, the designer's intended route, an
// experimental braise tuning (prototype B1; nil in the historical campaign) and, from chapter VII, its twin

import Foundation

struct LueurDefinition: Hashable, Sendable {
    let start: NormalizedPoint
    let iris: NormalizedPoint
    let temperament: Temperament
    let irisMotion: IrisMotion
    /// Waypoints the designer expects the lueur to pass through before its iris (help display and simulation).
    let route: [NormalizedPoint]
    /// EXPERIMENTAL: when set, the lueur is a braise (cold, woken by the gaze). Never set in the historical campaign.
    let braise: BraiseDefinition?
    /// Chapter VII (jumelles): sequence (1-based) of the twin lueur. Twins have no iris: `iris` is the poste where the
    /// lueur waits, and once the twins are within reach each becomes the iris of the other. Always mutual.
    let twin: Int?

    init(start: NormalizedPoint, iris: NormalizedPoint, temperament: Temperament = .normale,
         irisMotion: IrisMotion = .fixed, route: [NormalizedPoint] = [], braise: BraiseDefinition? = nil, twin: Int? = nil) {
        self.start = start
        self.iris = iris
        self.temperament = temperament
        self.irisMotion = irisMotion
        self.route = route
        self.braise = braise
        self.twin = twin
    }

    var isTwin: Bool { twin != nil }
}
