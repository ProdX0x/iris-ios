// LevelResultView.swift
// Layer: Presentation
// Purpose: "atteint": three éclats lighting one after the other, measurements, next / replay / chapters

import SwiftUI

struct LevelResultView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let result: LevelResult
    let level: LevelDefinition
    let chapter: ChapterDefinition
    let onPrimary: () -> Void
    let onReplay: () -> Void
    let onChapters: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var revealed = 0

    var body: some View {
        DSOverlayPanel(title: IrisText.interface("result.title", french: "atteint"),
                       subtitle: IrisText.interface("common.chapterLevel.line", french: "%@ · %@ — %@",
                                                    chapter.numeral, CampaignText.name(of: chapter), CampaignText.title(of: level)),
                       eyebrow: result.isCampaignEnd ? IrisText.interface("result.lastIris.eyebrow", french: "dernier iris") : (result.isChapterEnd ? IrisText.interface("result.chapterComplete.eyebrow", french: "chapitre terminé") : IrisText.interface("result.levelIndex.eyebrow", french: "niveau %lld", level.index)),
                       dim: 0.9) {
            // The three marks share the width until a third of it is too narrow for their condition, which is what
            // broke « terminer » into « termi- / ner ». At an accessibility size they stack, one under the other.
            marks {
                ForEach(Array(Eclat.allCases.enumerated()), id: \.offset) { index, eclat in
                    EclatBadge(eclat: eclat, isLit: result.earned.contains(eclat) && revealed > index,
                               isNew: result.newlyEarned.contains(eclat) && revealed > index)
                }
            }
            DSGlassPanel {
                // Three columns side by side is right until the text stops fitting in a third of the panel: at an
                // accessibility size the words break mid-word. The measurements then stack instead, each one taking
                // the full width, which is the room the text actually needs. Nothing shrinks, nothing is capped.
                measurements {
                    metric(IrisText.interface("result.time.label", french: "temps"),
                           "\(result.outcome.time.formatted(.number.precision(.fractionLength(1)))) s")
                    if !dynamicTypeSize.isAccessibilitySize { Spacer() }
                    metric(IrisText.interface("result.intrusions.label", french: "intrusions"),
                           "\(result.outcome.intrusions)")
                    if !dynamicTypeSize.isAccessibilitySize { Spacer() }
                    metric(IrisText.interface("result.losses.label", french: "pertes"),
                           "\(result.outcome.losses)")
                }
                if result.isNewBestTime {
                    Text(IrisText.interface("result.bestTime.badge", french: "meilleur temps")).dsEyebrowStyle(tint: DSColor.State.success)
                }
            }
            DSButton(result.primaryTitle, systemImage: result.isCampaignEnd ? "sparkles" : "arrow.right", action: onPrimary)
            DSButton(IrisText.interface("common.replay", french: "Rejouer"), variant: .secondary, action: onReplay)
            DSButton(IrisText.interface("common.chapters", french: "Chapitres"), variant: .ghost, action: onChapters)
        }
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

    /// Side by side at ordinary text sizes, stacked once the size is an accessibility one.
    private var marks: AnyLayout {
        dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: DSSpacing.m))
            : AnyLayout(HStackLayout(alignment: .top, spacing: DSSpacing.m))
    }

    /// Side by side at ordinary text sizes, stacked once the size is an accessibility one.
    private var measurements: AnyLayout {
        dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: DSSpacing.s))
            : AnyLayout(HStackLayout())
    }

    private func metric(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text(label).dsEyebrowStyle()
            Text(value)
                .font(DSFont.title3)
                .monospacedDigit()
                .foregroundStyle(DSColor.Identity.textPrimary)
        }
        .accessibilityElement(children: .combine)
    }
}

private struct EclatBadge: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let eclat: Eclat
    let isLit: Bool
    let isNew: Bool

    var body: some View {
        VStack(spacing: DSSpacing.xs) {
            ZStack {
                Circle()
                    .fill(isLit ? DSColor.State.success.opacity(0.2) : Color.clear)
                Circle()
                    .strokeBorder(isLit ? DSColor.State.success : DSColor.Identity.line, lineWidth: 2)
                DSApertureBlades(closure: isLit ? 0.85 : 0.2, rotation: 0)
                    .stroke(isLit ? DSColor.State.success : DSColor.Identity.textTertiary, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .padding(10)
            }
            .frame(width: 56, height: 56)
            .animation(.easeInOut(duration: 0.3), value: isLit)
            Text(CampaignText.title(of: eclat))
                .font(DSFont.callout)
                .foregroundStyle(isLit ? DSColor.Identity.textPrimary : DSColor.Identity.textTertiary)
            Text(CampaignText.condition(of: eclat))
                .font(DSFont.caption)
                .foregroundStyle(DSColor.Identity.textTertiary)
                .multilineTextAlignment(.center)
                // 96 points is the right measure for a column of three; at an accessibility size the badge has the
                // whole width and the cap is what would force the words apart.
                .frame(maxWidth: dynamicTypeSize.isAccessibilitySize ? .infinity : 96)
            if isNew {
                DSBadge(IrisText.interface("result.new.badge", french: "nouveau"), tone: .success)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityValue(isLit ? "obtenu" : IrisText.interface("result.eclat.notEarned", french: "non obtenu"))
    }
}
