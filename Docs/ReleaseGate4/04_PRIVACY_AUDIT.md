# 04 — Audit de confidentialité

Audit du code, pas des intentions. 17 septembre 2026, `release/iris-appstore-rc1` @ `42ca32a`.

## Ce que la caméra fait

Une seule configuration : `ARFaceTrackingConfiguration`, estimation de lumière désactivée, un visage au plus.
Par image, le code lit la transformation du visage et des deux yeux, `lookAtPoint`, la matrice de vue, et
**deux blend shapes seulement** (`eyeBlinkLeft`, `eyeBlinkRight`).

**Aucune image n'est conservée.** La recherche de `capturedImage`, `CVPixelBuffer`, `CVImageBuffer`, `sceneDepth`,
`capturedDepthData`, `CIImage`, `CGImage`, `UIImage` dans les sources de la cible n'a retourné **aucun résultat**.
L'`ARFrame` est consommé dans la méthode qui le reçoit et n'en sort pas. Ce qui subsiste en mémoire est une
structure de scalaires, écrasée à chaque image et remise à `nil` à l'arrêt.

## Ce qui est stocké

Un seul artefact dérivé du regard : le profil de calibration.

| | |
|---|---|
| Support | `UserDefaults.standard` — ni Keychain, ni fichier, ni base |
| Clé | `iris.gaze.calibrationProfile` |
| Contenu | version, **6 coefficients affines**, deux énumérations d'axe, orientation, taille du viewport, géométrie nominale de l'écran, date, deux résidus de validation, un booléen |

**Aucun point de regard, aucune ancre de visage, aucun blend shape, aucune géométrie faciale n'est enregistré.**
Les fixations qui servent à ajuster la transformation n'existent qu'en mémoire pendant la calibration ; seule la
transformation ajustée survit.

Les sept autres clés persistées — progression, sons, ambiance, vibrations, mode d'aide au regard, deux drapeaux
d'introduction — ne contiennent aucune donnée de regard.

**En Release, l'app n'écrit aucun fichier dans son conteneur.** Les trois fichiers de journal qui existent
(`iris-lifecycle.log`, `iris-storekit.log`, et les captures `iris-debug-*.jsonl`) sont tous entièrement enveloppés
dans `#if DEBUG` ; le dernier exige en plus un argument de lancement que Release ne lit jamais. C'est le seul code
du dépôt qui écrive des coordonnées de regard sur disque, et il ne part pas avec l'app.

## Réseau : il n'y en a pas

Recherche de `URLSession`, `URLRequest`, `NWConnection`, `NWPath`, `CFNetwork`, `import Network`, `socket`,
`WKWebView`, `import WebKit`, `dataTask`, `uploadTask`, `downloadTask`, `import CloudKit`, dans toutes les sources
de la cible : **une seule occurrence, et c'est un commentaire** dans le manifeste de confidentialité.

Recherche de littéraux `http(s)://` dans `*.swift *.plist *.yml *.xcprivacy *.storekit *.pbxproj` : **deux
occurrences, toutes deux la DTD d'en-tête d'un fichier plist.** Aucune URL de support, aucune URL de politique,
aucun hôte n'est compilé dans l'application.

Les quatre `openURL` du code pointent tous vers les Réglages du système d'Apple.

Le trafic StoreKit a lieu dans le processus d'Apple ; l'app ne transmet aucun identifiant — `appAccountToken`
n'apparaît nulle part.

## Ce qui est absent, après recherche

| Recherché | Trouvé |
|---|---|
| Firebase, Crashlytics, Sentry, Amplitude, Mixpanel, AppsFlyer, Adjust, Google Analytics | aucun |
| `os_signpost`, `MetricKit`, rapporteur de crash | aucun |
| IDFA, `ASIdentifierManager`, `AppTrackingTransparency`, `identifierForVendor`, UUID persisté | aucun |
| Compte, connexion, backend, clé d'API, OAuth | aucun |
| SDK tiers, `Package.swift`, `Package.resolved`, `.xcframework`, Pods, Carthage | aucun |
| Fichier `.entitlements`, App Groups, iCloud, notifications push | aucun |
| `SKAdNetworkItems` dans l'Info.plist | absent |

**Tous les imports de la cible sont des frameworks Apple** : Foundation, SwiftUI, simd, Observation, os, UIKit,
StoreKit, AVFoundation, ARKit, QuartzCore, OSLog. Confirmé sur le binaire Release construit : `otool -L` ne liste
que des frameworks système et le runtime Swift, et le bundle n'a pas de dossier `Frameworks/`.

## Journalisation en Release

Les lignes qui subsistent en Release rapportent : l'état du suivi (`idle`, `tracking(faceVisible:)`), la taille du
viewport, une erreur ARKit, la moyenne et le maximum des résidus de calibration, l'identifiant d'un niveau avec
son temps et ses intrusions, et l'état d'entitlement.

