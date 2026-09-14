// OculomotorTrace.swift
// Layer: Presentation (DEBUG instrumentation)
// Purpose: PROTOTYPE (chapter I level 6): observes, never steers. Classifies every gaze sample (VALID_INSIDE,
// VALID_OUTSIDE when the mapper still produces a projection outside the viewport, INVALID otherwise), records
// viewport exits with only what was really observed, and measures each balise transition (acquisition, dwell,
// head yaw/pitch deltas). Technical figures, not clinical ones.

import Foundation
import os

@MainActor
final class OculomotorTrace {
    enum GazeState: String, Sendable {
        case validInside = "VALID_INSIDE"
        case validOutside = "VALID_OUTSIDE"
        case invalid = "INVALID"
    }

    enum Edge: String, Sendable {
        case left = "LEFT"
        case right = "RIGHT"
        case top = "TOP"
        case bottom = "BOTTOM"
    }

    /// One trip outside the viewport (a projection outside it, or no usable projection at all).
    struct Excursion: Sendable {
        let startTime: TimeInterval
        let state: GazeState
        /// Last position inside the viewport before the exit, if there was one.
        let lastValidPosition: Vector2?
        /// Last movement direction observed inside the viewport, if it pointed at the edge the gaze was near.
        let lastDirection: Edge?
        /// The projection the mapper really produced (nil when the gaze was INVALID: no position is ever invented).
        let projected: Vector2?
        /// True when the projection sits on the mapper's clamp (its real value lay farther out).
        let isCapped: Bool
        var endTime: TimeInterval?
        var reentry: Vector2?

        var duration: TimeInterval? { endTime.map { $0 - startTime } }
    }

    /// One thread step: from the previous balise (or the start) to the designated one.
    struct Transition: Sendable {
        let from: String?
        let to: String
        let startTime: TimeInterval
        let startGaze: Vector2?
        let startState: GazeState
        let headYawStart: Double?
        let headPitchStart: Double?
        var firstEntry: TimeInterval?
        var validation: TimeInterval?
        var headYawAcquisition: Double?
        var headPitchAcquisition: Double?
        /// Largest |Δyaw| + |Δpitch| seen during the transition (descriptive, no threshold).
        var headMotion: Double = 0
        var excursions = 0
        var invalidDuration: TimeInterval = 0
        var outsideDuration: TimeInterval = 0

        var acquisition: TimeInterval? { firstEntry.map { $0 - startTime } }
        var dwell: TimeInterval? {
            guard let validation, let firstEntry else { return nil }
            return validation - firstEntry
        }
        var headYawDelta: Double? {
            guard let a = headYawAcquisition, let s = headYawStart else { return nil }
            return a - s
        }
        var headPitchDelta: Double? {
            guard let a = headPitchAcquisition, let s = headPitchStart else { return nil }
            return a - s
        }
    }

    let names: [String]
    private(set) var state: GazeState = .invalid
    private(set) var lastValidPosition: Vector2?
    private(set) var lastDirection: Edge?
    /// Edge to show on the DEBUG indicator: the projected side while VALID_OUTSIDE, the last observed direction while
    /// INVALID, nil while inside.
    private(set) var lastEdge: Edge?
    private(set) var headYaw: Double?
    private(set) var headPitch: Double?
    private(set) var headRoll: Double?
    private(set) var excursions: [Excursion] = []
    private(set) var transitions: [Transition] = []
    private(set) var lines: [String] = []

    private var current: Transition?
    private var currentBalise: Int?
    private var previousInside: (position: Vector2, time: TimeInterval)?
    private var lastSampleTime: TimeInterval?
    private var lastTickTime: TimeInterval?
    private var wasInside = false
    private let logger = Logger(subsystem: "net.steve-s.iris", category: "oculotest")
    /// Chapter X final: the loop and phase last seen, the start of a stretch without head data, one status line.
    private var ancreKey: String?
    private var ancreHeadGapStart: TimeInterval?
    private(set) var ancreStatus: String?
    /// The gaze state last logged while the head alone counted.
    private var ancreGazeState: GazeState?

    init(names: [String]) {
        self.names = names
    }

