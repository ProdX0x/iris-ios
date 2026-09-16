# 01 — Audit des résidus DEBUG / prototype / diagnostic en Release

Chaque ligne est étiquetée **FACT** (vérifiable par une commande donnée ici), **MEASUREMENT** (résultat d'une
exécution), **INFERENCE** (déduction argumentée) ou **UNKNOWN**.

Base : `527b9ae` (branche `audit/iris-release-gate-1`), Xcode 26.3 (17C529), SDK iPhoneOS 26.2.

---

## 1. La règle de compilation

**FACT.** Le projet ne définit `DEBUG` que dans la configuration Debug :

```
xcodebuild -project Iris.xcodeproj -target Iris -configuration Debug   -showBuildSettings | grep SWIFT_ACTIVE_COMPILATION_CONDITIONS
→ SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG

xcodebuild -project Iris.xcodeproj -target Iris -configuration Release -showBuildSettings | grep SWIFT_ACTIVE_COMPILATION_CONDITIONS
→ (aucune ligne : la variable est vide)
```

Release compile donc avec `SWIFT_OPTIMIZATION_LEVEL = -O` et `SWIFT_COMPILATION_MODE = wholemodule`, **sans**
`DEBUG`. Tout bloc `#if DEBUG` est retiré par le compilateur avant le typage : il n'existe pas dans le binaire.

C'est la preuve de premier niveau. La preuve de second niveau est l'inspection du binaire, ci-dessous.

## 2. Avertissement de méthode : `strings` ne prouve pas l'absence

**FACT.** Swift stocke les chaînes de 15 octets UTF-8 ou moins en *small string*, encodée en immédiat dans le flux
d'instructions, et non dans `__TEXT,__cstring`. `strings` ne les voit pas.

Mesuré sur le binaire Release : `"regard : visage perdu"` (21 octets) est trouvé, `"regard : suivi"` (14 octets)
ne l'est pas — alors que les deux sont dans le même `switch`, non gardé.

**Conséquence : l'absence d'une chaîne courte dans `strings` n'est pas une preuve.** Les conclusions ci-dessous
s'appuient sur la table des symboles (`nm`), qui n'a pas cette limite, et sur la règle de compilation du §1.

## 3. Inventaire classé

Classes demandées : A source DEBUG uniquement · B compilé mais inaccessible · C accessible utilisateur en Release ·
D code mort · E nécessaire aux tests · F nécessaire au développement · G décision humaine.

### 3.1 Prototypes hors campagne

| Élément | Emplacement | Classe | Preuve |
|---|---|---|---|
| Chapitre 0 « braises · prototype », niveau `BraisesPrototype.a` | `Domain/Campaign/BraisesPrototype.swift` — fichier entier entre `#if DEBUG` / `#endif` (lignes 7 à 41) | **A, F** | **MEASUREMENT** : `nm -a` sur le binaire Release → **0** symbole contenant `BraisesPrototype` |
| Panneau « prototypes (debug) » + bouton « Braises A · braise » | `Features/Settings/SettingsView.swift` lignes 60–68, entre `#if DEBUG` | **A, F** | **MEASUREMENT** : `strings` Release → 0 occurrence de `prototypes (debug)` et de `Braises A` (chaînes de 18 et 9 octets ; la première dépasse la limite small-string, donc son absence est probante) |
| `AppCoordinator.playPrototype(_:)` | `Navigation/AppCoordinator.swift` lignes 167–175 | **A, F** | **MEASUREMENT** : `nm -a` Release → **0** symbole `playPrototype` |
| Résolution d'un id de niveau prototype | `AppCoordinator.launchLevel`, `LaunchOptions.isKnownLevel` | **A** | même règle §1 |

**Conclusion : PROUVÉ — aucun prototype n'existe dans une build Release.**

### 3.2 HUD diagnostic oculomoteur (`VALID_INSIDE`, `yaw`, `pitch`)

