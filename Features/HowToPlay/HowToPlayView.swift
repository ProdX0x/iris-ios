// HowToPlayView.swift
// Layer: Presentation
// Purpose: The same four explanations, available for good from the threshold and the settings; the sheet's title and
// close action are the system's navigation chrome

import SwiftUI

struct HowToPlayView: View {
    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: DSSpacing.l) {
                    Text("Iris se joue avec les yeux. La caméra avant estime la direction de votre regard ; le reste tient en quatre idées.")
                        .font(DSFont.callout)
                        .foregroundStyle(DSColor.Identity.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                    ForEach(OnboardingPage.all) { page in
                        DSGlassPanel {
                            OnboardingFigure(figure: page.figure, describedBy: page.figureDescription)
                            Text(page.title)
                                .font(DSFont.title3)
                                .foregroundStyle(DSColor.Identity.textPrimary)
                                .fixedSize(horizontal: false, vertical: true)
                            Text(page.detail)
                                .font(DSFont.footnote)
                                .foregroundStyle(DSColor.Identity.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    DSGlassPanel {
                        Text("confort").dsEyebrowStyle()
                        Text("Tenez l'iPhone à hauteur des yeux, à une longueur de bras, dans une lumière régulière. Si le regard dérive, recalibrez depuis les réglages.")
                            .font(DSFont.footnote)
                            .foregroundStyle(DSColor.Identity.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(DSSpacing.gutter)
            }
            .dsSoftScrollEdges()
            .background { DSBackground(intensity: .calm) }
            .navigationTitle("comment jouer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fermer") { coordinator.dismissSheet() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    HowToPlayView()
        .environment(AppContainer.preview().makeAppCoordinator())
}
