// JourneyCompleteView.swift
// Layer: Presentation
// Purpose: End of the fourteen-level journey

import SwiftUI

struct JourneyCompleteView: View {
    let summary: JourneySummary
    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        DSScreen(intensity: .vivid) {
            HStack {
                Spacer()
                DSProgressRing(progress: 1, tint: DSColor.statusSuccess, lineWidth: 8, label: "\(summary.levelCount) / \(summary.levelCount)")
                    .frame(width: 160, height: 160)
                    .dsGlow(DSColor.statusSuccess, radius: 18, opacity: 0.4)
                Spacer()
            }
            .padding(.top, DSSpacing.l)

            VStack(alignment: .leading, spacing: DSSpacing.s) {
                Text("bravo")
                    .dsEyebrowStyle(tint: DSColor.statusSuccess)
                Text("parcours terminé")
                    .font(DSFont.display)
                    .foregroundStyle(DSColor.textPrimary)
                    .accessibilityAddTraits(.isHeader)
                Text("Toutes les sphères ont rejoint leur point d'arrivée sans jamais être fixées.")
                    .font(DSFont.body)
                    .foregroundStyle(DSColor.textSecondary)
            }

            DSCard(style: .flat) {
                HStack {
                    VStack(alignment: .leading, spacing: DSSpacing.xs) {
                        Text("niveaux").dsEyebrowStyle()
                        Text("\(summary.levelCount)")
                            .font(DSFont.title2)
                            .foregroundStyle(DSColor.textPrimary)
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: DSSpacing.xs) {
                        Text("temps de jeu").dsEyebrowStyle()
                        Text(formattedDuration)
                            .font(DSFont.title2)
                            .foregroundStyle(DSColor.textPrimary)
                    }
                }
            }

            DSButton("Recommencer", systemImage: "arrow.counterclockwise") { coordinator.replayJourney() }
            DSButton("Accueil", variant: .ghost) { coordinator.returnHome() }
        }
    }

    private var formattedDuration: String {
        Duration.seconds(summary.playDuration).formatted(.time(pattern: .minuteSecond))
    }
}

#Preview {
    JourneyCompleteView(summary: JourneySummary(levelCount: 14, playDuration: 754))
        .environment(AppContainer.preview().makeAppCoordinator())
}
