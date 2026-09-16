// StorePurchasing.swift
// Layer: Commerce (contract)
// Purpose: What the paywall may ask of the store: the price as the store formats it, buy, restore, re-read the
// rights. The entitlement itself is read through EntitlementProviding, which the rest of Iris depends on

import Foundation

@MainActor
protocol StorePurchasing: EntitlementProviding {
    /// The full game's price exactly as the store formats it for the player's storefront; nil while unknown.
    /// Iris never formats a price and never writes one down.
    var fullGameDisplayPrice: String? { get }
    /// True while a store call is in flight.
    var isWorking: Bool { get }
    /// How the last call ended; nil once the interface has shown it.
    var lastOutcome: StorePurchaseOutcome? { get }

    /// Starts listening to the store and reads the rights already held. Called once, after the first frame.
    func start()
    /// Reads the products and the rights again, for instance after the system's code redemption sheet closed.
    func refresh() async
    func purchaseFullGame() async
    func restorePurchases() async
    func acknowledgeOutcome()
}
