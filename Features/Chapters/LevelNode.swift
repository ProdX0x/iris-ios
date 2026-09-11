// LevelNode.swift
// Layer: Presentation
// Purpose: One level on the chapter map: number, éclats arcs, locked / available / next / completed

import SwiftUI

struct LevelNode: View {
    enum State: Hashable {
        case locked
        case available
        case next
        case completed
    }

    let level: LevelDefinition
    let state: State
    let eclats: Set<Eclat>
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(state == .locked ? DSColor.backgroundSurface : DSColor.backgroundElevated)
                DSEclats(lit: Eclat.allCases.map { eclats.contains($0) }, lineWidth: 2.5)
                    .padding(2)
                    .opacity(state == .locked ? 0.35 : 1)
                if state == .next {
                    Circle()
                        .strokeBorder(DSColor.accent, lineWidth: 2)
                        .padding(-5)
                }
                Text("\(level.index)")
                    .font(DSFont.title3)
                    .monospacedDigit()
                    .foregroundStyle(state == .locked ? DSColor.textTertiary : DSColor.textPrimary)
            }
            .frame(width: 48, height: 48)
        }
        .buttonStyle(DSPressableButtonStyle())
        .disabled(state == .locked)
        .accessibilityLabel("Niveau \(level.index), \(level.title)")
        .accessibilityValue(accessibilityValue)
    }

    private var accessibilityValue: String {
        switch state {
        case .locked: "verrouillé"
        case .next: "à jouer"
        case .available: "\(eclats.count) éclats sur 3"
        case .completed: "\(eclats.count) éclats sur 3"
        }
    }
}
