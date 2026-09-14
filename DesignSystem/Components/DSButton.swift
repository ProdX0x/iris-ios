// DSButton.swift
// Layer: DesignSystem
// Purpose: Primary, secondary and ghost actions with press feedback, 52 pt minimum height

import SwiftUI

struct DSButton: View {
    enum Variant {
        case primary
        case secondary
        case ghost
    }

    private let title: String
    private let systemImage: String?
    private let variant: Variant
    private let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    init(_ title: String, systemImage: String? = nil, variant: Variant = .primary, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.variant = variant
        self.action = action
    }

    var body: some View {
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
            .foregroundStyle(foreground)
            .background(background, in: Capsule())
            .overlay(Capsule().strokeBorder(border, lineWidth: 1))
        }
        .buttonStyle(DSPressableButtonStyle())
        .opacity(isEnabled ? 1 : 0.4)
        .accessibilityLabel(title)
    }

    private var background: Color {
        switch variant {
        case .primary: DSColor.Navigation.primary
        case .secondary: DSColor.Navigation.secondary
        case .ghost: .clear
        }
    }

    private var foreground: Color {
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
