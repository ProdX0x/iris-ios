// Campaign.swift
// Layer: Domain
// Purpose: The authored campaign: the six historical chapters (34 levels, frozen; see Design/LEVEL_DESIGN_SYSTEM.md)
// followed by the expansion chapters (VII and beyond, Design/IRIS_FULL_EXPANSION_REPORT.md)

import Foundation

enum Campaign {
    /// Chapters I to VI exactly as validated: never edited, protected by the historical fingerprint tests.
    static let historicalChapters: [ChapterDefinition] = [eveil, partage, courants, voiles, veilleuses, clairvoyance]

    /// Chapters VII and beyond, played after the historical campaign in the same progression.
    static let expansionChapters: [ChapterDefinition] = [jumelles, souffles]

    static let chapters: [ChapterDefinition] = historicalChapters + expansionChapters

    static let historicalLevels: [LevelDefinition] = historicalChapters.flatMap(\.levels)

    static let levels: [LevelDefinition] = chapters.flatMap(\.levels)

    static func level(id: String) -> LevelDefinition? {
        levels.first { $0.id == id }
    }

    static func chapter(number: Int) -> ChapterDefinition? {
        chapters.first { $0.number == number }
    }

    static func chapter(of level: LevelDefinition) -> ChapterDefinition? {
        chapter(number: level.chapter)
    }

    static func next(after level: LevelDefinition) -> LevelDefinition? {
        guard let index = levels.firstIndex(where: { $0.id == level.id }), index + 1 < levels.count else { return nil }
        return levels[index + 1]
    }

    static func isLastInChapter(_ level: LevelDefinition) -> Bool {
        chapter(of: level)?.levels.last?.id == level.id
    }

    /// Shorthand for authored coordinates.
    static func pt(_ x: Double, _ y: Double) -> NormalizedPoint {
        NormalizedPoint(x: x, y: y)
    }

    static func band(_ minX: Double, _ minY: Double, _ maxX: Double, _ maxY: Double) -> NormalizedRect {
        NormalizedRect(minX: minX, minY: minY, maxX: maxX, maxY: maxY)
    }

    static let down = Vector2(x: 0, y: 1)
    static let up = Vector2(x: 0, y: -1)
    static let left = Vector2(x: -1, y: 0)
    static let right = Vector2(x: 1, y: 0)
}
