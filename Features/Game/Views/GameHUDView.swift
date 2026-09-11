// GameHUDView.swift
// Layer: Presentation
// Purpose: Level readout, pause control, gaze and sound status (the reference engine's HUD texts)

import SwiftUI

struct GameHUDView: View {
    let levelNumber: Int
    let levelCount: Int
    let targetCount: Int
    let isSequential: Bool
    let gazeState: GazeTrackingState
    let audioStatus: AudioStatus
    let isSimulatedGaze: Bool
    let showsPause: Bool
    let onPause: () -> Void

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: DSSpacing.xs) {
                    Text("niveau \(levelNumber) / \(levelCount)")
                        .dsEyebrowStyle(tint: DSColor.textPrimary)
                    Text(targetCount > 1 ? "\(targetCount) sphères" : "1 sphère")
                        .font(DSFont.footnote)
                        .foregroundStyle(DSColor.textSecondary)
                }
                .accessibilityElement(children: .combine)
                Spacer()
                if showsPause {
                    Button(action: onPause) {
                        Image(systemName: "pause.fill")
                            .font(DSFont.headline)
                            .foregroundStyle(DSColor.textPrimary)
                            .frame(width: 44, height: 44)
                            .background(DSColor.backgroundSurface.opacity(0.7), in: Circle())
                            .overlay(Circle().strokeBorder(DSColor.lineSubtle, lineWidth: 1))
                    }
                    .accessibilityLabel("Pause")
                }
            }
            Spacer()
            VStack(alignment: .leading, spacing: DSSpacing.s) {
                if isSequential {
                    Text("la validation ne compte que dans l'ordre 1, 2, 3…")
                        .font(DSFont.footnote)
                        .foregroundStyle(DSColor.textSecondary.opacity(0.8))
                }
                HStack(spacing: DSSpacing.s) {
                    DSBadge(gazeLabel, tone: gazeTone)
                    DSBadge(audioLabel, tone: audioTone)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, DSSpacing.m)
        .padding(.vertical, DSSpacing.s)
    }

    private var gazeLabel: String {
        if isSimulatedGaze { return "mode : simulateur (toucher)" }
        switch gazeState {
        case .idle: return "regard : inactif"
        case .starting: return "regard : initialisation"
        case let .tracking(faceVisible): return faceVisible ? "mode : regard" : "regard : visage perdu"
        case .interrupted: return "regard : interrompu"
        case .unavailable: return "regard : indisponible"
        case .failed: return "regard : erreur"
        }
    }

    private var gazeTone: DSBadge.Tone {
        if isSimulatedGaze { return .info }
        switch gazeState {
        case .tracking(true): return .success
        case .tracking(false), .starting, .idle: return .neutral
        case .interrupted, .unavailable, .failed: return .danger
        }
    }

    private var audioLabel: String {
        switch audioStatus {
        case .active: "son : actif"
        case .inactive: "son : coupé"
        case .interrupted: "son : interrompu"
        case .unavailable: "son : indisponible"
        }
    }

    private var audioTone: DSBadge.Tone {
        switch audioStatus {
        case .active: .success
        case .inactive, .interrupted: .neutral
        case .unavailable: .danger
        }
    }
}

/// Reads only the coarse ViewModel properties, never the per-frame snapshot.
struct GameHUDHost: View {
    let viewModel: GameViewModel

    var body: some View {
        GameHUDView(levelNumber: viewModel.levelNumber,
                    levelCount: viewModel.levelCount,
                    targetCount: viewModel.targetCount,
                    isSequential: viewModel.isSequential,
                    gazeState: viewModel.gazeState,
                    audioStatus: viewModel.audioStatus,
                    isSimulatedGaze: viewModel.isSimulatedGaze,
                    showsPause: viewModel.phase == .playing,
                    onPause: { viewModel.pause() })
    }
}

#Preview {
    GameHUDView(levelNumber: 9, levelCount: 14, targetCount: 3, isSequential: true,
                gazeState: .tracking(faceVisible: true), audioStatus: .active, isSimulatedGaze: false,
                showsPause: true, onPause: {})
        .background(DSColor.backgroundPrimary)
}
