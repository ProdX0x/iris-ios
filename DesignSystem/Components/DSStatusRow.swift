// DSStatusRow.swift
// Layer: DesignSystem
// Purpose: Icon, title, detail and a coloured state dot; used for capability and permission lists

import SwiftUI

struct DSStatusRow: View {
    enum State {
        case pending
        case ok
        case warning
        case error
    }

    private let systemImage: String
    private let title: String
    private let detail: String?
    private let state: State

    init(systemImage: String, title: String, detail: String? = nil, state: State) {
        self.systemImage = systemImage
        self.title = title
        self.detail = detail
        self.state = state
    }

    var body: some View {
        HStack(alignment: .top, spacing: DSSpacing.m) {
            Image(systemName: systemImage)
                .font(DSFont.headline)
                .foregroundStyle(DSColor.accent)
                .frame(width: DSSpacing.l)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                Text(title)
                    .font(DSFont.body)
                    .foregroundStyle(DSColor.textPrimary)
                if let detail {
                    Text(detail)
                        .font(DSFont.footnote)
                        .foregroundStyle(DSColor.textSecondary)
                }
            }
            Spacer(minLength: DSSpacing.s)
            Circle()
                .fill(dotColor)
                .frame(width: DSSpacing.s + DSSpacing.xxs, height: DSSpacing.s + DSSpacing.xxs)
                .padding(.top, DSSpacing.xs + DSSpacing.xxs)
                .accessibilityHidden(true)
        }
        .accessibilityElement(children: .combine)
        .accessibilityValue(stateLabel)
    }

    private var dotColor: Color {
        switch state {
        case .pending: DSColor.textTertiary
        case .ok: DSColor.statusSuccess
        case .warning: DSColor.accent
        case .error: DSColor.statusDanger
        }
    }

    private var stateLabel: String {
        switch state {
        case .pending: "en attente"
        case .ok: "disponible"
        case .warning: "attention"
        case .error: "indisponible"
        }
    }
}

#Preview {
    VStack(spacing: DSSpacing.m) {
        DSStatusRow(systemImage: "faceid", title: "Caméra TrueDepth", detail: "Détection du regard", state: .ok)
        DSStatusRow(systemImage: "camera", title: "Accès caméra", detail: "Refusé dans Réglages", state: .error)
        DSStatusRow(systemImage: "speaker.wave.2", title: "Son", state: .pending)
    }
    .padding()
    .background(DSColor.backgroundPrimary)
}
