// AncreStageState.swift
// Layer: GameEngine
// Purpose: Chapter X final: one loop of « l'ancre ». The eyes are the criterion only around the circle: the loop begins
// once they rest on the point with the head still and roughly facing the screen, and the last loop ends with a short
// fixation again. While the head turns to the starting side, draws the circle and comes back to face, the gaze is not
// read at all (its projection drifts with a turned head): progress follows the head's observed path only, forward,
// continuous and at a bounded pace, and it waits while no head pose arrives. Head angles arrive oriented like the screen.

import Foundation

struct AncreStageState: Hashable, Sendable {
    enum Phase: String, Hashable, Sendable {
        /// Eyes on the point, head still and roughly facing the screen: the gaze is the criterion.
        case fixating
        /// The head turns toward the starting side: the head alone counts.
        case seeking
        /// The head draws the circle: the head alone counts.
        case circling
        /// The head comes back to face the screen: the head alone counts.
        case returning
        /// Last loop only: the eyes come back to the point, head facing the screen: the gaze is the criterion again.
        case refixating
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
    let ringRadius: Double
    let yawAmplitude: Double
    let pitchAmplitude: Double
    let reach: Double
    let rest: Double
    let fixation: TimeInterval
    let closingFixation: TimeInterval?
    let stillness: Double
    let neutralYaw: Double
    let neutralPitch: Double
    let returnHold: TimeInterval
    let maxSweepSpeed: Double
    let guidePace: Double

    private(set) var phase: Phase = .fixating
    /// Stage clock at the last update, and when the current phase began.
    private(set) var clock: TimeInterval = 0
    private(set) var phaseStartedAt: TimeInterval = 0
    /// Whether the eyes rest on the point (with a release margin); updated only while the gaze is the criterion.
    private(set) var isOnAnchor = false
    private(set) var fixationTime: TimeInterval = 0
    private var fixationReference: HeadPose?
    private var fixationYawSum = 0.0
    private var fixationPitchSum = 0.0
    private var fixationSamples = 0
    /// The head's rest pose, measured during the opening fixation.
    private(set) var restPose: HeadPose?
    /// Degrees of the loop drawn so far, from the starting side, in the loop's sense.
    private(set) var sweep = 0.0
    /// The head's last position along the loop while on the circle, to tell a forward move from a backward one.
    private var lastCandidate: Double?
    /// The ideal player's place along the loop (degrees), for the oracle only: it moves at the guide's pace just ahead
    /// of the ring, and starts again from the ring when it has been waiting there.
    private(set) var guideSweep = 0.0
    /// Stage time at which each checkpoint was reached, in order.
    private(set) var checkpointTimes: [TimeInterval] = []
    private(set) var anchoredAt: TimeInterval?
    private(set) var returnTime: TimeInterval = 0
    /// The head's last offset from rest, in amplitudes: x toward the screen's right, y toward its top.
    private(set) var headOffset: Vector2?
    /// Seconds without head data while the head alone counts (trace).
    private(set) var headGap: TimeInterval = 0
    /// Largest head offset reached, in amplitudes (trace).
    private(set) var largestReach = 0.0
    private(set) var completedAt: TimeInterval?

    init(definition: AncreDefinition, bounds: PlayfieldBounds, shortSide: Double) {
        anchor = definition.anchor.absolute(in: bounds)
        start = definition.start
        radius = definition.radius * shortSide
        releaseRadius = definition.releaseRadius * shortSide
        ringRadius = definition.ringRadius * shortSide
        yawAmplitude = definition.yawAmplitude
        pitchAmplitude = definition.pitchAmplitude
        reach = definition.reach
        rest = definition.rest
        fixation = definition.fixation
        closingFixation = definition.closingFixation
        stillness = definition.stillness
        neutralYaw = definition.neutralYaw
        neutralPitch = definition.neutralPitch
        returnHold = definition.returnHold
        maxSweepSpeed = definition.maxSweepSpeed
        guidePace = definition.guidePace
    }

    /// Angle of the starting side (degrees, anticlockwise from the screen's right) and the loop's sense (+1 anticlockwise).
    var startAngle: Double { start == .right ? 0 : 180 }
    var turn: Double { start == .right ? 1 : -1 }
    var isComplete: Bool { completedAt != nil }
    /// True while the eyes decide (the fixations).
    var gazeIsCriterion: Bool { phase == .fixating || phase == .refixating }
    /// True while the head alone counts and the gaze is not read (to the starting side, the circle, the return).
    var isHeadOnly: Bool { phase == .seeking || phase == .circling || phase == .returning }
    var returnProgress: Double { min(1, returnTime / returnHold) }

    var fixationProgress: Double {
        switch phase {
        case .fixating: min(1, fixationTime / fixation)
        case .refixating: min(1, fixationTime / (closingFixation ?? fixation))
        case .seeking, .circling, .returning, .done: 0
        }
    }

