// DSGlassSurface.swift
// Layer: DesignSystem
// Purpose: The plain surface standing in for glass: translucent where Liquid Glass is unavailable, opaque under
// Reduce Transparency, with a stronger edge under Increase Contrast; one fill and one hairline, nothing animated

import SwiftUI

struct DSGlassSurface: ViewModifier {
    let role: DSGlassRole
    let shape: DSGlassShape
    let rendering: DSGlassRendering

    @Environment(\.colorSchemeContrast) private var contrast

    func body(content: Content) -> some View {
        content
            .foregroundStyle(role.foreground(rendering))
            .background(role.fill(rendering), in: shape.shape)
            .overlay(shape.hairline(role.hairline(contrast)).allowsHitTesting(false))
    }
}
