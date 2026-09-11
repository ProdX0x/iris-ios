// DSMotion.swift
// Layer: DesignSystem
// Purpose: Motion tokens; every animation has a Reduce Motion variant (cross-fade only)

import SwiftUI

enum DSMotion {
    static let fast: Double = 0.15
    static let standard: Double = 0.28
    static let slow: Double = 0.45
    static let breath: Double = 2.6

    static let standardAnimation = Animation.easeInOut(duration: standard)
    static let slowAnimation = Animation.easeInOut(duration: slow)
    static let spring = Animation.spring(response: 0.35, dampingFraction: 0.82)
    static let breathAnimation = Animation.easeInOut(duration: breath).repeatForever(autoreverses: true)

    /// Picks the animation honouring the accessibility setting.
    static func animation(_ animation: Animation, reduceMotion: Bool) -> Animation {
        reduceMotion ? .easeInOut(duration: fast) : animation
    }
}
