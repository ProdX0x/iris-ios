// JourneyCompleteView.swift
// Layer: Presentation
// Purpose: The end of the campaign: the last iris closed, éclats and play time, replay a chapter

import SwiftUI

struct JourneyCompleteView: View {
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
                Text("le dernier iris").dsEyebrowStyle(tint: DSColor.State.success)
                Text(Campaign.chapters.last?.name ?? "")
                    .font(DSFont.display)
                    .foregroundStyle(DSColor.Identity.textPrimary)
                    .accessibilityAddTraits(.isHeader)
                Text("Toutes les lueurs ont trouvé leur iris. Vous avez appris à regarder juste, pas à regarder plus.")
                    .font(DSFont.body)
                    .foregroundStyle(DSColor.Identity.textSecondary)
            }
            DSCard(style: .flat) {
                HStack {
                    metric("niveaux", "\(summary.levelCount)")
                    Spacer()
                    metric("éclats", "\(summary.eclats) / \(summary.maxEclats)")
                    Spacer()
                    metric("temps de jeu", Duration.seconds(summary.playDuration).formatted(.time(pattern: .hourMinuteSecond)))
                }
            }
            DSButton("Rejouer un chapitre", systemImage: "arrow.counterclockwise") { coordinator.openChapters() }
            DSButton("Seuil", variant: .ghost) { coordinator.returnHome() }
        }
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
