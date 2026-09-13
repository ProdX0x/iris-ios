// ARKitGazeTrackingService.swift
// Layer: AR
// Purpose: ARFaceTrackingConfiguration session producing raw metric gaze samples in the interface-oriented
// camera frame. No screen scale, camera position or axis sign is assumed here.

import Foundation
import ARKit
import os
import simd

@MainActor
final class ARKitGazeTrackingService: NSObject, GazeTrackingService {
    private(set) var state: GazeTrackingState = .idle {
        didSet {
            if state != oldValue {
                logger.info("gaze state \(String(describing: self.state), privacy: .public)")
                onStateChange?(state)
            }
        }
    }
    private(set) var latestSample: RawGazeSample?
    var onStateChange: (@MainActor (GazeTrackingState) -> Void)?
    var onSample: (@MainActor (RawGazeSample) -> Void)?

    private let session = ARSession()
    private var configuration: ARFaceTrackingConfiguration?
    private var viewport: GazeViewport?
    private let capabilities: any DeviceCapabilities
    private let orientationProvider: any InterfaceOrientationProvider
    private let logger = Logger(subsystem: "net.steve-s.iris", category: "gaze")

    init(capabilities: any DeviceCapabilities = ARKitDeviceCapabilities(),
         orientationProvider: any InterfaceOrientationProvider = WindowSceneOrientationProvider()) {
        self.capabilities = capabilities
        self.orientationProvider = orientationProvider
        super.init()
        session.delegate = self
        session.delegateQueue = .main
    }

    func start(viewport: GazeViewport) {
        guard capabilities.supportsFaceTracking else {
            state = .unavailable(.faceTrackingUnsupported)
            return
        }
        self.viewport = viewport
        let configuration = Self.makeConfiguration()
        self.configuration = configuration
        state = .starting
        logger.info("start viewport \(viewport.bounds.width, format: .fixed(precision: 0))x\(viewport.bounds.height, format: .fixed(precision: 0)) orientation \(self.orientationProvider.interfaceOrientation.irisName, privacy: .public)")
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    func pause() {
        guard configuration != nil else { return }
        session.pause()
        state = .idle
    }

    func resume() {
        guard viewport != nil else { return }
        let configuration = self.configuration ?? Self.makeConfiguration()
        self.configuration = configuration
        state = .starting
        session.run(configuration, options: [])
    }

    func stop() {
        session.pause()
        configuration = nil
        latestSample = nil
        state = .idle
    }

    func updateViewport(_ viewport: GazeViewport) {
        self.viewport = viewport
    }

    private static func makeConfiguration() -> ARFaceTrackingConfiguration {
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = false
        configuration.maximumNumberOfTrackedFaces = 1
        if let format = ARFaceTrackingConfiguration.supportedVideoFormats.first(where: { $0.framesPerSecond >= 60 }) {
            configuration.videoFormat = format
        }
        return configuration
    }

    // MARK: Frame processing

    private func process(_ frame: ARFrame) {
        guard viewport != nil else { return }
        guard let face = frame.anchors.lazy.compactMap({ $0 as? ARFaceAnchor }).first(where: \.isTracked) else {
            state = .tracking(faceVisible: false)
            return
        }
        let orientation = orientationProvider.interfaceOrientation.resolvedForGaze
        let view = frame.camera.viewMatrix(for: orientation)
        let anchorToView = view * face.transform

        let leftEye = Self.point(anchorToView * face.leftEyeTransform.columns.3)
        let rightEye = Self.point(anchorToView * face.rightEyeTransform.columns.3)
        let eyeOrigin = (leftEye + rightEye) * 0.5
        let lookAt = face.lookAtPoint
        let lookAtView = Self.point(anchorToView * SIMD4<Float>(lookAt.x, lookAt.y, lookAt.z, 1))

        let eyeLine = rightEye - leftEye
        let userRight = SIMD2(eyeLine.x, eyeLine.y)
        let userRightUnit = simd_length(userRight) > 1e-9 ? simd_normalize(userRight) : SIMD2<Double>(0, 0)

        // World +y is up (gravity alignment); expressed in the view frame and projected on the device plane.
        let upInView = view * SIMD4<Float>(0, 1, 0, 0)
        let deviceUp = SIMD2(Double(upInView.x), Double(upInView.y))

        // Face-derived fallback: right x forward, forward being the direction from the eyes to the camera.
        let forward = simd_length(eyeOrigin) > 1e-6 ? simd_normalize(-eyeOrigin) : SIMD3<Double>(0, 0, 1)
        let rightUnit3D = simd_length(eyeLine) > 1e-9 ? simd_normalize(eyeLine) : SIMD3<Double>(1, 0, 0)
        let faceUp3D = simd_cross(rightUnit3D, forward)
        let faceUp = SIMD2(faceUp3D.x, faceUp3D.y)

        let blendShapes = face.blendShapes
        let blinkLeft = blendShapes[.eyeBlinkLeft]?.doubleValue ?? 0
        let blinkRight = blendShapes[.eyeBlinkRight]?.doubleValue ?? 0

        let sample = RawGazeSample(timestamp: frame.timestamp,
                                   planeHit: GazeRay.planeHit(eyeOrigin: eyeOrigin, lookAt: lookAtView),
                                   eyeOrigin: eyeOrigin,
                                   eyeSeparation: simd_length(eyeLine),
                                   userRight: userRightUnit,
                                   deviceUp: deviceUp,
                                   faceUp: faceUp,
                                   blinkLeft: blinkLeft,
                                   blinkRight: blinkRight,
                                   hasBlendShapes: !blendShapes.isEmpty,
                                   observation: Self.observation(anchorToView: anchorToView, leftEye: leftEye, rightEye: rightEye, lookAt: lookAtView))
        latestSample = sample
        state = .tracking(faceVisible: true)
        onSample?(sample)
    }

    private static func point(_ vector: SIMD4<Float>) -> SIMD3<Double> {
        SIMD3(Double(vector.x), Double(vector.y), Double(vector.z))
    }

    private func handleFailure(_ error: any Error) {
        if let arError = error as? ARError {
            switch arError.code {
            case .cameraUnauthorized:
                state = .unavailable(.cameraDenied)
                return
            case .unsupportedConfiguration:
                state = .unavailable(.faceTrackingUnsupported)
                return
            default:
                break
            }
        }
        logger.error("AR session failed: \(error.localizedDescription, privacy: .public)")
        state = .failed(message: error.localizedDescription)
    }
}

extension ARKitGazeTrackingService: ARSessionDelegate {
    nonisolated func session(_ session: ARSession, didUpdate frame: ARFrame) {
        MainActor.assumeIsolated { process(frame) }
    }

    nonisolated func session(_ session: ARSession, didFailWithError error: any Error) {
        MainActor.assumeIsolated { handleFailure(error) }
    }

    nonisolated func sessionWasInterrupted(_ session: ARSession) {
        MainActor.assumeIsolated { state = .interrupted }
    }

    nonisolated func sessionInterruptionEnded(_ session: ARSession) {
        MainActor.assumeIsolated { state = .starting }
    }
}
