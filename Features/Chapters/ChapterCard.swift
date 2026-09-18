// ChapterCard.swift
// Layer: Presentation
// Purpose: One chapter on the map: numeral, name, principle, level nodes, progress; locked state. Everything inside
// takes the width the card is given: texts wrap, the counter keeps its place, the levels adapt to their number

import SwiftUI

struct ChapterCard: View {
    let chapter: ChapterDefinition
    let isUnlocked: Bool
    /// False when the chapter belongs to the full access and the player does not hold it.
    let isAccessible: Bool
    let completed: Int
    let nodes: [(level: LevelDefinition, state: LevelNode.State, eclats: Set<Eclat>)]
    let lockedHint: String
    /// The full game's price as the store formats it; nil when the store could not be reached.
    let fullAccessPrice: String?
    let onSelect: (LevelDefinition) -> Void
    let onUnlock: () -> Void

    var body: some View {
        DSGlassPanel {
            header
                .accessibilityElement(children: .combine)
                .accessibilityLabel(isAccessible
                    ? IrisText.interface("chapters.card.label", french: "Chapitre %lld, %@, %lld niveaux sur %lld atteints",
                                         chapter.number, CampaignText.name(of: chapter), completed, chapter.levels.count)
                    : IrisText.interface("chapters.card.label.locked",
                                         french: "Chapitre %lld, %@, %lld niveaux sur %lld atteints, accès complet requis",
                                         chapter.number, CampaignText.name(of: chapter), completed, chapter.levels.count))
            if !isAccessible {
                ChapterLockNotice(chapter: chapter, price: fullAccessPrice, action: onUnlock)
            } else if isUnlocked {
                AdaptiveLevelRow {
                    ForEach(nodes, id: \.level.id) { node in
                        LevelNode(level: node.level, state: node.state, eclats: node.eclats) { onSelect(node.level) }
                    }
                }
                .padding(.top, DSSpacing.xs)
            }
        }
        .opacity(isUnlocked || !isAccessible ? 1 : 0.7)
    }

    /// [numeral] [name / principle, wrapping] [counter]: the middle column takes what the numeral and the counter leave.
    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(chapter.numeral)
                .font(DSFont.numeral)
                .foregroundStyle(isUnlocked ? chapter.theme.palette.accent : DSColor.Identity.textTertiary)
                .fixedSize()
                .frame(minWidth: 36, alignment: .leading)
            VStack(alignment: .leading, spacing: DSSpacing.xxs) {
                Text(CampaignText.name(of: chapter))
                    .font(DSFont.title2)
                    .foregroundStyle(isUnlocked ? DSColor.Identity.textPrimary : DSColor.Identity.textTertiary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(isUnlocked ? CampaignText.principle(of: chapter) : lockedHint)
                    .font(DSFont.footnote)
                    .foregroundStyle(DSColor.Identity.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(completed) / \(chapter.levels.count)")
                .font(DSFont.footnote)
                .monospacedDigit()
                .foregroundStyle(DSColor.Identity.textTertiary)
                .fixedSize()
                .layoutPriority(1)
        }
    }
}
