// Campaign+FinalCourants.swift
// Layer: Domain
// Purpose: OCULOMOTOR EXPANSION, chapter III final « le fil vivant » (smooth pursuit): a spark glides along a smooth
// loop without stopping; the filament it leaves stays alive only while the gaze accompanies it

import Foundation

extension Campaign {
    static let finalCourants = LevelDefinition(
        chapter: 3, index: 7, title: "le fil vivant",
        principle: "Une étincelle file dans le courant. Accompagnez-la : son fil reste vivant tant que votre regard la suit.",
        introduces: [.filVivant], zone: 0.48,
        lueurs: [LueurDefinition(start: pt(0.15, 0.12), iris: pt(0.5, 0.5))],
        oculo: OculoDefinition(stages: [
            .fil(FilDefinition(center: pt(0.5, 0.5), amplitudeX: 0.3, amplitudeY: 0.28, phase: .pi / 3, wobble: 0.05, period: 10, requirement: 8)),
        ], element: .filVivant),
        gatesProgression: false,
        hints: [LevelHint(.start, "L'étincelle ne s'arrête jamais. Gardez-la sous le regard, sans la devancer."),
                LevelHint(.firstOculoMiss, "Le fil s'effiloche. Rattrapez-la : il se ravive."),
                LevelHint(.oculoCompleted, "Le fil est vivant. L'iris s'ouvre : laissez la lueur venir."),
                LevelHint(.afterSeconds(40), "Suivez-la d'un regard souple, comme on suit une feuille sur l'eau.")],
        par: LevelPar(time: 27, intrusions: 2))
}
