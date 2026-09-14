// AncreStageState.swift
// Layer: GameEngine
// Purpose: Chapter X final: one loop of « l'ancre ». The player settles facing the screen with the eyes on the point,
// turns the head to the starting side, draws one continuous circle (up, across, down) and comes back to face. Progress
// follows the head's path, never a string of separate poses: the ring only fills forward, from where it stands, at a
// bounded pace. The eyes need only stay near the point: a clear look away pauses the ring (one miss) without undoing
// it, and lost tracking only pauses it. Head angles arrive oriented like the screen.

import Foundation

struct AncreStageState: Hashable, Sendable {
    enum Phase: String, Hashable, Sendable {
        /// Facing the screen, eyes on the point, head still.
        case settling
        /// Anchored: the head turns toward the starting side.
        case seeking
        /// On the circle: the ring fills with the head's path.
        case circling
        /// The circle is drawn: the head comes back to face the screen.
        case returning
        case done
    }

    /// Where the four checkpoints sit along a loop (degrees): the starting side, the top, the opposite side, the bottom.
    static let checkpoints: [Double] = [0, 90, 180, 270]
    /// A checkpoint counts a little before its exact angle.
    static let checkpointTolerance = 10.0
    /// Past this sweep the circle is drawn (the lower diagonal before the starting side).
    static let finishSweep = 300.0
    /// The head may reach the starting side this far above or below it.
    static let startTolerance = 30.0
    /// The ring only follows a head this close ahead of it (degrees): a jump across the circle does not count.
    static let continuityWindow = 50.0

    let anchor: Vector2
    let start: AncreDefinition.Side
    let radius: Double
    let releaseRadius: Double
    let holdRadius: Double
    let ringRadius: Double
    let yawAmplitude: Double
    let pitchAmplitude: Double
    let reach: Double
    let rest: Double
    let settle: TimeInterval
    let stillness: Double
    let returnHold: TimeInterval
    let maxSweepSpeed: Double
    let focusRate: Double
    let guidePace: Double

    private(set) var phase: Phase = .settling
    /// Stage clock at the last update, and when the current phase began.
    private(set) var clock: TimeInterval = 0
    private(set) var phaseStartedAt: TimeInterval = 0
    private(set) var isOnAnchor = false
    private(set) var settleTime: TimeInterval = 0
    private var settleReference: HeadPose?
    private var settleYawSum = 0.0
    private var settlePitchSum = 0.0
    private var settleSamples = 0
    /// The head's rest pose, measured while settling.
    private(set) var restPose: HeadPose?
    /// 0...1 presence of the eyes on the point once anchored; the ring waits below one half.
    private(set) var focus = 1.0
    private var missArmed = true
    /// Degrees of the loop drawn so far, from the starting side, in the loop's sense.
    private(set) var sweep = 0.0
    /// The head's last position along the loop while on the circle, to tell a forward move from a backward one.
    private var lastCandidate: Double?
    /// The ideal player's place along the loop (degrees), for the oracle only: it moves at the guide's pace just ahead
    /// of the ring, and starts again from the ring when it has been waiting there (eyes away, say).
    private(set) var guideSweep = 0.0
    /// Stage time at which each checkpoint was reached, in order.
    private(set) var checkpointTimes: [TimeInterval] = []
    private(set) var anchoredAt: TimeInterval?
    private(set) var returnTime: TimeInterval = 0
    /// The head's last offset from rest, in amplitudes: x toward the screen's right, y toward its top.
    private(set) var headOffset: Vector2?
    private(set) var misses = 0
    /// Seconds without head data once anchored (trace).
    private(set) var headGap: TimeInterval = 0
    /// Largest head offset reached, in amplitudes (trace).
    private(set) var largestReach = 0.0
    private(set) var completedAt: TimeInterval?

    init(definition: AncreDefinition, bounds: PlayfieldBounds, shortSide: Double) {
        anchor = definition.anchor.absolute(in: bounds)
        start = definition.start
        radius = definition.radius * shortSide
        releaseRadius = definition.releaseRadius * shortSide
        holdRadius = definition.holdRadius * shortSide
        ringRadius = definition.ringRadius * shortSide
        yawAmplitude = definition.yawAmplitude
        pitchAmplitude = definition.pitchAmplitude
        reach = definition.reach
        rest = definition.rest
        settle = definition.settle
        stillness = definition.stillness
        returnHold = definition.returnHold
        maxSweepSpeed = definition.maxSweepSpeed
        focusRate = definition.focusRate
        guidePace = definition.guidePace
    }

