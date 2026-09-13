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
    /// EXPERIMENTAL (prototype B1): braises keyed by target index; empty in the historical campaign.
    var braises: [Int: BraiseState]
    /// Chapter VII: twins keyed by target index (both twins of a pair are present); empty in the historical campaign.
    var twins: [Int: TwinState]
    /// Chapter VIII: gusts; empty in the historical campaign.
    var souffles: [SouffleField]
    /// Chapter IX: the echo of closing irises, the rings in flight, and the sleepers keyed by target index.
    var echo: EchoField?
    var waves: [EchoWave]
    var sleepers: [Int: SleeperState]
    /// Physical radius of each lueur (collisions with veils); empty uses the physics target radius.
    var lueurRadii: [Double]
    /// R-23: irises close while the gaze is off the playfield.
    var requiresAttentionOnField: Bool
    /// How far outside the playfield the gaze may be and still count as on it (points).
    var fieldTolerance: Double

    init(currents: [CurrentField] = [], veils: [VeilSegment] = [], veilleuses: [VeilleuseState] = [],
         irisPaths: [Int: IrisPath] = [:], braises: [Int: BraiseState] = [:], twins: [Int: TwinState] = [:],
         souffles: [SouffleField] = [], echo: EchoField? = nil, sleepers: [Int: SleeperState] = [:], lueurRadii: [Double] = [],
         requiresAttentionOnField: Bool = false, fieldTolerance: Double = 0) {
        self.currents = currents
        self.veils = veils
        self.veilleuses = veilleuses
        self.irisPaths = irisPaths
        self.braises = braises
        self.twins = twins
        self.souffles = souffles
        self.echo = echo
        self.waves = []
        self.sleepers = sleepers
        self.lueurRadii = lueurRadii
        self.requiresAttentionOnField = requiresAttentionOnField
        self.fieldTolerance = fieldTolerance
    }

    static let empty = LevelEnvironment()

    func impulse(at point: Vector2) -> Vector2 {
        currents.reduce(Vector2.zero) { $1.contains(point) ? $0 + $1.impulse : $0 }
    }

    /// Chapter VIII: the gust carrying a lueur at `point`, if any.
    func souffle(carrying point: Vector2, at time: TimeInterval) -> SouffleField? {
        souffles.first { $0.contains(point, at: time) }
    }

    func isOnField(_ point: Vector2, bounds: PlayfieldBounds) -> Bool {
        point.x >= -fieldTolerance && point.x <= bounds.width + fieldTolerance
            && point.y >= -fieldTolerance && point.y <= bounds.height + fieldTolerance
    }
}
