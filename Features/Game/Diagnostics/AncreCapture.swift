// AncreCapture.swift
// Layer: Presentation (DEBUG instrumentation)
// Purpose: Chapter X final « l'ancre »: a short local JSON Lines capture, started only by the `--iris-capture` launch
// argument, that keeps apart what a head loop can mix up: the game phase (with the face-lost warning), face and head
// tracking, the head pose (camera frame and screen-oriented), gaze availability, state and role, and the loop's phase,
// expected sense, checkpoints and sweep. During a circle the gaze role is "ignored": a gaze outside the viewport then is
// expected while the sweep keeps growing. Observation only: no camera image, no face geometry, no blend shape, no
// upload; bounded in time and written off the main thread into the app's temporary directory.

#if DEBUG
import Foundation
import os

@MainActor
final class AncreCapture {
    struct Record: Encodable, Sendable {
        /// Seconds since the capture started (monotonic), and the level's own clock.
        let t: Double
        let levelTime: Double
        let kind: String
        let session: String
        let level: String
        let gamePhase: String
        let faceLostWarning: Bool
        var loop: Int?
        let loopStart: String?
        /// The loop's sense on screen: "anticlockwise" from the right, "clockwise" from the left.
        let expectedDirection: String?
        let loopPhase: String?
        /// "criterion" during a fixation, "ignored" while the head alone counts.
        let gazeRole: String?
        let checkpoints: Int?
        let sweepDeg: Double?
        /// Whether the eyes rest on the point, recorded only while the gaze is the criterion.
        let gazeOnPoint: Bool?
        var headTracked: Bool?
        var faceTracked: Bool?
        var headYawDeg: Double?
        var headPitchDeg: Double?
        var headRollDeg: Double?
        var screenYawDeg: Double?
        var screenPitchDeg: Double?
        var gazeSample: Bool?
        var gazeState: String?
        var gazeX: Double?
        var gazeY: Double?
        var lastValidAgeMs: Double?
        var event: String?
    }

    static let maximumDuration: TimeInterval = 180
    static let directoryName = "iris-debug"

    /// An explicit developer action: the capture never runs unless the app was launched with this argument.
    static var isRequested: Bool { ProcessInfo.processInfo.arguments.contains("--iris-capture") }

    let url: URL
    private let levelID: String
    private let sessionID = String(UUID().uuidString.prefix(8))
    private let startedAt = ProcessInfo.processInfo.systemUptime
    private let queue = DispatchQueue(label: "net.steve-s.iris.ancre-capture", qos: .utility)
    private let logger = Logger(subsystem: "net.steve-s.iris", category: "oculotest")
    private var pending: [Record] = []
    /// The last record made (tests and inspection).
    private(set) var lastRecord: Record?
    private var lastValidTime: TimeInterval?
    private(set) var isStopped = false

    /// Nil unless the level is the ancre and the capture was requested.
    init?(level: LevelDefinition, requested: Bool = AncreCapture.isRequested) {
        guard requested, level.oculo?.element == .ancre else { return nil }
        levelID = level.id
        let stamp = ISO8601DateFormatter().string(from: Date()).replacingOccurrences(of: ":", with: "-")
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(Self.directoryName, isDirectory: true)
        let target = directory.appendingPathComponent("iris-debug-\(stamp)-\(level.id).jsonl")
        url = target
        queue.async {
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            FileManager.default.createFile(atPath: target.path, contents: nil)
        }
        logger.info("[OculoTest] ancre capture started: \(target.path, privacy: .public)")
    }

    /// One gaze sample, with what the session and the tracker say at that moment.
    func observeSample(session: GameSession, phase: GamePhase, faceTracked: Bool?, observation: GazeObservation?, screenHead: HeadPose?,
                       mapped: Vector2?, gazeState: String, bounds: PlayfieldBounds, timestamp: TimeInterval) {
        guard var record = record(session: session, phase: phase, kind: "sample") else { return }
        if mapped != nil && gazeState == "VALID_INSIDE" { lastValidTime = timestamp }
        record.faceTracked = faceTracked
        record.headTracked = screenHead != nil
        record.headYawDeg = observation?.headYaw
        record.headPitchDeg = observation?.headPitch
        record.headRollDeg = observation?.headRoll
        record.screenYawDeg = screenHead?.yaw
        record.screenPitchDeg = screenHead?.pitch
        record.gazeSample = mapped != nil
        record.gazeState = gazeState
        if let mapped, bounds.width > 0, bounds.height > 0 {
            record.gazeX = mapped.x / bounds.width
            record.gazeY = mapped.y / bounds.height
        }
        record.lastValidAgeMs = lastValidTime.map { max(0, timestamp - $0) * 1000 }
        append(record)
    }

