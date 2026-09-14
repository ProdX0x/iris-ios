// Campaign+FinalPartage.swift
// Layer: Domain
// Purpose: OCULOMOTOR EXPANSION, chapter II final « le cœur de verre » (fixation stability, distractor inhibition):
// a cold heart at the centre warms under a gaze that stays; sparks flare around it to tempt the gaze away

import Foundation

extension Campaign {
    static let finalPartage = LevelDefinition(
        chapter: 2, index: 6, title: "le cœur de verre",
        principle: "Un cœur froid. Votre regard, s'il reste, le réchauffe ; ce qui brille autour le refroidit.",
        introduces: [.coeur], zone: 0.48,
        lueurs: [LueurDefinition(start: pt(0.15, 0.12), iris: pt(0.32, 0.62)),
                 LueurDefinition(start: pt(0.85, 0.12), iris: pt(0.68, 0.62))],
        oculo: OculoDefinition(stages: [
            .coeur(CoeurDefinition(position: pt(0.5, 0.42),
                                   distractors: [pt(0.82, 0.22), pt(0.18, 0.66), pt(0.5, 0.86), pt(0.84, 0.6), pt(0.16, 0.2), pt(0.5, 0.1), pt(0.82, 0.8), pt(0.18, 0.42)],
                                   distractorPeriod: 2.4, distractorDuration: 1.1, distractorPenalty: 0.6, firstDistractorAt: 3)),
        ], element: .coeur),
        gatesProgression: false,
        hints: [LevelHint(.start, "Un cœur de verre, froid. Posez-y le regard et laissez-le se réchauffer."),
                LevelHint(.firstOculoMiss, "Une étincelle vous a pris le regard : le cœur a refroidi un peu."),
                LevelHint(.oculoCompleted, "Le cœur s'ouvre. Deux lueurs s'éveillent : laissez-les venir."),
                LevelHint(.afterSeconds(40), "Ce qui brille autour ne compte pas. Seul le cœur.")],
        par: LevelPar(time: 25, intrusions: 4))
}
