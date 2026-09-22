// StorePurchaseOutcome.swift
// Layer: Commerce
// Purpose: How the last store call ended, in words the interface can show without knowing StoreKit

import Foundation

enum StorePurchaseOutcome: Hashable, Sendable {
    case purchased
    /// The purchase waits for someone else (Ask to Buy, a pending payment method).
    case pending
    case cancelled
    /// The store returned a right whose signature could not be trusted: it was refused.
    case unverified
    /// The product could not be read from the store (no store, no network, product not yet approved).
    case unavailable
    case restored
    case nothingToRestore
    case failed
    /// This device cannot play Iris, so nothing was bought: no transaction was opened and the store was not asked.
    case deviceUnsupported

    /// What the player is told. Nothing here names a price: the price always comes from the store itself.
    var notice: String? {
        switch self {
        case .purchased: IrisText.interface("purchase.unlocked", french: "Accès complet débloqué.")
        case .pending: IrisText.interface("purchase.pending", french: "Achat en attente de validation.")
        case .cancelled: nil
        case .unverified: IrisText.interface("purchase.unverified", french: "Cet achat n'a pas pu être vérifié par l'App Store.")
        case .unavailable: IrisText.interface("purchase.storeUnreachable", french: "L'App Store est injoignable pour le moment.")
        case .restored: IrisText.interface("purchase.restored", french: "Vos achats ont été restaurés.")
        case .nothingToRestore: IrisText.interface("purchase.nothingToRestore", french: "Aucun achat à restaurer sur ce compte Apple.")
        case .failed: IrisText.interface("purchase.failed", french: "L'achat n'a pas abouti.")
        case .deviceUnsupported: IrisText.interface("unavailable.faceTracking.detail", french: "Non pris en charge sur cet appareil")
        }
    }

    var isFailure: Bool {
        switch self {
        case .unverified, .unavailable, .failed, .nothingToRestore, .deviceUnsupported: true
        case .purchased, .pending, .cancelled, .restored: false
        }
    }
}
