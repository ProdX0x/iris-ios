// PhysicsConstants.swift
// Layer: Domain
// Purpose: Physical constants of the reference engine, expressed per 60 Hz reference frame

import Foundation

struct PhysicsConstants: Hashable, Sendable {
    /// `RADIUS_TARGET`: drawn sphere radius, points.
    var targetRadius: Double = 24
    /// `RADIUS_ARRIVAL`: arrival ring radius, points.
    var arrivalRadius: Double = 40
    /// `VITESSE_MAX`: speed cap, points per reference frame.
    var maxSpeed: Double = 2.2
    /// `FRICTION`: velocity multiplier applied once per reference frame.
    var friction: Double = 0.94
    /// `MARGE_BORD`: inset of the playable area, points.
    var edgeMargin: Double = 60
    /// `PERTE_REBOND`: velocity kept (and reversed) after touching an edge.
    var bounceLoss: Double = 0.5
    /// Frame rate at which the reference engine was validated; every per-frame quantity is defined at this rate.
    var referenceFrameRate: Double = 60

    init() {}

    var referenceFrameDuration: TimeInterval { 1 / referenceFrameRate }

    static let reference = PhysicsConstants()
}
