// DSScreen.swift
// Layer: DesignSystem
// Purpose: Page container: atmosphere background, safe-area aware column, consistent gutters, and content softened
// where it passes under the system's glass bars

import SwiftUI

struct DSScreen<Content: View>: View {
    private let intensity: DSBackground.Intensity
    private let scrolls: Bool
    @ViewBuilder private let content: Content

    init(intensity: DSBackground.Intensity = .calm, scrolls: Bool = true, @ViewBuilder content: () -> Content) {
        self.intensity = intensity
        self.scrolls = scrolls
        self.content = content()
    }

    var body: some View {
        ZStack {
            DSBackground(intensity: intensity)
            if scrolls {
                ScrollView(showsIndicators: false) {
                    column
                }
                .dsSoftScrollEdges()
            } else {
                column
            }
        }
        .preferredColorScheme(.dark)
    }

    private var column: some View {
        VStack(alignment: .leading, spacing: DSSpacing.l) {
            content
        }
        .frame(maxWidth: 560, alignment: .leading)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, DSSpacing.gutter)
        .padding(.top, DSSpacing.xl)
        .padding(.bottom, DSSpacing.xxl)
    }
}

#Preview {
    DSScreen {
        Text("iris").font(DSFont.display).foregroundStyle(DSColor.Identity.textPrimary)
        Text("attention indirecte").dsEyebrowStyle()
    }
}
