// DisplayLinkGameClock.swift
// Layer: App (platform adapter)
// Purpose: CADisplayLink clock pinned to 60 Hz, the rate the reference engine was validated at

import Foundation
import QuartzCore

@MainActor
final class DisplayLinkGameClock: GameClock {
    private(set) var isRunning = false
    private var link: CADisplayLink?
    private var lastTimestamp: CFTimeInterval?
    private var onTick: (@MainActor (TimeInterval) -> Void)?
    private let preferredFrameRate: Float

    init(preferredFrameRate: Float = 60) {
        self.preferredFrameRate = preferredFrameRate
    }

    func start(_ onTick: @escaping @MainActor (TimeInterval) -> Void) {
        stop()
        self.onTick = onTick
        let proxy = DisplayLinkProxy(owner: self)
        let link = CADisplayLink(target: proxy, selector: #selector(DisplayLinkProxy.step(_:)))
        link.preferredFrameRateRange = CAFrameRateRange(minimum: preferredFrameRate, maximum: preferredFrameRate, preferred: preferredFrameRate)
        link.add(to: .main, forMode: .common)
        self.link = link
        isRunning = true
    }

    func stop() {
        link?.invalidate()
        link = nil
        lastTimestamp = nil
        onTick = nil
        isRunning = false
    }

    fileprivate func step(timestamp: CFTimeInterval, duration: CFTimeInterval) {
        let delta = lastTimestamp.map { timestamp - $0 } ?? duration
        lastTimestamp = timestamp
        onTick?(delta)
    }
}

/// Breaks the retain cycle CADisplayLink would otherwise create with its target.
@MainActor
private final class DisplayLinkProxy: NSObject {
    private weak var owner: DisplayLinkGameClock?

    init(owner: DisplayLinkGameClock) {
        self.owner = owner
    }

    @objc func step(_ link: CADisplayLink) {
        guard let owner else {
            link.invalidate()
            return
        }
        owner.step(timestamp: link.timestamp, duration: link.duration)
    }
}
