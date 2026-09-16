// AccessEntitlement.swift
// Layer: Domain
// Purpose: What the player is entitled to play: the free chapters only, a temporary promotional access, or the
// permanent full game. A pure business value: it names no product, no transaction and no store

import Foundation

enum AccessEntitlement: Hashable, Sendable, CaseIterable, Comparable {
    /// No commercial right is active: the free chapters only.
    case free
    /// A temporary right granted and still held: the whole campaign, until it expires.
    case promotionalAccess
    /// The permanent unlock: the whole campaign, for good.
    case fullAccess

    /// Strict priority of the model: fullAccess > promotionalAccess > free.
    var priority: Int {
        switch self {
        case .free: 0
        case .promotionalAccess: 1
        case .fullAccess: 2
        }
    }

    static func < (lhs: AccessEntitlement, rhs: AccessEntitlement) -> Bool {
        lhs.priority < rhs.priority
    }

    /// The strongest right held at one moment; `free` when none is.
    static func strongest(of held: some Sequence<AccessEntitlement>) -> AccessEntitlement {
        held.max() ?? .free
    }

    /// True when the whole campaign is open, whatever granted it.
    var opensWholeCampaign: Bool { self != .free }

    /// True when the right can end on its own and send the player back to the free chapters.
    var isTemporary: Bool { self == .promotionalAccess }
}
