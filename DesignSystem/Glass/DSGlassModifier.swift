// DSGlassModifier.swift
// Layer: DesignSystem
// Purpose: `.dsGlass(role)`: draws a view on the glass of its role, native Liquid Glass on iOS 26 and the plain
// surface of DSGlassSurface elsewhere or under Reduce Transparency; the touch response follows Reduce Motion

import SwiftUI

struct DSGlassModifier: ViewModifier {
    let role: DSGlassRole
    let shape: DSGlassShape

    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        let rendering = DSGlassRendering.resolve(reduceTransparency: reduceTransparency)
        if rendering == .native {
            if #available(iOS 26.0, *) {
                content
                    .foregroundStyle(role.foreground(.native))
                    .glassEffect(role.glass(interactive: !reduceMotion), in: shape.shape)
            } else {
                content.modifier(DSGlassSurface(role: role, shape: shape, rendering: .translucent))
            }
        } else {
            content.modifier(DSGlassSurface(role: role, shape: shape, rendering: rendering))
        }
    }
}

extension View {
    /// Draws this view on the glass of `role`, in the role's own shape unless another one is given.
    func dsGlass(_ role: DSGlassRole, in shape: DSGlassShape? = nil) -> some View {
        modifier(DSGlassModifier(role: role, shape: shape ?? role.defaultShape))
    }
}

#Preview("Rôles de verre") {
    ZStack {
        DSBackground(intensity: .vivid)
        VStack(spacing: DSSpacing.l) {
            DSGlassGroup(spacing: DSSpacing.m) {
                HStack(spacing: DSSpacing.m) {
                    ForEach(["pause.fill", "xmark", "gearshape"], id: \.self) { symbol in
                        Image(systemName: symbol)
                            .font(DSFont.headline)
                            .frame(width: 48, height: 48)
                            .dsGlass(.clearControl)
                    }
                }
            }
            VStack(alignment: .leading, spacing: DSSpacing.s) {
                Text("pause").font(DSFont.title)
                Text("III · courants — la brèche").font(DSFont.callout)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(DSSpacing.l)
            .dsGlass(.regularPanel)
            Text("Commencer")
                .font(DSFont.headline)
                .frame(maxWidth: .infinity, minHeight: 52)
                .dsGlass(.prominentAction)
        }
        .padding(DSSpacing.gutter)
    }
    .preferredColorScheme(.dark)
}
