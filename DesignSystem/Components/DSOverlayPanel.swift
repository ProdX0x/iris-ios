// DSOverlayPanel.swift
// Layer: DesignSystem
// Purpose: Veil over the game, lit by the spectral environment, with a centred title, subtitle and actions

import SwiftUI

struct DSOverlayPanel<Actions: View>: View {
    private let title: String
    private let subtitle: String?
    private let eyebrow: String?
    private let tint: Color
    private let dim: Double
    @ViewBuilder private let actions: Actions

    init(title: String, subtitle: String? = nil, eyebrow: String? = nil, tint: Color = DSColor.Identity.textPrimary, dim: Double = 0.86,
         @ViewBuilder actions: () -> Actions) {
        self.title = title
        self.subtitle = subtitle
        self.eyebrow = eyebrow
        self.tint = tint
        self.dim = dim
        self.actions = actions()
    }

    var body: some View {
        ZStack {
            // The veil dims the level; the spectral environment above it keeps the ground from becoming a
            // mathematically flat black, which left the glass of the actions nothing to transmit.
            DSColor.Navigation.veil.opacity(dim)
                .ignoresSafeArea()
            DSSpectralEnvironment(intensity: .veiled)
            ScrollView(showsIndicators: false) {
                VStack(spacing: DSSpacing.l) {
                    VStack(spacing: DSSpacing.s) {
                        if let eyebrow {
                            Text(eyebrow).dsEyebrowStyle(tint: DSColor.Identity.textSecondary)
                        }
                        Text(title)
                            .font(DSFont.display)
                            .foregroundStyle(tint)
                            .multilineTextAlignment(.center)
                            .accessibilityAddTraits(.isHeader)
                        if let subtitle {
                            Text(subtitle)
                                .font(DSFont.callout)
                                .foregroundStyle(DSColor.Identity.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    actions
                }
                .frame(maxWidth: 420)
                .padding(.horizontal, DSSpacing.gutter)
                .padding(.vertical, DSSpacing.xxl)
                .frame(maxWidth: .infinity)
            }
            .scrollBounceBehavior(.basedOnSize)
            .defaultScrollAnchor(.center)
        }
        .accessibilityAddTraits(.isModal)
    }
}

#Preview {
    DSOverlayPanel(title: "pause", subtitle: "III · courants — 2", eyebrow: "en pause") {
        DSButton("Reprendre") {}
        DSButton("Chapitres", variant: .ghost) {}
    }
    .background(DSColor.Identity.ground)
}
