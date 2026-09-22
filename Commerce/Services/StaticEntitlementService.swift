// StaticEntitlementService.swift
// Layer: Commerce
// Purpose: A store that answers from a fixed right: previews and tests exercise the interface and the access rules
// without the App Store. It never reaches StoreKit and never sells anything — and in a Release build it grants
// nothing at all, whatever it is asked for, so no right can ever exist without a verified transaction

import Foundation
import Observation

@MainActor
@Observable
final class StaticEntitlementService: StorePurchasing {
    /// A placeholder shown by previews only. It is deliberately NOT the price Iris will sell at: the real price is
    /// always the one the store formats (CommerceBoundaryTests holds the guarantee).
    nonisolated static let samplePrice = "4,99 €"

    private(set) var entitlement: AccessEntitlement
    private(set) var fullGameDisplayPrice: String?
    private(set) var isWorking = false
    private(set) var lastOutcome: StorePurchaseOutcome?
    private(set) var startCount = 0
    private(set) var restoreCount = 0
    private(set) var purchaseCount = 0
    private(set) var refreshCount = 0
    let allowsNewAcquisitions: Bool

    /// What a purchase leads to; `.purchased` also grants the full access.
    var outcomeOfPurchase: StorePurchaseOutcome = .purchased

    /// Same contract as the real store: a device that may not buy names no price and refuses every purchase.
    init(entitlement: AccessEntitlement = .free, displayPrice: String? = nil, allowsNewAcquisitions: Bool = true) {
        #if DEBUG
        self.entitlement = entitlement
        #else
        // A Release build never holds a right that did not come from the store.
        self.entitlement = .free
        #endif
        self.allowsNewAcquisitions = allowsNewAcquisitions
        self.fullGameDisplayPrice = allowsNewAcquisitions ? displayPrice : nil
    }

    func start() {
        startCount += 1
    }

    func purchaseFullGame() async {
        // Refused before it is counted: `purchaseCount` is the number of purchases that really started.
        guard allowsNewAcquisitions else {
            lastOutcome = .deviceUnsupported
            return
        }
        purchaseCount += 1
        #if DEBUG
        if outcomeOfPurchase == .purchased {
            entitlement = .fullAccess
        }
        #endif
        lastOutcome = outcomeOfPurchase
    }

    func restorePurchases() async {
        restoreCount += 1
        lastOutcome = entitlement == .free ? .nothingToRestore : .restored
    }

    func refresh() async {
        refreshCount += 1
    }

    func acknowledgeOutcome() {
        lastOutcome = nil
    }

    /// Used by tests to play out an expiry: the temporary right ends and the player falls back to the free chapters.
    func simulate(_ entitlement: AccessEntitlement) {
        #if DEBUG
        self.entitlement = entitlement
        #endif
    }
}
