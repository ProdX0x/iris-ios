// GameSceneRenderer.swift
// Layer: Presentation
// Purpose: Port of the reference engine's `draw()`: horizon, perspective floor, depth-scaled spheres, rings, shadows

import SwiftUI

struct GameSceneRenderer {
    private let constants: PhysicsConstants
    private let horizonRatio: CGFloat = 0.38

    init(constants: PhysicsConstants = .reference) {
        self.constants = constants
    }

    func draw(_ snapshot: GameSceneSnapshot, in context: inout GraphicsContext, size: CGSize) {
        let horizonY = size.height * horizonRatio
        drawBackdrop(in: &context, size: size, horizonY: horizonY)
        for target in snapshot.targets {
            drawArrival(target, sequential: snapshot.isSequential, in: &context, size: size, horizonY: horizonY)
            drawSphere(target, sequential: snapshot.isSequential, in: &context, size: size, horizonY: horizonY)
        }
        if let diagnostics = snapshot.diagnostics {
            drawDiagnostics(diagnostics, in: &context)
        }
        if let gaze = snapshot.gaze {
            drawGaze(at: gaze, in: &context)
        }
    }

    // MARK: Backdrop

    private func drawBackdrop(in context: inout GraphicsContext, size: CGSize, horizonY: CGFloat) {
        let sky = CGRect(x: 0, y: 0, width: size.width, height: horizonY)
        context.fill(Path(sky), with: .linearGradient(Gradient(colors: [DSColor.sceneSkyTop, DSColor.sceneSkyHorizon]),
                                                      startPoint: .zero, endPoint: CGPoint(x: 0, y: horizonY)))
        let floor = CGRect(x: 0, y: horizonY, width: size.width, height: size.height - horizonY)
        context.fill(Path(floor), with: .linearGradient(Gradient(colors: [DSColor.sceneFloorNear, DSColor.sceneFloorFar]),
                                                        startPoint: CGPoint(x: 0, y: horizonY), endPoint: CGPoint(x: 0, y: size.height)))
        var lines = Path()
        let vanishX = size.width / 2
        for index in -4...4 {
            lines.move(to: CGPoint(x: vanishX, y: horizonY))
            lines.addLine(to: CGPoint(x: vanishX + CGFloat(index) * size.width * 0.18, y: size.height))
        }
        context.stroke(lines, with: .color(DSColor.sceneRing.opacity(0.05)), lineWidth: 1)
    }

    // MARK: Depth

    /// Higher on screen means farther away: scale 0.55 at the horizon, 1.2 at the bottom edge.
    private func depthScale(y: CGFloat, size: CGSize, horizonY: CGFloat) -> CGFloat {
        let depth = min(max((y - horizonY) / (size.height - horizonY), 0), 1)
        return 0.55 + depth * 0.65
    }

    // MARK: Arrival ring

    private func drawArrival(_ target: SceneTargetSnapshot, sequential: Bool, in context: inout GraphicsContext, size: CGSize, horizonY: CGFloat) {
        let center = CGPoint(x: target.arrival.x, y: target.arrival.y)
        let radius = constants.arrivalRadius * depthScale(y: center.y, size: size, horizonY: horizonY)
        let flatten = CGAffineTransform(translationX: center.x, y: center.y).scaledBy(x: 1, y: 0.4)

        if target.progress > 0 {
            var arc = Path()
            arc.addArc(center: .zero, radius: radius, startAngle: .degrees(-90),
                       endAngle: .degrees(-90 + target.progress * 360), clockwise: false)
            context.stroke(arc.applying(flatten), with: .color(DSColor.statusSuccess), lineWidth: 2.5)
        }
        let ring = Path(ellipseIn: CGRect(x: -radius, y: -radius, width: radius * 2, height: radius * 2)).applying(flatten)
        context.stroke(ring, with: .color(DSColor.sceneRing.opacity(0.12)), lineWidth: 1)

        guard sequential else { return }
        let sequenceColor = DSColor.sequence(target.sequence)
        context.stroke(circle(center: center, radius: radius + 6), with: .color(sequenceColor.opacity(0.8)), lineWidth: 3)
        context.draw(Text(String(target.sequence)).font(.system(size: 11, weight: .semibold)).foregroundStyle(sequenceColor),
                     at: CGPoint(x: center.x, y: center.y - radius - 12), anchor: .center)
    }

    // MARK: Sphere

    private func drawSphere(_ target: SceneTargetSnapshot, sequential: Bool, in context: inout GraphicsContext, size: CGSize, horizonY: CGFloat) {
        let center = CGPoint(x: target.position.x, y: target.position.y)
        let scale = depthScale(y: center.y, size: size, horizonY: horizonY)
        let radius = constants.targetRadius * scale

        let shadowRadius = radius * 0.9
        let shadow = Path(ellipseIn: CGRect(x: center.x - shadowRadius, y: center.y + shadowRadius - shadowRadius * 0.35,
                                            width: shadowRadius * 2, height: shadowRadius * 0.7))
        context.fill(shadow, with: .color(DSColor.sceneShadow.opacity(0.4)))

        let light = target.isValidated ? DSColor.sceneSphereValidatedLight : DSColor.sceneSphereLight
        let dark = target.isValidated ? DSColor.sceneSphereValidatedDark : DSColor.sceneSphereDark
        let highlight = CGPoint(x: center.x - radius * 0.35, y: center.y - radius * 0.35)
        context.fill(circle(center: center, radius: radius),
                     with: .radialGradient(Gradient(colors: [light, dark]), center: highlight,
                                           startRadius: radius * 0.1, endRadius: radius * 1.35))

        if target.speed > 0.3 {
            context.stroke(circle(center: center, radius: radius + 4 + target.speed * 2),
                           with: .color(DSColor.statusDanger.opacity(min(0.5, target.speed * 0.15))), lineWidth: 2)
        }

        guard sequential else { return }
        context.stroke(circle(center: center, radius: radius + 5), with: .color(DSColor.sequence(target.sequence)), lineWidth: 3)
        context.draw(Text(String(target.sequence)).font(.system(size: 12, weight: .semibold)).foregroundStyle(DSColor.sceneLabel),
                     at: center, anchor: .center)
    }

    // MARK: Gaze indicators (diagnostic mode)

    /// Smoothed cursor used by the physics: amber ring.
    private func drawGaze(at gaze: Vector2, in context: inout GraphicsContext) {
        let center = CGPoint(x: gaze.x, y: gaze.y)
        context.stroke(circle(center: center, radius: 14), with: .color(DSColor.accent.opacity(0.7)), lineWidth: 1.5)
        context.fill(circle(center: center, radius: 2), with: .color(DSColor.accent))
    }

    /// Raw uncalibrated position: small coral ring. Calibrated unfiltered position: mint dot.
    private func drawDiagnostics(_ diagnostics: GazeDiagnostics, in context: inout GraphicsContext) {
        if let raw = diagnostics.raw {
            context.stroke(circle(center: CGPoint(x: raw.x, y: raw.y), radius: 7), with: .color(DSColor.statusDanger.opacity(0.8)), lineWidth: 1.5)
        }
        if let calibrated = diagnostics.calibrated {
            context.fill(circle(center: CGPoint(x: calibrated.x, y: calibrated.y), radius: 4), with: .color(DSColor.statusSuccess.opacity(0.9)))
        }
    }

    private func circle(center: CGPoint, radius: CGFloat) -> Path {
        Path(ellipseIn: CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2))
    }
}
