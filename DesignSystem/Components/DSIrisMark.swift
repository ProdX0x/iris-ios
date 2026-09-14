// DSIrisMark.swift
// Layer: DesignSystem
// Purpose: The Iris emblem: a six-blade amber diaphragm around a pearl lueur, optionally breathing

import SwiftUI

struct DSIrisMark: View {
    private let size: CGFloat
    private let isBreathing: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var open = false

    init(size: CGFloat = 120, isBreathing: Bool = false) {
        self.size = size
        self.isBreathing = isBreathing
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(RadialGradient(colors: [DSColor.Identity.accent.opacity(0.18), .clear], center: .center, startRadius: size * 0.2, endRadius: size * 0.8))
                .frame(width: size * 1.6, height: size * 1.6)
            Circle()
                .strokeBorder(DSColor.Identity.accent.opacity(0.45), lineWidth: max(1, size * 0.012))
                .frame(width: size, height: size)
            DSApertureBlades(closure: open ? 0.25 : 0.55, rotation: open ? 12 : 0)
                .stroke(DSColor.Identity.accent, style: StrokeStyle(lineWidth: max(1.5, size * 0.07), lineCap: .round))
                .frame(width: size * 0.84, height: size * 0.84)
            Circle()
                .fill(RadialGradient(colors: [DSColor.Identity.emblemCore, DSColor.Identity.emblemGlow.opacity(0)], center: .center, startRadius: 0, endRadius: size * 0.16))
                .frame(width: size * 0.32, height: size * 0.32)
            Circle()
                .fill(DSColor.Identity.emblemCore)
                .frame(width: size * 0.08, height: size * 0.08)
        }
        .frame(width: size * 1.6, height: size * 1.6)
        .onAppear {
            guard isBreathing, !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) { open = true }
        }
        .accessibilityHidden(true)
    }
}

/// Six arcs that tighten toward the centre as `closure` grows (0 open, 1 closed).
struct DSApertureBlades: Shape {
    var closure: Double
    var rotation: Double

    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(closure, rotation) }
        set {
            closure = newValue.first
            rotation = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let maxRadius = min(rect.width, rect.height) / 2
        let radius = maxRadius * (1 - 0.6 * min(max(closure, 0), 1))
        var path = Path()
        for index in 0..<6 {
            let start = Angle.degrees(Double(index) * 60 + rotation + closure * 40)
            // Each blade is its own subpath: without the move, addArc would join the blades with straight lines.
            path.move(to: CGPoint(x: center.x + radius * cos(start.radians), y: center.y + radius * sin(start.radians)))
            path.addArc(center: center, radius: radius, startAngle: start, endAngle: start + .degrees(34), clockwise: false)
        }
        return path
    }
}

#Preview {
    VStack(spacing: DSSpacing.xl) {
        DSIrisMark(size: 140, isBreathing: true)
        DSIrisMark(size: 48)
    }
    .padding()
    .background(DSColor.Identity.ground)
}
