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
    static let chambreNoire = DSThemePalette(accent: DSColor.accent, glow: DSColor.lueurGlow, wash: nil)
    /// Chapter VII, jumelles: rose over plum.
    static let jumelles = DSThemePalette(accent: DSColor.themeJumellesAccent, glow: DSColor.themeJumellesGlow, wash: DSColor.themeJumellesWash)
    /// Chapter VIII, souffles: pale cyan over teal ink.
    static let brume = DSThemePalette(accent: DSColor.themeBrumeAccent, glow: DSColor.themeBrumeGlow, wash: DSColor.themeBrumeWash)
}
