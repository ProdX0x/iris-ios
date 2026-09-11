// FeedbackTiming.swift
// Layer: Domain
// Purpose: Spacing shared by every loss feedback (tone and pulse): one perceptible loss event, never a burst (R-15)

import Foundation

enum FeedbackTiming {
    /// Minimum spacing between two loss feedbacks. Losses in one tick (a cascade) already collapse into one event;
    /// this guard covers losses spread over consecutive ticks, so neither the ear nor the hand receives a stutter.
    /// The audio policy and the haptic policy read the same value: it is one business rule, not two settings.
    static let lossRetriggerInterval: TimeInterval = 0.15
}