    var progress: Double {
        let closing = closingFixation == nil ? 0.0 : 0.08
        let circle = 0.8 - closing
        switch phase {
        case .fixating: return 0.1 * fixationProgress
        case .seeking: return 0.1
        case .circling: return 0.1 + circle * min(1, sweep / Self.finishSweep)
        case .returning: return 0.1 + circle + 0.1 * returnProgress
        case .refixating: return 0.2 + circle + closing * fixationProgress
        case .done: return 1
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
        switch phase {
        case .fixating:
            trackAnchor(input)
            fixate(input, into: &outcome)
        case .refixating:
            trackAnchor(input)
            closeWithFixation(input, into: &outcome)
        case .seeking, .circling, .returning:
            // The gaze is not read here: only an observed head pose moves anything, and nothing moves without one.
            guard let head = input.head, let restPose else {
                headGap += input.seconds
                lastCandidate = nil
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
            case .fixating, .refixating, .done: break
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

    /// The opening fixation: eyes on the point, head present, roughly facing the screen and still; its mean is the rest.
    private mutating func fixate(_ input: OculoInput, into outcome: inout OculoOutcome) {
        guard let head = input.head, isOnAnchor, abs(head.yaw) <= neutralYaw, abs(head.pitch) <= neutralPitch else {
            restartFixation(nil)
            return
        }
        if let reference = fixationReference, abs(head.yaw - reference.yaw) <= stillness, abs(head.pitch - reference.pitch) <= stillness {
            fixationTime += input.seconds
            fixationYawSum += head.yaw
            fixationPitchSum += head.pitch
            fixationSamples += 1
        } else {
            restartFixation(head)
        }
        guard fixationTime >= fixation - 1e-9, fixationSamples > 0 else { return }
        restPose = HeadPose(yaw: fixationYawSum / Double(fixationSamples), pitch: fixationPitchSum / Double(fixationSamples))
        anchoredAt = clock
        fixationTime = 0
        enter(.seeking)
        outcome.changes.append(.success)
    }

    private mutating func restartFixation(_ head: HeadPose?) {
        fixationReference = head
        fixationTime = 0
        fixationYawSum = head?.yaw ?? 0
        fixationPitchSum = head?.pitch ?? 0
        fixationSamples = head == nil ? 0 : 1
    }

    /// The closing fixation of the last loop: eyes on the point again, head present and back near its rest.
    private mutating func closeWithFixation(_ input: OculoInput, into outcome: inout OculoOutcome) {
        guard isOnAnchor, let head = input.head, let restPose, offset(of: head, from: restPose).length < reach else {
            fixationTime = 0
            return
        }
        fixationTime += input.seconds
        guard fixationTime >= (closingFixation ?? fixation) - 1e-9 else { return }
        completedAt = clock
        enter(.done)
        outcome.changes.append(.completed)
    }

    private mutating func seek(_ current: Vector2, size: Double, into outcome: inout OculoOutcome) {
        guard size >= reach else { return }
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

    /// The ring gains only from a head on the circle moving forward, a little ahead of the ring, at a bounded pace: a
    /// head coming round the wrong way, or landing ahead after a jump or a gap in the data, never fills it.
    private mutating func advance(_ current: Vector2, size: Double, seconds: TimeInterval) {
        guard size >= reach else {
            lastCandidate = nil
            return
        }
        let candidate = Self.unwrapped(loopAngle(of: current), near: sweep)
        let forward = lastCandidate.map { candidate > $0 } ?? false
        lastCandidate = candidate
        guard forward, candidate > sweep, candidate <= sweep + Self.continuityWindow else { return }
        sweep = min(360, candidate, sweep + maxSweepSpeed * seconds)
    }

    private mutating func finish(_ current: Vector2, size: Double, seconds: TimeInterval, into outcome: inout OculoOutcome) {
        advance(current, size: size, seconds: seconds)
        returnTime = size < rest ? returnTime + seconds : 0
        guard returnTime >= returnHold - 1e-9 else { return }
        if closingFixation != nil {
            // The circle is drawn and the head faces the screen: the eyes become the criterion again.
            isOnAnchor = false
            fixationTime = 0
            enter(.refixating)
            outcome.changes.append(.success)
        } else {
            completedAt = clock
            enter(.done)
            outcome.changes.append(.completed)
        }
    }

    // MARK: Oracle (simulated player only)

    /// The ideal player: still while fixating, a gentle turn to the starting side, the circle at a calm pace just ahead
    /// of the ring, then back to rest.
    var suggestedHead: HeadPose? {
        guard !isComplete else { return nil }
        let base = restPose ?? fixationReference ?? .neutral
        let target: Vector2
        switch phase {
        case .fixating, .returning, .refixating, .done:
            return base
        case .seeking:
            target = offset(atSweep: 0, size: min(1, max(0, clock - phaseStartedAt) * 1.6))
        case .circling:
            target = offset(atSweep: guideSweep, size: 1)
        }
        return HeadPose(yaw: base.yaw + target.x * yawAmplitude, pitch: base.pitch + target.y * pitchAmplitude)
    }
}
