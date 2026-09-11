// LevelCatalog.swift
// Layer: Domain
// Purpose: The fourteen levels, generated exactly like the reference engine (same seeds, same order of draws)

import Foundation

enum LevelCatalog {
    static let levelCount = 14
    /// `GAZE_ZONE_MULTIPLIER`: compensates gaze imprecision compared with a mouse cursor.
    static let gazeZoneMultiplier = 1.6
    /// `hold_time_frames = 45` at the 60 Hz reference rate.
    static let holdDuration: TimeInterval = 45.0 / 60.0
    /// `amplitude_bruit`
    static let noiseAmplitude = 0.15
    /// `randomPoint(rng, margin = 0.2)`
    static let spawnMargin = 0.2
    /// `rngFor(2000 + n * 97)`
    static let seedBase = 2000
    static let seedStride = 97

    static let all: [Level] = (0..<levelCount).map(level(at:))

    static func level(at index: Int) -> Level {
        let difficulty = LevelDifficulty.band(forLevelIndex: index)
        var generator = LinearCongruentialGenerator(seed: seedBase + index * seedStride)
        var targets: [TargetBlueprint] = []
        for targetIndex in 0..<difficulty.targetCount {
            let start = randomPoint(&generator)
            let arrival = randomPoint(&generator)
            targets.append(TargetBlueprint(sequence: targetIndex + 1,
                                           start: start,
                                           arrival: arrival,
                                           attentionZone: difficulty.baseAttentionZone * gazeZoneMultiplier,
                                           repulsionGain: difficulty.repulsionGain,
                                           passiveAttraction: difficulty.passiveAttraction,
                                           noiseAmplitude: noiseAmplitude))
        }
        return Level(id: LevelID(number: index + 1),
                     number: index + 1,
                     targets: targets,
                     holdDuration: holdDuration,
                     isSequential: difficulty.targetCount > 1)
    }

    private static func randomPoint(_ generator: inout LinearCongruentialGenerator) -> NormalizedPoint {
        let x = spawnMargin + generator.next() * (1 - 2 * spawnMargin)
        let y = spawnMargin + generator.next() * (1 - 2 * spawnMargin)
        return NormalizedPoint(x: x, y: y)
    }
}
