// LocalizationClassification.swift
// Layer: Tests (support)
// Purpose: Decides, by rule and not by opinion, which sentences may be translated now and which must wait. A wrong
// English word in a gameplay instruction does not read badly — it tells the player to move their eyes the wrong way.
// Every rule here therefore errs towards waiting: a key reaches NON_SENSITIVE only when nothing about it touches the
// gesture, the gaze, a measurement, or a promise the app has to keep

import Foundation
@testable import Iris

enum LocalizationClass: String {
    /// Plain interface: controls, titles, navigation, commerce wording that carries no instruction.
    case nonSensitive = "NON_SENSITIVE"
    /// Anything whose meaning could change what the player does, or what the app promises. Deferred to EN-5.
    case sensitiveEN5 = "SENSITIVE_EN5"
    /// Present in the catalogue, not read at runtime: their only display site is frozen.
    case reserved = "RESERVED"
}

enum LocalizationClassification {
    /// Screens that exist to teach, measure, or justify the gaze. Nothing in them is only decoration.
    static let sensitiveFamilies: Set<String> = [
        "access", "camera", "eclats", "gaze", "gazeAssistance", "gazeLearning", "gazeReadiness",
        "gazeSetup", "gazeStatus", "gazeVerdict", "howToPlay", "onboarding", "unavailable",
    ]

    /// A key naming a thing of the game, whatever its sentence says.
    static let sensitiveKeyTokens = ["eclat", "iris", "gaze", "regard"]

    /// The gesture, the body, the measure, the space, and the names of what is on screen. Matched on the French,
    /// after the app's own name is removed: « Iris » capitalised is the app, « iris » lowercase is the thing a
    /// sphere must reach.
    static let gestureLexicon = [
        "regard", "yeux", "œil", "oeil", "visage", "tête", "tete", "clign", "calibr", "précis", "precis",
        "écart", "ecart", "distance", " cm", "immobile", "bouge", "fixe", "suiv", "halo", "repère", "repere",
        "lueur", "balise", "braise", "veilleuse", "lanterne", "sphère", "sphere", "pouss", "éloign", "eloign",
        "rapproch", "gauche", "droite", "haut", "bas ", "iris", "éclat", "eclat",
        "face à l'écran", "replacez", "placez",
    ]

    /// Comment markers written in EN-3, each one placed where a mistranslation changes what the app promises.
    static let sensitiveMarkers = ["FUNCTIONAL", "COMMERCIAL", "PRIVACY", "LEGAL"]

    /// Keys the rules cleared but the translation itself sent back. « Seuil » and « Carnet » are not labels: they
    /// name a place and an object of Iris's world, in the same register as the chapter names. Choosing their English
    /// alone would settle a piece of the campaign's vocabulary from a tab bar, so they wait for EN-5 with the rest.
    static let returnedByTranslation: Set<String> = [
        "carnet.title",
        "common.threshold",
        "navigation.destination.carnet.title",
        "navigation.destination.seuil.title",
    ]

    /// The rule, applied in order. Deterministic: the same catalogue always yields the same answer.
    static func classify(table: String, key: String, french: String, comment: String) -> LocalizationClass {
        if returnedByTranslation.contains(key) { return .sensitiveEN5 }
        if comment.contains("RESERVED") { return .reserved }
        if table == IrisText.gameplayTable { return .sensitiveEN5 }
        if sensitiveMarkers.contains(where: comment.contains) { return .sensitiveEN5 }
        if sensitiveFamilies.contains(key.split(separator: ".").first.map(String.init) ?? "") { return .sensitiveEN5 }
        let loweredKey = key.lowercased()
        if sensitiveKeyTokens.contains(where: loweredKey.contains) { return .sensitiveEN5 }
        let probe = french.replacingOccurrences(of: "Iris", with: "").lowercased()
        if gestureLexicon.contains(where: probe.contains) { return .sensitiveEN5 }
        return .nonSensitive
    }

    /// One French sentence cannot be sensitive on one screen and harmless on another: whatever is deferred anywhere
    /// is deferred everywhere. This is what keeps « Comment jouer » from being translated as a sheet title while the
    /// same words wait, as a screen title, for EN-5.
    static func classifyAll(_ entries: [(table: String, key: String, french: String, comment: String)])
        -> [String: LocalizationClass] {
        var result: [String: LocalizationClass] = [:]
        for entry in entries {
            result["\(entry.table)|\(entry.key)"] = classify(table: entry.table, key: entry.key,
                                                             french: entry.french, comment: entry.comment)
        }
        let deferred = Set(entries.filter { result["\($0.table)|\($0.key)"] == .sensitiveEN5 }.map(\.french))
        for entry in entries where deferred.contains(entry.french) {
            if result["\(entry.table)|\(entry.key)"] == .nonSensitive {
                result["\(entry.table)|\(entry.key)"] = .sensitiveEN5
            }
        }
        return result
    }

    /// A reserved key may be translated only when nothing else about it is deferred — its words included.
    static func mayTranslate(key: String, french: String, deferredFrench: Set<String>) -> Bool {
        !deferredFrench.contains(french)
    }
}
