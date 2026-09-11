// Campaign+Courants.swift
// Layer: Domain
// Purpose: Chapter III, Courants: the gaze becomes a force that pushes

import Foundation

extension Campaign {
    static let courants = ChapterDefinition(
        number: 3, name: "courants", principle: "Votre regard pousse aussi.", ambientFrequency: 98,
        levels: [
            LevelDefinition(
                chapter: 3, index: 1, title: "le courant",
                principle: "Le courant la retient. Poussez-la.",
                introduces: [.courant], zone: 0.48, repulsionForce: 2.6,
                lueurs: [LueurDefinition(start: pt(0.5, 0.85), iris: pt(0.5, 0.2), route: [pt(0.5, 0.37)])],
                currents: [CurrentDefinition(area: band(0, 0.44, 1, 0.56), direction: down)],
                hints: [LevelHint(.start, "Le courant emporte la lueur vers le bas."),
                        LevelHint(.afterSeconds(5), "Regardez juste sous la lueur : elle montera."),
                        LevelHint(.firstHold, "Passé le courant, laissez-la.")],
                par: LevelPar(time: 16, intrusions: 3)),
            LevelDefinition(
                chapter: 3, index: 2, title: "la brèche",
                principle: "Le courant laisse un passage.",
                zone: 0.48, repulsionForce: 2.6,
                lueurs: [LueurDefinition(start: pt(0.3, 0.85), iris: pt(0.3, 0.2), route: [pt(0.78, 0.63), pt(0.78, 0.37)])],
                currents: [CurrentDefinition(area: band(0, 0.44, 0.62, 0.56), direction: down)],
                hints: [LevelHint(.afterSeconds(6), "Poussez-la de côté, vers la brèche.")],
                par: LevelPar(time: 19, intrusions: 3)),
            LevelDefinition(
                chapter: 3, index: 3, title: "deux rives",
                principle: "L'une remonte le courant, l'autre le descend.",
                ordered: true, zone: 0.48, repulsionForce: 2.6,
                lueurs: [LueurDefinition(start: pt(0.25, 0.84), iris: pt(0.72, 0.22), route: [pt(0.6, 0.36)]),
                         LueurDefinition(start: pt(0.76, 0.17), iris: pt(0.28, 0.8))],
                currents: [CurrentDefinition(area: band(0, 0.45, 1, 0.55), direction: down)],
                par: LevelPar(time: 20, intrusions: 6)),
            LevelDefinition(
                chapter: 3, index: 4, title: "contre-marée",
                principle: "Deux courants, une lueur vive.",
                zone: 0.48, repulsionForce: 2.6,
                lueurs: [LueurDefinition(start: pt(0.5, 0.87), iris: pt(0.5, 0.14), temperament: .vive,
                                         route: [pt(0.5, 0.53), pt(0.5, 0.25)])],
                currents: [CurrentDefinition(area: band(0, 0.58, 1, 0.66), direction: down),
                           CurrentDefinition(area: band(0, 0.31, 1, 0.39), direction: down)],
                par: LevelPar(time: 17, intrusions: 3)),
            LevelDefinition(
                chapter: 3, index: 5, title: "contre le courant",
                principle: "La lourde est longue à pousser. La 2 attend.",
                ordered: true, zone: 0.48, repulsionForce: 2.6,
                lueurs: [LueurDefinition(start: pt(0.35, 0.87), iris: pt(0.62, 0.22), temperament: .lourde, route: [pt(0.56, 0.34)]),
                         LueurDefinition(start: pt(0.8, 0.24), iris: pt(0.2, 0.3))],
                currents: [CurrentDefinition(area: band(0, 0.41, 1, 0.6), direction: down, strength: 0.72)],
                par: LevelPar(time: 20, intrusions: 4)),
            LevelDefinition(
                chapter: 3, index: 6, title: "courants",
                principle: "Trois lueurs, deux courants, dans l'ordre.",
                ordered: true, zone: 0.48, repulsionForce: 2.6,
                lueurs: [LueurDefinition(start: pt(0.25, 0.87), iris: pt(0.3, 0.2), route: [pt(0.3, 0.36)]),
                         LueurDefinition(start: pt(0.8, 0.17), iris: pt(0.75, 0.87), route: [pt(0.75, 0.78)]),
                         LueurDefinition(start: pt(0.84, 0.48), iris: pt(0.2, 0.6))],
                currents: [CurrentDefinition(area: band(0, 0.42, 0.6, 0.52), direction: down),
                           CurrentDefinition(area: band(0.4, 0.62, 1, 0.72), direction: up)],
                par: LevelPar(time: 20, intrusions: 10)),
        ])
}
