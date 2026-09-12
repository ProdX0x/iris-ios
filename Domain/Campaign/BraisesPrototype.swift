// BraisesPrototype.swift
// Layer: Domain
// Purpose: EXPERIMENTAL prototype B1: two levels testing the braise idea, outside the campaign (chapter 0, DEBUG only)

import Foundation

#if DEBUG
enum BraisesPrototype {
    /// Chapter 0 is reserved for experiments; it is never part of `Campaign`.
    static let chapter = ChapterDefinition(
        number: 0, name: "braises · prototype", principle: "Un regard bref la réveille. Un regard long l'affole.", ambientFrequency: 103.83,
        levels: [a, b])

    static var levels: [LevelDefinition] { chapter.levels }

    /// A, discovery: one cold braise, one iris. Does the player understand the gesture?
    static let a = LevelDefinition(
        chapter: 0, index: 1, title: "braise",
        principle: "Elle dort, froide. Votre regard la réveille.",
        zone: 0.46,
        lueurs: [LueurDefinition(start: Campaign.pt(0.5, 0.74), iris: Campaign.pt(0.5, 0.32), braise: .prototype)],
        hints: [LevelHint(.start, "Elle est froide. Regardez-la."),
                LevelHint(.braiseLit, "Elle s'allume et fuit. Laissez-la venir."),
                LevelHint(.braiseFlared, "Trop regardée, elle s'affole."),
                LevelHint(.afterSeconds(30), "Un regard bref suffit. Puis regardez ailleurs.")],
        par: LevelPar(time: 14, intrusions: 4))

    /// B, first mastery (reworked in B1.1): the braise sleeps 120 pt above the iris of a normal lueur that rises to it.
    /// Waking the braise is a gaze that also reaches that iris: wake it before the lueur settles there, or chase the lueur.
    static let b = LevelDefinition(
        chapter: 0, index: 2, title: "deux feux",
        principle: "La 1 monte au centre. La braise dort juste au-dessus.",
        ordered: true, zone: 0.46,
        lueurs: [LueurDefinition(start: Campaign.pt(0.5, 0.86), iris: Campaign.pt(0.5, 0.32)),
                 LueurDefinition(start: Campaign.pt(0.5, 0.18), iris: Campaign.pt(0.2, 0.2), braise: .prototype)],
        hints: [LevelHint(.start, "La braise dort au-dessus de l'iris de la 1."),
                LevelHint(.braiseFlared, "Trop regardée, elle s'affole."),
                LevelHint(.firstLoss, "Votre regard sur la braise a chassé la 1. Réveillez-la avant.")],
        par: LevelPar(time: 15, intrusions: 4))

    static func level(id: String) -> LevelDefinition? {
        levels.first { $0.id == id }
    }

    static func chapter(of level: LevelDefinition) -> ChapterDefinition? {
        level.chapter == chapter.number ? chapter : nil
    }

    static func next(after level: LevelDefinition) -> LevelDefinition? {
        guard let index = levels.firstIndex(where: { $0.id == level.id }), index + 1 < levels.count else { return nil }
        return levels[index + 1]
    }
}
#endif
