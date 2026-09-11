// GazeSetupIntent.swift
// Layer: Presentation
// Purpose: Why the gaze setup runs: first launch, quick revalidation of a stored profile, or manual recalibration

import Foundation

enum GazeSetupIntent: Hashable, Sendable {
    case firstRun
    case revalidate
    case recalibrate
}
