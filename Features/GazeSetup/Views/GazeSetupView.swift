// GazeSetupView.swift
// Layer: Presentation
// Purpose: Gaze diagnostic, calibration targets, validation and verdict screens

import SwiftUI

struct GazeSetupView: View {
    let viewModel: GazeSetupViewModel
    @Environment(\.displayScale) private var displayScale
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openURL) private var openURL

    var body: some View {
        ZStack {
            DSBackground(intensity: .calm)
            content
            GazeLiveDotsView(viewModel: viewModel)
        }
        .background(DSColor.Identity.ground)
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { size in
            viewModel.prepare(width: size.width, height: size.height, displayScale: displayScale)
        }
        .statusBarHidden(true)
        .onDisappear { viewModel.viewDisappeared() }
        .onChange(of: scenePhase) { _, phase in
            switch phase {
            case .background, .inactive: viewModel.suspend()
            case .active: viewModel.wake()
            @unknown default: break
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.phase {
        case .starting:
            VStack(spacing: DSSpacing.l) {
                DSIrisMark(size: 90, isBreathing: true)
                Text(IrisText.interface("gazeSetup.starting", french: "démarrage du suivi du regard…"))
                    .font(DSFont.callout)
                    .foregroundStyle(DSColor.Identity.textSecondary)
            }
        case let .readiness(report):
            GazeReadinessView(report: report, onCancel: { viewModel.cancel() })
        case let .calibrating(display):
            FixationTargetView(display: display, stageLabel: "calibration", viewport: viewModel.viewport, onCancel: { viewModel.cancel() })
        case let .validating(display):
            FixationTargetView(display: display, stageLabel: IrisText.interface("gazeSetup.verification.eyebrow", french: "vérification"), viewport: viewModel.viewport, onCancel: { viewModel.cancel() })
        case let .insufficient(result, attempts):
            GazeVerdictView(result: result, isAccepted: false, attempts: attempts,
                            onPrimary: { viewModel.recalibrate() },
                            onSecondary: { viewModel.continueAnyway() },
                            onCancel: { viewModel.cancel() })
        case let .ready(result):
            GazeVerdictView(result: result, isAccepted: true, attempts: 0,
                            onPrimary: { viewModel.finish() },
                            onSecondary: { viewModel.recalibrate() },
                            onCancel: { viewModel.cancel() })
        case .suspended:
            DSOverlayPanel(title: IrisText.interface("pause.title", french: "en pause"), subtitle: IrisText.interface("pause.detail", french: "Iris attend votre retour."), dim: 0.94) { EmptyView() }
        case let .failed(failure):
            DSOverlayPanel(title: failure.title, subtitle: failure.message, tint: DSColor.State.danger, dim: 0.94) {
                if failure == .cameraDenied {
                    DSButton(IrisText.interface("common.openSettings", french: "Ouvrir Réglages"), systemImage: "gear") {
                        if let url = SystemLinks.appSettings { openURL(url) }
                    }
                }
                DSButton(IrisText.interface("common.retry", french: "Réessayer"), variant: .secondary) { viewModel.recalibrate() }
                DSButton(IrisText.interface("common.cancel", french: "Annuler"), variant: .ghost) { viewModel.cancel() }
            }
        }
    }
}

/// Live raw (coral) and calibrated (mint) dots, drawn above every phase when enabled.
private struct GazeLiveDotsView: View {
    let viewModel: GazeSetupViewModel

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if let raw = viewModel.liveRaw {
                    Circle()
                        .strokeBorder(DSColor.State.danger.opacity(0.8), lineWidth: 1.5)
                        .frame(width: 16, height: 16)
                        .position(x: raw.x * proxy.size.width, y: raw.y * proxy.size.height)
                }
                if let calibrated = viewModel.liveCalibrated {
                    Circle()
                        .fill(DSColor.State.success.opacity(0.9))
                        .frame(width: 12, height: 12)
                        .position(x: calibrated.x * proxy.size.width, y: calibrated.y * proxy.size.height)
                }
            }
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}

#Preview("Readiness") {
    let container = AppContainer.preview()
    GazeSetupView(viewModel: container.makeGazeSetupViewModel(intent: .firstRun, navigator: container.makeAppCoordinator()))
}
