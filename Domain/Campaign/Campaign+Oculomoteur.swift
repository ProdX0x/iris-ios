// Campaign+Oculomoteur.swift
// Layer: Domain
// Purpose: PROTOTYPE, branch prototype/ch1-oculomotor-level6 only: chapter I level 6, a thread of balises around a
// shut iris. The thread's order makes the gaze travel centre, right, left, centre, up, down, centre, then alternate
// right/left and up/down; the level never names a direction to the player. Levels 1 to 5 are the frozen `eveil`.

import Foundation

extension Campaign {
    /// Balise indices of the thread.
    enum OculomotorBalise: Int, CaseIterable {
        case centre = 0
        case droite = 1
        case gauche = 2
        case haut = 3
        case bas = 4
    }

    static let oculomotorDwell: TimeInterval = 0.25

    static let oculomoteur = LevelDefinition(
        chapter: 1, index: 6, title: "le fil des balises",
        principle: "L'iris est éteint. Éveillez chaque balise que le fil désigne ; le fil complet l'ouvrira.",
        introduces: [.balise], zone: 0.50,
        lueurs: [LueurDefinition(start: pt(0.18, 0.12), iris: pt(0.5, 0.5))],
        balises: BaliseSequenceDefinition(
            balises: [BaliseDefinition(name: "CENTER", position: pt(0.5, 0.5)),
                      BaliseDefinition(name: "RIGHT", position: pt(0.82, 0.5)),
                      BaliseDefinition(name: "LEFT", position: pt(0.18, 0.5)),
                      BaliseDefinition(name: "TOP", position: pt(0.5, 0.16)),
                      BaliseDefinition(name: "BOTTOM", position: pt(0.5, 0.84))],
            // centre → droite → gauche → centre → haut → bas → centre, puis droite/gauche ×2, haut/bas ×2, centre.
            steps: [0, 1, 2, 0, 3, 4, 0, 1, 2, 1, 2, 3, 4, 3, 4, 0],
            dwell: oculomotorDwell, radius: 0.2, releaseRadius: 0.27),
        gatesProgression: false,
        hints: [LevelHint(.start, "Une balise respire au centre. Posez-y le regard."),
                LevelHint(.firstBalise, "Elle tend un fil. Suivez-le du regard, balise après balise."),
                LevelHint(.balisesCompleted, "Le fil est complet : l'iris s'ouvre et une lueur s'éveille. Laissez-la venir."),
                LevelHint(.afterSeconds(40), "Seule la balise qui respire peut s'éveiller. Restez posé dessus un instant.")],
        par: LevelPar(time: 26, intrusions: 2))

    /// Chapter I as played on this branch: the five frozen levels, then the prototype.
    static let eveilAvecPrototype = ChapterDefinition(
        number: eveil.number, name: eveil.name, principle: eveil.principle, ambientFrequency: eveil.ambientFrequency,
        theme: eveil.theme, levels: eveil.levels + [oculomoteur])
}
