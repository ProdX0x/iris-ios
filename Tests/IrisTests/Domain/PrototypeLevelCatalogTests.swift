// PrototypeLevelCatalogTests.swift
// Layer: Tests
// Purpose: R-12 progression data: fourteen levels, target counts, difficulty curve and exact reference geometry

import Testing
@testable import Iris

@Suite("PrototypeLevelCatalog")
struct LevelCatalogTests {
    @Test("exactly fourteen levels, numbered 1 to 14")
    func fourteenLevels() {
        #expect(PrototypeLevelCatalog.all.count == 14)
        #expect(PrototypeLevelCatalog.levelCount == 14)
        #expect(PrototypeLevelCatalog.all.map(\.number) == Array(1...14))
        #expect(PrototypeLevelCatalog.all[0].id.raw == "level_01")
        #expect(PrototypeLevelCatalog.all[13].id.raw == "level_14")
    }

    @Test("levels 1-3 have one target, 4-8 two, 9-14 three")
    func targetCounts() {
        for level in PrototypeLevelCatalog.all {
            let expected = level.number <= 3 ? 1 : (level.number <= 8 ? 2 : 3)
            #expect(level.targetCount == expected, "level \(level.number)")
            #expect(level.isSequential == (expected > 1))
            #expect(level.targets.map(\.sequence) == Array(1...expected))
        }
    }

    @Test("difficulty parameters follow the reference bands with the 1.6 gaze multiplier")
    func difficultyBands() {
        let first = PrototypeLevelCatalog.all[0].targets[0]
        #expect(first.attentionZone == 220 * 1.6)
        #expect(first.repulsionGain == 0.008)
        #expect(first.passiveAttraction == 0.6)

        let middle = PrototypeLevelCatalog.all[5].targets[1]
        #expect(middle.attentionZone == 190 * 1.6)
        #expect(middle.repulsionGain == 0.009)
        #expect(middle.passiveAttraction == 0.55)

        let last = PrototypeLevelCatalog.all[13].targets[2]
        #expect(last.attentionZone == 150 * 1.6)
        #expect(last.repulsionGain == 0.013)
        #expect(last.passiveAttraction == 0.5)
        #expect(last.noiseAmplitude == 0.15)
    }

    @Test("difficulty increases: attention zone never grows, repulsion never shrinks")
    func difficultyIsMonotonic() {
        let levels = PrototypeLevelCatalog.all
        for index in 1..<levels.count {
            #expect(levels[index].targets[0].attentionZone <= levels[index - 1].targets[0].attentionZone)
            #expect(levels[index].targets[0].repulsionGain >= levels[index - 1].targets[0].repulsionGain)
            #expect(levels[index].targetCount >= levels[index - 1].targetCount)
        }
        #expect(levels[0].targets[0].attentionZone > levels[13].targets[0].attentionZone)
        #expect(levels[0].targets[0].repulsionGain < levels[13].targets[0].repulsionGain)
    }

    @Test("hold duration is 0.75 s (45 frames at 60 Hz) on every level")
    func holdDuration() {
        for level in PrototypeLevelCatalog.all {
            #expect(abs(level.holdDuration - 0.75) < 1e-12)
        }
    }

    @Test("spawn and arrival points stay inside the 0.2 margin")
    func pointsInsideMargin() {
        for level in PrototypeLevelCatalog.all {
            for target in level.targets {
                for point in [target.start, target.arrival] {
                    #expect(point.x >= 0.2 && point.x <= 0.8)
                    #expect(point.y >= 0.2 && point.y <= 0.8)
                }
            }
        }
    }

    @Test("level 1 and level 9 geometry equals the reference generator output")
    func exactGeometry() {
        let level1 = PrototypeLevelCatalog.all[0].targets[0]
        #expect(abs(level1.start.x - 0.7714429012345678) < 1e-12)
        #expect(abs(level1.start.y - 0.5172170781893004) < 1e-12)
        #expect(abs(level1.arrival.x - 0.5628369341563786) < 1e-12)
        #expect(abs(level1.arrival.y - 0.6731172839506172) < 1e-12)

        let level9 = PrototypeLevelCatalog.all[8].targets
        #expect(abs(level9[0].start.x - 0.7351671810699587) < 1e-12)
        #expect(abs(level9[1].arrival.x - 0.24083076131687242) < 1e-12)
        #expect(abs(level9[2].arrival.y - 0.5147633744855967) < 1e-12)
    }
}
