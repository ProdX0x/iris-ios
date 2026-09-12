// Campaign+Jumelles.swift
// Layer: Domain
// Purpose: Chapter VII, Jumelles: twin lueurs have no iris, each is the iris of the other; bring them within reach
// and they finish the rendez-vous themselves

import Foundation

extension Campaign {
    static let jumelles = ChapterDefinition(
        number: 7, name: "jumelles", principle: "Chacune est l'iris de l'autre.", ambientFrequency: 92.5, theme: .jumelles,
        levels: [
            LevelDefinition(
                chapter: 7, index: 1, title: "l'une l'autre",
                principle: "Deux lueurs, aucun iris. Amenez l'une à portée de l'autre.",
                introduces: [.jumelles], zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.5, 0.10), iris: pt(0.5, 0.30), route: [pt(0.5, 0.47), pt(0.5, 0.60)], twin: 2),
                         LueurDefinition(start: pt(0.5, 0.90), iris: pt(0.5, 0.70), twin: 1)],
                hints: [LevelHint(.start, "Elles n'ont pas d'iris. Chacune est l'iris de l'autre."),
                        LevelHint(.firstIntrusion, "Poussez l'une vers l'autre, par le regard."),
                        LevelHint(.twinsLinked, "Elles se sont vues. Laissez-les se rejoindre."),
                        LevelHint(.firstHold, "Tenez : elles se ferment l'une sur l'autre."),
                        LevelHint(.afterSeconds(30), "Regardez au-dessus de celle du haut pour la pousser vers le bas.")],
                par: LevelPar(time: 15, intrusions: 4)),
            LevelDefinition(
                chapter: 7, index: 2, title: "le fil",
                principle: "Un voile entre elles. Le fil trouve le passage.",
                zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.12, 0.12), iris: pt(0.28, 0.30), route: [pt(0.55, 0.36), pt(0.82, 0.50), pt(0.78, 0.60)], twin: 2),
                         LueurDefinition(start: pt(0.88, 0.88), iris: pt(0.72, 0.68), twin: 1)],
                veils: [VeilDefinition(a: pt(0.15, 0.50), b: pt(0.70, 0.50))],
                hints: [LevelHint(.start, "Le voile les sépare. Contournez-le par la droite."),
                        LevelHint(.twinsLinked, "À portée. Laissez faire.")],
                par: LevelPar(time: 16, intrusions: 4)),
            LevelDefinition(
                chapter: 7, index: 3, title: "la solitaire",
                principle: "Une paire, et une lueur ordinaire dont l'iris est au centre.",
                zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.10, 0.10), iris: pt(0.20, 0.22), route: [pt(0.36, 0.50), pt(0.62, 0.52), pt(0.78, 0.30)], twin: 2),
                         LueurDefinition(start: pt(0.90, 0.10), iris: pt(0.80, 0.22), twin: 1),
                         LueurDefinition(start: pt(0.5, 0.88), iris: pt(0.5, 0.30))],
                hints: [LevelHint(.start, "La solitaire rejoint son iris seule. Contournez-la avec la jumelle."),
                        LevelHint(.firstLoss, "Votre regard a chassé la solitaire. Elle reviendra.")],
                par: LevelPar(time: 22, intrusions: 6)),
            LevelDefinition(
                chapter: 7, index: 4, title: "à contre-courant",
                principle: "Le courant les sépare. Traversez-le de biais.",
                zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.5, 0.08), iris: pt(0.5, 0.24), route: [pt(0.66, 0.40), pt(0.50, 0.66)], twin: 2),
                         LueurDefinition(start: pt(0.5, 0.92), iris: pt(0.5, 0.76), twin: 1)],
                currents: [CurrentDefinition(area: band(0.0, 0.42, 1.0, 0.58), direction: left, strength: 0.85)],
                hints: [LevelHint(.start, "Le courant l'emporte vers la gauche. Entrez à droite."),
                        LevelHint(.twinsLinked, "Hors du courant, elles se rejoignent.")],
                par: LevelPar(time: 17, intrusions: 4)),
            LevelDefinition(
                chapter: 7, index: 5, title: "sous la veilleuse",
                principle: "La flamme éclaire leur rendez-vous. Ne l'oubliez pas.",
                zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.10, 0.12), iris: pt(0.22, 0.30), route: [pt(0.50, 0.34), pt(0.74, 0.60)], twin: 2),
                         LueurDefinition(start: pt(0.90, 0.88), iris: pt(0.78, 0.70), twin: 1)],
                veilleuses: [VeilleuseDefinition(position: pt(0.5, 0.62), lookRadius: 0.14, decay: 9, recharge: 0.8, initialCharge: 0.45)],
                hints: [LevelHint(.start, "Sans la flamme, elles ne se ferment pas l'une sur l'autre."),
                        LevelHint(.veilleuseLow, "La flamme faiblit. Regardez-la.")],
                par: LevelPar(time: 17, intrusions: 6)),
            LevelDefinition(
                chapter: 7, index: 6, title: "la troisième",
                principle: "Les jumelles d'abord, puis la troisième. Le voile impose le détour.",
                ordered: true, zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.10, 0.10), iris: pt(0.22, 0.28), route: [pt(0.35, 0.55), pt(0.62, 0.50), pt(0.72, 0.36)], twin: 2),
                         LueurDefinition(start: pt(0.90, 0.10), iris: pt(0.78, 0.28), twin: 1),
                         LueurDefinition(start: pt(0.5, 0.90), iris: pt(0.5, 0.62))],
                veils: [VeilDefinition(a: pt(0.5, 0.12), b: pt(0.5, 0.45))],
                hints: [LevelHint(.start, "Dans l'ordre : les jumelles, puis la troisième."),
                        LevelHint(.firstLoss, "Séparées, elles entraînent la troisième dans leur chute.")],
                par: LevelPar(time: 21, intrusions: 8)),
        ])
}
