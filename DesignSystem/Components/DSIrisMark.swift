// DSIrisMark.swift
// Layer: DesignSystem
// Purpose: The Iris emblem: concentric amber rings around a dark pupil, optionally breathing

import SwiftUI

struct DSIrisMark: View {
    private let size: CGFloat
    private let isBreathing: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var breath = false

    init(size: CGFloat = 120, isBreathing: Bool = false) {
        self.size = size
        self.isBreathing = isBreathing
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(RadialGradient(colors: [DSColor.accent.opacity(0.35), DSColor.accent.opacity(0)],
                                     center: .center, startRadius: size * 0.3, endRadius: size * 0.75))
                .frame(width: size * 1.5, height: size * 1.5)
            Circle()
                .strokeBorder(AngularGradient(colors: [DSColor.accentDeep, DSColor.accent, DSColor.accentDeep, DSColor.accent, DSColor.accentDeep],
                                              center: .center), lineWidth: size * 0.16)
                .frame(width: size, height: size)
            Circle()
                .strokeBorder(DSColor.accent.opacity(0.35), lineWidth: 1)
                .frame(width: size * 0.62, height: size * 0.62)
            Circle()
                .fill(DSColor.backgroundPrimary)
                .frame(width: size * 0.42, height: size * 0.42)
                .overlay(alignment: .topLeading) {
                    Circle()
                        .fill(DSColor.textPrimary.opacity(0.85))
                        .frame(width: size * 0.09, height: size * 0.09)
                        .offset(x: size * 0.1, y: size * 0.1)
                }
        }
        .scaleEffect(breath ? 1.04 : 1)
        .opacity(breath ? 1 : 0.92)
        .frame(width: size * 1.5, height: size * 1.5)
        .onAppear {
            guard isBreathing, !reduceMotion else { return }
            withAnimation(DSMotion.breathAnimation) { breath = true }
        }
        .accessibilityHidden(true)
    }
}

#Preview {
    VStack(spacing: DSSpacing.xl) {
        DSIrisMark(size: 140, isBreathing: true)
        DSIrisMark(size: 48)
    }
    .padding()
    .background(DSColor.backgroundPrimary)
}
