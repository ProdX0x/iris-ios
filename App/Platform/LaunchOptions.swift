// LaunchOptions.swift
// Layer: App (platform adapter)
// Purpose: Debug-only launch arguments used to reach any screen directly (simulator screenshots, manual QA)

import Foundation

struct LaunchOptions: Hashable, Sendable {
    enum SeededProgress: Hashable, Sendable {
        /// Every level up to and including this id is completed.
        case through(String)
        case all
    }

    var initialRoute: AppRoute?
    var autoplay = false
    /// Level id such as "3-2".
    var level: String?
    /// Simulator only: parks the simulated gaze at this playfield point.
    var parkedGaze: Vector2?
    /// Simulator only: the simulated gaze fixates whatever target the setup shows (exercises calibration end to end).
    var oracleGaze = false
    /// Volatile progress used instead of the stored one.
    var seededProgress: SeededProgress?

    static let none = LaunchOptions()

    /// Recognised arguments: `--iris-route <home|cameraAccess|gazeSetup|chapters|carnet|game|journeyComplete|unavailable>`,
    /// `--iris-level <c-i>`, `--iris-autoplay`, `--iris-gaze <x,y>`, `--iris-oracle-gaze`, `--iris-progress <all|c-i>`.
    static func parse(_ arguments: [String]) -> LaunchOptions {
        var options = LaunchOptions()
        var iterator = arguments.makeIterator()
        while let argument = iterator.next() {
            switch argument {
            case "--iris-route":
                options.initialRoute = iterator.next().flatMap(route(named:))
            case "--iris-level":
                options.level = iterator.next().flatMap { Campaign.level(id: $0) != nil ? $0 : nil }
            case "--iris-autoplay":
                options.autoplay = true
            case "--iris-gaze":
                options.parkedGaze = iterator.next().flatMap(point(from:))
            case "--iris-oracle-gaze":
                options.oracleGaze = true
            case "--iris-progress":
                options.seededProgress = iterator.next().flatMap(seed(named:))
            default:
                continue
            }
        }
        return options
    }

    /// Deterministic, varied progress for screenshots: éclats alternate between one, two and three.
    static func progress(for seeded: SeededProgress) -> CampaignProgress {
        var progress = CampaignProgress()
        let levels = Campaign.levels
        let lastIndex: Int
        switch seeded {
        case .all:
            lastIndex = levels.count - 1
        case let .through(id):
            lastIndex = levels.firstIndex { $0.id == id } ?? -1
        }
        guard lastIndex >= 0 else { return progress }
        for (index, level) in levels.enumerated() where index <= lastIndex {
            let time = index % 3 == 0 ? level.par.time * 1.3 : level.par.time * 0.8
            let intrusions = index % 2 == 0 ? level.par.intrusions : level.par.intrusions + 4
            progress.register(LevelOutcome(time: time, intrusions: intrusions, losses: 0), for: level)
            progress.encounter(level.introduces)
        }
        return progress
    }

    private static func seed(named name: String) -> SeededProgress? {
        if name == "all" { return .all }
        return Campaign.level(id: name) != nil ? .through(name) : nil
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
        case "chapters": .chapters
        case "carnet": .carnet
        case "game": .game
        case "journeyComplete": .journeyComplete(JourneySummary(levelCount: 34, playDuration: 5_412, eclats: 81, maxEclats: 102))
        case "unavailable": .unavailable(.faceTrackingUnsupported)
        default: nil
        }
    }
}
