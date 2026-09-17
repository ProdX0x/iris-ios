# Iris — reprise de session, 17 septembre 2026 (après Gate 4A)

Ce document est autosuffisant. Une session Claude qui le lit doit pouvoir reprendre le projet sans rien savoir
d'autre. Il ne contient que des faits vérifiés dans Git, dans le code ou mesurés sur appareil.

---

## 1. Ce qu'est Iris

Un **jeu iOS d'attention indirecte contrôlé par le regard**. Le regard du joueur *repousse* les sphères : pour
guider une lueur jusqu'à son iris, il faut poser les yeux **à côté** et déplacer son attention autour d'elle.
Suivi du regard par la caméra TrueDepth (ARKit face tracking), SwiftUI, Liquid Glass natif iOS 26.

Douze chapitres, 82 niveaux. Téléchargement gratuit, **chapitres I à III gratuits pour toujours**, le reste par
**un achat unique** (2,99 € prévu).

**Iris est un jeu.** Aucune promesse de santé, de rééducation, de thérapie ou de bénéfice cognitif ne doit jamais
apparaître — ni dans l'app, ni dans les métadonnées App Store. Des tests automatiques le vérifient
(`CommerceBoundaryTests` test H relit chaque `.md` de `Docs/AppStore/` et chaque littéral du code produit contre
22 sous-chaînes interdites).

## 2. Où en est la release

| Gate | État |
|---|---|
| **Gate 1** — audit release, StoreKit, capacités appareils | terminé |
| **Gate 2** — stabilité, flash, performance, mémoire/Jetsam | terminé |
| **Gate 3** — assistance au regard, apprentissage, feedback | **CLOSED — validé humainement** |
| **Gate 4** — release candidate et préparation App Store | **PARTIAL** |
| **Gate 4A** — restaurer un appareil de validation StoreKit réelle | **PASS** |

```
READY FOR APP STORE SUBMISSION : NO
```

## 3. Git — l'état exact au moment du checkpoint

| | |
|---|---|
| Racine | `/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris` |
| Branche de travail | **`release/iris-appstore-rc1`** |
| HEAD avant ce handoff | `5e32497eea35863c0734a893f4aff8f87386bfab` |
| `main` | `52f20b7a4838e85f5be12c202bd4b98e9693f3a7` |
| `origin/main` | `52f20b7a4838e85f5be12c202bd4b98e9693f3a7` — identique |
| Remote | `origin` → `https://github.com/ProdX0x/iris-ios.git` |
| `main` est ancêtre de HEAD | oui |
| `main..HEAD` | **91 commits, 0 merge** — lignée strictement linéaire |
| Arbre de travail | propre |

**Rien n'a jamais été poussé.** Tout ce travail est local. `main` n'a pas bougé depuis `52f20b7`.

### Fichiers non suivis — à conserver, ne pas supprimer

```
JetsamEvent-2026-09-16-045447.ips     rapport Jetsam de l'incident historique
SKILL.md
x7_silhouette_reference.png           calque de tracé de la silhouette X-7
```

### Points de restauration (tags réellement présents dans le dépôt)

Tous sont des tags annotés, tous ancêtres de HEAD. Le sens indiqué est **le message du tag lui-même**.

| Tag | Commit | Date | Message du tag |
|---|---|---|---|
| `baseline-expansion-v1` | `d7e3a88` | 12 sept. 2026 | Iris validated expansion baseline — Braises A and audio validated |
| `iris-expansion-human-validated-v1` | `4bdb0ae` | 14 sept. 2026 | Iris 12-chapter expansion — human validated |
| `iris-ch1-oculomotor-human-validated-v1` | `c452c01` | 14 sept. 2026 | Iris Chapter I oculomotor level — human validated |
| `iris-liquid-glass-human-validated-v1` | `b3b067e` | 16 sept. 2026 | Iris Liquid Glass native production migration — human validated on iPhone 14 Pro |

Quatre tags au total, aucun autre. **Ne pas en créer, déplacer ni supprimer.**

### Branches hors de la lignée

`prototype/braises`, `prototype/braises-b-rework`, `prototype/braises-b-ux-audio`,
`prototype/braises-b-final-diagnostic`. C'est l'hypothèse « Braises B », testée puis **rejetée** et délibérément
absente. Rien à y récupérer.

## 4. Les appareils — et la règle à ne pas casser

### iPhone 14 Pro — **appareil de référence pour la validation StoreKit réelle**

| | |
|---|---|
| Nom | « iPhone Steve. » |
| UDID matériel | `00008120-0016341A2187C01E` |
| UUID CoreDevice | `CD9242BD-9650-52C9-BBA6-A30490C6DFA8` |
| Modèle / iOS | `iPhone15,2` / 26.5.2 |
| État | disponible |

