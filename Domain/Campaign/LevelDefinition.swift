// LevelDefinition.swift
// Layer: Domain
// Purpose: One authored campaign level: intention, lueurs, elements, tuning, hints and par

import Foundation

struct LevelDefinition: Hashable, Sendable, Identifiable {
    let chapter: Int
    let index: Int
    let title: String
    /// One sentence shown on the intro card.
    let principle: String
    let introduces: [GameElement]
    let ordered: Bool
    /// Attention zone radius as a fraction of the playfield's short side.
    let zone: Double
    /// Repulsion impulse at contact, per reference frame at scale 1.
    let repulsionForce: Double
    let attraction: Double
    let noise: Double
    let hold: TimeInterval
    let lueurs: [LueurDefinition]
    let currents: [CurrentDefinition]
    let veils: [VeilDefinition]
    let veilleuses: [VeilleuseDefinition]
    /// Chapter VIII: gusts carrying lueurs along their tracks.
    let souffles: [SouffleDefinition]
    /// Chapter IX: the echo of closing irises; nil means irises are silent and no lueur can be asleep.
    let echo: EchoDefinition?
    /// Chapter X: wells.
    let gouffres: [GouffreDefinition]
    let hints: [LevelHint]
    let par: LevelPar

    init(chapter: Int, index: Int, title: String, principle: String, introduces: [GameElement] = [],
         ordered: Bool = false, zone: Double = 0.48, repulsionForce: Double = 2.4, attraction: Double = 0.5,
         noise: Double = 0.15, hold: TimeInterval = 0.75, lueurs: [LueurDefinition], currents: [CurrentDefinition] = [],
         veils: [VeilDefinition] = [], veilleuses: [VeilleuseDefinition] = [], souffles: [SouffleDefinition] = [],
         echo: EchoDefinition? = nil, gouffres: [GouffreDefinition] = [], hints: [LevelHint] = [], par: LevelPar) {
        self.chapter = chapter
        self.index = index
        self.title = title
        self.principle = principle
        self.introduces = introduces
        self.ordered = ordered
        self.zone = zone
        self.repulsionForce = repulsionForce
        self.attraction = attraction
        self.noise = noise
        self.hold = hold
        self.lueurs = lueurs
        self.currents = currents
        self.veils = veils
        self.veilleuses = veilleuses
        self.souffles = souffles
        self.echo = echo
        self.gouffres = gouffres
        self.hints = hints
        self.par = par
    }

    var id: String { "\(chapter)-\(index)" }

    /// Element kinds present in the level (for the combination rules and difference criteria).
    var elementKinds: Set<GameElement> {
        var kinds = Set<GameElement>()
        if !currents.isEmpty { kinds.insert(.courant) }
        if !veils.isEmpty { kinds.insert(.voile) }
        if !veilleuses.isEmpty { kinds.insert(.veilleuse) }
        if lueurs.contains(where: { $0.irisMotion.isMoving }) { kinds.insert(.irisMouvant) }
        if hasTwins { kinds.insert(.jumelles) }
        if !souffles.isEmpty { kinds.insert(.souffle) }
        if echo != nil { kinds.insert(.echo) }
        if hasSleepers { kinds.insert(.dormeuse) }
        if !gouffres.isEmpty { kinds.insert(.gouffre) }
        if hasBraises { kinds.insert(.braise) }
        return kinds
    }

    var hasTemperaments: Bool { lueurs.contains { $0.temperament != .normale } }
    /// Chapter 0 is reserved for experiments (prototype levels): never part of the campaign, never recorded in the progress.
    var isExperimental: Bool { chapter == 0 }
    var hasBraises: Bool { lueurs.contains { $0.braise != nil } }
    /// Chapter VII: at least one pair of twins.
    var hasTwins: Bool { lueurs.contains(where: \.isTwin) }
    /// Chapter IX: at least one sleeping lueur.
    var hasSleepers: Bool { lueurs.contains(where: \.asleep) }
    var requiresPushing: Bool { lueurs.contains { !$0.route.isEmpty } }
}
