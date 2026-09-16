// SettingsView.swift
// Layer: Presentation
// Purpose: Sound effects, ambience, haptics, gaze diagnostics, recalibration, progress reset, privacy note; the
// sheet's title and close action are the system's navigation chrome, and its panels stand in the chambre noire
// (the Carnet has its own destination)

import SwiftUI

struct SettingsView: View {
    @Environment(AppCoordinator.self) private var coordinator
    @State private var confirmsReset = false

    var body: some View {
        @Bindable var settings = coordinator.settings
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: DSSpacing.l) {
                    DSGlassPanel {
                        Toggle("Effets sonores", isOn: $settings.soundEffectsEnabled)
                        Toggle("Ambiance sonore", isOn: $settings.ambienceEnabled)
                        Toggle("Vibrations", isOn: $settings.hapticsEnabled)
                        Toggle("Points de regard (diagnostic)", isOn: $settings.showsGazeIndicator)
                    }
                    .tint(DSColor.Navigation.control)
                    .foregroundStyle(DSColor.Identity.textPrimary)
                    DSGlassPanel {
                        Text("regard").dsEyebrowStyle()
                        DSButton("Recalibrer le regard", systemImage: "scope", variant: .secondary) { coordinator.recalibrate() }
                    }
                    DSGlassPanel {
                        Text("confidentialité").dsEyebrowStyle()
                        Text("Le regard est calculé sur l'iPhone, en temps réel. Aucune image, aucune vidéo et aucune donnée du visage n'est enregistrée ni envoyée. Seuls les coefficients de calibration et votre progression sont gardés sur l'appareil.")
                            .font(DSFont.footnote)
                            .foregroundStyle(DSColor.Identity.textSecondary)
                    }
                    #if DEBUG
                    DSGlassPanel {
                        Text("prototypes (debug)").dsEyebrowStyle()
                        Text("Hors campagne. Rien n'est enregistré.")
                            .font(DSFont.footnote)
                            .foregroundStyle(DSColor.Identity.textSecondary)
                        DSButton("Braises A · braise", systemImage: "flame", variant: .secondary) { coordinator.playPrototype(BraisesPrototype.a) }
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
            .dsSoftScrollEdges()
            // The sheet stands in the chambre noire like every other screen: a flat opaque surface left the glass
            // of its panels nothing to transmit.
            .background { DSBackground(intensity: .calm) }
            .navigationTitle("réglages")
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
    SettingsView()
        .environment(AppContainer.preview().makeAppCoordinator())
}
