// Campaign+Voiles.swift
// Layer: Domain
// Purpose: Chapter IV, Voiles: push around what the lueur cannot cross

import Foundation

extension Campaign {
    static let voiles = ChapterDefinition(
        number: 4, name: "voiles", principle: "Contourner, c'est viser.", ambientFrequency: 130.81,
        levels: [
            LevelDefinition(
                chapter: 4, index: 1, title: "le voile",
                principle: "Elle bute. Poussez-la vers le bord du voile.",
                introduces: [.voile], zone: 0.46, repulsionForce: 2.6,
                lueurs: [LueurDefinition(start: pt(0.5, 0.85), iris: pt(0.5, 0.2), route: [pt(0.82, 0.56), pt(0.82, 0.42)])],
                veils: [VeilDefinition(a: pt(0.12, 0.5), b: pt(0.7, 0.5))],
                hints: [LevelHint(.start, "Les lueurs ne traversent pas les voiles."),
                        LevelHint(.afterSeconds(5), "Regardez à gauche de la lueur : elle glissera vers la droite.")],
                par: LevelPar(time: 17, intrusions: 3)),
            LevelDefinition(
                chapter: 4, index: 2, title: "le col",
                principle: "Le passage n'est pas dans l'axe, et une lueur veille à côté.",
                zone: 0.46, repulsionForce: 2.6,
                lueurs: [LueurDefinition(start: pt(0.76, 0.85), iris: pt(0.76, 0.2), route: [pt(0.43, 0.58), pt(0.43, 0.42)]),
                         LueurDefinition(start: pt(0.16, 0.88), iris: pt(0.28, 0.66))],
                veils: [VeilDefinition(a: pt(0.12, 0.5), b: pt(0.34, 0.5)),
                        VeilDefinition(a: pt(0.52, 0.5), b: pt(0.88, 0.5))],
                par: LevelPar(time: 17, intrusions: 4)),
            LevelDefinition(
                chapter: 4, index: 3, title: "le coude",
                principle: "Deux poussées : monter, puis tourner.",
                zone: 0.46, repulsionForce: 2.6,
                lueurs: [LueurDefinition(start: pt(0.28, 0.6), iris: pt(0.74, 0.5), route: [pt(0.3, 0.17), pt(0.66, 0.17)])],
                veils: [VeilDefinition(a: pt(0.5, 0.25), b: pt(0.5, 0.76)),
                        VeilDefinition(a: pt(0.12, 0.76), b: pt(0.5, 0.76))],
                par: LevelPar(time: 19, intrusions: 3)),
            LevelDefinition(
                chapter: 4, index: 4, title: "deux côtés",
                principle: "Poussez l'une sans chasser l'autre.",
                ordered: true, zone: 0.46, repulsionForce: 2.6,
                lueurs: [LueurDefinition(start: pt(0.26, 0.5), iris: pt(0.76, 0.62), route: [pt(0.3, 0.85), pt(0.64, 0.85)]),
                         LueurDefinition(start: pt(0.76, 0.4), iris: pt(0.24, 0.36), route: [pt(0.7, 0.17), pt(0.34, 0.17)])],
                veils: [VeilDefinition(a: pt(0.5, 0.28), b: pt(0.5, 0.74))],
                par: LevelPar(time: 21, intrusions: 6)),
            LevelDefinition(
                chapter: 4, index: 5, title: "voile et courant",
                principle: "Le courant l'éloigne de l'ouverture.",
                zone: 0.46, repulsionForce: 2.6,
                lueurs: [LueurDefinition(start: pt(0.3, 0.86), iris: pt(0.3, 0.16), route: [pt(0.3, 0.44), pt(0.8, 0.42), pt(0.8, 0.27)])],
                currents: [CurrentDefinition(area: band(0, 0.36, 1, 0.5), direction: left)],
                veils: [VeilDefinition(a: pt(0.12, 0.34), b: pt(0.66, 0.34))],
                par: LevelPar(time: 22, intrusions: 3)),
            LevelDefinition(
                chapter: 4, index: 6, title: "la chambre",
                principle: "Un iris enfermé, une seule entrée.",
                ordered: true, zone: 0.46, repulsionForce: 2.6,
                lueurs: [LueurDefinition(start: pt(0.16, 0.2), iris: pt(0.52, 0.51), route: [pt(0.8, 0.3), pt(0.8, 0.51)]),
                         LueurDefinition(start: pt(0.5, 0.88), iris: pt(0.5, 0.2), route: [pt(0.84, 0.68), pt(0.84, 0.36)])],
                veils: [VeilDefinition(a: pt(0.36, 0.42), b: pt(0.66, 0.42)),
                        VeilDefinition(a: pt(0.36, 0.6), b: pt(0.66, 0.6)),
                        VeilDefinition(a: pt(0.36, 0.42), b: pt(0.36, 0.6))],
                par: LevelPar(time: 26, intrusions: 9)),
        ])
}
