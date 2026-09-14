// DSThemePalette.swift
// Layer: DesignSystem
// Purpose: The few colours a chapter identity adds to the chambre noire: its attention accent, its glow, and the
// wash tinting the ground (values live in the asset catalogue as ds.theme.* colour sets)

import SwiftUI

struct DSThemePalette: Hashable, Sendable {
    /// Attention colour of the chapter (numerals, eyebrows, new elements).
    let accent: Color
    /// Halo colour of the chapter's own elements.
    let glow: Color
    /// Ground tint washed over the chambre noire; nil leaves the historical ground exactly as it is.
    let wash: Color?

    init(accent: Color, glow: Color, wash: Color?) {
        self.accent = accent
        self.glow = glow
        self.wash = wash
    }

    /// Chapters I to VI: the historical tokens, no wash.
    static let chambreNoire = DSThemePalette(accent: DSColor.Chapter.attention, glow: DSColor.Chapter.lueurGlow, wash: nil)
    /// Chapter VII, jumelles: rose over plum.
    static let jumelles = DSThemePalette(accent: DSColor.Chapter.jumellesAccent, glow: DSColor.Chapter.jumellesGlow, wash: DSColor.Chapter.jumellesWash)
    /// Chapter VIII, souffles: pale cyan over teal ink.
    static let brume = DSThemePalette(accent: DSColor.Chapter.brumeAccent, glow: DSColor.Chapter.brumeGlow, wash: DSColor.Chapter.brumeWash)
    /// Chapter IX, échos: chartreuse over moss ink.
    static let echo = DSThemePalette(accent: DSColor.Chapter.echoAccent, glow: DSColor.Chapter.echoGlow, wash: DSColor.Chapter.echoWash)
    /// Chapter X, gouffres: lavender over a violet abyss.
    static let gouffres = DSThemePalette(accent: DSColor.Chapter.gouffresAccent, glow: DSColor.Chapter.gouffresGlow, wash: DSColor.Chapter.gouffresWash)
    /// Chapter XI, braises: ember orange over burnt ink.
    static let braises = DSThemePalette(accent: DSColor.Chapter.braisesAccent, glow: DSColor.Chapter.braisesGlow, wash: DSColor.Chapter.braisesWash)
    /// Chapter XII, constellation: silver over the deepest night.
    static let constellation = DSThemePalette(accent: DSColor.Chapter.constellationAccent, glow: DSColor.Chapter.constellationGlow, wash: DSColor.Chapter.constellationWash)
}
