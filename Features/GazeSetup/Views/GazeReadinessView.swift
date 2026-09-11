// GazeReadinessView.swift
// Layer: Presentation
// Purpose: Diagnostic checklist with a central fixation mark

import SwiftUI

struct GazeReadinessView: View {
    let report: GazeReadinessReport
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: DSSpacing.m) {
            VStack(spacing: DSSpacing.xs) {
                Text("diagnostic du regard").dsEyebrowStyle(tint: DSColor.accent)
                Text(report.isReady ? "regard prêt pour la calibration" : "regardez le point")
                    .font(DSFont.title2)
                    .foregroundStyle(DSColor.textPrimary)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isHeader)
            }
            .padding(.top, DSSpacing.m)

            FixationMark(progress: report.isReady ? 1 : 0, isCollecting: report.isReady, tint: report.isReady ? DSColor.statusSuccess : DSColor.accent)
                .frame(width: 56, height: 56)

            ScrollView(showsIndicators: false) {
                DSCard(style: .glass) {
                    ForEach(report.checks) { check in
                        DSStatusRow(systemImage: symbol(for: check.kind), title: check.kind.title, detail: check.detail, state: state(for: check.status))
                    }
                }
                .padding(.horizontal, DSSpacing.gutter)
                Text(report.isReady ? "La calibration démarre dans un instant. Gardez la tête immobile." : "Tenez l'iPhone droit devant vous, à 30 ou 40 cm, et fixez le point.")
                    .font(DSFont.footnote)
                    .foregroundStyle(DSColor.textTertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DSSpacing.gutter)
                    .padding(.top, DSSpacing.s)
            }

            DSButton("Annuler", variant: .ghost, action: onCancel)
                .padding(.horizontal, DSSpacing.gutter)
                .padding(.bottom, DSSpacing.s)
        }
    }

    private func state(for status: ReadinessStatus) -> DSStatusRow.State {
        switch status {
        case .pending: .pending
        case .pass: .ok
        case .fail: .error
        }
    }

    private func symbol(for kind: ReadinessCheckKind) -> String {
        switch kind {
        case .faceTracking: "faceid"
        case .cameraAccess: "camera"
        case .session: "arkit"
        case .faceDetected: "person.crop.circle"
        case .eyeTracking: "eye"
        case .gazeDirection: "scope"
        case .headStable: "figure.stand"
        case .signalStable: "waveform.path.ecg"
        case .blinkDetection: "eye.slash"
        case .axisMapping: "arrow.up.left.and.arrow.down.right"
        }
    }
}

/// Calm target: soft halo, thin ring that fills while samples are collected, small core.
struct FixationMark: View {
    let progress: Double
    let isCollecting: Bool
    let tint: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(tint.opacity(0.14))
            Circle()
                .strokeBorder(tint.opacity(0.35), lineWidth: 1)
                .padding(6)
            Circle()
                .trim(from: 0, to: min(max(progress, 0), 1))
                .stroke(tint, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .padding(6)
            Circle()
                .fill(tint)
                .frame(width: 10, height: 10)
        }
        .accessibilityHidden(true)
    }
}
