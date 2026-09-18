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
        return numerals.dropLast().joined(separator: ", ")
            + IrisText.interface("common.list.conjunction", french: " et ") + last
    }

    static var freeChapters: String {
        IrisText.interface("paywall.freeChapters", french: "Les chapitres %@ restent gratuits, pour toujours.", freeChapterList)
    }

    static let whatIsBought = IrisText.interface("paywall.whatIsBought", french: "L'accès complet ouvre tous les autres chapitres d'Iris, et ceux qui viendront ensuite.")

    static var notASubscription: String {
        IrisText.interface("paywall.notASubscription", french: "Achat unique. Aucun abonnement, aucun renouvellement.")
    }

    static let progressIsKept = IrisText.interface("paywall.progressIsKept", french: "Votre progression est gardée sur l'appareil : elle vous attend quoi qu'il arrive.")

    /// The main action. The price is the one the store formats; Iris never composes one.
    static func unlockTitle(price: String?) -> String {
        guard let price else { return IrisText.interface("paywall.unlock.action", french: "Débloquer l'accès complet") }
        return IrisText.interface("paywall.unlock.withPrice", french: "Débloquer · %@", price)
    }

    static let restore = IrisText.interface("paywall.restore.action", french: "Restaurer mes achats")
    static let redeemCode = IrisText.interface("paywall.redeem.action", french: "Utiliser un code d'accès")
    static let priceUnavailable = IrisText.interface("paywall.priceUnavailable", french: "Le prix n'a pas pu être lu sur l'App Store. Réessayez plus tard : les chapitres gratuits restent ouverts.")

    /// What a locked chapter says about itself on the map.
    static func lockedChapter(_ chapter: ChapterDefinition) -> String {
        IrisText.interface("paywall.lockedChapter", french: "Le chapitre %@ fait partie de l'accès complet.", chapter.numeral)
    }

    /// What a temporary access says once it has ended.
    static let promotionalAccessEnded = IrisText.interface("paywall.promotionalAccessEnded", french: "Votre accès temporaire est terminé. Les chapitres gratuits restent ouverts, et votre progression est intacte.")
}