**Aucune ligne de Release ne contient une coordonnée de regard, une mesure de visage ou un blend shape.** La
sortie la plus proche du regard est une précision agrégée en points et un booléen « visage visible ».

## Le manifeste de confidentialité

`Resources/PrivacyInfo.xcprivacy`, **vérifié présent à la racine du bundle Release construit** (1 572 octets).

| Clé | Valeur |
|---|---|
| `NSPrivacyTracking` | `false` |
| `NSPrivacyTrackingDomains` | vide |
| `NSPrivacyCollectedDataTypes` | **vide** |
| API à raison déclarée | `UserDefaults` → `CA92.1` ; `SystemBootTime` → `35F9.1` |

Les deux catégories déclarées correspondent à des usages réels du code. Les catégories non déclarées — horodatage
de fichier, espace disque, claviers actifs — ne sont utilisées nulle part : recherche faite, zéro occurrence.

## Permission caméra

`NSCameraUsageDescription`, unique `NS*UsageDescription` du projet :

> « Iris utilise la caméra frontale TrueDepth pour détecter la direction de votre regard : c'est ce regard qui
> repousse les sphères du jeu. Les images restent sur l'appareil, ne sont jamais enregistrées ni envoyées. »

Elle dit à quoi sert la caméra, ce que le regard fait dans le jeu, et ce qui n'arrive pas aux images. Les deux
affirmations sont vérifiées ci-dessus. Le texte demandé par le mandat est plus court ; celui-ci le couvre et
ajoute la garantie de non-conservation. **Il est conservé tel quel.**

## Tableau pour le questionnaire App Privacy

Définition d'Apple : « collecter » = transmettre hors de l'appareil.

| Type de donnée | Réponse | Fondement |
|---|---|---|
| Coordonnées (nom, e-mail, téléphone, adresse) | NON COLLECTÉ | aucun compte, aucun champ de saisie, aucun réseau |
| Santé et forme | NON COLLECTÉ | aucun HealthKit ; les figures oculomotrices ne quittent pas l'appareil |
| Informations financières | NON COLLECTÉ | l'achat a lieu dans le processus d'Apple ; aucun reçu ni jeton écrit |
| Localisation | NON COLLECTÉ | aucun CoreLocation, aucune description d'usage |
| **Données sensibles (biométrie)** | **NON COLLECTÉ** | les données TrueDepth sont consommées image par image et jetées ; aucun maillage, aucun blend shape, aucune géométrie oculaire n'est stocké ni transmis. Face ID n'est jamais sollicité |
| Contacts | NON COLLECTÉ | aucun framework Contacts |
| **Photos ou vidéos** | **NON COLLECTÉ** | aucune image n'est jamais retenue ni écrite |
| Audio | NON COLLECTÉ | aucun usage du microphone |
| Autre contenu utilisateur | NON COLLECTÉ | la progression reste locale |
| Historique de navigation / recherche | NON COLLECTÉ | ni WebKit, ni recherche |
| Identifiants | NON COLLECTÉ | ni IDFA, ni IDFV, ni UUID persisté |
| Achats | NON COLLECTÉ | l'entitlement est lu à la volée, jamais stocké ni transmis |
| Données d'usage | NON COLLECTÉ | aucun analytics, aucun suivi d'événement |
| Diagnostics | NON COLLECTÉ | aucun rapporteur de crash ; les journaux de debug ne partent pas |
| **Suivi (au sens ATT)** | **NON** | aucun framework ATT, aucun SDK publicitaire, aucun courtier |

Réponse cohérente à donner dans App Store Connect : **« Non, nous ne collectons aucune donnée. »** C'est aussi ce
que déclare le manifeste.

## Verdict

```
PRIVACY — CODE : PASS
```

Aucun code embarqué ne contredit la déclaration. Ce qui manque est **hors du code** :

- **la politique de confidentialité n'est pas publiée**, et son texte se termine encore par « Contact : *(adresse
  à indiquer)* ». App Store Connect exige une URL hébergée pour toute app qui accède à la caméra ;
- il n'existe **aucun moyen pour le joueur d'effacer son profil de calibration** — `CalibrationStore.clear()` n'a
  aucun appelant, et « Réinitialiser la progression » ne touche pas la calibration. Désinstaller suffit, donc ce
  n'est pas bloquant, mais un bouton serait défendable vu l'origine de la donnée ;
- le profil de calibration part dans les **sauvegardes iCloud/iTunes**, comme tout `UserDefaults`. Son contenu est
  six coefficients affines et des métadonnées d'écran, pas de la biométrie — il faut pouvoir le dire à un
  relecteur sans hésiter.