| Élément | Emplacement | Classe | Preuve |
|---|---|---|---|
| Propriété `oculoStatus` (la ligne affichée) | `Features/Game/ViewModels/GameViewModel.swift` ligne 74, dans le bloc `#if DEBUG` lignes 70–77 | **A** | **MEASUREMENT** : `nm -a` Release → **0** symbole `oculoStatus` |
| Ajout de la ligne au HUD | `Features/Game/Views/GameHUDView.swift` lignes 99–101, entre `#if DEBUG` | **A** | §1 |
| Alimentation de la ligne | `GameViewModel.handleGazeSample` / `handleGazeState`, blocs `#if DEBUG` | **A** | §1 |
| Type `OculomotorTrace` et ses valeurs `VALID_INSIDE` / `VALID_OUTSIDE` / `INVALID` | `Features/Game/Diagnostics/OculomotorTrace.swift` — **le fichier n'est pas gardé** | **B** | **MEASUREMENT** : `nm -a` Release → 255 symboles `OculomotorTrace` ; `strings` Release → `VALID_INSIDE`, `VALID_OUTSIDE`, `INVALID` présents (valeurs brutes d'énumération, émises dans les métadonnées de réflexion) |

**INFERENCE argumentée :** le type est **compilé** mais **injoignable** : la seule propriété qui en construit une
instance (`oculoTrace`) est déclarée dans le bloc `#if DEBUG`, et son symbole est absent du binaire Release. Aucun
autre site de construction n'existe (`grep -rn "OculomotorTrace(" App Features Navigation` → une seule occurrence,
dans `GameViewModel.loadLevel`, entre `#if DEBUG`).

**Conclusion : PROUVÉ — `VALID_INSIDE`, `yaw`, `pitch` ne peuvent pas s'afficher dans une build Release.**

### 3.3 Capture de trajectoire (chapitre X)

| Élément | Emplacement | Classe | Preuve |
|---|---|---|---|
| `AncreCapture` (`--iris-capture`, écriture JSON Lines) | `Features/Game/Diagnostics/AncreCapture.swift` — fichier entier entre `#if DEBUG` (10 à 226) | **A, F** | **MEASUREMENT** : `nm -a` Release → **0** symbole `AncreCapture` |

### 3.4 Arguments de lancement

| Élément | Emplacement | Classe | Preuve |
|---|---|---|---|
| `LaunchOptions.parse(ProcessInfo.processInfo.arguments)` | `App/DI/AppContainer.swift` ligne 54, **dans** le bloc `#if DEBUG` lignes 53–57 ; la branche `#else` vaut `LaunchOptions.none` | **A, F** | **FACT** : un seul site d'appel dans l'app (`grep -rn "LaunchOptions.parse" App AR Audio Commerce DesignSystem Domain Features GameEngine Haptics Navigation`) |
| Type `LaunchOptions` lui-même | `App/Platform/LaunchOptions.swift` — non gardé | **B, D** | **MEASUREMENT** : `nm -a` Release → 128 symboles `LaunchOptions` |
| Substitution du magasin par un droit fixe (`--iris-entitlement`) | `AppContainer.live()` lignes 64–72, `#if DEBUG` / `#else` | **A** | déjà verrouillé par `CommerceBoundaryTests` test L |

**Deuxième raison, indépendante du code — FACT :** iOS n'offre aucun moyen de passer des arguments de lancement à
une application lancée depuis l'écran d'accueil, depuis TestFlight ou depuis l'App Store. Les arguments ne sont
transmis que par un lanceur de développement (Xcode, `devicectl`, `simctl`), qui exige un appareil en mode
développeur.

**Conclusion : PROUVÉ, deux fois — un utilisateur App Store ne peut pas activer ces options.**

### 3.5 Doublures de service compilées en Release

| Type | Fichier | Classe | Remarque |
|---|---|---|---|
| `StaticEntitlementService` | `Commerce/Services/StaticEntitlementService.swift` | **B, E** | **MEASUREMENT** : 186 symboles en Release. **FACT** : ses trois points d'octroi sont entre `#if DEBUG` ; hors DEBUG l'initialiseur force `.free`, `purchaseFullGame()` n'accorde rien et `simulate(_:)` est un no-op. Verrouillé par `CommerceBoundaryTests` test L. |
| `SimulatedGazeTrackingService` | `AR/Services/SimulatedGazeTrackingService.swift` | **B, E** | **FACT** : construit uniquement pour `environment == .simulator` ou `.preview` ; `AppContainer.live()` choisit `.live` sur appareil. |
| `StubCameraAuthorizationService`, `StaticDeviceCapabilities`, `InMemoryProgressStore`, `InMemoryCalibrationStore`, `SilentAudioService`, `SilentHapticFeedbackService` | divers | **B, E** | même raison : seuls `AppContainer.preview(...)` et les tests les construisent. |

