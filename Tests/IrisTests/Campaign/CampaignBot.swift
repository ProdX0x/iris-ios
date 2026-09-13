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
        /// Chapter X: guided, but blind to the designer routes: pushes every lueur straight toward its iris.
        case straight
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

    /// `observe` (diagnostics) receives the session, the bot's aim and the tick's events after every frame.
    func run(maxSeconds: Double = 90, observe: ((GameSession, Vector2, [GameEvent]) -> Void)? = nil) -> Result {
        let resolved = LevelResolver.resolve(definition, in: bounds)
        var session = resolved.makeSession()
        var brain = Brain(resolved: resolved, policy: policy, gazeNoise: gazeNoise, seed: seed)
        let frame = 1.0 / 60.0
        let frames = Int(maxSeconds * 60)
        for index in 0..<frames {
            if index % 6 == 0 { brain.decide(session: session) }
            session.ingestGaze(brain.gazeSample())
            let events = session.advance(by: frame)
            observe?(session, brain.aim, events)
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
    /// Chapter VIII: where each gust track crosses a veil (the pickup point of the ferry), by gust index.
    let crossings: [(souffle: Int, veil: Int, point: Vector2, tangent: Vector2)]

    init(resolved: ResolvedLevel, policy: CampaignBot.Policy, gazeNoise: Double, seed: Int) {
        self.resolved = resolved
        self.policy = policy
        self.gazeNoise = gazeNoise
        self.generator = LinearCongruentialGenerator(seed: 4242 + seed * 7919)
        self.aim = resolved.bounds.center
        self.routeIndex = Array(repeating: 0, count: resolved.level.targets.count)
        var crossings: [(souffle: Int, veil: Int, point: Vector2, tangent: Vector2)] = []
        for (index, field) in resolved.environment.souffles.enumerated() {
            for segment in 1..<field.path.count {
                for (veilIndex, veil) in resolved.environment.veils.enumerated() {
                    if let point = Brain.intersection(field.path[segment - 1], field.path[segment], veil.a, veil.b) {
                        let along = veil.b - veil.a
                        let length = along.length
                        crossings.append((index, veilIndex, point, length > 1e-9 ? along / length : Vector2(x: 1, y: 0)))
                    }
                }
            }
        }
        self.crossings = crossings
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
        if policy == .guided || policy == .straight, let flame = veilleuseToServe(session: session) {
            aim = session.veilleuses[flame].position
            return
        }
        if policy == .guided || policy == .ignoresVeilleuses || policy == .straight, let feed = feedAim(session: session) {
            aim = feed
            return
        }
        if policy == .guided || policy == .ignoresVeilleuses || policy == .straight, let push = pushAim(session: session) {
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
            // Chapter VIII: a waypoint left behind a veil (the pickup spot, once the gust has carried the lueur over) is done.
            if !resolved.environment.souffles.isEmpty {
                while routeIndex[index] < route.count
                    && resolved.environment.veils.contains(where: { LevelAnalysis.intersects(target.position, route[routeIndex[index]], $0.a, $0.b) }) {
                    routeIndex[index] += 1
                }
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

    /// The first lueur (by rank) that needs the gaze, and where to put it: a carried lueur is left alone (the impatient
    /// player keeps staring beside it), a lueur walled off from its arrival waits for the ferry, otherwise the route is
    /// followed and an unlinked twin is pushed toward its partner.
    private func pushAim(session: GameSession) -> Vector2? {
        let targets = session.targets
        let ordered = targets.indices.filter { !targets[$0].isValidated }.sorted { targets[$0].sequence < targets[$1].sequence }
        for index in ordered {
            let target = targets[index]
            if session.isCarried(targetAt: index) { continue }
            // Chapter IX: a sleeper is brought within reach of another lueur's iris, then left to the echo.
            if session.isAsleep(targetAt: index) {
                if let aim = sleeperAim(session: session, index: index) { return aim }
                continue
            }
            if needsFerry(target) {
                if let aim = ferryAim(session: session, index: index) { return aim }
                continue
            }
            if let twin = session.twins[index], twin.isLinked { continue }
            if policy == .straight {
                // Blind to the routes: straight at the iris until close.
                if target.distanceToArrival > 60 { return pushPoint(from: target, toward: target.arrival, distance: target.attentionZone * 0.35) }
                continue
            }
            if routeIndex[index] < resolved.routes[index].count {
                return pushPoint(from: target, toward: resolved.routes[index][routeIndex[index]], distance: target.attentionZone * 0.35)
            }
            if let twin = session.twins[index], targets.indices.contains(twin.partner) {
                let partner = targets[twin.partner].position
                // Pointless through a veil: the partner will come over by the ferry.
                if resolved.environment.veils.contains(where: { LevelAnalysis.intersects(target.position, partner, $0.a, $0.b) }) { continue }
                return pushPoint(from: target, toward: partner, distance: target.attentionZone * 0.35)
            }
        }
        return nil
    }

    /// Gaze placed `distance` behind the lueur, on the side opposite to where it should go.
    private func pushPoint(from target: Target, toward waypoint: Vector2, distance: Double) -> Vector2? {
        let delta = waypoint - target.position
        let length = delta.length
        guard length > 1e-6 else { return nil }
        let raw = target.position - delta / length * distance
        return clamp(raw)
    }

    private func clamp(_ raw: Vector2) -> Vector2 {
        Vector2(x: min(max(raw.x, 4), resolved.bounds.width - 4), y: min(max(raw.y, 4), resolved.bounds.height - 4))
    }

    // MARK: Chapter IX: sleepers

    /// Pushes the sleeper toward the nearest iris of an awake lueur (asleep lueurs excluded) until it lies well inside
    /// the echo's reach; nil once it is there (the closing or breathing iris will wake it).
    private func sleeperAim(session: GameSession, index: Int) -> Vector2? {
        guard let echo = session.echo else { return nil }
        let target = session.targets[index]
        let sources = session.targets.indices.filter { $0 != index && !session.isAsleep(targetAt: $0) && session.twins[$0] == nil }
        guard let source = sources.min(by: { session.targets[$0].arrival.distance(to: target.position) < session.targets[$1].arrival.distance(to: target.position) }) else { return nil }
        let iris = session.targets[source].arrival
        let distance = target.position.distance(to: iris)
        guard distance > echo.radius * 0.72 else { return nil }
        return pushPoint(from: target, toward: iris, distance: target.attentionZone * 0.35)
    }

    // MARK: Chapter VIII: the ferry

    /// A veil lies between the lueur and its arrival, and gusts exist to carry it over.
    private func needsFerry(_ target: Target) -> Bool {
        !crossings.isEmpty && blockingVeil(target) != nil
    }

    /// The first veil crossed by the straight path from the lueur to its arrival.
    private func blockingVeil(_ target: Target) -> Int? {
        var best: (index: Int, distance: Double)?
        for (index, veil) in resolved.environment.veils.enumerated() {
            guard let point = Brain.intersection(target.position, target.arrival, veil.a, veil.b) else { continue }
            let distance = point.distance(to: target.position)
            if let current = best, distance >= current.distance { continue }
            best = (index, distance)
        }
        return best?.index
    }

    /// Waits for the nearest gust: shortly before its arrival at the crossing, brings the lueur closer, then holds the gaze
    /// far on the side the lueur slides toward, at the distance where the repulsion balances the slide, so that the lueur
    /// settles on the track without the gaze being beside it when the gust picks it up.
    private func ferryAim(session: GameSession, index: Int) -> Vector2? {
        let target = session.targets[index]
        guard let veilIndex = blockingVeil(target) else { return nil }
        let veil = resolved.environment.veils[veilIndex]
        // Nothing to do until the lueur has drifted against the veil by itself.
        guard veil.distance(to: target.position) < 60 else { return nil }
        let onThisVeil = crossings.filter { $0.veil == veilIndex }
        guard let crossing = onThisVeil.min(by: { $0.point.distance(to: target.position) < $1.point.distance(to: target.position) }) else { return nil }
        let field = resolved.environment.souffles[crossing.souffle]
        // The pickup spot: the crossing, offset to the lueur's side of the veil by the lueur's radius.
        var normal = Vector2(x: -crossing.tangent.y, y: crossing.tangent.x)
        let toLueur = target.position - crossing.point
        if toLueur.x * normal.x + toLueur.y * normal.y < 0 { normal = normal * -1 }
        let radius = resolved.environment.lueurRadii.indices.contains(index) ? resolved.environment.lueurRadii[index] : resolved.physics.targetRadius
        let pickup = crossing.point + normal * (radius + veil.halfThickness)
        let now = session.elapsed
        var arrival: Double?
        var probe = now
        while probe <= now + field.period {
            if let state = field.state(at: probe), state.position.distance(to: crossing.point) <= field.radius * 0.5 {
                arrival = probe
                break
            }
            probe += 1.0 / 30
        }
        let distance = target.position.distance(to: pickup)
        guard let arrival, arrival - now <= 3.0 + distance / 60 else { return nil }
        let toArrival = target.arrival - target.position
        let toArrivalLength = toArrival.length
        let drive = (toArrivalLength > 1e-9 ? toArrival / toArrivalLength * target.passiveAttraction : .zero)
            + resolved.environment.impulse(at: target.position)
        let tangential = drive.x * crossing.tangent.x + drive.y * crossing.tangent.y
        let fromPickup = (target.position.x - pickup.x) * crossing.tangent.x + (target.position.y - pickup.y) * crossing.tangent.y
        // The gaze goes on the side of the lueur away from the pickup (so that the push aims at the pickup); when the
        // lueur sits on the pickup, on the side it slides toward.
        let sideSign: Double = abs(fromPickup) > 12 ? (fromPickup >= 0 ? 1 : -1) : (tangential >= 0 ? 1 : -1)
        let side = crossing.tangent * sideSign
        let offset = fromPickup * sideSign
        // The slide pushes the lueur away from the pickup only when it heads the same way as the gaze side.
        let slideAway = max(0, tangential * sideSign)
        // Gap where the repulsion balances that slide once the lueur is on the pickup; the farther the lueur is from
        // the pickup, the closer the gaze, so that it is pushed there.
        let balance = target.attentionZone - slideAway / max(target.repulsionGain, 1e-9)
        let gap = min(max(balance - 0.8 * offset, 50), target.attentionZone - 5)
        return clamp(target.position + side * gap)
    }

    /// Intersection point of two segments, nil when they do not cross.
    static func intersection(_ p1: Vector2, _ p2: Vector2, _ p3: Vector2, _ p4: Vector2) -> Vector2? {
        let r = p2 - p1
        let s = p4 - p3
        let denominator = r.x * s.y - r.y * s.x
        guard abs(denominator) > 1e-12 else { return nil }
        let q = p3 - p1
        let t = (q.x * s.y - q.y * s.x) / denominator
        let u = (q.x * r.y - q.y * r.x) / denominator
        guard (0...1).contains(t), (0...1).contains(u) else { return nil }
        return p1 + r * t
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
