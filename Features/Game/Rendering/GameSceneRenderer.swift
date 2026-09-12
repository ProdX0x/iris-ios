// GameSceneRenderer.swift
// Layer: Presentation
// Purpose: Draws the chambre noire world: currents, veils, route help, irises, veilleuses, lueurs, trouble, diagnostics,
// and the expansion elements in their chapter palette (VII: postes, threads and the shared iris of twins)

import SwiftUI

struct GameSceneRenderer {
    init() {}

    func draw(_ snapshot: GameSceneSnapshot, in context: inout GraphicsContext, size: CGSize, reduceMotion: Bool) {
        let scale = snapshot.scale
        let palette = snapshot.theme.palette
        drawCurrents(snapshot, in: &context, reduceMotion: reduceMotion)
        drawVeils(snapshot, in: &context)
        drawRoutes(snapshot, in: &context, scale: scale)
        for lueur in snapshot.lueurs where !lueur.isTwin {
            drawIris(lueur, sequential: snapshot.isSequential, in: &context, scale: scale)
        }
        for lueur in snapshot.lueurs where lueur.isTwin {
            drawPoste(lueur, in: &context, scale: scale, palette: palette)
        }
        for pair in snapshot.pairs {
            drawTwinPair(pair, sequential: snapshot.isSequential, time: snapshot.time, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
        }
        for veilleuse in snapshot.veilleuses {
            drawVeilleuse(veilleuse, time: snapshot.time, in: &context, scale: scale, reduceMotion: reduceMotion)
        }
        for lueur in snapshot.lueurs {
            drawLueur(lueur, sequential: snapshot.isSequential, time: snapshot.time, in: &context, reduceMotion: reduceMotion)
            if let partner = lueur.partner {
                drawTwinCrescent(lueur, toward: partner, in: &context, palette: palette)
            }
        }
        if let diagnostics = snapshot.diagnostics {
            drawDiagnostics(diagnostics, in: &context)
        }
        if let gaze = snapshot.gaze {
            drawCursor(at: gaze, in: &context)
        }
    }

    // MARK: Currents: drifting filaments

    private func drawCurrents(_ snapshot: GameSceneSnapshot, in context: inout GraphicsContext, reduceMotion: Bool) {
        let scale = snapshot.scale
        for (bandIndex, field) in snapshot.currents.enumerated() {
            let width = field.maxX - field.minX
            let height = field.maxY - field.minY
            let strength = field.impulse.length
            guard width > 0, height > 0, strength > 0 else { continue }
            let direction = field.impulse / strength
            let horizontal = abs(direction.x) >= abs(direction.y)
            let axisLength = horizontal ? width : height
            let speed = strength * 60 * 0.55
            let count = max(10, min(46, Int(width * height / 1500)))
            let segment = 18 * scale
            var path = Path()
            for index in 0..<count {
                let hx = fract(sin(Double(index * 127 + bandIndex * 311) + 1.3) * 43758.5453)
                let hy = fract(sin(Double(index * 269 + bandIndex * 183) + 7.1) * 12543.853)
                let travel = reduceMotion ? 0 : snapshot.time * speed / axisLength
                var x = field.minX + hx * width
                var y = field.minY + hy * height
                if horizontal {
                    x = field.minX + fract(hx + travel * (direction.x >= 0 ? 1 : -1)) * width
                } else {
                    y = field.minY + fract(hy + travel * (direction.y >= 0 ? 1 : -1)) * height
                }
                let along = horizontal ? (x - field.minX) / width : (y - field.minY) / height
                guard along > 0.04 && along < 0.96 else { continue }
                path.move(to: CGPoint(x: x - direction.x * segment / 2, y: y - direction.y * segment / 2))
                path.addLine(to: CGPoint(x: x + direction.x * segment / 2, y: y + direction.y * segment / 2))
            }
            context.stroke(path, with: .color(DSColor.maree.opacity(0.42)), style: StrokeStyle(lineWidth: 1.4 * scale, lineCap: .round))
        }
    }

    // MARK: Veils: membranes

    private func drawVeils(_ snapshot: GameSceneSnapshot, in context: inout GraphicsContext) {
        guard !snapshot.veils.isEmpty else { return }
        var path = Path()
        for veil in snapshot.veils {
            path.move(to: CGPoint(x: veil.a.x, y: veil.a.y))
            path.addLine(to: CGPoint(x: veil.b.x, y: veil.b.y))
        }
        let scale = snapshot.scale
        context.stroke(path, with: .color(DSColor.veil.opacity(0.08)), style: StrokeStyle(lineWidth: 14 * scale, lineCap: .round))
        context.stroke(path, with: .color(DSColor.veil.opacity(0.62)), style: StrokeStyle(lineWidth: 3 * scale, lineCap: .round))
    }

    // MARK: Route help

    private func drawRoutes(_ snapshot: GameSceneSnapshot, in context: inout GraphicsContext, scale: Double) {
        guard !snapshot.routes.isEmpty else { return }
        var path = Path()
        for route in snapshot.routes {
            guard let first = route.first else { continue }
            path.move(to: CGPoint(x: first.x, y: first.y))
            for point in route.dropFirst() {
                path.addLine(to: CGPoint(x: point.x, y: point.y))
            }
        }
        context.stroke(path, with: .color(DSColor.textPrimary.opacity(0.22)),
                       style: StrokeStyle(lineWidth: 2 * scale, lineCap: .round, lineJoin: .round, dash: [0.1, 10 * scale]))
    }

    // MARK: Iris: diaphragm closing with presence

    private func drawIris(_ lueur: LueurSnapshot, sequential: Bool, in context: inout GraphicsContext, scale: Double) {
        let center = CGPoint(x: lueur.arrival.x, y: lueur.arrival.y)
        let radius = lueur.irisRadius
        let ringColor = sequential ? DSColor.rank(lueur.sequence).opacity(lueur.isIrisOpen ? 0.7 : 0.25) : DSColor.textPrimary.opacity(lueur.isIrisOpen ? 0.28 : 0.12)
        context.stroke(circle(center, radius), with: .color(ringColor), lineWidth: 1.2 * scale)

        if lueur.isValidated {
            var glow = context
            glow.blendMode = .plusLighter
            glow.fill(circle(center, radius * 1.7), with: .radialGradient(Gradient(colors: [DSColor.statusSuccess.opacity(0.32), DSColor.statusSuccess.opacity(0)]),
                                                                          center: center, startRadius: 0, endRadius: radius * 1.7))
            context.fill(circle(center, radius * 0.42), with: .color(DSColor.statusSuccess.opacity(0.85)))
        } else {
            let closure = 0.12 + 0.78 * lueur.progress
            let bladesRect = CGRect(x: center.x - radius * 0.86, y: center.y - radius * 0.86, width: radius * 1.72, height: radius * 1.72)
            let blades = DSApertureBlades(closure: closure, rotation: lueur.progress * 40).path(in: bladesRect)
            let bladeColor = lueur.isIrisOpen ? (lueur.progress > 0 ? DSColor.accent : DSColor.accentDeep.opacity(0.8)) : DSColor.textTertiary.opacity(0.35)
            context.stroke(blades, with: .color(bladeColor), style: StrokeStyle(lineWidth: 2.2 * scale, lineCap: .round))
        }

        if sequential {
            let pipRadius = 2.2 * scale
            let spacing = 7 * scale
            let y = center.y - radius - 9 * scale
            let startX = center.x - Double(lueur.sequence - 1) * spacing / 2
            for index in 0..<lueur.sequence {
                context.fill(circle(CGPoint(x: startX + Double(index) * spacing, y: y), pipRadius), with: .color(DSColor.rank(lueur.sequence)))
            }
        }
    }

    // MARK: Twins (chapter VII): poste, thread, shared iris at the midpoint, crescent facing the partner

    private func drawPoste(_ lueur: LueurSnapshot, in context: inout GraphicsContext, scale: Double, palette: DSThemePalette) {
        guard let poste = lueur.poste else { return }
        let center = CGPoint(x: poste.x, y: poste.y)
        let radius = lueur.irisRadius * 0.7
        context.stroke(circle(center, radius), with: .color(palette.accent.opacity(lueur.isLinked ? 0.1 : 0.22)),
                       style: StrokeStyle(lineWidth: 1 * scale, dash: [2 * scale, 5 * scale]))
        context.fill(circle(center, 1.6 * scale), with: .color(palette.accent.opacity(0.35)))
    }

    private func drawTwinPair(_ pair: TwinPairSnapshot, sequential: Bool, time: TimeInterval, in context: inout GraphicsContext,
                              scale: Double, palette: DSThemePalette, reduceMotion: Bool) {
        let a = CGPoint(x: pair.a.x, y: pair.a.y)
        let b = CGPoint(x: pair.b.x, y: pair.b.y)
        let sight = pair.reach * 2.6
        let closeness = max(0, 1 - pair.distance / max(sight, 1))
        if closeness > 0 {
            var thread = Path()
            thread.move(to: a)
            thread.addLine(to: b)
            let opacity = pair.isLinked ? 0.75 : 0.12 + 0.4 * closeness
            context.stroke(thread, with: .color(palette.accent.opacity(opacity)),
                           style: StrokeStyle(lineWidth: (pair.isLinked ? 1.8 : 1.1) * scale, lineCap: .round, dash: pair.isLinked ? [] : [3 * scale, 6 * scale]))
        }
        let center = CGPoint(x: pair.midpoint.x, y: pair.midpoint.y)
        let radius = pair.reach * 0.18
        if pair.isValidated {
            var glow = context
            glow.blendMode = .plusLighter
            glow.fill(circle(center, radius * 2.4), with: .radialGradient(Gradient(colors: [DSColor.statusSuccess.opacity(0.32), DSColor.statusSuccess.opacity(0)]),
                                                                          center: center, startRadius: 0, endRadius: radius * 2.4))
            context.fill(circle(center, radius * 0.5), with: .color(DSColor.statusSuccess.opacity(0.85)))
            return
        }
        guard pair.isLinked else { return }
        let breath = reduceMotion ? 1 : 0.94 + 0.06 * sin(time * 3)
        let ringRadius = radius * breath
        context.stroke(circle(center, ringRadius), with: .color(palette.accent.opacity(pair.isIrisOpen ? 0.55 : 0.2)), lineWidth: 1.2 * scale)
        let closure = 0.12 + 0.78 * pair.progress
        let bladesRect = CGRect(x: center.x - ringRadius * 0.86, y: center.y - ringRadius * 0.86, width: ringRadius * 1.72, height: ringRadius * 1.72)
        let blades = DSApertureBlades(closure: closure, rotation: pair.progress * 40).path(in: bladesRect)
        let bladeColor = pair.isIrisOpen ? (pair.progress > 0 ? palette.accent : palette.accent.opacity(0.7)) : DSColor.textTertiary.opacity(0.35)
        context.stroke(blades, with: .color(bladeColor), style: StrokeStyle(lineWidth: 2 * scale, lineCap: .round))
    }

    private func drawTwinCrescent(_ lueur: LueurSnapshot, toward partner: Vector2, in context: inout GraphicsContext, palette: DSThemePalette) {
        let center = CGPoint(x: lueur.position.x, y: lueur.position.y)
        let delta = partner - lueur.position
        let length = delta.length
        guard length > 1e-6 else { return }
        let angle = atan2(delta.y, delta.x)
        var arc = Path()
        arc.addArc(center: center, radius: lueur.radius + 3.5 * lueur.radius / 20, startAngle: .radians(angle - 0.75), endAngle: .radians(angle + 0.75), clockwise: false)
        let color = lueur.isValidated ? DSColor.statusSuccess : palette.accent
        context.stroke(arc, with: .color(color.opacity(lueur.isLinked ? 0.95 : 0.6)), style: StrokeStyle(lineWidth: 1.8 * lueur.radius / 20, lineCap: .round))
    }

    // MARK: Veilleuse: flame and charge ring

    private func drawVeilleuse(_ flame: VeilleuseSnapshot, time: TimeInterval, in context: inout GraphicsContext, scale: Double, reduceMotion: Bool) {
        let center = CGPoint(x: flame.position.x, y: flame.position.y)
        context.stroke(circle(center, flame.lookRadius), with: .color(DSColor.accent.opacity(0.1)),
                       style: StrokeStyle(lineWidth: 1 * scale, dash: [3 * scale, 6 * scale]))
        let ringRadius = 16 * scale
        context.stroke(circle(center, ringRadius), with: .color(DSColor.lineSubtle), lineWidth: 2 * scale)
        if flame.charge > 0 {
            var arc = Path()
            arc.addArc(center: center, radius: ringRadius, startAngle: .degrees(-90), endAngle: .degrees(-90 + 360 * flame.charge), clockwise: false)
            context.stroke(arc, with: .color(flame.isLow ? DSColor.statusDanger : DSColor.accent), style: StrokeStyle(lineWidth: 2.5 * scale, lineCap: .round))

            let flicker = (flame.isLow && !reduceMotion) ? 0.85 + 0.15 * sin(time * 22) : 1
            let height = 20 * scale * (0.55 + 0.45 * flame.charge) * flicker
            var glow = context
            glow.blendMode = .plusLighter
            glow.fill(circle(center, height * 1.3), with: .radialGradient(Gradient(colors: [DSColor.accent.opacity(0.45 * flame.charge), DSColor.accent.opacity(0)]),
                                                                          center: center, startRadius: 0, endRadius: height * 1.3))
            context.fill(teardrop(center: center, height: height), with: .color(DSColor.accent))
        } else {
            context.fill(circle(center, 3 * scale), with: .color(DSColor.textTertiary))
        }
    }

    // MARK: Lueur: emissive disc, rank ring, trouble ripple

    private func drawLueur(_ lueur: LueurSnapshot, sequential: Bool, time: TimeInterval, in context: inout GraphicsContext, reduceMotion: Bool) {
        if let heat = lueur.heat, !lueur.isValidated {
            drawBraise(lueur, heat: heat, sequential: sequential, time: time, in: &context, reduceMotion: reduceMotion)
            return
        }
        let center = CGPoint(x: lueur.position.x, y: lueur.position.y)
        let radius = lueur.radius
        let glowColor = lueur.isValidated ? DSColor.statusSuccess : DSColor.lueurGlow
        let shimmer = (lueur.temperament == .vive && !reduceMotion) ? 0.8 + 0.2 * sin(time * 9 + Double(lueur.sequence)) : 1
        let haloOpacity = (lueur.temperament == .lourde ? 0.36 : 0.26) * shimmer
        var glow = context
        glow.blendMode = .plusLighter
        glow.fill(circle(center, radius * 2.8), with: .radialGradient(Gradient(colors: [glowColor.opacity(haloOpacity), glowColor.opacity(0)]),
                                                                      center: center, startRadius: radius * 0.6, endRadius: radius * 2.8))
        let highlight = CGPoint(x: center.x - radius * 0.3, y: center.y - radius * 0.3)
        let coreColors = lueur.isValidated ? [DSColor.lueurCore, DSColor.statusSuccess] : [DSColor.lueurCore, DSColor.lueurGlow]
        context.fill(circle(center, radius), with: .radialGradient(Gradient(colors: coreColors), center: highlight, startRadius: 0, endRadius: radius * 1.4))

        if sequential {
            context.stroke(circle(center, radius + 3.5 * lueur.radius / 20), with: .color(DSColor.rank(lueur.sequence).opacity(0.9)), lineWidth: 1.6 * lueur.radius / 20)
            let pip = radius * 0.11
            let spacing = radius * 0.36
            let startX = center.x - Double(lueur.sequence - 1) * spacing / 2
            for index in 0..<lueur.sequence {
                context.fill(circle(CGPoint(x: startX + Double(index) * spacing, y: center.y), pip), with: .color(DSColor.fieldInk.opacity(0.8)))
            }
        }

        if lueur.disturbance > 0.02 {
            if reduceMotion {
                context.stroke(circle(center, radius * 1.5), with: .color(DSColor.statusDanger.opacity(lueur.disturbance * 0.6)), lineWidth: 2)
            } else {
                let phase = fract(time * 2.2 + Double(lueur.sequence) * 0.3)
                context.stroke(circle(center, radius * (1.25 + 0.95 * phase)),
                               with: .color(DSColor.statusDanger.opacity(min(0.85, lueur.disturbance * 1.2) * (1 - phase))), lineWidth: 2)
            }
        }
    }

    // MARK: Braise (EXPERIMENTAL): an ember whose light is its heat; white-hot and pulsing when it flares

    private func drawBraise(_ lueur: LueurSnapshot, heat: Double, sequential: Bool, time: TimeInterval, in context: inout GraphicsContext, reduceMotion: Bool) {
        let center = CGPoint(x: lueur.position.x, y: lueur.position.y)
        let radius = lueur.radius
        let warmth = min(max(heat, 0), 1)
        let flarePulse = (lueur.isFlaring && !reduceMotion) ? 0.5 + 0.5 * sin(time * 26) : (lueur.isFlaring ? 1 : 0)
        let haloRadius = radius * (1.6 + 1.6 * warmth + 1.0 * flarePulse)
        let haloOpacity = 0.06 + 0.32 * warmth + 0.25 * flarePulse
        var glow = context
        glow.blendMode = .plusLighter
        glow.fill(circle(center, haloRadius), with: .radialGradient(Gradient(colors: [DSColor.accent.opacity(haloOpacity), DSColor.accent.opacity(0)]),
                                                                    center: center, startRadius: radius * 0.5, endRadius: haloRadius))
        // Ember body: dark when cold, amber as it warms, nacre core once lit.
        context.fill(circle(center, radius), with: .color(DSColor.fieldAbyss))
        context.fill(circle(center, radius), with: .color(DSColor.accentDeep.opacity(0.35 + 0.65 * warmth)))
        let coreRadius = radius * (0.25 + 0.55 * warmth)
        let coreOpacity = max(0, (warmth - 0.3) / 0.7)
        context.fill(circle(center, coreRadius), with: .radialGradient(Gradient(colors: [DSColor.lueurCore.opacity(coreOpacity), DSColor.accent.opacity(coreOpacity * 0.6)]),
                                                                       center: center, startRadius: 0, endRadius: coreRadius))
        if lueur.isFlaring {
            context.stroke(circle(center, radius * (1.15 + 0.35 * flarePulse)), with: .color(DSColor.lueurCore.opacity(0.5 + 0.4 * flarePulse)), lineWidth: 1.5)
        }
        context.stroke(circle(center, radius + 2.5 * radius / 20), with: .color(DSColor.accent.opacity(0.35 + 0.45 * warmth)),
                       style: StrokeStyle(lineWidth: 1.4 * radius / 20, dash: lueur.isIrisOpen ? [] : [2.5 * radius / 20, 3.5 * radius / 20]))

        if sequential {
            let pip = radius * 0.11
            let spacing = radius * 0.36
            let startX = center.x - Double(lueur.sequence - 1) * spacing / 2
            for index in 0..<lueur.sequence {
                context.fill(circle(CGPoint(x: startX + Double(index) * spacing, y: center.y), pip), with: .color(DSColor.fieldInk.opacity(0.8)))
            }
        }

        if lueur.disturbance > 0.02 {
            if reduceMotion {
                context.stroke(circle(center, radius * 1.5), with: .color(DSColor.statusDanger.opacity(lueur.disturbance * 0.6)), lineWidth: 2)
            } else {
                let phase = fract(time * 2.2 + Double(lueur.sequence) * 0.3)
                context.stroke(circle(center, radius * (1.25 + 0.95 * phase)),
                               with: .color(DSColor.statusDanger.opacity(min(0.85, lueur.disturbance * 1.2) * (1 - phase))), lineWidth: 2)
            }
        }
    }

    // MARK: Diagnostics

    private func drawDiagnostics(_ diagnostics: GazeDiagnostics, in context: inout GraphicsContext) {
        if let raw = diagnostics.raw {
            context.stroke(circle(CGPoint(x: raw.x, y: raw.y), 7), with: .color(DSColor.statusDanger.opacity(0.8)), lineWidth: 1.5)
        }
        if let calibrated = diagnostics.calibrated {
            context.fill(circle(CGPoint(x: calibrated.x, y: calibrated.y), 4), with: .color(DSColor.statusSuccess.opacity(0.9)))
        }
    }

    private func drawCursor(at gaze: Vector2, in context: inout GraphicsContext) {
        let center = CGPoint(x: gaze.x, y: gaze.y)
        context.stroke(circle(center, 14), with: .color(DSColor.accent.opacity(0.7)), lineWidth: 1.5)
        context.fill(circle(center, 2), with: .color(DSColor.accent))
    }

    // MARK: Shapes

    private func circle(_ center: CGPoint, _ radius: CGFloat) -> Path {
        Path(ellipseIn: CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2))
    }

    private func teardrop(center: CGPoint, height: CGFloat) -> Path {
        var path = Path()
        let top = CGPoint(x: center.x, y: center.y - height * 0.62)
        let bottom = CGPoint(x: center.x, y: center.y + height * 0.38)
        path.move(to: top)
        path.addQuadCurve(to: bottom, control: CGPoint(x: center.x + height * 0.46, y: center.y + height * 0.2))
        path.addQuadCurve(to: top, control: CGPoint(x: center.x - height * 0.46, y: center.y + height * 0.2))
        return path
    }

    private func fract(_ value: Double) -> Double {
        value - value.rounded(.down)
    }
}
