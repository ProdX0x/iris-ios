// JourneyCompleteView.swift
// Layer: Presentation
// Purpose: The end of the campaign: the last iris closed, éclats and play time, replay a chapter

import SwiftUI

struct JourneyCompleteView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let summary: JourneySummary
    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        DSScreen(intensity: .vivid) {
            HStack {
                Spacer()
                DSEclats(lit: [true, summary.eclats >= summary.maxEclats * 2 / 3, summary.eclats == summary.maxEclats], lineWidth: 6)
                    .frame(width: 150, height: 150)
                    .overlay(DSIrisMark(size: 60))
                Spacer()
            }
            .padding(.top, DSSpacing.l)
            VStack(alignment: .leading, spacing: DSSpacing.s) {
                Text(IrisText.interface("journey.eyebrow", french: "le dernier iris")).dsEyebrowStyle(tint: DSColor.State.success)
                Text(Campaign.chapters.last.map(CampaignText.name(of:)) ?? "")
                    .font(DSFont.display)
                    .foregroundStyle(DSColor.Identity.textPrimary)
                    .accessibilityAddTraits(.isHeader)
                Text(IrisText.interface("journey.detail", french: "Toutes les lueurs ont trouvé leur iris. Vous avez appris à regarder juste, pas à regarder plus."))
                    .font(DSFont.body)
                    .foregroundStyle(DSColor.Identity.textSecondary)
            }
            DSGlassPanel {
                // Same reason as the result panel: three columns hold until an accessibility size, then the words
                // break. Stacked, each measurement gets the whole width instead of a third of it.
                measurements {
                    metric(IrisText.interface("journey.levels.label", french: "niveaux"), "\(summary.levelCount)")
                    if !dynamicTypeSize.isAccessibilitySize { Spacer() }
                    metric(IrisText.interface("journey.eclats.label", french: "éclats"), "\(summary.eclats) / \(summary.maxEclats)")
                    if !dynamicTypeSize.isAccessibilitySize { Spacer() }
                    metric(IrisText.interface("journey.playTime.label", french: "temps de jeu"), Duration.seconds(summary.playDuration).formatted(.time(pattern: .hourMinuteSecond)))
                }
            }
            DSButton(IrisText.interface("home.replayChapter.action", french: "Rejouer un chapitre"), systemImage: "arrow.counterclockwise") { coordinator.openChapters() }
            DSButton(IrisText.interface("common.threshold", french: "Seuil"), variant: .ghost) { coordinator.returnHome() }
        }
    }

    /// Side by side at ordinary text sizes, stacked once the size is an accessibility one.
    private var measurements: AnyLayout {
        dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: DSSpacing.s))
            : AnyLayout(HStackLayout())
    }

    private func metric(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text(label).dsEyebrowStyle()
            Text(value)
                .font(DSFont.title3)
                .monospacedDigit()
                .foregroundStyle(DSColor.Identity.textPrimary)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    JourneyCompleteView(summary: JourneySummary(levelCount: Campaign.levels.count, playDuration: 5_412,
                                                eclats: Campaign.levels.count * 3 - 21, maxEclats: Campaign.levels.count * 3))
        .environment(AppContainer.preview().makeAppCoordinator())
}
