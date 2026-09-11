// GameOverlayView.swift
// Layer: Presentation
// Purpose: One overlay per game phase: ready, pause, level end, interruption, resume, failure

import SwiftUI

struct GameOverlayView: View {
    @Bindable var viewModel: GameViewModel
    @Environment(\.openURL) private var openURL

    var body: some View {
        switch viewModel.phase {
        case .initializing:
            DSOverlayPanel(title: "iris", subtitle: "initialisation du regard…", dim: 0.94) {
                DSIrisMark(size: 72, isBreathing: true)
            }
        case .ready:
            tapPanel(title: "iris", subtitle: readySubtitle, action: "Commencer")
        case .playing:
            EmptyView()
        case .paused:
            pausePanel
        case let .levelComplete(number, isLast):
            DSOverlayPanel(title: "niveau terminé", subtitle: "niveau \(number) / \(viewModel.levelCount)", tint: DSColor.statusSuccess) {
                DSButton(isLast ? "Voir le parcours" : "Continuer", systemImage: isLast ? "flag.checkered" : "arrow.right") {
                    viewModel.primaryAction()
                }
                DSButton("Quitter", variant: .ghost) { viewModel.exit() }
            }
        case .interrupted:
            DSOverlayPanel(title: "session interrompue",
                           subtitle: "La caméra est utilisée ailleurs ou l'app a été interrompue. Le jeu reprendra dès que le suivi du regard sera de retour.",
                           tint: DSColor.statusDanger) {
                DSButton("Quitter", variant: .secondary) { viewModel.exit() }
            }
        case .resuming:
            tapPanel(title: "reprise", subtitle: "touchez l'écran pour reprendre", action: "Reprendre")
        case .faceLost:
            DSOverlayPanel(title: "visage perdu",
                           subtitle: "Replacez-vous face à l'écran. La partie reprend d'elle-même dès que votre regard est retrouvé.",
                           tint: DSColor.statusDanger, dim: 0.8) {
                DSButton("Quitter", variant: .ghost) { viewModel.exit() }
            }
        case .suspended:
            DSOverlayPanel(title: "en pause", subtitle: "Iris attend votre retour.", dim: 0.94) {
                EmptyView()
            }
        case let .failed(failure):
            DSOverlayPanel(title: failure.title, subtitle: failure.message, tint: DSColor.statusDanger, dim: 0.94) {
                if failure.canOpenSettings {
                    DSButton("Ouvrir Réglages", systemImage: "gear") {
                        if let url = SystemLinks.appSettings { openURL(url) }
                    }
                }
                DSButton("Réessayer", variant: .secondary) { viewModel.retryAfterFailure() }
                DSButton("Quitter", variant: .ghost) { viewModel.exit() }
            }
        }
    }

    private var readySubtitle: String {
        switch viewModel.gazeState {
        case .tracking(true): "touchez l'écran pour commencer"
        case .tracking(false): "placez votre visage face à l'écran, puis touchez pour commencer"
        default: "touchez l'écran pour commencer"
        }
    }

    private func tapPanel(title: String, subtitle: String, action: String) -> some View {
        Button(action: { viewModel.primaryAction() }) {
            DSOverlayPanel(title: title, subtitle: subtitle) {
                Text(action)
                    .dsEyebrowStyle(tint: DSColor.accent)
                    .padding(.top, DSSpacing.s)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(action)
    }

    private var pausePanel: some View {
        DSOverlayPanel(title: "pause", subtitle: "niveau \(viewModel.levelNumber) / \(viewModel.levelCount)") {
            DSButton("Reprendre", systemImage: "play.fill") { viewModel.primaryAction() }
            DSButton("Recommencer le niveau", variant: .secondary) { viewModel.restartLevel() }
            DSButton("Quitter", variant: .ghost) { viewModel.exit() }
            DSCard(style: .glass) {
                Text("regard").dsEyebrowStyle()
                Text(viewModel.calibrationStatus.description)
                    .font(DSFont.footnote)
                    .foregroundStyle(DSColor.textSecondary)
                DSButton("Recalibrer le regard", systemImage: "scope", variant: .secondary) { viewModel.requestRecalibration() }
                Toggle("Afficher les points de regard", isOn: $viewModel.showsGazeIndicator)
                    .tint(DSColor.accent)
                    .foregroundStyle(DSColor.textPrimary)
                Text("Corail : brut. Menthe : calibré. Ambre : curseur lissé utilisé par le jeu.")
                    .font(DSFont.footnote)
                    .foregroundStyle(DSColor.textTertiary)
            }
        }
    }
}

/// Reads only the phase-related properties of the ViewModel.
struct GameOverlayHost: View {
    let viewModel: GameViewModel

    var body: some View {
        GameOverlayView(viewModel: viewModel)
    }
}
