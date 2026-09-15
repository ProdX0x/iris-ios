// GameOverlayView.swift
// Layer: Presentation
// Purpose: One overlay per game phase: intro, pause, result, interruption, face lost, resume, suspension, failure

import SwiftUI

struct GameOverlayView: View {
    @Bindable var viewModel: GameViewModel
    @Environment(\.openURL) private var openURL

    var body: some View {
        switch viewModel.phase {
        case .initializing:
            DSOverlayPanel(title: "iris", subtitle: "le regard s'éveille…", dim: 0.94) {
                DSIrisMark(size: 72, isBreathing: true)
            }
        case .ready:
            LevelIntroCard(level: viewModel.level, chapter: viewModel.chapter,
                           onStart: { viewModel.primaryAction() }, onChapters: { viewModel.openChapters() })
        case .playing:
            EmptyView()
        case .paused:
            pausePanel
        case let .levelComplete(result):
            LevelResultView(result: result, level: viewModel.level, chapter: viewModel.chapter,
                            onPrimary: { viewModel.primaryAction() }, onReplay: { viewModel.replay() }, onChapters: { viewModel.openChapters() })
        case .interrupted:
            DSOverlayPanel(title: "interrompu",
                           subtitle: "La caméra est utilisée ailleurs. La partie reprendra dès que votre regard sera retrouvé.",
                           tint: DSColor.State.danger) {
                DSButton("Chapitres", variant: .secondary) { viewModel.openChapters() }
            }
        case .resuming:
            DSOverlayPanel(title: "reprise", subtitle: "\(viewModel.chapter.numeral) · \(viewModel.chapter.name) — \(viewModel.level.title)") {
                DSButton("Reprendre", systemImage: "play.fill") { viewModel.primaryAction() }
                DSButton("Chapitres", variant: .ghost) { viewModel.openChapters() }
            }
        case .faceLost:
            DSOverlayPanel(title: "visage perdu",
                           subtitle: "Replacez-vous face à l'écran. La partie reprend d'elle-même.",
                           tint: DSColor.State.danger, dim: 0.75) {
                DSButton("Chapitres", variant: .ghost) { viewModel.openChapters() }
            }
        case .suspended:
            DSOverlayPanel(title: "en pause", subtitle: "Iris attend votre retour.", dim: 0.94) {
                EmptyView()
            }
        case let .failed(failure):
            DSOverlayPanel(title: failure.title, subtitle: failure.message, tint: DSColor.State.danger, dim: 0.94) {
                if failure.canOpenSettings {
                    DSButton("Ouvrir Réglages", systemImage: "gear") {
                        if let url = SystemLinks.appSettings { openURL(url) }
                    }
                }
                DSButton("Réessayer", variant: .secondary) { viewModel.retryAfterFailure() }
                DSButton("Seuil", variant: .ghost) { viewModel.exit() }
            }
        }
    }

    private var pausePanel: some View {
        DSOverlayPanel(title: "pause", subtitle: "\(viewModel.chapter.numeral) · \(viewModel.chapter.name) — \(viewModel.level.title)") {
            DSButton("Reprendre", systemImage: "play.fill") { viewModel.primaryAction() }
            DSButton("Recommencer", variant: .secondary) { viewModel.restartLevel() }
            DSButton("Chapitres", variant: .ghost) { viewModel.openChapters() }
            DSGlassPanel {
                Text("regard").dsEyebrowStyle()
                Text(viewModel.calibrationStatus.description)
                    .font(DSFont.footnote)
                    .foregroundStyle(DSColor.Identity.textSecondary)
                DSButton("Recalibrer le regard", systemImage: "scope", variant: .secondary) { viewModel.requestRecalibration() }
                Toggle("Points de regard (diagnostic)", isOn: $viewModel.showsGazeIndicator)
                    .tint(DSColor.Navigation.control)
                    .foregroundStyle(DSColor.Identity.textPrimary)
                Text("Corail : brut. Menthe : calibré. Ambre : curseur lissé utilisé par le jeu.")
                    .font(DSFont.footnote)
                    .foregroundStyle(DSColor.Identity.textTertiary)
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
