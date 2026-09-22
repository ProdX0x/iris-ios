// UnavailableView.swift
// Layer: Presentation
// Purpose: Shown when the device cannot track faces (no TrueDepth / ARFaceTracking unsupported)

import SwiftUI

struct UnavailableView: View {
    let reason: DeviceUnavailability
    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        DSScreen {
            Text(IrisText.interface("unavailable.eyebrow", french: "appareil"))
                .dsEyebrowStyle(tint: DSColor.State.danger)
            Text(title)
                .font(DSFont.title)
                .foregroundStyle(DSColor.Identity.textPrimary)
                .accessibilityAddTraits(.isHeader)
            Text(message)
                .font(DSFont.body)
                .foregroundStyle(DSColor.Identity.textSecondary)
            DSGlassPanel {
                DSStatusRow(systemImage: "faceid", title: IrisText.interface("unavailable.faceTracking.label", french: "Suivi facial ARKit"), detail: IrisText.interface("unavailable.faceTracking.detail", french: "Non pris en charge sur cet appareil"), state: .error)
                DSStatusRow(systemImage: "iphone", title: IrisText.interface("unavailable.devices.label", french: "Compatibilité"),
                            detail: IrisText.interface("unavailable.devices.detail", french: "Vérifiée sur cet appareil par ARKit"), state: .warning)
            }
            DSButton(IrisText.interface("common.back", french: "Retour"), variant: .secondary) { coordinator.returnHome() }
        }
    }

    private var title: String {
        switch reason {
        case .faceTrackingUnsupported: IrisText.interface("gaze.unavailable.title", french: "regard indisponible")
        }
    }

    private var message: String {
        switch reason {
        case .faceTrackingUnsupported:
            IrisText.interface("unavailable.detail", french: "Iris se joue uniquement avec le regard, estimé à l'aide du suivi facial ARKit et de la caméra frontale. Cet appareil ne prend pas en charge cette fonction.")
        }
    }
}

#Preview {
    UnavailableView(reason: .faceTrackingUnsupported)
        .environment(AppContainer.preview().makeAppCoordinator())
}
