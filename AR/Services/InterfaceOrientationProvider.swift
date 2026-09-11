// InterfaceOrientationProvider.swift
// Layer: AR
// Purpose: The interface orientation actually used by the foreground window scene, never a hard-coded value

import Foundation
import UIKit

@MainActor
protocol InterfaceOrientationProvider: AnyObject {
    var interfaceOrientation: UIInterfaceOrientation { get }
}

extension UIInterfaceOrientation {
    /// Stable name stored with a calibration profile.
    var irisName: String {
        switch self {
        case .portrait: "portrait"
        case .portraitUpsideDown: "portraitUpsideDown"
        case .landscapeLeft: "landscapeLeft"
        case .landscapeRight: "landscapeRight"
        case .unknown: "unknown"
        @unknown default: "unknown"
        }
    }

    /// Unknown orientations fall back to portrait, the only orientation Iris supports.
    var resolvedForGaze: UIInterfaceOrientation {
        self == .unknown ? .portrait : self
    }
}

@MainActor
final class WindowSceneOrientationProvider: InterfaceOrientationProvider {
    init() {}

    var interfaceOrientation: UIInterfaceOrientation {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let active = scenes.first { $0.activationState == .foregroundActive } ?? scenes.first
        return (active?.interfaceOrientation ?? .portrait).resolvedForGaze
    }
}

@MainActor
final class FixedOrientationProvider: InterfaceOrientationProvider {
    let interfaceOrientation: UIInterfaceOrientation

    init(_ orientation: UIInterfaceOrientation = .portrait) {
        self.interfaceOrientation = orientation
    }
}
