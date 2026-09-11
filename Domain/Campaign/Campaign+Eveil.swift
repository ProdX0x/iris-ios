// Campaign+Eveil.swift
// Layer: Domain
// Purpose: Chapter I, Éveil: the gaze repels; hold; stay on the screen; two lueurs; temperaments

import Foundation

extension Campaign {
    static let eveil = ChapterDefinition(
        number: 1, name: "éveil", principle: "Ce que vous regardez s'éloigne.", ambientFrequency: 110,
        levels: [
            LevelDefinition(
                chapter: 1, index: 1, title: "premier regard",
                principle: "Amenez la lueur dans son iris.",
                introduces: [.lueur, .iris], zone: 0.50,
                lueurs: [LueurDefinition(start: pt(0.5, 0.26), iris: pt(0.5, 0.66))],
                hints: [LevelHint(.start, "Regardez la lueur."),
                        LevelHint(.firstIntrusion, "Elle fuit votre regard. Regardez ailleurs, sur l'écran."),
                        LevelHint(.firstHold, "Laissez-la se poser dans son iris."),
                        LevelHint(.attentionLeftField, "Gardez les yeux sur l'écran."),
                        LevelHint(.afterSeconds(30), "Regardez un coin de l'écran, loin de la lueur.")],
                par: LevelPar(time: 12, intrusions: 3)),
            LevelDefinition(
                chapter: 1, index: 2, title: "tenir",
                principle: "L'iris est au centre. Où poser les yeux ?",
                zone: 0.50,
                lueurs: [LueurDefinition(start: pt(0.24, 0.86), iris: pt(0.5, 0.5))],
                hints: [LevelHint(.firstHold, "Tenez : trois quarts de seconde."),
                        LevelHint(.firstLoss, "Elle est sortie de l'iris. Regardez plus loin.")],
                par: LevelPar(time: 12, intrusions: 2)),
            LevelDefinition(
                chapter: 1, index: 3, title: "traversée",
                principle: "Suivez-la sans la regarder.",
                introduces: [.ecran], zone: 0.50,
                lueurs: [LueurDefinition(start: pt(0.5, 0.13), iris: pt(0.5, 0.87))],
                hints: [LevelHint(.start, "Gardez les yeux sur l'écran, loin de la lueur."),
                        LevelHint(.attentionLeftField, "Hors de l'écran, les iris se ferment.")],
                par: LevelPar(time: 17, intrusions: 3)),
            LevelDefinition(
                chapter: 1, index: 4, title: "deux couloirs",
                principle: "Deux lueurs, deux iris, dans l'ordre que vous voulez.",
                zone: 0.50,
                lueurs: [LueurDefinition(start: pt(0.25, 0.15), iris: pt(0.25, 0.72)),
                         LueurDefinition(start: pt(0.75, 0.85), iris: pt(0.75, 0.28))],
                par: LevelPar(time: 15, intrusions: 4)),
            LevelDefinition(
                chapter: 1, index: 5, title: "tempéraments",
                principle: "La vive fuit au moindre regard. La lourde résiste.",
                introduces: [.temperaments], zone: 0.50,
                lueurs: [LueurDefinition(start: pt(0.28, 0.16), iris: pt(0.7, 0.62), temperament: .lourde),
                         LueurDefinition(start: pt(0.74, 0.86), iris: pt(0.28, 0.42), temperament: .vive)],
                par: LevelPar(time: 14, intrusions: 2)),
        ])
}
