// DSGlassRole.swift
// Layer: DesignSystem
// Purpose: The four intentions of glass in Iris (clear control, regular panel, chrome, prominent action): each role
// owns its native glass, its shape, and the plain surfaces that stand in for it before iOS 26. Apple's own surfaces
// (tab bar, toolbars, glass button styles) carry the system's glass and take no role

import SwiftUI

enum DSGlassRole: CaseIterable, Hashable, Sendable {
    /// Small floating icon controls (pause, close, settings): the clearest glass, compact, never a coloured slab.
    case clearControl
    /// Panels holding text (pause, introduction, result): more present than a control, the ground still perceptible.
    case regularPanel
    /// One of Iris's own floating containers over live content (the hint above the game). System bars draw their
    /// own glass and never use this role.
    case chrome
    /// The one main action of a screen. Native prominence comes from the system's `.glassProminent` button style;
    /// this role describes the capsule painted in its place before iOS 26 and under Reduce Transparency.
    case prominentAction

    /// The native glass of the role: Apple's two variants, untinted. Iris tints the system's prominent button style,
    /// never the material of a panel (the tinted capsule compared in the phase 2B gallery was rejected).
    var recipe: DSGlassRecipe {
        switch self {
        case .clearControl: DSGlassRecipe(.clear, interactive: true)
        case .regularPanel: DSGlassRecipe(.regular)
        case .chrome: DSGlassRecipe(.regular)
        case .prominentAction: DSGlassRecipe(.regular, interactive: true)
        }
    }

    var defaultShape: DSGlassShape {
        switch self {
        case .clearControl: .circle
        case .regularPanel: .rounded(DSRadius.l)
        case .chrome: .capsule
        case .prominentAction: .capsule
        }
    }

    /// Fill of the plain surface standing in for glass: light where Liquid Glass is unavailable, opaque under
    /// Reduce Transparency. Native glass has no fill of its own.
    func fill(_ rendering: DSGlassRendering) -> Color {
        switch (self, rendering) {
        case (_, .native): .clear
        case (.clearControl, .translucent): DSColor.Identity.surface.opacity(0.6)
        case (.regularPanel, .translucent): DSColor.Identity.surface.opacity(0.88)
        case (.chrome, .translucent): DSColor.Identity.surfaceElevated.opacity(0.92)
        case (.clearControl, .opaque), (.chrome, .opaque): DSColor.Identity.surfaceElevated
        case (.regularPanel, .opaque): DSColor.Identity.surface
        case (.prominentAction, _): DSColor.Navigation.primary
        }
    }

    /// Default colour of the content: the interface's text, or the text laid on the navigation colour when the
    /// prominent action is a plain surface.
    func foreground(_ rendering: DSGlassRendering) -> Color {
        self == .prominentAction && rendering != .native ? DSColor.Navigation.onPrimary : DSColor.Identity.textPrimary
    }

    /// Edge of the plain surfaces, stronger when the contrast is increased; the solid prominent action needs none.
    func hairline(_ contrast: ColorSchemeContrast) -> Color {
        guard self != .prominentAction else { return .clear }
        return contrast == .increased ? DSColor.Identity.textTertiary : DSColor.Identity.line
    }
}
