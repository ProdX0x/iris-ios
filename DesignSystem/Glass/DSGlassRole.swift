// DSGlassRole.swift
// Layer: DesignSystem
// Purpose: The four intentions of glass in Iris (clear control, regular panel, chrome, prominent action): each role
// owns its native glass recipe, its shape, and the plain surfaces that stand in for it

import SwiftUI

enum DSGlassRole: CaseIterable, Hashable, Sendable {
    /// Small floating icon controls (pause, close, settings): the clearest glass, compact, never a coloured slab.
    case clearControl
    /// Panels holding text (pause, introduction, result): more present than a control, the ground still perceptible.
    case regularPanel
    /// A custom container of navigation controls. System bars (tab bar, toolbars) draw their own glass: no role.
    case chrome
    /// The one main action of a screen. Never two on one screen.
    case prominentAction

    /// The native glass of the role. The clear control is validated; the three other roles keep their first recipes
    /// until one of the candidates compared in the development gallery is chosen.
    var recipe: DSGlassRecipe {
        switch self {
        case .clearControl: DSGlassRecipe(.clear, interactive: true)
        case .regularPanel: DSGlassRecipe(.regular)
        case .chrome: DSGlassRecipe(.regular)
        case .prominentAction: DSGlassRecipe(.regular, tint: DSColor.Navigation.primary.opacity(0.4), interactive: true)
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
