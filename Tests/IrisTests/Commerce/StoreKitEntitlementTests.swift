// StoreKitEntitlementTests.swift
// Layer: Tests
// Purpose: The store layer against a real StoreKit test session: products and their price, a verified purchase, an
// unverified one refused, pending, cancellation, errors, restoration, revocation, the promotional access granted by
// an offer code, its expiry, and the transaction updates that keep the right current

import Foundation
import StoreKit
import StoreKitTest
import Testing
@testable import Iris

@Suite("StoreKit entitlements", .serialized, .timeLimit(.minutes(1)))
@MainActor
struct StoreKitEntitlementTests {
    /// Project root, derived from this file's compile-time path (Tests/IrisTests/Commerce/...).
    private static var projectRoot: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
    }

    /// The same local products the scheme runs with; it creates nothing in App Store Connect.
    private static var configuration: URL { projectRoot.appendingPathComponent("Config/Iris.storekit") }

    /// A product that exists only in the copy of the configuration each session runs on: never in `Config/Iris.storekit`,
    /// never in App Store Connect, never asked for by Iris. No store but the local test session can answer for it.
    private static let localSessionMarker = "net.steve_s.iris.test.localsession"

    private struct UnreadableConfiguration: Error {}

    private func makeSession() throws -> SKTestSession {
        // SKTestSession writes its settings back into the file it was given. The simulator's sandbox cannot write to
        // the repository, so the session runs on a copy inside the sandbox: the same products, plus the marker.
        let copy = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("Iris-\(UUID().uuidString).storekit")
        try Self.configurationWithMarker().write(to: copy)
        let session = try SKTestSession(contentsOf: copy)
        session.disableDialogs = true
        session.askToBuyEnabled = false
        session.resetToDefaultState()
        session.clearTransactions()
        return session
    }

    /// `Config/Iris.storekit` with one more product, the local session marker: a consumable modelled on the full game's
    /// own entry, so the session reads it exactly as it reads the real ones. Nothing else in the configuration changes.
    private static func configurationWithMarker() throws -> Data {
        guard var root = try JSONSerialization.jsonObject(with: Data(contentsOf: configuration)) as? [String: Any],
              var products = root["products"] as? [[String: Any]], var marker = products.first else {
            throw UnreadableConfiguration()
        }
        marker["productID"] = localSessionMarker
        marker["referenceName"] = "Local StoreKit session marker"
        marker["internalID"] = "5E551011"
        marker["type"] = "Consumable"
        marker["localizations"] = [["description": "Present only in a local StoreKit test session.",
                                    "displayName": "Local session marker", "locale": "fr_FR"]]
        products.append(marker)
        root["products"] = products
        return try JSONSerialization.data(withJSONObject: root, options: [.prettyPrinted, .sortedKeys])
    }

    /// True when the local StoreKit test session is the store answering. Finding the real products no longer proves
    /// it: App Store Connect now serves them, and a runtime that refuses local sessions gets the sandbox's answer
    /// instead. Only the marker proves it, since only this session's own configuration declares it. The iOS 26.3
    /// runtime installed on this machine refuses local sessions (storekitd answers SKInternalErrorDomain 3): on an
    /// iOS 26 runtime a missing session is that known limitation, recorded as a known issue. Anywhere else, iOS 18.x
    /// among them, where these tests run for real, a missing session is a failure; the limitation hides nothing there.
    private func storeKitTestingIsAvailable() async -> Bool {
        let marker = (try? await Product.products(for: [Self.localSessionMarker])) ?? []
        if !marker.isEmpty { return true }
        if ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= 26 {
            withKnownIssue("This runtime refuses local StoreKit test sessions; run this suite on an iOS 18.x runtime to assert it for real.") {
                Issue.record("the local StoreKit test session is not in effect on this runtime")
            }
        } else {
            Issue.record("the local StoreKit test session did not take effect: its marker product is missing")
        }
        return false
    }

    /// Re-reads the rights until the store publishes the change the test just made.
    private func waitForEntitlement(_ expected: AccessEntitlement, on service: StoreKitEntitlementService,
                                    upTo seconds: Double = 10) async -> Bool {
        let deadline = Date().addingTimeInterval(seconds)
        while Date() < deadline {
            await service.refresh()
            if service.entitlement == expected { return true }
            try? await Task.sleep(for: .milliseconds(100))
        }
        return service.entitlement == expected
    }

    /// Waits for a condition the transaction listener will bring about.
    private func wait(upTo seconds: Double = 5, for condition: () -> Bool) async -> Bool {
        let deadline = Date().addingTimeInterval(seconds)
        while Date() < deadline {
            if condition() { return true }
            try? await Task.sleep(for: .milliseconds(40))
        }
        return condition()
    }

    // MARK: Products

    @Test("the full game is available and its price comes from the store, never from Iris")
    func productAvailable() async throws {
        let session = try makeSession()
        _ = session
        guard await storeKitTestingIsAvailable() else { return }
        let service = StoreKitEntitlementService(allowsNewAcquisitions: true)
        await service.refresh()

        let price = try #require(service.fullGameDisplayPrice)
        #expect(!price.isEmpty)
        let products = try await Product.products(for: [StoreProductID.fullGameUnlock])
        #expect(products.first?.displayPrice == price)
        #expect(products.first?.type == .nonConsumable)
        #expect(service.entitlement == .free)
    }

    @Test("the promotional pass is an auto-renewable subscription in the store, and Iris never offers it for sale")
    func promotionalPassIsASubscription() async throws {
        let session = try makeSession()
        _ = session
        guard await storeKitTestingIsAvailable() else { return }
        let products = try await Product.products(for: [StoreProductID.promotionalAccessPass])
        let pass = try #require(products.first)
        #expect(pass.type == .autoRenewable)
        #expect(pass.subscription != nil)
        // Iris reads a price for the full game only: the pass has no price to show anywhere.
        let service = StoreKitEntitlementService(allowsNewAcquisitions: true)
        await service.refresh()
        #expect(service.fullGameDisplayPrice != nil)
    }

    @Test("when the store cannot be reached the price is unknown, the free chapters stay open, and buying says so")
    func productUnavailable() async throws {
        let session = try makeSession()
        guard await storeKitTestingIsAvailable() else { return }
        try await session.setSimulatedError(.generic(.networkError(URLError(.notConnectedToInternet))), forAPI: .loadProducts)
        let service = StoreKitEntitlementService(allowsNewAcquisitions: true)
        await service.refresh()

        #expect(service.fullGameDisplayPrice == nil)
        #expect(service.entitlement == .free)
        await service.purchaseFullGame()
        #expect(service.lastOutcome == .unavailable)
        #expect(AccessPolicy.isAccessible(chapterNumber: 1, with: service.entitlement))
    }

    // MARK: Buying

    @Test("a verified purchase grants the permanent full access")
    func purchaseVerified() async throws {
        let session = try makeSession()
        guard await storeKitTestingIsAvailable() else { return }
        let service = StoreKitEntitlementService(allowsNewAcquisitions: true)
        await service.refresh()
        #expect(service.entitlement == .free)

        // `Product.purchase()` needs a scene to present its confirmation, which a unit-test host does not offer; the
        // transaction it would hand back is made here by the test session, and the service decides on it exactly as
        // it does in the app.
        let transaction = try await session.buyProduct(identifier: StoreProductID.fullGameUnlock)
        await service.apply(.success(.verified(transaction)))

        #expect(service.lastOutcome == .purchased)
        #expect(await waitForEntitlement(.fullAccess, on: service), "a verified purchase must open the whole campaign")
    }

    @Test("an unverified purchase is refused and grants nothing")
    func purchaseUnverified() async throws {
        let session = try makeSession()
        guard await storeKitTestingIsAvailable() else { return }
        let service = StoreKitEntitlementService(allowsNewAcquisitions: true)
        let transaction = try await session.buyProduct(identifier: StoreProductID.fullGameUnlock)
        session.clearTransactions()

        await service.apply(.success(.unverified(transaction, .invalidSignature)))

        #expect(service.lastOutcome == .unverified)
        #expect(service.entitlement == .free, "an unverified transaction must grant nothing")
    }

    @Test("a purchase waiting for someone else stays pending and grants nothing yet")
    func purchasePending() async throws {
        let session = try makeSession()
        _ = session
        guard await storeKitTestingIsAvailable() else { return }
        let service = StoreKitEntitlementService(allowsNewAcquisitions: true)
        await service.apply(.pending)

        #expect(service.lastOutcome == .pending)
        #expect(service.entitlement == .free)
    }

    @Test("a cancelled purchase says nothing to the player and grants nothing")
    func purchaseCancelled() async throws {
        let session = try makeSession()
        _ = session
        guard await storeKitTestingIsAvailable() else { return }
        let service = StoreKitEntitlementService(allowsNewAcquisitions: true)
        await service.apply(.userCancelled)
        #expect(service.lastOutcome == .cancelled)
        #expect(service.lastOutcome?.notice == nil, "a cancellation is not an error to show")

        // A cancellation that surfaces as a thrown error is the same thing.
        service.apply(StoreKitError.userCancelled)
        #expect(service.lastOutcome == .cancelled)
        #expect(service.entitlement == .free)
    }

    @Test("a purchase error is reported without granting anything")
    func purchaseError() async throws {
        let session = try makeSession()
        _ = session
        guard await storeKitTestingIsAvailable() else { return }
        let service = StoreKitEntitlementService(allowsNewAcquisitions: true)
        service.apply(StoreKitError.networkError(URLError(.timedOut)))
        #expect(service.lastOutcome == .failed)
        #expect(service.lastOutcome?.isFailure == true)
        #expect(service.entitlement == .free)
    }

    @Test("a product the store will not sell is reported as unavailable")
    func purchaseUnavailableProduct() async throws {
        let session = try makeSession()
        guard await storeKitTestingIsAvailable() else { return }
        try await session.setSimulatedError(.generic(.networkError(URLError(.notConnectedToInternet))), forAPI: .loadProducts)
        let service = StoreKitEntitlementService(allowsNewAcquisitions: true)
        await service.purchaseFullGame()

        #expect(service.lastOutcome == .unavailable)
        #expect(service.entitlement == .free)
    }

    // MARK: Launching, restoring, revoking

    @Test("a right bought earlier is found again at the next launch")
    func entitlementAtLaunch() async throws {
        let session = try makeSession()
        guard await storeKitTestingIsAvailable() else { return }
        _ = try await session.buyProduct(identifier: StoreProductID.fullGameUnlock)

        let service = StoreKitEntitlementService(allowsNewAcquisitions: true)
        await service.refresh()
        #expect(service.entitlement == .fullAccess)
    }

    @Test("restoring finds the permanent right; with nothing to restore it says so")
    func restore() async throws {
        // `AppStore.sync()` presents a sign-in and needs a scene the test host does not offer, so it is made to fail
        // here: what is under test is that Iris swallows it and re-reads the rights either way.
        let session = try makeSession()
        guard await storeKitTestingIsAvailable() else { return }
        try await session.setSimulatedError(.generic(.networkError(URLError(.timedOut))), forAPI: .appStoreSync)
        let empty = StoreKitEntitlementService(allowsNewAcquisitions: true)
        await empty.refresh()
        await empty.restorePurchases()
        #expect(empty.lastOutcome == .nothingToRestore)
        #expect(empty.entitlement == .free)

        _ = try await session.buyProduct(identifier: StoreProductID.fullGameUnlock)
        let service = StoreKitEntitlementService(allowsNewAcquisitions: true)
        #expect(await waitForEntitlement(.fullAccess, on: service), "the store never published the purchase")
        await service.restorePurchases()
        #expect(service.lastOutcome == .restored)
        #expect(service.entitlement == .fullAccess)
    }

    @Test("a synchronisation that fails is swallowed: the rights are read again and the free chapters stay open")
    func restoreWhenSynchronisationFails() async throws {
        let session = try makeSession()
        guard await storeKitTestingIsAvailable() else { return }
        try await session.setSimulatedError(.generic(.networkError(URLError(.timedOut))), forAPI: .appStoreSync)
        let service = StoreKitEntitlementService(allowsNewAcquisitions: true)
        await service.refresh()
        await service.restorePurchases()

        #expect(service.lastOutcome == .nothingToRestore)
        #expect(service.entitlement == .free)
        #expect(AccessPolicy.isAccessible(chapterNumber: 3, with: service.entitlement))
    }

    @Test("a revoked purchase takes the access back")
    func revocation() async throws {
        let session = try makeSession()
        guard await storeKitTestingIsAvailable() else { return }
        _ = try await session.buyProduct(identifier: StoreProductID.fullGameUnlock)
        let service = StoreKitEntitlementService(allowsNewAcquisitions: true)
        await service.refresh()
        #expect(service.entitlement == .fullAccess)

        let transaction = try #require(session.allTransactions().first)
        try session.refundTransaction(identifier: transaction.identifier)
        #expect(await waitForEntitlement(.free, on: service), "a refunded purchase must take the access back")
    }

    // MARK: Promotional access

    @Test("an offer code on the promotional pass opens the whole campaign for its duration")
    func promotionalAccessGranted() async throws {
        let session = try makeSession()
        guard await storeKitTestingIsAvailable() else { return }
        _ = try await session.buyProduct(identifier: StoreProductID.promotionalAccessPass,
                                         options: [.codeOffer(referenceName: "Iris 3-Day Promotional Access")])
        let service = StoreKitEntitlementService(allowsNewAcquisitions: true)
        await service.refresh()

        #expect(service.entitlement == .promotionalAccess)
        #expect(AccessPolicy.isAccessible(chapterNumber: 12, with: service.entitlement))
    }

    @Test("when the promotional access ends the player is free again, and no local flag survives it")
    func promotionalAccessExpires() async throws {
        let session = try makeSession()
        guard await storeKitTestingIsAvailable() else { return }
        _ = try await session.buyProduct(identifier: StoreProductID.promotionalAccessPass,
                                         options: [.codeOffer(referenceName: "Iris 3-Day Promotional Access")])
        let service = StoreKitEntitlementService(allowsNewAcquisitions: true)
        await service.refresh()
        #expect(service.entitlement == .promotionalAccess)

        try session.expireSubscription(productIdentifier: StoreProductID.promotionalAccessPass)
        #expect(await waitForEntitlement(.free, on: service), "an expired promotion must not keep the campaign open")
        #expect(AccessPolicy.isAccessible(chapterNumber: 3, with: service.entitlement))
        #expect(!AccessPolicy.isAccessible(chapterNumber: 4, with: service.entitlement))
    }

    @Test("a permanent purchase outlives the promotional access it was bought during")
    func fullAccessOutlivesPromotion() async throws {
        let session = try makeSession()
        guard await storeKitTestingIsAvailable() else { return }
        _ = try await session.buyProduct(identifier: StoreProductID.promotionalAccessPass,
                                         options: [.codeOffer(referenceName: "Iris 3-Day Promotional Access")])
        _ = try await session.buyProduct(identifier: StoreProductID.fullGameUnlock)
        let service = StoreKitEntitlementService(allowsNewAcquisitions: true)
        await service.refresh()
        #expect(service.entitlement == .fullAccess)

        try session.expireSubscription(productIdentifier: StoreProductID.promotionalAccessPass)
        await service.refresh()
        await service.refresh()
        #expect(service.entitlement == .fullAccess)
    }

    // MARK: Updates

    @Test("a purchase made outside Iris reaches it through the transaction updates")
    func transactionUpdates() async throws {
        let session = try makeSession()
        guard await storeKitTestingIsAvailable() else { return }
        let service = StoreKitEntitlementService(allowsNewAcquisitions: true)
        service.start()
        #expect(await wait { service.fullGameDisplayPrice != nil })
        #expect(service.entitlement == .free)

        _ = try await session.buyProduct(identifier: StoreProductID.fullGameUnlock)
        #expect(await wait { service.entitlement == .fullAccess }, "the listener never reported the purchase")
    }

    // MARK: A device that cannot play Iris

    @Test("H: on a device that cannot play Iris no transaction is ever opened and no price is named")
    func deviceGateOpensNoTransaction() async throws {
        let session = try makeSession()
        guard await storeKitTestingIsAvailable() else { return }
        // The same store, on a device that can play: the price is there, so what follows is the gate and nothing else.
        let able = StoreKitEntitlementService(allowsNewAcquisitions: true)
        await able.refresh()
        #expect(able.fullGameDisplayPrice != nil)

        let unable = StoreKitEntitlementService(allowsNewAcquisitions: false)
        await unable.refresh()
        #expect(unable.fullGameDisplayPrice == nil, "a device that cannot play must not be shown a price")
        await unable.purchaseFullGame()
        #expect(unable.lastOutcome == .deviceUnsupported)
        #expect(unable.entitlement == .free)
        #expect(session.allTransactions().isEmpty, "a purchase reached the store on a device that cannot play")
    }

    @Test("H: a right bought on another device stays recognised, and restorable, on a device that cannot play")
    func deviceGateKeepsTheRightsHeld() async throws {
        let session = try makeSession()
        guard await storeKitTestingIsAvailable() else { return }
        try await session.setSimulatedError(.generic(.networkError(URLError(.timedOut))), forAPI: .appStoreSync)
        _ = try await session.buyProduct(identifier: StoreProductID.fullGameUnlock)

        let unable = StoreKitEntitlementService(allowsNewAcquisitions: false)
        #expect(await waitForEntitlement(.fullAccess, on: unable), "the gate must never hide a right already held")
        await unable.restorePurchases()
        #expect(unable.lastOutcome == .restored)
        #expect(unable.entitlement == .fullAccess)
    }

    @Test("H: a promotional access already redeemed stays recognised on a device that cannot play")
    func deviceGateKeepsThePromotionalRight() async throws {
        let session = try makeSession()
        guard await storeKitTestingIsAvailable() else { return }
        _ = try await session.buyProduct(identifier: StoreProductID.promotionalAccessPass,
                                         options: [.codeOffer(referenceName: "Iris 3-Day Promotional Access")])
        let unable = StoreKitEntitlementService(allowsNewAcquisitions: false)
        await unable.refresh()
        #expect(unable.entitlement == .promotionalAccess)
    }
}
