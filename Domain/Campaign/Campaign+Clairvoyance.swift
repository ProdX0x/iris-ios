// Campaign+Clairvoyance.swift
// Layer: Domain
// Purpose: Chapter VI, Clairvoyance: gliding irises, then every idea combined

import Foundation

extension Campaign {
    static let clairvoyance = ChapterDefinition(
        number: 6, name: "clairvoyance", principle: "Lire le niveau avant de jouer.", ambientFrequency: 146.83,
        levels: [
            LevelDefinition(
                chapter: 6, index: 1, title: "iris mouvant",
                principle: "L'iris glisse. Anticipez sans le fixer.",
                introduces: [.irisMouvant], zone: 0.42,
                lueurs: [LueurDefinition(start: pt(0.5, 0.86), iris: pt(0.24, 0.34),
                                         irisMotion: .oscillate(to: pt(0.76, 0.34), period: 10))],
                hints: [LevelHint(.start, "L'iris se déplace lentement."),
                        LevelHint(.firstLoss, "Suivez-le de loin.")],
                par: LevelPar(time: 15, intrusions: 2)),
            LevelDefinition(
                chapter: 6, index: 2, title: "marée",
                principle: "L'iris 2 monte et descend près de la 1.",
                ordered: true, zone: 0.42,
                lueurs: [LueurDefinition(start: pt(0.2, 0.13), iris: pt(0.52, 0.62)),
                         LueurDefinition(start: pt(0.82, 0.86), iris: pt(0.24, 0.3),
                                         irisMotion: .oscillate(to: pt(0.24, 0.72), period: 9))],
                par: LevelPar(time: 15, intrusions: 2)),
            LevelDefinition(
                chapter: 6, index: 3, title: "flamme et courant",
                principle: "Pousser contre le courant sans oublier la flamme.",
                ordered: true, zone: 0.42, repulsionForce: 2.6,
                lueurs: [LueurDefinition(start: pt(0.3, 0.86), iris: pt(0.3, 0.22), route: [pt(0.3, 0.38)]),
                         LueurDefinition(start: pt(0.7, 0.19), iris: pt(0.64, 0.72))],
                currents: [CurrentDefinition(area: band(0, 0.44, 1, 0.54), direction: down)],
                veilleuses: [VeilleuseDefinition(position: pt(0.84, 0.82), decay: 7, initialCharge: 0.5)],
                par: LevelPar(time: 20, intrusions: 8)),
            LevelDefinition(
                chapter: 6, index: 4, title: "voile et marée",
                principle: "L'iris passe derrière le voile, puis en ressort.",
                zone: 0.42, repulsionForce: 2.6,
                lueurs: [LueurDefinition(start: pt(0.66, 0.85), iris: pt(0.52, 0.22),
                                         irisMotion: .oscillate(to: pt(0.8, 0.22), period: 12),
                                         route: [pt(0.18, 0.57), pt(0.18, 0.42)])],
                veils: [VeilDefinition(a: pt(0.3, 0.5), b: pt(0.88, 0.5))],
                par: LevelPar(time: 18, intrusions: 3)),
            LevelDefinition(
                chapter: 6, index: 5, title: "constellation",
                principle: "Un courant, un voile, une flamme, trois lueurs.",
                ordered: true, zone: 0.42, repulsionForce: 2.6,
                lueurs: [LueurDefinition(start: pt(0.84, 0.84), iris: pt(0.75, 0.18), route: [pt(0.76, 0.25)]),
                         LueurDefinition(start: pt(0.3, 0.87), iris: pt(0.3, 0.45), route: [pt(0.62, 0.7), pt(0.62, 0.55)]),
                         LueurDefinition(start: pt(0.46, 0.12), iris: pt(0.24, 0.8), route: [pt(0.62, 0.55), pt(0.62, 0.72)])],
                currents: [CurrentDefinition(area: band(0.5, 0.3, 1, 0.4), direction: down)],
                veils: [VeilDefinition(a: pt(0.12, 0.62), b: pt(0.5, 0.62))],
                veilleuses: [VeilleuseDefinition(position: pt(0.16, 0.3), decay: 7, initialCharge: 0.5, linked: [3])],
                par: LevelPar(time: 32, intrusions: 17)),
            LevelDefinition(
                chapter: 6, index: 6, title: "iris",
                principle: "Le dernier regard.",
                ordered: true, zone: 0.42, repulsionForce: 2.6,
                lueurs: [LueurDefinition(start: pt(0.16, 0.86), iris: pt(0.42, 0.2), route: [pt(0.2, 0.42), pt(0.2, 0.28)]),
                         LueurDefinition(start: pt(0.84, 0.13), iris: pt(0.6, 0.84), route: [pt(0.82, 0.58), pt(0.82, 0.72)]),
                         LueurDefinition(start: pt(0.84, 0.88), iris: pt(0.22, 0.7),
                                         irisMotion: .oscillate(to: pt(0.22, 0.86), period: 9))],
                currents: [CurrentDefinition(area: band(0.62, 0.2, 1, 0.3), direction: left)],
                veils: [VeilDefinition(a: pt(0.3, 0.36), b: pt(0.54, 0.36)),
                        VeilDefinition(a: pt(0.46, 0.64), b: pt(0.7, 0.64))],
                veilleuses: [VeilleuseDefinition(position: pt(0.5, 0.5), decay: 6, initialCharge: 0.6)],
                par: LevelPar(time: 22, intrusions: 9)),
        ])
}