    var statusLine: String {
        var parts = ["oculo : \(state.rawValue)"]
        if let lastEdge { parts.append(lastEdge.rawValue) }
        if let headYaw, let headPitch { parts.append(String(format: "yaw %.1f° pitch %.1f°", headYaw, headPitch)) }
        if let ancreStatus { parts.append(ancreStatus) }
        return parts.joined(separator: " · ")
    }

    // MARK: Samples

    /// `mapped` is the calibrated playfield point the mapper produced, nil when it produced none.
    func observeSample(mapped: Vector2?, sample: RawGazeSample, bounds: PlayfieldBounds) {
        let time = sample.timestamp
        lastSampleTime = time
        if let observation = sample.observation {
            headYaw = observation.headYaw
            headPitch = observation.headPitch
            headRoll = observation.headRoll
            if var transition = current, let yawStart = transition.headYawStart, let pitchStart = transition.headPitchStart {
                transition.headMotion = max(transition.headMotion, abs(observation.headYaw - yawStart) + abs(observation.headPitch - pitchStart))
                current = transition
            }
        }
        let newState: GazeState
        if let mapped {
            let inside = mapped.x >= 0 && mapped.x <= bounds.width && mapped.y >= 0 && mapped.y <= bounds.height
            newState = inside ? .validInside : .validOutside
        } else {
            newState = .invalid
        }
        if newState == .validInside, let mapped {
            if let previous = previousInside, time > previous.time {
                let delta = mapped - previous.position
                if delta.length > 2 {
                    lastDirection = abs(delta.x) >= abs(delta.y) ? (delta.x > 0 ? .right : .left) : (delta.y > 0 ? .bottom : .top)
                }
            }
            previousInside = (mapped, time)
            lastValidPosition = mapped
        }
        transition(to: newState, mapped: mapped, bounds: bounds, time: time)
    }

    /// The face left the camera (no samples arrive) or came back.
    func observeFaceVisible(_ visible: Bool, time: TimeInterval? = nil) {
        let at = time ?? lastSampleTime ?? 0
        if !visible {
            transition(to: .invalid, mapped: nil, bounds: nil, time: at)
        }
    }

    private func transition(to newState: GazeState, mapped: Vector2?, bounds: PlayfieldBounds?, time: TimeInterval) {
        guard newState != state else { return }
        let previous = state
        state = newState
        switch newState {
        case .validInside:
            lastEdge = nil
            if var open = excursions.last, open.endTime == nil {
                open.endTime = time
                open.reentry = mapped
                excursions[excursions.count - 1] = open
                log(String(format: "reentry after %.0fms at %@", (open.duration ?? 0) * 1000, describe(mapped)))
            }
        case .validOutside, .invalid:
            var edge: Edge?
            var capped = false
            if newState == .validOutside, let mapped, let bounds {
                edge = Self.edge(of: mapped, in: bounds)
                let marginX = bounds.width * 0.5
                let marginY = bounds.height * 0.5
                capped = mapped.x <= -marginX + 1e-6 || mapped.x >= bounds.width + marginX - 1e-6
                    || mapped.y <= -marginY + 1e-6 || mapped.y >= bounds.height + marginY - 1e-6
            } else if let bounds, let position = lastValidPosition {
                edge = Self.nearEdge(position, in: bounds, direction: lastDirection)
            } else if bounds == nil {
                edge = lastDirection
            }
            lastEdge = edge
            if previous == .validInside {
                let excursion = Excursion(startTime: time, state: newState, lastValidPosition: lastValidPosition,
                                          lastDirection: lastDirection, projected: newState == .validOutside ? mapped : nil,
                                          isCapped: capped, endTime: nil, reentry: nil)
                excursions.append(excursion)
                if var transition = current {
                    transition.excursions += 1
                    current = transition
                }
                log("exit state=\(newState.rawValue) edge=\(edge?.rawValue ?? "unknown") last=\(describe(lastValidPosition)) "
                    + "projected=\(newState == .validOutside ? describe(mapped) : "none")\(capped ? " capped" : "") lastDirection=\(lastDirection?.rawValue ?? "unknown")")
            } else if var open = excursions.last, open.endTime == nil, open.state != newState {
                // Outside, then no projection at all: keep the exit as observed, note the change.
                excursions[excursions.count - 1] = open
                open.endTime = nil
                log("exit continues state=\(newState.rawValue)")
            }
        }
    }

