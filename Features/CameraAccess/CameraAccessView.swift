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
            Text("avant de jouer")
                .dsEyebrowStyle(tint: DSColor.Identity.accent)
            Text("la caméra lit votre regard")
                .font(DSFont.title)
                .foregroundStyle(DSColor.Identity.textPrimary)
                .accessibilityAddTraits(.isHeader)

            DSGlassPanel {
                DSStatusRow(systemImage: "faceid", title: "Caméra TrueDepth",
                            detail: "Estime la direction du regard, environ soixante fois par seconde.", state: rowState)
                DSStatusRow(systemImage: "lock.shield", title: "Traitement local",
                            detail: "Aucune image n'est enregistrée ni envoyée. Rien ne quitte l'appareil.", state: .ok)
                DSStatusRow(systemImage: "eye.slash", title: "Aucune calibration",
                            detail: "Le jeu démarre dès que votre visage est détecté.", state: .ok)
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
            Text("iOS va vous demander l'autorisation d'utiliser la caméra frontale. Elle sert uniquement à détecter où vous regardez.")
                .font(DSFont.body)
                .foregroundStyle(DSColor.Identity.textSecondary)
            DSButton("Autoriser la caméra", systemImage: "camera") {
                Task { await viewModel.requestAccess() }
            }
            DSButton("Plus tard", variant: .ghost) { viewModel.abandon() }
        case .requesting:
            HStack(spacing: DSSpacing.m) {
                ProgressView()
                    .tint(DSColor.Navigation.control)
                Text("Demande d'accès en cours…")
                    .font(DSFont.body)
                    .foregroundStyle(DSColor.Identity.textSecondary)
            }
        case .denied:
            Text("L'accès à la caméra a été refusé. Sans regard, Iris ne peut pas fonctionner. Vous pouvez l'autoriser dans Réglages, puis revenir ici.")
                .font(DSFont.body)
                .foregroundStyle(DSColor.Identity.textSecondary)
            DSButton("Ouvrir Réglages", systemImage: "gear") {
                if let url = SystemLinks.appSettings { openURL(url) }
            }
            DSButton("Retour", variant: .ghost) { viewModel.abandon() }
        case .restricted:
            Text("L'accès à la caméra est restreint sur cet appareil (temps d'écran, profil de gestion). Iris ne peut pas lire le regard tant que cette restriction est active.")
                .font(DSFont.body)
                .foregroundStyle(DSColor.Identity.textSecondary)
            DSButton("Retour", variant: .secondary) { viewModel.abandon() }
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
