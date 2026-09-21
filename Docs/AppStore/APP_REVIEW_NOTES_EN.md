# Iris — App Review Notes (en)

Version anglaise des notes pour l'App Review. **`APP_REVIEW_NOTES_FR.md` reste la source canonique** : ce document
en est la traduction fidèle, et toute correction de fond se fait d'abord côté français.

Le champ « App Review Information → Notes » d'App Store Connect est **global et non localisable** : une seule valeur
existe pour toute la fiche, quelle que soit la langue. C'est donc **ce document-ci** qui sera collé lors de la saisie,
l'anglais ayant été retenu par le pilote parce que la relecture d'Apple se fait le plus souvent dans cette langue et
que le montage Offer Code est le point le plus facile à mal comprendre.

Chaque affirmation est reprise de `APP_REVIEW_NOTES_FR.md`, `STOREKIT_PRODUCTS.md` et `PRIVACY_RELEASE_NOTES.md`.
Rien n'est inventé. Une seule phrase n'a pas d'équivalent français : celle qui signale au relecteur que l'app est
bilingue et comment changer sa langue — elle est vraie, vérifiée sur appareil, et utile à qui doit tester.

**Le document ne décrit pas la politique de renouvellement du produit promotionnel.** Aucune source locale ne peut
la prouver : `Config/Iris.storekit` déclare un abonnement hebdomadaire ordinaire, sans offre, et App Store Connect
n'a jamais été ouvert. Ce qui est affirmé ici se limite donc à ce que fait Iris — accorder l'accès tant que
StoreKit rapporte un droit vérifié et actif, le retirer sinon.

---

## Texte à coller dans App Store Connect

```
WHAT IRIS IS
Iris is a game. The TrueDepth front camera estimates where the player is looking, and that gaze pushes the spheres on screen away. The player must therefore learn to look beside what they want to move, to guide it to its target. Iris is a game of skill and attention. It makes no health promise.

HOW TO TEST QUICKLY
1. First launch: four screens explain the mechanic. They can be skipped, and seen again through "How to play".
2. Camera permission: asked at the first level only. The text shown is NSCameraUsageDescription.
3. Calibration: a short sequence of fixations. It can be redone from Settings > Recalibrate gaze.
4. A TrueDepth camera is required (UIRequiredDeviceCapabilities contains front-facing-camera, and the game checks ARFaceTrackingConfiguration.isSupported). Without it, Iris shows an unavailable screen instead of starting.
5. Hold the iPhone at eye level, an arm's length away, in steady light.
6. The app ships in French and English; the language can be switched in Settings > Apps > Iris > Language.

CAMERA AND GAZE
ARKit face data is used to compute a gaze direction, frame after frame, and to move the spheres. No camera image is recorded or transmitted; the processing is entirely local. This is game input and nothing more: Iris makes no health or medical measurement of any kind.

BUSINESS MODEL
- The app is free to download.
- Chapters I, II and III (19 levels out of 82) are playable without any purchase, forever.
- Chapters IV to XII require full access.
- Full access is a single non-consumable purchase: net.steve-s.iris.unlock.fullgame. It is not a subscription, and the interface says so.
- The displayed price comes from StoreKit (Product.displayPrice); no price is written in the app.
- "Restore purchases" is available on the full access screen and in the settings.

THE SECOND PRODUCT: PROMOTIONAL ACCESS
net.steve-s.iris.access.promopass is an auto-renewable subscription, used as the carrier for a promotional Offer Code. Its renewal settings live in App Store Connect and are not described here.
- It is never offered for sale in Iris: no "Subscribe" button, no subscription page, no price displayed for this product.
- The user only sees "Use an access code", which presents Apple's official redemption sheet (offerCodeRedemption).
- Iris recognises no code by itself: the binary contains no string comparison, no secret and no local date acting as a licence.
- Iris grants this access only while StoreKit reports a verified, active entitlement, and keeps no local flag that could outlive one.
- When that entitlement is no longer active, the paid chapters lock again; the player keeps their progress.

PRIVACY
- Iris contains no network code: no URLSession, no Network framework, no WebView, no backend, no third-party SDK, analytics, tracker or crash reporter.
- No camera image is recorded or sent; the ARKit face data used for the gaze computation is neither stored nor transmitted.
- Kept on the device: calibration coefficients, campaign progress, four preferences (sound, ambience, vibration, gaze marker) and one "explanation already seen" flag.
- No account is required. No sign-in is requested, apart from StoreKit's own for a purchase or a restore.
- PrivacyInfo.xcprivacy declares two required-reason APIs: NSPrivacyAccessedAPICategoryUserDefaults (CA92.1) and NSPrivacyAccessedAPICategorySystemBootTime (35F9.1). No data is collected, no tracking.

NO EXTERNAL PAYMENT
Every purchase goes through StoreKit and the App Store. Iris contains no external payment link, no redirection to a merchant site, no in-game currency.

THINGS TO KNOW WHILE TESTING
- The game is portrait only.
- Gaze tracking needs a few seconds to settle after calibration; if the face leaves the frame, the level pauses and resumes by itself.
- Head movements are used in a few optional end-of-chapter levels; they are announced on screen.
```

