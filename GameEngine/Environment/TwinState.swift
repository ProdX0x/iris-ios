// TwinState.swift
// Layer: GameEngine
// Purpose: Chapter VII resolved twin: its partner, the poste where it waits, and the reach hysteresis of the link

import Foundation

struct TwinState: Hashable, Sendable {
    /// Target index of the twin lueur.
    let partner: Int
    /// Where the lueur waits (and drifts back to) while its twin is out of reach.
    let poste: Vector2
    /// Distance (points) under which the twins see each other: each becomes the iris of the other.
    let reach: Double
    /// Distance (points) beyond which linked twins lose sight of each other (hysteresis against a trembling approach).
    let release: Double
    private(set) var isLinked: Bool

    init(partner: Int, poste: Vector2, reach: Double, release: Double, isLinked: Bool = false) {
        self.partner = partner
        self.poste = poste
        self.reach = reach
        self.release = max(release, reach)
        self.isLinked = isLinked
    }

    enum Change: Hashable, Sendable {
        case none
        case linked
        case parted
    }

    /// Updates the link from the current distance between the twins; reports the threshold crossed, if any.
    mutating func update(distance: Double) -> Change {
        if !isLinked && distance <= reach {
            isLinked = true
            return .linked
        }
        if isLinked && distance > release {
            isLinked = false
            return .parted
        }
        return .none
    }
}
