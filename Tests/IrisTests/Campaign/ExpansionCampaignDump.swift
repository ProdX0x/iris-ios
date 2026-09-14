// ExpansionCampaignDump.swift
// Layer: Tests
// Purpose: Canonical text of the human-validated chapters VII to XII and of chapter I level 6 (every authored field,
// resolution on the reference phone, scripted 8 s trace); compared byte for byte to Fixtures/expansion_campaign.txt

import Foundation
@testable import Iris

enum ExpansionCampaignDump {
    static let bounds = PlayfieldBounds(width: 393, height: 852)

    /// The validated levels this dump protects: chapter I level 6 and every level of chapters VII to XII.
    static var protectedLevels: [LevelDefinition] {
        [Campaign.oculomoteur] + Campaign.expansionChapters.flatMap(\.levels)
    }

    static func render() -> String {
        var lines = ["expansion campaign fingerprint v1 (reference phone 393 x 852, 60 Hz, scripted gaze)"]
        for chapter in Campaign.expansionChapters {
            lines.append("chapter \(chapter.number) \(chapter.numeral) name=\(chapter.name) principle=\(chapter.principle) "
                + "ambient=\(f(chapter.ambientFrequency)) theme=\(chapter.theme.rawValue) levels=\(chapter.levels.map(\.id).joined(separator: ","))")
        }
        for level in protectedLevels {
            lines += describe(level)
            lines += describeResolved(level)
            lines += trace(level)
        }
        return lines.joined(separator: "\n") + "\n"
    }

    private static func describe(_ level: LevelDefinition) -> [String] {
        var lines = ["level \(level.id) title=\(level.title) principle=\(level.principle) introduces=\(level.introduces.map(\.rawValue).joined(separator: ","))"
            + " ordered=\(level.ordered) zone=\(f(level.zone)) force=\(f(level.repulsionForce)) attraction=\(f(level.attraction)) noise=\(f(level.noise)) hold=\(f(level.hold))"
            + " par=\(f(level.par.time))/\(level.par.intrusions) kinds=\(level.elementKinds.map(\.rawValue).sorted().joined(separator: ","))"
            + " gates=\(level.gatesProgression)"]
        for (index, lueur) in level.lueurs.enumerated() {
            lines.append("  lueur \(index + 1) start=\(p(lueur.start)) iris=\(p(lueur.iris)) temperament=\(lueur.temperament.rawValue)"
                + " motion=\(String(describing: lueur.irisMotion)) route=\(lueur.route.map(p).joined(separator: ";"))"
                + " braise=\(lueur.braise.map { String(describing: $0) } ?? "nil") twin=\(lueur.twin.map(String.init) ?? "nil") asleep=\(lueur.asleep)")
        }
        for current in level.currents {
            lines.append("  current area=\(f(current.area.minX)),\(f(current.area.minY)),\(f(current.area.maxX)),\(f(current.area.maxY)) direction=\(v(current.direction)) strength=\(f(current.strength))")
        }
        for veil in level.veils { lines.append("  veil a=\(p(veil.a)) b=\(p(veil.b))") }
        for flame in level.veilleuses {
            lines.append("  veilleuse position=\(p(flame.position)) look=\(f(flame.lookRadius)) decay=\(f(flame.decay)) recharge=\(f(flame.recharge)) initial=\(f(flame.initialCharge)) linked=\(flame.linked.map(String.init).joined(separator: ","))")
        }
        for souffle in level.souffles {
            lines.append("  souffle path=\(souffle.path.map(p).joined(separator: ";")) period=\(f(souffle.period)) duty=\(f(souffle.duty)) radius=\(f(souffle.radius)) strength=\(f(souffle.strength)) phase=\(f(souffle.phase))")
        }
        if let echo = level.echo {
            lines.append("  echo radius=\(f(echo.radius)) speed=\(f(echo.speed)) interval=\(f(echo.interval)) burst=\(f(echo.burst))")
        }
        for well in level.gouffres {
            lines.append("  gouffre center=\(p(well.center)) radius=\(f(well.radius)) pull=\(f(well.pull)) strength=\(f(well.strength))")
        }
        if let balises = level.balises {
            lines.append("  balises \(balises.balises.map { "\($0.name)@\(p($0.position))" }.joined(separator: ";")) steps=\(balises.steps.map(String.init).joined(separator: ","))"
                + " dwell=\(f(balises.dwell)) radius=\(f(balises.radius)) release=\(f(balises.releaseRadius))")
        }
        for hint in level.hints { lines.append("  hint \(String(describing: hint.trigger)) text=\(hint.text)") }
        return lines
    }

    private static func describeResolved(_ level: LevelDefinition) -> [String] {
        let resolved = LevelResolver.resolve(level, in: bounds)
        let environment = resolved.environment
        var lines = ["  resolved scale=\(f(resolved.scale)) targets=\(resolved.level.targets.count) sequential=\(resolved.level.isSequential)"
            + " twins=\(environment.twins.count) souffles=\(environment.souffles.count) sleepers=\(environment.sleepers.count) gouffres=\(environment.gouffres.count)"
            + " braises=\(environment.braises.count) balises=\(environment.balises?.steps.count ?? 0) echo=\(environment.echo.map { f($0.radius) } ?? "nil")"]
        for target in resolved.level.targets {
            lines.append("  target \(target.sequence) zone=\(f(target.attentionZone)) gain=\(f(target.repulsionGain)) attraction=\(f(target.passiveAttraction)) noise=\(f(target.noiseAmplitude))")
        }
        return lines
    }

    private static func trace(_ level: LevelDefinition) -> [String] {
        var session = LevelResolver.resolve(level, in: bounds).makeSession()
        var counts: [String: Int] = [:]
        var lines: [String] = []
        for frame in 0..<480 {
            session.ingestGaze(HistoricalCampaignDump.scriptedGaze(frame: frame, level: level))
            let events = session.advance(by: 1.0 / 60.0)
            for event in events { counts[String(describing: event).components(separatedBy: "(").first ?? "?", default: 0] += 1 }
            if frame % 60 == 59 {
                let targets = session.targets.map { "\(v($0.position)) hold=\(f($0.holdTime)) ok=\($0.isValidated)" }.joined(separator: " | ")
                lines.append("  t=\(frame + 1) complete=\(session.isComplete) \(targets)")
            }
            if session.isComplete { break }
        }
        let summary = counts.keys.sorted().map { "\($0)=\(counts[$0] ?? 0)" }.joined(separator: ",")
        lines.append("  events \(summary) intrusions=\(session.metrics.intrusions) losses=\(session.metrics.losses) elapsed=\(f(session.elapsed))")
        return lines
    }

    private static func f(_ value: Double) -> String { String(format: "%.10g", value) }
    private static func p(_ point: NormalizedPoint) -> String { "(\(f(point.x)),\(f(point.y)))" }
    private static func v(_ vector: Vector2) -> String { "(\(f(vector.x)),\(f(vector.y)))" }
}
