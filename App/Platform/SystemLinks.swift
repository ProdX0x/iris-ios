// SystemLinks.swift
// Layer: App (platform adapter)
// Purpose: System URLs the presentation layer may open (app settings)

import Foundation
import UIKit

enum SystemLinks {
    static var appSettings: URL? { URL(string: UIApplication.openSettingsURLString) }
}
