// JardinStageState.swift
// Layer: GameEngine
// Purpose: Chapter VI final: batches of breathing seeds among twinkling ones; a rest on a breathing seed sprouts it,
// lingering on a twinkling seed folds the batch's sprouts back; the explored seeds are counted for the trace

import Foundation

struct JardinStageState: Hashable, Sendable {
    let seeds: [Vector2]
    let batches: [[Int]]
    let radius: Double
    let releaseRadius: Double
    let dwell: TimeInterval
    let lingerDwell: TimeInterval
    private(set) var batchIndex = 0
    /// Sprouts of the current batch, and sprouts of completed batches (they stay).
    private(set) var found: Set<Int> = []
    private(set) var garden: [Int] = []
    private(set) var dwellingOn: Int?
    private(set) var dwellTime: TimeInterval = 0
    /// Seeds the gaze came to rest on at least once (exploration coverage, DEBUG only).
    private(set) var visited: Set<Int> = []
    private(set) var folds = 0
    private(set) var completedAt: TimeInterval?
    /// The twinkling seed that already folded the batch during the current rest (it folds once per rest).
    private var blamed: Int?

    init(definition: JardinDefinition, bounds: PlayfieldBounds, shortSide: Double) {
        seeds = definition.seeds.map { $0.absolute(in: bounds) }
        batches = definition.batches
        radius = definition.radius * shortSide
        releaseRadius = definition.releaseRadius * shortSide
        dwell = definition.dwell
        lingerDwell = definition.lingerDwell
        if batches.isEmpty { completedAt = 0 }
    }

    var isComplete: Bool { completedAt != nil }
    var currentBatch: [Int] { batches.indices.contains(batchIndex) ? batches[batchIndex] : [] }
    var missing: [Int] { currentBatch.filter { !found.contains($0) } }
    var totalTargets: Int { batches.reduce(0) { $0 + $1.count } }
    var progress: Double { totalTargets == 0 ? 1 : Double(garden.count + found.count) / Double(totalTargets) }

    func isBreathing(_ seed: Int) -> Bool { currentBatch.contains(seed) && !found.contains(seed) }
    func isSprouted(_ seed: Int) -> Bool { garden.contains(seed) || found.contains(seed) }

    mutating func update(_ input: OculoInput) -> OculoOutcome {
        var outcome = OculoOutcome()
        guard !isComplete, input.gazeActive else { return outcome }
        if let on = dwellingOn, input.gaze.distance(to: seeds[on]) <= releaseRadius {
            dwellTime += input.seconds
        } else {
            dwellingOn = seeds.indices.first { input.gaze.distance(to: seeds[$0]) <= radius }
            dwellTime = dwellingOn == nil ? 0 : input.seconds
            blamed = nil
        }
        guard let on = dwellingOn else { return outcome }
        if dwellTime >= dwell - 1e-9 { visited.insert(on) }
        if isBreathing(on), dwellTime >= dwell - 1e-9 {
            found.insert(on)
            outcome.changes.append(.success)
            dwellingOn = nil
            dwellTime = 0
            if missing.isEmpty {
                garden += currentBatch
                found = []
                batchIndex += 1
                if batchIndex >= batches.count {
                    completedAt = input.elapsed
                    outcome.changes.append(.completed)
                }
            }
        } else if !isSprouted(on), !currentBatch.contains(on), dwellTime >= lingerDwell - 1e-9, blamed != on {
            blamed = on
            folds += 1
            found = []
            outcome.changes.append(.miss)
        }
        return outcome
    }

    /// The ideal player goes straight to a breathing seed.
    var suggestedGaze: Vector2? {
        missing.first.map { seeds[$0] }
    }
}
