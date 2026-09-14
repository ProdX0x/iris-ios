// GameSceneRenderer+Ancre.swift
// Layer: Presentation
// Purpose: Chapter X final « l'ancre »: draws the silhouette traced from the reference image, the segmented ring that
// fills with the head's circle, its checkpoints, the head's direction, the point to hold and the stardust of a
// completed loop, in the chapter palette; nothing here reads the engine

import SwiftUI

extension GameSceneRenderer {
    func drawAncre(_ scene: AncreSceneSnapshot, time: TimeInterval, in context: inout GraphicsContext, scale: Double,
                   palette: DSThemePalette, reduceMotion: Bool) {
        let center = CGPoint(x: scene.center.x, y: scene.center.y)
        drawAncreSilhouette(scene, center: center, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
        if scene.scatteringRingOpacity > 0.01 {
            drawAncreRing(scene, center: center, lit: 360, opacity: scene.scatteringRingOpacity, showsGuides: false, time: time,
                          in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
        }
        if let stardust = scene.stardust {
            drawAncreStardust(center: center, radius: scene.ringRadius, progress: stardust, time: time, in: &context, scale: scale,
                              palette: palette, reduceMotion: reduceMotion)
        }
        if scene.ringOpacity > 0.01 {
            drawAncreRing(scene, center: center, lit: scene.litSweep, opacity: scene.ringOpacity, showsGuides: true, time: time,
                          in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
        }
        drawAncrePoint(scene, center: center, time: time, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
    }

    // MARK: Silhouette

    private func drawAncreSilhouette(_ scene: AncreSceneSnapshot, center: CGPoint, in context: inout GraphicsContext, scale: Double,
                                     palette: DSThemePalette, reduceMotion: Bool) {
        let presence = scene.silhouetteOpacity
        guard presence > 0.01 else { return }
        let face = CGFloat(scene.ringRadius * AncreSceneSnapshot.faceScale)
        let lean = reduceMotion ? CGVector.zero : ancreLean(scene)
        let head = AncreSilhouette.headPath(center: center, scale: face, lean: lean)
        let round = StrokeStyle(lineWidth: 1.3 * scale, lineCap: .round, lineJoin: .round)
        var glow = context
        glow.blendMode = .plusLighter
        glow.fill(head, with: .color(palette.glow.opacity(0.03 * presence)))
        glow.stroke(head, with: .color(palette.glow.opacity(0.06 * presence)), style: StrokeStyle(lineWidth: 11 * scale, lineCap: .round, lineJoin: .round))
        glow.stroke(head, with: .color(palette.glow.opacity(0.13 * presence)), style: StrokeStyle(lineWidth: 4 * scale, lineCap: .round, lineJoin: .round))
        context.stroke(head, with: .color(palette.accent.opacity(0.5 * presence)), style: round)
        for mirrored in [false, true] {
            let shoulder = AncreSilhouette.shoulderPath(center: center, scale: face, lean: lean, mirrored: mirrored)
            let side: CGFloat = mirrored ? -1 : 1
            let from = CGPoint(x: center.x + side * AncreSilhouette.shoulderFade.lowerBound * face, y: center.y)
            let to = CGPoint(x: center.x + side * AncreSilhouette.shoulderFade.upperBound * face, y: center.y)
            glow.stroke(shoulder, with: .linearGradient(Gradient(colors: [palette.glow.opacity(0.12 * presence), palette.glow.opacity(0)]), startPoint: from, endPoint: to),
                        style: StrokeStyle(lineWidth: 4 * scale, lineCap: .round))
            context.stroke(shoulder, with: .linearGradient(Gradient(colors: [palette.accent.opacity(0.45 * presence), palette.accent.opacity(0)]), startPoint: from, endPoint: to),
                           style: round)
        }
    }

    /// The silhouette leans gently with the player's head; while it demonstrates, it draws the loop itself, slowly.
    private func ancreLean(_ scene: AncreSceneSnapshot) -> CGVector {
        let amount = 0.07
        if scene.demonstrates {
            // A six-second cycle: out to the starting side, once round in the loop's sense, back to face, a pause.
            let cycle = scene.phaseTime.truncatingRemainder(dividingBy: 6)
            var angle = scene.startAngle
            let size: Double
            switch cycle {
            case ..<0.8: size = cycle / 0.8
            case ..<4.8:
                size = 1
                angle += scene.screenTurn * 2 * Double.pi * (cycle - 0.8) / 4
            case ..<5.6: size = 1 - (cycle - 4.8) / 0.8
            default: size = 0
            }
            let eased = size * size * (3 - 2 * size)
            return CGVector(dx: amount * eased * cos(angle), dy: amount * eased * sin(angle))
        }
        guard let head = scene.head, head.length > 1e-6 else { return .zero }
        let clamp = min(1, 1.3 / head.length)
        return CGVector(dx: amount * head.x * clamp, dy: amount * head.y * clamp)
    }

    // MARK: Ring

    private func drawAncreRing(_ scene: AncreSceneSnapshot, center: CGPoint, lit: Double, opacity: Double, showsGuides: Bool, time: TimeInterval,
                               in context: inout GraphicsContext, scale: Double, palette: DSThemePalette, reduceMotion: Bool) {
        let radius = scene.ringRadius
        var dim = Path()
        var bright = Path()
        for index in 0..<AncreSceneSnapshot.barCount {
            let angle = 2 * Double.pi * Double(index) / Double(AncreSceneSnapshot.barCount)
            let along = scene.loopDegrees(atScreenAngle: angle)
            let isCheckpoint = AncreStageState.checkpoints.contains { abs($0 - along) < 2.5 }
            let half = (isCheckpoint ? 6.5 : 4.5) * scale
            var bar = Path()
            bar.move(to: CGPoint(x: center.x + (radius - half) * cos(angle), y: center.y + (radius - half) * sin(angle)))
            bar.addLine(to: CGPoint(x: center.x + (radius + half) * cos(angle), y: center.y + (radius + half) * sin(angle)))
            if lit >= 359.9 || (lit > 0 && along <= lit + 0.01) {
                bright.addPath(bar)
            } else {
                dim.addPath(bar)
            }
        }
        let bars = StrokeStyle(lineWidth: 2 * scale, lineCap: .round)
        context.stroke(dim, with: .color(DSColor.textTertiary.opacity(0.22 * opacity)), style: bars)
        if !bright.isEmpty {
            var glow = context
            glow.blendMode = .plusLighter
            glow.stroke(bright, with: .color(palette.glow.opacity(0.25 * opacity)), style: StrokeStyle(lineWidth: 5 * scale, lineCap: .round))
            context.stroke(bright, with: .color(palette.accent.opacity(0.9 * opacity)), style: bars)
        }
        guard showsGuides else { return }
        if scene.phase == .seeking || scene.phase == .circling {
            drawAncreArrow(scene, center: center, along: scene.phase == .seeking ? 0 : lit, opacity: opacity, in: &context, scale: scale, palette: palette)
        }
        drawAncreCheckpoints(scene, center: center, opacity: opacity, time: time, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
        if let head = scene.head, head.length > 0.05 {
            // The head's direction, as a soft light on the ring that brightens as the head reaches the circle.
            let strength = min(1, head.length)
            let angle = atan2(head.y, head.x)
            let point = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
            let size = 14 * scale
            var glow = context
            glow.blendMode = .plusLighter
            glow.fill(Path(ellipseIn: CGRect(x: point.x - size, y: point.y - size, width: 2 * size, height: 2 * size)),
                      with: .radialGradient(Gradient(colors: [palette.glow.opacity((0.1 + 0.35 * strength) * opacity), palette.glow.opacity(0)]),
                                            center: point, startRadius: 0, endRadius: size))
            if head.length >= 1 {
                let dot = 2.4 * scale
                context.fill(Path(ellipseIn: CGRect(x: point.x - dot, y: point.y - dot, width: 2 * dot, height: 2 * dot)), with: .color(DSColor.lueurCore.opacity(0.9 * opacity)))
            }
        }
    }

    /// An arrowhead just inside the ring, ahead of its lit edge, pointing the way round.
    private func drawAncreArrow(_ scene: AncreSceneSnapshot, center: CGPoint, along: Double, opacity: Double, in context: inout GraphicsContext,
                                scale: Double, palette: DSThemePalette) {
        let angle = scene.screenAngle(alongLoop: along + 9)
        let tangent = angle + scene.screenTurn * Double.pi / 2
        let distance = scene.ringRadius - 13 * scale
        let tip = CGPoint(x: center.x + distance * cos(angle) + 3 * scale * cos(tangent), y: center.y + distance * sin(angle) + 3 * scale * sin(tangent))
        let wing = 4.5 * scale
        var arrow = Path()
        arrow.move(to: CGPoint(x: tip.x - wing * cos(tangent - 0.6), y: tip.y - wing * sin(tangent - 0.6)))
        arrow.addLine(to: tip)
        arrow.addLine(to: CGPoint(x: tip.x - wing * cos(tangent + 0.6), y: tip.y - wing * sin(tangent + 0.6)))
        context.stroke(arrow, with: .color(palette.accent.opacity(0.6 * opacity)), style: StrokeStyle(lineWidth: 1.4 * scale, lineCap: .round, lineJoin: .round))
    }

    /// The starting side, the top, the opposite side and the bottom: reached ones glow (a short flash as they are
    /// reached), the next one breathes, the others wait.
    private func drawAncreCheckpoints(_ scene: AncreSceneSnapshot, center: CGPoint, opacity: Double, time: TimeInterval, in context: inout GraphicsContext,
                                      scale: Double, palette: DSThemePalette, reduceMotion: Bool) {
        let distance = scene.ringRadius + 12 * scale
        var glow = context
        glow.blendMode = .plusLighter
        for checkpoint in scene.checkpoints {
            let point = CGPoint(x: center.x + distance * cos(checkpoint.angle), y: center.y + distance * sin(checkpoint.angle))
            func disc(_ size: Double) -> Path {
                Path(ellipseIn: CGRect(x: point.x - size, y: point.y - size, width: 2 * size, height: 2 * size))
            }
            if checkpoint.isReached {
                if let age = checkpoint.age, age < 0.7, !reduceMotion {
                    let t = age / 0.7
                    glow.fill(disc((6 + 18 * t) * scale), with: .radialGradient(Gradient(colors: [palette.glow.opacity(0.55 * (1 - t) * opacity), palette.glow.opacity(0)]),
                                                                          center: point, startRadius: 0, endRadius: (6 + 18 * t) * scale))
                }
                context.fill(disc(2.6 * scale), with: .color(palette.accent.opacity(0.95 * opacity)))
            } else if checkpoint.isNext {
                let breath = reduceMotion ? 0.75 : 0.6 + 0.35 * sin(time * 3)
                glow.fill(disc(11 * scale), with: .radialGradient(Gradient(colors: [palette.glow.opacity(0.35 * breath * opacity), palette.glow.opacity(0)]),
                                                                center: point, startRadius: 0, endRadius: 11 * scale))
                context.fill(disc(3 * scale), with: .color(palette.accent.opacity(breath * opacity)))
            } else {
                context.fill(disc(2.2 * scale), with: .color(DSColor.textTertiary.opacity(0.35 * opacity)))
            }
        }
    }

    // MARK: Point and stardust

    private func drawAncrePoint(_ scene: AncreSceneSnapshot, center: CGPoint, time: TimeInterval, in context: inout GraphicsContext, scale: Double,
                                palette: DSThemePalette, reduceMotion: Bool) {
        let presence = scene.pointOpacity
        guard presence > 0.01 else { return }
        func disc(_ size: Double) -> Path {
            Path(ellipseIn: CGRect(x: center.x - size, y: center.y - size, width: 2 * size, height: 2 * size))
        }
        var glow = context
        glow.blendMode = .plusLighter
        func halo(_ size: Double, _ strength: Double) {
            glow.fill(disc(size), with: .radialGradient(Gradient(colors: [palette.glow.opacity(strength), palette.glow.opacity(0)]), center: center, startRadius: 0, endRadius: size))
        }
        // A look away: the point calls the eyes back with a wider, slow glow.
        if !scene.isFocused && (scene.phase == .seeking || scene.phase == .circling) {
            halo(30 * scale, 0.45 * (reduceMotion ? 1 : 0.75 + 0.25 * sin(time * 4)) * presence)
        }
        halo(17 * scale, 0.4 * presence)
        context.stroke(disc(7 * scale), with: .color(palette.accent.opacity(0.65 * presence)), lineWidth: 1.2 * scale)
        context.fill(disc(3.2 * scale), with: .color(DSColor.lueurCore.opacity(presence)))
        if scene.phase == .settling && scene.settleProgress > 0.01 {
            var arc = Path()
            arc.addArc(center: center, radius: 11 * scale, startAngle: .radians(-Double.pi / 2), endAngle: .radians(-Double.pi / 2 + 2 * Double.pi * scene.settleProgress), clockwise: false)
            context.stroke(arc, with: .color(palette.accent.opacity(0.85 * presence)), style: StrokeStyle(lineWidth: 1.6 * scale, lineCap: .round))
        }
        if scene.phase == .seeking && scene.phaseTime < 0.6 && !reduceMotion {
            let t = scene.phaseTime / 0.6
            glow.stroke(disc((11 + 16 * t) * scale), with: .color(palette.glow.opacity(0.6 * (1 - t) * presence)), lineWidth: 1.5 * scale)
        }
    }

    /// A completed ring scatters into fine stardust that drifts outward and fades.
    private func drawAncreStardust(center: CGPoint, radius: Double, progress: Double, time: TimeInterval, in context: inout GraphicsContext,
                                   scale: Double, palette: DSThemePalette, reduceMotion: Bool) {
        guard progress < 1 else { return }
        var glow = context
        glow.blendMode = .plusLighter
        let eased = 1 - pow(1 - progress, 2.2)
        let fade = pow(1 - progress, 1.3)
        let count = AncreSceneSnapshot.barCount
        for index in 0..<count {
            for grain in 0..<3 {
                let a = Self.ancreNoise(index, grain, 1), b = Self.ancreNoise(index, grain, 2), c = Self.ancreNoise(index, grain, 3)
                let d = Self.ancreNoise(index, grain, 4), e = Self.ancreNoise(index, grain, 5)
                let angle = 2 * Double.pi * (Double(index) + a) / Double(count) + (b - 0.5) * 0.5 * eased
                let distance = radius + (c - 0.35) * 10 * scale + (16 + 46 * d) * scale * eased
                let point = CGPoint(x: center.x + distance * cos(angle), y: center.y + distance * sin(angle) - 12 * scale * eased * e)
                let twinkle = reduceMotion ? 1 : 0.55 + 0.45 * sin(time * (5 + 6 * b) + 30 * a)
                let size = (0.6 + 1.2 * c) * scale * (1 - 0.4 * progress)
                let color = grain == 0 ? DSColor.lueurCore : palette.accent
                glow.fill(Path(ellipseIn: CGRect(x: point.x - size, y: point.y - size, width: 2 * size, height: 2 * size)),
                          with: .color(color.opacity(0.85 * fade * twinkle)))
            }
        }
    }

    private static func ancreNoise(_ index: Int, _ grain: Int, _ salt: Int) -> Double {
        let value = sin(Double(index * 127 + grain * 311 + salt * 74 + 1) * 12.9898) * 43758.5453
        return value - value.rounded(.down)
    }
}
