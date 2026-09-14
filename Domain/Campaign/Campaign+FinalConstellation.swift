// Campaign+FinalConstellation.swift
// Layer: Domain
// Purpose: OCULOMOTOR EXPANSION, chapter XII final « l'orchestre du regard » (multi-modal oculomotor sequencing):
// seven short passages, each a gaze idea met in the chapters before (fixation, transfer, pursuit, search, memory,
// diagonals, eye-head), each lighting one star of a constellation that comes alive at the end

import Foundation

extension Campaign {
    static let finalConstellation = LevelDefinition(
        chapter: 12, index: 7, title: "l'orchestre du regard",
        principle: "Tout ce que vos yeux ont appris, d'un seul souffle. Chaque passage allume une étoile.",
        introduces: [.orchestre], zone: 0.46,
        lueurs: [LueurDefinition(start: pt(0.25, 0.2), iris: pt(0.4, 0.55), twin: 2),
                 LueurDefinition(start: pt(0.75, 0.2), iris: pt(0.6, 0.55), twin: 1)],
        oculo: OculoDefinition(stages: [
            // Fixation: the heart, two sparks.
            .coeur(CoeurDefinition(position: pt(0.5, 0.45), requirement: 2.5, distractors: [pt(0.8, 0.2), pt(0.2, 0.75)],
                                   distractorPeriod: 1.6, distractorDuration: 0.9, firstDistractorAt: 0.8)),
            // Transfer: one answer after a silence, one while the presence still sings.
            .absence(AbsenceDefinition(places: [pt(0.5, 0.45), pt(0.8, 0.24), pt(0.22, 0.7)], trials: [.init(0, 1, .gap), .init(1, 2, .overlap)])),
            // Pursuit: the living thread, briefly.
            .fil(FilDefinition(center: pt(0.5, 0.5), amplitudeX: 0.28, amplitudeY: 0.26, phase: .pi / 3, wobble: 0.04, period: 9, requirement: 3)),
            // Search: two breathing seeds among eight.
            .jardin(JardinDefinition(seeds: [pt(0.2, 0.2), pt(0.5, 0.18), pt(0.8, 0.2), pt(0.2, 0.5), pt(0.8, 0.5), pt(0.2, 0.8), pt(0.5, 0.82), pt(0.8, 0.8)],
                                     batches: [[1, 6]])),
            // Memory: three stars, once.
            .etoiles(EtoilesDefinition(candidates: [pt(0.5, 0.16), pt(0.82, 0.4), pt(0.7, 0.8), pt(0.3, 0.8), pt(0.18, 0.4)], rounds: [[0, 2, 4]])),
            // Diagonals: middle then far.
            .croisement(CroisementDefinition(center: pt(0.5, 0.5), legs: [.init(.falling, dx: 0.24, dy: 0.18), .init(.rising, dx: 0.32, dy: 0.32)])),
            // Eyes then head: two braises.
            .tourner(TournerDefinition(places: [pt(0.82, 0.3), pt(0.18, 0.72)], order: [0, 1], goal: 2)),
        ], element: .orchestre, pause: 0.8, showsConstellation: true),
        gatesProgression: false,
        hints: [LevelHint(.start, "Un cœur de verre. Posez le regard, comme au début."),
                LevelHint(.firstOculoSuccess, "Une étoile s'allume. Chaque passage en allume une autre."),
                LevelHint(.oculoCompleted, "La constellation est entière. Les jumelles descendent la rejoindre."),
                LevelHint(.afterSeconds(60), "Chaque passage est un souvenir : le cœur, la réponse, le fil, le jardin, les étoiles, les jumelles, la braise.")],
        par: LevelPar(time: 54, intrusions: 4))
}
