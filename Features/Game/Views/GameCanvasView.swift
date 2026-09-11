// GameCanvasView.swift
// Layer: Presentation
// Purpose: Draws one scene snapshot; re-evaluated only when the snapshot changes

import SwiftUI

struct GameCanvasView: View {
    let snapshot: GameSceneSnapshot
    let reduceMotion: Bool
    private let renderer = GameSceneRenderer()

    var body: some View {
        Canvas(rendersAsynchronously: false) { context, size in
            renderer.draw(snapshot, in: &context, size: size, reduceMotion: reduceMotion)
        }
        .accessibilityHidden(true)
    }
}

/// Isolates the per-frame observation of `snapshot` so the rest of the game screen is not re-evaluated every tick.
struct GameCanvasHost: View {
    let viewModel: GameViewModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GameCanvasView(snapshot: viewModel.snapshot, reduceMotion: reduceMotion)
    }
}

#Preview {
    if let level = Campaign.level(id: "6-5") {
        let bounds = PlayfieldBounds(width: 393, height: 852)
        let resolved = LevelResolver.resolve(level, in: bounds)
        ZStack {
            DSBackground()
            GameCanvasView(snapshot: GameSceneSnapshot(session: resolved.makeSession(), resolved: resolved, showsRoute: true, showsGaze: false, diagnostics: nil),
                           reduceMotion: false)
        }
        .ignoresSafeArea()
    }
}
