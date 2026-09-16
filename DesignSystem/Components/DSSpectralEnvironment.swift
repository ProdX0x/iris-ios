// DSSpectralEnvironment.swift
// Layer: DesignSystem
// Purpose: The light Iris puts behind Apple's glass. A few very dark spectral fields — indigo low on the screen,
// cold blue high on one side, violet in the opposite corner — give the chambre noire enough variation for the
// system's material to have something to transmit. It belongs to the environment: it never follows the shape of a
// control, never sits above glass, and never brightens Iris into a light interface

import SwiftUI

struct DSSpectralEnvironment: View {
    enum Intensity: Hashable, Sendable {
        /// Reading screens: chapters, carnet, settings, secondary states.
        case calm
        /// The threshold and the end of the journey, where the interface is the whole subject.
        case vivid
        /// Behind the veil laid over a running level: the field must stay dim, only a little structure comes back.
        case veiled

        var scale: Double {
            switch self {
            case .calm: 1
            case .vivid: 1.3
            case .veiled: 0.75
            }
        }
    }

    let intensity: Intensity

    init(intensity: Intensity = .calm) {
        self.intensity = intensity
    }

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            let scale = intensity.scale
            ZStack {
                // The pool the main actions stand in: the lower third was mathematically flat before.
                RadialGradient(colors: [DSColor.Identity.spectralIndigo.opacity(0.26 * scale), .clear],
                               center: UnitPoint(x: 0.5, y: 1.04), startRadius: 0, endRadius: max(width, height) * 0.82)
                // A cold drift high on the trailing side, so the top band is never uniform either.
                RadialGradient(colors: [DSColor.Identity.spectralFrost.opacity(0.16 * scale), .clear],
                               center: UnitPoint(x: 0.94, y: 0.12), startRadius: 0, endRadius: width * 1.15)
                // A violet breath in the opposite corner: the two sides of a screen never read the same.
                RadialGradient(colors: [DSColor.Identity.spectralViolet.opacity(0.18 * scale), .clear],
                               center: UnitPoint(x: 0.04, y: 0.86), startRadius: 0, endRadius: width * 1.0)
                // A last, extremely soft lift toward the bottom edge.
                LinearGradient(colors: [.clear, DSColor.Identity.spectralIndigo.opacity(0.12 * scale)],
                               startPoint: .center, endPoint: .bottom)
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

#Preview("Environnement spectral") {
    ZStack {
        DSColor.Identity.ground.ignoresSafeArea()
        DSSpectralEnvironment(intensity: .vivid)
        VStack(spacing: DSSpacing.l) {
            Spacer()
            Text("le verre a désormais quelque chose à transmettre")
                .font(DSFont.callout)
                .foregroundStyle(DSColor.Identity.textSecondary)
                .padding(DSSpacing.l)
                .dsGlass(.regularPanel)
            Text("Commencer")
                .font(DSFont.headline)
                .frame(maxWidth: .infinity, minHeight: 52)
                .dsGlass(.prominentAction)
        }
        .padding(DSSpacing.gutter)
        .padding(.bottom, DSSpacing.xxl)
    }
    .preferredColorScheme(.dark)
}
