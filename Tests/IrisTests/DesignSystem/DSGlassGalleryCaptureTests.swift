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
        let typeSize: DynamicTypeSize
        let view: AnyView
    }

    private func selection(_ name: String, _ page: DSGlassSelectionGallery.Page, _ ground: GalleryDemoGround.Intensity,
                           _ typeSize: DynamicTypeSize = .large) -> Shot {
        Shot(name: name, typeSize: typeSize, view: AnyView(DSGlassSelectionGallery(page: page, ground: ground)))
    }

    private func reference(_ name: String, _ page: DSGlassGallery.Page, _ ground: DSGlassGallery.Ground,
                           _ typeSize: DynamicTypeSize = .large) -> Shot {
        Shot(name: name, typeSize: typeSize, view: AnyView(DSGlassGallery(page: page, ground: ground)))
    }

    /// Pages of one run; the simulator's accessibility settings change between runs, outside the test. The
    /// "phase2" run redraws the phase 2 pages under their original names, to compare them with their first captures.
    private func shots(for set: String) -> [Shot] {
        switch set {
        case "normal":
            [selection("selection-iris-rich-normal", .selection, .rich),
             selection("selection-iris-calm-normal", .selection, .calm),
             selection("selection-iris-rich-large-text", .largeText, .rich, .accessibility2),
             selection("panels-comparison", .panels, .rich),
             selection("chrome-comparison", .chrome, .rich),
             selection("prominent-comparison", .prominent, .rich)]
        case "contraste":
            [selection("selection-iris-rich-high-contrast", .selection, .rich)]
        case "transparence":
            [selection("selection-iris-rich-reduce-transparency", .selection, .rich)]
        default:
            [reference("normal-roles-simple", .roles, .simple),
             reference("normal-comparaison-simple", .comparaison, .simple),
             reference("normal-roles-riche", .roles, .riche),
             reference("normal-comparaison-riche", .comparaison, .riche),
             reference("normal-texte-grand-riche", .texte, .riche, .accessibility2)]
        }
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
            window.rootViewController = UIHostingController(rootView: shot.view.dynamicTypeSize(shot.typeSize))
            try await Task.sleep(for: .milliseconds(1_500))
            let image = directory.appendingPathComponent("\(shot.name).png")
            try Data().write(to: directory.appendingPathComponent("ready-\(shot.name)"))
            var waited = 0
            while !FileManager.default.fileExists(atPath: image.path), waited < 150 {
                try await Task.sleep(for: .milliseconds(200))
                waited += 1
            }
            #expect(FileManager.default.fileExists(atPath: image.path), "\(shot.name) was captured")
            lines.append("\(shot.name) · texte \(shot.typeSize)")
        }
        window.isHidden = true
        window.rootViewController = nil
        try (lines.joined(separator: "\n") + "\n").write(to: directory.appendingPathComponent("manifest-\(set).txt"), atomically: true, encoding: .utf8)
    }
}
