// Campaign+FinalGouffres.swift
// Layer: Domain
// Purpose: OCULOMOTOR EXPANSION, chapter X final « l'ancre » (gaze stabilisation while the head moves, VOR-inspired):
// the eyes hold a point at the centre of a silhouette while the head draws one slow circle around it, then the same
// circle the other way; the released lueur then drifts into its iris on its own

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
            .ancre(AncreDefinition(anchor: pt(0.5, 0.47), start: .left)),
        ], element: .ancre, pause: 1.8, help: "C'est la tête qui dessine le cercle ; les yeux restent sur le point."),
        gatesProgression: false,
        hints: [LevelHint(.start, "Regardez le point au centre."),
                LevelHint(.firstOculoSuccess, "Les yeux sur le point, tournez doucement la tête : à droite, puis en rond."),
                LevelHint(.firstOculoMiss, "Gardez les yeux sur le point pendant que la tête tourne."),
                LevelHint(.oculoStageCompleted(0), "Tour complet ! Recommencez dans l'autre sens, par la gauche."),
                LevelHint(.oculoCompleted, "Les deux tours sont faits. La lueur s'éveille."),
                LevelHint(.afterSeconds(30), "Un petit mouvement suffit : l'anneau se remplit quand la tête suit le cercle.")],
        par: LevelPar(time: 81, intrusions: 2))
}
