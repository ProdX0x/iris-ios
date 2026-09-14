// Campaign+FinalGouffres.swift
// Layer: Domain
// Purpose: OCULOMOTOR EXPANSION, chapter X final « l'ancre » (gaze stabilisation while the head moves, VOR-inspired): a
// fixation of the point, one slow circle of the head around it, a new fixation, the same circle the other way, a closing
// fixation. The eyes are checked before and after each circle; the head alone draws it. The released lueur then drifts
// into its iris on its own

import Foundation

extension Campaign {
    static let finalGouffres = LevelDefinition(
        chapter: 10, index: 7, title: "l'ancre",
        principle: "Regardez le point au centre.\nGardez vos yeux dessus et tournez doucement la tête en rond.\nFaites le tour complet, puis recommencez dans l'autre sens.",
        introduces: [.ancre], zone: 0.46,
        // Above the silhouette, clear of the camera housing and far from the point: no push once the two loops are done.
        lueurs: [LueurDefinition(start: pt(0.36, 0.15), iris: pt(0.64, 0.15))],
        oculo: OculoDefinition(stages: [
            .ancre(AncreDefinition(anchor: pt(0.5, 0.47), start: .right)),
            .ancre(AncreDefinition(anchor: pt(0.5, 0.47), start: .left, fixation: 0.7, closingFixation: 0.7)),
        ], element: .ancre, pause: 1.8, help: "Un petit mouvement suffit : l'anneau se remplit quand la tête suit le cercle."),
        gatesProgression: false,
        hints: [LevelHint(.start, "Gardez les yeux sur le point."),
                LevelHint(.firstOculoSuccess, "Maintenant, dessinez le cercle avec la tête, en partant vers la droite."),
                LevelHint(.oculoStageCompleted(0), "Tour complet ! Revenez de face, les yeux sur le point."),
                LevelHint(.oculoSuccessInStage(stage: 1, ordinal: 1), "Maintenant, le cercle dans l'autre sens, en partant vers la gauche."),
                LevelHint(.oculoSuccessInStage(stage: 1, ordinal: 6), "Les yeux sur le point, une dernière fois."),
                LevelHint(.oculoCompleted, "Les deux cercles sont faits. La lueur s'éveille."),
                LevelHint(.afterSeconds(30), "Les yeux restent sur le point ; c'est la tête qui dessine le cercle.")],
        par: LevelPar(time: 82, intrusions: 2))
}
