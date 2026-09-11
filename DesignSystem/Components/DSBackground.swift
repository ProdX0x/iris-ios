// DSBackground.swift
// Layer: DesignSystem
// Purpose: The chambre noire: ink ground, abyss centre, faint iris fibres, vignette; optionally breathing

import SwiftUI

struct DSBackground: View {
    enum Intensity {
        case calm
        case vivid
    }

    let intensity: Intensity

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var breath = false

    init(intensity: Intensity = .calm) {
        self.intensity = intensity
    }

    var body: some View {
        ZStack {
            DSColor.fieldInk
            RadialGradient(colors: [DSColor.fieldAbyss, DSColor.fieldInk], center: .center, startRadius: 0, endRadius: 520)
                .opacity(breath ? 1 : 0.86)
            DSIrisFibers(opacity: intensity == .vivid ? 0.045 : 0.03)
            RadialGradient(colors: [DSColor.accent.opacity(intensity == .vivid ? 0.07 : 0.035), .clear],
                           center: UnitPoint(x: 0.5, y: 0.42), startRadius: 0, endRadius: 360)
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) { breath = true }
        }
    }
}

/// Eighty fine rays from the centre, drawn once (static inputs).
struct DSIrisFibers: View {
    let opacity: Double

    var body: some View {
        Canvas { context, size in
            let centerX: CGFloat = size.width / 2
            let centerY: CGFloat = size.height / 2
            let inner: CGFloat = min(size.width, size.height) * 0.16
            let outer: CGFloat = max(size.width, size.height) * 0.75
            var path = Path()
            for index in 0..<80 {
                let angle: CGFloat = CGFloat(index) / 80 * 2 * .pi
                let seed: CGFloat = CGFloat(sin(Double(index) * 12.9898))
                let jitter: CGFloat = (seed * 0.5 + 0.5) * 0.25
                let start: CGFloat = inner * (1 + jitter)
                let cosine: CGFloat = cos(angle)
                let sine: CGFloat = sin(angle)
                path.move(to: CGPoint(x: centerX + cosine * start, y: centerY + sine * start))
                path.addLine(to: CGPoint(x: centerX + cosine * outer, y: centerY + sine * outer))
            }
            context.stroke(path, with: .color(DSColor.textPrimary.opacity(opacity)), lineWidth: 0.6)
        }
        .allowsHitTesting(false)
    }
}

#Preview("Calm") {
    DSBackground()
}

#Preview("Vivid") {
    DSBackground(intensity: .vivid)
}
