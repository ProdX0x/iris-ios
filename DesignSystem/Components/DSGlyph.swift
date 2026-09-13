// DSGlyph.swift
// Layer: DesignSystem
// Purpose: Hand-drawn glyphs of the game's ideas (no SF Symbols in the game vocabulary)

import SwiftUI

struct DSGlyph: View {
    enum Kind: Hashable, Sendable {
        case lueur, iris, ecran, temperaments, ordre, cascade, courant, voile, veilleuse, irisMouvant, inconnu
        // Expansion
        case jumelles, souffle, dormeuse, echo, gouffre, braise, balise
    }

    let kind: Kind
    let tint: Color

    init(_ kind: Kind, tint: Color = DSColor.accent) {
        self.kind = kind
        self.tint = tint
    }

    var body: some View {
        Canvas { context, size in
            let s = min(size.width, size.height)
            let c = CGPoint(x: size.width / 2, y: size.height / 2)
            let stroke = StrokeStyle(lineWidth: max(1.2, s * 0.07), lineCap: .round, lineJoin: .round)
            func circle(_ center: CGPoint, _ r: CGFloat) -> Path {
                Path(ellipseIn: CGRect(x: center.x - r, y: center.y - r, width: r * 2, height: r * 2))
            }
            switch kind {
            case .lueur:
                context.fill(circle(c, s * 0.34), with: .color(tint.opacity(0.18)))
                context.fill(circle(c, s * 0.16), with: .color(tint))
            case .iris:
                context.stroke(circle(c, s * 0.4), with: .color(tint.opacity(0.5)), style: stroke)
                context.stroke(DSApertureBlades(closure: 0.4, rotation: 0).path(in: CGRect(x: c.x - s * 0.3, y: c.y - s * 0.3, width: s * 0.6, height: s * 0.6)),
                               with: .color(tint), style: stroke)
            case .ecran:
                context.stroke(Path(roundedRect: CGRect(x: c.x - s * 0.24, y: c.y - s * 0.42, width: s * 0.48, height: s * 0.84), cornerRadius: s * 0.1),
                               with: .color(tint), style: stroke)
                context.fill(circle(CGPoint(x: c.x, y: c.y), s * 0.07), with: .color(tint))
            case .temperaments:
                context.fill(circle(CGPoint(x: c.x - s * 0.16, y: c.y), s * 0.2), with: .color(tint))
                context.fill(circle(CGPoint(x: c.x + s * 0.26, y: c.y), s * 0.1), with: .color(tint.opacity(0.8)))
            case .ordre:
                for index in 0..<3 {
                    context.fill(circle(CGPoint(x: c.x + CGFloat(index - 1) * s * 0.3, y: c.y), s * 0.08 + CGFloat(index) * s * 0.02), with: .color(tint))
                }
            case .cascade:
                for index in 0..<3 {
                    context.fill(circle(CGPoint(x: c.x + CGFloat(index - 1) * s * 0.28, y: c.y + CGFloat(index - 1) * s * 0.22), s * 0.09),
                                 with: .color(tint.opacity(1 - Double(index) * 0.3)))
                }
            case .courant:
                var path = Path()
                for row in 0..<3 {
                    let y = c.y + CGFloat(row - 1) * s * 0.26
                    path.move(to: CGPoint(x: c.x - s * 0.4, y: y))
                    path.addCurve(to: CGPoint(x: c.x + s * 0.4, y: y), control1: CGPoint(x: c.x - s * 0.1, y: y - s * 0.14), control2: CGPoint(x: c.x + s * 0.1, y: y + s * 0.14))
                }
                context.stroke(path, with: .color(tint), style: stroke)
            case .voile:
                var path = Path()
                path.move(to: CGPoint(x: c.x - s * 0.4, y: c.y + s * 0.2))
                path.addLine(to: CGPoint(x: c.x + s * 0.4, y: c.y - s * 0.2))
                context.stroke(path, with: .color(tint.opacity(0.25)), style: StrokeStyle(lineWidth: s * 0.22, lineCap: .round))
                context.stroke(path, with: .color(tint), style: stroke)
            case .veilleuse:
                var flame = Path()
                flame.move(to: CGPoint(x: c.x, y: c.y - s * 0.38))
                flame.addQuadCurve(to: CGPoint(x: c.x, y: c.y + s * 0.3), control: CGPoint(x: c.x + s * 0.42, y: c.y + s * 0.12))
                flame.addQuadCurve(to: CGPoint(x: c.x, y: c.y - s * 0.38), control: CGPoint(x: c.x - s * 0.42, y: c.y + s * 0.12))
                context.fill(flame, with: .color(tint))
            case .irisMouvant:
                context.stroke(circle(c, s * 0.2), with: .color(tint), style: stroke)
                var arrows = Path()
                arrows.move(to: CGPoint(x: c.x - s * 0.44, y: c.y - s * 0.1))
                arrows.addLine(to: CGPoint(x: c.x - s * 0.34, y: c.y))
                arrows.addLine(to: CGPoint(x: c.x - s * 0.44, y: c.y + s * 0.1))
                arrows.move(to: CGPoint(x: c.x + s * 0.44, y: c.y - s * 0.1))
                arrows.addLine(to: CGPoint(x: c.x + s * 0.34, y: c.y))
                arrows.addLine(to: CGPoint(x: c.x + s * 0.44, y: c.y + s * 0.1))
                context.stroke(arrows, with: .color(tint), style: stroke)
            case .inconnu:
                context.stroke(circle(c, s * 0.36), with: .color(tint.opacity(0.4)), style: StrokeStyle(lineWidth: stroke.lineWidth, dash: [2, 4]))
            case .jumelles:
                var thread = Path()
                thread.move(to: CGPoint(x: c.x - s * 0.26, y: c.y))
                thread.addLine(to: CGPoint(x: c.x + s * 0.26, y: c.y))
                context.stroke(thread, with: .color(tint.opacity(0.6)), style: stroke)
                context.fill(circle(CGPoint(x: c.x - s * 0.28, y: c.y), s * 0.15), with: .color(tint))
                context.fill(circle(CGPoint(x: c.x + s * 0.28, y: c.y), s * 0.15), with: .color(tint))
            case .souffle:
                context.fill(circle(c, s * 0.3), with: .color(tint.opacity(0.18)))
                var gust = Path()
                for row in 0..<3 {
                    let y = c.y + CGFloat(row - 1) * s * 0.18
                    gust.move(to: CGPoint(x: c.x - s * 0.42 + CGFloat(row) * s * 0.06, y: y))
                    gust.addLine(to: CGPoint(x: c.x + s * 0.2 + CGFloat(row) * s * 0.06, y: y))
                }
                gust.move(to: CGPoint(x: c.x + s * 0.28, y: c.y - s * 0.16))
                gust.addLine(to: CGPoint(x: c.x + s * 0.44, y: c.y))
                gust.addLine(to: CGPoint(x: c.x + s * 0.28, y: c.y + s * 0.16))
                context.stroke(gust, with: .color(tint), style: stroke)
            case .dormeuse:
                context.fill(circle(c, s * 0.3), with: .color(tint.opacity(0.25)))
                context.stroke(circle(c, s * 0.3), with: .color(tint), style: stroke)
                var lid = Path()
                lid.move(to: CGPoint(x: c.x - s * 0.14, y: c.y - s * 0.02))
                lid.addQuadCurve(to: CGPoint(x: c.x + s * 0.14, y: c.y - s * 0.02), control: CGPoint(x: c.x, y: c.y + s * 0.12))
                context.stroke(lid, with: .color(tint), style: stroke)
            case .echo:
                context.fill(circle(c, s * 0.08), with: .color(tint))
                for ring in 1...3 {
                    var arc = Path()
                    arc.addArc(center: c, radius: s * 0.14 * CGFloat(ring), startAngle: .degrees(-50), endAngle: .degrees(50), clockwise: false)
                    context.stroke(arc, with: .color(tint.opacity(1 - Double(ring) * 0.22)), style: stroke)
                }
            case .gouffre:
                context.fill(circle(c, s * 0.42), with: .color(tint.opacity(0.12)))
                context.fill(circle(c, s * 0.22), with: .color(tint.opacity(0.9)))
                var swirl = Path()
                swirl.addArc(center: c, radius: s * 0.32, startAngle: .degrees(200), endAngle: .degrees(330), clockwise: false)
                context.stroke(swirl, with: .color(tint), style: stroke)
                var swirl2 = Path()
                swirl2.addArc(center: c, radius: s * 0.32, startAngle: .degrees(20), endAngle: .degrees(150), clockwise: false)
                context.stroke(swirl2, with: .color(tint), style: stroke)
            case .braise:
                context.fill(circle(c, s * 0.3), with: .color(tint.opacity(0.35)))
                context.stroke(circle(c, s * 0.3), with: .color(tint), style: StrokeStyle(lineWidth: stroke.lineWidth, dash: [s * 0.08, s * 0.1]))
                context.fill(circle(c, s * 0.12), with: .color(tint))
            case .balise:
                var thread = Path()
                thread.move(to: CGPoint(x: c.x - s * 0.42, y: c.y + s * 0.3))
                thread.addLine(to: CGPoint(x: c.x - s * 0.1, y: c.y))
                context.stroke(thread, with: .color(tint.opacity(0.55)), style: stroke)
                context.stroke(circle(CGPoint(x: c.x + s * 0.12, y: c.y - s * 0.12), s * 0.22), with: .color(tint), style: stroke)
                context.fill(circle(CGPoint(x: c.x + s * 0.12, y: c.y - s * 0.12), s * 0.08), with: .color(tint))
            }
        }
        .accessibilityHidden(true)
    }
}

#Preview {
    let kinds: [DSGlyph.Kind] = [.lueur, .iris, .ecran, .temperaments, .ordre, .cascade, .courant, .voile, .veilleuse, .irisMouvant, .inconnu, .jumelles, .souffle, .dormeuse, .echo, .gouffre, .braise, .balise]
    LazyVGrid(columns: Array(repeating: GridItem(.fixed(48)), count: 4)) {
        ForEach(kinds, id: \.self) { kind in
            DSGlyph(kind).frame(width: 32, height: 32)
        }
    }
    .padding()
    .background(DSColor.backgroundPrimary)
}
