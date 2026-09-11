// DSCard.swift
// Layer: DesignSystem
// Purpose: Elevated surface with hairline border for grouped content and overlays

import SwiftUI

struct DSCard<Content: View>: View {
    enum Style {
        case flat
        case elevated
        case glass
    }

    private let style: Style
    @ViewBuilder private let content: Content

    init(style: Style = .elevated, @ViewBuilder content: () -> Content) {
        self.style = style
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.m) {
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DSSpacing.l)
        .background(background, in: RoundedRectangle(cornerRadius: DSRadius.l, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: DSRadius.l, style: .continuous).strokeBorder(DSColor.lineSubtle, lineWidth: 1))
    }

    private var background: Color {
        switch style {
        case .flat: DSColor.backgroundSurface
        case .elevated: DSColor.backgroundElevated
        case .glass: DSColor.backgroundSurface.opacity(0.88)
        }
    }
}

#Preview {
    VStack(spacing: DSSpacing.m) {
        DSCard { Text("Carte élevée").foregroundStyle(DSColor.textPrimary) }
        DSCard(style: .flat) { Text("Carte plate").foregroundStyle(DSColor.textPrimary) }
    }
    .padding()
    .background(DSColor.backgroundPrimary)
}
