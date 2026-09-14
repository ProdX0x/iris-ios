// UnavailableView.swift
// Layer: Presentation
// Purpose: Shown when the device cannot track faces (no TrueDepth / ARFaceTracking unsupported)

import SwiftUI

struct UnavailableView: View {
    let reason: DeviceUnavailability
    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        DSScreen {
            Text("appareil")
                .dsEyebrowStyle(tint: DSColor.State.danger)
            Text(title)
                .font(DSFont.title)
                .foregroundStyle(DSColor.Identity.textPrimary)
                .accessibilityAddTraits(.isHeader)
            Text(message)
                .font(DSFont.body)
                .foregroundStyle(DSColor.Identity.textSecondary)
            DSCard(style: .flat) {
                DSStatusRow(systemImage: "faceid", title: "Suivi facial ARKit", detail: "Non pris en charge sur cet appareil", state: .error)
                DSStatusRow(systemImage: "iphone", title: "Appareils compatibles",
                            detail: "iPhone et iPad équipés de Face ID (caméra TrueDepth)", state: .warning)
            }
            DSButton("Retour", variant: .secondary) { coordinator.returnHome() }
        }
    }

    private var title: String {
        switch reason {
        case .faceTrackingUnsupported: "regard indisponible"
        }
    }

    private var message: String {
        switch reason {
        case .faceTrackingUnsupported:
            "Iris se joue uniquement avec le regard, lu par la caméra TrueDepth. Cet appareil ne dispose pas du suivi facial nécessaire."
        }
    }
}

#Preview {
    UnavailableView(reason: .faceTrackingUnsupported)
        .environment(AppContainer.preview().makeAppCoordinator())
}