**État StoreKit après le Gate 4A — propre :**

```
appTransaction.environment = (unavailable)
appTransaction.error       = StoreKit.StoreKitError/2
result.count               = 0
result.displayPrice        = (none)
entitlement                = free
storefront                 = FRA / 143442
```

Zéro produit et aucun prix sont le résultat **attendu** tant qu'App Store Connect n'est pas configuré : c'est ce
qu'un vrai client verrait aujourd'hui.

```
CLEAN FOR REAL STOREKIT VALIDATION : YES
PRODUCTION VERIFIED : NO
```

> **⚠️ RÈGLE CRITIQUE.** Le scheme Iris référence de nouveau `Config/Iris.storekit`. **Un « Run » d'Iris depuis
> Xcode sur le 14 Pro réactiverait immédiatement l'environnement StoreKit Xcode** et détruirait la valeur de cet
> appareil comme témoin.
>
> Pour installer sur le 14 Pro : **`devicectl` uniquement** — la méthode du Gate 1 —
> ou mettre StoreKit Configuration à `None` avant tout lancement depuis Xcode vers lui.

Ne pas désinstaller Iris de cet appareil, ne pas effacer ses données, ne pas supprimer sa calibration, ne pas
toucher à son compte Apple/Sandbox, sans autorisation explicite.

### iPhone 15 Pro — appareil de développement

| | |
|---|---|
| Nom | « The Grey » |
| UUID CoreDevice | `21ABC186-DEFC-59C7-9671-85E4FA69DA9A` |
| Modèle / iOS | `iPhone16,1` / 26.6.1 |
| État | **indisponible physiquement aujourd'hui avant 21:00 locale** |

Ne pas tenter de le joindre, ne pas l'attendre, ne bloquer aucune mission à cause de son absence.
À son retour : c'est lui l'appareil de développement Xcode, avec configuration StoreKit locale et
expérimentations. **Il ne doit jamais être confondu avec le 14 Pro de référence.** Il n'a été ni touché ni modifié
pendant les Gate 4 et 4A.

## 5. Gate 4A — ce qui a été établi, et avec quelle rigueur

Le 14 Pro avait perdu son état propre entre le Gate 1 et le 16 septembre 19:06 UTC : il s'était mis à retourner
deux produits à 2,99 € avec `appTransaction.environment=Xcode`.

Deux tests ont été faits, identiques sauf sur un point :

| | Xcode pendant l'édition du scheme | Résultat sur le 14 Pro |
|---|---|---|
| Test 1 | **ouvert** | `environment=Xcode`, 2 produits, 2,99 € |
| Test 2 | **fermé avant l'édition, rouvert après** | `environment=(unavailable)`, 0 produit, aucun prix |

Une troisième lecture, le 17 septembre à 14:02:23Z, faite par l'app lancée **sans Xcode du tout**, confirme
`(unavailable)`.

### Formulation à conserver telle quelle

```
EFFECT OF XCODE SCHEME              : STRONGLY SUPPORTED
CAUSE HISTORIQUE DE L'ACTIVATION    : NOT PROVEN
```

Le comportement observé est expliqué par la configuration StoreKit du scheme, et **l'hypothèse d'un état
persistant propre à l'appareil n'est plus nécessaire** pour rendre compte des résultats expérimentaux.

Ne pas durcir cela en « l'environnement était dans le scheme et pas dans l'appareil » : le mécanisme interne n'a
jamais été observé directement. Et *quand* et *par qui* le premier lancement configuré a atteint le 14 Pro reste
inconnu — Xcode avait purgé les enregistrements qui l'auraient dit.

### Ce qui n'a pas été nécessaire

Aucune désinstallation, aucun redémarrage, aucune suppression. Le profil de calibration et toutes les préférences
du 14 Pro sont intacts. Le scheme a été restauré au bit près (SHA-256 identique, `git diff` vide).

### Sauvegarde Gate 4A — hors du dépôt

`/Volumes/Steve Pro BlackSSD/Dev/App Mobile/.iris-gate4a-backup/`

| Fichier | SHA-256 |
|---|---|
| `net.steve-s.iris.plist` | `c8aa57c7e0dfdd31740b4d975289a3f0d18502fe3bcdeaa3a7dc2a81621dbdcc` |
| `iris-storekit.log` | `0760015878dc9cf00e0a19ee82f1a017dfccd683b904457da42d1244f39c66e4` |
| `iris-lifecycle.log` | `6bd37badfc1502e744b4380f7e973d388153a266f189b1f0245104a2c9a2c63a` |
| `Iris.xcscheme.ORIGINAL` | `56d1db6ce21194f31dcee60b15e91dbe51d027adbc769b2f4f9f75fa1e074756` |

