// LevelIntroCard.swift
// Layer: Presentation
// Purpose: What the level asks, in three seconds; a compact translucent card so the level stays readable behind it

import SwiftUI

struct LevelIntroCard: View {
    let level: LevelDefinition
    let chapter: ChapterDefinition
    let onStart: () -> Void
    let onChapters: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            Button(action: onStart) {
                LinearGradient(colors: [DSColor.fieldInk.opacity(0.05), DSColor.fieldInk.opacity(0.55)], startPoint: .center, endPoint: .bottom)
                    .ignoresSafeArea()
            }
            .buttonStyle(.plain)
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: DSSpacing.s) {
                HStack(alignment: .firstTextBaseline) {
                    Text("\(chapter.numeral) · \(chapter.name) — \(level.index)")
                        .dsEyebrowStyle(tint: DSColor.accent)
                    Spacer()
                    Button("chapitres", action: onChapters)
                        .font(DSFont.footnote)
                        .foregroundStyle(DSColor.textSecondary)
                        .frame(minHeight: 44)
                }
                Text(level.title)
                    .font(DSFont.title)
                    .foregroundStyle(DSColor.textPrimary)
                    .accessibilityAddTraits(.isHeader)
                Text(level.principle)
                    .font(DSFont.callout)
                    .foregroundStyle(DSColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                if !level.introduces.isEmpty {
                    HStack(spacing: DSSpacing.m) {
                        ForEach(level.introduces, id: \.self) { element in
                            HStack(spacing: DSSpacing.xs) {
                                DSGlyph(element.glyphKind)
                                    .frame(width: 18, height: 18)
                                Text(element.name)
                                    .font(DSFont.footnote)
                                    .foregroundStyle(DSColor.textPrimary)
                            }
                            .accessibilityElement(children: .combine)
                        }
                        DSBadge("nouveau", tone: .accent)
                    }
                }
                DSButton("Commencer", systemImage: "eye", action: onStart)
                    .padding(.top, DSSpacing.xs)
            }
            .padding(.horizontal, DSSpacing.l)
            .padding(.vertical, DSSpacing.m)
            .frame(maxWidth: 520, alignment: .leading)
            .background(DSColor.backgroundSurface.opacity(0.8), in: RoundedRectangle(cornerRadius: DSRadius.l, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: DSRadius.l, style: .continuous).strokeBorder(DSColor.lineSubtle, lineWidth: 1))
            .padding(.horizontal, DSSpacing.m)
            .padding(.bottom, DSSpacing.s)
        }
    }
}

#Preview {
    if let level = Campaign.level(id: "3-1"), let chapter = Campaign.chapter(of: level) {
        LevelIntroCard(level: level, chapter: chapter, onStart: {}, onChapters: {})
            .background(DSBackground())
    }
}
