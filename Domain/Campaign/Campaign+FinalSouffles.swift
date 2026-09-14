// Campaign+FinalSouffles.swift
// Layer: Domain
// Purpose: OCULOMOTOR EXPANSION, chapter VIII final « la lanterne du courant » (predictive pursuit, anticipation): a
// periodic current carries a lantern around the same loop; from the second lap it vanishes in the mist, and the gaze
// must be where it comes out

import Foundation

extension Campaign {
    static let finalSouffles = LevelDefinition(
        chapter: 8, index: 7, title: "la lanterne du courant",
        principle: "Le courant porte une lanterne, toujours par le même chemin. Dans la brume elle disparaît : soyez là où elle ressort.",
        introduces: [.lanterne], zone: 0.46, noise: 0.08,
        lueurs: [LueurDefinition(start: pt(0.5, 0.1), iris: pt(0.5, 0.5))],
        oculo: OculoDefinition(stages: [
            .courant(CourantDefinition(
                // Along the bottom (the current), up the right side (a rising curve), a wave across the top, back down the left.
                waypoints: [pt(0.22, 0.72), pt(0.5, 0.75), pt(0.78, 0.72), pt(0.8, 0.5), pt(0.7, 0.3), pt(0.5, 0.22),
                            pt(0.38, 0.3), pt(0.28, 0.24), pt(0.2, 0.36), pt(0.21, 0.55)],
                period: 8, drift: 0.25,
                mists: [.init(start: 0.08, end: 0.18), .init(start: 0.42, end: 0.52), .init(start: 0.74, end: 0.83)],
                mistFrom: 8, catchRadius: 0.2, catchWindow: 0.3, catches: 5)),
        ], element: .lanterne),
        gatesProgression: false,
        hints: [LevelHint(.start, "Suivez la lanterne. Le courant la ramène toujours par le même chemin."),
                LevelHint(.firstOculoMiss, "Elle est ressortie sans vous. Au prochain passage, gardez son rythme dans la brume."),
                LevelHint(.firstOculoSuccess, "Vous étiez là. Chaque brume a sa sortie."),
                LevelHint(.oculoCompleted, "Le courant vous connaît. L'iris s'ouvre : laissez la lueur venir."),
                LevelHint(.afterSeconds(45), "Dans la brume, continuez de la suivre du regard, au même pas qu'avant.")],
        par: LevelPar(time: 48, intrusions: 3))
}
