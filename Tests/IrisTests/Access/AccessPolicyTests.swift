// AccessPolicyTests.swift
// Layer: Tests
// Purpose: The commercial model as a rule, not as an interface: three free chapters, everything else behind the full
// access, the strict priority of the rights, and what a temporary access leaves behind when it ends

import Foundation
import Testing
@testable import Iris

@Suite("Access policy")
struct AccessPolicyTests {
    private var chapterNumbers: [Int] { Campaign.chapters.map(\.number) }

    private func chapter(_ number: Int) -> ChapterDefinition {
        guard let chapter = Campaign.chapter(number: number) else { preconditionFailure("missing chapter \(number)") }
        return chapter
    }

    private func firstLevel(ofChapter number: Int) -> LevelDefinition {
        guard let level = chapter(number).levels.first else { preconditionFailure("empty chapter \(number)") }
        return level
    }

    @Test("the free chapter count is written once, and the campaign really has twelve chapters")
    func singleSource() {
        #expect(AccessPolicy.freeChapterCount == 3)
        #expect(AccessPolicy.freeChapterNumbers == 1...3)
        #expect(chapterNumbers == Array(1...12))
        #expect(AccessPolicy.freeChapters(in: Campaign.chapters).map(\.number) == [1, 2, 3])
        #expect(AccessPolicy.paidChapters(in: Campaign.chapters).map(\.number) == Array(4...12))
    }

    @Test("FREE: chapters I, II and III are open; IV and XII are not")
    func freePlayer() {
        for number in [1, 2, 3] {
            #expect(AccessPolicy.isAccessible(chapter(number), with: .free), "chapter \(number) must be free")
            #expect(AccessPolicy.isAccessible(firstLevel(ofChapter: number), with: .free))
        }
        for number in [4, 12] {
            #expect(!AccessPolicy.isAccessible(chapter(number), with: .free), "chapter \(number) must be locked")
            #expect(!AccessPolicy.isAccessible(firstLevel(ofChapter: number), with: .free))
        }
    }

    @Test("FULL: every chapter from I to XII is open")
    func fullAccess() {
        for number in chapterNumbers {
            #expect(AccessPolicy.isAccessible(chapter(number), with: .fullAccess), "chapter \(number)")
        }
        #expect(Campaign.levels.allSatisfy { AccessPolicy.isAccessible($0, with: .fullAccess) })
    }

    @Test("PROMOTIONAL ACCESS, while it lasts: every chapter from I to XII is open")
    func promotionalAccess() {
        for number in chapterNumbers {
            #expect(AccessPolicy.isAccessible(chapter(number), with: .promotionalAccess), "chapter \(number)")
        }
        #expect(Campaign.levels.allSatisfy { AccessPolicy.isAccessible($0, with: .promotionalAccess) })
    }

    @Test("PROMOTIONAL ACCESS once expired: the player is free again, I to III open, IV to XII locked")
    func promotionalAccessExpired() {
        // Expiry is not a state of its own: the right simply disappears and the strongest remaining one is free.
        let afterExpiry = AccessEntitlement.strongest(of: [] as [AccessEntitlement])
        #expect(afterExpiry == .free)
        for number in [1, 2, 3] {
            #expect(AccessPolicy.isAccessible(chapter(number), with: afterExpiry))
        }
        for number in Array(4...12) {
            #expect(!AccessPolicy.isAccessible(chapter(number), with: afterExpiry), "chapter \(number)")
        }
    }

    @Test("FULL + PROMOTIONAL: the permanent right wins, and outlives the temporary one")
    func priority() {
        #expect(AccessEntitlement.strongest(of: [.promotionalAccess, .fullAccess]) == .fullAccess)
        #expect(AccessEntitlement.strongest(of: [.fullAccess, .promotionalAccess]) == .fullAccess)
        #expect(AccessEntitlement.strongest(of: [.free, .promotionalAccess]) == .promotionalAccess)
        #expect(AccessEntitlement.strongest(of: [.free]) == .free)
        #expect(AccessEntitlement.fullAccess > .promotionalAccess)
        #expect(AccessEntitlement.promotionalAccess > .free)
        // A full access held alongside an expired promotion is still a full access.
        #expect(AccessEntitlement.strongest(of: [.fullAccess]) == .fullAccess)
        #expect(AccessEntitlement.allCases == [.free, .promotionalAccess, .fullAccess])
        #expect(AccessEntitlement.promotionalAccess.isTemporary)
        #expect(!AccessEntitlement.fullAccess.isTemporary)
        #expect(!AccessEntitlement.free.opensWholeCampaign)
    }

    @Test("the DEBUG prototype levels stand outside the campaign and outside the commercial model")
    func experimentalLevels() {
        let prototype = BraisesPrototype.a
        #expect(prototype.isExperimental)
        #expect(AccessPolicy.isAccessible(prototype, with: .free))
    }

    @Test("each product grants exactly one right, and nothing else grants any")
    func productsGrantRights() {
        #expect(StoreProductID.entitlement(for: StoreProductID.fullGameUnlock) == .fullAccess)
        #expect(StoreProductID.entitlement(for: StoreProductID.promotionalAccessPass) == .promotionalAccess)
        #expect(StoreProductID.entitlement(for: "net.steve-s.iris.unknown") == nil)
        #expect(StoreProductID.all == [StoreProductID.fullGameUnlock, StoreProductID.promotionalAccessPass])
        #expect(StoreProductID.fullGameUnlock == "net.steve_s.iris.unlock.fullgame")
        #expect(StoreProductID.promotionalAccessPass == "net.steve_s.iris.access.promopass")
    }
}
