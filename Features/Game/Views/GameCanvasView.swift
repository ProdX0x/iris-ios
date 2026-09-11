// GameCanvasView.swift
// Layer: Presentation
// Purpose: Draws one scene snapshot; re-evaluated only when the snapshot changes

import SwiftUI

struct GameCanvasView: View {
    let snapshot: GameSceneSnapshot
    private let renderer = GameSceneRenderer()

    var body: some View {
        Canvas(rendersAsynchronously: false) { context, size in
            renderer.draw(snapshot, in: &context, size: size)
        }
        .accessibilityHidden(true)
    }
}

/// Isolates the per-frame observation of `snapshot` so the rest of the game screen is not re-evaluated every tick.
struct GameCanvasHost: View {
    let viewModel: GameViewModel

    var body: some View {
        GameCanvasView(snapshot: viewModel.snapshot)
    }
}

#Preview {
    let session = GameSession(level: LevelCatalog.all[8], bounds: .referencePhone)
    GameCanvasView(snapshot: GameSceneSnapshot(session: session, showsGaze: true))
        .ignoresSafeArea()
}
