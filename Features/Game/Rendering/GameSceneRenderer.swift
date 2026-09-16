// GameSceneRenderer.swift
// Layer: Presentation
// Purpose: Draws the chambre noire world: currents, veils, route help, irises, veilleuses, lueurs, trouble, diagnostics,
// and the expansion elements in their chapter palette (VII: postes, threads and the shared iris of twins;
// VIII: gust tracks, travelling gusts and the lift of a carried lueur; IX: echo reach, rings, sleeping lueurs;
// X: wells, swallowed and reborn lueurs; PROTOTYPE chapter I level 6: the thread of balises and the shut iris waking)

import SwiftUI

struct GameSceneRenderer {
    init() {}

    func draw(_ snapshot: GameSceneSnapshot, in context: inout GraphicsContext, size: CGSize, reduceMotion: Bool) {
        let scale = snapshot.scale
        let palette = snapshot.theme.palette
        drawCurrents(snapshot, in: &context, reduceMotion: reduceMotion)
        for well in snapshot.gouffres {
            drawGouffre(well, time: snapshot.time, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
        }
        drawSouffleTracks(snapshot, in: &context, scale: scale, palette: palette)
        drawVeils(snapshot, in: &context)
        drawRoutes(snapshot, in: &context, scale: scale)
        drawBaliseThreads(snapshot, in: &context, scale: scale)
        for lueur in snapshot.lueurs where !lueur.isTwin {
            drawIris(lueur, sequential: snapshot.isSequential, in: &context, scale: scale)
        }
        // Latent twins (an oculomotor final still in progress) show neither their postes nor their thread yet.
        for lueur in snapshot.lueurs where lueur.isTwin && !lueur.isLatent {
            drawPoste(lueur, in: &context, scale: scale, palette: palette)
        }
        for pair in snapshot.pairs where !(snapshot.lueurs.first?.isLatent ?? false) {
            drawTwinPair(pair, sequential: snapshot.isSequential, time: snapshot.time, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
        }
        if let reach = snapshot.echoReach {
            drawEchoReach(snapshot, reach: reach, in: &context, scale: scale, palette: palette)
        }
        for wave in snapshot.waves {
            drawEchoWave(wave, in: &context, scale: scale, palette: palette)
        }
        for veilleuse in snapshot.veilleuses {
            drawVeilleuse(veilleuse, time: snapshot.time, in: &context, scale: scale, reduceMotion: reduceMotion)
        }
        for souffle in snapshot.souffles {
            drawSouffle(souffle, time: snapshot.time, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
        }
        for balise in snapshot.balises {
            drawBalise(balise, time: snapshot.time, in: &context, scale: scale, reduceMotion: reduceMotion)
        }
        if let oculo = snapshot.oculo {
            drawOculoConstellation(oculo, time: snapshot.time, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
            // Chapter X final: the ancre keeps its silhouette and scatters its last ring after the sequence.
            if !oculo.isComplete || oculo.ancre != nil {
                drawOculo(oculo, time: snapshot.time, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
            }
        }
        for lueur in snapshot.lueurs {
            if lueur.isLatent {
                if let rebirth = lueur.rebirth {
                    drawRebirth(lueur, progress: rebirth, in: &context, palette: palette)
                }
                continue
            }
            if lueur.isCarried {
                drawLift(lueur, time: snapshot.time, in: &context, palette: palette, reduceMotion: reduceMotion)
            }
            if lueur.isAsleep {
                drawSleeper(lueur, sequential: snapshot.isSequential, time: snapshot.time, in: &context, palette: palette, reduceMotion: reduceMotion)
                continue
            }
            if let swallow = lueur.swallow {
                drawSwallowed(lueur, progress: swallow, in: &context, palette: palette)
                continue
            }
            if let rebirth = lueur.rebirth {
                drawRebirth(lueur, progress: rebirth, in: &context, palette: palette)
            }
            drawLueur(lueur, sequential: snapshot.isSequential, time: snapshot.time, in: &context, reduceMotion: reduceMotion)
            if let partner = lueur.partner {
                drawTwinCrescent(lueur, toward: partner, in: &context, palette: palette)
            }
        }
        #if DEBUG
        // Developer overlay: the raw and calibrated points, and the chevron of the last observable direction. A
        // player never sees these — the product marker is the cursor below, and the halo beside it.
        if let diagnostics = snapshot.diagnostics {
            drawDiagnostics(diagnostics, in: &context)
        }
        #endif
        if let guidance = snapshot.edgeGuidance {
            drawEdgeHalo(guidance, in: &context)
        }
        if let gaze = snapshot.gaze, snapshot.gazeMarkerOpacity > 0 {
            drawCursor(at: gaze, opacity: snapshot.gazeMarkerOpacity, in: &context)
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
            context.stroke(path, with: .color(DSColor.Chapter.maree.opacity(0.42)), style: StrokeStyle(lineWidth: 1.4 * scale, lineCap: .round))
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
        context.stroke(path, with: .color(DSColor.Chapter.veil.opacity(0.08)), style: StrokeStyle(lineWidth: 14 * scale, lineCap: .round))
        context.stroke(path, with: .color(DSColor.Chapter.veil.opacity(0.62)), style: StrokeStyle(lineWidth: 3 * scale, lineCap: .round))
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
        context.stroke(path, with: .color(DSColor.Chapter.nacre.opacity(0.22)),
                       style: StrokeStyle(lineWidth: 2 * scale, lineCap: .round, lineJoin: .round, dash: [0.1, 10 * scale]))
    }

    // MARK: Iris: diaphragm closing with presence

    private func drawIris(_ lueur: LueurSnapshot, sequential: Bool, in context: inout GraphicsContext, scale: Double) {
        let center = CGPoint(x: lueur.arrival.x, y: lueur.arrival.y)
        let radius = lueur.irisRadius
        let ringColor = sequential ? DSColor.Chapter.rank(lueur.sequence).opacity(lueur.isIrisOpen ? 0.7 : 0.25) : DSColor.Chapter.nacre.opacity(lueur.isIrisOpen ? 0.28 : 0.12)
        context.stroke(circle(center, radius), with: .color(ringColor), lineWidth: 1.2 * scale)

        if lueur.isValidated {
            var glow = context
            glow.blendMode = .plusLighter
            glow.fill(circle(center, radius * 1.7), with: .radialGradient(Gradient(colors: [DSColor.Chapter.success.opacity(0.32), DSColor.Chapter.success.opacity(0)]),
                                                                          center: center, startRadius: 0, endRadius: radius * 1.7))
            context.fill(circle(center, radius * 0.42), with: .color(DSColor.Chapter.success.opacity(0.85)))
        } else if lueur.isLatent, let awakening = lueur.awakening {
            // PROTOTYPE: shut, the iris opens a little with every balise of the thread.
            let closure = 0.92 - 0.72 * awakening
            let bladesRect = CGRect(x: center.x - radius * 0.86, y: center.y - radius * 0.86, width: radius * 1.72, height: radius * 1.72)
            let blades = DSApertureBlades(closure: closure, rotation: awakening * 30).path(in: bladesRect)
            context.stroke(blades, with: .color(DSColor.Chapter.attention.opacity(0.25 + 0.65 * awakening)), style: StrokeStyle(lineWidth: 2.2 * scale, lineCap: .round))
        } else {
            let closure = 0.12 + 0.78 * lueur.progress
            let bladesRect = CGRect(x: center.x - radius * 0.86, y: center.y - radius * 0.86, width: radius * 1.72, height: radius * 1.72)
            let blades = DSApertureBlades(closure: closure, rotation: lueur.progress * 40).path(in: bladesRect)
            let bladeColor = lueur.isIrisOpen ? (lueur.progress > 0 ? DSColor.Chapter.attention : DSColor.Chapter.attentionDeep.opacity(0.8)) : DSColor.Chapter.cendre.opacity(0.35)
            context.stroke(blades, with: .color(bladeColor), style: StrokeStyle(lineWidth: 2.2 * scale, lineCap: .round))
        }

        if sequential {
            let pipRadius = 2.2 * scale
            let spacing = 7 * scale
            let y = center.y - radius - 9 * scale
            let startX = center.x - Double(lueur.sequence - 1) * spacing / 2
            for index in 0..<lueur.sequence {
                context.fill(circle(CGPoint(x: startX + Double(index) * spacing, y: y), pipRadius), with: .color(DSColor.Chapter.rank(lueur.sequence)))
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
            glow.fill(circle(center, radius * 2.4), with: .radialGradient(Gradient(colors: [DSColor.Chapter.success.opacity(0.32), DSColor.Chapter.success.opacity(0)]),
                                                                          center: center, startRadius: 0, endRadius: radius * 2.4))
            context.fill(circle(center, radius * 0.5), with: .color(DSColor.Chapter.success.opacity(0.85)))
            return
        }
        guard pair.isLinked else { return }
        let breath = reduceMotion ? 1 : 0.94 + 0.06 * sin(time * 3)
        let ringRadius = radius * breath
        context.stroke(circle(center, ringRadius), with: .color(palette.accent.opacity(pair.isIrisOpen ? 0.55 : 0.2)), lineWidth: 1.2 * scale)
        let closure = 0.12 + 0.78 * pair.progress
        let bladesRect = CGRect(x: center.x - ringRadius * 0.86, y: center.y - ringRadius * 0.86, width: ringRadius * 1.72, height: ringRadius * 1.72)
        let blades = DSApertureBlades(closure: closure, rotation: pair.progress * 40).path(in: bladesRect)
        let bladeColor = pair.isIrisOpen ? (pair.progress > 0 ? palette.accent : palette.accent.opacity(0.7)) : DSColor.Chapter.cendre.opacity(0.35)
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
        let color = lueur.isValidated ? DSColor.Chapter.success : palette.accent
        context.stroke(arc, with: .color(color.opacity(lueur.isLinked ? 0.95 : 0.6)), style: StrokeStyle(lineWidth: 1.8 * lueur.radius / 20, lineCap: .round))
    }

    // MARK: Souffles (chapter VIII): track, travelling gust, lift of a carried lueur

    private func drawSouffleTracks(_ snapshot: GameSceneSnapshot, in context: inout GraphicsContext, scale: Double, palette: DSThemePalette) {
        guard !snapshot.souffles.isEmpty else { return }
        var path = Path()
        for souffle in snapshot.souffles {
            guard let first = souffle.path.first else { continue }
            path.move(to: CGPoint(x: first.x, y: first.y))
            for point in souffle.path.dropFirst() {
                path.addLine(to: CGPoint(x: point.x, y: point.y))
            }
        }
        context.stroke(path, with: .color(palette.accent.opacity(0.14)),
                       style: StrokeStyle(lineWidth: 1.2 * scale, lineCap: .round, lineJoin: .round, dash: [2 * scale, 7 * scale]))
        for souffle in snapshot.souffles {
            guard let last = souffle.path.last, souffle.path.count >= 2 else { continue }
            let before = souffle.path[souffle.path.count - 2]
            let delta = last - before
            let length = delta.length
            guard length > 1e-6 else { continue }
            let direction = delta / length
            let tip = CGPoint(x: last.x, y: last.y)
            let size = 6 * scale
            var arrow = Path()
            arrow.move(to: CGPoint(x: tip.x - direction.x * size - direction.y * size * 0.6, y: tip.y - direction.y * size + direction.x * size * 0.6))
            arrow.addLine(to: tip)
            arrow.addLine(to: CGPoint(x: tip.x - direction.x * size + direction.y * size * 0.6, y: tip.y - direction.y * size - direction.x * size * 0.6))
            context.stroke(arrow, with: .color(palette.accent.opacity(0.3)), style: StrokeStyle(lineWidth: 1.2 * scale, lineCap: .round, lineJoin: .round))
        }
    }

    private func drawSouffle(_ souffle: SouffleSnapshot, time: TimeInterval, in context: inout GraphicsContext, scale: Double,
                             palette: DSThemePalette, reduceMotion: Bool) {
        guard let position = souffle.position, souffle.presence > 0 else { return }
        let center = CGPoint(x: position.x, y: position.y)
        let radius = souffle.radius
        let presence = souffle.presence
        var glow = context
        glow.blendMode = .plusLighter
        glow.fill(circle(center, radius * 1.15), with: .radialGradient(Gradient(colors: [palette.glow.opacity(0.22 * presence), palette.accent.opacity(0.08 * presence), palette.accent.opacity(0)]),
                                                                      center: center, startRadius: 0, endRadius: radius * 1.15))
        context.stroke(circle(center, radius), with: .color(palette.accent.opacity(0.28 * presence)), lineWidth: 1 * scale)
        // Filaments drifting along the direction of travel, wrapping inside the disc.
        let direction = souffle.direction
        let normal = Vector2(x: -direction.y, y: direction.x)
        let travel = reduceMotion ? 0 : time * 1.6
        var filaments = Path()
        for index in 0..<9 {
            let seedA = fract(sin(Double(index) * 12.9898 + 4.1) * 43758.5453)
            let seedB = fract(sin(Double(index) * 78.233 + 1.7) * 12543.853)
            let across = (seedA * 2 - 1) * radius * 0.7
            let along = (fract(seedB + travel * 0.5) * 2 - 1) * radius * 0.8
            let limit = (radius * radius * 0.85 - across * across).squareRoot()
            guard abs(along) < limit else { continue }
            let mid = Vector2(x: position.x + direction.x * along + normal.x * across, y: position.y + direction.y * along + normal.y * across)
            let half = 7 * scale
            filaments.move(to: CGPoint(x: mid.x - direction.x * half, y: mid.y - direction.y * half))
            filaments.addLine(to: CGPoint(x: mid.x + direction.x * half, y: mid.y + direction.y * half))
        }
        context.stroke(filaments, with: .color(palette.glow.opacity(0.45 * presence)), style: StrokeStyle(lineWidth: 1.2 * scale, lineCap: .round))
    }

    private func drawLift(_ lueur: LueurSnapshot, time: TimeInterval, in context: inout GraphicsContext, palette: DSThemePalette, reduceMotion: Bool) {
        let center = CGPoint(x: lueur.position.x, y: lueur.position.y)
        let breath = reduceMotion ? 1 : 0.9 + 0.1 * sin(time * 6)
        let radius = lueur.radius * 2.2 * breath
        var glow = context
        glow.blendMode = .plusLighter
        glow.fill(circle(center, radius), with: .radialGradient(Gradient(colors: [palette.accent.opacity(0.3), palette.accent.opacity(0)]),
                                                                center: center, startRadius: lueur.radius * 0.5, endRadius: radius))
        context.stroke(circle(center, lueur.radius * 1.35), with: .color(palette.accent.opacity(0.6)), lineWidth: 1.2 * lueur.radius / 20)
    }

    // MARK: Échos (chapter IX): reach of every echo source, rings in flight, sleeping lueurs

    private func drawEchoReach(_ snapshot: GameSceneSnapshot, reach: Double, in context: inout GraphicsContext, scale: Double, palette: DSThemePalette) {
        for lueur in snapshot.lueurs where lueur.echoes {
            let center = CGPoint(x: lueur.arrival.x, y: lueur.arrival.y)
            context.stroke(circle(center, reach), with: .color(palette.accent.opacity(lueur.isValidated ? 0.16 : 0.09)),
                           style: StrokeStyle(lineWidth: 1 * scale, dash: [2 * scale, 7 * scale]))
        }
    }

    private func drawEchoWave(_ wave: EchoWaveSnapshot, in context: inout GraphicsContext, scale: Double, palette: DSThemePalette) {
        guard wave.front > 0, wave.reach > 0 else { return }
        let progress = min(1, wave.front / wave.reach)
        let center = CGPoint(x: wave.origin.x, y: wave.origin.y)
        let opacity = 0.7 * (1 - progress * progress)
        guard opacity > 0.01 else { return }
        var glow = context
        glow.blendMode = .plusLighter
        glow.stroke(circle(center, wave.front), with: .color(palette.glow.opacity(opacity * 0.5)), lineWidth: 10 * scale * (1 - progress) + 2 * scale)
        context.stroke(circle(center, wave.front), with: .color(palette.accent.opacity(opacity)), lineWidth: 1.6 * scale)
    }

    private func drawSleeper(_ lueur: LueurSnapshot, sequential: Bool, time: TimeInterval, in context: inout GraphicsContext,
                             palette: DSThemePalette, reduceMotion: Bool) {
        let center = CGPoint(x: lueur.position.x, y: lueur.position.y)
        let radius = lueur.radius
        let breath = reduceMotion ? 1 : 0.92 + 0.08 * sin(time * 1.4 + Double(lueur.sequence))
        var glow = context
        glow.blendMode = .plusLighter
        glow.fill(circle(center, radius * 1.9 * breath), with: .radialGradient(Gradient(colors: [palette.accent.opacity(0.14), palette.accent.opacity(0)]),
                                                                                center: center, startRadius: radius * 0.5, endRadius: radius * 1.9 * breath))
        context.fill(circle(center, radius), with: .color(DSColor.Chapter.abyss))
        context.fill(circle(center, radius), with: .color(DSColor.Chapter.lueurGlow.opacity(0.22)))
        context.stroke(circle(center, radius), with: .color(palette.accent.opacity(0.75)), lineWidth: 1.4 * radius / 20)
        // A closed lid across the body.
        var lid = Path()
        lid.move(to: CGPoint(x: center.x - radius * 0.5, y: center.y - radius * 0.05))
        lid.addQuadCurve(to: CGPoint(x: center.x + radius * 0.5, y: center.y - radius * 0.05), control: CGPoint(x: center.x, y: center.y + radius * 0.4))
        context.stroke(lid, with: .color(palette.accent.opacity(0.9)), style: StrokeStyle(lineWidth: 1.6 * radius / 20, lineCap: .round))

        if sequential {
            let pip = radius * 0.11
            let spacing = radius * 0.36
            let startX = center.x - Double(lueur.sequence - 1) * spacing / 2
            for index in 0..<lueur.sequence {
                context.fill(circle(CGPoint(x: startX + Double(index) * spacing, y: center.y - radius * 0.45), pip), with: .color(palette.accent.opacity(0.8)))
            }
        }
        if lueur.disturbance > 0.02 {
            context.stroke(circle(center, radius * 1.4), with: .color(DSColor.Chapter.trouble.opacity(lueur.disturbance * 0.6)), lineWidth: 2)
        }
    }

    // MARK: Gouffres (chapter X): the pull, the mouth, a swallowed lueur, a reborn lueur

    private func drawGouffre(_ well: GouffreSnapshot, time: TimeInterval, in context: inout GraphicsContext, scale: Double,
                             palette: DSThemePalette, reduceMotion: Bool) {
        let center = CGPoint(x: well.center.x, y: well.center.y)
        context.fill(circle(center, well.pullRadius), with: .radialGradient(Gradient(colors: [DSColor.Chapter.abyss.opacity(0.9), DSColor.Chapter.abyss.opacity(0)]),
                                                                            center: center, startRadius: well.radius * 0.8, endRadius: well.pullRadius))
        context.stroke(circle(center, well.pullRadius), with: .color(palette.accent.opacity(0.1)),
                       style: StrokeStyle(lineWidth: 1 * scale, dash: [2 * scale, 6 * scale]))
        context.fill(circle(center, well.radius), with: .color(DSColor.Chapter.abyss))
        context.fill(circle(center, well.radius), with: .radialGradient(Gradient(colors: [DSColor.Chapter.ink.opacity(0), palette.accent.opacity(0.22)]),
                                                                        center: center, startRadius: well.radius * 0.3, endRadius: well.radius))
        let spin = reduceMotion ? 0 : time * 0.9
        for ring in 0..<2 {
            var swirl = Path()
            let radius = well.radius * (0.55 + 0.35 * Double(ring))
            let start = Angle.radians(spin * (ring == 0 ? 1 : -0.7) + Double(ring) * 2.1)
            swirl.addArc(center: center, radius: radius, startAngle: start, endAngle: start + .degrees(150), clockwise: false)
            context.stroke(swirl, with: .color(palette.accent.opacity(0.35 - 0.1 * Double(ring))), style: StrokeStyle(lineWidth: 1.2 * scale, lineCap: .round))
        }
        context.stroke(circle(center, well.radius), with: .color(palette.accent.opacity(0.5)), lineWidth: 1.2 * scale)
    }

    private func drawSwallowed(_ lueur: LueurSnapshot, progress: Double, in context: inout GraphicsContext, palette: DSThemePalette) {
        let center = CGPoint(x: lueur.position.x, y: lueur.position.y)
        let radius = lueur.radius * (1 - progress)
        guard radius > 0.5 else { return }
        context.fill(circle(center, radius), with: .radialGradient(Gradient(colors: [DSColor.Chapter.lueurCore.opacity(1 - progress), palette.accent.opacity(0.4 * (1 - progress))]),
                                                                   center: center, startRadius: 0, endRadius: radius))
    }

    private func drawRebirth(_ lueur: LueurSnapshot, progress: Double, in context: inout GraphicsContext, palette: DSThemePalette) {
        let center = CGPoint(x: lueur.position.x, y: lueur.position.y)
        let radius = lueur.radius * (3.2 - 2.2 * progress)
        var glow = context
        glow.blendMode = .plusLighter
        glow.fill(circle(center, radius), with: .radialGradient(Gradient(colors: [palette.glow.opacity(0.35 * (1 - progress)), palette.glow.opacity(0)]),
                                                                center: center, startRadius: 0, endRadius: radius))
    }

    // MARK: Veilleuse: flame and charge ring

    private func drawVeilleuse(_ flame: VeilleuseSnapshot, time: TimeInterval, in context: inout GraphicsContext, scale: Double, reduceMotion: Bool) {
        let center = CGPoint(x: flame.position.x, y: flame.position.y)
        context.stroke(circle(center, flame.lookRadius), with: .color(DSColor.Chapter.attention.opacity(0.1)),
                       style: StrokeStyle(lineWidth: 1 * scale, dash: [3 * scale, 6 * scale]))
        let ringRadius = 16 * scale
        context.stroke(circle(center, ringRadius), with: .color(DSColor.Chapter.line), lineWidth: 2 * scale)
        if flame.charge > 0 {
            var arc = Path()
            arc.addArc(center: center, radius: ringRadius, startAngle: .degrees(-90), endAngle: .degrees(-90 + 360 * flame.charge), clockwise: false)
            context.stroke(arc, with: .color(flame.isLow ? DSColor.Chapter.trouble : DSColor.Chapter.attention), style: StrokeStyle(lineWidth: 2.5 * scale, lineCap: .round))

            let flicker = (flame.isLow && !reduceMotion) ? 0.85 + 0.15 * sin(time * 22) : 1
            let height = 20 * scale * (0.55 + 0.45 * flame.charge) * flicker
            var glow = context
            glow.blendMode = .plusLighter
            glow.fill(circle(center, height * 1.3), with: .radialGradient(Gradient(colors: [DSColor.Chapter.attention.opacity(0.45 * flame.charge), DSColor.Chapter.attention.opacity(0)]),
                                                                          center: center, startRadius: 0, endRadius: height * 1.3))
            context.fill(teardrop(center: center, height: height), with: .color(DSColor.Chapter.attention))
        } else {
            context.fill(circle(center, 3 * scale), with: .color(DSColor.Chapter.cendre))
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
        let glowColor = lueur.isValidated ? DSColor.Chapter.success : DSColor.Chapter.lueurGlow
        let shimmer = (lueur.temperament == .vive && !reduceMotion) ? 0.8 + 0.2 * sin(time * 9 + Double(lueur.sequence)) : 1
        let haloOpacity = (lueur.temperament == .lourde ? 0.36 : 0.26) * shimmer
        var glow = context
        glow.blendMode = .plusLighter
        glow.fill(circle(center, radius * 2.8), with: .radialGradient(Gradient(colors: [glowColor.opacity(haloOpacity), glowColor.opacity(0)]),
                                                                      center: center, startRadius: radius * 0.6, endRadius: radius * 2.8))
        let highlight = CGPoint(x: center.x - radius * 0.3, y: center.y - radius * 0.3)
        let coreColors = lueur.isValidated ? [DSColor.Chapter.lueurCore, DSColor.Chapter.success] : [DSColor.Chapter.lueurCore, DSColor.Chapter.lueurGlow]
        context.fill(circle(center, radius), with: .radialGradient(Gradient(colors: coreColors), center: highlight, startRadius: 0, endRadius: radius * 1.4))

        if sequential {
            context.stroke(circle(center, radius + 3.5 * lueur.radius / 20), with: .color(DSColor.Chapter.rank(lueur.sequence).opacity(0.9)), lineWidth: 1.6 * lueur.radius / 20)
            let pip = radius * 0.11
            let spacing = radius * 0.36
            let startX = center.x - Double(lueur.sequence - 1) * spacing / 2
            for index in 0..<lueur.sequence {
                context.fill(circle(CGPoint(x: startX + Double(index) * spacing, y: center.y), pip), with: .color(DSColor.Chapter.ink.opacity(0.8)))
            }
        }

        if lueur.disturbance > 0.02 {
            if reduceMotion {
                context.stroke(circle(center, radius * 1.5), with: .color(DSColor.Chapter.trouble.opacity(lueur.disturbance * 0.6)), lineWidth: 2)
            } else {
                let phase = fract(time * 2.2 + Double(lueur.sequence) * 0.3)
                context.stroke(circle(center, radius * (1.25 + 0.95 * phase)),
                               with: .color(DSColor.Chapter.trouble.opacity(min(0.85, lueur.disturbance * 1.2) * (1 - phase))), lineWidth: 2)
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
        glow.fill(circle(center, haloRadius), with: .radialGradient(Gradient(colors: [DSColor.Chapter.attention.opacity(haloOpacity), DSColor.Chapter.attention.opacity(0)]),
                                                                    center: center, startRadius: radius * 0.5, endRadius: haloRadius))
        // Ember body: dark when cold, amber as it warms, nacre core once lit.
        context.fill(circle(center, radius), with: .color(DSColor.Chapter.abyss))
        context.fill(circle(center, radius), with: .color(DSColor.Chapter.attentionDeep.opacity(0.35 + 0.65 * warmth)))
        let coreRadius = radius * (0.25 + 0.55 * warmth)
        let coreOpacity = max(0, (warmth - 0.3) / 0.7)
        context.fill(circle(center, coreRadius), with: .radialGradient(Gradient(colors: [DSColor.Chapter.lueurCore.opacity(coreOpacity), DSColor.Chapter.attention.opacity(coreOpacity * 0.6)]),
                                                                       center: center, startRadius: 0, endRadius: coreRadius))
        if lueur.isFlaring {
            context.stroke(circle(center, radius * (1.15 + 0.35 * flarePulse)), with: .color(DSColor.Chapter.lueurCore.opacity(0.5 + 0.4 * flarePulse)), lineWidth: 1.5)
        }
        context.stroke(circle(center, radius + 2.5 * radius / 20), with: .color(DSColor.Chapter.attention.opacity(0.35 + 0.45 * warmth)),
                       style: StrokeStyle(lineWidth: 1.4 * radius / 20, dash: lueur.isIrisOpen ? [] : [2.5 * radius / 20, 3.5 * radius / 20]))

        if sequential {
            let pip = radius * 0.11
            let spacing = radius * 0.36
            let startX = center.x - Double(lueur.sequence - 1) * spacing / 2
            for index in 0..<lueur.sequence {
                context.fill(circle(CGPoint(x: startX + Double(index) * spacing, y: center.y), pip), with: .color(DSColor.Chapter.ink.opacity(0.8)))
            }
        }

        if lueur.disturbance > 0.02 {
            if reduceMotion {
                context.stroke(circle(center, radius * 1.5), with: .color(DSColor.Chapter.trouble.opacity(lueur.disturbance * 0.6)), lineWidth: 2)
            } else {
                let phase = fract(time * 2.2 + Double(lueur.sequence) * 0.3)
                context.stroke(circle(center, radius * (1.25 + 0.95 * phase)),
                               with: .color(DSColor.Chapter.trouble.opacity(min(0.85, lueur.disturbance * 1.2) * (1 - phase))), lineWidth: 2)
            }
        }
    }

    // MARK: Balises (PROTOTYPE): the thread, each balise (asleep, designated, awake)

    private func drawBaliseThreads(_ snapshot: GameSceneSnapshot, in context: inout GraphicsContext, scale: Double) {
        for thread in snapshot.baliseThreads {
            let growth = min(1, thread.age / 0.35)
            let end = thread.from + (thread.to - thread.from) * growth
            var path = Path()
            path.move(to: CGPoint(x: thread.from.x, y: thread.from.y))
            path.addLine(to: CGPoint(x: end.x, y: end.y))
            let opacity = thread.isComplete ? 0.16 : 0.55
            context.stroke(path, with: .color(DSColor.Chapter.attention.opacity(opacity)),
                           style: StrokeStyle(lineWidth: (thread.isComplete ? 1 : 1.6) * scale, lineCap: .round, dash: thread.isComplete ? [2 * scale, 6 * scale] : []))
        }
    }

    private func drawBalise(_ balise: BaliseSnapshot, time: TimeInterval, in context: inout GraphicsContext, scale: Double, reduceMotion: Bool) {
        let center = CGPoint(x: balise.position.x, y: balise.position.y)
        let ring = 7 * scale
        if balise.isActive {
            context.stroke(circle(center, balise.radius), with: .color(DSColor.Chapter.attention.opacity(0.1)),
                           style: StrokeStyle(lineWidth: 1 * scale, dash: [2 * scale, 7 * scale]))
            let breath = reduceMotion ? 1 : 1 + 0.18 * sin(time * 3.2)
            var glow = context
            glow.blendMode = .plusLighter
            glow.fill(circle(center, 30 * scale * breath), with: .radialGradient(Gradient(colors: [DSColor.Chapter.attention.opacity(0.32), DSColor.Chapter.attention.opacity(0)]),
                                                                                  center: center, startRadius: ring * 0.5, endRadius: 30 * scale * breath))
            context.stroke(circle(center, ring * 1.9 * breath), with: .color(DSColor.Chapter.attention.opacity(0.7)), lineWidth: 1.4 * scale)
        }
        let fresh = balise.litAge.map { max(0, 1 - $0 / 1.2) } ?? 0
        if balise.isLit {
            var glow = context
            glow.blendMode = .plusLighter
            glow.fill(circle(center, ring * (2.2 + 2.5 * fresh)), with: .radialGradient(Gradient(colors: [DSColor.Chapter.lueurGlow.opacity(0.18 + 0.5 * fresh), DSColor.Chapter.lueurGlow.opacity(0)]),
                                                                                          center: center, startRadius: 0, endRadius: ring * (2.2 + 2.5 * fresh)))
            context.fill(circle(center, ring * 0.7), with: .color(DSColor.Chapter.lueurCore.opacity(0.7 + 0.3 * fresh)))
            context.stroke(circle(center, ring), with: .color(DSColor.Chapter.attention.opacity(0.8)), lineWidth: 1.4 * scale)
        } else {
            context.stroke(circle(center, ring), with: .color(DSColor.Chapter.cendre.opacity(balise.isActive ? 0.9 : 0.5)), lineWidth: 1.2 * scale)
            context.fill(circle(center, 1.8 * scale), with: .color(DSColor.Chapter.cendre.opacity(0.7)))
        }
    }

    // MARK: Developer diagnostics (DEBUG only)

    #if DEBUG
    private func drawDiagnostics(_ diagnostics: GazeDiagnostics, in context: inout GraphicsContext) {
        if let raw = diagnostics.raw {
            context.stroke(circle(CGPoint(x: raw.x, y: raw.y), 7), with: .color(DSColor.Chapter.trouble.opacity(0.8)), lineWidth: 1.5)
        }
        if let calibrated = diagnostics.calibrated {
            context.fill(circle(CGPoint(x: calibrated.x, y: calibrated.y), 4), with: .color(DSColor.Chapter.success.opacity(0.9)))
        }
        if let edge = diagnostics.edge {
            drawEdgeIndicator(edge, in: &context)
        }
    }

    /// PROTOTYPE DEBUG: a chevron on the edge of the last observable direction. It complements the historical warning
    /// and never claims to know where the gaze is beyond the screen.
    private func drawEdgeIndicator(_ edge: GazeDiagnostics.Edge, in context: inout GraphicsContext) {
        let bounds = context.clipBoundingRect
        let size: CGFloat = 12
        let inset: CGFloat = 10
        var chevron = Path()
        switch edge {
        case .right:
            let tip = CGPoint(x: bounds.maxX - inset, y: bounds.midY)
            chevron.move(to: CGPoint(x: tip.x - size, y: tip.y - size))
            chevron.addLine(to: tip)
            chevron.addLine(to: CGPoint(x: tip.x - size, y: tip.y + size))
        case .left:
            let tip = CGPoint(x: bounds.minX + inset, y: bounds.midY)
            chevron.move(to: CGPoint(x: tip.x + size, y: tip.y - size))
            chevron.addLine(to: tip)
            chevron.addLine(to: CGPoint(x: tip.x + size, y: tip.y + size))
        case .top:
            let tip = CGPoint(x: bounds.midX, y: bounds.minY + inset)
            chevron.move(to: CGPoint(x: tip.x - size, y: tip.y + size))
            chevron.addLine(to: tip)
            chevron.addLine(to: CGPoint(x: tip.x + size, y: tip.y + size))
        case .bottom:
            let tip = CGPoint(x: bounds.midX, y: bounds.maxY - inset)
            chevron.move(to: CGPoint(x: tip.x - size, y: tip.y - size))
            chevron.addLine(to: tip)
            chevron.addLine(to: CGPoint(x: tip.x + size, y: tip.y - size))
        }
        context.stroke(chevron, with: .color(DSColor.Chapter.trouble.opacity(0.85)), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
    }
    #endif

    /// The gaze marker: where Iris estimates the player is looking. Soft on purpose — it is an estimate, not a
    /// surgical crosshair — and it fades with the opacity the policy asked for.
    private func drawCursor(at gaze: Vector2, opacity: Double, in context: inout GraphicsContext) {
        let center = CGPoint(x: gaze.x, y: gaze.y)
        context.stroke(circle(center, 14), with: .color(DSColor.Chapter.attention.opacity(0.7 * opacity)), lineWidth: 1.5)
        context.fill(circle(center, 2), with: .color(DSColor.Chapter.attention.opacity(opacity)))
    }

    /// A halo on the edge the gaze left by. It says a side, never a distance: beyond the mapper's own clamp the
    /// intensity saturates, because nothing downstream knows any more than that.
    private func drawEdgeHalo(_ guidance: GazeEdgeGuidance, in context: inout GraphicsContext) {
        let bounds = context.clipBoundingRect
        let reach = min(bounds.width, bounds.height) * 0.42
        let strength = 0.16 + 0.34 * guidance.intensity
        let anchor = Self.haloAnchor(guidance.direction, in: bounds)
        let glow = Path(ellipseIn: CGRect(x: anchor.x - reach, y: anchor.y - reach, width: reach * 2, height: reach * 2))
        context.fill(glow, with: .radialGradient(
            Gradient(colors: [DSColor.Chapter.attention.opacity(strength), DSColor.Chapter.attention.opacity(0)]),
            center: anchor, startRadius: 0, endRadius: reach))
    }

    /// Where the halo sits: the middle of a side, or the corner itself.
    static func haloAnchor(_ direction: GazeEdgeGuidance.Direction, in bounds: CGRect) -> CGPoint {
        switch direction {
        case .left: CGPoint(x: bounds.minX, y: bounds.midY)
        case .right: CGPoint(x: bounds.maxX, y: bounds.midY)
        case .top: CGPoint(x: bounds.midX, y: bounds.minY)
        case .bottom: CGPoint(x: bounds.midX, y: bounds.maxY)
        case .topLeft: CGPoint(x: bounds.minX, y: bounds.minY)
        case .topRight: CGPoint(x: bounds.maxX, y: bounds.minY)
        case .bottomLeft: CGPoint(x: bounds.minX, y: bounds.maxY)
        case .bottomRight: CGPoint(x: bounds.maxX, y: bounds.maxY)
        }
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
