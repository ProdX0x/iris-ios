// UIKitHapticFeedbackService.swift
// Layer: Haptics
// Purpose: UIKit feedback generators kept alive for the session: medium impact for a validation, soft impact for a loss,
// success notification for a level; silently inert on hardware without a Taptic Engine or when System Haptics is off

import UIKit

@MainActor
final class UIKitHapticFeedbackService: HapticFeedbackService {
    private let validation = UIImpactFeedbackGenerator(style: .medium)
    private let loss = UIImpactFeedbackGenerator(style: .soft)
    private let completion = UINotificationFeedbackGenerator()

    /// Below full strength so the pulse stays a confirmation, not an event of its own.
    static let validationIntensity: CGFloat = 0.7
    /// Very light: the phone is held in the hand and looked at; a loss must never shake it.
    static let lossIntensity: CGFloat = 0.45

    func play(_ cue: HapticCue) {
        switch cue {
        case .prepare:
            validation.prepare()
        case .validation:
            validation.impactOccurred(intensity: Self.validationIntensity)
        case .loss:
            loss.impactOccurred(intensity: Self.lossIntensity)
        case .levelComplete:
            completion.notificationOccurred(.success)
        }
    }
}
