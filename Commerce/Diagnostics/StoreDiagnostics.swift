// StoreDiagnostics.swift
// Layer: Commerce (DEBUG instrumentation)
// Purpose: One structured line per store read, written to standard output so that `devicectl … --console` can
// capture it from a physical device. It answers one question: what did StoreKit actually return, on which device,
// in which environment. It never prints an Apple Account, a token, a receipt or any part of one.

#if DEBUG
import Foundation
import StoreKit

enum StoreDiagnostics {
    /// Marker the capture scripts grep for.
    static let marker = "IRIS-STOREKIT"

    /// Everything a differential between two devices needs, and nothing else.
    static func report(requested: Set<String>,
                       returned: [Product],
                       fullGameDisplayPrice: String?,
                       failure: (any Error)?,
                       entitlement: AccessEntitlement) async {
        var fields: [(String, String)] = [
            ("device.model", hardwareModel),
            ("device.ios", systemVersion),
            ("app.version", bundleValue("CFBundleShortVersionString")),
            ("app.build", bundleValue("CFBundleVersion")),
            ("app.bundle", Bundle.main.bundleIdentifier ?? "-"),
            ("app.configuration", "DEBUG"),
            ("request.ids", requested.sorted().joined(separator: "|")),
            ("result.count", "\(returned.count)"),
            ("result.ids", returned.map(\.id).sorted().joined(separator: "|")),
            ("result.types", returned.map { "\($0.id)=\($0.type.rawValue)" }.sorted().joined(separator: "|")),
            ("result.displayPrice", fullGameDisplayPrice ?? "(none)"),
            ("entitlement", String(describing: entitlement)),
        ]
        if let failure {
            let nsError = failure as NSError
            fields.append(("error.domain", nsError.domain))
            fields.append(("error.code", "\(nsError.code)"))
            fields.append(("error.description", String(describing: failure)))
        } else {
            fields.append(("error.domain", "(none)"))
        }
        fields.append(contentsOf: await storeEnvironment())
        let body = fields.map { "\($0.0)=\($0.1)" }.joined(separator: " ")
        print("\(marker) \(body)")
    }

    /// Storefront and transaction environment, when the public API can answer at all. `AppStore.Environment` is the
    /// value that tells a StoreKit-testing run (`xcode`) apart from a sandbox or production one.
    private static func storeEnvironment() async -> [(String, String)] {
        var fields: [(String, String)] = []
        if let storefront = await Storefront.current {
            fields.append(("storefront.country", storefront.countryCode))
            fields.append(("storefront.id", storefront.id))
        } else {
            fields.append(("storefront.country", "(none)"))
        }
        do {
            let shared = try await AppTransaction.shared
            switch shared {
            case let .verified(appTransaction):
                fields.append(("appTransaction.environment", appTransaction.environment.rawValue))
                fields.append(("appTransaction.verified", "yes"))
            case let .unverified(appTransaction, _):
                fields.append(("appTransaction.environment", appTransaction.environment.rawValue))
                fields.append(("appTransaction.verified", "no"))
            }
        } catch {
            let nsError = error as NSError
            fields.append(("appTransaction.environment", "(unavailable)"))
            fields.append(("appTransaction.error", "\(nsError.domain)/\(nsError.code)"))
            fields.append(("appTransaction.errorDescription", String(describing: error)))
        }
        return fields
    }

    // MARK: Device facts

    /// "iPhone15,2" for an iPhone 14 Pro, "iPhone16,1" for an iPhone 15 Pro.
    private static var hardwareModel: String {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        guard size > 0 else { return "(unknown)" }
        var buffer = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.machine", &buffer, &size, nil, 0)
        let bytes = buffer.prefix { $0 != 0 }.map { UInt8(bitPattern: $0) }
        return String(decoding: bytes, as: UTF8.self)
    }

    private static var systemVersion: String {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
    }

    private static func bundleValue(_ key: String) -> String {
        Bundle.main.object(forInfoDictionaryKey: key) as? String ?? "-"
    }
}
#endif
