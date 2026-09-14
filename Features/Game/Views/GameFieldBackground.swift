// GameFieldBackground.swift
// Layer: Presentation
// Purpose: The field behind a level: the chambre noire drawn from chapter tokens only, so a new interface background
// never changes a chapter (it renders exactly like the calm DSBackground of the interface today)

import SwiftUI

struct GameFieldBackground: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var breath = false

    var body: some View {
        ZStack {
            DSColor.Chapter.ink
            RadialGradient(colors: [DSColor.Chapter.abyss, DSColor.Chapter.ink], center: .center, startRadius: 0, endRadius: 520)
                .opacity(breath ? 1 : 0.86)
            DSIrisFibers(opacity: 0.03, color: DSColor.Chapter.nacre)
            RadialGradient(colors: [DSColor.Chapter.attention.opacity(0.035), .clear],
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

#Preview {
    GameFieldBackground()
}
