// DeviceCapabilities.swift
// Layer: AR
// Purpose: Hardware capability probe (TrueDepth face tracking) behind a protocol for tests and previews

import Foundation
import ARKit

protocol DeviceCapabilities: Sendable {
    var supportsFaceTracking: Bool { get }
}

struct ARKitDeviceCapabilities: DeviceCapabilities {
    init() {}

    var supportsFaceTracking: Bool { ARFaceTrackingConfiguration.isSupported }
}

struct StaticDeviceCapabilities: DeviceCapabilities {
    let supportsFaceTracking: Bool

    init(supportsFaceTracking: Bool) {
        self.supportsFaceTracking = supportsFaceTracking
    }
}
