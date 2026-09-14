// Campaign+FinalVoiles.swift
// Layer: Domain
// Purpose: OCULOMOTOR EXPANSION, chapter IV final « le miroir menteur » (anti-saccade): a lure flashes on one side,
// the door opens on the opposite side; going to the lure closes the door, the cycle repeats without punishment

import Foundation

extension Campaign {
    static let finalVoiles = LevelDefinition(
        chapter: 4, index: 7, title: "le miroir menteur",
        principle: "Un éclat appelle le regard d'un côté ; la porte s'ouvre de l'autre. Le voile ne cède qu'aux portes.",
        introduces: [.miroir], zone: 0.48,
        lueurs: [LueurDefinition(start: pt(0.15, 0.12), iris: pt(0.7, 0.72), route: [pt(0.2, 0.56), pt(0.5, 0.64)])],
        veils: [VeilDefinition(a: pt(0.32, 0.46), b: pt(0.8, 0.46))],
        oculo: OculoDefinition(stages: [
            .miroir(MiroirDefinition(right: pt(0.82, 0.5), left: pt(0.18, 0.5), top: pt(0.5, 0.16), bottom: pt(0.5, 0.84),
                                     cycles: [.right, .top, .right, .bottom, .left, .top, .left, .bottom])),
        ], element: .miroir),
        gatesProgression: false,
        hints: [LevelHint(.start, "Un éclat va briller. La porte, elle, s'ouvre en face."),
                LevelHint(.firstOculoMiss, "L'éclat mentait. La porte se rouvrira : allez en face."),
                LevelHint(.firstOculoSuccess, "La porte a cédé. Chaque éclat en annonce une autre, toujours en face."),
                LevelHint(.oculoCompleted, "Toutes les portes ont cédé. L'iris s'ouvre : contournez le voile."),
                LevelHint(.afterSeconds(45), "Ne regardez pas ce qui brille. Regardez là où il ne brille pas.")],
        par: LevelPar(time: 36, intrusions: 3))
}
