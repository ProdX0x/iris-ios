// ChapterLockNotice.swift
// Layer: Presentation
// Purpose: What a chapter says when it belongs to the full access: it stays visible and named, states its condition
// in one sentence, shows the store's own price, and offers the one way in. On a device that cannot play Iris it offers
// nothing and names no price: a status line, which cannot be tapped, says the device is not supported

import SwiftUI

struct ChapterLockNotice: View {
    /// What the notice may offer, decided from the store alone so a test can hold it without drawing anything.
    enum Offer: Hashable, Sendable {
        /// The purchase, with the price as the store formats it; nil when the store could not be reached.
        case purchase(price: String?)
        /// This device cannot play Iris: no action, no price.
        case deviceUnsupported

        init(allowsNewAcquisitions: Bool, price: String?) {
            self = allowsNewAcquisitions ? .purchase(price: price) : .deviceUnsupported
        }
    }

    let chapter: ChapterDefinition
    let offer: Offer
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.s) {
            DSBadge(IrisText.interface("paywall.eyebrow", french: "accès complet"), tone: .info)
            Text(PaywallCopy.lockedChapter(chapter))
                .font(DSFont.footnote)
                .foregroundStyle(DSColor.Identity.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            switch offer {
            case let .purchase(price):
                DSButton(PaywallCopy.unlockTitle(price: price), systemImage: "lock.open", variant: .secondary, action: action)
                    .padding(.top, DSSpacing.xxs)
            case .deviceUnsupported:
                DSStatusRow(systemImage: "eye.slash",
                            title: IrisText.interface("unavailable.faceTracking.label", french: "Suivi facial ARKit"),
                            detail: IrisText.interface("unavailable.faceTracking.detail", french: "Non pris en charge sur cet appareil"),
                            state: .error)
                    .padding(.top, DSSpacing.xxs)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, DSSpacing.xs)
        .accessibilityElement(children: .contain)
    }
}

#Preview("Offer") {
    ZStack {
        DSBackground(intensity: .calm)
        DSGlassPanel {
            Text("IV · voiles").font(DSFont.title2).foregroundStyle(DSColor.Identity.textPrimary)
            ChapterLockNotice(chapter: Campaign.chapters[3], offer: .purchase(price: StaticEntitlementService.samplePrice)) {}
        }
        .padding(DSSpacing.gutter)
    }
    .preferredColorScheme(.dark)
}

#Preview("Device that cannot play") {
    ZStack {
        DSBackground(intensity: .calm)
        DSGlassPanel {
            Text("IV · voiles").font(DSFont.title2).foregroundStyle(DSColor.Identity.textPrimary)
            ChapterLockNotice(chapter: Campaign.chapters[3], offer: .deviceUnsupported) {}
        }
        .padding(DSSpacing.gutter)
    }
    .preferredColorScheme(.dark)
}
