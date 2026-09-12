// HistoricalCampaignDump.swift
// Layer: Tests
// Purpose: Canonical text of the 34 historical levels: every authored field, their resolution on the reference phone,
// and a scripted 8 s simulation trace; compared byte for byte to Fixtures/historical_campaign.txt

import Foundation
@testable import Iris

enum HistoricalCampaignDump {
    static let bounds = PlayfieldBounds(width: 393, height: 852)
    static let traceFrames = 480
    static let sampleEvery = 30

    static func render() -> String {
        var lines = ["historical campaign fingerprint v1 (reference phone 393 x 852, 60 Hz, scripted gaze)"]
        for chapter in Campaign.historicalChapters {
            lines.append("chapter \(chapter.number) \(chapter.numeral) name=\(chapter.name) principle=\(chapter.principle) "
                + "ambient=\(f(chapter.ambientFrequency)) theme=\(chapter.theme.rawValue) levels=\(chapter.levels.map(\.id).joined(separator: ","))")
        }
        for level in Campaign.historicalLevels {
            lines += describe(level)
            lines += describeResolved(level)
            lines += trace(level)
        }
        return lines.joined(separator: "\n") + "\n"
    }

    // MARK: Authored definition

    private static func describe(_ level: LevelDefinition) -> [String] {
        var lines = ["level \(level.id) title=\(level.title) principle=\(level.principle) introduces=\(level.introduces.map(\.rawValue).joined(separator: ","))"
            + " ordered=\(level.ordered) zone=\(f(level.zone)) force=\(f(level.repulsionForce)) attraction=\(f(level.attraction)) noise=\(f(level.noise)) hold=\(f(level.hold))"
            + " par=\(f(level.par.time))/\(level.par.intrusions) kinds=\(level.elementKinds.map(\.rawValue).sorted().joined(separator: ","))"
            + " temperaments=\(level.hasTemperaments) braises=\(level.hasBraises) pushing=\(level.requiresPushing) experimental=\(level.isExperimental)"]
        for (index, lueur) in level.lueurs.enumerated() {
            lines.append("  lueur \(index + 1) start=\(p(lueur.start)) iris=\(p(lueur.iris)) temperament=\(lueur.temperament.rawValue)"
                + " motion=\(motion(lueur.irisMotion)) route=\(lueur.route.map(p).joined(separator: ";")) braise=\(lueur.braise == nil ? "nil" : "SET")")
        }
        for current in level.currents {
            lines.append("  current area=\(f(current.area.minX)),\(f(current.area.minY)),\(f(current.area.maxX)),\(f(current.area.maxY))"
                + " direction=\(v(current.direction)) strength=\(f(current.strength))")
        }
        for veil in level.veils {
            lines.append("  veil a=\(p(veil.a)) b=\(p(veil.b))")
        }
        for flame in level.veilleuses {
            lines.append("  veilleuse position=\(p(flame.position)) look=\(f(flame.lookRadius)) decay=\(f(flame.decay)) recharge=\(f(flame.recharge))"
                + " initial=\(f(flame.initialCharge)) linked=\(flame.linked.map(String.init).joined(separator: ","))")
        }
        for hint in level.hints {
            lines.append("  hint \(String(describing: hint.trigger)) text=\(hint.text)")
        }
        return lines
    }

    // MARK: Resolution

