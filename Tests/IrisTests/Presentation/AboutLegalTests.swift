// AboutLegalTests.swift
// Layer: Tests
// Purpose: The about page carries the exact identity, addresses and copyright Apple and the player need; its version
// comes from the bundle that runs; nothing in it is a placeholder, and the v1 says nothing it was not asked to say.
// These tests assert values and never reach the network: the addresses were checked live during Release Gate 4H-A

import Foundation
import Testing
@testable import Iris

@Suite("About and legal")
struct AboutLegalTests {
    /// Project root, derived from this file's compile-time path (Tests/IrisTests/Presentation/...).
    private static var projectRoot: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
    }

    /// The two files that make the about surface, read as text.
    private func aboutSources() throws -> [(path: String, text: String)] {
        try ["Features/About/AboutCopy.swift", "Features/About/AboutView.swift"].map {
            ($0, try String(contentsOf: Self.projectRoot.appendingPathComponent($0), encoding: .utf8))
        }
    }

    @Test("A: the privacy policy address is exact and builds a valid URL")
    func privacyAddress() throws {
        #expect(AboutCopy.privacyAddress == "https://www.steve-s.net/iris/privacy-iris/")
        let url = try #require(AboutCopy.privacyURL)
        #expect(url.scheme == "https")
        #expect(url.absoluteString == AboutCopy.privacyAddress)
    }

    @Test("B: the official site address is exact and builds a valid URL")
    func siteAddress() throws {
        #expect(AboutCopy.siteAddress == "https://www.steve-s.net/iris/")
        let url = try #require(AboutCopy.siteURL)
        #expect(url.scheme == "https")
        #expect(url.absoluteString == AboutCopy.siteAddress)
    }

    @Test("C: the contact address is exact and builds a valid mailto URL")
    func contactAddress() throws {
        #expect(AboutCopy.contactEmail == "contact@steve-s.net")
        let url = try #require(AboutCopy.contactURL)
        #expect(url.scheme == "mailto")
        #expect(url.absoluteString == "mailto:contact@steve-s.net")
    }

    @Test("D: the terms link points at Apple's standard licence agreement")
    func termsAddress() throws {
        #expect(AboutCopy.termsAddress == "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")
        let url = try #require(AboutCopy.termsURL)
        #expect(url.scheme == "https")
        #expect(url.host() == "www.apple.com")
    }

    @Test("E: the person who made Iris is named exactly")
    func creator() {
        #expect(AboutCopy.creatorName == "Stéphane SAULNIER")
    }

    @Test("F: the role is the wording the release decided on")
    func role() {
        #expect(AboutCopy.role == "Conception & direction du projet")
    }

    @Test("G: the copyright shown in the app carries the symbol, the year and the holder")
    func copyright() {
        #expect(AboutCopy.copyright == "© 2026 Stéphane SAULNIER")
    }

    @Test("H: the version and the build are read from the bundle, never written down")
    func versionComesFromTheBundle() throws {
        let info = Bundle.main.infoDictionary
        let expectedVersion = (info?["CFBundleShortVersionString"] as? String).flatMap { $0.isEmpty ? nil : $0 } ?? AboutCopy.unknownValue
        let expectedBuild = (info?["CFBundleVersion"] as? String).flatMap { $0.isEmpty ? nil : $0 } ?? AboutCopy.unknownValue
        #expect(AboutCopy.version == expectedVersion)
        #expect(AboutCopy.build == expectedBuild)
        #expect(AboutCopy.versionLine == "Version \(expectedVersion) (build \(expectedBuild))")
        // No build number is spelled out in the sources: a new build must never require editing this page.
        for (path, text) in try aboutSources() {
            #expect(!text.contains("\"1.0\""), "\(path) writes a marketing version down")
            #expect(!text.contains("Version 1.0"), "\(path) writes a version line down")
            #expect(!text.contains("build 1)"), "\(path) writes a build number down")
        }
    }

    @Test("I: nothing in the about surface is a placeholder")
    func noPlaceholders() throws {
        // The two developer markers are assembled rather than written: `Tools/audit.py` scans this repository
        // for them, and a test that hunts them must not become a hit itself.
        let forbidden = ["TO" + "DO", "FIX" + "ME", "XXX", "Lorem", "lorem", "à fournir", "à indiquer", "à définir"]
        for (path, text) in try aboutSources() {
            for token in forbidden {
                #expect(!text.contains(token), "\(path) still carries the placeholder \(token)")
            }
        }
    }

    @Test("J: the v1 about surface shows no signature and claims no company")
    func noSignatureAndNoCompany() throws {
        let forbidden = ["ProdX0x", "SARL", "SAS ", "S.A.S", "Inc.", "Ltd", "GmbH", "société", "Société"]
        for (path, text) in try aboutSources() {
            for token in forbidden {
                #expect(!text.contains(token), "\(path) mentions \(token)")
            }
        }
    }

    @Test("K: the settings are the only way in, and they open the page itself")
    func settingsEntryPoint() throws {
        let settings = try String(contentsOf: Self.projectRoot.appendingPathComponent("Features/Settings/SettingsView.swift"), encoding: .utf8)
        #expect(settings.contains("AboutView()"))
        #expect(settings.contains("NavigationLink"))
    }
}
