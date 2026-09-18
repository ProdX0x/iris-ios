// CarnetView.swift
// Layer: Presentation
// Purpose: The ideas met so far, one glyph and one sentence each; the others stay unknown

import SwiftUI

struct CarnetView: View {
    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        DSScreen {
            Text("carnet")
                .font(DSFont.display)
                .foregroundStyle(DSColor.Identity.textPrimary)
                .accessibilityAddTraits(.isHeader)
            DSGlassPanel {
                ForEach(GameElement.allCases, id: \.self) { element in
                    CarnetRow(element: element, isKnown: coordinator.progress.encounteredElements.contains(element))
                }
            }
        }
    }
}

private struct CarnetRow: View {
    let element: GameElement
    let isKnown: Bool

    var body: some View {
        HStack(alignment: .top, spacing: DSSpacing.m) {
            DSGlyph(isKnown ? element.glyphKind : .inconnu, tint: isKnown ? DSColor.Identity.accent : DSColor.Identity.textTertiary)
                .frame(width: 28, height: 28)
            VStack(alignment: .leading, spacing: DSSpacing.xxs) {
                Text(isKnown ? CampaignText.name(of: element) : "à découvrir")
                    .font(DSFont.headline)
                    .foregroundStyle(isKnown ? DSColor.Identity.textPrimary : DSColor.Identity.textTertiary)
                if isKnown {
                    Text(CampaignText.summary(of: element))
                        .font(DSFont.footnote)
                        .foregroundStyle(DSColor.Identity.textSecondary)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, DSSpacing.xs)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    CarnetView()
        .environment(AppContainer.preview().makeAppCoordinator())
}
