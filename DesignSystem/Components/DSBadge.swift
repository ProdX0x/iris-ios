// DSBadge.swift
// Layer: DesignSystem
// Purpose: Small status pill (success, danger, info, neutral, accent): the system's glass carries it on iOS 26, its
// own faint tint before that; the tone always speaks through the label, never through a filled surface

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

    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    init(_ text: String, tone: Tone = .neutral) {
        self.text = text
        self.tone = tone
    }

    var body: some View {
        let rendering = DSGlassRendering.resolve(reduceTransparency: reduceTransparency)
        label
            .padding(.horizontal, DSSpacing.s + DSSpacing.xs)
            .padding(.vertical, DSSpacing.xs + DSSpacing.xxs)
            .modifier(DSBadgeSurface(rendering: rendering, tint: foreground))
    }

    private var label: some View {
        Text(text)
            .font(DSFont.eyebrow)
            .textCase(.uppercase)
            .tracking(1.2)
            .foregroundStyle(foreground)
    }

    private var foreground: Color {
        switch tone {
        case .neutral: DSColor.Identity.textSecondary
        case .accent: DSColor.Identity.accent
        case .success: DSColor.State.success
        case .danger: DSColor.State.danger
        case .info: DSColor.State.info
        }
    }
}

/// The chip's surface: the system's glass where it exists, the historical faint tint before it.
private struct DSBadgeSurface: ViewModifier {
    let rendering: DSGlassRendering
    let tint: Color

    @ViewBuilder
    func body(content: Content) -> some View {
        if rendering == .native {
            content.dsGlass(.chrome, in: .capsule)
        } else {
            content.background(tint.opacity(0.14), in: Capsule())
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
    .background(DSColor.Identity.ground)
}
