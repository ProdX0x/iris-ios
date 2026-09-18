// FixationTargetView.swift
// Layer: Presentation
// Purpose: One calibration or validation target positioned in normalized coordinates, with progress, stage label and
// a cancel control on the system's glass (the measurement itself is untouched)

import SwiftUI

struct FixationTargetView: View {
    let display: FixationDisplay
    let stageLabel: String
    let viewport: PlayfieldBounds
    let onCancel: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                FixationMark(progress: display.progress, isCollecting: display.isCollecting, tint: DSColor.Identity.accent)
                    .frame(width: 64, height: 64)
                    .position(x: display.target.x * proxy.size.width, y: display.target.y * proxy.size.height)
                    .animation(DSMotion.animation(DSMotion.standardAnimation, reduceMotion: reduceMotion), value: display.target)

                // Placed between the top and middle rows of targets so it never covers one of them.
                VStack(spacing: DSSpacing.xs) {
                    Text("\(stageLabel) \(display.index + 1) / \(display.count)")
                        .dsEyebrowStyle(tint: DSColor.Identity.accent)
                    Text(IrisText.interface("gazeSetup.fixation.instruction", french: "suivez le point des yeux, sans bouger la tête"))
                        .font(DSFont.footnote)
                        .foregroundStyle(DSColor.Identity.textSecondary)
                }
                .position(x: proxy.size.width / 2, y: proxy.size.height * 0.31)
                .accessibilityElement(children: .combine)

                Button(action: onCancel) {
                    Image(systemName: "xmark")
                        .font(DSFont.headline)
                        .frame(width: 44, height: 44)
                        .dsGlass(.clearControl)
                }
                .accessibilityLabel(IrisText.interface("common.cancel", french: "Annuler"))
                .position(x: DSSpacing.xl + DSSpacing.s, y: proxy.size.height - DSSpacing.xxl)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    FixationTargetView(display: FixationDisplay(target: SIMD2(0.15, 0.14), index: 0, count: 9, progress: 0.4, isCollecting: true),
                       stageLabel: "calibration", viewport: .referencePhone, onCancel: {})
        .background(DSColor.Identity.ground)
}
