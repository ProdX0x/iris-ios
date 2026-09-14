// GazeVerdictView.swift
// Layer: Presentation
// Purpose: "Regard prêt" or "La précision peut être améliorée" with measured errors and actions

import SwiftUI

struct GazeVerdictView: View {
    let result: ValidationResult
    let isAccepted: Bool
    let attempts: Int
    let onPrimary: () -> Void
    let onSecondary: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: DSSpacing.l) {
            Spacer()
            VStack(spacing: DSSpacing.s) {
                Text(isAccepted ? "calibration validée" : "précision insuffisante")
                    .dsEyebrowStyle(tint: isAccepted ? DSColor.State.success : DSColor.State.danger)
                Text(isAccepted ? "regard prêt" : "la précision peut être améliorée")
                    .font(DSFont.display)
                    .foregroundStyle(DSColor.Identity.textPrimary)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isHeader)
                Text(isAccepted
                     ? "Le point menthe suit votre regard. Vérifiez qu'il se pose bien là où vous regardez, puis continuez."
                     : "Les cibles de contrôle n'ont pas été retrouvées avec assez de précision. Recalibrez en tenant l'iPhone droit, sans bouger la tête.")
                    .font(DSFont.callout)
                    .foregroundStyle(DSColor.Identity.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, DSSpacing.gutter)

            DSCard(style: .glass) {
                HStack {
                    metric(label: "erreur moyenne", value: result.meanError)
                    Spacer()
                    metric(label: "erreur maximale", value: result.maxError)
                }
                Text("en pourcentage de la petite dimension de l'écran (seuils 18 % et 30 %)")
                    .font(DSFont.footnote)
                    .foregroundStyle(DSColor.Identity.textTertiary)
            }
            .padding(.horizontal, DSSpacing.gutter)

            VStack(spacing: DSSpacing.s) {
                if isAccepted {
                    DSButton("Continuer", systemImage: "arrow.right", action: onPrimary)
                    DSButton("Recalibrer", variant: .ghost, action: onSecondary)
                } else {
                    DSButton("Recalibrer", systemImage: "scope", action: onPrimary)
                    if attempts >= 1 {
                        DSButton("Continuer quand même", variant: .secondary, action: onSecondary)
                    }
                    DSButton("Annuler", variant: .ghost, action: onCancel)
                }
            }
            .padding(.horizontal, DSSpacing.gutter)
            .padding(.bottom, DSSpacing.xl)
        }
    }

    private func metric(label: String, value: Double) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text(label).dsEyebrowStyle()
            Text("\(Int((value * 100).rounded())) %")
                .font(DSFont.title2)
                .foregroundStyle(DSColor.Identity.textPrimary)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview("Ready") {
    GazeVerdictView(result: ValidationResult(measurements: [
        ValidationResult.Measurement(target: SIMD2(0.5, 0.5), measured: SIMD2(0.52, 0.5), error: 0.05),
        ValidationResult.Measurement(target: SIMD2(0.15, 0.5), measured: SIMD2(0.2, 0.48), error: 0.11),
    ]), isAccepted: true, attempts: 0, onPrimary: {}, onSecondary: {}, onCancel: {})
    .background(DSColor.Identity.ground)
}
