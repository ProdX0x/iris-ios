// ChapterTheme.swift
// Layer: Domain
// Purpose: The visual identity a chapter asks for: the historical chapters keep the chambre noire untouched,
// every expansion chapter (VII and beyond) names the tint the presentation washes over it

import Foundation

enum ChapterTheme: String, Hashable, Sendable, CaseIterable {
    /// Chapters I to VI: ink ground, amber attention, no wash. Rendering is exactly the historical one.
    case chambreNoire
    /// Chapter VII, jumelles: rose attention over a plum ground.
    case jumelles
    /// Chapter VIII, souffles: pale cyan over a teal ink (brume).
    case brume
    /// Chapter IX, échos: chartreuse over a moss ink.
    case echo
    /// Chapter X, gouffres: lavender over a violet abyss.
    case gouffres
    /// Chapter XI, braises: ember orange over a burnt ink.
    case braises
}
