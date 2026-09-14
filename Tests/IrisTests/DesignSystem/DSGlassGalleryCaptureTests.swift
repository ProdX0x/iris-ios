// DSGlassGalleryCaptureTests.swift
// Layer: Tests
// Purpose: Shows the Liquid Glass gallery pages one by one in a window of the test host, so that screenshots of the
// real composited glass are taken from outside the simulator (only when IRIS_GLASS_CAPTURE_DIR is set)

import SwiftUI
import Testing
import UIKit
@testable import Iris

/// Directory shared with the screenshot watcher outside the simulator; set it outside the repository.
private let glassCaptureDirectory = ProcessInfo.processInfo.environment["IRIS_GLASS_CAPTURE_DIR"]

@Suite("Liquid Glass gallery capture", .serialized)
@MainActor
struct DSGlassGalleryCaptureTests {
    private struct Shot {
        let name: String
        let page: DSGlassGallery.Page
        let ground: DSGlassGallery.Ground
        let typeSize: DynamicTypeSize
    }

    /// Pages of one run; the simulator's accessibility settings change between runs, outside the test.
    private func shots(for set: String) -> [Shot] {
        let rich = [Shot(name: "roles-riche", page: .roles, ground: .riche, typeSize: .large),
                    Shot(name: "comparaison-riche", page: .comparaison, ground: .riche, typeSize: .large),
                    Shot(name: "texte-grand-riche", page: .texte, ground: .riche, typeSize: .accessibility2)]
        guard set == "normal" else { return rich }
        return [Shot(name: "roles-simple", page: .roles, ground: .simple, typeSize: .large),
                Shot(name: "comparaison-simple", page: .comparaison, ground: .simple, typeSize: .large)] + rich
    }

    @Test("gallery pages wait on screen for an outside screenshot (only when IRIS_GLASS_CAPTURE_DIR is set)",
          .enabled(if: glassCaptureDirectory != nil))
    func showGallery() async throws {
        let directory = URL(fileURLWithPath: try #require(glassCaptureDirectory))
        let set = ProcessInfo.processInfo.environment["IRIS_GLASS_CAPTURE_SET"] ?? "normal"
        let scene = try #require(UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first, "a window scene")
        let window = UIWindow(windowScene: scene)
        window.windowLevel = UIWindow.Level(rawValue: UIWindow.Level.alert.rawValue + 1)
        window.overrideUserInterfaceStyle = .dark
        window.isHidden = false
        var lines = ["set \(set) · iOS \(UIDevice.current.systemVersion) · verre natif \(DSGlassRendering.isNativeGlassAvailable)"
                     + " · réduire la transparence \(UIAccessibility.isReduceTransparencyEnabled)"
                     + " · augmenter le contraste \(UIAccessibility.isDarkerSystemColorsEnabled)"
                     + " · réduire les animations \(UIAccessibility.isReduceMotionEnabled)"
                     + " · taille système \(UIApplication.shared.preferredContentSizeCategory.rawValue)"]
        for shot in shots(for: set) {
            let name = "\(set)-\(shot.name)"
            window.rootViewController = UIHostingController(rootView: DSGlassGallery(page: shot.page, ground: shot.ground).dynamicTypeSize(shot.typeSize))
            try await Task.sleep(for: .milliseconds(1_500))
            let image = directory.appendingPathComponent("\(name).png")
            try Data().write(to: directory.appendingPathComponent("ready-\(name)"))
            var waited = 0
            while !FileManager.default.fileExists(atPath: image.path), waited < 150 {
                try await Task.sleep(for: .milliseconds(200))
                waited += 1
            }
            #expect(FileManager.default.fileExists(atPath: image.path), "\(name) was captured")
            lines.append("\(name) · page \(shot.page.rawValue) · fond \(shot.ground.rawValue) · texte \(shot.typeSize)")
        }
        window.isHidden = true
        window.rootViewController = nil
        try (lines.joined(separator: "\n") + "\n").write(to: directory.appendingPathComponent("manifest-\(set).txt"), atomically: true, encoding: .utf8)
    }
}
