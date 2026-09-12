// ChapterCard.swift
// Layer: Presentation
// Purpose: One chapter on the map: numeral, name, principle, level nodes, progress; locked state

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
            HStack(alignment: .firstTextBaseline) {
                Text(chapter.numeral)
                    .font(DSFont.numeral)
                    .foregroundStyle(isUnlocked ? chapter.theme.palette.accent : DSColor.textTertiary)
                    .frame(minWidth: 36, alignment: .leading)
                VStack(alignment: .leading, spacing: DSSpacing.xxs) {
                    Text(chapter.name)
                        .font(DSFont.title2)
                        .foregroundStyle(isUnlocked ? DSColor.textPrimary : DSColor.textTertiary)
                    Text(isUnlocked ? chapter.principle : lockedHint)
                        .font(DSFont.footnote)
                        .foregroundStyle(DSColor.textSecondary)
                }
                Spacer()
                Text("\(completed) / \(chapter.levels.count)")
                    .font(DSFont.footnote)
                    .monospacedDigit()
                    .foregroundStyle(DSColor.textTertiary)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Chapitre \(chapter.number), \(chapter.name), \(completed) niveaux sur \(chapter.levels.count) atteints")
            if isUnlocked {
                HStack(spacing: DSSpacing.s) {
                    ForEach(nodes, id: \.level.id) { node in
                        LevelNode(level: node.level, state: node.state, eclats: node.eclats) { onSelect(node.level) }
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.top, DSSpacing.xs)
            }
        }
        .opacity(isUnlocked ? 1 : 0.7)
    }
}
