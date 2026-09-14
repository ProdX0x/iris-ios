// DSGlassRendering.swift
// Layer: DesignSystem
// Purpose: The one place deciding how glass is drawn: native Liquid Glass on iOS 26, a light plain surface before,
// an opaque surface whenever Reduce Transparency is on; and whether glass morphs or only fades (Reduce Motion)

import SwiftUI

enum DSGlassRendering: Hashable, Sendable {
    /// The system's Liquid Glass (iOS 26 and later).
    case native
    /// A light translucent surface of the interface colours (iOS 17 to 25): no blur, no imitation of refraction.
    case translucent
    /// An opaque surface, on every version, when the user asks for less transparency.
    case opaque

    /// How glass elements appear, disappear and change shape.
    enum Transition: Hashable, Sendable {
        /// Neighbouring glass morphs from one shape into another.
        case morph
        /// The glass only fades in and out.
        case fade
    }

    /// True where the running system provides Liquid Glass.
    static var isNativeGlassAvailable: Bool {
        if #available(iOS 26.0, *) {
            return true
        }
        return false
    }

    static func resolve(nativeGlassAvailable: Bool = DSGlassRendering.isNativeGlassAvailable, reduceTransparency: Bool) -> DSGlassRendering {
        if reduceTransparency {
            return .opaque
        }
        return nativeGlassAvailable ? .native : .translucent
    }

    static func transition(reduceMotion: Bool) -> Transition {
        reduceMotion ? .fade : .morph
    }
}
