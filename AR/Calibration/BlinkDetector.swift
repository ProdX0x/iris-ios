// BlinkDetector.swift
// Layer: AR (calibration, pure Swift)
// Purpose: Flags samples taken during a blink (either eye) and shortly after it

import Foundation

struct BlinkDetector: Hashable, Sendable {
    var threshold: Double
    var holdOff: TimeInterval
    private var lastBlinkTime: TimeInterval?

    init(threshold: Double = 0.5, holdOff: TimeInterval = 0.12) {
        self.threshold = threshold
        self.holdOff = holdOff
    }

    /// `left` and `right` are the `eyeBlinkLeft` / `eyeBlinkRight` blend shape coefficients (0...1).
    mutating func isBlinking(left: Double, right: Double, at time: TimeInterval) -> Bool {
        if max(left, right) >= threshold {
            lastBlinkTime = time
            return true
        }
        if let lastBlinkTime, time - lastBlinkTime < holdOff {
            return true
        }
        return false
    }
}
