// RootView.swift
// Layer: Presentation (Navigation)
// Purpose: Renders the coordinator's route: the three destinations inside the system's tab bar, every immersive
// route full screen without navigation chrome, the sheets (settings, full access, how to play) and the first-launch
// explanation; forwards scene phase changes to the game and starts the store once the interface is up

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
            if let destination = AppDestination(route: coordinator.route) {
                destinations(selection: destination)
                    .transition(transition)
            } else {
                immersive
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
                    .presentationDragIndicator(.visible)
            case .paywall:
                PaywallView()
                    .environment(coordinator)
                    .presentationDragIndicator(.visible)
            case .howToPlay:
                HowToPlayView()
                    .environment(coordinator)
                    .presentationDragIndicator(.visible)
            }
        }
        // First launch only, and only over a destination: it explains the game and may be skipped at once.
        .fullScreenCover(isPresented: onboardingBinding) {
            OnboardingView { coordinator.completeOnboarding() }
        }
        // The store starts here, after the first frame: it never delays the interface coming up.
        .task { coordinator.activate() }
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

    /// Seuil, Chapitres and Carnet in the system's tab bar: it draws its own glass and steps aside while scrolling.
    private func destinations(selection: AppDestination) -> some View {
        TabView(selection: destinationBinding(current: selection)) {
            NavigationStack {
                HomeView()
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button { coordinator.showSettings() } label: {
                                Label(AppSheet.settings.title, systemImage: "slider.horizontal.3")
                            }
                            .accessibilityLabel(AppSheet.settings.title)
                        }
                    }
                    .toolbarBackground(.hidden, for: .navigationBar)
            }
            .tabItem { Label(AppDestination.seuil.title, systemImage: AppDestination.seuil.systemImage) }
            .tag(AppDestination.seuil)

            ChaptersView()
                .tabItem { Label(AppDestination.chapitres.title, systemImage: AppDestination.chapitres.systemImage) }
                .tag(AppDestination.chapitres)

            CarnetView()
                .tabItem { Label(AppDestination.carnet.title, systemImage: AppDestination.carnet.systemImage) }
                .tag(AppDestination.carnet)
        }
        .dsTabBarMinimizesOnScroll()
    }

    /// Permission, calibration, game, journey end and unavailability take the whole screen: no tab bar, no toolbar.
    @ViewBuilder
    private var immersive: some View {
        switch coordinator.route {
        case .cameraAccess:
            if let viewModel = coordinator.cameraAccessViewModel {
                CameraAccessView(viewModel: viewModel)
            }
        case .gazeSetup:
            if let viewModel = coordinator.gazeSetupViewModel {
                GazeSetupView(viewModel: viewModel)
            }
        case .game:
            if let viewModel = coordinator.gameViewModel {
                GameView(viewModel: viewModel)
            }
        case let .journeyComplete(summary):
            JourneyCompleteView(summary: summary)
        case let .unavailable(reason):
            UnavailableView(reason: reason)
        case .home, .chapters, .carnet:
            EmptyView()
        }
    }

    private func destinationBinding(current: AppDestination) -> Binding<AppDestination> {
        Binding(get: { current }, set: { coordinator.show($0) })
    }

    private var sheetBinding: Binding<AppSheet?> {
        Binding(get: { coordinator.sheet }, set: { coordinator.sheet = $0 })
    }

    /// The explanation opens by itself only before it has been gone through, and never over an immersive route.
    private var onboardingBinding: Binding<Bool> {
        Binding(get: { !coordinator.onboarding.hasCompletedOnboarding && AppDestination(route: coordinator.route) != nil },
                set: { if !$0 { coordinator.completeOnboarding() } })
    }

    private var transition: AnyTransition {
        reduceMotion ? .opacity : .opacity.combined(with: .scale(scale: 0.985))
    }
}
