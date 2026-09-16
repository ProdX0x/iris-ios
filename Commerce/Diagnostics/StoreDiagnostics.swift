// StoreDiagnostics.swift
// Layer: Commerce (DEBUG instrumentation)
// Purpose: One structured line per store read, written to standard output AND appended to a file in the app's own
// container, so that a physical device can be measured either with `devicectl … --console` or by pulling the file
// afterwards. It answers one question: what did StoreKit actually return, on which device, in which environment.
// It never writes an Apple Account, a token, a receipt or any part of one.

#if DEBUG
import Foundation
import StoreKit

enum StoreDiagnostics {
    /// Marker the capture scripts grep for.
    static let marker = "IRIS-STOREKIT"
    /// File appended to inside the app's Documents directory, pullable with `devicectl device copy from`.
    static let fileName = "iris-storekit.log"

    /// The facts that must always be captured. This function performs **no await on StoreKit**: a store call that
    /// hangs (a receipt refresh waiting on a sign-in, for instance) can never prevent the measurement from landing.
    static func report(requested: Set<String>,
                       returned: [Product],
                       fullGameDisplayPrice: String?,
                       failure: (any Error)?,
                       entitlement: AccessEntitlement) {
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
        emit(fields)
        // The storefront and the transaction environment come from calls that may take their time, or never answer
        // at all. They are reported on their own line, and their absence costs nothing.
        Task { await reportEnvironment() }
    }

    /// Storefront and transaction environment, on a line of their own. `AppStore.Environment` is the value that
    /// tells a StoreKit-testing run (`xcode`) apart from a sandbox or a production one.
    private static func reportEnvironment() async {
        var fields: [(String, String)] = [("device.model", hardwareModel)]
        if let storefront = await Storefront.current {
            fields.append(("storefront.country", storefront.countryCode))
            fields.append(("storefront.id", storefront.id))
        } else {
            fields.append(("storefront.country", "(none)"))
        }
        emit(fields)

        var environment: [(String, String)] = [("device.model", hardwareModel)]
        do {
            switch try await AppTransaction.shared {
            case let .verified(appTransaction):
                environment.append(("appTransaction.environment", appTransaction.environment.rawValue))
                environment.append(("appTransaction.verified", "yes"))
            case let .unverified(appTransaction, _):
                environment.append(("appTransaction.environment", appTransaction.environment.rawValue))
                environment.append(("appTransaction.verified", "no"))
            }
        } catch {
            let nsError = error as NSError
            environment.append(("appTransaction.environment", "(unavailable)"))
            environment.append(("appTransaction.error", "\(nsError.domain)/\(nsError.code)"))
            environment.append(("appTransaction.errorDescription", String(describing: error)))
        }
        emit(environment)
    }

    // MARK: Writing

    private static func emit(_ fields: [(String, String)]) {
        let line = "\(marker) " + fields.map { "\($0.0)=\($0.1)" }.joined(separator: " ")
        print(line)
        append(line)
    }

    /// Appends to the app's own Documents directory. Failure is silent: the printed line remains.
    private static func append(_ line: String) {
        let directories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documents = directories.first else { return }
        let url = documents.appendingPathComponent(fileName)
        let stamped = "\(ISO8601DateFormatter().string(from: Date())) \(line)\n"
        guard let data = stamped.data(using: .utf8) else { return }
        if let handle = try? FileHandle(forWritingTo: url) {
            defer { try? handle.close() }
            _ = try? handle.seekToEnd()
            try? handle.write(contentsOf: data)
        } else {
            try? data.write(to: url)
        }
    }

    // MARK: Device facts

    /// "iPhone15,2" for an iPhone 14 Pro, "iPhone16,1" for an iPhone 15 Pro.
    private static var hardwareModel: String {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        guard size > 0 else { return "(unknown)" }
        var buffer = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.machine", &buffer, &size, nil, 0)
        return String(decoding: buffer.prefix { $0 != 0 }.map { UInt8(bitPattern: $0) }, as: UTF8.self)
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
