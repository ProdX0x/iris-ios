// CameraAccessNavigating.swift
// Layer: Presentation
// Purpose: Navigation intents emitted by the camera permission screen

import Foundation

@MainActor
protocol CameraAccessNavigating: AnyObject {
    func cameraAccessGranted()
    func cameraAccessAbandoned()
}
