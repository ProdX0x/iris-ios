// LevelAnalysis.swift
// Layer: Tests
// Purpose: Static metrics of a level (free area, crossings, guard pressure) and the difficulty estimate

import Foundation
@testable import Iris

struct LevelAnalysis {
    let definition: LevelDefinition
    let bounds: PlayfieldBounds

    init(_ definition: LevelDefinition, bounds: PlayfieldBounds = CampaignBot.referenceBounds) {
        self.definition = definition
        self.bounds = bounds
    }

    private var zone: Double { definition.zone * min(bounds.width, bounds.height) }

    /// Share of the screen from which the gaze repels no lueur at start.
    var freeArea: Double {
        let starts = definition.lueurs.map { $0.start.absolute(in: bounds) }
        var free = 0
        var total = 0
        var x = 0.0
        while x < bounds.width {
            var y = 0.0
            while y < bounds.height {
                total += 1
                let point = Vector2(x: x, y: y)
                if starts.allSatisfy({ $0.distance(to: point) >= zone }) { free += 1 }
                y += 6
            }
            x += 6
        }
        return Double(free) / Double(max(total, 1))
    }

    var crossings: Int {
        let segments = definition.lueurs.map { ($0.start.absolute(in: bounds), $0.iris.absolute(in: bounds)) }
        var count = 0
        for i in segments.indices {
            for j in segments.indices where j > i {
                if Self.intersects(segments[i].0, segments[i].1, segments[j].0, segments[j].1) { count += 1 }
            }
        }
        return count
    }

    /// Irises lying within the attention zone of some point of another lueur's straight path.
    var guardPressure: Int {
        let lueurs = definition.lueurs
        var count = 0
        for (i, guarded) in lueurs.enumerated() {
            let iris = guarded.iris.absolute(in: bounds)
            let threatened = lueurs.enumerated().contains { j, other in
                guard j != i else { return false }
                let a = other.start.absolute(in: bounds)
                let b = other.iris.absolute(in: bounds)
                return VeilSegment(a: a, b: b, halfThickness: 0).distance(to: iris) < zone * 0.6
            }
            if threatened { count += 1 }
        }
        return count
    }

    func difficulty(botTime: Double) -> Double {
        var estimate = Double(definition.lueurs.count)
        estimate += 1.5 * (1 - freeArea)
        estimate += 0.6 * Double(crossings)
        estimate += 0.5 * Double(guardPressure)
        estimate += (definition.veils.isEmpty && definition.currents.isEmpty) ? 0 : 1
        estimate += Double(definition.veilleuses.count)
        estimate += 0.8 * Double(definition.lueurs.filter { $0.irisMotion.isMoving }.count)
        estimate += 0.5 * Double(definition.lueurs.filter(\.isTwin).count) / 2
        estimate += 0.8 * Double(definition.souffles.count)
        estimate += 0.6 * Double(definition.lueurs.filter(\.asleep).count)
        estimate += 0.7 * Double(definition.gouffres.count)
        estimate += 0.5 * Double(definition.lueurs.filter { $0.braise != nil }.count)
        estimate += 0.15 * Double(definition.balises?.steps.count ?? 0)
        estimate += 1.5 * Double(definition.oculo?.stages.count ?? 0)
        estimate += botTime / 20
        return estimate
    }

    static func intersects(_ p1: Vector2, _ p2: Vector2, _ p3: Vector2, _ p4: Vector2) -> Bool {
        func ccw(_ a: Vector2, _ b: Vector2, _ c: Vector2) -> Bool {
            (c.y - a.y) * (b.x - a.x) > (b.y - a.y) * (c.x - a.x)
        }
        return ccw(p1, p3, p4) != ccw(p2, p3, p4) && ccw(p1, p2, p3) != ccw(p1, p2, p4)
    }
}

extension LevelAnalysis {
    private var shortSide: Double { min(bounds.width, bounds.height) }

