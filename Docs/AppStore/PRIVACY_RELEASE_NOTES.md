# Iris — confidentialité : réponses pour App Store Connect

Tout ce qui suit a été établi en relisant le code, pas en le supposant. Les commandes de vérification sont données
pour que la relecture soit refaisable.

## 1. Iris ne contient aucun code réseau

```
grep -rn "URLSession\|import Network\|CFNetwork\|WKWebView\|URLRequest\|dataTask\|import CloudKit" \
  App AR Audio Commerce DesignSystem Domain Features GameEngine Haptics Navigation
```

→ **aucune occurrence**. Il n'existe dans Iris ni client HTTP, ni socket, ni WebView, ni backend, ni synchronisation
iCloud. Les seules communications réseau de l'app sont celles que **StoreKit** effectue lui-même, dans le processus
d'Apple, pour lire les produits, acheter et restaurer.

## 2. Aucun SDK tiers, aucun analytics, aucun tracker

Iris n'a **aucune dépendance externe** : pas de Swift Package, pas de CocoaPods, pas de Carthage, pas de framework
embarqué. Les seuls frameworks liés sont ceux d'Apple (SwiftUI, ARKit, AVFoundation, StoreKit, CoreHaptics…).
Aucun AppTrackingTransparency, aucun IDFA, aucun crash reporter tiers.

## 3. Caméra et TrueDepth

| Question | Réponse | Preuve |
|---|---|---|
| Des images de la caméra sont-elles enregistrées ? | Non | `AR/Services/ARKitGazeTrackingService.swift` ne conserve aucun `CVPixelBuffer` et n'écrit aucun fichier |
| Des images sont-elles transmises ? | Non | aucun code réseau (§1) |
| Les données de visage sont-elles transmises ? | Non | idem |
| Les mesures de regard sont-elles transmises ? | Non | idem |
| Que reste-t-il de la caméra après une partie ? | Rien | la session ARKit est arrêtée quand l'écran de jeu se ferme |

Ce qui est calculé : à partir de `ARFaceAnchor`, Iris déduit une direction de regard, la projette sur l'écran, la
lisse, et s'en sert pour la physique. Rien de cela n'est persisté.

Ce qui est conservé sur l'appareil, et rien d'autre :

| Donnée | Où | Contenu |
|---|---|---|
| Coefficients de calibration | `UserDefaults` (`UserDefaultsCalibrationStore`) | une transformation affine 2D, une date, deux erreurs de validation |
| Progression de campagne | `UserDefaults` (`UserDefaultsProgressStore`) | temps, intrusions, pertes et éclats par niveau |
| Préférences | `UserDefaults` (`GameSettingsStore`) | quatre interrupteurs |
| Explication déjà vue | `UserDefaults` (`OnboardingStore`) | un booléen |

Aucune de ces données ne quitte l'appareil et aucune n'identifie la personne.

## 4. Réponses au questionnaire « App Privacy » d'App Store Connect

| Question | Réponse |
|---|---|
| Collectez-vous des données ? | **Non** |
| Suivi (tracking) au sens d'Apple ? | **Non** |
| Données liées à l'utilisateur ? | Aucune |
| Données non liées à l'utilisateur ? | Aucune |
| Identifiants (Device ID, User ID) ? | Aucun |
| Données d'usage / diagnostic ? | Aucune n'est transmise |
| Achats ? | Aucune donnée d'achat n'est collectée par Iris ; les transactions sont gérées par StoreKit et restent chez Apple |
| Contacts, localisation, contenus, santé, finances ? | Aucun |
| Photos / caméra ? | La caméra est **utilisée** mais rien n'en est **collecté** : aucune image n'est enregistrée ni transmise |

Rappel de la définition d'Apple : « collecter » signifie transmettre les données hors de l'appareil. Un traitement
entièrement local, sans transmission, ne constitue pas une collecte. C'est exactement le cas d'Iris.

## 5. Politique de confidentialité — texte prêt à publier

> **Confidentialité d'Iris**
>
> Iris utilise la caméra frontale TrueDepth de votre iPhone pour estimer la direction de votre regard. C'est ce
> regard qui déplace les sphères du jeu.
>
> Aucune image, aucune vidéo et aucune donnée de votre visage n'est enregistrée. Rien n'est envoyé : Iris ne
> contient aucun code réseau, aucun serveur, aucun service d'analyse et aucun outil de suivi publicitaire. Tout est
> calculé sur votre appareil, image après image, puis oublié.
>
> Iris conserve sur votre appareil, et nulle part ailleurs : les coefficients de calibration de votre regard, votre
> progression dans les chapitres, vos préférences de son et de vibrations. Supprimer l'application supprime ces
> données.
>
> Les achats sont gérés par l'App Store. Iris ne voit ni votre identifiant Apple, ni votre moyen de paiement ; il
> demande seulement à StoreKit si un achat valide existe pour cet appareil.
>
> Aucun compte n'est nécessaire pour jouer.
>
> Contact : *(adresse à indiquer)*

## 6. Privacy manifest

`Resources/PrivacyInfo.xcprivacy`, copié à la racine du bundle :

| Clé | Valeur | Raison |
|---|---|---|
| `NSPrivacyTracking` | `false` | aucun suivi |
| `NSPrivacyTrackingDomains` | vide | aucun domaine contacté |
| `NSPrivacyCollectedDataTypes` | vide | rien ne quitte l'appareil |
| `NSPrivacyAccessedAPICategoryUserDefaults` | `CA92.1` | préférences et progression, lisibles par la seule app |
| `NSPrivacyAccessedAPICategorySystemBootTime` | `35F9.1` | `ProcessInfo.systemUptime` horodate les échantillons de regard : durée écoulée entre événements internes |

Les libellés exacts des raisons viennent de la documentation Apple
(<https://developer.apple.com/documentation/bundleresources/app-privacy-configuration/nsprivacyaccessedapitypes/nsprivacyaccessedapitypereasons>),
consultée le 16 septembre 2026 :

- `CA92.1` — « Declare this reason to access user defaults to read and write information that is only accessible to
  the app itself. »
- `35F9.1` — « Declare this reason to access the system boot time in order to measure the amount of time that has
  elapsed between events that occurred within the app… Information accessed for this reason, or any derived
  information, may not be sent off-device. »

APIs à raison obligatoire **non utilisées** par Iris, donc non déclarées : horodatages de fichiers, espace disque,
claviers actifs.

## 7. Texte d'autorisation caméra

`Config/Info.plist` → `NSCameraUsageDescription` :

> « Iris utilise la caméra frontale TrueDepth pour détecter la direction de votre regard : c'est ce regard qui
> repousse les sphères du jeu. Les images restent sur l'appareil, ne sont jamais enregistrées ni envoyées. »

Cette phrase dit à la fois **à quoi sert** la caméra et **ce qui n'est pas fait** des images. Les deux affirmations
sont vérifiables dans le code (§1 et §3).
