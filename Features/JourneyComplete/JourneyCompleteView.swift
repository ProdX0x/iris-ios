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
                Text("le dernier iris").dsEyebrowStyle(tint: DSColor.statusSuccess)
                Text("clairvoyance")
                    .font(DSFont.display)
                    .foregroundStyle(DSColor.textPrimary)
                    .accessibilityAddTraits(.isHeader)
                Text("Toutes les lueurs ont trouvé leur iris. Vous avez appris à regarder juste, pas à regarder plus.")
                    .font(DSFont.body)
                    .foregroundStyle(DSColor.textSecondary)
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
                .foregroundStyle(DSColor.textPrimary)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    JourneyCompleteView(summary: JourneySummary(levelCount: 34, playDuration: 5_412, eclats: 81, maxEclats: 102))
        .environment(AppContainer.preview().makeAppCoordinator())
}
