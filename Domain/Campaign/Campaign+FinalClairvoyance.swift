// Campaign+FinalClairvoyance.swift
// Layer: Domain
// Purpose: OCULOMOTOR EXPANSION, chapter VI final « le jardin caché » (visual search, systematic scanning): among
// twelve seeds spread over the whole field, a few breathe; the gaze finds them and they sprout, batch after batch,
// until the garden opens onto a gliding iris

import Foundation

extension Campaign {
    /// Twelve seeds on a loose three-by-four grid, slightly offset so the garden does not look like a board.
    static let jardinSeeds: [NormalizedPoint] = [
        pt(0.20, 0.17), pt(0.51, 0.19), pt(0.80, 0.16),
        pt(0.18, 0.40), pt(0.49, 0.41), pt(0.82, 0.39),
        pt(0.21, 0.62), pt(0.50, 0.63), pt(0.79, 0.61),
        pt(0.19, 0.84), pt(0.52, 0.83), pt(0.81, 0.85),
    ]

    static let finalClairvoyance = LevelDefinition(
        chapter: 6, index: 7, title: "le jardin caché",
        principle: "Des graines partout. Quelques-unes respirent : trouvez-les du regard, elles poussent.",
        introduces: [.jardin], zone: 0.48,
        lueurs: [LueurDefinition(start: pt(0.5, 0.1), iris: pt(0.3, 0.5), irisMotion: .oscillate(to: pt(0.7, 0.5), period: 7))],
        oculo: OculoDefinition(stages: [
            // Each batch's two breathing seeds sit far apart, and never side by side in reading order.
            .jardin(JardinDefinition(seeds: jardinSeeds, batches: [[0, 10], [2, 9], [3, 8], [7, 4]])),
        ], element: .jardin),
        gatesProgression: false,
        hints: [LevelHint(.start, "Toutes scintillent. Cherchez celles qui respirent lentement."),
                LevelHint(.firstOculoSuccess, "Elle pousse. Une autre respire quelque part."),
                LevelHint(.firstOculoMiss, "Celle-ci ne faisait que scintiller : les pousses se sont repliées. Cherchez encore."),
                LevelHint(.oculoCompleted, "Le jardin est ouvert. L'iris glisse : laissez la lueur le rejoindre."),
                LevelHint(.afterSeconds(40), "Un coup d'œil ne coûte rien. Seules les graines qui respirent méritent qu'on s'y attarde.")],
        par: LevelPar(time: 21, intrusions: 2))
}
