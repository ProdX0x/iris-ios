// CommerceBoundaryTests.swift
// Layer: Tests
// Purpose: Commerce stays where it belongs: the gameplay, the gaze engine, the calibration, the levels and the
// campaign never hear about StoreKit; the product identifiers and the free chapter count are written once; no price
// is ever spelled out in the interface; no code is ever recognised locally; and Iris promises nothing medical

import Foundation
import Testing
@testable import Iris

@Suite("Commerce boundaries")
struct CommerceBoundaryTests {
    /// Project root, derived from this file's compile-time path (Tests/IrisTests/Commerce/...).
    private static var projectRoot: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
    }

    /// Every Swift source compiled into the app.
    private func productionSources() throws -> [(path: String, text: String)] {
        var sources: [(path: String, text: String)] = []
        for base in ["App", "AR", "Audio", "Commerce", "DesignSystem", "Domain", "Features", "GameEngine", "Haptics", "Navigation"] {
            let directory = Self.projectRoot.appendingPathComponent(base)
            let files = FileManager.default.enumerator(atPath: directory.path)?.allObjects as? [String] ?? []
            for relative in files.sorted() where relative.hasSuffix(".swift") {
                sources.append(("\(base)/\(relative)", try String(contentsOf: directory.appendingPathComponent(relative), encoding: .utf8)))
            }
        }
        return sources
    }

    private func source(_ path: String) throws -> String {
        try String(contentsOf: Self.projectRoot.appendingPathComponent(path), encoding: .utf8)
    }

    /// Everything a player can read in a Swift source: the string literals. A comment stating that Iris promises
    /// nothing medical is not a claim, and must not be mistaken for one.
    private func literals(in text: String) -> String {
        text.matches(of: #/"([^"\\\n]|\\.)*"/#).map { String($0.output.0) }.joined(separator: "\n")
    }

    /// The one file of the interface allowed to reach StoreKit: it presents Apple's own redemption sheet.
    private static let redemptionFile = "Features/Paywall/OfferCodeRedemption.swift"

    @Test("A: only the Commerce layer and the redemption sheet import StoreKit")
    func storeKitStaysInCommerce() throws {
        var importers: [String] = []
        for (path, text) in try productionSources() where text.contains("import StoreKit") {
            importers.append(path)
        }
        #expect(Set(importers) == ["Commerce/Diagnostics/StoreDiagnostics.swift",
                                  "Commerce/Services/StoreKitEntitlementService.swift", Self.redemptionFile],
                "StoreKit is imported by \(importers.sorted())")
    }

    @Test("B: the gameplay, the gaze engine, the calibration, the levels and the campaign know nothing of commerce")
    func gameplayIsIndependent() throws {
        let commerceWords = ["StoreKit", "Product(", "Transaction", "StoreProductID", "AccessEntitlement", "AccessPolicy",
                            "EntitlementProviding", "Paywall", "purchase", "fullgame", "promopass"]
        var checked = 0
        for (path, text) in try productionSources() {
            guard path.hasPrefix("GameEngine/") || path.hasPrefix("AR/") || path.hasPrefix("Audio/") || path.hasPrefix("Haptics/")
                    || path.hasPrefix("Domain/Campaign/") || path.hasPrefix("Domain/Entities/") || path.hasPrefix("Domain/Physics/")
                    || path.hasPrefix("Features/Game/") else { continue }
            for word in commerceWords {
                #expect(!text.contains(word), "\(path) mentions \(word)")
            }
            checked += 1
        }
        #expect(checked > 100, "only \(checked) gameplay sources were checked")
        // The three files the mission names, one by one.
        for path in ["GameEngine/Physics/TargetPhysics.swift", "GameEngine/Gaze/GazeFilter.swift",
                     "AR/Calibration/GazeMapper.swift", "AR/Services/ARKitGazeTrackingService.swift",
                     "Domain/Campaign/LevelDefinition.swift", "Domain/Campaign/Campaign.swift"] {
            let text = try source(path)
            #expect(!text.contains("StoreKit") && !text.contains("Entitlement") && !text.contains("AccessPolicy"), "\(path)")
        }
    }

    @Test("C: the product identifiers are written in exactly one file")
    func productIdentifiersAreCentralised() throws {
        for identifier in [StoreProductID.fullGameUnlock, StoreProductID.promotionalAccessPass] {
            let writers = try productionSources().filter { $0.text.contains(identifier) }.map(\.path)
            #expect(writers == ["Commerce/Products/StoreProductID.swift"], "\(identifier) is written by \(writers)")
        }
    }

    @Test("D: the free chapter count is written in exactly one file")
    func freeChapterCountIsCentralised() throws {
        let writers = try productionSources().filter { $0.text.contains("freeChapterCount = ") }.map(\.path)
        #expect(writers == ["Domain/Access/AccessPolicy.swift"], "freeChapterCount is assigned in \(writers)")
        // Everything that shows or applies the rule reads the policy instead of counting for itself.
        #expect(try source("Features/Paywall/PaywallCopy.swift").contains("AccessPolicy.freeChapters("))
        #expect(try source("Navigation/AppCoordinator.swift").contains("AccessPolicy.isAccessible("))
    }

    @Test("E: no offer code is recognised locally: the right always comes from the store")
    func noLocalCodeValidation() throws {
        for (path, text) in try productionSources() {
            #expect(!text.contains("IRIS7D"), "\(path) knows a promotional code")
        }
        // The only redemption path is Apple's own sheet.
        let redemption = try source(Self.redemptionFile)
        #expect(redemption.contains("offerCodeRedemption(isPresented:"))
        #expect(!redemption.contains("=="), "the redemption sheet compares nothing")
    }

    @Test("F: no local flag ever stands in for a right: the entitlement is recomputed from the store")
    func noPermanentLocalFlag() throws {
        let forbidden = ["hasPromo", "isUnlockedForever", "hasPurchased", "premiumEnabled", "trialStartDate", "promoExpiry"]
        for (path, text) in try productionSources() {
            for flag in forbidden {
                #expect(!text.contains(flag), "\(path) keeps \(flag)")
            }
        }
        let service = try source("Commerce/Services/StoreKitEntitlementService.swift")
        #expect(!service.contains("UserDefaults"), "the rights are never cached in the defaults")
        #expect(service.contains("Transaction.currentEntitlements") && service.contains("Transaction.updates"))
        #expect(service.contains("revocationDate") && service.contains("isUpgraded") && service.contains("expirationDate"))
        #expect(service.contains("case .unverified"), "unverified transactions are refused")
    }

    @Test("G: no price is written in Iris: the interface shows the one the store formats")
    func noHardcodedPrice() throws {
        let sample = "Commerce/Services/StaticEntitlementService.swift"
        for (path, text) in try productionSources() {
            #expect(!text.contains("2,99") && !text.contains("2.99"), "\(path) writes the target price")
            guard path != sample else { continue }
            #expect(!text.contains("€"), "\(path) writes a currency itself")
        }
        // The sample used by previews is deliberately not the price Iris will sell at.
        #expect(!StaticEntitlementService.samplePrice.contains("2,99"))
        #expect(try source("Features/Paywall/PaywallView.swift").contains("store.fullGameDisplayPrice"))
        #expect(try source("Features/Paywall/PaywallCopy.swift").contains("unlockTitle(price:"))
        #expect(try source("Commerce/Services/StoreKitEntitlementService.swift").contains("displayPrice"))
    }

    @Test("H: Iris is described as a game and promises nothing medical, therapeutic or clinical")
    func noMedicalClaims() throws {
        let forbidden = ["rééduc", "reeduc", "thérap", "therap", "clinique", "clinical", "patholog", "traitement d",
                         "dispositif médical", "soigne", "guérit", "guerit", "améliore la vision", "améliore les yeux",
                         "santé visuelle", "bénéfice cognitif", "bénéfice neurologique", "neurologique", "ophtalmo",
                         "prescription", "diagnostic médical", "orthoptie", "orthoptique", "amblyop", "strabis"]
        // Swift sources are judged on what they show, not on what they document about themselves.
        var texts: [(String, String)] = try productionSources().map { ($0.path, literals(in: $0.text)) }
        let docs = Self.projectRoot.appendingPathComponent("Docs/AppStore")
        if let names = try? FileManager.default.contentsOfDirectory(atPath: docs.path) {
            for name in names.sorted() where name.hasSuffix(".md") {
                texts.append(("Docs/AppStore/\(name)", try String(contentsOf: docs.appendingPathComponent(name), encoding: .utf8)))
            }
        }
        for (path, text) in texts {
            let lowered = text.lowercased()
            for word in forbidden {
                #expect(!lowered.contains(word), "\(path) claims \(word)")
            }
        }
        #expect(texts.count > 150)
    }

    @Test("I: the promotional pass is never sold: no subscription is offered anywhere in the interface")
    func promotionalPassIsNeverSold() throws {
        for (path, text) in try productionSources() where path.hasPrefix("Features/") || path.hasPrefix("Navigation/") {
            #expect(!text.contains("S'abonner") && !text.contains("Abonnement") && !text.contains("abonner"),
                    "\(path) offers a subscription")
        }
        // Iris asks the store about the pass only to read a right; it never buys it.
        let service = try source("Commerce/Services/StoreKitEntitlementService.swift")
        #expect(!service.contains("purchase(promotionalAccessPass"))
        #expect(service.contains("products[StoreProductID.fullGameUnlock]"))
        #expect(!service.contains("products[StoreProductID.promotionalAccessPass]"))
        // No two-month offer exists anywhere.
        for (path, text) in try productionSources() {
            #expect(!text.contains("P2M") && !text.contains("2 mois") && !text.contains("deux mois"), "\(path) mentions a two-month offer")
        }
    }

    @Test("J: the store starts after the first frame and opens exactly one transaction listener")
    func storeDoesNotBlockTheFirstFrame() throws {
        let service = try source("Commerce/Services/StoreKitEntitlementService.swift")
        #expect(service.contains("guard !hasStarted else { return }"), "start() must be idempotent")
        #expect(service.components(separatedBy: "for await update in Transaction.updates").count == 2,
                "exactly one listener is opened")
        let app = try source("App/IrisApp.swift")
        #expect(!app.contains("store") && !app.contains("await"), "nothing commercial runs at the entry point")
        let container = try source("App/DI/AppContainer.swift")
        // The guarantee is about the store, not about any object that happens to have a start(): the composition
        // root may start a DEBUG diagnostic, but never the store.
        #expect(!container.contains("store.start()"), "the container builds the store, it does not start it")
        #expect(!container.contains("StoreKitEntitlementService().start"), "the container must not start the store")
        #expect(try source("Navigation/RootView.swift").contains(".task { coordinator.activate() }"))
        #expect(try source("Navigation/AppCoordinator.swift").contains("container.store.start()"))
    }

    @Test("L: the debug shortcut to a commercial state cannot exist in a Release build")
    func debugEntitlementIsDebugOnly() throws {
        let container = try source("App/DI/AppContainer.swift")
        // The one conditional block that builds the store: DEBUG may stand a fixed right in, Release may not.
        let blocks = container.matches(of: #/#if DEBUG(?<debug>[\s\S]*?)#else(?<release>[\s\S]*?)#endif/#)
        let storeBlock = blocks.first { $0.output.debug.contains("StaticEntitlementService") }
        guard let storeBlock else {
            Issue.record("the composition root no longer separates the debug store from the real one")
            return
        }
        let release = String(storeBlock.output.release)
        #expect(String(storeBlock.output.debug).contains("StaticEntitlementService(entitlement:"))
        #expect(release.contains("StoreKitEntitlementService()"))
        #expect(!release.contains("StaticEntitlementService"), "a Release build could stand a fixed right in for the store")
        #expect(!release.contains("launchOptions"), "a Release build reads no launch argument to build the store")
        // Launch arguments themselves are parsed in DEBUG only.
        #expect(container.contains("LaunchOptions.parse(ProcessInfo.processInfo.arguments)"))
        #expect(container.components(separatedBy: "LaunchOptions.none").count == 2)

        // Belt and braces: the double itself grants nothing outside DEBUG, so even a Release build that somehow
        // built one would still hold no right that did not come from the store.
        let double = try source("Commerce/Services/StaticEntitlementService.swift")
        for block in double.matches(of: #/#if DEBUG(?<debug>[\s\S]*?)#(?<tail>else[\s\S]*?#endif|endif)/#) {
            #expect(!String(block.output.debug).isEmpty)
        }
        #expect(double.contains("self.entitlement = .free"), "the Release branch must fall back to free")
        #expect(double.components(separatedBy: "#if DEBUG").count == 4, "every grant is behind DEBUG")
    }
}
