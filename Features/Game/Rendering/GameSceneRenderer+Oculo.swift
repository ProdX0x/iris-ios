// GameSceneRenderer+Oculo.swift
// Layer: Presentation
// Purpose: OCULOMOTOR EXPANSION: draws the current gaze stage from its scene description, by role, in the chapter
// palette; nothing here reads the engine

import SwiftUI

extension GameSceneRenderer {
    /// Chapter XII: the constellation of completed stages, drawn behind the current stage and after the sequence ends.
    func drawOculoConstellation(_ oculo: OculoSnapshot, time: TimeInterval, in context: inout GraphicsContext, scale: Double,
                                palette: DSThemePalette, reduceMotion: Bool) {
        if let links = oculo.constellationLinks {
            drawOculoPolyline(links, in: &context, scale: scale, palette: palette)
        }
        for star in oculo.constellation where star.isLit {
            drawOculoElement(star, time: time, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
        }
    }

    func drawOculo(_ oculo: OculoSnapshot, time: TimeInterval, in context: inout GraphicsContext, scale: Double,
                   palette: DSThemePalette, reduceMotion: Bool) {
        if let ancre = oculo.ancre {
            drawAncre(ancre, time: time, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
        }
        for polyline in oculo.polylines {
            drawOculoPolyline(polyline, in: &context, scale: scale, palette: palette)
        }
        for arc in oculo.arcs {
            drawOculoArc(arc, in: &context, scale: scale, palette: palette)
        }
        for element in oculo.elements {
            drawOculoElement(element, time: time, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
        }
    }

    private func drawOculoPolyline(_ polyline: OculoPolylineSnapshot, in context: inout GraphicsContext, scale: Double, palette: DSThemePalette) {
        guard let first = polyline.points.first, polyline.intensity > 0.01 else { return }
        var path = Path()
        path.move(to: CGPoint(x: first.x, y: first.y))
        for point in polyline.points.dropFirst() { path.addLine(to: CGPoint(x: point.x, y: point.y)) }
        if polyline.isClosed { path.closeSubpath() }
        if polyline.isMist {
            context.stroke(path, with: .color(palette.glow.opacity(0.1 * polyline.intensity)), style: StrokeStyle(lineWidth: 44 * scale, lineCap: .round, lineJoin: .round))
            context.stroke(path, with: .color(palette.glow.opacity(0.16 * polyline.intensity)), style: StrokeStyle(lineWidth: 24 * scale, lineCap: .round, lineJoin: .round))
            return
        }
        context.stroke(path, with: .color(palette.accent.opacity(0.7 * polyline.intensity)),
                       style: StrokeStyle(lineWidth: 1.4 * scale, lineCap: .round, lineJoin: .round))
    }

    private func drawOculoArc(_ arc: OculoArcSnapshot, in context: inout GraphicsContext, scale: Double, palette: DSThemePalette) {
        var path = Path()
        path.addArc(center: CGPoint(x: arc.center.x, y: arc.center.y), radius: arc.radius, startAngle: .radians(arc.start), endAngle: .radians(arc.end), clockwise: false)
        let color = arc.isActive ? palette.accent : DSColor.textTertiary
        context.stroke(path, with: .color(color.opacity(0.25 + 0.6 * arc.intensity)), style: StrokeStyle(lineWidth: (arc.isActive ? 3 : 1.5) * scale, lineCap: .round))
    }

    private func drawOculoElement(_ element: OculoElementSnapshot, time: TimeInterval, in context: inout GraphicsContext, scale: Double,
                                  palette: DSThemePalette, reduceMotion: Bool) {
        let center = CGPoint(x: element.position.x, y: element.position.y)
        let breath = reduceMotion ? 1 : 1 + 0.12 * sin(time * 3.1 + Double(element.index))
        func disc(_ radius: CGFloat) -> Path {
            Path(ellipseIn: CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2))
        }
        func halo(_ radius: CGFloat, _ color: Color, _ opacity: Double) {
            var glow = context
            glow.blendMode = .plusLighter
            glow.fill(disc(radius), with: .radialGradient(Gradient(colors: [color.opacity(opacity), color.opacity(0)]), center: center, startRadius: 0, endRadius: radius))
        }
        switch element.role {
        case .target:
            if element.isActive {
                context.stroke(disc(element.radius), with: .color(palette.accent.opacity(0.12)), style: StrokeStyle(lineWidth: 1 * scale, dash: [2 * scale, 7 * scale]))
            }
            halo(22 * scale * breath, palette.glow, 0.15 + 0.35 * element.intensity)
            context.stroke(disc(8 * scale * breath), with: .color(palette.accent.opacity(0.4 + 0.5 * element.intensity)), lineWidth: 1.6 * scale)
            context.fill(disc(3 * scale), with: .color(DSColor.lueurCore.opacity(0.5 + 0.5 * element.intensity)))
        case .distractor:
            halo(18 * scale, DSColor.statusDanger, 0.35 * element.intensity)
            context.fill(disc(4 * scale), with: .color(DSColor.lueurCore.opacity(0.9 * element.intensity)))
        case .spark, .lantern:
            halo(26 * scale, palette.glow, 0.2 + 0.5 * element.intensity)
            context.fill(disc(6 * scale), with: .radialGradient(Gradient(colors: [DSColor.lueurCore, palette.accent.opacity(0.8)]), center: center, startRadius: 0, endRadius: 7 * scale))
            if element.isActive {
                context.stroke(disc(element.radius), with: .color(palette.accent.opacity(0.1)), style: StrokeStyle(lineWidth: 1 * scale, dash: [2 * scale, 7 * scale]))
            }
        case .flash:
            halo(element.radius * 0.8 * (1 + 0.6 * element.phase), DSColor.lueurGlow, 0.6 * element.intensity)
            context.fill(disc(9 * scale * (1 - 0.5 * element.phase)), with: .color(DSColor.lueurCore.opacity(element.intensity)))
        case .window:
            context.stroke(disc(element.radius), with: .color(palette.accent.opacity(element.isActive ? 0.14 : 0.05)), style: StrokeStyle(lineWidth: 1 * scale, dash: [2 * scale, 7 * scale]))
            halo(24 * scale * breath, palette.glow, element.isActive ? 0.35 : 0.05)
            context.stroke(disc(12 * scale * breath), with: .color(palette.accent.opacity(element.isActive ? 0.8 : 0.2)), lineWidth: 1.6 * scale)
            if element.isLit { context.fill(disc(5 * scale), with: .color(DSColor.statusSuccess)) }
        case .constellation:
            let pulse = reduceMotion ? 1 : 1 + (0.15 + 0.35 * element.phase) * sin(time * 2.1 + Double(element.index) * 0.9)
            halo(18 * scale * pulse, DSColor.lueurGlow, 0.35 + 0.35 * element.phase)
            context.fill(starPath(center: center, radius: 7 * scale * pulse, points: 4), with: .color(DSColor.lueurCore))
        case .star:
            if element.isLit || element.intensity > 0 {
                halo(16 * scale, DSColor.lueurGlow, 0.5 * max(element.intensity, element.isLit ? 0.8 : 0))
                context.fill(starPath(center: center, radius: 6 * scale, points: 4), with: .color(DSColor.lueurCore.opacity(0.5 + 0.5 * max(element.intensity, element.isLit ? 1 : 0))))
            } else if element.isActive {
                context.stroke(disc(element.radius), with: .color(palette.accent.opacity(0.08)), style: StrokeStyle(lineWidth: 1 * scale, dash: [2 * scale, 7 * scale]))
            }
        case .seed:
            if element.isLit {
                var stem = Path()
                stem.move(to: center)
                stem.addQuadCurve(to: CGPoint(x: center.x + 6 * scale, y: center.y - 26 * scale * element.intensity), control: CGPoint(x: center.x - 8 * scale, y: center.y - 14 * scale))
                context.stroke(stem, with: .color(palette.accent.opacity(0.8)), style: StrokeStyle(lineWidth: 1.6 * scale, lineCap: .round))
                let bloom = CGPoint(x: center.x + 6 * scale, y: center.y - 26 * scale * element.intensity)
                halo(14 * scale, palette.glow, 0.4)
                context.fill(Path(ellipseIn: CGRect(x: bloom.x - 5 * scale, y: bloom.y - 5 * scale, width: 10 * scale, height: 10 * scale)), with: .color(DSColor.lueurCore))
            } else {
                // Breathing seeds swell slowly; the others only twinkle, quick and small.
                let pulse: CGFloat
                if reduceMotion {
                    pulse = element.isActive ? 1.2 : 1
                } else if element.isActive {
                    pulse = 1 + 0.38 * sin(time * 2.3 + Double(element.index))
                } else {
                    pulse = 0.9 + 0.1 * sin(time * 9 + Double(element.index) * 1.7)
                }
                context.fill(disc(4 * scale * pulse), with: .color(palette.accent.opacity(0.7)))
                context.stroke(disc(7 * scale * pulse), with: .color(palette.accent.opacity(0.35)), lineWidth: 1 * scale)
                if element.intensity > 0 {
                    context.stroke(disc(11 * scale), with: .color(palette.glow.opacity(0.5 * element.intensity)), lineWidth: 1.2 * scale)
                }
            }
        case .cradle:
            context.stroke(disc(element.radius), with: .color(palette.accent.opacity(element.isActive ? 0.12 : 0.04)), style: StrokeStyle(lineWidth: 1 * scale, dash: [2 * scale, 7 * scale]))
            if element.isActive { halo(28 * scale * breath, palette.glow, 0.35) }
            context.stroke(disc(9 * scale * (element.isActive ? breath : 1)), with: .color(palette.accent.opacity(element.isLit ? 0.9 : (element.isActive ? 0.8 : 0.3))), lineWidth: 1.4 * scale)
            if element.isLit { context.fill(disc(4 * scale), with: .color(DSColor.lueurCore.opacity(0.9))) }
        case .relay:
            context.stroke(disc(element.radius), with: .color(palette.accent.opacity(element.isActive ? 0.12 : 0.04)), style: StrokeStyle(lineWidth: 1 * scale, dash: [2 * scale, 7 * scale]))
            if element.isActive { halo(24 * scale * breath, palette.glow, 0.35) }
            context.stroke(disc(8 * scale), with: .color(palette.accent.opacity(element.isLit ? 0.9 : (element.isActive ? 0.85 : 0.3))), lineWidth: 1.4 * scale)
            if element.isLit { context.fill(disc(3.5 * scale), with: .color(DSColor.statusSuccess.opacity(0.9))) }
        case .presence:
            if element.intensity > 0.01 {
                halo(30 * scale * breath, palette.glow, 0.45 * element.intensity)
                context.stroke(disc(10 * scale * breath), with: .color(palette.accent.opacity(0.9 * element.intensity)), lineWidth: 1.6 * scale)
                context.fill(disc(3.5 * scale), with: .color(DSColor.lueurCore.opacity(element.intensity)))
            }
            if element.isActive {
                context.stroke(disc(element.radius), with: .color(palette.accent.opacity(0.1)), style: StrokeStyle(lineWidth: 1 * scale, dash: [2 * scale, 7 * scale]))
            }
        case .announce:
            halo(element.radius * 0.6 * breath, palette.glow, 0.3 * element.intensity)
            context.stroke(disc(element.radius * 0.35 * breath), with: .color(palette.accent.opacity(0.6 * element.intensity)), style: StrokeStyle(lineWidth: 1.2 * scale, dash: [3 * scale, 4 * scale]))
        }
    }

    private func starPath(center: CGPoint, radius: CGFloat, points: Int) -> Path {
        var path = Path()
        for index in 0..<(points * 2) {
            let angle = Double(index) * .pi / Double(points) - .pi / 2
            let r = index.isMultiple(of: 2) ? radius : radius * 0.42
            let point = CGPoint(x: center.x + r * cos(angle), y: center.y + r * sin(angle))
            if index == 0 { path.move(to: point) } else { path.addLine(to: point) }
        }
        path.closeSubpath()
        return path
    }
}
