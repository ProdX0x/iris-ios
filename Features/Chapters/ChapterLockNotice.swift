// ChapterLockNotice.swift
// Layer: Presentation
// Purpose: What a chapter says when it belongs to the full access: it stays visible and named, states its condition
// in one sentence, shows the store's own price, and offers the one way in

import SwiftUI

struct ChapterLockNotice: View {
    let chapter: ChapterDefinition
    /// The price as the store formats it; nil when the store could not be reached.
    let price: String?
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.s) {
            DSBadge(IrisText.interface("paywall.eyebrow", french: "accès complet"), tone: .info)
            Text(PaywallCopy.lockedChapter(chapter))
                .font(DSFont.footnote)
                .foregroundStyle(DSColor.Identity.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            DSButton(PaywallCopy.unlockTitle(price: price), systemImage: "lock.open", variant: .secondary, action: action)
                .padding(.top, DSSpacing.xxs)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, DSSpacing.xs)
        .accessibilityElement(children: .contain)
    }
}

#Preview {
    ZStack {
        DSBackground(intensity: .calm)
        DSGlassPanel {
            Text("IV · voiles").font(DSFont.title2).foregroundStyle(DSColor.Identity.textPrimary)
            ChapterLockNotice(chapter: Campaign.chapters[3], price: StaticEntitlementService.samplePrice) {}
        }
        .padding(DSSpacing.gutter)
    }
    .preferredColorScheme(.dark)
}
