// RootView.swift
// Layer: Presentation (Navigation)
// Purpose: Renders the coordinator's route and sheet, forwards scene phase changes to the running game

import SwiftUI

struct RootView: View {
    @State private var coordinator: AppCoordinator
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(coordinator: AppCoordinator) {
        _coordinator = State(initialValue: coordinator)
    }

    var body: some View {
        ZStack {
            switch coordinator.route {
            case .home:
                HomeView()
                    .transition(transition)
            case .cameraAccess:
                if let viewModel = coordinator.cameraAccessViewModel {
                    CameraAccessView(viewModel: viewModel)
                        .transition(transition)
                }
            case .gazeSetup:
                if let viewModel = coordinator.gazeSetupViewModel {
                    GazeSetupView(viewModel: viewModel)
                        .transition(transition)
                }
            case .chapters:
                ChaptersView()
                    .transition(transition)
            case .carnet:
                CarnetView()
                    .transition(transition)
            case .game:
                if let viewModel = coordinator.gameViewModel {
                    GameView(viewModel: viewModel)
                        .transition(transition)
                }
            case let .journeyComplete(summary):
                JourneyCompleteView(summary: summary)
                    .transition(transition)
            case let .unavailable(reason):
                UnavailableView(reason: reason)
                    .transition(transition)
            }
        }
        .animation(DSMotion.animation(DSMotion.slowAnimation, reduceMotion: reduceMotion), value: coordinator.route)
        .environment(coordinator)
        .preferredColorScheme(.dark)
        .sheet(item: sheetBinding) { sheet in
            switch sheet {
            case .settings:
                SettingsView()
                    .environment(coordinator)
                    .presentationBackground(DSColor.Identity.surface)
                    .presentationDragIndicator(.visible)
            }
        }
        .onChange(of: scenePhase) { _, phase in
            switch phase {
            case .background, .inactive:
                if case .game = coordinator.route { coordinator.gameViewModel?.suspend() }
            case .active:
                if case .game = coordinator.route { coordinator.gameViewModel?.wake() }
            @unknown default:
                break
            }
        }
    }

    private var sheetBinding: Binding<AppSheet?> {
        Binding(get: { coordinator.sheet }, set: { coordinator.sheet = $0 })
    }

    private var transition: AnyTransition {
        reduceMotion ? .opacity : .opacity.combined(with: .scale(scale: 0.985))
    }
}
