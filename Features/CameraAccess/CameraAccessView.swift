// CameraAccessView.swift
// Layer: Presentation
// Purpose: Explains why the TrueDepth camera is needed and handles denied and restricted states

import SwiftUI

struct CameraAccessView: View {
    let viewModel: CameraAccessViewModel
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        DSScreen {
            Text(IrisText.interface("camera.eyebrow", french: "avant de jouer"))
                .dsEyebrowStyle(tint: DSColor.Identity.accent)
            Text(IrisText.interface("camera.headline", french: "la caméra lit votre regard"))
                .font(DSFont.title)
                .foregroundStyle(DSColor.Identity.textPrimary)
                .accessibilityAddTraits(.isHeader)

            DSGlassPanel {
                DSStatusRow(systemImage: "faceid", title: IrisText.interface("camera.trueDepth.title", french: "Caméra frontale"),
                            detail: IrisText.interface("camera.trueDepth.detail", french: "Estime la direction du regard, environ soixante fois par seconde."), state: rowState)
                DSStatusRow(systemImage: "lock.shield", title: IrisText.interface("camera.localProcessing.title", french: "Traitement local"),
                            detail: IrisText.interface("camera.localProcessing.detail", french: "Aucune image n'est enregistrée ni envoyée. Rien ne quitte l'appareil."), state: .ok)
                DSStatusRow(systemImage: "eye.slash", title: IrisText.interface("camera.noCalibration.title", french: "Aucune calibration"),
                            detail: IrisText.interface("camera.noCalibration.detail", french: "Le jeu démarre dès que votre visage est détecté."), state: .ok)
            }

            content
        }
        .task { viewModel.refresh() }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { viewModel.refresh() }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.phase {
        case .explain:
            Text(IrisText.interface("camera.request.detail", french: "iOS va vous demander l'autorisation d'utiliser la caméra frontale. Elle sert uniquement à détecter où vous regardez."))
                .font(DSFont.body)
                .foregroundStyle(DSColor.Identity.textSecondary)
            DSButton(IrisText.interface("camera.allow.action", french: "Autoriser la caméra"), systemImage: "camera") {
                Task { await viewModel.requestAccess() }
            }
            DSButton(IrisText.interface("camera.later.action", french: "Plus tard"), variant: .ghost) { viewModel.abandon() }
        case .requesting:
            HStack(spacing: DSSpacing.m) {
                ProgressView()
                    .tint(DSColor.Navigation.control)
                Text(IrisText.interface("camera.requesting", french: "Demande d'accès en cours…"))
                    .font(DSFont.body)
                    .foregroundStyle(DSColor.Identity.textSecondary)
            }
        case .denied:
            Text(IrisText.interface("camera.denied.detail", french: "L'accès à la caméra a été refusé. Sans regard, Iris ne peut pas fonctionner. Vous pouvez l'autoriser dans Réglages, puis revenir ici."))
                .font(DSFont.body)
                .foregroundStyle(DSColor.Identity.textSecondary)
            DSButton(IrisText.interface("common.openSettings", french: "Ouvrir Réglages"), systemImage: "gear") {
                if let url = SystemLinks.appSettings { openURL(url) }
            }
            DSButton(IrisText.interface("common.back", french: "Retour"), variant: .ghost) { viewModel.abandon() }
        case .restricted:
            Text(IrisText.interface("camera.restricted.detail", french: "L'accès à la caméra est restreint sur cet appareil (temps d'écran, profil de gestion). Iris ne peut pas lire le regard tant que cette restriction est active."))
                .font(DSFont.body)
                .foregroundStyle(DSColor.Identity.textSecondary)
            DSButton(IrisText.interface("common.back", french: "Retour"), variant: .secondary) { viewModel.abandon() }
        }
    }

    private var rowState: DSStatusRow.State {
        switch viewModel.phase {
        case .explain, .requesting: .pending
        case .denied, .restricted: .error
        }
    }
}

#Preview("Explain") {
    let container = AppContainer.preview(cameraStatus: .notDetermined)
    CameraAccessView(viewModel: container.makeCameraAccessViewModel(navigator: container.makeAppCoordinator()))
}

#Preview("Denied") {
    let container = AppContainer.preview(cameraStatus: .denied)
    CameraAccessView(viewModel: container.makeCameraAccessViewModel(navigator: container.makeAppCoordinator()))
}

#Preview("Restricted") {
    let container = AppContainer.preview(cameraStatus: .restricted)
    CameraAccessView(viewModel: container.makeCameraAccessViewModel(navigator: container.makeAppCoordinator()))
}
