// DSEyebrowStyle.swift
// Layer: DesignSystem
// Purpose: Small uppercase tracked label style used for section markers and HUD readouts

import SwiftUI

struct DSEyebrowStyle: ViewModifier {
    let tint: Color

    func body(content: Content) -> some View {
        content
            .font(DSFont.eyebrow)
            .textCase(.uppercase)
            .tracking(2)
            .foregroundStyle(tint)
    }
}

extension View {
    func dsEyebrowStyle(tint: Color = DSColor.Identity.textSecondary) -> some View {
        modifier(DSEyebrowStyle(tint: tint))
    }
}
