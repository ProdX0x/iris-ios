// StoreKitEntitlementService.swift
// Layer: Commerce
// Purpose: The only place in Iris that talks to StoreKit. It reads the rights the player holds (verified
// transactions only), keeps them up to date through Transaction.updates, sells the permanent unlock, restores
// purchases, and exposes one business value: the entitlement

import Foundation
import Observation
import OSLog
import StoreKit

@MainActor
@Observable
final class StoreKitEntitlementService: StorePurchasing {
    private(set) var entitlement: AccessEntitlement = .free
    private(set) var fullGameDisplayPrice: String?
    private(set) var isWorking = false
    private(set) var lastOutcome: StorePurchaseOutcome?

    @ObservationIgnored private var products: [String: Product] = [:]
    @ObservationIgnored private var updates: Task<Void, Never>?
    @ObservationIgnored private var hasStarted = false
    @ObservationIgnored private let logger = Logger(subsystem: "net.steve-s.iris", category: "commerce")
    #if DEBUG
    /// Kept only so the DEBUG store report can say why a read came back empty.
    @ObservationIgnored private var lastLoadFailure: (any Error)?
    #endif

    init() {}

    // MARK: Lifetime

    /// Starts the single Transaction.updates listener and reads what is already held. Idempotent: calling it again
    /// never opens a second listener. Nothing here runs before the first frame; both steps are asynchronous.
    func start() {
        guard !hasStarted else { return }
        hasStarted = true
        updates = Task { [weak self] in
            for await update in Transaction.updates {
                await self?.receive(update)
            }
        }
        Task { [weak self] in
            await self?.refresh()
        }
    }

    /// Reads the products and the rights again.
    func refresh() async {
        await loadProducts()
        await refreshEntitlements()
        #if DEBUG
        await StoreDiagnostics.report(requested: StoreProductID.all,
                                      returned: Array(products.values),
                                      fullGameDisplayPrice: fullGameDisplayPrice,
                                      failure: lastLoadFailure,
                                      entitlement: entitlement)
        #endif
    }

    // MARK: Reading the rights

    /// Re-reads every right the account currently holds for this app. Only verified transactions are trusted; a
    /// revoked, upgraded or expired one grants nothing. The strongest right wins.
    private func refreshEntitlements() async {
        var held: [AccessEntitlement] = []
        let now = Date()
        for await result in Transaction.currentEntitlements {
            guard case let .verified(transaction) = result else {
                logger.error("an unverified entitlement was refused")
                continue
            }
            guard transaction.revocationDate == nil else { continue }
            guard !transaction.isUpgraded else { continue }
            if let expiration = transaction.expirationDate, expiration <= now { continue }
            guard let right = StoreProductID.entitlement(for: transaction.productID) else { continue }
            held.append(right)
        }
        let resolved = AccessEntitlement.strongest(of: held)
        if resolved != entitlement {
            logger.info("entitlement is now \(String(describing: resolved), privacy: .public)")
        }
        entitlement = resolved
    }

    private func receive(_ update: VerificationResult<Transaction>) async {
        switch update {
        case let .verified(transaction):
            await transaction.finish()
            await refreshEntitlements()
        case .unverified:
            logger.error("an unverified transaction update was refused")
        }
    }

    // MARK: Products

    private func loadProducts() async {
        do {
            let loaded = try await Product.products(for: StoreProductID.all)
            products = Dictionary(loaded.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
            fullGameDisplayPrice = products[StoreProductID.fullGameUnlock]?.displayPrice
            #if DEBUG
            lastLoadFailure = nil
            #endif
        } catch {
            logger.error("the store did not return its products: \(error.localizedDescription, privacy: .public)")
            fullGameDisplayPrice = nil
            #if DEBUG
            lastLoadFailure = error
            #endif
        }
    }

    // MARK: Buying

    func purchaseFullGame() async {
        guard !isWorking else { return }
        isWorking = true
        defer { isWorking = false }
        if products[StoreProductID.fullGameUnlock] == nil {
            await loadProducts()
        }
        guard let product = products[StoreProductID.fullGameUnlock] else {
            lastOutcome = .unavailable
            return
        }
        do {
            await apply(try await product.purchase())
        } catch {
            apply(error)
        }
    }

    /// What the store answered, turned into a right and into what the player is told. The one decision point of the
    /// purchase; `purchase()` itself is Apple's call and the only part of the path a unit test cannot drive.
    func apply(_ result: Product.PurchaseResult) async {
        switch result {
        case let .success(verification):
            switch verification {
            case let .verified(transaction):
                await transaction.finish()
                await refreshEntitlements()
                lastOutcome = .purchased
            case .unverified:
                // A signature the App Store cannot vouch for grants nothing, whatever it claims.
                logger.error("a purchase came back unverified and was refused")
                lastOutcome = .unverified
            }
        case .pending:
            lastOutcome = .pending
        case .userCancelled:
            lastOutcome = .cancelled
        @unknown default:
            lastOutcome = .failed
        }
    }

    /// A store call that threw. A cancellation surfaced as an error is still a cancellation, not a failure to show.
    func apply(_ error: any Error) {
        if let storeError = error as? StoreKitError, case .userCancelled = storeError {
            lastOutcome = .cancelled
            return
        }
        logger.error("the purchase did not complete: \(error.localizedDescription, privacy: .public)")
        lastOutcome = .failed
    }

    // MARK: Restoring

    /// Asked for by the player, never on its own at launch: the system may present a sign-in.
    func restorePurchases() async {
        guard !isWorking else { return }
        isWorking = true
        defer { isWorking = false }
        do {
            try await AppStore.sync()
        } catch {
            logger.error("the store could not be synchronised: \(error.localizedDescription, privacy: .public)")
        }
        await refreshEntitlements()
        lastOutcome = entitlement == .free ? .nothingToRestore : .restored
    }

    func acknowledgeOutcome() {
        lastOutcome = nil
    }
}
