// ChapterCard.swift
// Layer: Presentation
// Purpose: One chapter on the map: numeral, name, principle, level nodes, progress; locked state. Everything inside
// takes the width the card is given: texts wrap, the counter keeps its place, the levels adapt to their number

import SwiftUI

struct ChapterCard: View {
    let chapter: ChapterDefinition
    let isUnlocked: Bool
    let completed: Int
    let nodes: [(level: LevelDefinition, state: LevelNode.State, eclats: Set<Eclat>)]
    let lockedHint: String
    let onSelect: (LevelDefinition) -> Void

    var body: some View {
        DSCard(style: isUnlocked ? .elevated : .flat) {
            header
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Chapitre \(chapter.number), \(chapter.name), \(completed) niveaux sur \(chapter.levels.count) atteints")
            if isUnlocked {
                AdaptiveLevelRow {
                    ForEach(nodes, id: \.level.id) { node in
                        LevelNode(level: node.level, state: node.state, eclats: node.eclats) { onSelect(node.level) }
                    }
                }
                .padding(.top, DSSpacing.xs)
            }
        }
        .opacity(isUnlocked ? 1 : 0.7)
    }

    /// [numeral] [name / principle, wrapping] [counter]: the middle column takes what the numeral and the counter leave.
    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(chapter.numeral)
                .font(DSFont.numeral)
                .foregroundStyle(isUnlocked ? chapter.theme.palette.accent : DSColor.textTertiary)
                .fixedSize()
                .frame(minWidth: 36, alignment: .leading)
            VStack(alignment: .leading, spacing: DSSpacing.xxs) {
                Text(chapter.name)
                    .font(DSFont.title2)
                    .foregroundStyle(isUnlocked ? DSColor.textPrimary : DSColor.textTertiary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(isUnlocked ? chapter.principle : lockedHint)
                    .font(DSFont.footnote)
                    .foregroundStyle(DSColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(completed) / \(chapter.levels.count)")
                .font(DSFont.footnote)
                .monospacedDigit()
                .foregroundStyle(DSColor.textTertiary)
                .fixedSize()
                .layoutPriority(1)
        }
    }
}
