// DSCard.swift
// Layer: DesignSystem
// Purpose: Elevated surface with hairline border for grouped content. Panels that stand on glass use DSGlassPanel:
// this card never imitates a material

import SwiftUI

struct DSCard<Content: View>: View {
    enum Style {
        case flat
        case elevated
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
        .overlay(RoundedRectangle(cornerRadius: DSRadius.l, style: .continuous).strokeBorder(DSColor.Identity.line, lineWidth: 1))
    }

    private var background: Color {
        switch style {
        case .flat: DSColor.Identity.surface
        case .elevated: DSColor.Identity.surfaceElevated
        }
    }
}

#Preview {
    VStack(spacing: DSSpacing.m) {
        DSCard { Text("Carte élevée").foregroundStyle(DSColor.Identity.textPrimary) }
        DSCard(style: .flat) { Text("Carte plate").foregroundStyle(DSColor.Identity.textPrimary) }
    }
    .padding()
    .background(DSColor.Identity.ground)
}
