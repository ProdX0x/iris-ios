// DeviceIdiom.swift
// Layer: App (platform adapter)
// Purpose: Device idiom probe used to estimate the display geometry

import Foundation
import UIKit

enum DeviceIdiom {
    @MainActor static var isPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }
}
