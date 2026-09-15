// GalleryDemoGround.swift
// Layer: Tests
// Purpose: Demonstration grounds behind the Liquid Glass galleries: a rich one (blue-black and indigo areas, diffuse
// light, fibres, bands, rings) and a calmer version of it; not Iris's background, and none of these colours are tokens

import SwiftUI
@testable import Iris

struct GalleryDemoGround: View {
    enum Intensity: String, CaseIterable, Sendable {
        case rich = "riche"
        case calm = "calme"
    }

    var intensity: Intensity = .rich

    var body: some View {
        let rich = intensity == .rich
        ZStack {
            LinearGradient(colors: [Color(red: 0.02, green: 0.03, blue: 0.08), Color(red: 0.09, green: 0.07, blue: 0.24), Color(red: 0.03, green: 0.05, blue: 0.12)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            RadialGradient(colors: [Color(red: 0.40, green: 0.42, blue: 0.98).opacity(rich ? 0.55 : 0.28), .clear], center: UnitPoint(x: 0.18, y: 0.22), startRadius: 0, endRadius: 280)
            RadialGradient(colors: [Color(red: 0.62, green: 0.84, blue: 1.0).opacity(rich ? 0.38 : 0.18), .clear], center: UnitPoint(x: 0.88, y: 0.58), startRadius: 0, endRadius: 260)
            RadialGradient(colors: [Color(red: 0.95, green: 0.72, blue: 0.40).opacity(rich ? 0.22 : 0.10), .clear], center: UnitPoint(x: 0.35, y: 0.9), startRadius: 0, endRadius: 220)
            DSIrisFibers(opacity: rich ? 0.14 : 0.06, color: .white)
            Canvas { context, size in
                for index in 0..<14 where rich || index % 2 == 0 {
                    let x = CGFloat(index) * size.width / 7 - size.width / 2
                    var band = Path()
                    band.move(to: CGPoint(x: x, y: 0))
                    band.addLine(to: CGPoint(x: x + size.height * 0.5, y: size.height))
                    context.stroke(band, with: .color(.white.opacity(rich ? (index % 2 == 0 ? 0.10 : 0.05) : 0.04)), lineWidth: 10)
                }
                let rings = [CGPoint(x: 0.25, y: 0.35), CGPoint(x: 0.7, y: 0.2), CGPoint(x: 0.62, y: 0.72), CGPoint(x: 0.15, y: 0.8)]
                for (index, unit) in rings.enumerated() where rich || index < 2 {
                    let center = CGPoint(x: unit.x * size.width, y: unit.y * size.height)
                    let radius = CGFloat(40 + index * 22)
                    context.stroke(Path(ellipseIn: CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)),
                                   with: .color(Color(red: 0.8, green: 0.84, blue: 1).opacity(rich ? 0.45 : 0.22)), lineWidth: 2)
                    context.fill(Path(ellipseIn: CGRect(x: center.x - 5, y: center.y - 5, width: 10, height: 10)), with: .color(.white.opacity(rich ? 0.8 : 0.45)))
                }
            }
            if rich {
                Text("iris")
                    .font(.system(size: 160, weight: .light, design: .serif))
                    .foregroundStyle(.white.opacity(0.10))
                    .rotationEffect(.degrees(-12))
            }
        }
    }
}
