// HomeView.swift
// Layer: Presentation
// Purpose: The threshold: emblem, promise, one main action (begin or continue). Settings live in the navigation
// toolbar and the other destinations in the tab bar, both drawn by the system

import SwiftUI

struct HomeView: View {
    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        let summary = coordinator.homeSummary
        ZStack {
            DSBackground(intensity: .vivid)
            VStack(spacing: DSSpacing.l) {
                Spacer(minLength: DSSpacing.l)
                DSIrisMark(size: 132, isBreathing: true)
                VStack(spacing: DSSpacing.s) {
                    Text("iris")
                        .font(DSFont.display)
                        .foregroundStyle(DSColor.Identity.textPrimary)
                        .accessibilityAddTraits(.isHeader)
                    Text(IrisText.interface("home.tagline", french: "Ce que vous regardez s'éloigne."))
                        .font(DSFont.callout)
                        .foregroundStyle(DSColor.Identity.textSecondary)
                }
                Spacer(minLength: DSSpacing.l)
                VStack(spacing: DSSpacing.s) {
                    DSButton(HomeText.primaryTitle(of: summary), systemImage: "eye") { coordinator.continueJourney() }
                    // `summary.detail` is composed inside a frozen file, already assembled; the same line is rebuilt
                    // from keys here, where the level itself is at hand. The two are held equal by test.
                    if summary.detail != nil, let level = coordinator.nextLevel {
                        Text(NavigationText.label(for: level))
                            .font(DSFont.footnote)
                            .foregroundStyle(DSColor.Identity.textTertiary)
                            .multilineTextAlignment(.center)
                    }
                    DSButton(IrisText.interface("howToPlay.title", french: "Comment jouer"), systemImage: "questionmark.circle", variant: .secondary) { coordinator.showHowToPlay() }
                        .padding(.top, DSSpacing.xs)
                    if summary.eclats > 0 {
                        Text(IrisText.interface("eclats.total.value", french: "%lld éclats sur %lld", summary.eclats, summary.maxEclats))
                            .dsEyebrowStyle(tint: DSColor.State.success)
                            .padding(.top, DSSpacing.xs)
                    }
                }
                .frame(maxWidth: 420)
            }
            .padding(.horizontal, DSSpacing.gutter)
            .padding(.vertical, DSSpacing.m)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview("First launch") {
    HomeView()
        .environment(AppContainer.preview().makeAppCoordinator())
}
