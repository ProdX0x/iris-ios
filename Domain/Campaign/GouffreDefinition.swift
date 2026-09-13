// GouffreDefinition.swift
// Layer: Domain
// Purpose: Chapter X: a well in the field; it pulls the lueurs that come near and sends what it swallows back to its start

import Foundation

struct GouffreDefinition: Hashable, Sendable {
    let center: NormalizedPoint
    /// Radius of the mouth (fraction of the short side): a lueur whose centre enters it is swallowed.
    let radius: Double
    /// Radius of the pull (fraction of the short side), larger than the mouth.
    let pull: Double
    /// Pull impulse at the mouth (points per reference frame at scale 1), fading to nothing at the pull's edge.
    let strength: Double

    init(center: NormalizedPoint, radius: Double = 0.09, pull: Double = 0.2, strength: Double = 0.9) {
        self.center = center
        self.radius = max(radius, 0.02)
        self.pull = max(pull, self.radius)
        self.strength = max(strength, 0)
    }
}
