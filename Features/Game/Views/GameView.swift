// GameView.swift
// Layer: Presentation
// Purpose: The game screen: full-screen canvas, HUD and phase overlays

import SwiftUI

struct GameView: View {
    let viewModel: GameViewModel
    @Environment(\.displayScale) private var displayScale

    var body: some View {
        ZStack {
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
        .background(DSColor.backgroundSurface)
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
    GameView(viewModel: container.makeGameViewModel(navigator: container.makeAppCoordinator()))
}
