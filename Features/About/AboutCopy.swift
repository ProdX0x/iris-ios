// AboutCopy.swift
// Layer: Presentation
// Purpose: Who made Iris, the four addresses a player or Apple may need, and the copyright — written once here, read
// by the about page, asserted by the tests, repeated nowhere else. The version is never written down: it is read
// from the bundle that runs

import Foundation

enum AboutCopy {
    static let appName = "IRIS"

    // MARK: Identity

    static let role = "Conception & direction du projet"
    static let creatorName = "Stéphane SAULNIER"
    /// The line the app displays. App Store Connect owns its own copyright field, without the symbol.
    static let copyright = "© 2026 Stéphane SAULNIER"

    // MARK: Addresses

    static let siteTitle = "Site officiel"
    static let siteAddress = "https://www.steve-s.net/iris/"
    static var siteURL: URL? { URL(string: siteAddress) }

    static let contactTitle = "Assistance"
    static let contactEmail = "contact@steve-s.net"
    static let contactAction = "Écrire à l'assistance"
    static var contactURL: URL? { URL(string: "mailto:\(contactEmail)") }

    static let privacyTitle = "Politique de confidentialité"
    static let privacyAddress = "https://www.steve-s.net/iris/privacy-iris/"
    static var privacyURL: URL? { URL(string: privacyAddress) }

    static let termsTitle = "Conditions d'utilisation"
    static let termsDetail = "Iris est couvert par le contrat de licence standard d'Apple."
    static let termsAddress = "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
    static var termsURL: URL? { URL(string: termsAddress) }

    // MARK: Version

    /// What stands in for a value the bundle does not carry. A build should never show it.
    static let unknownValue = "—"

    static var version: String { bundleValue("CFBundleShortVersionString") }
    static var build: String { bundleValue("CFBundleVersion") }
    static var versionLine: String { "Version \(version) (build \(build))" }

    private static func bundleValue(_ key: String) -> String {
        guard let value = Bundle.main.infoDictionary?[key] as? String, !value.isEmpty else { return unknownValue }
        return value
    }
}
