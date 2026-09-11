// HomeView.swift
// Layer: Presentation
// Purpose: Welcome screen: identity, promise, start action, privacy note

import SwiftUI

struct HomeView: View {
    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        DSScreen(intensity: .vivid) {
            HStack {
                Spacer()
                DSIrisMark(size: 150, isBreathing: true)
                Spacer()
            }
            .padding(.top, DSSpacing.l)

            VStack(alignment: .leading, spacing: DSSpacing.s) {
                Text("attention indirecte")
                    .dsEyebrowStyle(tint: DSColor.accent)
                Text("iris")
                    .font(DSFont.display)
                    .foregroundStyle(DSColor.textPrimary)
                    .accessibilityAddTraits(.isHeader)
                Text("Regarder une sphère la repousse. Laissez-la tranquille : elle dérive vers son point d'arrivée.")
                    .font(DSFont.body)
                    .foregroundStyle(DSColor.textSecondary)
            }

            DSCard(style: .flat) {
                HomeFactRow(systemImage: "circle.grid.3x3", text: "14 niveaux, jusqu'à 3 sphères à ignorer en même temps")
                HomeFactRow(systemImage: "faceid", text: "Regard suivi par la caméra TrueDepth, sans calibration")
                HomeFactRow(systemImage: "timer", text: "Pas de chronomètre, pas de vies, pas de score")
            }

            DSButton("Commencer", systemImage: "eye") {
                coordinator.beginJourney()
            }
            DSButton("Les règles", variant: .ghost) {
                coordinator.showTutorial()
            }

            Text("Le regard est analysé sur l'appareil, en temps réel. Aucune image et aucune donnée du visage ne sont enregistrées ni transmises.")
                .font(DSFont.footnote)
                .foregroundStyle(DSColor.textTertiary)
        }
    }
}

private struct HomeFactRow: View {
    let systemImage: String
    let text: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: DSSpacing.m) {
            Image(systemName: systemImage)
                .foregroundStyle(DSColor.accent)
                .frame(width: DSSpacing.l)
                .accessibilityHidden(true)
            Text(text)
                .font(DSFont.callout)
                .foregroundStyle(DSColor.textWarm)
        }
    }
}

#Preview {
    HomeView()
        .environment(AppContainer.preview().makeAppCoordinator())
}
