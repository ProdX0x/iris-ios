// PaywallCopy.swift
// Layer: Presentation
// Purpose: The sentences of the commercial screens, every one of them derived from the access policy and from the
// store's own price. No number of chapters and no price is ever written here

import Foundation

enum PaywallCopy {
    /// "I, II et III", read from the access policy and the campaign, never written down.
    static var freeChapterList: String {
        let numerals = AccessPolicy.freeChapters(in: Campaign.chapters).map(\.numeral)
        guard let last = numerals.last else { return "" }
        guard numerals.count > 1 else { return last }
        return numerals.dropLast().joined(separator: ", ") + " et " + last
    }

    static var freeChapters: String {
        "Les chapitres \(freeChapterList) restent gratuits, pour toujours."
    }

    static let whatIsBought = "L'accès complet ouvre tous les autres chapitres d'Iris, et ceux qui viendront ensuite."

    static var notASubscription: String {
        IrisText.interface("paywall.notASubscription", french: "Achat unique. Aucun abonnement, aucun renouvellement.")
    }

    static let progressIsKept = "Votre progression est gardée sur l'appareil : elle vous attend quoi qu'il arrive."

    /// The main action. The price is the one the store formats; Iris never composes one.
    static func unlockTitle(price: String?) -> String {
        guard let price else { return "Débloquer l'accès complet" }
        return "Débloquer · \(price)"
    }

    static let restore = "Restaurer mes achats"
    static let redeemCode = "Utiliser un code d'accès"
    static let priceUnavailable = "Le prix n'a pas pu être lu sur l'App Store. Réessayez plus tard : les chapitres gratuits restent ouverts."

    /// What a locked chapter says about itself on the map.
    static func lockedChapter(_ chapter: ChapterDefinition) -> String {
        "Le chapitre \(chapter.numeral) fait partie de l'accès complet."
    }

    /// What a temporary access says once it has ended.
    static let promotionalAccessEnded = "Votre accès temporaire est terminé. Les chapitres gratuits restent ouverts, et votre progression est intacte."
}