    // MARK: Ticks

    /// Called once per engine tick with the events of that tick; measures the thread transitions in level time.
    func observeTick(session: GameSession, events: [GameEvent]) {
        let now = session.elapsed
        if let last = lastTickTime, var transition = current {
            let dt = max(0, now - last)
            if state == .invalid { transition.invalidDuration += dt }
            if state == .validOutside { transition.outsideDuration += dt }
            current = transition
        }
        lastTickTime = now
        // OCULOMOTOR EXPANSION: stage successes, misses and completions, with the head pose at that moment.
        for event in events {
            switch event {
            case let .oculoSuccess(stage):
                log("stage=\(stage + 1) success gazeState=\(state.rawValue) yaw=\(degrees(headYaw)) pitch=\(degrees(headPitch))")
            case let .oculoMiss(stage):
                log("stage=\(stage + 1) miss gazeState=\(state.rawValue) yaw=\(degrees(headYaw)) pitch=\(degrees(headPitch))")
            case let .oculoStageCompleted(stage):
                log("stage=\(stage + 1) complete at \(decimal(now, 2))s excursions=\(excursions.count)")
            case .oculoCompleted:
                log("sequence complete at \(decimal(now, 2))s excursions=\(excursions.count)")
            default:
                break
            }
        }
        observeAncre(session: session, events: events)
        guard let balises = session.balises else { return }

        for event in events {
            if case let .baliseLit(balise, step) = event, var transition = current {
                transition.validation = now
                current = nil
                transitions.append(transition)
                log(String(format: "transition=%@->%@ step=%d acquisition=%@ dwell=%@ gazeState=%@ excursions=%d invalid=%.0fms outside=%.0fms headYawDelta=%@ headPitchDelta=%@ headMotion=%.1fdeg",
                           transition.from ?? "START", transition.to, step, milliseconds(transition.acquisition), milliseconds(transition.dwell),
                           transition.startState.rawValue, transition.excursions, transition.invalidDuration * 1000, transition.outsideDuration * 1000,
                           degrees(transition.headYawDelta), degrees(transition.headPitchDelta), transition.headMotion))
                _ = balise
            }
            if event == .balisesCompleted {
                let acquisitions = transitions.compactMap(\.acquisition)
                let dwells = transitions.compactMap(\.dwell)
                let motions = transitions.map(\.headMotion)
                log(String(format: "thread complete at %.2fs transitions=%d meanAcquisition=%.0fms meanDwell=%.0fms meanHeadMotion=%.1fdeg excursions=%d",
                           now, transitions.count, mean(acquisitions) * 1000, mean(dwells) * 1000, mean(motions), excursions.count))
            }
        }

        let active = balises.activeBalise
        if active != currentBalise {
            currentBalise = active
            wasInside = false
            if let active {
                current = Transition(from: transitions.last?.to, to: names.indices.contains(active) ? names[active] : "\(active)",
                                     startTime: now, startGaze: session.gaze.isActive ? session.gaze.position : nil, startState: state,
                                     headYawStart: headYaw, headPitchStart: headPitch)
            } else {
                current = nil
            }
        }
        if let active, balises.activeBalise == active, balises.isInside, !wasInside, var transition = current, transition.firstEntry == nil {
            transition.firstEntry = now
            transition.headYawAcquisition = headYaw
            transition.headPitchAcquisition = headPitch
            current = transition
        }
        wasInside = balises.isInside
    }

    // MARK: Chapter X final