    /// The loop's events of one engine tick, named after what they mean in the loop.
    func observeTick(session: GameSession, phase: GamePhase, events: [GameEvent]) {
        for event in events {
            var loop: Int?
            let name: String
            switch event {
            case .oculoSuccess:
                var loopPhase: AncreStageState.Phase?
                if case let .ancre(state)? = session.oculo?.current { loopPhase = state.phase }
                switch loopPhase {
                case .seeking: name = "fixationAcquired"
                case .refixating: name = "circleClosedFixateAgain"
                default: name = "checkpoint"
                }
            case let .oculoStageCompleted(stage):
                name = "loopCompleted"
                loop = stage + 1
            case .oculoCompleted: name = "loopsCompleted"
            case .levelCompleted: name = "levelCompleted"
            default: continue
            }
            mark(name, session: session, phase: phase, loop: loop)
        }
    }

    /// A moment worth its own line: the face shown or hidden, the face-lost warning, a loop event.
    func mark(_ name: String, session: GameSession, phase: GamePhase, faceTracked: Bool? = nil, loop: Int? = nil) {
        guard var record = record(session: session, phase: phase, kind: "event") else { return }
        record.event = name
        record.faceTracked = faceTracked
        if let loop { record.loop = loop }
        append(record)
    }

    /// Waits until every line handed to the writer is on disk (tests and inspection).
    func waitForWrites() {
        queue.sync {}
    }

    func stop(reason: String) {
        guard !isStopped else { return }
        flush()
        isStopped = true
        let path = url.path
        logger.info("[OculoTest] ancre capture stopped (\(reason, privacy: .public)): \(path, privacy: .public)")
    }

    private func record(session: GameSession, phase: GamePhase, kind: String) -> Record? {
        guard !isStopped else { return nil }
        let t = ProcessInfo.processInfo.systemUptime - startedAt
        guard t <= Self.maximumDuration else {
            stop(reason: "time limit")
            return nil
        }
        var loop: Int?
        var start: String?
        var direction: String?
        var loopPhase: String?
        var role: String?
        var checkpoints: Int?
        var sweep: Double?
        var onPoint: Bool?
        if let sequence = session.oculo, case let .ancre(state)? = sequence.current {
            loop = sequence.currentIndex + 1
            start = state.start.rawValue
            direction = state.start == .right ? "anticlockwise" : "clockwise"
            if sequence.isBreathing {
                loopPhase = "breath"
            } else {
                loopPhase = state.phase.rawValue
                role = state.gazeIsCriterion ? "criterion" : (state.isHeadOnly ? "ignored" : nil)
                onPoint = state.gazeIsCriterion ? state.isOnAnchor : nil
            }
            checkpoints = state.checkpointTimes.count
            sweep = state.sweep
        } else if session.oculo?.isComplete == true {
            loopPhase = "complete"
        }
        var record = Record(t: t, levelTime: session.elapsed, kind: kind, session: sessionID, level: levelID, gamePhase: Self.name(of: phase),
                            faceLostWarning: phase == .faceLost, loop: loop, loopStart: start, expectedDirection: direction, loopPhase: loopPhase,
                            gazeRole: role, checkpoints: checkpoints, sweepDeg: sweep, gazeOnPoint: onPoint)
        record.headTracked = session.headPose != nil
        return record
    }

    private static func name(of phase: GamePhase) -> String {
        switch phase {
        case .levelComplete: "levelComplete"
        case .failed: "failed"
        default: String(describing: phase)
        }
    }

    private func append(_ record: Record) {
        lastRecord = record
        pending.append(record)
        if pending.count >= 30 { flush() }
    }

    func flush() {
        guard !pending.isEmpty else { return }
        let batch = pending
        pending.removeAll(keepingCapacity: true)
        let target = url
        queue.async {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys]
            var data = Data()
            for record in batch {
                guard let line = try? encoder.encode(record) else { continue }
                data.append(line)
                data.append(0x0A)
            }
            guard let handle = try? FileHandle(forWritingTo: target) else { return }
            defer { try? handle.close() }
            _ = try? handle.seekToEnd()
            try? handle.write(contentsOf: data)
        }
    }
}
#endif
