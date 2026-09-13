// GameEvent.swift
// Layer: GameEngine
// Purpose: Facts produced by one engine tick, consumed by audio, haptics, hints and presentation

import Foundation

enum LossCause: Hashable, Sendable {
    /// The validated lueur drifted beyond the wobble tolerance.
    case drift
    /// A lower-ranked lueur lost its validation (R-11).
    case cascade
    /// The veilleuse lighting its iris went out (R-26).
    case veilleuse
    /// Chapter X: a well swallowed the validated lueur.
    case gouffre
}

enum GameEvent: Hashable, Sendable {
    case validationProgressed(sequence: Int, progress: Double)
    case validationProgressStopped(sequence: Int)
    case targetValidated(sequence: Int)
    case targetLost(sequence: Int, cause: LossCause)
    case levelCompleted
    /// A lueur entered the attention zone (it starts being repelled).
    case intrusion(sequence: Int)
    /// R-23: the gaze left the screen; irises are closed until it comes back.
    case attentionLeftField
    case attentionReturned
    case veilleuseLow(index: Int)
    case veilleuseOut(index: Int)
    case veilleuseRelit(index: Int)
    /// EXPERIMENTAL (prototype B1): a braise woke, went back to sleep, or flared.
    case braiseLit(sequence: Int)
    case braiseCooled(sequence: Int)
    case braiseFlared(sequence: Int)
    /// Chapter VII: the twins of `sequence` (the lower of the pair) came within reach, or lost each other.
    case twinsLinked(sequence: Int)
    case twinsParted(sequence: Int)
    /// Chapter VIII: a gust picked the lueur up, or let it go (end of the track, spill by the gaze).
    case lueurCarried(sequence: Int)
    case lueurDropped(sequence: Int)
    /// Chapter IX: an iris emitted its echo (at closing, then at every breath), or an echo woke a sleeping lueur.
    case echoEmitted(sequence: Int)
    case lueurWoken(sequence: Int)
    /// Chapter X: a well swallowed the lueur; the well sent it back to its start.
    case lueurSwallowed(sequence: Int)
    case lueurReturned(sequence: Int)
    /// PROTOTYPE (chapter I level 6): a balise woke (step index in the thread); the thread is complete; a latent lueur appeared.
    case baliseLit(balise: Int, step: Int)
    case balisesCompleted
    case lueurReleased(sequence: Int)
}