    private static func describeResolved(_ level: LevelDefinition) -> [String] {
        let resolved = LevelResolver.resolve(level, in: bounds)
        let physics = resolved.physics
        var lines = ["  resolved scale=\(f(resolved.scale)) radius=\(f(physics.targetRadius)) arrival=\(f(physics.arrivalRadius)) maxSpeed=\(f(physics.maxSpeed))"
            + " edge=\(f(physics.edgeMargin)) friction=\(f(physics.friction)) bounce=\(f(physics.bounceLoss)) settle=\(f(resolved.validation.settleRadius))"
            + " wobble=\(f(resolved.validation.wobbleMargin)) jump=\(f(resolved.gazeJumpThreshold)) hold=\(f(resolved.level.holdDuration)) sequential=\(resolved.level.isSequential)"]
        for target in resolved.level.targets {
            lines.append("  target \(target.sequence) start=\(p(target.start)) arrival=\(p(target.arrival)) zone=\(f(target.attentionZone))"
                + " gain=\(f(target.repulsionGain)) attraction=\(f(target.passiveAttraction)) noise=\(f(target.noiseAmplitude))")
        }
        let environment = resolved.environment
        lines.append("  environment attention=\(environment.requiresAttentionOnField) tolerance=\(f(environment.fieldTolerance))"
            + " radii=\(environment.lueurRadii.map(f).joined(separator: ",")) braises=\(environment.braises.count)")
        for current in environment.currents {
            lines.append("  field \(f(current.minX)),\(f(current.minY)),\(f(current.maxX)),\(f(current.maxY)) impulse=\(v(current.impulse))")
        }
        for veil in environment.veils {
            lines.append("  segment a=\(v(veil.a)) b=\(v(veil.b)) half=\(f(veil.halfThickness))")
        }
        for flame in environment.veilleuses {
            lines.append("  flame position=\(v(flame.position)) look=\(f(flame.lookRadius)) decay=\(f(flame.decay)) recharge=\(f(flame.recharge))"
                + " charge=\(f(flame.charge)) linked=\(flame.linked.map(String.init).joined(separator: ","))")
        }
        for index in environment.irisPaths.keys.sorted() {
            guard let path = environment.irisPaths[index] else { continue }
            lines.append("  path \(index) from=\(v(path.from)) to=\(v(path.to)) period=\(f(path.period))")
        }
        for (index, route) in resolved.routes.enumerated() where !route.isEmpty {
            lines.append("  route \(index) \(route.map(v).joined(separator: ";"))")
        }
        return lines
    }

    // MARK: Scripted simulation

    /// A gaze wandering over the field (two sines seeded by the level ids), off the screen between 3 s and 3.5 s.
    static func scriptedGaze(frame: Int, level: LevelDefinition) -> Vector2 {
        if frame >= 180 && frame < 210 { return Vector2(x: bounds.width / 2, y: -220) }
        let t = Double(frame) / 60
        return Vector2(x: bounds.width * (0.5 + 0.38 * sin(0.9 * t + Double(level.index))),
                       y: bounds.height * (0.5 + 0.4 * sin(0.6 * t + 1.7 * Double(level.chapter))))
    }

    private static func trace(_ level: LevelDefinition) -> [String] {
        var session = LevelResolver.resolve(level, in: bounds).makeSession()
        var counts: [String: Int] = [:]
        var lines: [String] = []
        for frame in 0..<traceFrames {
            session.ingestGaze(scriptedGaze(frame: frame, level: level))
            let events = session.advance(by: 1.0 / 60.0)
            for event in events {
                counts[kind(of: event), default: 0] += 1
            }
            if frame % sampleEvery == sampleEvery - 1 {
                let targets = session.targets.map { target in
                    "\(v(target.position)) v=\(v(target.velocity)) a=\(v(target.arrival)) hold=\(f(target.holdTime)) ok=\(target.isValidated)"
                }.joined(separator: " | ")
                let flames = session.veilleuses.map { f($0.charge) }.joined(separator: ",")
                lines.append("  t=\(frame + 1) attention=\(session.isAttentionOnField) complete=\(session.isComplete) \(targets) flames=\(flames)")
            }
            if session.isComplete { break }
        }
        let summary = counts.keys.sorted().map { "\($0)=\(counts[$0] ?? 0)" }.joined(separator: ",")
        lines.append("  events \(summary) intrusions=\(session.metrics.intrusions) losses=\(session.metrics.losses) exits=\(session.metrics.attentionExits) elapsed=\(f(session.elapsed))")
        return lines
    }

    private static func kind(of event: GameEvent) -> String {
        switch event {
        case .validationProgressed: "progress"
        case .validationProgressStopped: "stop"
        case .targetValidated: "validated"
        case let .targetLost(_, cause): "lost.\(cause)"
        case .levelCompleted: "completed"
        case .intrusion: "intrusion"
        case .attentionLeftField: "left"
        case .attentionReturned: "returned"
        case .veilleuseLow: "low"
        case .veilleuseOut: "out"
        case .veilleuseRelit: "relit"
        case .braiseLit: "braiseLit"
        case .braiseCooled: "braiseCooled"
        case .braiseFlared: "braiseFlared"
        }
    }

    // MARK: Formatting

    private static func f(_ value: Double) -> String {
        String(format: "%.10g", value)
    }

    private static func p(_ point: NormalizedPoint) -> String {
        "(\(f(point.x)),\(f(point.y)))"
    }

    private static func v(_ vector: Vector2) -> String {
        "(\(f(vector.x)),\(f(vector.y)))"
    }

    private static func motion(_ motion: IrisMotion) -> String {
        switch motion {
        case .fixed: "fixed"
        case let .oscillate(to, period): "oscillate(\(p(to)),\(f(period)))"
        }
    }
}
