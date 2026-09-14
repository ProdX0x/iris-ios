// Campaign+FinalBraises.swift
// Layer: Domain
// Purpose: OCULOMOTOR EXPANSION, chapter XI final « d'abord les yeux » (eye-head coordination, saccade-first gaze
// shift): braises light up at the edge of the field; reaching them with the eyes first, then letting the head follow,
// gives them all their warmth; the validated braise A waits for that warmth at the end

import Foundation

extension Campaign {
    static let finalBraises = LevelDefinition(
        chapter: 11, index: 7, title: "d'abord les yeux",
        principle: "Des braises s'allument au bord. Allez-y des yeux d'abord, puis laissez la tête suivre : elles donnent toute leur chaleur.",
        introduces: [.premierRegard], zone: 0.46,
        lueurs: [LueurDefinition(start: pt(0.3, 0.74), iris: pt(0.7, 0.3), braise: .prototype)],
        oculo: OculoDefinition(stages: [
            .tourner(TournerDefinition(places: [pt(0.82, 0.28), pt(0.18, 0.72), pt(0.82, 0.74), pt(0.18, 0.26), pt(0.5, 0.14), pt(0.5, 0.86)],
                                       order: [0, 1, 2, 3, 4, 5])),
        ], element: .premierRegard),
        gatesProgression: false,
        hints: [LevelHint(.start, "Une braise va s'allumer au bord de l'écran. Laissez vos yeux y aller."),
                LevelHint(.firstOculoSuccess, "Elle vous a donné sa chaleur. Les yeux d'abord, la tête ensuite : c'est là qu'elle en donne le plus."),
                LevelHint(.firstOculoMiss, "Elle s'est éteinte sans vous. La suivante s'allume ailleurs."),
                LevelHint(.oculoCompleted, "Assez de chaleur. La braise dort encore : un regard bref la réveillera."),
                LevelHint(.afterSeconds(45), "Ne tournez pas la tête pour chercher : laissez les yeux trouver, la tête suit d'elle-même.")],
        par: LevelPar(time: 22, intrusions: 3))
}
