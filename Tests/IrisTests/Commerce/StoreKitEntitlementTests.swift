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

    private func makeSession() throws -> SKTestSession {
        // SKTestSession writes its settings back into the file it was given. The simulator's sandbox cannot write to
        // the repository, so the session runs on a copy inside the sandbox; the products are the same.
        let copy = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("Iris-\(UUID().uuidString).storekit")
        try FileManager.default.copyItem(at: Self.configuration, to: copy)
        let session = try SKTestSession(contentsOf: copy)
        session.disableDialogs = true
        session.askToBuyEnabled = false
        session.resetToDefaultState()
        session.clearTransactions()
        return session
    }

    /// True when this simulator runtime lets a StoreKit test session take effect. The iOS 26.3 runtime installed on
    /// this machine refuses it — storekitd answers SKInternalErrorDomain 3 and every store call comes back
    /// `notEntitled` — while the iOS 18.x runtimes run these tests for real. Where it is refused the test records a
    /// known issue naming the limitation rather than pretending to have proved anything.
    private func storeKitTestingIsAvailable() async -> Bool {
        let products = (try? await Product.products(for: [StoreProductID.fullGameUnlock])) ?? []
        guard products.isEmpty else { return true }
        withKnownIssue("This simulator runtime refuses StoreKit test sessions; run this suite on an iOS 18.x runtime to assert it for real.") {
            Issue.record("StoreKit testing is unavailable on this runtime")
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
        let service = StoreKitEntitlementService()
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
        let service = StoreKitEntitlementService()
        await service.refresh()
        #expect(service.fullGameDisplayPrice != nil)
    }

    @Test("when the store cannot be reached the price is unknown, the free chapters stay open, and buying says so")
    func productUnavailable() async throws {
        let session = try makeSession()
        guard await storeKitTestingIsAvailable() else { return }
        try await session.setSimulatedError(.generic(.networkError(URLError(.notConnectedToInternet))), forAPI: .loadProducts)
        let service = StoreKitEntitlementService()
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
        let service = StoreKitEntitlementService()
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
        let service = StoreKitEntitlementService()
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
        let service = StoreKitEntitlementService()
        await service.apply(.pending)

        #expect(service.lastOutcome == .pending)
        #expect(service.entitlement == .free)
    }

    @Test("a cancelled purchase says nothing to the player and grants nothing")
    func purchaseCancelled() async throws {
        let session = try makeSession()
        _ = session
        guard await storeKitTestingIsAvailable() else { return }
        let service = StoreKitEntitlementService()
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
        let service = StoreKitEntitlementService()
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
        let service = StoreKitEntitlementService()
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

        let service = StoreKitEntitlementService()
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
        let empty = StoreKitEntitlementService()
        await empty.refresh()
        await empty.restorePurchases()
        #expect(empty.lastOutcome == .nothingToRestore)
        #expect(empty.entitlement == .free)

        _ = try await session.buyProduct(identifier: StoreProductID.fullGameUnlock)
        let service = StoreKitEntitlementService()
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
        let service = StoreKitEntitlementService()
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
        let service = StoreKitEntitlementService()
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
                                         options: [.codeOffer(referenceName: "Iris 7-Day Promotional Access")])
        let service = StoreKitEntitlementService()
        await service.refresh()

        #expect(service.entitlement == .promotionalAccess)
        #expect(AccessPolicy.isAccessible(chapterNumber: 12, with: service.entitlement))
    }

    @Test("when the promotional access ends the player is free again, and no local flag survives it")
    func promotionalAccessExpires() async throws {
        let session = try makeSession()
        guard await storeKitTestingIsAvailable() else { return }
        _ = try await session.buyProduct(identifier: StoreProductID.promotionalAccessPass,
                                         options: [.codeOffer(referenceName: "Iris 7-Day Promotional Access")])
        let service = StoreKitEntitlementService()
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
                                         options: [.codeOffer(referenceName: "Iris 7-Day Promotional Access")])
        _ = try await session.buyProduct(identifier: StoreProductID.fullGameUnlock)
        let service = StoreKitEntitlementService()
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
        let service = StoreKitEntitlementService()
        service.start()
        #expect(await wait { service.fullGameDisplayPrice != nil })
        #expect(service.entitlement == .free)

        _ = try await session.buyProduct(identifier: StoreProductID.fullGameUnlock)
        #expect(await wait { service.entitlement == .fullAccess }, "the listener never reported the purchase")
    }
}
