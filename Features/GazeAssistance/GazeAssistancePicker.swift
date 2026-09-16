// GazeAssistancePicker.swift
// Layer: Presentation
// Purpose: The one way a player chooses how much help they want seeing the gaze marker. Two presentations —
// detailed in the settings, compact in the pause — over a single binding: there is no second state anywhere

import SwiftUI

struct GazeAssistancePicker: View {
    enum Variant {
        /// Each choice carries its sentence. The settings screen, where a player is reading.
        case detailed
        /// Names only. The pause panel, where a player is mid-level and wants one tap.
        case compact
    }

    /// Why the choices are inert while chapter I is still teaching the marker. Said once, in the player's terms.
    static let learningNote = "L'aide au regard est guidée pendant les premiers niveaux d'apprentissage."

    @Binding var mode: GazeAssistanceMode
    var variant: Variant = .detailed
    /// True while the chapter I learning decides the marker for itself. The rows still show what the player chose
    /// — it is what will apply afterwards — but they cannot pretend to change this level.
    var isLearning: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            ForEach(GazeAssistanceMode.allCases, id: \.self) { candidate in
                GazeAssistanceRow(mode: candidate,
                                  isSelected: candidate == mode,
                                  showsSummary: variant == .detailed) { mode = candidate }
            }
            if isLearning {
                Text(Self.learningNote)
                    .font(DSFont.footnote)
                    .foregroundStyle(DSColor.Identity.textTertiary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, DSSpacing.xxs)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .disabled(isLearning)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Aide au regard")
    }
}

/// One choice. The selection is told by a filled mark and by the VoiceOver trait, never by colour alone. The
/// sentence is always announced, even when the compact variant does not draw it.
private struct GazeAssistanceRow: View {
    let mode: GazeAssistanceMode
    let isSelected: Bool
    let showsSummary: Bool
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
                    if showsSummary {
                        Text(mode.summary)
                            .font(DSFont.footnote)
                            .foregroundStyle(DSColor.Identity.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                    }
                }
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, showsSummary ? DSSpacing.s : DSSpacing.xs)
            .contentShape(Rectangle())
        }
        .buttonStyle(DSPressableButtonStyle())
        .accessibilityLabel(mode.title)
        .accessibilityValue(mode.summary)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}

#Preview("détaillé") {
    ZStack {
        DSBackground(intensity: .calm)
        GazeAssistancePicker(mode: .constant(.guided), variant: .detailed)
            .padding(DSSpacing.gutter)
    }
    .preferredColorScheme(.dark)
}

#Preview("compact, pendant l'apprentissage") {
    ZStack {
        DSBackground(intensity: .calm)
        DSGlassPanel {
            Text("aide au regard").dsEyebrowStyle()
            GazeAssistancePicker(mode: .constant(.classic), variant: .compact, isLearning: true)
        }
        .padding(DSSpacing.gutter)
    }
    .preferredColorScheme(.dark)
}
