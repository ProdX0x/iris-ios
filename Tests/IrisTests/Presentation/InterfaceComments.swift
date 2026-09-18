// InterfaceComments.swift
// Layer: Tests (support)
// Purpose: What a translator is told about each interface key. A comment is built from three things — the screen the
// key belongs to, the role its suffix names, and, where the sentence carries an obligation, an authored note. Anything
// with placeholders, anything commercial, and anything describing what the app really does is authored here: a
// mistranslation there is not a clumsy phrase, it is a promise the app does not keep

import Foundation

enum InterfaceComments {
    /// Keys whose catalogue entry declares a plural variation on the first argument.
    static let pluralKeys: Set<String> = ["eclats.outOfThree.value", "eclats.total.value"]

    /// Which screen, in one phrase.
    private static let families: [String: String] = [
        "about": "About and legal screen.",
        "access": "Access state, shown in the settings and on the paywall.",
        "camera": "Camera permission screen, shown before the gaze can be read.",
        "carnet": "Carnet, the collection of game elements the player has met.",
        "chapters": "Chapter map.",
        "common": "Shared control or line, used on several screens.",
        "eclats": "The marks a level awards, shown as a count.",
        "game": "In-game overlays, shown over a level in progress.",
        "gaze": "Gaze failure titles.",
        "gazeAssistance": "Gaze-assistance setting: how visible the gaze marker is during play.",
        "gazeLearning": "The screens that introduce the gaze marker, before the first level.",
        "gazeReadiness": "Gaze setup: the checks run before calibration.",
        "gazeSetup": "Gaze calibration.",
        "gazeStatus": "Calibration state, summarised in the pause panel.",
        "gazeVerdict": "The result of a calibration.",
        "home": "Threshold, the first screen.",
        "howToPlay": "How-to-play explanations.",
        "journey": "End of the journey, after the last level.",
        "levelIntro": "The card shown before a level starts.",
        "navigation": "Navigation chrome: tab bar and sheets.",
        "onboarding": "First-run introduction.",
        "pause": "Pause panel.",
        "paywall": "Paywall: what the full access is and how to get it.",
        "progress": "Progress indicator.",
        "purchase": "Result of a purchase or a restore.",
        "result": "The panel shown when a level is finished.",
        "settings": "Settings.",
        "status": "Generic status word.",
        "unavailable": "The screen shown on a device that cannot read the gaze.",
    ]

    /// What the last part of a key says the string is for.
    private static let roles: [String: String] = [
        "action": "Button label — keep it short enough for a control.",
        "title": "Title.",
        "eyebrow": "Small lowercase label above a title.",
        "detail": "Explanatory line under a title.",
        "message": "Message shown when something went wrong.",
        "hint": "VoiceOver hint: says what happens if the control is used.",
        "label": "VoiceOver label: what is read aloud, not what is drawn.",
        "note": "Side note, smaller than the body text.",
        "summary": "One line summarising a state.",
        "headline": "Headline.",
        "value": "A value read aloud or drawn next to a figure.",
        "line": "A composed line.",
    ]

