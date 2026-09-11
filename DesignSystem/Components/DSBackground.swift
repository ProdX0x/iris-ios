// DSBackground.swift
// Layer: DesignSystem
// Purpose: The Iris atmosphere: deep ground, amber glow rising from the horizon, hairline horizon

import SwiftUI

struct DSBackground: View {
    enum Intensity {
        case calm
        case vivid
    }

    let intensity: Intensity

    init(intensity: Intensity = .calm) {
        self.intensity = intensity
    }

    var body: some View {
        ZStack {
            DSColor.backgroundPrimary
            RadialGradient(colors: [DSColor.accent.opacity(glowOpacity), DSColor.accent.opacity(0)],
                           center: UnitPoint(x: 0.5, y: 0.34), startRadius: 0, endRadius: 520)
            VStack(spacing: 0) {
                Spacer()
                Rectangle()
                    .fill(DSColor.sceneRing.opacity(0.06))
                    .frame(height: 1)
                Rectangle()
                    .fill(LinearGradient(colors: [DSColor.sceneFloorNear.opacity(0.6), DSColor.backgroundPrimary],
                                         startPoint: .top, endPoint: .bottom))
                    .frame(maxHeight: .infinity)
            }
            .frame(maxHeight: .infinity)
            .padding(.top, horizonOffset)
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }

    private var glowOpacity: Double {
        switch intensity {
        case .calm: 0.16
        case .vivid: 0.28
        }
    }

    private var horizonOffset: CGFloat {
        switch intensity {
        case .calm: 560
        case .vivid: 470
        }
    }
}

#Preview("Calm") {
    DSBackground()
}

#Preview("Vivid") {
    DSBackground(intensity: .vivid)
}
