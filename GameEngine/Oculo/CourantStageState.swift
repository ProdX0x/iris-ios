// CourantStageState.swift
// Layer: GameEngine
// Purpose: Chapter VIII final: a lantern carried along a smooth closed loop with a gentle drift of pace; once the first
// lap is over it vanishes inside mist patches; a gaze within reach when it comes out (or shortly after) catches it,
// otherwise it slips away. Every mist must be caught at least once, and enough catches overall

import Foundation

struct CourantStageState: Hashable, Sendable {
    static let samplesPerSegment = 40

    let samples: [Vector2]
    /// Cumulative length at each sample, closed: the last entry is the whole loop.
    let cumulative: [Double]
    let period: TimeInterval
    let drift: TimeInterval
    let mists: [CourantDefinition.Mist]
    let mistFrom: TimeInterval
    let catchRadius: Double
    let catchWindow: TimeInterval
    let required: Int
    private(set) var catches = 0
    private(set) var drops = 0
    private(set) var caught: Set<Int> = []
    /// The mist hiding the lantern at the last update.
    private(set) var hiddenIn: Int?
    /// The mist the lantern just came out of, and when: the catch is open for `catchWindow`.
    private(set) var catchMist: Int?
    private(set) var catchOpenedAt: TimeInterval?
    private(set) var completedAt: TimeInterval?

    init(definition: CourantDefinition, bounds: PlayfieldBounds, shortSide: Double) {
        let points = definition.waypoints.map { $0.absolute(in: bounds) }
        var samples: [Vector2] = []
        let count = points.count
        if count >= 3 {
            for index in 0..<count {
                let p0 = points[(index - 1 + count) % count]
                let p1 = points[index]
                let p2 = points[(index + 1) % count]
                let p3 = points[(index + 2) % count]
                for step in 0..<Self.samplesPerSegment {
                    samples.append(Self.catmullRom(p0, p1, p2, p3, Double(step) / Double(Self.samplesPerSegment)))
                }
            }
        } else {
            samples = points.isEmpty ? [bounds.center, bounds.center] : points + points
        }
        var cumulative = [0.0]
        for index in 1...samples.count {
            cumulative.append(cumulative[index - 1] + samples[index % samples.count].distance(to: samples[index - 1]))
        }
        self.samples = samples
        self.cumulative = cumulative
        period = definition.period
        drift = definition.drift
        mists = definition.mists
        mistFrom = definition.mistFrom
        catchRadius = definition.catchRadius * shortSide
        catchWindow = definition.catchWindow
        required = definition.catches
    }

    var isComplete: Bool { completedAt != nil }
    var length: Double { cumulative.last ?? 0 }
    var progress: Double {
        guard required > 0 else { return 1 }
        return min(1, Double(catches) / Double(max(required, mists.count)))
    }

    static func catmullRom(_ p0: Vector2, _ p1: Vector2, _ p2: Vector2, _ p3: Vector2, _ t: Double) -> Vector2 {
        let t2 = t * t
        let t3 = t2 * t
        let a = p1 * 2
        let b = (p2 - p0) * t
        let c = (p0 * 2 - p1 * 5 + p2 * 4 - p3) * t2
        let d = (p1 * 3 - p0 - p2 * 3 + p3) * t3
        return (a + b + c + d) * 0.5
    }

    /// The fraction of the loop (0 up to 1) reached at `time`; the pace breathes by a few percent so the rhythm is
    /// learnable but never mechanical.
    func loopFraction(at time: TimeInterval) -> Double {
        let warped = time + drift * sin(2 * Double.pi * time / (1.9 * period))
        let laps = warped / period
        return laps - laps.rounded(.down)
    }

    func position(atFraction fraction: Double) -> Vector2 {
        guard samples.count >= 2, length > 0 else { return samples.first ?? .zero }
        let target = min(max(fraction, 0), 1) * length
        var low = 0
        var high = cumulative.count - 1
        while high - low > 1 {
            let middle = (low + high) / 2
            if cumulative[middle] <= target { low = middle } else { high = middle }
        }
        let span = max(cumulative[high] - cumulative[low], 1e-9)
        let a = samples[low % samples.count]
        let b = samples[high % samples.count]
        return a + (b - a) * ((target - cumulative[low]) / span)
    }

    func position(at time: TimeInterval) -> Vector2 {
        position(atFraction: loopFraction(at: time))
    }

    /// The mist hiding the lantern at `time` (none during the first lap).
    func mist(at time: TimeInterval) -> Int? {
        guard time >= mistFrom else { return nil }
        let fraction = loopFraction(at: time)
        return mists.firstIndex { fraction >= $0.start && fraction < $0.end }
    }

    /// Where the lantern comes out of each mist.
    var exits: [Vector2] { mists.map { position(atFraction: $0.end) } }

    /// Points along a mist patch, for the fog.
    func mistTrail(_ index: Int) -> [Vector2] {
        guard mists.indices.contains(index) else { return [] }
        let mist = mists[index]
        return (0...12).map { position(atFraction: mist.start + (mist.end - mist.start) * Double($0) / 12) }
    }

    mutating func update(_ input: OculoInput) -> OculoOutcome {
        var outcome = OculoOutcome()
        guard !isComplete else { return outcome }
        let now = input.elapsed
        let inMist = mist(at: now)
        if let previous = hiddenIn, inMist != previous {
            catchMist = previous
            catchOpenedAt = now
        }
        hiddenIn = inMist
        guard let mistIndex = catchMist, let opened = catchOpenedAt else { return outcome }
        if input.gazeActive, input.gaze.distance(to: position(at: now)) <= catchRadius {
            catches += 1
            caught.insert(mistIndex)
            catchMist = nil
            catchOpenedAt = nil
            outcome.changes.append(.success)
            if catches >= required && caught.count == mists.count {
                completedAt = now
                outcome.changes.append(.completed)
            }
        } else if now - opened > catchWindow {
            drops += 1
            catchMist = nil
            catchOpenedAt = nil
            outcome.changes.append(.miss)
        }
        return outcome
    }
}
