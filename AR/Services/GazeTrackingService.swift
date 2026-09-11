// GazeTrackingService.swift
// Layer: AR (service contract consumed by Presentation)
// Purpose: Abstraction over gaze acquisition. Produces raw, metric samples; calibration and mapping happen downstream.

import Foundation
import simd

enum GazeUnavailabilityReason: Hashable, Sendable {
    case faceTrackingUnsupported
    case cameraDenied
    case cameraRestricted
}

enum GazeTrackingState: Hashable, Sendable {
    case idle
    case starting
    case tracking(faceVisible: Bool)
    case interrupted
    case unavailable(GazeUnavailabilityReason)
    case failed(message: String)
}

/// One frame of raw gaze geometry in the interface-oriented camera frame (metres). Never persisted.
struct RawGazeSample: Hashable, Sendable {
    let timestamp: TimeInterval
    /// Hit of the gaze ray on the device plane, nil when the gaze does not reach the plane.
    let planeHit: SIMD2<Double>?
    /// Midpoint of both eyes.
    let eyeOrigin: SIMD3<Double>
    /// Distance between the eyes (metres), a plausibility cue.
    let eyeSeparation: Double
    /// Direction from the user's left eye to their right eye, projected on the device plane.
    let userRight: SIMD2<Double>
    /// Direction opposite to gravity, projected on the device plane (short when the device lies flat).
    let deviceUp: SIMD2<Double>
    /// Fallback up direction derived from the face itself.
    let faceUp: SIMD2<Double>
    let blinkLeft: Double
    let blinkRight: Double
    let hasBlendShapes: Bool

    init(timestamp: TimeInterval, planeHit: SIMD2<Double>?, eyeOrigin: SIMD3<Double>, eyeSeparation: Double,
         userRight: SIMD2<Double>, deviceUp: SIMD2<Double>, faceUp: SIMD2<Double>,
         blinkLeft: Double, blinkRight: Double, hasBlendShapes: Bool) {
        self.timestamp = timestamp
        self.planeHit = planeHit
        self.eyeOrigin = eyeOrigin
        self.eyeSeparation = eyeSeparation
        self.userRight = userRight
        self.deviceUp = deviceUp
        self.faceUp = faceUp
        self.blinkLeft = blinkLeft
        self.blinkRight = blinkRight
        self.hasBlendShapes = hasBlendShapes
    }

    var faceDistance: Double { simd_length(eyeOrigin) }

    /// Axis mapping suggested by this single frame (majority voting happens in the readiness evaluator).
    var suggestedAxisMapping: AxisMapping? {
        AxisResolver.resolve(userRight: userRight, deviceUp: deviceUp, faceUp: faceUp)
    }
}

/// Gaze sample mapped to playfield points (the game's coordinate space).
struct GazeSample: Hashable, Sendable {
    let point: Vector2
    let timestamp: TimeInterval

    init(point: Vector2, timestamp: TimeInterval) {
        self.point = point
        self.timestamp = timestamp
    }
}

struct GazeViewport: Hashable, Sendable {
    let bounds: PlayfieldBounds
    /// Nominal frame used by the simulator to invert pointer positions; ignored by the ARKit service.
    let nominal: NominalDisplayGeometry

    init(bounds: PlayfieldBounds, nominal: NominalDisplayGeometry) {
        self.bounds = bounds
        self.nominal = nominal
    }
}

@MainActor
protocol GazeTrackingService: AnyObject {
    var state: GazeTrackingState { get }
    var latestSample: RawGazeSample? { get }
    var onStateChange: (@MainActor (GazeTrackingState) -> Void)? { get set }
    var onSample: (@MainActor (RawGazeSample) -> Void)? { get set }

    func start(viewport: GazeViewport)
    func pause()
    func resume()
    func stop()
    func updateViewport(_ viewport: GazeViewport)
}
