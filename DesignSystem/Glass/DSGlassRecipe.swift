// DSGlassRecipe.swift
// Layer: DesignSystem
// Purpose: The native Liquid Glass a surface uses: the system variant (clear or regular), an optional tint laid in
// the glass, optional content colour and edge, and the touch response; each role owns one, the gallery compares others

import SwiftUI

struct DSGlassRecipe: Hashable, Sendable {
    /// Variant of the system glass.
    enum Variant: Hashable, Sendable {
        case clear
        case regular
    }

    let variant: Variant
    /// Colour laid in the glass (a dark neutral for legibility, or a light accent); nil keeps the glass neutral.
    let tint: Color?
    /// Content colour on native glass; nil uses the role's own.
    let foreground: Color?
    /// A hairline drawn on the edge of native glass; nil draws none.
    let edge: Color?
    let isInteractive: Bool

    init(_ variant: Variant, tint: Color? = nil, foreground: Color? = nil, edge: Color? = nil, interactive: Bool = false) {
        self.variant = variant
        self.tint = tint
        self.foreground = foreground
        self.edge = edge
        self.isInteractive = interactive
    }
}

@available(iOS 26.0, *)
extension DSGlassRecipe {
    /// The system glass; `interactive` is false under Reduce Motion.
    func glass(interactive: Bool) -> Glass {
        let base: Glass = variant == .clear ? .clear : .regular
        return base.tint(tint).interactive(isInteractive && interactive)
    }
}