    /// Angle of the starting side (degrees, anticlockwise from the screen's right) and the loop's sense (+1 anticlockwise).
    var startAngle: Double { start == .right ? 0 : 180 }
    var turn: Double { start == .right ? 1 : -1 }
    var isComplete: Bool { completedAt != nil }
    var isFocused: Bool { focus >= 0.5 }
    var settleProgress: Double { min(1, settleTime / settle) }
    var returnProgress: Double { min(1, returnTime / returnHold) }

    var progress: Double {
        switch phase {
        case .settling: 0.1 * settleProgress
        case .seeking: 0.1
        case .circling: 0.1 + 0.8 * min(1, sweep / Self.finishSweep)
        case .returning: 0.9 + 0.1 * returnProgress
        case .done: 1
        }
    }

    // MARK: Geometry

    /// The head's offset from rest in amplitudes (x right, y up).
    func offset(of head: HeadPose, from rest: HeadPose) -> Vector2 {
        Vector2(x: (head.yaw - rest.yaw) / yawAmplitude, y: (head.pitch - rest.pitch) / pitchAmplitude)
    }

    /// Where an offset sits along this loop: degrees from the starting side in the loop's sense, -180...180.
    func loopAngle(of offset: Vector2) -> Double {
        Self.normalized(turn * (atan2(offset.y, offset.x) * 180 / .pi - startAngle))
    }

    /// The offset (amplitudes) of the loop's point at `sweep` degrees, at `size` times the amplitude.
    func offset(atSweep sweep: Double, size: Double) -> Vector2 {
        let angle = (startAngle + turn * sweep) * .pi / 180
        return Vector2(x: size * cos(angle), y: size * sin(angle))
    }

    static func normalized(_ degrees: Double) -> Double {
        var value = degrees.truncatingRemainder(dividingBy: 360)
        if value > 180 { value -= 360 }
        if value <= -180 { value += 360 }
        return value
    }

    /// The representative of a loop angle closest to the sweep already drawn.
    static func unwrapped(_ angle: Double, near sweep: Double) -> Double {
        angle + 360 * ((sweep - angle) / 360).rounded()
    }

    // MARK: Update

    mutating func update(_ input: OculoInput) -> OculoOutcome {
        var outcome = OculoOutcome()
        clock = input.elapsed
        guard !isComplete else { return outcome }
        trackAnchor(input)
        switch phase {
        case .settling:
            settleStep(input, into: &outcome)
        case .seeking, .circling, .returning:
            updateFocus(input, into: &outcome)
            guard let head = input.head, let restPose else {
                headGap += input.seconds
                return outcome
            }
            let current = offset(of: head, from: restPose)
            headOffset = current
            let size = current.length
            largestReach = max(largestReach, size)
            switch phase {
            case .seeking: seek(current, size: size, into: &outcome)
            case .circling: circle(current, size: size, seconds: input.seconds, into: &outcome)
            case .returning: finish(current, size: size, seconds: input.seconds, into: &outcome)
            case .settling, .done: break
            }
        case .done:
            break
        }
        return outcome
    }

    private mutating func enter(_ next: Phase) {
        phase = next
        phaseStartedAt = clock
    }

    private mutating func trackAnchor(_ input: OculoInput) {
        guard input.gazeActive else {
            isOnAnchor = false
            return
        }
        let distance = input.gaze.distance(to: anchor)
        if isOnAnchor {
            if distance > releaseRadius { isOnAnchor = false }
        } else if distance <= radius {
            isOnAnchor = true
        }
    }

    private mutating func settleStep(_ input: OculoInput, into outcome: inout OculoOutcome) {
        guard let head = input.head, isOnAnchor else {
            restartSettle(nil)
            return
        }
        if let reference = settleReference, abs(head.yaw - reference.yaw) <= stillness, abs(head.pitch - reference.pitch) <= stillness {
            settleTime += input.seconds
            settleYawSum += head.yaw
            settlePitchSum += head.pitch
            settleSamples += 1
        } else {
            restartSettle(head)
        }
        guard settleTime >= settle - 1e-9, settleSamples > 0 else { return }
        restPose = HeadPose(yaw: settleYawSum / Double(settleSamples), pitch: settlePitchSum / Double(settleSamples))
        anchoredAt = clock
        focus = 1
        missArmed = true
        enter(.seeking)
        outcome.changes.append(.success)
    }

