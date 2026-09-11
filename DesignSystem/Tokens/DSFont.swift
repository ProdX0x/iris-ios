// DSFont.swift
// Layer: DesignSystem
// Purpose: Typography tokens: serif display for the Iris voice, system text for reading, all Dynamic Type aware

import SwiftUI

enum DSFont {
    /// Wordmark and hero titles ("iris", "parcours terminé").
    static let display = Font.system(.largeTitle, design: .serif).weight(.medium)
    /// Screen titles.
    static let title = Font.system(.title, design: .serif).weight(.regular)
    /// Section titles and overlay headings.
    static let title2 = Font.system(.title2, design: .serif).weight(.regular)
    /// Emphasised body.
    static let headline = Font.headline
    static let body = Font.body
    static let callout = Font.callout
    static let footnote = Font.footnote
    static let caption = Font.caption
    /// Small uppercase tracked labels (use with `dsEyebrowStyle`).
    static let eyebrow = Font.caption.weight(.semibold)
    /// Numeric readouts.
    static let mono = Font.system(.caption, design: .monospaced)
}
