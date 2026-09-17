# 02 — Build et tests de la Release Candidate

Mesuré le 17 septembre 2026 sur `release/iris-appstore-rc1` @ `42ca32a`. Xcode 26.3 (17C529).

## Builds

| Build | Configuration | Destination | Résultat |
|---|---|---|---|
| Debug simulateur | Debug | iPhone 17 Pro (iOS 26.3) | **BUILD SUCCEEDED** |
| Release simulateur | Release | iPhone 17 Pro (iOS 26.3) | **BUILD SUCCEEDED** |
| Release appareil signé | Release | `generic/platform=iOS` | **BUILD SUCCEEDED** |

Aucun avertissement propre à Iris. Le seul message émis est
`appintentsmetadataprocessor … No AppIntents.framework dependency found`, une note d'outil Apple sans rapport.

## Tests

### Sur le runtime par défaut (iOS 26.3)

```
Test run with 567 tests in 80 suites passed
échecs : 0
ignorés : 5   (captures visuelles, IRIS_CAPTURE_DIR non défini)
known issues : 17   (toutes à StoreKitEntitlementTests.swift:45)
** TEST SUCCEEDED **
```

Identique au Gate 3 : aucune régression, aucun test converti en skip.

### Les 17 « known issues », enfin levées

Ce ne sont pas des échecs déguisés : le runtime iOS 26.3 refuse les sessions de test StoreKit — `storekitd`
répond `SKInternalErrorDomain 3` — et la suite enregistre alors une *known issue* nommant la limitation plutôt que
de prétendre avoir prouvé quelque chose.

Le dépôt documentait le contournement. Il a été exécuté, sur le simulateur `Iris-SK-18` (iOS 18.6) déjà présent :

```
xcodebuild test -only-testing:IrisTests/StoreKitEntitlementTests \
  -destination 'platform=iOS Simulator,id=9AEC6C9E-C23D-471F-B049-391A46B6B357'

✔ Test run with 17 tests in 1 suite passed after 6.329 seconds.
** TEST SUCCEEDED **
```

**17 tests sur 17, pour de vrai, zéro known issue.** La logique d'entitlement — achat vérifié, achat non vérifié
refusé, achat en attente, annulation, erreur, produit indisponible, droit retrouvé au relancement, restauration,
synchronisation en échec, révocation, code promotionnel, fin de l'accès promotionnel, achat permanent survivant à
la promo, achat fait hors de l'app — est démontrée, pas supposée.

C'est le seul écart réel avec le Gate 3, et il va dans le bon sens.

## Audit de couches

```
Tools/audit.py : C1 C2 C8 C9 TODO C10 C12 — tous verts, 349 fichiers
```

## Le bundle Release réellement produit

`Release-iphoneos/Iris.app` :

```
Iris  Info.plist  Assets.car  PrivacyInfo.xcprivacy  AppIcon60x60@2x.png
AppIcon76x76@2x~ipad.png  embedded.mobileprovision  PkgInfo  _CodeSignature
```

| Vérification | Résultat |
|---|---|
| `PrivacyInfo.xcprivacy` à la racine du bundle | **oui** — 1 572 octets |
| Dossier `Frameworks/` | absent — rien d'embarqué |
| Bibliothèques liées | **uniquement** des frameworks Apple et le runtime Swift ; aucune tierce partie |
| `CFBundleShortVersionString` | `1.0` |
| `CFBundleVersion` | `1` |
| `CFBundleIdentifier` | `net.steve-s.iris` |
| `MinimumOSVersion` | `17.0` |

### Instruments de développement dans le binaire Release

| Symbole | Occurrences |
|---|---|
| `LifecycleTrace` | 0 |
| `StoreDiagnostics` | 0 |
| `AncreCapture` | 0 |
| `drawDiagnostics` | 0 |
| `showsDeveloperGazeDiagnostics` | 0 |
| `OculomotorTrace` | **255** |

`OculomotorTrace` est le seul fichier de diagnostic qui n'est pas lui-même enveloppé dans `#if DEBUG` ; ses cinq
points d'appel le sont tous, il n'est donc **jamais instancié** en Release et sa ligne de log ne peut pas partir.
C'est la même situation « COMPILÉ mais NON ATTEIGNABLE » que le Gate 1 avait mesurée pour `VALID_INSIDE`.
Envelopper le fichier rendrait la garantie structurelle au lieu de dépendre des appelants — voir document 07,
ACTION 6.

## Signature : ce build n'est PAS un build de distribution

C'est le point le plus important de cette section.

```
Authority        = Apple Development: Stéphane SAULNIER (NKN63DTRM4)
TeamIdentifier   = G4U9RG5GL7
Profil           = "iOS Team Provisioning Profile: *"   (App ID générique)
get-task-allow   = true
```

Trois faits, chacun bloquant pour une archive App Store :

1. **`CODE_SIGN_IDENTITY = Apple Development`** est figé dans `project.yml` (réglages de base). Une archive de
   distribution exige `Apple Distribution`.
2. **`get-task-allow = true`** est une entitlement de développement. L'App Store refuse un binaire qui la porte.
3. **Le profil est un App ID générique `*`.** Un App ID générique **ne peut pas porter l'achat intégré**. L'App ID
   explicite `net.steve-s.iris` doit être enregistré avec le service In-App Purchase.

Ces trois corrections touchent la signature, interdite par le mandat de ce Gate. Elles sont consignées au
document 07 comme ACTIONS REQUISES, non exécutées.

**Le code est prêt. L'archive ne l'est pas.** Ce sont deux états différents.
