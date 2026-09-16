// AccessGatingTests.swift
// Layer: Tests
// Purpose: The eight journeys of the commercial model as the coordinator plays them out: the free chapters open, a
// locked chapter leads to the full access screen instead of the game, the game asks before moving on by itself, and
// a right that ends never takes the player's progression with it

import Foundation
import Testing
@testable import Iris

@Suite("Access gating")
@MainActor
struct AccessGatingTests {
    private func makeSUT(entitlement: AccessEntitlement = .free,
                         progressed: Bool = true,
                         hasCompletedOnboarding: Bool = true) -> (AppCoordinator, StaticEntitlementService) {
        let store = StaticEntitlementService(entitlement: entitlement)
        let progress = progressed
            ? InMemoryProgressStore(progress: LaunchOptions.progress(for: .all))
            : InMemoryProgressStore()
        let container = AppContainer.preview(progressStore: progress, store: store, hasCompletedOnboarding: hasCompletedOnboarding)
        return (container.makeAppCoordinator(), store)
    }

    private func level(inChapter number: Int) -> LevelDefinition {
        guard let level = Campaign.chapter(number: number)?.levels.first else { preconditionFailure("missing chapter \(number)") }
        return level
    }

    // MARK: Cases 1 and 2

    @Test("CASE 1 and 2: a free player opens chapters I to III and is sent to the full access screen for IV")
    func freePlayer() {
        let (sut, _) = makeSUT()
        #expect(sut.entitlement == .free)
        for number in 1...3 {
            #expect(sut.isAccessible(level(inChapter: number)), "chapter \(number)")
            #expect(sut.isPlayable(level(inChapter: number)))
        }
        for number in [4, 12] {
            #expect(!sut.isAccessible(level(inChapter: number)), "chapter \(number)")
            #expect(!sut.isPlayable(level(inChapter: number)))
        }

        sut.play(level(inChapter: 4))
        #expect(sut.sheet == .paywall)
        #expect(sut.paywallChapter?.number == 4)
        #expect(sut.route == .home, "the game must not start")
    }

    @Test("a free player starting chapter I really goes to the game path, not to the full access screen")
    func freePlayerPlaysFreeChapter() {
        let (sut, _) = makeSUT(progressed: false)
        sut.play(level(inChapter: 1))
        #expect(sut.sheet == nil)
        #expect(sut.route == .gazeSetup(.firstRun))
    }

    // MARK: Cases 3, 4, 5, 7 and 8

    @Test("CASE 3 and 4: the permanent right opens every chapter, whether bought or restored")
    func fullAccess() {
        let (sut, _) = makeSUT(entitlement: .fullAccess)
        for chapter in Campaign.chapters {
            #expect(sut.isAccessible(chapter), "chapter \(chapter.number)")
        }
        sut.play(level(inChapter: 12))
        #expect(sut.sheet == nil)
        #expect(sut.route == .gazeSetup(.firstRun) || sut.route == .game)
    }

    @Test("CASE 5: a valid promotional access opens every chapter for as long as it lasts")
    func promotionalAccess() {
        let (sut, _) = makeSUT(entitlement: .promotionalAccess)
        for chapter in Campaign.chapters {
            #expect(sut.isAccessible(chapter), "chapter \(chapter.number)")
        }
        sut.play(level(inChapter: 8))
        #expect(sut.sheet == nil)
    }

    @Test("CASE 6 and 7: when a promotional access ends the chapters lock again and the progression is untouched")
    func promotionalAccessEnds() {
        let (sut, store) = makeSUT(entitlement: .promotionalAccess)
        let reached = sut.progress.completedCount(in: Campaign.levels)
        let eclats = sut.progress.eclatCount(in: Campaign.levels)
        #expect(reached > 0)

        store.simulate(.free)

        #expect(sut.entitlement == .free)
        #expect(sut.progress.completedCount(in: Campaign.levels) == reached, "the progression was taken away")
        #expect(sut.progress.eclatCount(in: Campaign.levels) == eclats, "the éclats were taken away")
        #expect(sut.isAccessible(level(inChapter: 3)))
        #expect(!sut.isAccessible(level(inChapter: 8)))
        // Buying later finds the progression again.
        store.simulate(.fullAccess)
        #expect(sut.isAccessible(level(inChapter: 8)))
        #expect(sut.progress.completedCount(in: Campaign.levels) == reached)
    }

    @Test("CASE 8: a permanent right held alongside an expired promotion stays active")
    func fullAccessSurvivesExpiry() {
        let (sut, store) = makeSUT(entitlement: .fullAccess)
        store.simulate(.fullAccess)
        #expect(sut.entitlement == .fullAccess)
        #expect(sut.isAccessible(level(inChapter: 12)))
    }

    // MARK: The game asks before moving on

    @Test("the game asks the navigator before continuing, and is refused at the first paid chapter")
    func gameAsksBeforeContinuing() throws {
        let (sut, store) = makeSUT()
        let lastFreeLevel = try #require(Campaign.chapter(number: 3)?.levels.last)
        let firstPaidLevel = try #require(Campaign.next(after: lastFreeLevel))
        #expect(firstPaidLevel.chapter == 4)

        #expect(sut.gameMayContinue(to: lastFreeLevel))
        #expect(!sut.gameMayContinue(to: firstPaidLevel))

        sut.gameDidReachLockedLevel(firstPaidLevel)
        #expect(sut.route == .chapters)
        #expect(sut.sheet == .paywall)
        #expect(sut.paywallChapter?.number == 4)

        store.simulate(.fullAccess)
        #expect(sut.gameMayContinue(to: firstPaidLevel))
    }

    @Test("the full access screen can be opened without naming a chapter, from the settings")
    func paywallWithoutChapter() {
        let (sut, _) = makeSUT()
        sut.presentPaywall()
        #expect(sut.sheet == .paywall)
        #expect(sut.paywallChapter == nil)
        sut.dismissSheet()
        #expect(sut.sheet == nil)
    }

    @Test("the store is started by the interface, once, and never by the container")
    func storeIsStartedOnce() {
        let (sut, store) = makeSUT()
        #expect(store.startCount == 0, "building the app must not talk to the store")
        sut.activate()
        #expect(store.startCount == 1)
    }

    @Test("the experimental prototype levels stay outside the model")
    func prototypesStayFree() {
        let (sut, _) = makeSUT()
        #expect(sut.isAccessible(BraisesPrototype.a))
    }
}
