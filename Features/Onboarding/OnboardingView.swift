// OnboardingView.swift
// Layer: Presentation
// Purpose: The four screens shown once, at the first launch: how the gaze moves a sphere, and where it must go.
// It may be skipped at any moment, it starts no camera and no ARKit session, and it is never a splash

import SwiftUI

struct OnboardingView: View {
    /// Called once the player has gone through the pages or skipped them.
    let onFinish: () -> Void

    @State private var index = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var pages: [OnboardingPage] { OnboardingPage.all }
    private var page: OnboardingPage { pages.indices.contains(index) ? pages[index] : (pages.first ?? OnboardingPage.all[0]) }
    private var isLast: Bool { index >= pages.count - 1 }

    var body: some View {
        ZStack {
            DSBackground(intensity: .calm)
            VStack(spacing: DSSpacing.l) {
                skipRow
                Spacer(minLength: 0)
                OnboardingFigure(figure: page.figure, describedBy: page.figureDescription)
                    .id(page.figure)
                    .transition(.opacity)
                VStack(spacing: DSSpacing.s) {
                    Text(page.title)
                        .font(DSFont.title)
                        .foregroundStyle(DSColor.Identity.textPrimary)
                        .multilineTextAlignment(.center)
                        .accessibilityAddTraits(.isHeader)
                    Text(page.detail)
                        .font(DSFont.callout)
                        .foregroundStyle(DSColor.Identity.textSecondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .id(page.figure)
                .transition(.opacity)
                Spacer(minLength: 0)
                steps
                DSButton(isLast ? "Commencer" : "Suivant", systemImage: isLast ? "eye" : "arrow.right") { advance() }
            }
            .frame(maxWidth: 480)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, DSSpacing.gutter)
            .padding(.vertical, DSSpacing.l)
            .animation(DSMotion.animation(DSMotion.standardAnimation, reduceMotion: reduceMotion), value: index)
        }
        .preferredColorScheme(.dark)
    }

    private var skipRow: some View {
        HStack {
            Text("comment jouer").dsEyebrowStyle()
            Spacer()
            DSButton("Passer", variant: .ghost) { onFinish() }
        }
    }

    /// Where the player stands in the four screens.
    private var steps: some View {
        HStack(spacing: DSSpacing.s) {
            ForEach(pages.indices, id: \.self) { step in
                Capsule()
                    .fill(step == index ? DSColor.Identity.accent : DSColor.Identity.line)
                    .frame(width: step == index ? 22 : 7, height: 7)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Écran \(index + 1) sur \(pages.count)")
    }

    private func advance() {
        if isLast {
            onFinish()
        } else {
            index += 1
        }
    }
}

#Preview {
    OnboardingView {}
}
