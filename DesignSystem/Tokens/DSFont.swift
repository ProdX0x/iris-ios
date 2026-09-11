// DSFont.swift
// Layer: DesignSystem
// Purpose: Typography tokens: New York serif titles in lowercase, SF for reading, all Dynamic Type aware

import SwiftUI

enum DSFont {
    /// Wordmark and hero titles ("iris", "atteint", "regard prêt").
    static let display = Font.system(.largeTitle, design: .serif).weight(.regular)
    /// Screen and level titles.
    static let title = Font.system(.title, design: .serif).weight(.regular)
    static let title2 = Font.system(.title2, design: .serif).weight(.regular)
    static let title3 = Font.system(.title3, design: .serif).weight(.regular)
    static let headline = Font.headline
    static let body = Font.body
    static let callout = Font.callout
    static let footnote = Font.footnote
    static let caption = Font.caption
    /// Small uppercase tracked labels (use with `dsEyebrowStyle`).
    static let eyebrow = Font.caption.weight(.semibold)
    /// Chapter numerals (I, II, III...).
    static let numeral = Font.system(.title3, design: .serif).weight(.regular)
    /// Numeric readouts.
    static let mono = Font.system(.body, design: .default).monospacedDigit()
}
