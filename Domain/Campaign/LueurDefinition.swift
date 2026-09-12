// LueurDefinition.swift
// Layer: Domain
// Purpose: One authored lueur: start, iris, temperament, iris motion, the designer's intended route, and an
// experimental braise tuning (prototype B1; nil for every campaign lueur)

import Foundation

struct LueurDefinition: Hashable, Sendable {
    let start: NormalizedPoint
    let iris: NormalizedPoint
    let temperament: Temperament
    let irisMotion: IrisMotion
    /// Waypoints the designer expects the lueur to pass through before its iris (help display and simulation).
    let route: [NormalizedPoint]
    /// EXPERIMENTAL: when set, the lueur is a braise (cold, woken by the gaze). Never set in the campaign.
    let braise: BraiseDefinition?

    init(start: NormalizedPoint, iris: NormalizedPoint, temperament: Temperament = .normale,
         irisMotion: IrisMotion = .fixed, route: [NormalizedPoint] = [], braise: BraiseDefinition? = nil) {
        self.start = start
        self.iris = iris
        self.temperament = temperament
        self.irisMotion = irisMotion
        self.route = route
        self.braise = braise
    }
}
