// LevelResultView.swift
// Layer: Presentation
// Purpose: "atteint": three éclats lighting one after the other, measurements, next / replay / chapters

import SwiftUI

struct LevelResultView: View {
    let result: LevelResult
    let level: LevelDefinition
    let chapter: ChapterDefinition
    let hapticsEnabled: Bool
    let onPrimary: () -> Void
    let onReplay: () -> Void
    let onChapters: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var revealed = 0

    var body: some View {
        DSOverlayPanel(title: "atteint",
                       subtitle: "\(chapter.numeral) · \(chapter.name) — \(level.title)",
                       eyebrow: result.isCampaignEnd ? "dernier iris" : (result.isChapterEnd ? "chapitre terminé" : "niveau \(level.index)"),
                       dim: 0.9) {
            HStack(alignment: .top, spacing: DSSpacing.m) {
                ForEach(Array(Eclat.allCases.enumerated()), id: \.offset) { index, eclat in
                    EclatBadge(eclat: eclat, isLit: result.earned.contains(eclat) && revealed > index,
                               isNew: result.newlyEarned.contains(eclat) && revealed > index)
                }
            }
            DSCard(style: .flat) {
                HStack {
                    metric("temps", "\(result.outcome.time.formatted(.number.precision(.fractionLength(1)))) s")
                    Spacer()
                    metric("intrusions", "\(result.outcome.intrusions)")
                    Spacer()
                    metric("pertes", "\(result.outcome.losses)")
                }
                if result.isNewBestTime {
                    Text("meilleur temps").dsEyebrowStyle(tint: DSColor.statusSuccess)
                }
            }
            DSButton(result.primaryTitle, systemImage: result.isCampaignEnd ? "sparkles" : "arrow.right", action: onPrimary)
            DSButton("Rejouer", variant: .secondary, action: onReplay)
            DSButton("Chapitres", variant: .ghost, action: onChapters)
        }
        .sensoryFeedback(.success, trigger: revealed) { _, new in hapticsEnabled && new == 3 }
        .task {
            if reduceMotion {
                revealed = 3
                return
            }
            for step in 1...3 {
                try? await Task.sleep(for: .milliseconds(260))
                revealed = step
            }
        }
    }

    private func metric(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text(label).dsEyebrowStyle()
            Text(value)
                .font(DSFont.title3)
                .monospacedDigit()
                .foregroundStyle(DSColor.textPrimary)
        }
        .accessibilityElement(children: .combine)
    }
}

private struct EclatBadge: View {
    let eclat: Eclat
    let isLit: Bool
    let isNew: Bool

    var body: some View {
        VStack(spacing: DSSpacing.xs) {
            ZStack {
                Circle()
                    .fill(isLit ? DSColor.statusSuccess.opacity(0.2) : Color.clear)
                Circle()
                    .strokeBorder(isLit ? DSColor.statusSuccess : DSColor.lineSubtle, lineWidth: 2)
                DSApertureBlades(closure: isLit ? 0.85 : 0.2, rotation: 0)
                    .stroke(isLit ? DSColor.statusSuccess : DSColor.textTertiary, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .padding(10)
            }
            .frame(width: 56, height: 56)
            .animation(.easeInOut(duration: 0.3), value: isLit)
            Text(eclat.title)
                .font(DSFont.callout)
                .foregroundStyle(isLit ? DSColor.textPrimary : DSColor.textTertiary)
            Text(eclat.condition)
                .font(DSFont.caption)
                .foregroundStyle(DSColor.textTertiary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 96)
            if isNew {
                DSBadge("nouveau", tone: .success)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityValue(isLit ? "obtenu" : "non obtenu")
    }
}
