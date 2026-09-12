// BraisesPrototype.swift
// Layer: Domain
// Purpose: EXPERIMENTAL, human-validated prototype Braises A: one level testing the braise idea, outside the campaign (chapter 0, DEBUG only)

import Foundation

#if DEBUG
enum BraisesPrototype {
    /// Chapter 0 is reserved for experiments; it is never part of `Campaign`.
    static let chapter = ChapterDefinition(
        number: 0, name: "braises · prototype", principle: "Un regard bref la réveille. Un regard long l'affole.", ambientFrequency: 103.83,
        levels: [a])

    static var levels: [LevelDefinition] { chapter.levels }

    /// A, discovery: one cold braise, one iris. Validated on device on 12 September 2026 (Design/BRAISES_VALIDATION_STATUS.md); frozen.
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
