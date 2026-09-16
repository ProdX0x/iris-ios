// OnboardingFigure.swift
// Layer: Presentation
// Purpose: The drawing that explains one rule of Iris: a gaze, its attention zone, a sphere and the iris waiting for
// it. Static by construction, so it costs nothing and never moves under Reduce Motion

import SwiftUI

struct OnboardingFigure: View {
    let figure: OnboardingPage.Figure
    let describedBy: String

    /// The board the figure is drawn on; every position below is expressed in it.
    private let board = CGSize(width: 300, height: 176)

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: DSRadius.m, style: .continuous)
                .strokeBorder(DSColor.Identity.line, lineWidth: 1)
            content
        }
        .frame(width: board.width, height: board.height)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(describedBy)
    }

    @ViewBuilder
    private var content: some View {
        switch figure {
        case .repulsion:
            gaze(at: CGPoint(x: 78, y: 88))
            sphere(at: CGPoint(x: 176, y: 88))
            nudge(at: CGPoint(x: 226, y: 88), degrees: 0, tint: DSColor.Identity.textSecondary)
        case .directStare:
            iris(at: CGPoint(x: 246, y: 88), isReached: false)
            sphere(at: CGPoint(x: 160, y: 88))
            gaze(at: CGPoint(x: 160, y: 88))
            nudge(at: CGPoint(x: 92, y: 88), degrees: 180, tint: DSColor.State.danger)
        case .indirectGaze:
            iris(at: CGPoint(x: 252, y: 88), isReached: false)
            gaze(at: CGPoint(x: 96, y: 112))
            sphere(at: CGPoint(x: 158, y: 80))
            nudge(at: CGPoint(x: 206, y: 80), degrees: 0, tint: DSColor.State.success)
        case .destination:
            trail(from: CGPoint(x: 72, y: 118), to: CGPoint(x: 222, y: 76))
            sphere(at: CGPoint(x: 72, y: 118))
            iris(at: CGPoint(x: 240, y: 70), isReached: true)
        }
    }

    // MARK: Pieces

    /// Where the player looks: a small ring inside the zone of attention that pushes.
    private func gaze(at point: CGPoint) -> some View {
        ZStack {
            Circle()
                .fill(RadialGradient(colors: [DSColor.Identity.accent.opacity(0.22), .clear], center: .center, startRadius: 4, endRadius: 46))
                .frame(width: 92, height: 92)
            Circle()
                .strokeBorder(DSColor.Identity.accent.opacity(0.45), style: StrokeStyle(lineWidth: 1, dash: [4, 5]))
                .frame(width: 84, height: 84)
            Circle()
                .strokeBorder(DSColor.Identity.accent, lineWidth: 2)
                .frame(width: 17, height: 17)
        }
        .position(point)
    }

    /// A lueur: the pearl core Iris uses everywhere for the spheres.
    private func sphere(at point: CGPoint) -> some View {
        ZStack {
            Circle()
                .fill(RadialGradient(colors: [DSColor.Identity.emblemGlow.opacity(0.35), .clear], center: .center, startRadius: 2, endRadius: 22))
                .frame(width: 44, height: 44)
            Circle()
                .fill(DSColor.Identity.emblemCore)
                .frame(width: 18, height: 18)
        }
        .position(point)
    }

    /// The iris waiting for a sphere: open once it is reached, still closing before.
    private func iris(at point: CGPoint, isReached: Bool) -> some View {
        let tint = isReached ? DSColor.State.success : DSColor.Identity.textSecondary
        return ZStack {
            Circle()
                .strokeBorder(tint.opacity(0.5), lineWidth: 1)
                .frame(width: 40, height: 40)
            DSApertureBlades(closure: isReached ? 0.24 : 0.6, rotation: 0)
                .stroke(tint, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .frame(width: 32, height: 32)
        }
        .position(point)
    }

    /// The direction the sphere is pushed in.
    private func nudge(at point: CGPoint, degrees: Double, tint: Color) -> some View {
        Image(systemName: "arrow.right")
            .font(DSFont.headline)
            .foregroundStyle(tint)
            .rotationEffect(.degrees(degrees))
            .position(point)
            .accessibilityHidden(true)
    }

    /// The road a sphere travels to its iris.
    private func trail(from start: CGPoint, to end: CGPoint) -> some View {
        Path { path in
            path.move(to: start)
            path.addQuadCurve(to: end, control: CGPoint(x: (start.x + end.x) / 2, y: start.y - 46))
        }
        .stroke(DSColor.Identity.textTertiary.opacity(0.65), style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [3, 6]))
    }
}

#Preview("Figures") {
    ZStack {
        DSBackground(intensity: .calm)
        ScrollView {
            VStack(spacing: DSSpacing.l) {
                ForEach(OnboardingPage.all) { page in
                    OnboardingFigure(figure: page.figure, describedBy: page.figureDescription)
                }
            }
            .padding(DSSpacing.gutter)
        }
    }
    .preferredColorScheme(.dark)
}
