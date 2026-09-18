// GameHUDView.swift
// Layer: Presentation
// Purpose: Peripheral HUD over the running level: level mark, the pause control and the contextual hint on the
// system's glass, diagnostic badges when enabled

import SwiftUI

struct GameHUDView: View {
    let levelMark: String
    let hint: String?
    let showsPause: Bool
    let diagnostics: [String]?
    let onPause: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text(levelMark)
                    .dsEyebrowStyle(tint: DSColor.Identity.textSecondary)
                    .accessibilityLabel("Niveau \(levelMark)")
                Spacer()
                Button(action: onPause) {
                    Image(systemName: "pause")
                        .font(DSFont.headline)
                        .frame(width: 44, height: 44)
                        .dsGlass(.clearControl)
                }
                .opacity(showsPause ? 1 : 0)
                .disabled(!showsPause)
                .accessibilityLabel(IrisText.interface("game.pause.action", french: "Pause"))
            }
            Spacer()
            if let hint {
                Text(hint)
                    .font(DSFont.callout)
                    .foregroundStyle(DSColor.Identity.textWarm)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, DSSpacing.m)
                    .padding(.vertical, DSSpacing.s)
                    .dsGlass(.chrome, in: .capsule)
                    .transition(.opacity)
                    .id(hint)
            }
            if let diagnostics {
                HStack(spacing: DSSpacing.s) {
                    ForEach(diagnostics, id: \.self) { DSBadge($0, tone: .info) }
                }
            }
        }
        .padding(.horizontal, DSSpacing.m)
        .padding(.top, DSSpacing.s)
        .padding(.bottom, DSSpacing.l)
        .animation(DSMotion.animation(.easeInOut(duration: 0.35), reduceMotion: reduceMotion), value: hint)
        .onChange(of: hint) { _, newHint in
            if let newHint {
                AccessibilityNotification.Announcement(newHint).post()
            }
        }
    }
}

/// Reads only the coarse ViewModel properties, never the per-frame snapshot.
struct GameHUDHost: View {
    let viewModel: GameViewModel

    var body: some View {
        GameHUDView(levelMark: "\(viewModel.chapter.numeral) · \(viewModel.level.index)",
                    // The engine hands over a bare sentence; its identity is rebuilt here, where the level
                    // is at hand. With no translation in the catalogue this returns the French received.
                    hint: viewModel.phase == .playing
                        ? viewModel.hint.map { HintText.localized($0, in: viewModel.level) }
                        : nil,
                    showsPause: viewModel.phase == .playing,
                    diagnostics: diagnosticLabels,
                    onPause: { viewModel.pause() })
    }

    /// Developer overlay only: tracking and sound state in words. Release builds show nothing here.
    private var diagnosticLabels: [String]? {
        #if DEBUG
        guard viewModel.showsDeveloperGazeDiagnostics else { return nil }
        return developerLabels
        #else
        return nil
        #endif
    }

    #if DEBUG
    private var developerLabels: [String] {
        let gaze: String
        if viewModel.isSimulatedGaze {
            gaze = "regard : simulé"
        } else {
            switch viewModel.gazeState {
            case .idle: gaze = "regard : inactif"
            case .starting: gaze = "regard : démarrage"
            case let .tracking(faceVisible): gaze = faceVisible ? "regard : suivi" : "regard : visage perdu"
            case .interrupted: gaze = "regard : interrompu"
            case .unavailable: gaze = "regard : indisponible"
            case .failed: gaze = "regard : erreur"
            }
        }
        let sound: String
        switch viewModel.audioStatus {
        case .active: sound = "son : actif"
        case .inactive: sound = "son : coupé"
        case .interrupted: sound = "son : interrompu"
        case .unavailable: sound = "son : indisponible"
        }
        var labels = [gaze, sound]
        if let oculo = viewModel.oculoStatus { labels.append(oculo) }
        return labels
    }
    #endif
}

#Preview {
    GameHUDView(levelMark: "III · 2", hint: "Regardez juste sous la lueur : elle montera.", showsPause: true,
                diagnostics: nil, onPause: {})
        .background(DSColor.Identity.ground)
}
