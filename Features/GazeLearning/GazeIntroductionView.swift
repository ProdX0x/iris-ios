// GazeIntroductionView.swift
// Layer: Presentation
// Purpose: The three screens shown once, before the very first level, explaining the gaze marker. No navigation
// chrome of its own: three pages and one action

import SwiftUI

struct GazeIntroductionView: View {
    /// Called when the player has read the three pages and asked to begin.
    let onFinish: () -> Void

    @State private var index = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var pages: [GazeIntroductionPage] { GazeIntroductionPage.all }
    private var page: GazeIntroductionPage { pages.indices.contains(index) ? pages[index] : (pages.first ?? GazeIntroductionPage.all[0]) }

    var body: some View {
        ZStack {
            DSBackground(intensity: .calm)
            VStack(spacing: DSSpacing.l) {
                Text("aide au regard").dsEyebrowStyle()
                Spacer(minLength: 0)
                GazeMarkerFigure(stage: index)
                    .id(index)
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
                    if let note = page.note {
                        Text(note)
                            .font(DSFont.footnote)
                            .foregroundStyle(DSColor.Identity.textTertiary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, DSSpacing.xs)
                    }
                }
                .id(index)
                .transition(.opacity)
                Spacer(minLength: 0)
                steps
                DSButton(GazeIntroductionPage.actionTitle(atIndex: index), systemImage: index >= pages.count - 1 ? "eye" : "arrow.right") {
                    if index >= pages.count - 1 { onFinish() } else { index += 1 }
                }
            }
            .frame(maxWidth: 480)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, DSSpacing.gutter)
            .padding(.vertical, DSSpacing.l)
            .animation(DSMotion.animation(DSMotion.standardAnimation, reduceMotion: reduceMotion), value: index)
        }
        .preferredColorScheme(.dark)
    }

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
}

/// The marker as the player will see it: a soft ring, not a surgical crosshair. Static by construction.
private struct GazeMarkerFigure: View {
    let stage: Int

    private let board = CGSize(width: 300, height: 150)

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: DSRadius.m, style: .continuous)
                .strokeBorder(DSColor.Identity.line, lineWidth: 1)
            ForEach(Array(offsets.enumerated()), id: \.offset) { item in
                marker(opacity: opacities[min(item.offset, opacities.count - 1)])
                    .position(x: board.width / 2 + item.element.width, y: board.height / 2 + item.element.height)
            }
        }
        .frame(width: board.width, height: board.height)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label)
    }

    /// Page 1 shows the marker wandering slightly; pages 2 and 3 show it fading.
    private var offsets: [CGSize] {
        stage == 0 ? [CGSize(width: -26, height: -10), CGSize(width: -4, height: 6), CGSize(width: 22, height: -4)]
                   : [CGSize(width: -34, height: 0), CGSize(width: 0, height: 0), CGSize(width: 34, height: 0)]
    }

    private var opacities: [Double] {
        switch stage {
        case 0: [0.35, 0.65, 1]
        case 1: [1, 1, 1]
        default: [1, 0.55, 0.15]
        }
    }

    private var label: String {
        switch stage {
        case 0: "Trois positions proches du repère, montrant qu'il bouge légèrement."
        case 1: "Le repère, bien visible."
        default: "Le repère qui s'efface peu à peu."
        }
    }

    private func marker(opacity: Double) -> some View {
        ZStack {
            Circle()
                .strokeBorder(DSColor.Identity.accent.opacity(0.7 * opacity), lineWidth: 1.5)
                .frame(width: 28, height: 28)
            Circle()
                .fill(DSColor.Identity.accent.opacity(opacity))
                .frame(width: 4, height: 4)
        }
    }
}

#Preview {
    GazeIntroductionView {}
}
