// Campaign+FinalJumelles.swift
// Layer: Domain
// Purpose: OCULOMOTOR EXPANSION, chapter VII final « croisement » (diagonal saccades, variable amplitude): the twins
// call each other across a diagonal, near then far, on one diagonal then the other, and end close enough to fuse

import Foundation

extension Campaign {
    static let finalJumelles = LevelDefinition(
        chapter: 7, index: 7, title: "la danse croisée",
        principle: "Les jumelles s'appellent d'un coin à l'autre. Répondez à celle qui respire ; à la fin, elles se rejoignent.",
        introduces: [.croisement], zone: 0.46,
        lueurs: [LueurDefinition(start: pt(0.22, 0.2), iris: pt(0.4, 0.5), twin: 2),
                 LueurDefinition(start: pt(0.78, 0.8), iris: pt(0.6, 0.5), twin: 1)],
        oculo: OculoDefinition(stages: [
            .croisement(CroisementDefinition(center: pt(0.5, 0.5), legs: [
                .init(.falling, dx: 0.14, dy: 0.09), .init(.falling, dx: 0.24, dy: 0.18), .init(.falling, dx: 0.32, dy: 0.32),
                .init(.rising, dx: 0.32, dy: 0.32), .init(.rising, dx: 0.24, dy: 0.18), .init(.rising, dx: 0.14, dy: 0.09),
            ])),
        ], element: .croisement),
        gatesProgression: false,
        hints: [LevelHint(.start, "Deux jumelles, deux coins opposés. Regardez celle qui respire."),
                LevelHint(.firstOculoSuccess, "Elle appelle sa sœur, de l'autre côté. Répondez-lui."),
                LevelHint(.oculoCompleted, "Leur lien est complet. Elles glissent l'une vers l'autre : laissez-les se rejoindre."),
                LevelHint(.afterSeconds(40), "Une seule respire à la fois. Allez à elle, puis à l'autre coin.")],
        par: LevelPar(time: 24, intrusions: 4))
}
