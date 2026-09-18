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
            DSOverlayPanel(title: "iris", subtitle: IrisText.interface("game.gazeWaking", french: "le regard s'éveille…"), dim: 0.94) {
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
            DSOverlayPanel(title: IrisText.interface("game.interrupted.title", french: "interrompu"),
                           subtitle: IrisText.interface("game.cameraBusy.detail", french: "La caméra est utilisée ailleurs. La partie reprendra dès que votre regard sera retrouvé."),
                           tint: DSColor.State.danger) {
                DSButton(IrisText.interface("common.chapters", french: "Chapitres"), variant: .secondary) { viewModel.openChapters() }
            }
        case .resuming:
            DSOverlayPanel(title: IrisText.interface("game.resuming.title", french: "reprise"), subtitle: IrisText.interface("common.chapterLevel.line", french: "%@ · %@ — %@",
                                                        viewModel.chapter.numeral, CampaignText.name(of: viewModel.chapter),
                                                        CampaignText.title(of: viewModel.level))) {
                DSButton(IrisText.interface("common.resume", french: "Reprendre"), systemImage: "play.fill") { viewModel.primaryAction() }
                DSButton(IrisText.interface("common.chapters", french: "Chapitres"), variant: .ghost) { viewModel.openChapters() }
            }
        case .faceLost:
            DSOverlayPanel(title: IrisText.interface("game.faceLost.title", french: "visage perdu"),
                           subtitle: IrisText.interface("game.faceLost.detail", french: "Replacez-vous face à l'écran. La partie reprend d'elle-même."),
                           tint: DSColor.State.danger, dim: 0.75) {
                DSButton(IrisText.interface("common.chapters", french: "Chapitres"), variant: .ghost) { viewModel.openChapters() }
            }
        case .suspended:
            DSOverlayPanel(title: IrisText.interface("pause.title", french: "en pause"), subtitle: IrisText.interface("pause.detail", french: "Iris attend votre retour."), dim: 0.94) {
                EmptyView()
            }
        case let .failed(failure):
            DSOverlayPanel(title: failure.title, subtitle: failure.message, tint: DSColor.State.danger, dim: 0.94) {
                if failure.canOpenSettings {
                    DSButton(IrisText.interface("common.openSettings", french: "Ouvrir Réglages"), systemImage: "gear") {
                        if let url = SystemLinks.appSettings { openURL(url) }
                    }
                }
                DSButton(IrisText.interface("common.retry", french: "Réessayer"), variant: .secondary) { viewModel.retryAfterFailure() }
                DSButton(IrisText.interface("common.threshold", french: "Seuil"), variant: .ghost) { viewModel.exit() }
            }
        }
    }

    private var pausePanel: some View {
        DSOverlayPanel(title: IrisText.interface("pause.panel.title", french: "pause"), subtitle: IrisText.interface("common.chapterLevel.line", french: "%@ · %@ — %@",
                                                        viewModel.chapter.numeral, CampaignText.name(of: viewModel.chapter),
                                                        CampaignText.title(of: viewModel.level))) {
            DSButton(IrisText.interface("common.resume", french: "Reprendre"), systemImage: "play.fill") { viewModel.primaryAction() }
            DSButton(IrisText.interface("common.restart", french: "Recommencer"), variant: .secondary) { viewModel.restartLevel() }
            DSButton(IrisText.interface("common.chapters", french: "Chapitres"), variant: .ghost) { viewModel.openChapters() }
            DSGlassPanel {
                Text(IrisText.interface("pause.gaze.eyebrow", french: "regard")).dsEyebrowStyle()
                Text(viewModel.calibrationStatus.description)
                    .font(DSFont.footnote)
                    .foregroundStyle(DSColor.Identity.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                // A percentage says nothing by itself. One line, right under it, says which way is better.
                if let explanation = viewModel.calibrationStatus.explanation {
                    Text(explanation)
                        .font(DSFont.footnote)
                        .foregroundStyle(DSColor.Identity.textTertiary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                DSButton(IrisText.interface("settings.recalibrate.action", french: "Recalibrer le regard"), systemImage: "scope", variant: .secondary) { viewModel.requestRecalibration() }
                // The same choice as the settings, over the same value: changing it here changes it there, and the
                // level obeys as soon as play resumes. Compact, because a player in pause wants one tap, not a page.
                Text(IrisText.interface("gazeAssistance.eyebrow", french: "aide au regard")).dsEyebrowStyle()
                GazeAssistancePicker(mode: $viewModel.gazeAssistance,
                                     variant: .compact,
                                     isLearning: viewModel.isGazeLearningActive)
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
