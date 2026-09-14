// Campaign+FinalEchos.swift
// Layer: Domain
// Purpose: OCULOMOTOR EXPANSION, chapter IX final « l'absence » (fixation disengagement, gap and overlap shifts): a
// presence holds while the gaze stays; another answers elsewhere, sometimes after a silence, sometimes while the first
// still sings; the gaze leaves for the answer, which becomes the next presence

import Foundation

extension Campaign {
    static let finalEchos = LevelDefinition(
        chapter: 9, index: 7, title: "l'absence",
        principle: "Une présence tient tant que vous la regardez. Quand une autre lui répond, parfois après un silence, allez à elle.",
        introduces: [.absence], zone: 0.46,
        lueurs: [LueurDefinition(start: pt(0.5, 0.12), iris: pt(0.5, 0.42)),
                 LueurDefinition(start: pt(0.5, 0.62), iris: pt(0.5, 0.86), asleep: true)],
        echo: .standard,
        oculo: OculoDefinition(stages: [
            .absence(AbsenceDefinition(
                places: [pt(0.5, 0.5), pt(0.8, 0.3), pt(0.2, 0.72), pt(0.5, 0.16), pt(0.8, 0.72), pt(0.2, 0.3), pt(0.5, 0.84)],
                trials: [.init(0, 1, .gap), .init(1, 2, .overlap), .init(2, 0, .gap), .init(0, 3, .overlap),
                         .init(3, 4, .gap), .init(4, 5, .overlap), .init(5, 6, .gap), .init(6, 0, .overlap)])),
        ], element: .absence),
        gatesProgression: false,
        hints: [LevelHint(.start, "Une présence au centre. Posez-y le regard, et restez."),
                LevelHint(.firstOculoSuccess, "Elle a répondu et vous l'avez rejointe. Restez avec elle : une autre viendra."),
                LevelHint(.firstOculoMiss, "La réponse s'est éteinte. Revenez à la présence : elle rappellera."),
                LevelHint(.oculoCompleted, "Les échos se sont tous répondu. Les lueurs s'éveillent : laissez l'écho faire le reste."),
                LevelHint(.afterSeconds(45), "Quand la réponse paraît, quittez la première, même si elle brille encore.")],
        par: LevelPar(time: 37, intrusions: 12))
}
