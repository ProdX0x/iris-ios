// CalibrationStore.swift
// Layer: AR (calibration)
// Purpose: Local persistence of the calibration profile (UserDefaults JSON) behind a protocol

import Foundation

protocol CalibrationStore: AnyObject, Sendable {
    func load() -> CalibrationProfile?
    func save(_ profile: CalibrationProfile)
    func clear()
}

final class UserDefaultsCalibrationStore: CalibrationStore, @unchecked Sendable {
    private static let key = "iris.gaze.calibrationProfile"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> CalibrationProfile? {
        guard let data = defaults.data(forKey: Self.key) else { return nil }
        return try? JSONDecoder().decode(CalibrationProfile.self, from: data)
    }

    func save(_ profile: CalibrationProfile) {
        guard let data = try? JSONEncoder().encode(profile) else { return }
        defaults.set(data, forKey: Self.key)
    }

    func clear() {
        defaults.removeObject(forKey: Self.key)
    }
}

final class InMemoryCalibrationStore: CalibrationStore, @unchecked Sendable {
    private let lock = NSLock()
    private var profile: CalibrationProfile?

    init(profile: CalibrationProfile? = nil) {
        self.profile = profile
    }

    func load() -> CalibrationProfile? {
        lock.withLock { profile }
    }

    func save(_ profile: CalibrationProfile) {
        lock.withLock { self.profile = profile }
    }

    func clear() {
        lock.withLock { profile = nil }
    }
}
