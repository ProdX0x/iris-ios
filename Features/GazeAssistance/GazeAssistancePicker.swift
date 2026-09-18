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
    static let learningNote = IrisText.interface("gazeAssistance.learning.note", french: "L'aide au regard est guidée pendant les premiers niveaux d'apprentissage.")

    /// What a row says about a mode, at the length its screen can afford: the settings explain, the pause names.
    /// One rule, used both to draw the row and to answer VoiceOver, so the two can never say different things.
    static func meaning(for mode: GazeAssistanceMode, variant: Variant) -> String {
        switch variant {
        case .detailed: GazeAssistanceText.summary(of: mode)
        case .compact: GazeAssistanceText.compactSummary(of: mode)
        }
    }

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
                                  variant: variant) { mode = candidate }
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
        .accessibilityLabel(IrisText.interface("gazeAssistance.title", french: "Aide au regard"))
    }
}

/// One choice: a name, what it does, and a mark that never relies on colour alone. Both variants say what the
/// mode does — at the length their screen can afford — and VoiceOver announces exactly the words that are drawn.
private struct GazeAssistanceRow: View {
    let mode: GazeAssistanceMode
    let isSelected: Bool
    let variant: GazeAssistancePicker.Variant
    let action: () -> Void

    /// The sentence this row shows, and the one VoiceOver reads: never two different texts for one row.
    private var meaning: String {
        GazeAssistancePicker.meaning(for: mode, variant: variant)
    }

    var body: some View {
        Button(action: action) {
            HStack(alignment: .firstTextBaseline, spacing: DSSpacing.m) {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .font(DSFont.headline)
                    .foregroundStyle(isSelected ? DSColor.Navigation.selection : DSColor.Identity.textTertiary)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: DSSpacing.xxs) {
                    Text(GazeAssistanceText.title(of: mode))
                        .font(DSFont.headline)
                        .foregroundStyle(DSColor.Identity.textPrimary)
                    Text(meaning)
                        .font(DSFont.footnote)
                        .foregroundStyle(DSColor.Identity.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, variant == .detailed ? DSSpacing.s : DSSpacing.xs)
            .contentShape(Rectangle())
        }
        .buttonStyle(DSPressableButtonStyle())
        // One element per choice: the mark is hidden, the two texts are merged into this label and value, and the
        // selection is a trait rather than a spoken word.
        .accessibilityLabel(GazeAssistanceText.title(of: mode))
        .accessibilityValue(meaning)
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
