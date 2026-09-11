// DSOverlayPanel.swift
// Layer: DesignSystem
// Purpose: Dimmed full-screen veil with a centred title, subtitle and actions (the reference engine's overlays)

import SwiftUI

struct DSOverlayPanel<Actions: View>: View {
    private let title: String
    private let subtitle: String?
    private let tint: Color
    private let dim: Double
    @ViewBuilder private let actions: Actions

    init(title: String, subtitle: String? = nil, tint: Color = DSColor.textPrimary, dim: Double = 0.88,
         @ViewBuilder actions: () -> Actions) {
        self.title = title
        self.subtitle = subtitle
        self.tint = tint
        self.dim = dim
        self.actions = actions()
    }

    var body: some View {
        ZStack {
            DSColor.backgroundSurface.opacity(dim)
                .ignoresSafeArea()
            VStack(spacing: DSSpacing.l) {
                VStack(spacing: DSSpacing.s) {
                    Text(title)
                        .font(DSFont.title)
                        .foregroundStyle(tint)
                        .multilineTextAlignment(.center)
                    if let subtitle {
                        Text(subtitle)
                            .font(DSFont.callout)
                            .foregroundStyle(DSColor.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                }
                actions
            }
            .frame(maxWidth: 420)
            .padding(.horizontal, DSSpacing.gutter)
        }
        .accessibilityAddTraits(.isModal)
    }
}

#Preview {
    DSOverlayPanel(title: "pause", subtitle: "touchez pour reprendre") {
        DSButton("Reprendre") {}
        DSButton("Quitter", variant: .ghost) {}
    }
    .background(DSColor.backgroundPrimary)
}
