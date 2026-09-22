// PaywallView.swift
// Layer: Presentation
// Purpose: What the full access is, what it costs according to the store, and the three ways in: buy once, restore,
// or redeem a code. No subscription is ever offered here, and no price is ever written by Iris. On a device that cannot
// play Iris it offers nothing at all: no price, no purchase, no code — only the way to restore a right bought elsewhere

import SwiftUI

/// Which of its three faces the full access screen shows. Decided from the right held and from whether this device may
/// start an acquisition, never from the view's own state, so a test can hold every combination.
enum PaywallMode: Hashable, Sendable {
    /// The whole campaign is already open: there is nothing to sell. Holds on any device, even one that cannot play.
    case granted
    /// The offer: what is bought, the store's price, buying, restoring, redeeming a code.
    case offer
    /// This device cannot play Iris: nothing is offered and no price is named. Restoring stays, so a right bought on
    /// another device is still recognised here.
    case deviceUnsupported

    static func resolve(opensWholeCampaign: Bool, allowsNewAcquisitions: Bool) -> PaywallMode {
        if opensWholeCampaign { return .granted }
        return allowsNewAcquisitions ? .offer : .deviceUnsupported
    }
}

struct PaywallView: View {
    @Environment(AppCoordinator.self) private var coordinator
    @State private var redeemsCode = false

    var body: some View {
        let store = coordinator.store
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: DSSpacing.l) {
                    switch PaywallMode.resolve(opensWholeCampaign: coordinator.entitlement.opensWholeCampaign,
                                               allowsNewAcquisitions: store.allowsNewAcquisitions) {
                    case .granted:
                        granted
                    case .offer:
                        offer(price: store.fullGameDisplayPrice)
                        actions(store: store)
                    case .deviceUnsupported:
                        deviceUnsupported
                        restoreOnly(store: store)
                    }
                    if let notice = store.lastOutcome?.notice {
                        Text(notice)
                            .font(DSFont.footnote)
                            .foregroundStyle(store.lastOutcome?.isFailure == true ? DSColor.State.danger : DSColor.State.success)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Text(PaywallCopy.progressIsKept)
                        .font(DSFont.caption)
                        .foregroundStyle(DSColor.Identity.textTertiary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(DSSpacing.gutter)
                .frame(maxWidth: 480)
                .frame(maxWidth: .infinity)
            }
            .dsSoftScrollEdges()
            .background { DSBackground(intensity: .calm) }
            .navigationTitle(IrisText.interface("paywall.eyebrow", french: "accès complet"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(IrisText.interface("common.close", french: "Fermer")) { coordinator.dismissSheet() }
                }
            }
        }
        .preferredColorScheme(.dark)
        .dsOfferCodeRedemption(isPresented: $redeemsCode, through: store) { _ in
            Task { await coordinator.store.refresh() }
        }
        .onDisappear { coordinator.store.acknowledgeOutcome() }
    }

    // MARK: Sections

    private func offer(price: String?) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.l) {
            if let chapter = coordinator.paywallChapter {
                Text(IrisText.interface("common.chapter.line", french: "%@ · %@",
                                        chapter.numeral, CampaignText.name(of: chapter))).dsEyebrowStyle()
            }
            DSGlassPanel {
                Text(PaywallCopy.whatIsBought)
                    .font(DSFont.body)
                    .foregroundStyle(DSColor.Identity.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(PaywallCopy.freeChapters)
                    .font(DSFont.footnote)
                    .foregroundStyle(DSColor.Identity.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(PaywallCopy.notASubscription)
                    .font(DSFont.footnote)
                    .foregroundStyle(DSColor.Identity.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                if price == nil {
                    Text(PaywallCopy.priceUnavailable)
                        .font(DSFont.footnote)
                        .foregroundStyle(DSColor.State.warning)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private func actions(store: any StorePurchasing) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.m) {
            DSButton(PaywallCopy.unlockTitle(price: store.fullGameDisplayPrice), systemImage: "lock.open") {
                Task { await store.purchaseFullGame() }
            }
            .disabled(store.isWorking || store.fullGameDisplayPrice == nil)
            restoreButton(store: store)
            DSButton(PaywallCopy.redeemCode, systemImage: "ticket", variant: .ghost) { redeemsCode = true }
                .disabled(store.isWorking)
            working(store: store)
        }
    }

    /// The one action a device that cannot play Iris keeps: finding a right bought elsewhere. Nothing is sold here.
    private func restoreOnly(store: any StorePurchasing) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.m) {
            restoreButton(store: store)
            working(store: store)
        }
    }

    private func restoreButton(store: any StorePurchasing) -> some View {
        HStack(spacing: DSSpacing.m) {
            DSButton(PaywallCopy.restore, variant: .secondary) {
                Task { await store.restorePurchases() }
            }
            .disabled(store.isWorking)
            Spacer(minLength: 0)
        }
    }

    @ViewBuilder
    private func working(store: any StorePurchasing) -> some View {
        if store.isWorking {
            ProgressView()
                .tint(DSColor.Identity.accent)
                .accessibilityLabel(IrisText.interface("paywall.storeWorking", french: "Communication avec l'App Store"))
        }
    }

    /// Why nothing is offered, in the same generic words the unavailability screen uses. It names no hardware: which
    /// devices can read the gaze is the system's answer, not a claim this screen makes.
    private var deviceUnsupported: some View {
        DSGlassPanel {
            Text(IrisText.interface("unavailable.eyebrow", french: "appareil")).dsEyebrowStyle(tint: DSColor.State.danger)
            Text(IrisText.interface("gaze.unavailable.title", french: "regard indisponible"))
                .font(DSFont.title2)
                .foregroundStyle(DSColor.Identity.textPrimary)
                .accessibilityAddTraits(.isHeader)
            DSStatusRow(systemImage: "eye.slash",
                        title: IrisText.interface("unavailable.faceTracking.label", french: "Suivi facial ARKit"),
                        detail: IrisText.interface("unavailable.faceTracking.detail", french: "Non pris en charge sur cet appareil"),
                        state: .error)
        }
    }

    private var granted: some View {
        DSGlassPanel {
            DSBadge(coordinator.entitlement == .fullAccess ? IrisText.interface("paywall.full.eyebrow", french: "accès complet") : IrisText.interface("paywall.promotional.eyebrow", french: "accès temporaire"), tone: .success)
            Text(coordinator.entitlement == .fullAccess
                 ? IrisText.interface("access.full.summary", french: "Iris est ouvert en entier sur ce compte Apple.")
                 : IrisText.interface("access.promotional.detail", french: "Iris est ouvert en entier pendant la durée de votre accès."))
                .font(DSFont.body)
                .foregroundStyle(DSColor.Identity.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview("Free player") {
    PaywallView()
        .environment(AppContainer.preview(store: StaticEntitlementService(displayPrice: StaticEntitlementService.samplePrice)).makeAppCoordinator())
}

#Preview("Already unlocked") {
    PaywallView()
        .environment(AppContainer.preview(store: StaticEntitlementService(entitlement: .fullAccess)).makeAppCoordinator())
}

#Preview("Device that cannot play") {
    PaywallView()
        .environment(AppContainer.preview(supportsFaceTracking: false).makeAppCoordinator())
}
