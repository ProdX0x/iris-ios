// CalibrationProfile.swift
// Layer: AR (calibration, pure Swift)
// Purpose: Persisted result of a gaze calibration: coefficients and the context they are valid for. No gaze data.

import Foundation

struct CalibrationProfile: Codable, Hashable, Sendable {
    static let currentVersion = 1

    var version: Int
    var transform: AffineTransform2D
    var axisMapping: AxisMapping
    var interfaceOrientation: String
    var viewportWidth: Double
    var viewportHeight: Double
    /// Nominal frame the transform was fitted against; must be reused when applying the transform.
    var nominalGeometry: NominalDisplayGeometry
    var createdAt: Date
    var validationMeanError: Double?
    var validationMaxError: Double?
    var isValid: Bool

    init(version: Int = CalibrationProfile.currentVersion,
         transform: AffineTransform2D,
         axisMapping: AxisMapping,
         interfaceOrientation: String,
         viewport: PlayfieldBounds,
         nominalGeometry: NominalDisplayGeometry,
         createdAt: Date,
         validationMeanError: Double?,
         validationMaxError: Double?,
         isValid: Bool) {
        self.version = version
        self.transform = transform
        self.axisMapping = axisMapping
        self.interfaceOrientation = interfaceOrientation
        self.viewportWidth = viewport.width
        self.viewportHeight = viewport.height
        self.nominalGeometry = nominalGeometry
        self.createdAt = createdAt
        self.validationMeanError = validationMeanError
        self.validationMaxError = validationMaxError
        self.isValid = isValid
    }

    var viewport: PlayfieldBounds { PlayfieldBounds(width: viewportWidth, height: viewportHeight) }

    /// A profile is reusable when it has the current model version, was validated, matches the viewport
    /// (within one percent) and the interface orientation, and is not older than `maximumAge`.
    func isCompatible(viewport: PlayfieldBounds, interfaceOrientation: String, now: Date,
                      maximumAge: TimeInterval = 30 * 24 * 3600) -> Bool {
        guard isValid else { return false }
        return isUsable(viewport: viewport, interfaceOrientation: interfaceOrientation, now: now, maximumAge: maximumAge)
    }

    /// Same context checks without the validity flag: the game may run on a profile the player chose to keep
    /// despite a mediocre validation, which still beats the nominal projection.
    func isUsable(viewport: PlayfieldBounds, interfaceOrientation: String, now: Date = Date(),
                  maximumAge: TimeInterval = 30 * 24 * 3600) -> Bool {
        guard version == Self.currentVersion, transform.isFinite else { return false }
        guard self.interfaceOrientation == interfaceOrientation else { return false }
        let widthMatches = abs(viewportWidth - viewport.width) <= viewport.width * 0.01
        let heightMatches = abs(viewportHeight - viewport.height) <= viewport.height * 0.01
        guard widthMatches && heightMatches else { return false }
        return now.timeIntervalSince(createdAt) <= maximumAge && createdAt <= now.addingTimeInterval(60)
    }

    /// Cheap check used before the viewport is known (route selection at launch).
    var isCurrentAndValid: Bool {
        version == Self.currentVersion && isValid && transform.isFinite
    }
}
