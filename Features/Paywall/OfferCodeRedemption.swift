// OfferCodeRedemption.swift
// Layer: Presentation
// Purpose: Apple's own code redemption sheet, and the ONLY place in the interface that reaches StoreKit. Iris has no
// code of its own to recognise: whatever the player redeems, the right comes back through the store's entitlements.
// Redeeming is an acquisition, so it answers to the same device rule as a purchase: on a device that cannot play
// Iris, the sheet is never attached, and a request to open it is withdrawn at once, whichever view made it

import StoreKit
import SwiftUI

struct OfferCodeRedemption: ViewModifier {
    @Binding var isPresented: Bool
    /// The store decides whether this device may start an acquisition at all; the view presenting the sheet does not.
    let store: any StorePurchasing
    /// True when the system reported the sheet closed without error; the rights are re-read either way.
    let onFinish: (Bool) -> Void

    /// Whether Apple's sheet may be attached here. Kept apart from the body so the rule can be held by a test.
    static func mayPresent(for store: any StorePurchasing) -> Bool {
        store.allowsNewAcquisitions
    }

    func body(content: Content) -> some View {
        if Self.mayPresent(for: store) {
            content.offerCodeRedemption(isPresented: $isPresented) { result in
                switch result {
                case .success:
                    onFinish(true)
                case .failure:
                    onFinish(false)
                }
            }
        } else {
            content.onChange(of: isPresented, initial: true) { _, requested in
                if requested { isPresented = false }
            }
        }
    }
}

extension View {
    /// Presents the App Store's redemption sheet, if `store` allows this device to acquire anything. Nothing in Iris
    /// parses, stores or compares a code.
    func dsOfferCodeRedemption(isPresented: Binding<Bool>, through store: any StorePurchasing,
                               onFinish: @escaping (Bool) -> Void) -> some View {
        modifier(OfferCodeRedemption(isPresented: isPresented, store: store, onFinish: onFinish))
    }
}