    /// Longest travel along start, waypoints and iris, in short-side units.
    var longestRoute: Double {
        definition.lueurs.map { lueur in
            let points = [lueur.start] + lueur.route + [lueur.iris]
            var length = 0.0
            for index in 1..<points.count {
                length += points[index].absolute(in: bounds).distance(to: points[index - 1].absolute(in: bounds))
            }
            return length / shortSide
        }.max() ?? 0
    }

    /// Largest total turning angle (degrees) along a lueur's intended path.
    var turning: Double {
        definition.lueurs.map { lueur in
            let points = ([lueur.start] + lueur.route + [lueur.iris]).map { $0.absolute(in: bounds) }
            guard points.count >= 3 else { return 0 }
            var total = 0.0
            for index in 1..<(points.count - 1) {
                let a = points[index] - points[index - 1]
                let b = points[index + 1] - points[index]
                let cosine = (a.x * b.x + a.y * b.y) / max(a.length * b.length, 1e-9)
                total += acos(min(max(cosine, -1), 1)) * 180 / .pi
            }
            return total
        }.max() ?? 0
    }

    var hasCentralIris: Bool {
        definition.lueurs.contains { $0.iris.absolute(in: bounds).distance(to: bounds.center) < shortSide * 0.15 }
    }

    var skills: Set<String> {
        var skills: Set<String> = []
        if !definition.requiresPushing { skills.insert("évitement") }
        if definition.requiresPushing && !definition.currents.isEmpty { skills.insert("pousser contre") }
        if definition.requiresPushing && !definition.veils.isEmpty { skills.insert("contourner") }
        if !definition.veilleuses.isEmpty { skills.insert("vigilance") }
        if definition.lueurs.contains(where: { $0.irisMotion.isMoving }) { skills.insert("anticiper") }
        if definition.hasTwins { skills.insert("réunir") }
        if !definition.souffles.isEmpty { skills.insert("porter") }
        if definition.hasSleepers { skills.insert("réveiller") }
        if !definition.gouffres.isEmpty { skills.insert("esquiver") }
        if definition.hasBraises { skills.insert("réveiller au regard") }
        if definition.hasBalises { skills.insert("fixer") }
        if let oculo = definition.oculo { skills.insert("oculo:\(oculo.element.rawValue)") }
        return skills
    }

    /// The criteria of LEVEL_DESIGN_SYSTEM.md section 7, as comparable values.
    func signature(botTime: Double) -> [String: String] {
        func band(_ value: Double, _ low: Double, _ high: Double) -> String {
            value < low ? "bas" : (value <= high ? "moyen" : "haut")
        }
        let kinds = definition.elementKinds.map(\.rawValue).sorted().joined(separator: "+")
        let temperaments = Set(definition.lueurs.map(\.temperament.rawValue)).sorted().joined(separator: "+")
        return [
            "lueurs": "\(definition.lueurs.count)",
            "éléments": kinds,
            "ordre": definition.ordered ? "ordonné" : "libre",
            "tempéraments": temperaments,
            "croisements": "\(crossings)",
            "garde": "\(guardPressure)",
            "compétences": skills.sorted().joined(separator: "+"),
            "temps": band(botTime, 6, 10),
            "instances": "\(definition.currents.count)-\(definition.veils.count)-\(definition.veilleuses.count)-\(definition.souffles.count)-\(definition.lueurs.filter(\.asleep).count)-\(definition.gouffres.count)-\(definition.lueurs.filter { $0.braise != nil }.count)",
            "détour": band(turning, 30, 120),
            "trajet": band(longestRoute, 1.0, 1.6),
            "iris central": hasCentralIris ? "oui" : "non",
            "espace libre": band(freeArea, 0.45, 0.65),
        ]
    }

    static func differences(_ lhs: [String: String], _ rhs: [String: String]) -> [String] {
        lhs.keys.sorted().filter { lhs[$0] != rhs[$0] }
    }
}
