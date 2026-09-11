// LaunchOptions.swift
// Layer: App (platform adapter)
// Purpose: Debug-only launch arguments used to reach any screen directly (simulator screenshots, manual QA)

import Foundation

struct LaunchOptions: Hashable, Sendable {
    var initialRoute: AppRoute?
    var autoplay = false
    var startingLevel: Int?
    /// Simulator only: parks the simulated gaze at this playfield point.
    var parkedGaze: Vector2?
    /// Simulator only: the simulated gaze fixates whatever target the setup shows (exercises calibration end to end).
    var oracleGaze = false

    static let none = LaunchOptions()

    /// Recognised arguments: `--iris-route <home|cameraAccess|gazeSetup|tutorial|game|journeyComplete|unavailable>`,
    /// `--iris-level <1...14>`, `--iris-autoplay`, `--iris-gaze <x,y>` and `--iris-oracle-gaze` (simulator only).
    static func parse(_ arguments: [String]) -> LaunchOptions {
        var options = LaunchOptions()
        var iterator = arguments.makeIterator()
        while let argument = iterator.next() {
            switch argument {
            case "--iris-route":
                options.initialRoute = iterator.next().flatMap(route(named:))
            case "--iris-level":
                options.startingLevel = iterator.next().flatMap(Int.init)
            case "--iris-autoplay":
                options.autoplay = true
            case "--iris-gaze":
                options.parkedGaze = iterator.next().flatMap(point(from:))
            case "--iris-oracle-gaze":
                options.oracleGaze = true
            default:
                continue
            }
        }
        return options
    }

    private static func point(from text: String) -> Vector2? {
        let parts = text.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        guard parts.count == 2 else { return nil }
        return Vector2(x: parts[0], y: parts[1])
    }

    private static func route(named name: String) -> AppRoute? {
        switch name {
        case "home": .home
        case "cameraAccess": .cameraAccess
        case "gazeSetup": .gazeSetup(.firstRun)
        case "tutorial": .tutorial
        case "game": .game
        case "journeyComplete": .journeyComplete(JourneySummary(levelCount: LevelCatalog.levelCount, playDuration: 754))
        case "unavailable": .unavailable(.faceTrackingUnsupported)
        default: nil
        }
    }
}
