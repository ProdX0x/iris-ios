// CampaignText.swift
// Layer: Presentation (shared)
// Purpose: Localisation keys for the game content, derived from what a thing IS — a chapter number, a level id, an
// element case — and never from what it says. Rewording a French sentence never moves its key. The French values stay
// where they have always been, in Domain/Campaign, which this file does not touch and must never need to

import Foundation

enum CampaignText {
    /// Which sentence of a piece of content a key names.
    enum Field: String {
        case name
        case title
        case principle
        case summary
        case condition
    }

    // MARK: - Keys, derived from identity

    static func key(chapter number: Int, _ field: Field) -> String { "chapter.\(number).\(field.rawValue)" }

    static func key(level id: String, _ field: Field) -> String { "level.\(id).\(field.rawValue)" }

    static func key(element: GameElement, _ field: Field) -> String { "element.\(element.rawValue).\(field.rawValue)" }

    static func key(eclat: Eclat, _ field: Field) -> String { "eclat.\(eclat.rawValue).\(field.rawValue)" }

    // MARK: - The text a screen shows

    static func name(of chapter: ChapterDefinition) -> String {
        IrisText.gameplay(key(chapter: chapter.number, .name), french: chapter.name)
    }

    static func principle(of chapter: ChapterDefinition) -> String {
        IrisText.gameplay(key(chapter: chapter.number, .principle), french: chapter.principle)
    }

    static func title(of level: LevelDefinition) -> String {
        IrisText.gameplay(key(level: level.id, .title), french: level.title)
    }

    static func principle(of level: LevelDefinition) -> String {
        IrisText.gameplay(key(level: level.id, .principle), french: level.principle)
    }

    static func name(of element: GameElement) -> String {
        IrisText.gameplay(key(element: element, .name), french: element.name)
    }

    static func summary(of element: GameElement) -> String {
        IrisText.gameplay(key(element: element, .summary), french: element.summary)
    }

    static func title(of eclat: Eclat) -> String {
        IrisText.gameplay(key(eclat: eclat, .title), french: eclat.title)
    }

    static func condition(of eclat: Eclat) -> String {
        IrisText.gameplay(key(eclat: eclat, .condition), french: eclat.condition)
    }
}
