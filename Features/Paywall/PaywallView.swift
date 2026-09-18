// PaywallView.swift
// Layer: Presentation
// Purpose: What the full access is, what it costs according to the store, and the three ways in: buy once, restore,
// or redeem a code. No subscription is ever offered here, and no price is ever written by Iris

import SwiftUI

struct PaywallView: View {
    @Environment(AppCoordinator.self) private var coordinator
    @State private var redeemsCode = false

    var body: some View {
        let store = coordinator.store
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: DSSpacing.l) {
                    if coordinator.entitlement.opensWholeCampaign {
                        granted
                    } else {
                        offer(price: store.fullGameDisplayPrice)
                        actions(store: store)
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
        .dsOfferCodeRedemption(isPresented: $redeemsCode) { _ in
            Task { await coordinator.store.refresh() }
        }
        .onDisappear { coordinator.store.acknowledgeOutcome() }
    }

    // MARK: Sections

    private func offer(price: String?) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.l) {
            if let chapter = coordinator.paywallChapter {
                Text("\(chapter.numeral) · \(chapter.name)").dsEyebrowStyle()
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
            HStack(spacing: DSSpacing.m) {
                DSButton(PaywallCopy.restore, variant: .secondary) {
                    Task { await store.restorePurchases() }
                }
                .disabled(store.isWorking)
                Spacer(minLength: 0)
            }
            DSButton(PaywallCopy.redeemCode, systemImage: "ticket", variant: .ghost) { redeemsCode = true }
                .disabled(store.isWorking)
            if store.isWorking {
                ProgressView()
                    .tint(DSColor.Identity.accent)
                    .accessibilityLabel(IrisText.interface("paywall.storeWorking", french: "Communication avec l'App Store"))
            }
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
