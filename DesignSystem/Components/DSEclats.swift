// DSEclats.swift
// Layer: DesignSystem
// Purpose: Three arcs around a circle, lit or unlit: the mastery marks of a level

import SwiftUI

struct DSEclats: View {
    /// Lit state of the three marks, in order.
    let lit: [Bool]
    let lineWidth: CGFloat

    init(lit: [Bool], lineWidth: CGFloat = 2.5) {
        self.lit = lit
        self.lineWidth = lineWidth
    }

    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .trim(from: Double(index) / 3 + 0.02, to: Double(index + 1) / 3 - 0.02)
                    .stroke(isLit(index) ? DSColor.State.success : DSColor.Identity.line,
                            style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(IrisText.interface("eclats.outOfThree.value", french: "%lld éclats sur 3", lit.filter { $0 }.count))
    }

    private func isLit(_ index: Int) -> Bool {
        lit.indices.contains(index) && lit[index]
    }
}

#Preview {
    HStack(spacing: DSSpacing.l) {
        DSEclats(lit: [false, false, false]).frame(width: 44, height: 44)
        DSEclats(lit: [true, false, true]).frame(width: 44, height: 44)
        DSEclats(lit: [true, true, true], lineWidth: 5).frame(width: 90, height: 90)
    }
    .padding()
    .background(DSColor.Identity.ground)
}
