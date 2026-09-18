// DSProgressRing.swift
// Layer: DesignSystem
// Purpose: Circular progress used for journey completion and hold progress readouts

import SwiftUI

struct DSProgressRing: View {
    private let progress: Double
    private let tint: Color
    private let lineWidth: CGFloat
    private let label: String?

    init(progress: Double, tint: Color = DSColor.State.success, lineWidth: CGFloat = 6, label: String? = nil) {
        self.progress = progress
        self.tint = tint
        self.lineWidth = lineWidth
        self.label = label
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(DSColor.Identity.line, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: min(max(progress, 0), 1))
                .stroke(tint, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(DSMotion.standardAnimation, value: progress)
            if let label {
                Text(label)
                    .font(DSFont.title2)
                    .foregroundStyle(DSColor.Identity.textPrimary)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label ?? "progression")
        .accessibilityValue(IrisText.interface("progress.percent.value", french: "%lld pour cent", Int((progress * 100).rounded())))
    }
}

#Preview {
    DSProgressRing(progress: 0.7, label: "14 / 14")
        .frame(width: 140, height: 140)
        .padding()
        .background(DSColor.Identity.ground)
}
