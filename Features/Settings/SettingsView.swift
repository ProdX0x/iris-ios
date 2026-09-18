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
                        Toggle(String(localized: "settings.audio.soundEffects", defaultValue: "Effets sonores",
                                      comment: "Settings: the short sounds the game plays on events"),
                               isOn: $settings.soundEffectsEnabled)
                        Toggle("Ambiance sonore", isOn: $settings.ambienceEnabled)
                        Toggle("Vibrations", isOn: $settings.hapticsEnabled)
                    }
                    .tint(DSColor.Navigation.control)
                    .foregroundStyle(DSColor.Identity.textPrimary)
                    GazeAssistanceSection(mode: $settings.gazeAssistance) { coordinator.showGazeIntroduction() }
                    DSGlassPanel {
                        Text("regard").dsEyebrowStyle()
                        DSButton("Recalibrer le regard", systemImage: "scope", variant: .secondary) { coordinator.recalibrate() }
                    }
                    DSGlassPanel {
                        Text("comprendre iris").dsEyebrowStyle()
                        DSButton("Comment jouer", systemImage: "questionmark.circle", variant: .secondary) { coordinator.showHowToPlay() }
                    }
                    DSGlassPanel {
                        Text("accès").dsEyebrowStyle()
                        Text(accessSummary)
                            .font(DSFont.footnote)
                            .foregroundStyle(DSColor.Identity.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                        if coordinator.entitlement != .fullAccess {
                            DSButton("Accès complet", systemImage: "lock.open", variant: .secondary) { coordinator.presentPaywall() }
                        }
                        DSButton(PaywallCopy.restore, variant: .ghost) {
                            Task { await coordinator.store.restorePurchases() }
                        }
                        .disabled(coordinator.store.isWorking)
                        if let notice = coordinator.store.lastOutcome?.notice {
                            Text(notice)
                                .font(DSFont.caption)
                                .foregroundStyle(coordinator.store.lastOutcome?.isFailure == true ? DSColor.State.danger : DSColor.State.success)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    DSGlassPanel {
                        Text("confidentialité").dsEyebrowStyle()
                        Text("Le regard est calculé sur l'iPhone, en temps réel. Aucune image, aucune vidéo et aucune donnée du visage n'est enregistrée ni envoyée. Seuls les coefficients de calibration et votre progression sont gardés sur l'appareil.")
                            .font(DSFont.footnote)
                            .foregroundStyle(DSColor.Identity.textSecondary)
                    }
                    DSGlassPanel {
                        Text("à propos").dsEyebrowStyle()
                        NavigationLink {
                            AboutView()
                        } label: {
                            Label("À propos & informations légales", systemImage: "info.circle")
                                .font(DSFont.headline)
                                .frame(maxWidth: .infinity, minHeight: 52, alignment: .leading)
                                .contentShape(Rectangle())
                        }
                        .foregroundStyle(DSColor.Navigation.control)
                        .accessibilityHint("Identité, version, liens et confidentialité")
                    }
                    #if DEBUG
                    DSGlassPanel {
                        Text("diagnostics (debug)").dsEyebrowStyle()
                        Toggle("Points bruts et calibrés", isOn: $settings.showsDeveloperGazeDiagnostics)
                            .tint(DSColor.Navigation.control)
                            .foregroundStyle(DSColor.Identity.textPrimary)
                        Text("Corail : brut. Menthe : calibré. Outil de développement, absent des versions publiées.")
                            .font(DSFont.footnote)
                            .foregroundStyle(DSColor.Identity.textSecondary)
                    }
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

    /// What the player holds right now, in one sentence; the chapters that stay free are read from the policy.
    private var accessSummary: String {
        switch coordinator.entitlement {
        case .fullAccess: "Iris est ouvert en entier sur ce compte Apple."
        case .promotionalAccess: "Un accès temporaire ouvre Iris en entier. À sa fin, les chapitres gratuits restent ouverts."
        case .free: PaywallCopy.freeChapters
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppContainer.preview().makeAppCoordinator())
}