Ne rien y remplacer, ni supprimer. Le plist contient la calibration du regard et les réglages ; **il ne contient
pas de progression de campagne** — il n'y en a pas sur cet appareil.

### Le scheme

```
Iris.xcodeproj/xcshareddata/xcschemes/Iris.xcscheme
SHA-256 : 56d1db6ce21194f31dcee60b15e91dbe51d027adbc769b2f4f9f75fa1e074756
référence ../../Config/Iris.storekit : présente (ligne 94)
```

Le fichier est **suivi par Git** (xcshareddata), donc `git diff` est une vérification valable en plus du hash.
Il est régénéré par `xcodegen generate` depuis `project.yml` : toute modification faite dans Xcode est écrasée.

## 6. Gate 3 — décisions UX définitives, validées humainement

À préserver telles quelles.

**Aide au regard** — trois modes, réglables dans les Réglages **et** depuis la pause, sur une seule valeur
partagée (`iris.gazeAssistance`, la seule clé) :

```
Classique — Sans repère
Guidé     — Repère ponctuel
Visible   — Repère permanent
```

Les Réglages gardent les explications longues ; la pause montre les étiquettes courtes. Un seul composant,
`GazeAssistancePicker`, deux variantes.

**Apprentissage du chapitre I**, première traversée :

```
I-1   repère permanent
I-2   repère permanent
I-3   repère initial puis fondu progressif
I-4+  le mode choisi par le joueur s'applique
```

Fin de l'apprentissage déduite de `progress.isCompleted("1-3")` — pas de drapeau en double. Pendant
l'apprentissage, le sélecteur de la pause est **désactivé**, sous la phrase :
« L'aide au regard est guidée pendant les premiers niveaux d'apprentissage. »

**Calibration** — le pourcentage est conservé, suivi de :
« Plus l'écart est faible, plus le suivi du regard est précis. »

**Accessibilité :** Dynamic Type validé humainement (PASS). **VoiceOver : NOT REQUIRED FOR GATE 3** — décision
délibérée, Iris se joue en regardant l'écran. Cela **n'autorise aucune promesse d'accessibilité aux personnes
aveugles**, et les éléments d'accessibilité en place ne doivent pas être dégradés.

## 7. Gate 4 — mesures et blocages

```
80 suites · 567 tests · 567 passés · 0 échec · 5 ignorés (captures visuelles)
17 known issues sur iOS 26.3 — le runtime refuse les sessions de test StoreKit
     → rejoués sur le simulateur iOS 18.6 « Iris-SK-18 » : 17/17 RÉELS, 0 known issue
Tools/audit.py : C1 C2 C8 C9 C10 C12 verts, 349 fichiers
Debug simulateur PASS · Release simulateur PASS · Release appareil signé PASS (techniquement)
```

### Pourquoi l'archive App Store est impossible aujourd'hui

```
Authority      = Apple Development: Stéphane SAULNIER (NKN63DTRM4)
TeamIdentifier = G4U9RG5GL7
Profil         = "iOS Team Provisioning Profile: *"   ← App ID GÉNÉRIQUE
get-task-allow = true                                 ← entitlement de développement
```

Restent à résoudre : signature **Apple Distribution**, **App ID explicite** compatible achat intégré, profil de
distribution, `get-task-allow=false`, et l'état réel d'App Store Connect. Ces changements touchent la signature et
le projet : ils exigent une mission dédiée et une autorisation.

## 8. StoreKit / monétisation — à conserver

```
Full unlock : net.steve-s.iris.unlock.fullgame   (non consommable)
Promo       : net.steve-s.iris.access.promopass  (auto-renouvelable, code d'offre Apple)
Entitlements: free · promotionalAccess · fullAccess
Priorité    : fullAccess > promotionalAccess > free
Chapitres gratuits : AccessPolicy.freeChapterCount = 3  (définition unique)
```

Le code utilise `Product.displayPrice` — **aucun prix n'est jamais codé en dur** sur un chemin visible —, refuse
toute transaction non vérifiée, ne persiste **aucun** droit localement (StoreKit est l'autorité, relue à chaque
fois), et n'a ni licence maison, ni minuterie promotionnelle, ni expiration calculée localement.

**App Store Connect : NOT DETERMINED.** Aucun accès n'a jamais été utilisé. Rien ne prouve que les produits y
existent.

### Défaut connu, ouvert — ne pas corriger sans mission dédiée