    private mutating func restartSettle(_ head: HeadPose?) {
        settleReference = head
        settleTime = 0
        settleYawSum = head?.yaw ?? 0
        settlePitchSum = head?.pitch ?? 0
        settleSamples = head == nil ? 0 : 1
    }

    /// The eyes' presence rises inside the wide zone and falls outside it; an inactive gaze leaves it as it is.
    private mutating func updateFocus(_ input: OculoInput, into outcome: inout OculoOutcome) {
        guard input.gazeActive else { return }
        let inside = input.gaze.distance(to: anchor) <= holdRadius
        focus = min(1, max(0, focus + (inside ? 1 : -1) * focusRate * input.seconds))
        if focus < 0.5 && missArmed && phase != .returning {
            missArmed = false
            misses += 1
            outcome.changes.append(.miss)
        } else if focus >= 0.9 {
            missArmed = true
        }
    }

    private mutating func seek(_ current: Vector2, size: Double, into outcome: inout OculoOutcome) {
        guard isFocused, size >= reach else { return }
        let angle = loopAngle(of: current)
        guard abs(angle) <= Self.startTolerance else { return }
        sweep = max(0, angle)
        lastCandidate = angle
        guideSweep = sweep
        checkpointTimes = [clock]
        enter(.circling)
        outcome.changes.append(.success)
    }

    private mutating func circle(_ current: Vector2, size: Double, seconds: TimeInterval, into outcome: inout OculoOutcome) {
        let before = sweep
        advance(current, size: size, seconds: seconds)
        guideSweep = min(guideSweep + guidePace * seconds, sweep + 20)
        if sweep == before && guideSweep >= sweep + 20 - 1e-9 { guideSweep = sweep }
        while checkpointTimes.count < Self.checkpoints.count,
              sweep >= Self.checkpoints[checkpointTimes.count] - Self.checkpointTolerance {
            checkpointTimes.append(clock)
            outcome.changes.append(.success)
        }
        if sweep >= Self.finishSweep - 1e-9 { enter(.returning) }
    }

    /// The ring gains only from a head on the circle moving forward, eyes near the point, a little ahead of the ring, at a
    /// bounded pace: a head coming round the wrong way, or landing ahead after a jump, never fills it.
    private mutating func advance(_ current: Vector2, size: Double, seconds: TimeInterval) {
        guard size >= reach else {
            lastCandidate = nil
            return
        }
        let candidate = Self.unwrapped(loopAngle(of: current), near: sweep)
        let forward = lastCandidate.map { candidate > $0 } ?? false
        lastCandidate = candidate
        guard isFocused, forward, candidate > sweep, candidate <= sweep + Self.continuityWindow else { return }
        sweep = min(360, candidate, sweep + maxSweepSpeed * seconds)
    }

    private mutating func finish(_ current: Vector2, size: Double, seconds: TimeInterval, into outcome: inout OculoOutcome) {
        advance(current, size: size, seconds: seconds)
        returnTime = size < rest ? returnTime + seconds : 0
        guard returnTime >= returnHold - 1e-9 else { return }
        completedAt = clock
        enter(.done)
        outcome.changes.append(.completed)
    }

    // MARK: Oracle (simulated player only)

    /// The ideal player: still while settling, a gentle turn to the starting side, the circle at a calm pace just ahead
    /// of the ring, then back to rest.
    var suggestedHead: HeadPose? {
        guard !isComplete else { return nil }
        let base = restPose ?? settleReference ?? .neutral
        let target: Vector2
        switch phase {
        case .settling, .returning, .done:
            return base
        case .seeking:
            target = offset(atSweep: 0, size: min(1, max(0, clock - phaseStartedAt) * 1.6))
        case .circling:
            target = offset(atSweep: guideSweep, size: 1)
        }
        return HeadPose(yaw: base.yaw + target.x * yawAmplitude, pitch: base.pitch + target.y * pitchAmplitude)
    }
}
