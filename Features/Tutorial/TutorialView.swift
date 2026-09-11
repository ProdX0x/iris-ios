// TutorialView.swift
// Layer: Presentation
// Purpose: Rules of the game, ported from the reference engine's rules screen

import SwiftUI

struct TutorialView: View {
    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        DSScreen {
            Text("les règles")
                .dsEyebrowStyle(tint: DSColor.accent)
            Text("ne la fixez pas")
                .font(DSFont.title)
                .foregroundStyle(DSColor.textPrimary)
                .accessibilityAddTraits(.isHeader)

            VStack(alignment: .leading, spacing: DSSpacing.m) {
                TutorialStep(number: 1, systemImage: "scope",
                             text: "Une sphère doit atteindre son cercle d'arrivée.")
                TutorialStep(number: 2, systemImage: "eye",
                             text: "Si vous la regardez de trop près, elle s'éloigne. Plus votre regard s'approche, plus elle fuit.")
                TutorialStep(number: 3, systemImage: "wind",
                             text: "Si vous la laissez tranquille, elle dérive doucement vers son but.")
                TutorialStep(number: 4, systemImage: "timer",
                             text: "Elle doit rester trois quarts de seconde dans son cercle pour être validée.")
                TutorialStep(number: 5, systemImage: "list.number",
                             text: "Avec plusieurs sphères, la validation ne compte que dans l'ordre 1, 2, 3. Une sphère validée qui s'échappe entraîne celles qui la suivent.")
            }

            DSCard(style: .flat) {
                Text("Pas de chronomètre, pas de vies, pas de score. La difficulté augmente avec le nombre de sphères à ignorer en même temps. La seule compétence est de répartir son attention sans jamais la fixer.")
                    .font(DSFont.callout)
                    .foregroundStyle(DSColor.textWarm)
            }

            DSButton("Jouer", systemImage: "play.fill") {
                coordinator.startGame()
            }
            DSButton("Accueil", variant: .ghost) {
                coordinator.returnHome()
            }
        }
    }
}

private struct TutorialStep: View {
    let number: Int
    let systemImage: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: DSSpacing.m) {
            ZStack {
                Circle()
                    .strokeBorder(DSColor.accent.opacity(0.5), lineWidth: 1)
                Image(systemName: systemImage)
                    .font(DSFont.footnote)
                    .foregroundStyle(DSColor.accent)
            }
            .frame(width: DSSpacing.xl, height: DSSpacing.xl)
            .accessibilityHidden(true)
            Text(text)
                .font(DSFont.body)
                .foregroundStyle(DSColor.textSecondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Étape \(number). \(text)")
    }
}

#Preview {
    TutorialView()
        .environment(AppContainer.preview().makeAppCoordinator())
}
