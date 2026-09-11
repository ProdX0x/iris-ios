// LueurDefinition.swift
// Layer: Domain
// Purpose: One authored lueur: start, iris, temperament, iris motion and the designer's intended route

import Foundation

struct LueurDefinition: Hashable, Sendable {
    let start: NormalizedPoint
    let iris: NormalizedPoint
    let temperament: Temperament
    let irisMotion: IrisMotion
    /// Waypoints the designer expects the lueur to pass through before its iris (help display and simulation).
    let route: [NormalizedPoint]

    init(start: NormalizedPoint, iris: NormalizedPoint, temperament: Temperament = .normale,
         irisMotion: IrisMotion = .fixed, route: [NormalizedPoint] = []) {
        self.start = start
        self.iris = iris
        self.temperament = temperament
        self.irisMotion = irisMotion
        self.route = route
    }
}
