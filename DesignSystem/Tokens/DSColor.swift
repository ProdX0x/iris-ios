// DSColor.swift
// Layer: DesignSystem
// Purpose: Colour tokens by role: interface identity, navigation, states, and the chapters' game world (values live
// in the asset catalogue, one colour set per token, named after its family)

import SwiftUI

/// Four families that never share a colour set, so the interface can be recoloured without touching a chapter.
/// `Identity`, `Navigation` and `State` dress the screens around the game; `Chapter` is the game world alone
/// (renderer, chapter palettes and wash, the field behind a level). Several tokens still carry the same value.
enum DSColor {
    /// The interface's own look: grounds, surfaces, hairlines, text, attention accent and the Iris emblem.
    enum Identity {
        // Grounds: encre, abysse, ardoise
        static let ground = Color("ds.identity.ground")
        static let groundAbyss = Color("ds.identity.ground.abyss")
        static let surface = Color("ds.identity.surface")
        static let surfaceElevated = Color("ds.identity.surface.elevated")
        static let line = Color("ds.identity.line")

        // Text: nacre, brume, cendre
        static let textPrimary = Color("ds.identity.text.primary")
        static let textSecondary = Color("ds.identity.text.secondary")
        static let textTertiary = Color("ds.identity.text.tertiary")
        static let textWarm = Color("ds.identity.text.warm")

        // The light Iris puts behind Apple's glass: three very dark spectral fields (ADR-26), never a surface of
        // their own, never drawn over the material
        static let spectralIndigo = Color("ds.identity.spectral.indigo")
        static let spectralViolet = Color("ds.identity.spectral.violet")
        static let spectralFrost = Color("ds.identity.spectral.frost")

        // Attention (ambre) and the emblem's pearl lueur
        static let accent = Color("ds.identity.accent")
        static let emblemCore = Color("ds.identity.emblem.core")
        static let emblemGlow = Color("ds.identity.emblem.glow")
    }

    /// Actions and navigation: buttons, toggles and text actions, the selected item, veils laid over content.
    enum Navigation {
        static let primary = Color("ds.navigation.primary")
        static let onPrimary = Color("ds.navigation.onPrimary")
        static let secondary = Color("ds.navigation.secondary")
        static let control = Color("ds.navigation.control")
        static let selection = Color("ds.navigation.selection")
        static let veil = Color("ds.navigation.veil")
    }

    /// Outcomes told by the interface: menthe, corail, ambre, givre.
    enum State {
        static let success = Color("ds.state.success")
        static let danger = Color("ds.state.danger")
        static let warning = Color("ds.state.warning")
        static let info = Color("ds.state.info")
    }

    /// The game world: what the renderer draws, the chapter palettes and wash, the field behind a level.
    /// The interface around the game never reads these, and the world never reads the other families.
    enum Chapter {
        // Field: encre, abysse
        static let ink = Color("ds.chapter.ink")
        static let abyss = Color("ds.chapter.abyss")

        // Attention (ambre, braise), lueurs, currents and veils
        static let attention = Color("ds.chapter.attention")
        static let attentionDeep = Color("ds.chapter.attention.deep")
        static let lueurCore = Color("ds.chapter.lueur.core")
        static let lueurGlow = Color("ds.chapter.lueur.glow")
        static let maree = Color("ds.chapter.maree")
        static let veil = Color("ds.chapter.veil")

        // Neutral strokes of the world: nacre, cendre, hairline
        static let nacre = Color("ds.chapter.nacre")
        static let cendre = Color("ds.chapter.cendre")
        static let line = Color("ds.chapter.line")

        // Outcomes in the world: a closed iris (menthe), a disturbed lueur (corail)
        static let success = Color("ds.chapter.success")
        static let trouble = Color("ds.chapter.trouble")

        // Chapter identities VII to XII: accent, glow, ground wash
        static let jumellesAccent = Color("ds.chapter.theme.jumelles.accent")
        static let jumellesGlow = Color("ds.chapter.theme.jumelles.glow")
        static let jumellesWash = Color("ds.chapter.theme.jumelles.wash")
        static let brumeAccent = Color("ds.chapter.theme.brume.accent")
        static let brumeGlow = Color("ds.chapter.theme.brume.glow")
        static let brumeWash = Color("ds.chapter.theme.brume.wash")
        static let echoAccent = Color("ds.chapter.theme.echo.accent")
        static let echoGlow = Color("ds.chapter.theme.echo.glow")
        static let echoWash = Color("ds.chapter.theme.echo.wash")
        static let gouffresAccent = Color("ds.chapter.theme.gouffres.accent")
        static let gouffresGlow = Color("ds.chapter.theme.gouffres.glow")
        static let gouffresWash = Color("ds.chapter.theme.gouffres.wash")
        static let braisesAccent = Color("ds.chapter.theme.braises.accent")
        static let braisesGlow = Color("ds.chapter.theme.braises.glow")
        static let braisesWash = Color("ds.chapter.theme.braises.wash")
        static let constellationAccent = Color("ds.chapter.theme.constellation.accent")
        static let constellationGlow = Color("ds.chapter.theme.constellation.glow")
        static let constellationWash = Color("ds.chapter.theme.constellation.wash")

        /// Rank colours (sable, givre, orchidée), 1-based, wrapping after three. Never the only carrier of rank:
        /// rank is always drawn as pips too.
        static func rank(_ sequence: Int) -> Color {
            let index = ((sequence - 1) % 3 + 3) % 3 + 1
            return Color("ds.chapter.rank.\(index)")
        }
    }
}
