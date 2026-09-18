// LevelNode.swift
// Layer: Presentation
// Purpose: One level on the chapter map: number, éclats arcs, locked / available / next / completed; a square touch
// target that takes the size its row offers (up to the historical 48 pt circle)

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

    private let style = AdaptiveLevelRowMetrics.Style.standard

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(state == .locked ? DSColor.Identity.surface : DSColor.Identity.surfaceElevated)
                DSEclats(lit: Eclat.allCases.map { eclats.contains($0) }, lineWidth: 2.5)
                    .padding(2)
                    .opacity(state == .locked ? 0.35 : 1)
                if state == .next {
                    Circle()
                        .strokeBorder(DSColor.Navigation.selection, lineWidth: 2)
                        .padding(-style.ringOutset)
                }
                Text("\(level.index)")
                    .font(DSFont.title3)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(DSSpacing.xs)
                    .foregroundStyle(state == .locked ? DSColor.Identity.textTertiary : DSColor.Identity.textPrimary)
            }
            .padding(style.circleInset)
            // A square no larger than the historical button, as large as the row allows.
            .frame(maxWidth: style.maximumTarget, maxHeight: style.maximumTarget)
            .aspectRatio(1, contentMode: .fit)
            .contentShape(Rectangle())
        }
        .buttonStyle(DSPressableButtonStyle())
        .disabled(state == .locked)
        .accessibilityLabel(IrisText.interface("chapters.level.label", french: "Niveau %lld, %@",
                                               level.index, CampaignText.title(of: level)))
        .accessibilityValue(accessibilityValue)
    }

    private var accessibilityValue: String {
        switch state {
        case .locked: IrisText.interface("chapters.level.locked", french: "verrouillé")
        case .next: IrisText.interface("chapters.level.toPlay", french: "à jouer")
        case .available: IrisText.interface("eclats.outOfThree.value", french: "%lld éclats sur 3", eclats.count)
        case .completed: IrisText.interface("eclats.outOfThree.value", french: "%lld éclats sur 3", eclats.count)
        }
    }
}
