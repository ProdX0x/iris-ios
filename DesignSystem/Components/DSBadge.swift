// DSBadge.swift
// Layer: DesignSystem
// Purpose: Small status pill (success, danger, info, neutral, accent)

import SwiftUI

struct DSBadge: View {
    enum Tone {
        case neutral
        case accent
        case success
        case danger
        case info
    }

    private let text: String
    private let tone: Tone

    init(_ text: String, tone: Tone = .neutral) {
        self.text = text
        self.tone = tone
    }

    var body: some View {
        Text(text)
            .font(DSFont.eyebrow)
            .textCase(.uppercase)
            .tracking(1.2)
            .foregroundStyle(foreground)
            .padding(.horizontal, DSSpacing.s + DSSpacing.xs)
            .padding(.vertical, DSSpacing.xs + DSSpacing.xxs)
            .background(foreground.opacity(0.14), in: Capsule())
    }

    private var foreground: Color {
        switch tone {
        case .neutral: DSColor.textSecondary
        case .accent: DSColor.accent
        case .success: DSColor.statusSuccess
        case .danger: DSColor.statusDanger
        case .info: DSColor.statusInfo
        }
    }
}

#Preview {
    HStack {
        DSBadge("neutre")
        DSBadge("ambre", tone: .accent)
        DSBadge("validé", tone: .success)
        DSBadge("perdu", tone: .danger)
        DSBadge("info", tone: .info)
    }
    .padding()
    .background(DSColor.backgroundPrimary)
}
