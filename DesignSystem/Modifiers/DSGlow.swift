// DSGlow.swift
// Layer: DesignSystem
// Purpose: Soft coloured glow used for the iris mark and validated states

import SwiftUI

struct DSGlow: ViewModifier {
    let color: Color
    let radius: CGFloat
    let opacity: Double

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(opacity), radius: radius)
            .shadow(color: color.opacity(opacity * 0.5), radius: radius * 2.2)
    }
}

extension View {
    func dsGlow(_ color: Color = DSColor.Identity.accent, radius: CGFloat = 12, opacity: Double = 0.55) -> some View {
        modifier(DSGlow(color: color, radius: radius, opacity: opacity))
    }
}