---

## Correspondance avec la source française

| Point demandé | Section anglaise | Source |
|---|---|---|
| 1. Ce qu'est Iris | WHAT IRIS IS | `APP_REVIEW_NOTES_FR.md` § « Ce qu'est Iris » |
| 2. Test rapide | HOW TO TEST QUICKLY | § « Comment tester rapidement » |
| 3. Caméra / TrueDepth | CAMERA AND GAZE, points 2 et 4 | § « Comment tester rapidement », `PRIVACY_RELEASE_NOTES.md` § 3 |
| 4. Rôle de l'estimation du regard | WHAT IRIS IS, CAMERA AND GAZE | § « Ce qu'est Iris » |
| 5. Absence de compte | PRIVACY | `PRIVACY_RELEASE_NOTES.md` § 3 |
| 6. Trois chapitres gratuits | BUSINESS MODEL | § « Modèle commercial », `STOREKIT_PRODUCTS.md` § 1 |
| 7. Achat unique | BUSINESS MODEL | § « Modèle commercial » |
| 8. Second produit / Offer Code | THE SECOND PRODUCT | § « Le second produit », `STOREKIT_PRODUCTS.md` § 3 |
| 9. Fonctionnement du renouvelable | THE SECOND PRODUCT | `STOREKIT_PRODUCTS.md` § 3 et § 4 |
| 10. Non commercialisé comme abonnement | THE SECOND PRODUCT | § « Le second produit », test I de `CommerceBoundaryTests` |
| 11. Aucun paiement externe | NO EXTERNAL PAYMENT | § « Aucun paiement externe » |
| 12. Confidentialité | PRIVACY | `PRIVACY_RELEASE_NOTES.md` § 1 à § 6 |
| 13. Instructions de test | HOW TO TEST QUICKLY, THINGS TO KNOW | § « Points d'attention pour le test » |

## Deux écarts assumés par rapport au français, et pourquoi

1. **Point 6 de « HOW TO TEST QUICKLY »** — la bilinguité de l'app et la bascule par application n'existent pas dans
   la version française, écrite avant EN‑8. C'est un fait vérifié sur iPhone 14 Pro physique le 21 septembre 2026, et
   c'est une information dont un relecteur a besoin. À retirer si le pilote préfère la stricte parité.
2. **« It is not a subscription, and the interface says so explicitly »** — le français cite la phrase exacte de
   l'interface. La citation est omise ici parce que la phrase anglaise affichée dans l'app relève du catalogue et non
   de ce document ; l'affirmation, elle, est identique et reste vérifiable à l'écran.

## Ce que ce document ne fait pas

La partie caméra reste **fonctionnelle**. Elle dit à quoi sert TrueDepth, ce que le signal contrôle, que le calcul
est local et que rien n'est enregistré ni envoyé. Elle ne présente le suivi du regard ni comme une mesure
biométrique de santé, ni comme une analyse médicale, ni comme un entraînement, ni comme une amélioration de la
vision ou de l'attention. La phrase « Iris is a game. It makes no health promise. » est reprise telle quelle de la
description App Store.

Le montage StoreKit n'est pas simplifié : l'abonnement auto‑renouvelable est nommé, son unique raison d'être est
donnée, et le fait qu'Iris ne reconnaisse aucun code par lui‑même est conservé — c'est précisément ce qu'un
relecteur doit pouvoir vérifier.
