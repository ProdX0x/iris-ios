// EnglishTranslations.swift
// Layer: Tests (support)
// Purpose: The English of EN-4A, for the non-sensitive interface only. Buttons and titles take the Title Case an iOS
// control expects; the small lowercase labels Iris draws above its titles stay lowercase, because that casing is part
// of the design and not an accident of French. Nothing here adds a promise the French does not already make

import Foundation

enum EnglishTranslations {
    /// French and English legitimately identical: a format made only of punctuation, a version line, a word Apple
    /// spells the same way. Listed one by one so that no untranslated string can hide among them.
    static let identicalByDesign: Set<String> = [
        "about.version.line",
        "common.chapter.line",
        "common.chapterLevel.line",
        "game.pause.action",
        "levelIntro.chapterLevel.line",
        "pause.panel.title",
    ]

    static let byKey: [String: String] = [
        // About and legal
        "about.contact.action": "Email Support",
        "about.contact.address.label": "Contact address: %@",
        "about.contact.hint": "Opens a new message to Iris support",
        "about.entry.action": "About & Legal Information",
        "about.entry.hint": "Identity, version, links and privacy",
        "about.links.eyebrow": "links",
        "about.privacy.hint": "Opens the privacy policy on the Iris website",
        "about.privacy.title": "Privacy Policy",
        "about.role": "Design & Project Direction",
        "about.site.hint": "Opens the official Iris website",
        "about.site.title": "Official Website",
        "about.support.eyebrow": "support",
        "about.terms.hint": "Opens the standard license agreement on Apple's website",
        "about.terms.title": "Terms of Use",
        "about.title": "about",
        "about.version.line": "Version %@ (build %@)",

        // Carnet
        "carnet.undiscovered": "to be discovered",

        // Chapter map
        "chapters.card.label": "Chapter %lld, %@, %lld of %lld levels reached",
        "chapters.card.label.locked": "Chapter %lld, %@, %lld of %lld levels reached, full access required",
        "chapters.level.label": "Level %lld, %@",
        "chapters.level.locked": "locked",
        "chapters.level.toPlay": "to play",
        "chapters.locked.hint": "Finish chapter %@",
        "chapters.title": "chapters",

        // Shared controls and lines
        "common.back": "Back",
        "common.begin": "Begin",
        "common.cancel": "Cancel",
        "common.chapter.line": "%@ · %@",
        "common.chapterLevel.line": "%@ · %@ — %@",
        "common.chapters": "Chapters",
        "common.close": "Close",
        "common.continue": "Continue",
        "common.list.conjunction": " and ",
        "common.openSettings": "Open Settings",
        "common.pageIndicator": "Screen %lld of %lld",
        "common.replay": "Replay",
        "common.restart": "Restart",
        "common.resume": "Resume",
        "common.retry": "Try Again",
        "common.skip": "Skip",

        // In-game chrome
        "game.interrupted.title": "interrupted",
        "game.level.label": "Level %@",
        "game.pause.action": "Pause",
        "game.resuming.title": "resuming",

        // Threshold
        "home.action.begin": "Begin",
        "home.action.replay": "Replay a Chapter",
        "home.action.resume": "Continue",
        "home.replayChapter.action": "Replay a Chapter",

        // End of the journey
        "journey.playTime.label": "play time",

        // Level intro card
        "levelIntro.chapterLevel.line": "%@ · %@ — %lld",
        "levelIntro.chapters.action": "chapters",
        "levelIntro.new.badge": "new",

        // Navigation chrome, reserved until its display site is no longer frozen
        "navigation.destination.chapitres.title": "Chapters",
        "navigation.sheet.paywall.title": "Full Access",
        "navigation.sheet.settings.title": "Settings",

        // Pause
        "pause.detail": "Iris awaits your return.",
        "pause.panel.title": "pause",
        "pause.title": "paused",

        // Paywall
        "paywall.eyebrow": "full access",
        "paywall.full.eyebrow": "full access",
        "paywall.lockedChapter": "Chapter %@ is included with full access.",
        "paywall.priceUnavailable": "The price could not be retrieved from the App Store. Try again later: the free chapters stay open.",
        "paywall.progressIsKept": "Your progress is saved on this device: it will be waiting for you, no matter what.",
        "paywall.promotional.eyebrow": "temporary access",
        "paywall.redeem.action": "Redeem an Access Code",
        "paywall.restore.action": "Restore Purchases",
        "paywall.storeWorking": "Contacting the App Store",
        "paywall.title": "Full Access",
        "paywall.unlock.action": "Unlock Full Access",
        "paywall.unlock.withPrice": "Unlock · %@",

        // Progress ring
        "progress.percent.value": "%lld percent",

        // Purchase outcomes
        "purchase.failed": "The purchase did not complete.",
        "purchase.restored": "Your purchases have been restored.",
        "purchase.storeUnreachable": "The App Store cannot be reached right now.",
        "purchase.unlocked": "Full access unlocked.",

        // Level result
        "result.bestTime.badge": "best time",
        "result.chapterComplete.eyebrow": "chapter complete",
        "result.levelIndex.eyebrow": "level %lld",
        "result.new.badge": "new",
        "result.seeEnding.action": "See the Ending",

        // Settings
        "settings.access.eyebrow": "access",
        "settings.audio.ambience": "Ambient Sound",
        "settings.audio.soundEffects": "Sound Effects",
        "settings.haptics.label": "Haptics",
        "settings.navigationTitle": "settings",
        "settings.privacy.eyebrow": "privacy",
        "settings.reset.action": "Reset Progress",
        "settings.reset.confirmAction": "Reset",

        // Generic status
        "status.pending": "pending",
    ]
}
