// DSButton.swift
// Layer: DesignSystem
// Purpose: Primary, secondary and ghost actions, 52 pt minimum height: the system's Liquid Glass button styles where
// the platform draws them, the historical painted capsule before iOS 26 and under Reduce Transparency

import SwiftUI

struct DSButton: View {
    enum Variant {
        case primary
        case secondary
        case ghost

        /// What the action means to the system.
        var glassRole: DSGlassButtonStyle.Role {
            switch self {
            case .primary: .prominent
            case .secondary: .standard
            case .ghost: .plain
            }
        }
    }

    private let title: String
    private let systemImage: String?
    private let variant: Variant
    private let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    init(_ title: String, systemImage: String? = nil, variant: Variant = .primary, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.variant = variant
        self.action = action
    }

    var body: some View {
        let rendering = DSGlassRendering.resolve(reduceTransparency: reduceTransparency)
        // The system's glass draws the surface itself; everywhere else the button paints the capsule it always had.
        let paintsSurface = rendering != .native || variant == .ghost
        Button(action: action) {
            HStack(spacing: DSSpacing.s) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .accessibilityHidden(true)
                }
                Text(title)
            }
            .font(DSFont.headline)
            .frame(maxWidth: .infinity, minHeight: 52)
            .padding(.horizontal, DSSpacing.l)
            .foregroundStyle(foreground(rendering))
            .background(paintsSurface ? background(rendering) : .clear, in: Capsule())
            .overlay {
                if paintsSurface {
                    Capsule().strokeBorder(border, lineWidth: 1)
                }
            }
        }
        .dsGlassButton(variant.glassRole, rendering: rendering)
        .opacity(isEnabled ? 1 : 0.4)
        .accessibilityLabel(title)
    }

    /// The main action stands on the surface of its glass role; the others keep their own.
    private func background(_ rendering: DSGlassRendering) -> Color {
        switch variant {
        case .primary: DSGlassRole.prominentAction.fill(rendering)
        case .secondary: DSColor.Navigation.secondary
        case .ghost: .clear
        }
    }

    private func foreground(_ rendering: DSGlassRendering) -> Color {
        switch variant {
        case .primary: DSColor.Navigation.onPrimary
        case .secondary: DSColor.Identity.textPrimary
        case .ghost: DSColor.Identity.textSecondary
        }
    }

    private var border: Color {
        switch variant {
        case .primary: .clear
        case .secondary: DSColor.Identity.line
        case .ghost: .clear
        }
    }
}

struct DSPressableButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(DSMotion.animation(DSMotion.spring, reduceMotion: reduceMotion), value: configuration.isPressed)
    }
}

#Preview("Variants") {
    VStack(spacing: DSSpacing.m) {
        DSButton("Commencer", systemImage: "eye") {}
        DSButton("Reprendre", variant: .secondary) {}
        DSButton("Quitter", variant: .ghost) {}
        DSButton("Désactivé") {}.disabled(true)
    }
    .padding()
    .background(DSColor.Identity.ground)
}

#Preview("Accessibility size") {
    DSButton("Commencer", systemImage: "eye") {}
        .padding()
        .background(DSColor.Identity.ground)
        .dynamicTypeSize(.accessibility3)
}
