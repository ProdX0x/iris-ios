// IrisApp.swift
// Layer: App
// Purpose: Application entry point: builds the composition root and the coordinator once

import SwiftUI

@main
struct IrisApp: App {
    @State private var coordinator = AppContainer.live().makeAppCoordinator()

    var body: some Scene {
        WindowGroup {
            RootView(coordinator: coordinator)
        }
    }
}
