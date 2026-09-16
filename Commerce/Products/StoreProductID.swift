// StoreProductID.swift
// Layer: Commerce
// Purpose: The App Store product identifiers of Iris, written once and nowhere else, and the right each one grants

import Foundation

enum StoreProductID {
    /// Non-consumable. Unlocks the whole campaign, for good. App Store Connect reference name: Iris Full Game Unlock.
    static let fullGameUnlock = "net.steve-s.iris.unlock.fullgame"

    /// Auto-renewable subscription used ONLY as Apple's vehicle for a promotional offer code (a free 1-week offer
    /// configured not to renew). It is never sold, never presented as a subscription, and never purchased from Iris.
    /// App Store Connect reference name: Iris Promotional Access Pass.
    static let promotionalAccessPass = "net.steve-s.iris.access.promopass"

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
