// DSColor.swift
// Layer: DesignSystem
// Purpose: Semantic colour tokens of the "chambre noire" identity (values live in the asset catalogue)

import SwiftUI

enum DSColor {
    // Grounds: encre, abysse, ardoise
    static let backgroundPrimary = Color("ds.background.primary")
    static let backgroundSurface = Color("ds.background.surface")
    static let backgroundElevated = Color("ds.background.elevated")
    static let lineSubtle = Color("ds.line.subtle")

    // Text: nacre, brume, cendre
    static let textPrimary = Color("ds.text.primary")
    static let textSecondary = Color("ds.text.secondary")
    static let textTertiary = Color("ds.text.tertiary")
    static let textWarm = Color("ds.text.warm")
    static let textOnAccent = Color("ds.text.onAccent")

    // Attention (ambre, braise) and outcomes (menthe, corail)
    static let accent = Color("ds.accent")
    static let accentDeep = Color("ds.accent.deep")
    static let statusSuccess = Color("ds.status.success")
    static let statusDanger = Color("ds.status.danger")
    static let statusInfo = Color("ds.status.info")

    // Game world
    static let fieldInk = Color("ds.field.ink")
    static let fieldAbyss = Color("ds.field.abyss")
    static let lueurCore = Color("ds.lueur.core")
    static let lueurGlow = Color("ds.lueur.glow")
    static let maree = Color("ds.maree")
    static let veil = Color("ds.veil")

    // Chapter identities (expansion): accent, glow, ground wash
    static let themeJumellesAccent = Color("ds.theme.jumelles.accent")
    static let themeJumellesGlow = Color("ds.theme.jumelles.glow")
    static let themeJumellesWash = Color("ds.theme.jumelles.wash")

    /// Rank colours (sable, givre, orchidée), 1-based, wrapping after three. Never the only carrier of rank:
    /// rank is always drawn as pips too.
    static func rank(_ sequence: Int) -> Color {
        let index = ((sequence - 1) % 3 + 3) % 3 + 1
        return Color("ds.rank.\(index)")
    }
}