    /// Where a mistranslation would cost something. Authored, key by key.
    private static let authored: [String: String] = [
        // --- Formats: every placeholder is described, in order. A lost or reordered one is a crash or a wrong number.
        "about.contact.address.label": "%@ is the support email address, unchanged in every language.",
        "about.version.line": "%@ is the version (1.0), then %@ the build number. Both are literal, never translated.",
        "chapters.card.label": "VoiceOver label of a chapter card. %lld is the chapter number, %@ its name, then the "
        + "number of levels reached and the number of levels it holds. Keep all four, in an order the sentence allows.",
        "chapters.card.label.locked": "Same as `chapters.card.label`, for a chapter the player has not bought. "
        + "%lld chapter number, %@ name, levels reached, levels in total. The ending says the full access is required.",
        "chapters.level.label": "VoiceOver label of a level. %lld is the level number inside its chapter, %@ its title.",
        "chapters.locked.hint": "%@ is a chapter numeral (I, II, III…). Says which chapter must be finished first.",
        "common.chapter.line": "%@ is a chapter numeral, %@ its name. The separator is a middle dot.",
        "common.chapterLevel.line": "%@ chapter numeral, %@ chapter name, %@ level title. Punctuation is part of the "
        + "design: a middle dot then an em dash.",
        "common.pageIndicator": "VoiceOver label of a page indicator. %lld is the current screen, %lld the total.",
        "eclats.outOfThree.value": "VoiceOver value: how many of a level's three marks are lit. %lld is that count. "
        + "The French keeps the plural form at every count, as validated; the plural slot is for the translation.",
        "eclats.total.value": "How many marks the player has, out of the campaign total. %lld earned, %lld possible.",
        "game.level.label": "VoiceOver label of the level mark in the HUD. %@ is the mark itself, e.g. « III · 2 ».",
        "game.trackingError.message": "%@ is the system's own error text, already localised by iOS. Do not translate "
        + "it, do not drop it: it is what a support request will quote.",
        "gazeSetup.insufficientSignal.message": "%lld is the number of the calibration point, counted from 1.",
        "gazeSetup.trackingError.message": "%@ is the system's own error text, already localised by iOS.",
        "gazeStatus.line": "%@ is the calibration headline. This form only adds the final period.",
        "gazeStatus.meanError.line": "%@ is the calibration headline, %lld the mean error as a percentage. `%%` is a "
        + "literal percent sign. FUNCTIONAL: the figure is a measured deviation, not a score and not an accuracy.",
        "levelIntro.chapterLevel.line": "%@ chapter numeral, %@ chapter name, %lld level number.",
        "paywall.freeChapters": "%@ is the list of free chapters in numerals, e.g. « I, II et III ». COMMERCIAL: the "
        + "chapters named here are free permanently — the sentence must not suggest a trial or a limited time.",
        "paywall.lockedChapter": "%@ is a chapter numeral. Says the chapter belongs to the paid access.",
        "paywall.unlock.withPrice": "Main purchase button. %@ is the price, already formatted by the App Store in the "
        + "player's currency. Never alter it, never add a currency, never round it.",
        "progress.percent.value": "VoiceOver value of a progress ring. %lld is a percentage from 0 to 100.",
        "result.levelIndex.eyebrow": "%lld is the level number inside its chapter.",
        "gazeVerdict.percent.value": "%lld is a percentage; `%%` is a literal percent sign.",
        "common.list.conjunction": "Joins the last two items of a list of chapter numerals: « I, II et III ». Keep the "
        + "spaces around the word. Only used inside `paywall.freeChapters`.",

        // --- Commerce: these sentences are the contract with the player.
        "paywall.notASubscription": "COMMERCIAL: Iris sells one non-consumable purchase. Never translate this as a "
        + "subscription, a plan, or anything renewing.",
        "paywall.whatIsBought": "COMMERCIAL: states what the money buys — every other chapter, and future ones. Do "
        + "not promise anything the sentence does not already promise.",
        "paywall.progressIsKept": "Reassurance: progress is stored on the device and survives the purchase.",
        "paywall.priceUnavailable": "Shown when the App Store did not return a price. Must keep both halves: the "
        + "price could not be read, and the free chapters stay open.",
        "paywall.promotionalAccessEnded": "COMMERCIAL: a temporary access has ended. Must say that the free chapters "
        + "stay open and that progress is intact — a player reading this has lost nothing.",
        "paywall.restore.action": "Restores purchases already made on this Apple Account. Apple's own wording in the "
        + "target language is the safest choice.",
        "paywall.redeem.action": "Opens the App Store offer-code sheet.",
        "paywall.storeWorking": "Shown while the App Store is being contacted.",
        "purchase.unverified": "FUNCTIONAL: the App Store could not verify the purchase, so nothing was granted. Do "
        + "not soften it into a delay.",
        "purchase.pending": "FUNCTIONAL: the purchase waits for someone else's approval (Ask to Buy). Nothing is "
        + "granted yet, and nothing was lost.",
        "purchase.nothingToRestore": "FUNCTIONAL: there is nothing to restore on this Apple Account. Not an error.",
        "purchase.storeUnreachable": "The App Store could not be reached. Temporary; the free chapters stay open.",
        "purchase.failed": "The purchase did not complete. Neutral: it is not the player's fault and nothing was charged.",
        "purchase.restored": "Purchases were restored successfully.",
        "purchase.unlocked": "The full access is now open.",
        "access.full.summary": "FUNCTIONAL: the full access is permanent and tied to the Apple Account, not the device.",
        "access.promotional.summary": "FUNCTIONAL: a temporary access opens everything, and when it ends the free "
        + "chapters stay open. Both halves matter.",
        "access.promotional.detail": "FUNCTIONAL: says the access lasts as long as its duration, no longer.",

        // --- Privacy and permissions: what is said here must be exactly what the app does.
        "camera.localProcessing.detail": "PRIVACY: this is a factual claim about the app. Nothing is recorded, nothing "
        + "is sent, nothing leaves the device. Translate it exactly; never weaken it and never strengthen it.",
        "camera.request.detail": "PRIVACY: explains what iOS is about to ask and what the camera is used for.",
        "camera.trueDepth.detail": "Describes what the TrueDepth camera does, about sixty times a second.",
        "camera.denied.detail": "The camera was refused; says the game cannot work without the gaze, and that it can "
        + "be allowed again in Settings.",
        "camera.denied.message": "Shorter form of the same, shown over a level.",
        "camera.restricted.detail": "FUNCTIONAL: the restriction comes from Screen Time or a management profile, not "
        + "from a refusal by the player. Keep that distinction.",
        "camera.restricted.message": "Shorter form of the same.",
        "camera.unsupported.message": "FUNCTIONAL: the device has no TrueDepth face tracking at all. Nothing the "
        + "player does can change it.",
        "camera.noCalibration.detail": "Says the game starts as soon as a face is detected.",
        "unavailable.detail": "FUNCTIONAL: this device cannot run Iris, because it has no TrueDepth camera.",
        "unavailable.devices.detail": "The devices that do work: iPhone and iPad with Face ID.",
        "about.terms.detail": "LEGAL: Iris uses Apple's standard licence agreement. Do not name another one.",
        "about.role": "The author's role on the project, next to their name.",

        // --- The gaze vocabulary: technical, and the player is judged by it.
        "gazeLearning.accuracy.note": "FUNCTIONAL: explains that a lower calibration deviation is better and that 0 % "
        + "is an ideal reference, not a requirement. The percent signs here are literal text, not placeholders.",
        "gazeVerdict.error.note": "FUNCTIONAL: the figure is expressed as a percentage of the screen's short side, "
        + "with thresholds at 18 % and 30 %. The percent signs are literal text.",
        "common.recalibrate": "Starts the calibration again.",
        "common.threshold": "Goes back to the threshold — the home screen, called « Seuil » in French. It is a place "
        + "in Iris, so it keeps a name rather than becoming « Home ».",
    ]

    static func comment(for key: String, french: String) -> String {
        var parts: [String] = []
        if let family = families[key.split(separator: ".").first.map(String.init) ?? ""] { parts.append(family) }
        if let role = roles[key.split(separator: ".").last.map(String.init) ?? ""] { parts.append(role) }
        if let note = authored[key] { parts.append(note) }
        if french.contains("%") && authored[key] == nil {
            parts.append("Contains a literal percent sign or a placeholder: keep it exactly as it is.")
        }
        return parts.joined(separator: " ")
    }
}