**Classe D (code mort) :** `LaunchOptions` et `OculomotorTrace` sont compilés sans être joignables en Release.
Ils ne sont pas supprimés : ce sont des outils de développement réellement utilisés (captures, protocole de
comparaison), et le mandat interdit de détruire des outils utiles. Leur coût est quelques dizaines de kilooctets.

### 3.6 Assertions et pièges

**MEASUREMENT.** `grep -rn "assertionFailure\|preconditionFailure\|precondition(\|fatalError"` sur les dix
répertoires de production → **aucune occurrence**. `Tools/audit.py` (contrôle C9) échoue si l'une réapparaît.

---

## 4. Ce qui EST visible par un utilisateur App Store

Un seul ensemble, et il n'est pas un outil de développement : c'est une **préférence utilisateur explicite**.

| Élément | Emplacement | Classe |
|---|---|---|
| Interrupteur « Points de regard (diagnostic) » | `Features/Settings/SettingsView.swift` ligne 22 **et** `Features/Game/Views/GameOverlayView.swift` ligne 72 (panneau de pause) — **non gardés** | **C, G** |
| Badges d'état « regard : … » et « son : … » | `Features/Game/Views/GameHUDView.swift`, `GameHUDHost.diagnosticLabels` lignes 77–103 — **non gardé** ; affichés si `showsGazeIndicator` | **C, G** |
| Points de regard dessinés (corail = brut, menthe = calibré) | `Features/Game/Rendering/GameSceneRenderer.swift` `drawDiagnostics` lignes 575–586 | **C, G** |
| Phrase « Corail : brut. Menthe : calibré. Ambre : curseur lissé utilisé par le jeu. » | `GameOverlayView.swift` lignes 75–77 | **C, G** |
| Lecture technique de calibration « Calibration validée, erreur moyenne N % de la largeur. » | `Features/Game/ViewModels/GazeCalibrationStatus.swift` lignes 13–24, affichée dans le panneau de pause | **C, G** |

**FACT — l'interrupteur est éteint par défaut :** `GameSettingsStore.init` fait
`showsGazeIndicator = defaults.bool(forKey: Key.showsGazeIndicator)`, et `UserDefaults.bool(forKey:)` vaut `false`
pour une clé absente. Un joueur qui n'y touche pas ne voit **rien** de tout cela.

**FACT — le chevron de bord n'apparaît pas :** `GazeDiagnostics.edge` n'est renseigné que dans un bloc `#if DEBUG`
(`GameViewModel.handleGazeSample`), donc `drawEdgeIndicator` ne s'exécute jamais en Release.

### Décision

**Aucune modification n'est faite dans cette mission**, pour trois raisons :

1. ce n'est pas un outil de développement qui fuit : c'est une fonction produit délibérée, étiquetée, documentée
   dans l'interface, et éteinte par défaut ;
2. le §19 de la mission prévoit de reconcevoir cette zone (modes Classique / Guidé / Visible) et **interdit
   explicitement de l'implémenter maintenant** ;
3. supprimer le rendu des points de regard détruirait la brique dont le futur viseur a besoin.

**Classification : G — décision humaine, à prendre au Release Gate 2**, avec la recommandation ci-dessous.

**Recommandation (non appliquée) :** au Gate 2, séparer deux choses aujourd'hui confondues — (a) un *viseur produit*
(le point ambre lissé, sans texte), et (b) un *HUD technique développeur* (badges « regard : … », lecture de
calibration, points corail/menthe), ce dernier passant derrière `#if DEBUG`. Le §19 demande déjà exactement cela.

---

## 5. Réponses aux questions du rapport

| Question | Réponse | Fondement |
|---|---|---|
| Prototypes DEBUG visibles en Release | **NON** | 0 symbole `BraisesPrototype` / `playPrototype` en Release |
| Diagnostics de regard visibles en Release | **OUI**, derrière un interrupteur utilisateur éteint par défaut | code non gardé, mesuré |
| HUD technique de calibration visible en Release | **OUI** (panneau de pause) | `GazeCalibrationStatus` non gardé |
| `VALID_INSIDE` / `yaw` / `pitch` visibles en Release | **NON** | 0 symbole `oculoStatus` en Release |
| Outils développeur correctement isolés | **OUI** pour prototypes, captures, arguments de lancement, substitution de droit | §1 + `nm` |
| Code de développement mort ou inutile | **OUI**, deux types (`LaunchOptions`, `OculomotorTrace`), conservés volontairement | §3.5 |
