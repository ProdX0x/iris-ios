// DSGlassModifier.swift
// Layer: DesignSystem
// Purpose: `.dsGlass(role)`: draws a view on the glass of its role (its recipe), native Liquid Glass on iOS 26 and
// the plain surface of DSGlassSurface elsewhere or under Reduce Transparency; the touch response follows Reduce Motion

import SwiftUI

struct DSGlassModifier: ViewModifier {
    let role: DSGlassRole
    let shape: DSGlassShape
    let recipe: DSGlassRecipe

    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// `recipe` replaces the role's native glass (the development gallery compares candidates this way); the role
    /// still decides the plain surfaces drawn without Liquid Glass or under Reduce Transparency.
    init(role: DSGlassRole, shape: DSGlassShape? = nil, recipe: DSGlassRecipe? = nil) {
        self.role = role
        self.shape = shape ?? role.defaultShape
        self.recipe = recipe ?? role.recipe
    }

    func body(content: Content) -> some View {
        let rendering = DSGlassRendering.resolve(reduceTransparency: reduceTransparency)
        if rendering == .native {
            if #available(iOS 26.0, *) {
                content
                    .foregroundStyle(recipe.foreground ?? role.foreground(.native))
                    .glassEffect(recipe.glass(interactive: !reduceMotion), in: shape.shape)
                    .overlay {
                        if let edge = recipe.edge {
                            shape.hairline(edge).allowsHitTesting(false)
                        }
                    }
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
        modifier(DSGlassModifier(role: role, shape: shape))
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
