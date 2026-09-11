// GazeReadinessEvaluator.swift
// Layer: AR (calibration, pure Swift)
// Purpose: Checks that the gaze signal is usable before calibrating: face, eyes, direction, stability, blinks, axes

import Foundation
import simd

struct GazeReadinessEvaluator: Hashable, Sendable {
    struct Configuration: Hashable, Sendable {
        var windowDuration: TimeInterval = 1.2
        var minimumSamples = 20
        var minimumHitRatio = 0.8
        var distanceRange: ClosedRange<Double> = 0.15...0.9
        var eyeSeparationRange: ClosedRange<Double> = 0.04...0.10
        /// RMS deviation of the eye midpoint over the window (metres).
        var maximumHeadDeviation = 0.02
        /// RMS deviation of the nominal normalized gaze over the window while looking at a fixed point.
        var maximumSignalDeviation = 0.10
        var minimumAxisConfidence = 0.8

        init() {}
    }

    let configuration: Configuration
    private var window: [RawGazeSample] = []
    private var axisVote = AxisVote()
    private var blinkDetector = BlinkDetector()

    init(configuration: Configuration = Configuration()) {
        self.configuration = configuration
    }

    var sampleCount: Int { window.count }

    mutating func reset() {
        window.removeAll()
        axisVote.reset()
    }

    mutating func ingest(_ sample: RawGazeSample) {
        window.append(sample)
        let cutoff = sample.timestamp - configuration.windowDuration
        window.removeAll { $0.timestamp < cutoff }
        if let mapping = sample.suggestedAxisMapping {
            axisVote.add(mapping)
        }
    }

    func report(supportsFaceTracking: Bool, cameraAuthorized: Bool, trackingState: GazeTrackingState,
                nominal: NominalDisplayGeometry, viewport: PlayfieldBounds) -> GazeReadinessReport {
        var checks: [ReadinessCheck] = []
        checks.append(ReadinessCheck(kind: .faceTracking, status: supportsFaceTracking ? .pass : .fail,
                                     detail: supportsFaceTracking ? "Suivi facial ARKit disponible" : "Appareil sans suivi facial"))
        checks.append(ReadinessCheck(kind: .cameraAccess, status: cameraAuthorized ? .pass : .fail,
                                     detail: cameraAuthorized ? "Autorisé" : "Refusé ou restreint"))

        let sessionStatus: ReadinessStatus
        let sessionDetail: String
        switch trackingState {
        case .tracking: sessionStatus = .pass; sessionDetail = "Frames reçues"
        case .starting, .idle: sessionStatus = .pending; sessionDetail = "Démarrage"
        case .interrupted: sessionStatus = .fail; sessionDetail = "Session interrompue"
        case .unavailable: sessionStatus = .fail; sessionDetail = "Indisponible"
        case .failed: sessionStatus = .fail; sessionDetail = "Erreur"
        }
        checks.append(ReadinessCheck(kind: .session, status: sessionStatus, detail: sessionDetail))

        let faceVisible: Bool
        if case .tracking(true) = trackingState { faceVisible = true } else { faceVisible = false }
        let enough = window.count >= configuration.minimumSamples
        checks.append(ReadinessCheck(kind: .faceDetected, status: faceVisible && enough ? .pass : .pending,
                                     detail: faceVisible ? (enough ? "Visage suivi" : "Un instant…") : "Placez votre visage face à l'écran"))

        guard enough else {
            for kind in [ReadinessCheckKind.eyeTracking, .gazeDirection, .headStable, .signalStable, .blinkDetection, .axisMapping] {
                checks.append(ReadinessCheck(kind: kind, status: .pending, detail: "En attente du signal"))
            }
            return GazeReadinessReport(checks: checks, axisMapping: axisVote.majority, axisConfidence: axisVote.confidence, sampleCount: window.count)
        }

        let distances = window.map(\.faceDistance)
        let separations = window.map(\.eyeSeparation)
        let medianDistance = RobustAggregator.median(distances)
        let medianSeparation = RobustAggregator.median(separations)
        let eyesValid = medianSeparation.isFinite && configuration.eyeSeparationRange.contains(medianSeparation)
            && medianDistance.isFinite && configuration.distanceRange.contains(medianDistance)
        checks.append(ReadinessCheck(kind: .eyeTracking, status: eyesValid ? .pass : .fail,
                                     detail: eyesValid ? String(format: "Distance %.0f cm", medianDistance * 100)
                                                       : "Rapprochez-vous ou éloignez-vous de l'écran (20 à 80 cm)"))

        let hits = window.compactMap { sample -> SIMD2<Double>? in
            sample.planeHit.map { hit in
                let offsets = AxisMapping.standard.screenCoordinates(of: hit)
                return nominal.normalized(right: offsets.x, up: offsets.y, viewport: viewport)
            }
        }
        let hitRatio = Double(hits.count) / Double(window.count)
        checks.append(ReadinessCheck(kind: .gazeDirection, status: hitRatio >= configuration.minimumHitRatio ? .pass : .fail,
                                     detail: hitRatio >= configuration.minimumHitRatio ? "Regard dirigé vers l'écran" : "Regardez l'écran"))

        let headDeviation = Self.rmsDeviation(window.map { SIMD2($0.eyeOrigin.x, $0.eyeOrigin.y) })
        let headStable = headDeviation <= configuration.maximumHeadDeviation
        checks.append(ReadinessCheck(kind: .headStable, status: headStable ? .pass : .pending,
                                     detail: headStable ? "Tête immobile" : "Gardez la tête immobile"))

        let signalDeviation = Self.rmsDeviation(hits)
        let signalStable = hits.count >= configuration.minimumSamples / 2 && signalDeviation <= configuration.maximumSignalDeviation
        checks.append(ReadinessCheck(kind: .signalStable, status: signalStable ? .pass : .pending,
                                     detail: signalStable ? "Signal régulier" : "Fixez le point au centre"))

        let blinksAvailable = window.allSatisfy(\.hasBlendShapes)
        checks.append(ReadinessCheck(kind: .blinkDetection, status: blinksAvailable ? .pass : .fail,
                                     detail: blinksAvailable ? "Les clignements seront ignorés" : "Blend shapes indisponibles"))

        let mapping = axisVote.majority
        let axisOK = mapping != nil && axisVote.confidence >= configuration.minimumAxisConfidence
        checks.append(ReadinessCheck(kind: .axisMapping, status: axisOK ? .pass : .pending,
                                     detail: axisOK ? "Axes résolus (\(Self.describe(mapping)))" : "Tenez l'iPhone droit devant vous"))

        return GazeReadinessReport(checks: checks, axisMapping: mapping, axisConfidence: axisVote.confidence, sampleCount: window.count)
    }

    static func rmsDeviation(_ points: [SIMD2<Double>]) -> Double {
        guard !points.isEmpty else { return .infinity }
        let mean = points.reduce(SIMD2<Double>(0, 0), +) / Double(points.count)
        let squared = points.reduce(0.0) { $0 + simd_length_squared($1 - mean) }
        return (squared / Double(points.count)).squareRoot()
    }

    static func describe(_ mapping: AxisMapping?) -> String {
        guard let mapping else { return "?" }
        return "droite = \(mapping.right.rawValue), haut = \(mapping.up.rawValue)"
    }
}
