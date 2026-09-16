// AccessPolicy.swift
// Layer: Domain
// Purpose: The one business rule of the commercial model: how many chapters are free, and whether a chapter or a
// level is open for a given entitlement. THE single place the free chapter count is written

import Foundation

enum AccessPolicy {
    /// THE source of the commercial model: chapters I to III are free. No view and no service may write this number
    /// again; they ask this policy (CommerceBoundaryTests holds the guarantee).
    static let freeChapterCount = 3

    /// Chapter numbers open without any purchase.
    static let freeChapterNumbers: ClosedRange<Int> = 1...freeChapterCount

    static func isFree(chapterNumber: Int) -> Bool {
        freeChapterNumbers.contains(chapterNumber)
    }

    static func isAccessible(chapterNumber: Int, with entitlement: AccessEntitlement) -> Bool {
        entitlement.opensWholeCampaign || isFree(chapterNumber: chapterNumber)
    }

    static func isAccessible(_ chapter: ChapterDefinition, with entitlement: AccessEntitlement) -> Bool {
        isAccessible(chapterNumber: chapter.number, with: entitlement)
    }

    /// Experimental levels (chapter 0, the DEBUG prototypes) stand outside the campaign and outside the model.
    static func isAccessible(_ level: LevelDefinition, with entitlement: AccessEntitlement) -> Bool {
        level.isExperimental || isAccessible(chapterNumber: level.chapter, with: entitlement)
    }

    /// The chapters a player without any purchase may open, in campaign order.
    static func freeChapters(in chapters: [ChapterDefinition]) -> [ChapterDefinition] {
        chapters.filter { isFree(chapterNumber: $0.number) }
    }

    /// The chapters the full access opens, in campaign order.
    static func paidChapters(in chapters: [ChapterDefinition]) -> [ChapterDefinition] {
        chapters.filter { !isFree(chapterNumber: $0.number) }
    }
}
