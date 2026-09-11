// LevelEnvironment.swift
// Layer: GameEngine
// Purpose: Everything a campaign level adds around the historical engine (empty for prototype levels)

import Foundation

struct LevelEnvironment: Hashable, Sendable {
    var currents: [CurrentField]
    var veils: [VeilSegment]
    var veilleuses: [VeilleuseState]
    /// Gliding irises keyed by target index.
    var irisPaths: [Int: IrisPath]
    /// Physical radius of each lueur (collisions with veils); empty uses the physics target radius.
    var lueurRadii: [Double]
    /// R-23: irises close while the gaze is off the playfield.
    var requiresAttentionOnField: Bool
    /// How far outside the playfield the gaze may be and still count as on it (points).
    var fieldTolerance: Double

    init(currents: [CurrentField] = [], veils: [VeilSegment] = [], veilleuses: [VeilleuseState] = [],
         irisPaths: [Int: IrisPath] = [:], lueurRadii: [Double] = [], requiresAttentionOnField: Bool = false,
         fieldTolerance: Double = 0) {
        self.currents = currents
        self.veils = veils
        self.veilleuses = veilleuses
        self.irisPaths = irisPaths
        self.lueurRadii = lueurRadii
        self.requiresAttentionOnField = requiresAttentionOnField
        self.fieldTolerance = fieldTolerance
    }

    static let empty = LevelEnvironment()

    func impulse(at point: Vector2) -> Vector2 {
        currents.reduce(Vector2.zero) { $1.contains(point) ? $0 + $1.impulse : $0 }
    }

    func isOnField(_ point: Vector2, bounds: PlayfieldBounds) -> Bool {
        point.x >= -fieldTolerance && point.x <= bounds.width + fieldTolerance
            && point.y >= -fieldTolerance && point.y <= bounds.height + fieldTolerance
    }
}
