// CampaignBot.swift
// Layer: Tests
// Purpose: Simulated players used to prove each level feasible (guided) and each element necessary (limited policies);
// the guided player also feeds braises (EXPERIMENTAL prototype B1), the avoidance player never does

import Foundation
@testable import Iris

struct CampaignBot {
    enum Policy: String, CaseIterable {
        /// Avoids lueurs, follows the designer routes by pushing, looks at weak veilleuses.
        case guided
        /// Only avoids lueurs: never pushes, never looks at veilleuses.
        case avoidance
        /// Guided but blind to veilleuses.
        case ignoresVeilleuses
        /// Looks above the phone the whole time.
        case offScreen
    }

    struct Result: Hashable {
        let completed: Bool
        let time: TimeInterval
        let intrusions: Int
        let losses: Int
    }

    static let referenceBounds = PlayfieldBounds(width: 393, height: 852)

    let definition: LevelDefinition
    let bounds: PlayfieldBounds
    let policy: Policy
    let gazeNoise: Double
    let seed: Int

    init(definition: LevelDefinition, bounds: PlayfieldBounds = CampaignBot.referenceBounds, policy: Policy,
         gazeNoise: Double = 24, seed: Int = 1) {
        self.definition = definition
        self.bounds = bounds
        self.policy = policy
        self.gazeNoise = gazeNoise
        self.seed = seed
    }

    func run(maxSeconds: Double = 90) -> Result {
        let resolved = LevelResolver.resolve(definition, in: bounds)
        var session = resolved.makeSession()
        var brain = Brain(resolved: resolved, policy: policy, gazeNoise: gazeNoise, seed: seed)
        let frame = 1.0 / 60.0
        let frames = Int(maxSeconds * 60)
        for index in 0..<frames {
            if index % 6 == 0 { brain.decide(session: session) }
            session.ingestGaze(brain.gazeSample())
            _ = session.advance(by: frame)
            if session.isComplete {
                return Result(completed: true, time: session.elapsed, intrusions: session.metrics.intrusions, losses: session.metrics.losses)
            }
        }
        return Result(completed: false, time: session.elapsed, intrusions: session.metrics.intrusions, losses: session.metrics.losses)
    }
}

private struct Brain {
    let resolved: ResolvedLevel
    let policy: CampaignBot.Policy
    let gazeNoise: Double
    var generator: LinearCongruentialGenerator
    var aim: Vector2
    var jitter = Vector2.zero
    var routeIndex: [Int]
    var servingVeilleuse: Int?

    init(resolved: ResolvedLevel, policy: CampaignBot.Policy, gazeNoise: Double, seed: Int) {
        self.resolved = resolved
        self.policy = policy
        self.gazeNoise = gazeNoise
        self.generator = LinearCongruentialGenerator(seed: 4242 + seed * 7919)
        self.aim = resolved.bounds.center
        self.routeIndex = Array(repeating: 0, count: resolved.level.targets.count)
    }

    mutating func gazeSample() -> Vector2 {
        aim + jitter
    }

    mutating func decide(session: GameSession) {
        let target = Vector2(x: (generator.next() * 2 - 1) * gazeNoise, y: (generator.next() * 2 - 1) * gazeNoise)
        jitter = jitter * 0.5 + target * 0.5
        let bounds = resolved.bounds
        if policy == .offScreen {
            aim = Vector2(x: bounds.width / 2, y: -bounds.height * 0.6)
            return
        }
        advanceRoutes(session: session)
        if policy == .guided, let flame = veilleuseToServe(session: session) {
            aim = session.veilleuses[flame].position
            return
        }
        if policy == .guided || policy == .ignoresVeilleuses, let feed = feedAim(session: session) {
            aim = feed
            return
        }
        if policy == .guided || policy == .ignoresVeilleuses, let push = pushAim(session: session) {
            aim = push
            return
        }
        aim = avoidanceAim(session: session)
    }

