// FixationSequence.swift
// Layer: AR (calibration, pure Swift)
// Purpose: Time-based target sequence: settle, collect usable samples, aggregate robustly, retry once, move on

import Foundation
import simd

enum FixationFailure: Hashable, Sendable {
    case insufficientSamples(target: Int)
}

enum FixationEvent: Hashable, Sendable {
    case targetChanged(index: Int)
    case targetMeasured(index: Int)
    case completed
    case failed(FixationFailure)
}

struct FixationSequence: Hashable, Sendable {
    struct Configuration: Hashable, Sendable {
        /// Time to let the eyes travel to the new target before collecting.
        var settleDuration: TimeInterval = 0.3
        /// Nominal collection window per target.
        var collectDuration: TimeInterval = 0.8
        /// Valid samples needed after outlier rejection.
        var minimumSamples: Int = 12
        /// Collection keeps going past `collectDuration` up to this bound when samples are missing (blinks).
        var maximumCollectDuration: TimeInterval = 2.5
        var maximumRetries: Int = 1

        init() {}
    }

    enum Stage: Hashable, Sendable {
        case idle
        case settling(target: Int)
        case collecting(target: Int)
        case completed
        case failed(FixationFailure)
    }

    let targets: [SIMD2<Double>]
    let configuration: Configuration
    private(set) var stage: Stage = .idle
    private(set) var measurements: [Int: RobustAggregator.Result] = [:]
    private var stageStart: TimeInterval?
    private var buffer: [SIMD2<Double>] = []
    private var retries: [Int: Int] = [:]

    init(targets: [SIMD2<Double>], configuration: Configuration = Configuration()) {
        self.targets = targets
        self.configuration = configuration
    }

    var currentTargetIndex: Int? {
        switch stage {
        case let .settling(target), let .collecting(target): target
        case .idle, .completed, .failed: nil
        }
    }

    var currentTarget: SIMD2<Double>? {
        currentTargetIndex.map { targets[$0] }
    }

    var isCollecting: Bool {
        if case .collecting = stage { return true }
        return false
    }

    var isFinished: Bool {
        switch stage {
        case .completed, .failed: true
        case .idle, .settling, .collecting: false
        }
    }

    /// 0...1 progress of the current target (settling counts for nothing, collection fills the ring).
    func progress(at time: TimeInterval) -> Double {
        guard case .collecting = stage, let stageStart else { return 0 }
        return min(max((time - stageStart) / configuration.collectDuration, 0), 1)
    }

    /// Raw -> target pairs of every measured target, in target order.
    var pairs: [(raw: SIMD2<Double>, target: SIMD2<Double>)] {
        measurements.keys.sorted().map { (measurements[$0]?.center ?? SIMD2(0, 0), targets[$0]) }
    }

    mutating func start(at time: TimeInterval) -> FixationEvent? {
        guard !targets.isEmpty else {
            stage = .completed
            return .completed
        }
        stage = .settling(target: 0)
        stageStart = time
        buffer.removeAll(keepingCapacity: true)
        return .targetChanged(index: 0)
    }

    /// Feeds one observation. `sample` is nil when the tracker produced nothing; `isUsable` is false during blinks.
    mutating func feed(sample: SIMD2<Double>?, isUsable: Bool, at time: TimeInterval) -> FixationEvent? {
        switch stage {
        case .idle:
            return start(at: time)
        case let .settling(target):
            guard let stageStart else { return nil }
            if time - stageStart >= configuration.settleDuration {
                stage = .collecting(target: target)
                self.stageStart = time
                buffer.removeAll(keepingCapacity: true)
            }
            return nil
        case let .collecting(target):
            guard let stageStart else { return nil }
            if isUsable, let sample, NormalizedCoordinates.isFinite(sample) {
                buffer.append(sample)
            }
            let elapsed = time - stageStart
            guard elapsed >= configuration.collectDuration else { return nil }
            if let result = RobustAggregator.aggregate(buffer, minimumAccepted: configuration.minimumSamples) {
                measurements[target] = result
                return advance(from: target, at: time)
            }
            if elapsed < configuration.maximumCollectDuration {
                return nil
            }
            let attempts = retries[target, default: 0]
            if attempts < configuration.maximumRetries {
                retries[target] = attempts + 1
                stage = .settling(target: target)
                self.stageStart = time
                buffer.removeAll(keepingCapacity: true)
                return .targetChanged(index: target)
            }
            stage = .failed(.insufficientSamples(target: target))
            return .failed(.insufficientSamples(target: target))
        case .completed, .failed:
            return nil
        }
    }

    private mutating func advance(from target: Int, at time: TimeInterval) -> FixationEvent {
        let next = target + 1
        if next < targets.count {
            stage = .settling(target: next)
            stageStart = time
            buffer.removeAll(keepingCapacity: true)
            return .targetChanged(index: next)
        }
        stage = .completed
        return .completed
    }
}
