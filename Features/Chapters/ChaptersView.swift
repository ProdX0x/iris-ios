// ChaptersView.swift
// Layer: Presentation
// Purpose: The map: every chapter, its levels and éclats; choose a level to play

import SwiftUI

struct ChaptersView: View {
    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        DSScreen {
            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                Text("\(coordinator.homeSummary.eclats) éclats sur \(coordinator.homeSummary.maxEclats)")
                    .dsEyebrowStyle(tint: DSColor.State.success)
                Text("chapitres")
                    .font(DSFont.display)
                    .foregroundStyle(DSColor.Identity.textPrimary)
                    .accessibilityAddTraits(.isHeader)
            }
            ForEach(Campaign.chapters) { chapter in
                ChapterCard(chapter: chapter,
                            isUnlocked: coordinator.isUnlocked(chapter),
                            completed: coordinator.progress.completedCount(in: chapter.levels),
                            nodes: chapter.levels.map { level in (level, state(of: level), coordinator.record(for: level).eclats) },
                            lockedHint: lockedHint(for: chapter),
                            onSelect: { coordinator.play($0) })
            }
        }
    }

    private func state(of level: LevelDefinition) -> LevelNode.State {
        if !coordinator.isUnlocked(level) { return .locked }
        if coordinator.progress.isCompleted(level) { return .completed }
        return coordinator.nextLevel?.id == level.id ? .next : .available
    }

    private func lockedHint(for chapter: ChapterDefinition) -> String {
        guard let previous = Campaign.chapter(number: chapter.number - 1) else { return "" }
        return "Terminez le chapitre \(previous.numeral)"
    }
}

#Preview {
    ChaptersView()
        .environment(AppContainer.preview().makeAppCoordinator())
}