    private mutating func advanceRoutes(session: GameSession) {
        let reach = min(resolved.bounds.width, resolved.bounds.height) * 0.08
        for index in session.targets.indices {
            let route = resolved.routes[index]
            let target = session.targets[index]
            if target.isValidated {
                routeIndex[index] = route.count
                continue
            }
            while routeIndex[index] < route.count && target.position.distance(to: route[routeIndex[index]]) < reach {
                routeIndex[index] += 1
            }
        }
    }

    private mutating func veilleuseToServe(session: GameSession) -> Int? {
        let flames = session.veilleuses
        if let serving = servingVeilleuse {
            if flames[serving].charge < 0.97 { return serving }
            servingVeilleuse = nil
        }
        if let weakest = flames.indices.min(by: { flames[$0].charge < flames[$1].charge }), flames[weakest].charge < 0.42 {
            servingVeilleuse = weakest
            return weakest
        }
        return nil
    }

    /// EXPERIMENTAL: warms any sleeping braise as soon as possible (waking validates nothing, the engine keeps the order),
    /// looking just beyond it on the side away from its iris, so that the flight it provokes helps; stops once the
    /// braise is warm enough, feeds again only if it nearly sleeps.
    private func feedAim(session: GameSession) -> Vector2? {
        let targets = session.targets
        for index in targets.indices {
            guard let braise = session.braises[index] else { continue }
            let target = targets[index]
            if target.isValidated { continue }
            let wanted = braise.isLit ? 0.45 : 0.75
            if braise.heat >= wanted { continue }
            let away = target.position - target.arrival
            let length = away.length
            let direction = length > 1e-6 ? away / length : Vector2(x: 0, y: 1)
            let raw = target.position + direction * (braise.chargeRadius * 0.45)
            return Vector2(x: min(max(raw.x, 4), resolved.bounds.width - 4), y: min(max(raw.y, 4), resolved.bounds.height - 4))
        }
        return nil
    }

    private func pushAim(session: GameSession) -> Vector2? {
        let targets = session.targets
        let candidates = targets.indices.filter { routeIndex[$0] < resolved.routes[$0].count && !targets[$0].isValidated }
        guard let index = candidates.min(by: { targets[$0].sequence < targets[$1].sequence }) else { return nil }
        let target = targets[index]
        let waypoint = resolved.routes[index][routeIndex[index]]
        let delta = waypoint - target.position
        let length = delta.length
        guard length > 1e-6 else { return nil }
        let direction = delta / length
        let raw = target.position - direction * (target.attentionZone * 0.35)
        return Vector2(x: min(max(raw.x, 4), resolved.bounds.width - 4), y: min(max(raw.y, 4), resolved.bounds.height - 4))
    }

    private func avoidanceAim(session: GameSession) -> Vector2 {
        let bounds = resolved.bounds
        func score(_ point: Vector2) -> Double {
            var best = Double.infinity
            for target in session.targets {
                let weight = target.isValidated || target.isHolding ? 1.15 : 1.0
                best = min(best, point.distance(to: target.position) - target.attentionZone * weight)
                if !target.isValidated {
                    best = min(best, point.distance(to: target.arrival) - target.attentionZone * 0.9)
                }
            }
            return best
        }
        var bestPoint = aim
        var bestScore = -Double.infinity
        for column in 0...12 {
            for row in 0...26 {
                let point = Vector2(x: bounds.width * (0.04 + 0.92 * Double(column) / 12),
                                    y: bounds.height * (0.04 + 0.92 * Double(row) / 26))
                let value = score(point)
                if value > bestScore {
                    bestScore = value
                    bestPoint = point
                }
            }
        }
        let onField = aim.x >= 0 && aim.x <= bounds.width && aim.y >= 0 && aim.y <= bounds.height
        if onField && score(aim) >= bestScore - 10 { return aim }
        return bestPoint
    }
}
