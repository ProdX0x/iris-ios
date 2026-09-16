// DSGlassButtonStyle.swift
// Layer: DesignSystem
// Purpose: Actions on Apple's own glass: the system's `.glass` button style on iOS 26, the historical painted
// capsule before it and under Reduce Transparency; one of the two places aware of the system version. The filled
// prominent style is deliberately unused: it turned the material into an opaque amber capsule

import SwiftUI

struct DSGlassButtonStyle: ViewModifier {
    /// What an action means, in the system's terms.
    enum Role: Hashable, Sendable {
        /// The single main action of a screen. It takes the same system material as the others: prominence comes
        /// from the Iris colour of its label, never from a tint filling the glass into an opaque slab.
        case prominent
        /// A secondary action standing on its own glass.
        case standard
        /// A text action that never takes a surface.
        case plain
    }

    let role: Role
    let rendering: DSGlassRendering

    @ViewBuilder
    func body(content: Content) -> some View {
        if rendering == .native, role != .plain {
            if #available(iOS 26.0, *) {
                content.buttonStyle(.glass)
            } else {
                content.buttonStyle(DSPressableButtonStyle())
            }
        } else {
            content.buttonStyle(DSPressableButtonStyle())
        }
    }
}

extension View {
    /// Gives a button the system's Liquid Glass style where the platform draws it; everywhere else the button keeps
    /// the plain surface its caller painted, with the historical press feedback.
    func dsGlassButton(_ role: DSGlassButtonStyle.Role, rendering: DSGlassRendering) -> some View {
        modifier(DSGlassButtonStyle(role: role, rendering: rendering))
    }
}
