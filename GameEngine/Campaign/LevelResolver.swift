// LevelResolver.swift
// Layer: GameEngine
// Purpose: Resolves a LevelDefinition against the playfield: scale, zone, forces, elements, routes

import Foundation

enum LevelResolver {
    /// Short side of the reference screen the campaign was tuned on (iPhone 15 Pro, 393 x 852 pt).
    static let referenceShortSide = 393.0
    static let lueurRadius = 20.0
    static let settleRadius = 16.0
    static let wobbleMargin = 20.0
    static let edgeMargin = 44.0
    static let veilHalfThickness = 3.0
    static let gazeJumpThreshold = 300.0
    /// R-23 tolerance as a fraction of the short side.
    static let fieldTolerance = 0.06

    static func resolve(_ definition: LevelDefinition, in bounds: PlayfieldBounds) -> ResolvedLevel {
        let shortSide = min(bounds.width, bounds.height)
        let scale = shortSide / referenceShortSide

        var physics = PhysicsConstants()
        physics.targetRadius = lueurRadius * scale
        physics.arrivalRadius = (lueurRadius + settleRadius) * scale
        physics.maxSpeed = 2.2 * scale
        physics.edgeMargin = edgeMargin * scale
        let validation = ValidationRules(settleRadius: settleRadius * scale, wobbleMargin: wobbleMargin * scale)

        let zone = definition.zone * shortSide
        let blueprints = definition.lueurs.enumerated().map { index, lueur in
            TargetBlueprint(sequence: index + 1,
                            start: lueur.start,
                            arrival: lueur.iris,
                            attentionZone: zone,
                            repulsionGain: definition.repulsionForce * scale * lueur.temperament.repulsionMultiplier / zone,
                            passiveAttraction: definition.attraction * scale * lueur.temperament.attractionMultiplier,
                            noiseAmplitude: definition.noise * scale)
        }
        let level = Level(id: LevelID(raw: definition.id), number: definition.index, targets: blueprints,
                          holdDuration: definition.hold, isSequential: definition.ordered)

        var paths: [Int: IrisPath] = [:]
        var braises: [Int: BraiseState] = [:]
        for (index, lueur) in definition.lueurs.enumerated() {
            if case let .oscillate(to, period) = lueur.irisMotion {
                paths[index] = IrisPath(from: lueur.iris.absolute(in: bounds), to: to.absolute(in: bounds), period: period)
            }
            if let braise = lueur.braise {
                braises[index] = BraiseState(definition: braise, shortSide: shortSide)
            }
        }
        let environment = LevelEnvironment(
            currents: definition.currents.map { current in
                CurrentField(minX: current.area.minX * bounds.width, minY: current.area.minY * bounds.height,
                             maxX: current.area.maxX * bounds.width, maxY: current.area.maxY * bounds.height,
                             impulse: current.direction * (current.strength * scale))
            },
            veils: definition.veils.map {
                VeilSegment(a: $0.a.absolute(in: bounds), b: $0.b.absolute(in: bounds), halfThickness: veilHalfThickness * scale)
            },
            veilleuses: definition.veilleuses.map {
                VeilleuseState(position: $0.position.absolute(in: bounds), lookRadius: $0.lookRadius * shortSide,
                               decay: $0.decay, recharge: $0.recharge, initialCharge: $0.initialCharge, linked: $0.linked)
            },
            irisPaths: paths,
            braises: braises,
            lueurRadii: definition.lueurs.map { lueurRadius * scale * $0.temperament.radiusMultiplier },
            requiresAttentionOnField: true,
            fieldTolerance: fieldTolerance * shortSide)

        return ResolvedLevel(definition: definition, bounds: bounds, scale: scale, level: level, physics: physics,
                             validation: validation, environment: environment,
                             routes: definition.lueurs.map { $0.route.map { $0.absolute(in: bounds) } },
                             gazeJumpThreshold: gazeJumpThreshold * scale)
    }
}
