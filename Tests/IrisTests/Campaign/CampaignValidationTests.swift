// CampaignValidationTests.swift
// Layer: Tests
// Purpose: LEVEL_DESIGN_SYSTEM.md section 6: structure, validity, feasibility, necessity, par, difference, mastery

import Foundation
import Testing
@testable import Iris

@Suite("Campaign structure and validity")
struct CampaignStructureTests {
    @Test("six chapters of 5, 5, 6, 6, 6, 6 levels, unique ids and titles, numbered in order")
    func structure() {
        #expect(Campaign.chapters.map(\.levels.count) == [5, 5, 6, 6, 6, 6])
        #expect(Campaign.levels.count == 34)
        #expect(Set(Campaign.levels.map(\.id)).count == 34)
        #expect(Set(Campaign.levels.map(\.title)).count == 34)
        for chapter in Campaign.chapters {
            #expect(chapter.levels.map(\.index) == Array(1...chapter.levels.count))
            #expect(chapter.levels.allSatisfy { $0.chapter == chapter.number })
        }
        #expect(Campaign.chapters.map(\.numeral) == ["I", "II", "III", "IV", "V", "VI"])
    }

    @Test("rule 1: chapters III to VI open with a single lueur introducing their element")
    func introductions() {
        let expected: [Int: GameElement] = [3: .courant, 4: .voile, 5: .veilleuse, 6: .irisMouvant]
        for (number, element) in expected {
            guard let first = Campaign.chapter(number: number)?.levels.first else {
                Issue.record("missing chapter \(number)")
                continue
            }
            #expect(first.lueurs.count == 1, "\(first.id)")
            #expect(first.introduces.contains(element), "\(first.id)")
            #expect(first.elementKinds == [element], "\(first.id)")
        }
    }

    @Test("rules 2 and 3: at most two element kinds outside chapter VI, bounded counts, iris motion only in chapter VI")
    func combination() {
        for level in Campaign.levels {
            if level.chapter < 6 {
                #expect(level.elementKinds.count <= 2, "\(level.id)")
                #expect(!level.elementKinds.contains(.irisMouvant), "\(level.id)")
            }
            #expect((1...3).contains(level.lueurs.count), "\(level.id)")
            #expect(level.currents.count <= 2 && level.veils.count <= 3 && level.veilleuses.count <= 2, "\(level.id)")
            #expect(level.hold == 0.75, "\(level.id)")
            #expect((0.40...0.52).contains(level.zone), "\(level.id)")
            #expect((1.6...3.2).contains(level.repulsionForce), "\(level.id)")
            #expect(level.currents.allSatisfy { (0.7...1.0).contains($0.strength) }, "\(level.id)")
        }
    }

    @Test("rules 4 to 7: positions in the field, irises out of currents, starts away from irises, veils clear, flames on screen")
    func geometry() {
        let bounds = CampaignBot.referenceBounds
        let shortSide = min(bounds.width, bounds.height)
        for level in Campaign.levels {
            for lueur in level.lueurs {
                for point in [lueur.start, lueur.iris] + lueur.route {
                    #expect((0.1...0.9).contains(point.x) && (0.08...0.92).contains(point.y), "\(level.id) point \(point)")
                }
                #expect(lueur.start.absolute(in: bounds).distance(to: lueur.iris.absolute(in: bounds)) >= shortSide * 0.25, "\(level.id) start too close")
                #expect(level.currents.allSatisfy { !$0.area.contains(lueur.iris) }, "\(level.id) iris in a current")
                if case let .oscillate(to, _) = lueur.irisMotion {
                    #expect(level.currents.allSatisfy { !$0.area.contains(to) }, "\(level.id) moving iris in a current")
                }
                for veil in level.veils {
                    let segment = VeilSegment(a: veil.a.absolute(in: bounds), b: veil.b.absolute(in: bounds), halfThickness: 3)
                    #expect(segment.distance(to: lueur.start.absolute(in: bounds)) > 30, "\(level.id) start on a veil")
                    #expect(segment.distance(to: lueur.iris.absolute(in: bounds)) > 30, "\(level.id) iris on a veil")
                }
            }
            for flame in level.veilleuses {
                let radius = flame.lookRadius * shortSide
                let position = flame.position.absolute(in: bounds)
                #expect(position.x - radius >= 0 && position.x + radius <= bounds.width, "\(level.id) flame off screen")
                #expect(position.y - radius >= 0 && position.y + radius <= bounds.height, "\(level.id) flame off screen")
                #expect(flame.linked.allSatisfy { (1...level.lueurs.count).contains($0) }, "\(level.id) flame linked to nothing")
            }
            for veil in level.veils {
                let length = veil.a.absolute(in: bounds).distance(to: veil.b.absolute(in: bounds))
                #expect(length >= bounds.width * 0.2, "\(level.id) veil too short")
            }
        }
    }

