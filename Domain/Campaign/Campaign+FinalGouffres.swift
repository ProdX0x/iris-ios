// Campaign+FinalGouffres.swift
// Layer: Domain
// Purpose: OCULOMOTOR EXPANSION, chapter X final « l'ancre » (gaze stabilisation, VOR-inspired): the gaze holds an
// anchor above the abyss while small, comfortable head turns steer a compass around it into each band

import Foundation

extension Campaign {
    static let finalGouffres = LevelDefinition(
        chapter: 10, index: 7, title: "l'ancre",
        principle: "Gardez les yeux sur l'ancre. Tournez doucement la tête : la boussole suit, jusqu'à l'arc qui s'allume.",
        introduces: [.ancre], zone: 0.46,
        // The released lueur meets the abyss exactly as in chapter X's first level; the anchor floats above it.
        lueurs: [LueurDefinition(start: pt(0.5, 0.12), iris: pt(0.5, 0.8), route: [pt(0.24, 0.5)])],
        gouffres: [GouffreDefinition(center: pt(0.5, 0.5), radius: 0.11, pull: 0.24)],
        oculo: OculoDefinition(stages: [
            .ancre(AncreDefinition(anchor: pt(0.5, 0.26), bands: [
                .init(.yaw, .first), .init(.yaw, .opposite), .init(.pitch, .first), .init(.pitch, .opposite),
                .init(.yaw, .same), .init(.pitch, .opposite),
            ])),
        ], element: .ancre),
        gatesProgression: false,
        hints: [LevelHint(.start, "Les yeux sur l'ancre. Tournez un peu la tête, sans la quitter du regard."),
                LevelHint(.firstOculoSuccess, "L'arc a tenu. Revenez face à l'écran : un autre arc s'allume."),
                LevelHint(.firstOculoMiss, "Le regard a quitté l'ancre. Gardez-la sous les yeux pendant que la tête tourne."),
                LevelHint(.oculoCompleted, "L'ancre tient. La lueur s'éveille : faites-lui contourner le gouffre."),
                LevelHint(.afterSeconds(45), "Un petit mouvement suffit, comme pour regarder par-dessus une épaule, les yeux restant posés.")],
        par: LevelPar(time: 25, intrusions: 3))
}