Hors ligne, `restorePurchases()` avale l'erreur de `AppStore.sync()` et annonce « Aucun achat à restaurer sur ce
compte Apple » alors que l'App Store était simplement injoignable. Un client payant, hors ligne, s'entend dire que
son compte ne contient rien. Le comportement est actuellement épinglé par un test, qu'il faudra changer aussi.

Trois autres points ouverts sont décrits dans `Docs/ReleaseGate4/03_STOREKIT_READINESS.md` : pas de
rafraîchissement des droits au retour au premier plan, `PaywallCopy.promotionalAccessEnded` sans appelant, et un
prix qui peut devenir périmé après un échec de rechargement.

## 9. Confidentialité — état établi par audit de code

Aucun réseau applicatif, aucun SDK tiers, aucun analytics, aucun rapporteur de crash, aucun identifiant
utilisateur, aucune image jamais conservée ni écrite. Seuls les coefficients de calibration et des métadonnées
d'écran sont persistés localement, dans `UserDefaults`. `PrivacyInfo.xcprivacy` est présent et vérifié **à la
racine du bundle Release construit**, avec `NSPrivacyCollectedDataTypes` vide.

Réponse cohérente pour App Store Connect : **« Nous ne collectons aucune donnée. »**

**La politique de confidentialité n'est pas hébergée.** Le texte est écrit dans
`Docs/AppStore/PRIVACY_RELEASE_NOTES.md` et se termine encore par « Contact : *(adresse à indiquer)* ». Ne pas
laisser entendre qu'une URL existe.

## 10. Métadonnées App Store

**Prêtes** (français) : nom, sous-titre, texte promotionnel, description FR, mots-clés, catégories, copyright,
nouveautés, notes de relecture, explication TrueDepth. Tout est dans `Docs/AppStore/`.

Formulation TrueDepth prévue pour la relecture :
« Iris utilise la caméra TrueDepth pour estimer la direction du regard nécessaire au contrôle du jeu. »