    @Test("every level resolves on phone and tablet viewports with finite values")
    func resolvesEverywhere() {
        for bounds in [PlayfieldBounds(width: 375, height: 812), PlayfieldBounds(width: 430, height: 932), PlayfieldBounds(width: 834, height: 1194)] {
            for level in Campaign.levels {
                let resolved = LevelResolver.resolve(level, in: bounds)
                #expect(resolved.level.targets.allSatisfy { $0.attentionZone.isFinite && $0.repulsionGain.isFinite && $0.repulsionGain > 0 })
                #expect(resolved.environment.requiresAttentionOnField)
            }
        }
    }

    @Test("navigation helpers")
    func helpers() {
        #expect(Campaign.level(id: "3-2")?.title == "la brèche")
        #expect(Campaign.next(after: Campaign.levels[4])?.id == "2-1")
        #expect(Campaign.next(after: Campaign.levels[33]) == nil)
        #expect(Campaign.isLastInChapter(Campaign.levels[4]))
        #expect(!Campaign.isLastInChapter(Campaign.levels[0]))
    }
}

@Suite("Campaign simulation")
struct CampaignSimulationTests {
    @Test("feasibility: the noisy guided player completes every level with three seeds within 90 s")
    func feasibility() {
        for level in Campaign.levels {
            let measurement = CampaignMeasurements.of(level)
            let solved = measurement.guided.allSatisfy { $0.completed }
            #expect(solved, "\(level.id) not solved by the guided player")
        }
    }

    @Test("necessity: avoidance suffices in chapters I and II, pushing is required wherever a route exists")
    func pushingNecessity() {
        for level in Campaign.levels {
            let measurement = CampaignMeasurements.of(level)
            if level.chapter <= 2 {
                #expect(measurement.avoidance.completed, "\(level.id) should be solvable by avoidance")
            }
            if level.requiresPushing {
                #expect(!measurement.avoidance.completed, "\(level.id) solvable without pushing")
            }
        }
    }

    @Test("necessity: a player blind to veilleuses fails every level that has one")
    func vigilanceNecessity() {
        for level in Campaign.levels where !level.veilleuses.isEmpty {
            #expect(CampaignMeasurements.of(level).ignoresVeilleuses?.completed == false, "\(level.id) solvable without looking at the flame")
        }
    }

    @Test("R-23: looking above the phone never completes a level")
    func offScreen() {
        for level in Campaign.levels {
            #expect(!CampaignMeasurements.of(level).offScreen.completed, "\(level.id) solvable off screen")
        }
    }

    @Test("par values keep the éclats reachable yet demanding")
    func pars() {
        for level in Campaign.levels {
            let measurement = CampaignMeasurements.of(level)
            #expect(level.par.time >= measurement.guidedTime * 1.4, "\(level.id) par time too tight")
            #expect(level.par.time <= measurement.guidedTime * 3 + 10, "\(level.id) par time too loose")
            #expect(Double(level.par.intrusions) >= measurement.guidedIntrusions.rounded(.up) + 1, "\(level.id) par intrusions too tight")
        }
    }

    @Test("difference: two levels of the same chapter differ on at least two criteria")
    func difference() {
        for chapter in Campaign.chapters {
            let signatures = chapter.levels.map { LevelAnalysis($0).signature(botTime: CampaignMeasurements.of($0).guidedTime) }
            for i in signatures.indices {
                for j in signatures.indices where j > i {
                    let differences = LevelAnalysis.differences(signatures[i], signatures[j])
                    #expect(differences.count >= 2, "\(chapter.levels[i].id) vs \(chapter.levels[j].id) differ only on \(differences)")
                }
            }
        }
    }

    @Test("mastery: the last level of each chapter has the highest difficulty estimate of its chapter")
    func mastery() {
        for chapter in Campaign.chapters {
            let estimates = chapter.levels.map { LevelAnalysis($0).difficulty(botTime: CampaignMeasurements.of($0).guidedTime) }
            guard let last = estimates.last else { continue }
            let dominated = estimates.dropLast().allSatisfy { $0 < last }
            #expect(dominated, "chapter \(chapter.number): \(estimates)")
        }
    }
}
