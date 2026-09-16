// EntitlementProviding.swift
// Layer: Domain (contract)
// Purpose: All the rest of Iris may ask about the player's commercial rights: one value. Never a product, never a
// price, never a transaction, never a store

import Foundation

@MainActor
protocol EntitlementProviding: AnyObject {
    /// The strongest right the player currently holds.
    var entitlement: AccessEntitlement { get }
}
