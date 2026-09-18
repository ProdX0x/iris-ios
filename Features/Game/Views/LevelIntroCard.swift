// LevelIntroCard.swift
// Layer: Presentation
// Purpose: What the level asks, in three seconds; a compact panel on the system's glass so the level stays readable
// behind it, and one prominent action to begin

import SwiftUI

struct LevelIntroCard: View {
    let level: LevelDefinition
    let chapter: ChapterDefinition
    let onStart: () -> Void
    let onChapters: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            Button(action: onStart) {
                LinearGradient(colors: [DSColor.Navigation.veil.opacity(0.05), DSColor.Navigation.veil.opacity(0.55)], startPoint: .center, endPoint: .bottom)
                    .ignoresSafeArea()
            }
            .buttonStyle(.plain)
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: DSSpacing.s) {
                HStack(alignment: .firstTextBaseline) {
                    Text("\(chapter.numeral) · \(chapter.name) — \(level.index)")
                        .dsEyebrowStyle(tint: chapter.theme.palette.accent)
                    Spacer()
                    Button(IrisText.interface("levelIntro.chapters.action", french: "chapitres"), action: onChapters)
                        .font(DSFont.footnote)
                        .foregroundStyle(DSColor.Identity.textSecondary)
                        .frame(minHeight: 44)
                }
                Text(CampaignText.title(of: level))
                    .font(DSFont.title)
                    .foregroundStyle(DSColor.Identity.textPrimary)
                    .accessibilityAddTraits(.isHeader)
                Text(CampaignText.principle(of: level))
                    .font(DSFont.callout)
                    .foregroundStyle(DSColor.Identity.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                if !level.introduces.isEmpty {
                    HStack(spacing: DSSpacing.m) {
                        ForEach(level.introduces, id: \.self) { element in
                            HStack(spacing: DSSpacing.xs) {
                                DSGlyph(element.glyphKind)
                                    .frame(width: 18, height: 18)
                                Text(CampaignText.name(of: element))
                                    .font(DSFont.footnote)
                                    .foregroundStyle(DSColor.Identity.textPrimary)
                            }
                            .accessibilityElement(children: .combine)
                        }
                        DSBadge(IrisText.interface("levelIntro.new.badge", french: "nouveau"), tone: .accent)
                    }
                }
                DSButton(IrisText.interface("common.begin", french: "Commencer"), systemImage: "eye", action: onStart)
                    .padding(.top, DSSpacing.xs)
            }
            .padding(.horizontal, DSSpacing.l)
            .padding(.vertical, DSSpacing.m)
            .frame(maxWidth: 520, alignment: .leading)
            .dsGlass(.regularPanel)
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