*(La chaîne réellement embarquée dans `Config/Info.plist` est plus complète et a été conservée : elle ajoute que
les images restent sur l'appareil et ne sont ni enregistrées ni envoyées.)*

**Manquants ou non déterminés** — ne rien inventer sur leur état : URL de support, URL de politique de
confidentialité, adresse de contact, description anglaise, conflit de description de l'achat intégré (deux
versions existent, l'une dépasse la limite de 45 caractères), questionnaires App Privacy et classification d'âge,
contrat Applications payantes, fiscalité, coordonnées bancaires, état réel des produits App Store Connect, App ID
explicite compatible achat intégré, décision iPhone seul ou universel.

## 11. Captures App Store

```
ÉTAT : PENDING — aucune capture n'existe, d'aucune taille
```

Plan écrit et complet dans `Docs/AppStore/SCREENSHOT_PLAN.md` : **8 captures 6,9 pouces obligatoires** (1290 ×
2796) plus la **capture de relecture de l'achat intégré**. L'icône marketing 1024 × 1024 est présente et correcte.

C'est le seul blocage majeur entièrement réalisable en local, sans Apple.

## 12. Systèmes gelés — ne pas modifier

**Le Gaze Engine v2 est gelé.** Ne pas toucher à : la calibration affine 2D, la calibration en 9 points, le rejet
de clignement, le diagnostic, la vérification en 5 points, la persistance et la revalidation, `TargetPhysics`, et
la logique fondamentale de répulsion des sphères.

La zone de répulsion étudiée au Gate 2 **n'a pas démontré de régression**. Ne pas la « corriger » sans preuve
nouvelle.

Également gelés : `LevelDefinitions`, structure de campagne et de chapitres, règles de progression, X-7, le halo
périphérique, le feedback III-7, les timings d'apprentissage du Gate 3, StoreKit produit, audio, haptique,
architecture Liquid Glass.

Des tables de gel par SHA-256 protègent ces fichiers (`GameContentFreezeTests`) : les toucher fait échouer les
tests, et re-geler un hash exige d'écrire pourquoi dans le fichier de test.

## 13. Incident flash / Jetsam — historique, non résolu

Un incident sérieux avait montré des sphères et des boutons illuminés, des changements visuels, un comportement
ressemblant à un redémarrage. Un rapport `backboardd` indiquait un *highwater kill* autour de 3072 Mo, lié
principalement à des surfaces graphiques partagées. Un autre flash bref a été observé ensuite, sans crash ni
impact.

```
CAUSE : NOT PROVEN
```

Liquid Glass V3 **n'a jamais été démontré** comme cause. Ne pas déclarer ce problème résolu. Ne pas ouvrir
d'investigation sans mission dédiée. Le rapport brut est le fichier non suivi `JetsamEvent-2026-09-16-045447.ips`
à la racine.

## 14. Hors v1 — pistes à ne pas démarrer

### Accessibilité aveugle — V2 / V3 seulement

Concept possible : **Iris — Navigation sonore / Audio Gaze Mode**. Audio spatial directionnel, hauteur ou timbre
pour l'axe vertical, pulsation selon la proximité, identité sonore des sphères et des cibles, convergence
harmonique, haptique de réussite, guidage vocal ponctuel, vocabulaire sonore d'entraînement, biofeedback regard →
son spatial.

**Ne pas intégrer à Iris v1.** La faisabilité dépend de capacités oculomotrices très variables selon les
personnes aveugles, et devra être testée avec de vrais utilisateurs avant toute promesse.

### Android / multiplateforme

Iris v1 reste **100 % Apple / Swift jusqu'à publication**. Aucune modification v1 pour Android.

Étude future séparée. Question prioritaire : la faisabilité réelle du Gaze Engine sur matériel Android (Samsung,
Pixel, autres). Architectures à comparer : (1) iOS Swift + Android Kotlin natif ; (2) cœur Swift partagé avec des
couches natives. Swift sur Android et Kotlin Multiplatform méritent une étude. **Ne pas décider Flutter ou React
Native** sans preuve qu'ils conviennent à la partie regard/matériel.

## 15. Comment construire et tester

```bash
# Le projet Xcode est GÉNÉRÉ. project.yml est la source de vérité.
xcodegen generate

# Tests (DerivedData hors du dépôt : le disque interne du Mac est presque plein)
xcodebuild test -project Iris.xcodeproj -scheme Iris \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -derivedDataPath "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/.iris-derived-data/sim"

# Tests StoreKit RÉELS — seulement sur un runtime iOS 18.x
xcodebuild test -only-testing:IrisTests/StoreKitEntitlementTests \
  -destination 'platform=iOS Simulator,id=9AEC6C9E-C23D-471F-B049-391A46B6B357'

# Audit de couches
python3 Tools/audit.py            # --write-file-map pour régénérer Docs/file-map.md
```

Un seul `xcodebuild` à la fois : le Mac a 17 Go de RAM et son swap est sur un disque presque plein.

## 16. Où lire la suite

| Sujet | Document |
|---|---|
| Différence StoreKit entre appareils, mesures du Gate 1 | `Docs/ReleaseGate1/02_STOREKIT_DEVICE_DIFFERENTIAL.md` |
| Flash, mémoire, Jetsam | `Docs/ReleaseGate2/01_FLASH_TIMELINE.md`, `05_MEMORY_BACKBOARDD.md`, `07_STABILITY_DECISION.md` |
| Décisions UX du Gate 3 | `Docs/ReleaseGate3/01` à `11` |
| Lignée, builds, StoreKit, privacy, métadonnées, captures | `Docs/ReleaseGate4/01` à `08` |
| Le nettoyage de l'appareil et les deux tests de scheme | `Docs/ReleaseGate4/09_STOREKIT_DEVICE_CLEANUP.md` |
| Fiche App Store, produits, captures, checklist | `Docs/AppStore/` |
| Carnet technique | `README.md` |

---

# NEXT SESSION — FIRST ACTION

**La première action après `/clear` n'est pas du développement.**

1. **Lire ce handoff en entier.**

2. Vérifier l'environnement :
   ```bash
   pwd
   git rev-parse --show-toplevel
   git branch --show-current
   git rev-parse HEAD
   git status
   git diff
   ```

3. Confirmer que branche et HEAD correspondent à ce document. En cas d'écart : **ne rien corriger**, le signaler.

4. Confirmer la **disponibilité physique** des appareils avant tout test matériel.

5. **Ne pas utiliser l'iPhone 15 Pro** avant qu'il soit physiquement disponible (pas avant 21:00 locale
   le 17 septembre 2026).

6. **Ne pas lancer Iris depuis Xcode sur l'iPhone 14 Pro** tant que le scheme référence `Config/Iris.storekit` :
   cela détruirait son état propre, durement récupéré.

7. **Attendre ensuite la mission explicite de l'utilisateur.** Aucune initiative de développement autonome.

## Action suivante recommandée, quand l'utilisateur la demandera

Produire la série de **huit captures d'écran 6,9 pouces** en suivant `Docs/AppStore/SCREENSHOT_PLAN.md` : c'est le
seul blocage majeur qui ne dépende ni d'Apple, ni d'un hébergement, ni d'une autorisation de modifier le projet.
