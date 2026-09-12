// DSThemeWash.swift
// Layer: DesignSystem
// Purpose: Tints the chambre noire with a chapter's wash and a soft glow at the top; draws nothing for the historical palette

import SwiftUI

struct DSThemeWash: View {
    let palette: DSThemePalette

    init(palette: DSThemePalette) {
        self.palette = palette
    }

    var body: some View {
        if let wash = palette.wash {
            ZStack {
                wash.opacity(0.62)
                RadialGradient(colors: [palette.glow.opacity(0.12), .clear],
                               center: UnitPoint(x: 0.5, y: 0.3), startRadius: 0, endRadius: 460)
                LinearGradient(colors: [.clear, wash.opacity(0.35)], startPoint: .center, endPoint: .bottom)
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .accessibilityHidden(true)
        }
    }
}

#Preview {
    ZStack {
        DSBackground()
        DSThemeWash(palette: DSThemePalette(accent: DSColor.statusInfo, glow: DSColor.statusInfo, wash: DSColor.statusInfo))
    }
}
