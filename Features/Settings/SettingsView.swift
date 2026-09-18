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
                        Toggle(IrisText.interface("settings.audio.soundEffects", french: "Effets sonores"),
                               isOn: $settings.soundEffectsEnabled)
                        Toggle(IrisText.interface("settings.audio.ambience", french: "Ambiance sonore"), isOn: $settings.ambienceEnabled)
                        Toggle(IrisText.interface("settings.haptics.label", french: "Vibrations"), isOn: $settings.hapticsEnabled)
                    }
                    .tint(DSColor.Navigation.control)
                    .foregroundStyle(DSColor.Identity.textPrimary)
                    GazeAssistanceSection(mode: $settings.gazeAssistance) { coordinator.showGazeIntroduction() }
                    DSGlassPanel {
                        Text(IrisText.interface("settings.gaze.eyebrow", french: "regard")).dsEyebrowStyle()
                        DSButton(IrisText.interface("settings.recalibrate.action", french: "Recalibrer le regard"), systemImage: "scope", variant: .secondary) { coordinator.recalibrate() }
                    }
                    DSGlassPanel {
                        Text(IrisText.interface("settings.understand.eyebrow", french: "comprendre iris")).dsEyebrowStyle()
                        DSButton(IrisText.interface("howToPlay.title", french: "Comment jouer"), systemImage: "questionmark.circle", variant: .secondary) { coordinator.showHowToPlay() }
                    }
                    DSGlassPanel {
                        Text(IrisText.interface("settings.access.eyebrow", french: "accès")).dsEyebrowStyle()
                        Text(accessSummary)
                            .font(DSFont.footnote)
                            .foregroundStyle(DSColor.Identity.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                        if coordinator.entitlement != .fullAccess {
                            DSButton(IrisText.interface("paywall.title", french: "Accès complet"), systemImage: "lock.open", variant: .secondary) { coordinator.presentPaywall() }
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
                        Text(IrisText.interface("settings.privacy.eyebrow", french: "confidentialité")).dsEyebrowStyle()
                        Text(IrisText.interface("settings.privacy.detail", french: "Le regard est calculé sur l'iPhone, en temps réel. Aucune image, aucune vidéo et aucune donnée du visage n'est enregistrée ni envoyée. Seuls les coefficients de calibration et votre progression sont gardés sur l'appareil."))
                            .font(DSFont.footnote)
                            .foregroundStyle(DSColor.Identity.textSecondary)
                    }
                    DSGlassPanel {
                        Text(IrisText.interface("about.title", french: "à propos")).dsEyebrowStyle()
                        NavigationLink {
                            AboutView()
                        } label: {
                            Label(IrisText.interface("about.entry.action", french: "À propos & informations légales"), systemImage: "info.circle")
                                .font(DSFont.headline)
                                .frame(maxWidth: .infinity, minHeight: 52, alignment: .leading)
                                .contentShape(Rectangle())
                        }
                        .foregroundStyle(DSColor.Navigation.control)
                        .accessibilityHint(IrisText.interface("about.entry.hint", french: "Identité, version, liens et confidentialité"))
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
                    DSButton(IrisText.interface("settings.reset.action", french: "Réinitialiser la progression"), variant: .ghost) { confirmsReset = true }
                        .confirmationDialog(IrisText.interface("settings.reset.confirm", french: "Effacer tous les niveaux atteints et les éclats ?"), isPresented: $confirmsReset, titleVisibility: .visible) {
                            Button(IrisText.interface("settings.reset.confirmAction", french: "Réinitialiser"), role: .destructive) { coordinator.resetProgress() }
                            Button(IrisText.interface("common.cancel", french: "Annuler"), role: .cancel) {}
                        }
                }
                .padding(DSSpacing.gutter)
            }
            .dsSoftScrollEdges()
            // The sheet stands in the chambre noire like every other screen: a flat opaque surface left the glass
            // of its panels nothing to transmit.
            .background { DSBackground(intensity: .calm) }
            .navigationTitle(IrisText.interface("settings.navigationTitle", french: "réglages"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(IrisText.interface("common.close", french: "Fermer")) { coordinator.dismissSheet() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    /// What the player holds right now, in one sentence; the chapters that stay free are read from the policy.
    private var accessSummary: String {
        switch coordinator.entitlement {
        case .fullAccess: IrisText.interface("access.full.summary", french: "Iris est ouvert en entier sur ce compte Apple.")
        case .promotionalAccess: IrisText.interface("access.promotional.summary", french: "Un accès temporaire ouvre Iris en entier. À sa fin, les chapitres gratuits restent ouverts.")
        case .free: PaywallCopy.freeChapters
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppContainer.preview().makeAppCoordinator())
}
