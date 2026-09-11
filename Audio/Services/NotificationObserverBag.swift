// NotificationObserverBag.swift
// Layer: Audio
// Purpose: Owns NotificationCenter observer tokens and removes them when its owner is deallocated

import Foundation

final class NotificationObserverBag: @unchecked Sendable {
    private let lock = NSLock()
    private var tokens: [any NSObjectProtocol] = []

    init() {}

    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }

    func add(_ token: any NSObjectProtocol) {
        lock.withLock { tokens.append(token) }
    }
}
