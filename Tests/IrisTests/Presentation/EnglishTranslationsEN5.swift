// EnglishTranslationsEN5.swift
// Layer: Tests (support)
// Purpose: Gathers the English of EN-5 — interface, campaign, hints — and keeps it strictly apart from the eighty-nine
// sentences EN-4C already validated. Nothing here may touch a key EN-4C settled: the two tables must not intersect,
// and a test says so

import Foundation

enum EnglishTranslationsEN5 {
    /// Every sentence EN-4 deferred, now written.
    static let byKey: [String: String] = EnglishTranslationsEN5Interface.byKey
        .merging(EnglishTranslationsEN5Campaign.byKey) { a, _ in a }
        .merging(EnglishTranslationsEN5Hints.byKey) { a, _ in a }
        .merging(EnglishTranslationsEN5Readiness.byKey) { a, _ in a }

    /// The English singular of the two counted entries. French keeps one wording at every count — that sentence was
    /// validated and photographed as it stands — while English says « 1 glint » and « 2 glints », which is what the
    /// String Catalog's plural variation is for. No Swift decides this: the catalogue does.
    static let plurals: [String: (one: String, other: String)] = [
        "eclats.outOfThree.value": ("%lld glint out of 3", "%lld glints out of 3"),
        "eclats.total.value": ("%lld glint out of %lld", "%lld glints out of %lld"),
    ]

    /// The one word Iris uses in English for what a level awards.
    static let eclatTerm = "glint"

    /// French and English legitimately identical, EN-5 side. Each one is a word the two languages share — a
    /// constellation is a constellation, an iris is an iris — or a format made of punctuation alone. Listed key by
    /// key so that an untranslated sentence cannot hide among them.
    static let identicalByDesign: Set<String> = Set([
        "chapter.12.name",                    // constellation
        "gazeSetup.calibration.eyebrow",      // calibration — the same word in both languages
        "result.intrusions.label",            // intrusions — the same word in both languages
        "element.absence.name",               // absence
        "element.cascade.name",               // cascade
        "element.iris.name",                  // iris — the word Iris is named after, kept in both languages
        "gazeAssistance.mode.visible.title",  // Visible
        "gazeStatus.line",                    // %@.
        "level.6-5.title",                    // constellation
        "level.6-6.title",                    // iris
    ])
    .union(EnglishTranslationsEN5Readiness.identicalByDesign)
}
