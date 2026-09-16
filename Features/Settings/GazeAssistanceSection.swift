// GazeAssistanceSection.swift
// Layer: Presentation
// Purpose: The one place a player chooses how much help they want seeing the gaze marker. Three rows rather than a
// segmented control: each carries its own name, its own sentence and a mark that does not rely on colour alone

import SwiftUI

struct GazeAssistanceSection: View {
    @Binding var mode: GazeAssistanceMode
    /// Opens the three introduction screens again.
    let onReviewIntroduction: () -> Void

    var body: some View {
        DSGlassPanel {
            Text("aide au regard").dsEyebrowStyle()
            Text("Le repère montre où Iris estime que vous regardez.")
                .font(DSFont.footnote)
                .foregroundStyle(DSColor.Identity.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            VStack(spacing: DSSpacing.xs) {
                ForEach(GazeAssistanceMode.allCases, id: \.self) { candidate in
                    GazeAssistanceRow(mode: candidate, isSelected: candidate == mode) { mode = candidate }
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Aide au regard")
            DSButton("Revoir l'explication", systemImage: "questionmark.circle", variant: .ghost, action: onReviewIntroduction)
        }
    }
}

/// One choice. The selection is told by a filled mark and by the VoiceOver trait, never by colour alone.
private struct GazeAssistanceRow: View {
    let mode: GazeAssistanceMode
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .firstTextBaseline, spacing: DSSpacing.m) {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .font(DSFont.headline)
                    .foregroundStyle(isSelected ? DSColor.Navigation.selection : DSColor.Identity.textTertiary)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: DSSpacing.xxs) {
                    Text(mode.title)
                        .font(DSFont.headline)
                        .foregroundStyle(DSColor.Identity.textPrimary)
                    Text(mode.summary)
                        .font(DSFont.footnote)
                        .foregroundStyle(DSColor.Identity.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, DSSpacing.s)
            .contentShape(Rectangle())
        }
        .buttonStyle(DSPressableButtonStyle())
        .accessibilityLabel(mode.title)
        .accessibilityValue(mode.summary)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}

#Preview {
    ZStack {
        DSBackground(intensity: .calm)
        GazeAssistanceSection(mode: .constant(.guided), onReviewIntroduction: {})
            .padding(DSSpacing.gutter)
    }
    .preferredColorScheme(.dark)
}
