// DSGlassPanel.swift
// Layer: DesignSystem
// Purpose: A panel of text and controls laid on the glass of its role: native Liquid Glass on iOS 26, the role's
// plain surface before it and under Reduce Transparency

import SwiftUI

struct DSGlassPanel<Content: View>: View {
    private let shape: DSGlassShape
    @ViewBuilder private let content: Content

    init(shape: DSGlassShape = .rounded(DSRadius.l), @ViewBuilder content: () -> Content) {
        self.shape = shape
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.m) {
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DSSpacing.l)
        .dsGlass(.regularPanel, in: shape)
    }
}

#Preview {
    ZStack {
        DSBackground(intensity: .vivid)
        DSGlassPanel {
            Text("panneau").dsEyebrowStyle()
            Text("Le verre laisse passer le fond : ce texte doit se lire sans effort.")
                .font(DSFont.footnote)
                .foregroundStyle(DSColor.Identity.textSecondary)
        }
        .padding(DSSpacing.gutter)
    }
    .preferredColorScheme(.dark)
}
