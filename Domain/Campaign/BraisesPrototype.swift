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

    /// B, first mastery: a normal lueur settles first; the braise must be fed from where the settled lueur is not troubled.
    static let b = LevelDefinition(
        chapter: 0, index: 2, title: "deux feux",
        principle: "La 1 se pose. Réveillez la 2 sans chasser la 1.",
        ordered: true, zone: 0.46,
        lueurs: [LueurDefinition(start: Campaign.pt(0.22, 0.86), iris: Campaign.pt(0.5, 0.5)),
                 LueurDefinition(start: Campaign.pt(0.76, 0.86), iris: Campaign.pt(0.62, 0.36), braise: .prototype)],
        hints: [LevelHint(.start, "D'abord la 1. La 2 dort."),
                LevelHint(.braiseFlared, "Trop regardée, elle s'affole."),
                LevelHint(.firstLoss, "La 1 a perdu sa place : réveillez la 2 de plus loin.")],
        par: LevelPar(time: 22, intrusions: 7))

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
