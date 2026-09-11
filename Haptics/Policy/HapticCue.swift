// HapticCue.swift
// Layer: Haptics
// Purpose: Touch intents derived from game events, independent from UIKit

import Foundation

enum HapticCue: Hashable, Sendable {
    /// Warm the generator: a hold has started, a pulse is likely within the hold duration.
    case prepare
    /// A lueur validated: light, positive.
    case validation
    /// A validation lost, whatever the cause; a cascade is one loss.
    case loss
    /// The level is complete: distinct success, replaces the validation pulse of the last iris.
    case levelComplete
}
