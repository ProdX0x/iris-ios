// GameHUDView.swift
// Layer: Presentation
// Purpose: Peripheral HUD: level mark, pause, contextual hint at the bottom, diagnostic badges when enabled

import SwiftUI

struct GameHUDView: View {
    let levelMark: String
    let hint: String?
    let showsPause: Bool
    let diagnostics: [String]?
    /// DEBUG lab readout of experimental levels (nil in the campaign and in Release).
    var readout: String? = nil
    let onPause: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text(levelMark)
                    .dsEyebrowStyle(tint: DSColor.textSecondary)
                    .accessibilityLabel("Niveau \(levelMark)")
                Spacer()
                Button(action: onPause) {
                    Image(systemName: "pause")
                        .font(DSFont.headline)
                        .foregroundStyle(DSColor.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(DSColor.backgroundSurface.opacity(0.6), in: Circle())
                        .overlay(Circle().strokeBorder(DSColor.lineSubtle, lineWidth: 1))
                }
                .opacity(showsPause ? 1 : 0)
                .disabled(!showsPause)
                .accessibilityLabel("Pause")
            }
            Spacer()
            if let hint {
                Text(hint)
                    .font(DSFont.callout)
                    .foregroundStyle(DSColor.textWarm)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, DSSpacing.m)
                    .padding(.vertical, DSSpacing.s)
                    .background(DSColor.fieldInk.opacity(0.55), in: Capsule())
                    .transition(.opacity)
                    .id(hint)
            }
            if let diagnostics {
                HStack(spacing: DSSpacing.s) {
                    ForEach(diagnostics, id: \.self) { DSBadge($0, tone: .info) }
                }
            }
            if let readout {
                Text(readout)
                    .font(DSFont.caption.monospaced())
                    .foregroundStyle(DSColor.textSecondary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(DSSpacing.s)
                    .background(DSColor.fieldInk.opacity(0.55), in: RoundedRectangle(cornerRadius: DSRadius.m, style: .continuous))
                    .accessibilityHidden(true)
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
                    hint: viewModel.phase == .playing ? viewModel.hint : nil,
                    showsPause: viewModel.phase == .playing,
                    diagnostics: viewModel.showsGazeIndicator ? diagnosticLabels : nil,
                    readout: labReadout,
                    onPause: { viewModel.pause() })
    }

    private var labReadout: String? {
        #if DEBUG
        return viewModel.phase == .playing ? viewModel.experimentReadout : nil
        #else
        return nil
        #endif
    }

    private var diagnosticLabels: [String] {
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
        return [gaze, sound]
    }
}

#Preview {
    GameHUDView(levelMark: "III · 2", hint: "Regardez juste sous la lueur : elle montera.", showsPause: true,
                diagnostics: nil, onPause: {})
        .background(DSColor.backgroundPrimary)
}
