// SettingsView.swift
// Layer: Presentation
// Purpose: Sound effects, ambience, haptics, gaze diagnostics, recalibration, Carnet, progress reset, privacy note

import SwiftUI

struct SettingsView: View {
    @Environment(AppCoordinator.self) private var coordinator
    @State private var confirmsReset = false

    var body: some View {
        @Bindable var settings = coordinator.settings
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: DSSpacing.l) {
                HStack {
                    Text("réglages")
                        .font(DSFont.title)
                        .foregroundStyle(DSColor.textPrimary)
                        .accessibilityAddTraits(.isHeader)
                    Spacer()
                    Button("Fermer") { coordinator.dismissSheet() }
                        .font(DSFont.callout)
                        .foregroundStyle(DSColor.accent)
                        .frame(minHeight: 44)
                }
                DSCard(style: .flat) {
                    Toggle("Effets sonores", isOn: $settings.soundEffectsEnabled)
                    Toggle("Ambiance sonore", isOn: $settings.ambienceEnabled)
                    Toggle("Vibrations", isOn: $settings.hapticsEnabled)
                    Toggle("Points de regard (diagnostic)", isOn: $settings.showsGazeIndicator)
                }
                .tint(DSColor.accent)
                .foregroundStyle(DSColor.textPrimary)
                DSCard(style: .flat) {
                    Text("regard").dsEyebrowStyle()
                    DSButton("Recalibrer le regard", systemImage: "scope", variant: .secondary) { coordinator.recalibrate() }
                    DSButton("Carnet", systemImage: "book.closed", variant: .ghost) { coordinator.openCarnet() }
                }
                DSCard(style: .flat) {
                    Text("confidentialité").dsEyebrowStyle()
                    Text("Le regard est calculé sur l'iPhone, en temps réel. Aucune image, aucune vidéo et aucune donnée du visage n'est enregistrée ni envoyée. Seuls les coefficients de calibration et votre progression sont gardés sur l'appareil.")
                        .font(DSFont.footnote)
                        .foregroundStyle(DSColor.textSecondary)
                }
                #if DEBUG
                DSCard(style: .flat) {
                    Text("prototypes (debug)").dsEyebrowStyle()
                    Text("Hors campagne. Rien n'est enregistré.")
                        .font(DSFont.footnote)
                        .foregroundStyle(DSColor.textSecondary)
                    DSButton("Braises A · braise", systemImage: "flame", variant: .secondary) { coordinator.playPrototype(BraisesPrototype.a) }
                    DSButton("Braises B · deux feux", systemImage: "flame", variant: .secondary) { coordinator.playPrototype(BraisesPrototype.b) }
                }
                #endif
                DSButton("Réinitialiser la progression", variant: .ghost) { confirmsReset = true }
                    .confirmationDialog("Effacer tous les niveaux atteints et les éclats ?", isPresented: $confirmsReset, titleVisibility: .visible) {
                        Button("Réinitialiser", role: .destructive) { coordinator.resetProgress() }
                        Button("Annuler", role: .cancel) {}
                    }
            }
            .padding(DSSpacing.gutter)
        }
        .background(DSColor.backgroundSurface)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    SettingsView()
        .environment(AppContainer.preview().makeAppCoordinator())
}
