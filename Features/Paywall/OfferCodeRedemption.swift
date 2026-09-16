// OfferCodeRedemption.swift
// Layer: Presentation
// Purpose: Apple's own code redemption sheet, and the ONLY place in the interface that reaches StoreKit. Iris has no
// code of its own to recognise: whatever the player redeems, the right comes back through the store's entitlements

import StoreKit
import SwiftUI

struct OfferCodeRedemption: ViewModifier {
    @Binding var isPresented: Bool
    /// True when the system reported the sheet closed without error; the rights are re-read either way.
    let onFinish: (Bool) -> Void

    func body(content: Content) -> some View {
        content.offerCodeRedemption(isPresented: $isPresented) { result in
            switch result {
            case .success:
                onFinish(true)
            case .failure:
                onFinish(false)
            }
        }
    }
}

extension View {
    /// Presents the App Store's redemption sheet. Nothing in Iris parses, stores or compares a code.
    func dsOfferCodeRedemption(isPresented: Binding<Bool>, onFinish: @escaping (Bool) -> Void) -> some View {
        modifier(OfferCodeRedemption(isPresented: isPresented, onFinish: onFinish))
    }
}