    /// Logs each loop's phases and successes with the rest pose, the head offset (screen-oriented amplitudes), the gaze
    /// state and the gaze's role: the criterion during a fixation, ignored while the head draws the circle. A gaze outside
    /// the viewport during a circle is expected and logged as such, never as an error. Also logs the stretches without
    /// head data. Observation only; every figure is built by interpolation, with types that match exactly.
    private func observeAncre(session: GameSession, events: [GameEvent]) {
        guard let sequence = session.oculo, case let .ancre(ancre)? = sequence.current else {
            ancreStatus = nil
            return
        }
        let now = session.elapsed
        let loop = sequence.currentIndex + 1
        let role = ancre.gazeIsCriterion ? "criterion" : (ancre.isHeadOnly ? "ignored" : "none")
        let sense = ancre.start == .right ? "anticlockwise" : "clockwise"
        let head = ancre.headOffset.map { "(\(decimal($0.x, 2)),\(decimal($0.y, 2)))" } ?? "none"
        let key = "\(loop)-\(ancre.phase.rawValue)"
        if key != ancreKey {
            ancreKey = key
            ancreGazeState = nil
            let rest = ancre.restPose.map { "(\(decimal($0.yaw, 1)),\(decimal($0.pitch, 1)))" } ?? "none"
            log("ancre loop=\(loop) phase=\(ancre.phase.rawValue) at \(decimal(now, 2))s sense=\(sense) sweep=\(decimal(ancre.sweep, 0))deg "
                + "rest=\(rest) head=\(head) gaze=\(role) gazeState=\(state.rawValue) headGap=\(decimal(ancre.headGap * 1000, 0))ms reach=\(decimal(ancre.largestReach, 2))")
        }
        if events.contains(where: { if case .oculoSuccess = $0 { return true } else { return false } }) {
            log("ancre loop=\(loop) success phase=\(ancre.phase.rawValue) checkpoints=\(ancre.checkpointTimes.count) sweep=\(decimal(ancre.sweep, 0))deg "
                + "head=\(head) gaze=\(role) gazeState=\(state.rawValue)")
        }
        if ancre.isHeadOnly && state != ancreGazeState {
            ancreGazeState = state
            log("ancre loop=\(loop) \(ancre.phase.rawValue) gazeState=\(state.rawValue) gaze=ignored sweep=\(decimal(ancre.sweep, 0))deg: expected while the head turns, the circle goes on")
        }
        if session.headPose == nil {
            if ancreHeadGapStart == nil { ancreHeadGapStart = now }
        } else if let start = ancreHeadGapStart {
            ancreHeadGapStart = nil
            if ancre.isHeadOnly { log("ancre loop=\(loop) head data back after \(decimal((now - start) * 1000, 0))ms; the circle waited meanwhile") }
        }
        let gazeWord = ancre.gazeIsCriterion ? "regard : critère" : "regard ignoré"
        ancreStatus = "ancre \(loop) · \(ancre.phase.rawValue) · \(decimal(ancre.sweep, 0))° · r \(decimal(ancre.headOffset?.length ?? 0, 2)) · \(gazeWord)"
    }

    /// A decimal with a fixed number of digits; the argument is a Double, as the specifier expects.
    private func decimal(_ value: Double, _ digits: Int) -> String {
        String(format: "%.\(digits)f", value)
    }

    // MARK: Helpers

    static func edge(of point: Vector2, in bounds: PlayfieldBounds) -> Edge? {
        let excess: [(Edge, Double)] = [(.left, -point.x), (.right, point.x - bounds.width), (.top, -point.y), (.bottom, point.y - bounds.height)]
        guard let worst = excess.max(by: { $0.1 < $1.1 }), worst.1 > 0 else { return nil }
        return worst.0
    }

    /// The last observed direction, kept only when the last inside position lay in the outer third toward that edge.
    static func nearEdge(_ position: Vector2, in bounds: PlayfieldBounds, direction: Edge?) -> Edge? {
        guard let direction else { return nil }
        switch direction {
        case .left: return position.x <= bounds.width / 3 ? .left : nil
        case .right: return position.x >= bounds.width * 2 / 3 ? .right : nil
        case .top: return position.y <= bounds.height / 3 ? .top : nil
        case .bottom: return position.y >= bounds.height * 2 / 3 ? .bottom : nil
        }
    }

    private func log(_ message: String) {
        let line = "[OculoTest] " + message
        lines.append(line)
        logger.info("\(line, privacy: .public)")
    }

    private func describe(_ point: Vector2?) -> String {
        point.map { String(format: "(%.0f,%.0f)", $0.x, $0.y) } ?? "none"
    }

    private func milliseconds(_ value: TimeInterval?) -> String {
        value.map { String(format: "%.0fms", $0 * 1000) } ?? "none"
    }

    private func degrees(_ value: Double?) -> String {
        value.map { String(format: "%.1fdeg", $0) } ?? "none"
    }

    private func mean(_ values: [Double]) -> Double {
        values.isEmpty ? 0 : values.reduce(0, +) / Double(values.count)
    }
}
