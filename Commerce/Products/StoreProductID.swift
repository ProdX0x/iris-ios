// StoreProductID.swift
// Layer: Commerce
// Purpose: The App Store product identifiers of Iris, written once and nowhere else, and the right each one grants

import Foundation

/// Product identifiers are not bundle IDs and must never be aligned on one: they write `steve_s` where the bundle ID
/// writes `steve-s`, because our App Store Connect form refused the hyphenated identifier on 22 September 2026.
/// CommerceBoundaryTests (test N) checks that `Config/Iris.storekit` declares exactly these identifiers, and keeps them
/// in a conservative character set — a choice of Iris, not a rule Apple publishes.
enum StoreProductID {
    /// Non-consumable. Unlocks the whole campaign, for good. App Store Connect reference name: Iris Full Game Unlock.
    static let fullGameUnlock = "net.steve_s.iris.unlock.fullgame"

    /// Auto-renewable subscription (1 week) used ONLY as Apple's vehicle for a promotional offer code: a free 3-day
    /// offer, set not to renew at its end. Never sold, never presented as a subscription, never purchased from Iris.
    /// App Store Connect reference name: Iris Promotional Access Pass.
    static let promotionalAccessPass = "net.steve_s.iris.access.promopass"

    /// Every product Iris asks the store about.
    static let all: Set<String> = [fullGameUnlock, promotionalAccessPass]

    /// The right a verified, live transaction on this product grants; nil for anything Iris does not sell.
    static func entitlement(for productID: String) -> AccessEntitlement? {
        switch productID {
        case fullGameUnlock: .fullAccess
        case promotionalAccessPass: .promotionalAccess
        default: nil
        }
    }
}
