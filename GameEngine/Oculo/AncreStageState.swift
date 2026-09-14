// AncreStageState.swift
// Layer: GameEngine
// Purpose: Chapter X final: the gaze stays on an anchor while small head turns push a notch around a compass into the
// band the level designates; each band holds for a while, then the head comes back before the next one. The sign of
// each axis is learned from the player's own first turn, so no head convention is assumed.

import Foundation

struct AncreStageState: Hashable, Sendable {
    let anchor: Vector2
    let radius: Double
    let releaseRadius: Double
    let ringRadius: Double
    let bands: [AncreDefinition.Band]
    let yawThreshold: Double
    let pitchThreshold: Double
    let yawRelease: Double
    let pitchRelease: Double
    let dwell: TimeInterval

    private(set) var baseline: HeadPose?
    /// +1 or -1: the sign of the player's first yaw turn and first pitch tilt (nil until they happen).
    private(set) var yawSign: Double?
    private(set) var pitchSign: Double?
    private(set) var bandIndex = 0
    /// After a band, the head must come back near its rest before the next band counts.
    private(set) var awaitingReturn = false
    private(set) var isOnAnchor = false
    private(set) var inBand = false
    private(set) var holdTime: TimeInterval = 0
    /// Times the gaze left the anchor while a band was holding.
    private(set) var slips = 0
    private(set) var lastDelta: HeadPose = .neutral
    private(set) var completedAt: TimeInterval?

    init(definition: AncreDefinition, bounds: PlayfieldBounds, shortSide: Double) {
        anchor = definition.anchor.absolute(in: bounds)
        radius = definition.radius * shortSide
        releaseRadius = definition.releaseRadius * shortSide
        ringRadius = definition.ringRadius * shortSide
        bands = definition.bands
        yawThreshold = definition.yawThreshold
        pitchThreshold = definition.pitchThreshold
        yawRelease = definition.yawThreshold * 0.6
        pitchRelease = definition.pitchThreshold * 0.6
        dwell = definition.dwell
        if bands.isEmpty { completedAt = 0 }
    }

    var isComplete: Bool { completedAt != nil }
    var band: AncreDefinition.Band? { bands.indices.contains(bandIndex) ? bands[bandIndex] : nil }
    var progress: Double { bands.isEmpty ? 1 : (Double(bandIndex) + (dwell > 0 ? min(1, holdTime / dwell) : 0)) / Double(bands.count) }

    /// Where a band sits on the compass: the first yaw turn to the right, its opposite to the left, the first pitch
    /// tilt up, its opposite down.
    static func angle(of band: AncreDefinition.Band) -> Double {
        switch (band.axis, band.direction) {
        case (.yaw, .first), (.yaw, .same): 0
        case (.yaw, .opposite): Double.pi
        case (.pitch, .first), (.pitch, .same): -Double.pi / 2
        case (.pitch, .opposite): Double.pi / 2
        }
    }

    /// The head turn in compass terms: +x toward the first yaw band, -y toward the first pitch band, 1 at the threshold.
    func screenOffset() -> (x: Double, y: Double) {
        (lastDelta.yaw * (yawSign ?? 1) / yawThreshold, -lastDelta.pitch * (pitchSign ?? 1) / pitchThreshold)
    }

    private func reaches(_ delta: HeadPose, _ band: AncreDefinition.Band, threshold yaw: Double, _ pitch: Double) -> Bool {
        switch (band.axis, band.direction) {
        case (.yaw, .first): abs(delta.yaw) >= yaw
        case (.yaw, .same): delta.yaw * (yawSign ?? 1) >= yaw
        case (.yaw, .opposite): -delta.yaw * (yawSign ?? 1) >= yaw
        case (.pitch, .first): abs(delta.pitch) >= pitch
        case (.pitch, .same): delta.pitch * (pitchSign ?? 1) >= pitch
        case (.pitch, .opposite): -delta.pitch * (pitchSign ?? 1) >= pitch
        }
    }

    mutating func update(_ input: OculoInput) -> OculoOutcome {
        var outcome = OculoOutcome()
        guard !isComplete, let band, let head = input.head else { return outcome }
        if baseline == nil { baseline = head }
        let rest = baseline ?? head
        let delta = HeadPose(yaw: head.yaw - rest.yaw, pitch: head.pitch - rest.pitch)
        lastDelta = delta
        if input.gazeActive {
            let distance = input.gaze.distance(to: anchor)
            if isOnAnchor {
                if distance > releaseRadius { isOnAnchor = false }
            } else if distance <= radius {
                isOnAnchor = true
            }
        } else {
            isOnAnchor = false
        }
        if awaitingReturn {
            inBand = false
            holdTime = 0
            if abs(delta.yaw) < yawRelease && abs(delta.pitch) < pitchRelease { awaitingReturn = false }
            return outcome
        }
        // The first turn on an axis sets its sign, as soon as it is clearly under way.
        if band.direction == .first {
            switch band.axis {
            case .yaw where abs(delta.yaw) >= yawRelease: yawSign = delta.yaw >= 0 ? 1 : -1
            case .pitch where abs(delta.pitch) >= pitchRelease: pitchSign = delta.pitch >= 0 ? 1 : -1
            default: break
            }
        }
        inBand = inBand ? reaches(delta, band, threshold: yawRelease, pitchRelease) : reaches(delta, band, threshold: yawThreshold, pitchThreshold)
        if inBand && isOnAnchor {
            holdTime += input.seconds
            if holdTime >= dwell - 1e-9 {
                bandIndex += 1
                holdTime = 0
                inBand = false
                awaitingReturn = true
                outcome.changes.append(.success)
                if bandIndex >= bands.count {
                    completedAt = input.elapsed
                    outcome.changes.append(.completed)
                }
            }
        } else {
            if holdTime > 0 && inBand && !isOnAnchor {
                slips += 1
                outcome.changes.append(.miss)
            }
            holdTime = 0
        }
        return outcome
    }

    /// The ideal player: eyes on the anchor, a gentle turn a little past the threshold toward the band, then back to rest.
    var suggestedHead: HeadPose? {
        guard !isComplete else { return nil }
        // No turn before the rest pose is known: the first head sample becomes the rest.
        guard let rest = baseline else { return .neutral }
        guard let band, !awaitingReturn else { return rest }
        let yaw = yawSign ?? 1
        let pitch = pitchSign ?? 1
        switch (band.axis, band.direction) {
        case (.yaw, .first), (.yaw, .same): return HeadPose(yaw: rest.yaw + yaw * (yawThreshold + 2.5), pitch: rest.pitch)
        case (.yaw, .opposite): return HeadPose(yaw: rest.yaw - yaw * (yawThreshold + 2.5), pitch: rest.pitch)
        case (.pitch, .first), (.pitch, .same): return HeadPose(yaw: rest.yaw, pitch: rest.pitch + pitch * (pitchThreshold + 2.5))
        case (.pitch, .opposite): return HeadPose(yaw: rest.yaw, pitch: rest.pitch - pitch * (pitchThreshold + 2.5))
        }
    }
}
