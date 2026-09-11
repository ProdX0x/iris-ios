// Campaign+Veilleuses.swift
// Layer: Domain
// Purpose: Chapter V, Veilleuses: look at something without disturbing the rest

import Foundation

extension Campaign {
    static let veilleuses = ChapterDefinition(
        number: 5, name: "veilleuses", principle: "Regarder sans troubler.", ambientFrequency: 116.54,
        levels: [
            LevelDefinition(
                chapter: 5, index: 1, title: "la veilleuse",
                principle: "La flamme faiblit. Sans elle, l'iris se ferme.",
                introduces: [.veilleuse], zone: 0.44,
                lueurs: [LueurDefinition(start: pt(0.3, 0.85), iris: pt(0.3, 0.3))],
                veilleuses: [VeilleuseDefinition(position: pt(0.76, 0.58), decay: 8, initialCharge: 0.35)],
                hints: [LevelHint(.start, "Regardez la flamme pour la raviver."),
                        LevelHint(.veilleuseLow, "La flamme s'éteint. Un regard suffit."),
                        LevelHint(.firstLoss, "Flamme éteinte : l'iris s'est fermé.")],
                par: LevelPar(time: 14, intrusions: 2)),
            LevelDefinition(
                chapter: 5, index: 2, title: "près du feu",
                principle: "La flamme veille au-dessus de l'iris 1.",
                ordered: true, zone: 0.44,
                lueurs: [LueurDefinition(start: pt(0.2, 0.85), iris: pt(0.5, 0.38)),
                         LueurDefinition(start: pt(0.84, 0.18), iris: pt(0.22, 0.76))],
                veilleuses: [VeilleuseDefinition(position: pt(0.5, 0.2), decay: 7, initialCharge: 0.6)],
                par: LevelPar(time: 15, intrusions: 5)),
            LevelDefinition(
                chapter: 5, index: 3, title: "deux flammes",
                principle: "Chaque flamme éclaire un iris.",
                ordered: true, zone: 0.44,
                lueurs: [LueurDefinition(start: pt(0.7, 0.87), iris: pt(0.3, 0.24)),
                         LueurDefinition(start: pt(0.3, 0.13), iris: pt(0.7, 0.78))],
                veilleuses: [VeilleuseDefinition(position: pt(0.16, 0.5), decay: 7, initialCharge: 0.5, linked: [1]),
                             VeilleuseDefinition(position: pt(0.84, 0.5), decay: 7, initialCharge: 0.5, linked: [2])],
                par: LevelPar(time: 17, intrusions: 8)),
            LevelDefinition(
                chapter: 5, index: 4, title: "garde et flamme",
                principle: "La flamme ne veille que sur la 1. Si elle meurt, tout tombe.",
                ordered: true, zone: 0.44,
                lueurs: [LueurDefinition(start: pt(0.2, 0.87), iris: pt(0.22, 0.64)),
                         LueurDefinition(start: pt(0.82, 0.85), iris: pt(0.8, 0.2)),
                         LueurDefinition(start: pt(0.2, 0.13), iris: pt(0.54, 0.28))],
                veilleuses: [VeilleuseDefinition(position: pt(0.5, 0.52), decay: 6, initialCharge: 0.35, linked: [1])],
                par: LevelPar(time: 19, intrusions: 11)),
            LevelDefinition(
                chapter: 5, index: 5, title: "derrière le voile",
                principle: "Contourner le voile sans laisser mourir la flamme.",
                zone: 0.44, repulsionForce: 2.6,
                lueurs: [LueurDefinition(start: pt(0.36, 0.85), iris: pt(0.36, 0.2), route: [pt(0.78, 0.56), pt(0.78, 0.42)])],
                veils: [VeilDefinition(a: pt(0.12, 0.5), b: pt(0.66, 0.5))],
                veilleuses: [VeilleuseDefinition(position: pt(0.2, 0.68), decay: 6, initialCharge: 0.5)],
                par: LevelPar(time: 19, intrusions: 4)),
            LevelDefinition(
                chapter: 5, index: 6, title: "veilleuses",
                principle: "Une flamme exigeante, un courant, trois lueurs.",
                ordered: true, zone: 0.44, repulsionForce: 2.6,
                lueurs: [LueurDefinition(start: pt(0.2, 0.13), iris: pt(0.5, 0.85), route: [pt(0.42, 0.76)]),
                         LueurDefinition(start: pt(0.8, 0.87), iris: pt(0.2, 0.4)),
                         LueurDefinition(start: pt(0.5, 0.11), iris: pt(0.8, 0.6))],
                currents: [CurrentDefinition(area: band(0, 0.62, 0.66, 0.7), direction: up)],
                veilleuses: [VeilleuseDefinition(position: pt(0.84, 0.3), decay: 6, initialCharge: 0.5)],
                par: LevelPar(time: 23, intrusions: 11)),
        ])
}
