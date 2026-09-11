// GameView.swift
// Layer: Presentation
// Purpose: The game screen: chambre noire background, world canvas, peripheral HUD and phase overlays

import SwiftUI

struct GameView: View {
    let viewModel: GameViewModel
    @Environment(\.displayScale) private var displayScale

    var body: some View {
        ZStack {
            DSBackground()
            GameCanvasHost(viewModel: viewModel)
                .ignoresSafeArea()
                .onGeometryChange(for: CGSize.self) { proxy in
                    proxy.size
                } action: { size in
                    viewModel.prepare(width: size.width, height: size.height, displayScale: displayScale)
                }
                .modifier(SimulatedPointerModifier(viewModel: viewModel))
            GameHUDHost(viewModel: viewModel)
            GameOverlayHost(viewModel: viewModel)
        }
        .background(DSColor.fieldInk)
        .statusBarHidden(true)
        .persistentSystemOverlays(.hidden)
        .onDisappear { viewModel.viewDisappeared() }
    }
}

/// In the simulator the pointer stands in for the gaze; on devices this modifier does nothing.
private struct SimulatedPointerModifier: ViewModifier {
    let viewModel: GameViewModel

    func body(content: Content) -> some View {
        #if targetEnvironment(simulator)
        content.gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .onChanged { value in
                    viewModel.simulatePointer(x: value.location.x, y: value.location.y,
                                              timestamp: value.time.timeIntervalSinceReferenceDate)
                }
        )
        #else
        content
        #endif
    }
}

#Preview {
    let container = AppContainer.preview()
    if let level = Campaign.level(id: "4-6") {
        GameView(viewModel: container.makeGameViewModel(level: level, navigator: container.makeAppCoordinator()))
    }
}
