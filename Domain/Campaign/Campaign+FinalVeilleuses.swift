// Campaign+FinalVeilleuses.swift
// Layer: Domain
// Purpose: OCULOMOTOR EXPANSION, chapter V final « les étoiles absentes » (memory-guided saccades): stars shine
// briefly, vanish, and come back only where the gaze returns to their place; a flame keeps the iris lit for the end

import Foundation

extension Campaign {
    static let finalVeilleuses = LevelDefinition(
        chapter: 5, index: 7, title: "les étoiles absentes",
        principle: "Des étoiles brillent un instant, puis s'effacent. Retournez là où elles étaient : la constellation se dessine.",
        introduces: [.etoileAbsente], zone: 0.48,
        lueurs: [LueurDefinition(start: pt(0.15, 0.12), iris: pt(0.5, 0.5))],
        veilleuses: [VeilleuseDefinition(position: pt(0.5, 0.9), lookRadius: 0.14, decay: 9, recharge: 0.8, initialCharge: 0.45)],
        oculo: OculoDefinition(stages: [
            .etoiles(EtoilesDefinition(candidates: [pt(0.5, 0.16), pt(0.78, 0.26), pt(0.84, 0.5), pt(0.78, 0.72), pt(0.5, 0.8), pt(0.22, 0.72), pt(0.16, 0.5), pt(0.22, 0.26)],
                                       rounds: [[1, 5], [7, 3], [0, 2, 6], [4, 1, 7]])),
        ], element: .etoileAbsente),
        gatesProgression: false,
        hints: [LevelHint(.start, "Regardez bien où elles brillent : elles vont s'effacer."),
                LevelHint(.firstOculoSuccess, "Retrouvée. Cherchez l'autre, là où elle était."),
                LevelHint(.firstOculoMiss, "Pas ici. Elles reviennent briller un instant : regardez encore."),
                LevelHint(.oculoCompleted, "La constellation est dessinée. L'iris s'ouvre ; la flamme l'éclaire, ne l'oubliez pas."),
                LevelHint(.veilleuseLow, "La flamme faiblit.")],
        par: LevelPar(time: 34, intrusions: 3))
}
