# 08 — Release Gate 1 : rapport

Base : `527b9ae` → branche `audit/iris-release-gate-1`.
Date : 16 septembre 2026. Xcode 26.3 (17C529), SDK iPhoneOS 26.2.

Appareils : iPhone 14 Pro (`iPhone15,2`, iOS 26.5.2 / 23F84) · iPhone 15 Pro (`iPhone16,1`, iOS 26.6.1 / 23G83).

---

## Les quatre questions

### 1. Des outils DEBUG peuvent-ils apparaître dans une build Release ?

**Réponse : non pour tout ce qui est un outil de développement. Oui pour une préférence utilisateur étiquetée.**

| | Verdict | Preuve |
|---|---|---|
| Prototypes hors campagne (« Braises A ») | **NON** | 0 symbole `BraisesPrototype` / `playPrototype` dans le binaire Release |
| Capture de trajectoire (`--iris-capture`) | **NON** | 0 symbole `AncreCapture` |
| HUD oculomoteur (`VALID_INSIDE`, `yaw`, `pitch`) | **NON** | 0 symbole `oculoStatus` |
| Arguments de lancement | **NON** | seul site d'appel de `LaunchOptions.parse` entre `#if DEBUG` ; et iOS ne permet pas de passer d'arguments depuis l'App Store |
| Substitution d'un droit commercial | **NON** | `#if DEBUG` + verrou `CommerceBoundaryTests` test L |
| Nouvelle instrumentation StoreKit de cette mission | **NON** | 0 symbole `StoreDiagnostics` dans le binaire Release construit après l'ajout |
| Points de regard + badges « regard : … » + lecture de calibration | **OUI**, derrière un interrupteur **éteint par défaut** | code non gardé — détail au document 01, §4 |

Racine de la preuve : **la configuration Release ne définit aucune condition de compilation**
(`SWIFT_ACTIVE_COMPILATION_CONDITIONS` vide, contre `DEBUG` en Debug). Tout `#if DEBUG` disparaît avant le typage.

Piège de méthode consigné : `strings` **ne prouve pas** l'absence d'une chaîne courte (Swift garde les littéraux de
≤ 15 octets en immédiat). Toutes les conclusions ci-dessus reposent sur `nm`, pas sur `strings`.

### 2. Pourquoi le prix apparaît sur le 15 Pro et pas sur le 14 Pro ?

**Mesuré sur le 14 Pro, lancé hors Xcode :** `Product.products(for:)` **réussit et rend zéro produit**, sans aucune
erreur, avec un storefront lu normalement (France / 143442). Ce n'est ni une panne, ni un refus : c'est la réponse
de l'App Store quand il ne connaît pas les identifiants.

**Mesuré, même code, avec une configuration StoreKit active :** 2 produits, avec le `displayPrice` du jeu complet.

**Établi dans le dépôt :** la configuration `Config/Iris.storekit` n'est attachée qu'à l'action **Run** du schéma.
Un lancement par `devicectl`, depuis l'écran d'accueil, par TestFlight ou par l'App Store n'utilise aucune action de
schéma.

**Donc :** la cause est **l'environnement d'exécution, pas l'appareil**. Ce qui reste **inféré et non prouvé**, faute
d'avoir pu mesurer le 15 Pro (verrouillé pendant toute la fenêtre), c'est que le 15 Pro affichait 2,99 € **parce
qu'il tournait depuis Xcode**. L'observation humaine — feuille de test StoreKit, message d'environnement de test —
va dans ce sens sans le démontrer.

Écartées **par mesure** : le matériel, le réseau, le bundle identifier, une différence de code entre les deux
appareils. Non écartée mais sans indice : la différence de version d'iOS.

### 3. Existe-t-il une différence matérielle démontrable ?

**Sources Apple :** la caméra TrueDepth et l'écran sont décrits **dans les mêmes termes** pour les deux appareils —
12 Mpx, ƒ/1.9, autofocus avec Focus Pixels, 2556×1179 à 460 ppi, ProMotion jusqu'à 120 Hz, mêmes luminances.
Les seules différences publiées : A16 Bionic → A17 Pro, GPU 5 → 6 cœurs. Neural Engine 16 cœurs des deux côtés,
**sans débit publié**.

**Apple ne publie aucun chiffre** de précision du regard, d'erreur angulaire, de latence, ni de précision des
transformations oculaires — pour aucun des deux appareils.

**ARKit à l'exécution, mesuré sur le 14 Pro :** face tracking supporté, 3 visages, 4 formats TrueDepth frontaux,
jusqu'à 1440×1080 à 60 fps. **Le 15 Pro n'a pas pu être mesuré** (verrouillé).

### 4. Que peut-on affirmer sur le suivi observé sur le 14 Pro ?

```
FINAL CLASSIFICATION: E — DONNÉES INSUFFISANTES
```

Aucune comparaison contrôlée n'a été exécutée : elle exige une personne devant l'écran. Le protocole est écrit,
prêt à jouer (document 05), fondé uniquement sur des grandeurs qu'Iris calcule déjà, avec sa règle de lecture fixée
d'avance.

**Il n'est donc pas possible d'écrire « le 14 Pro suit le regard moins bien ».** Rien ne l'appuie : ni source Apple,
ni mesure ARKit, ni mesure Iris.

---

## Le regard hors écran

```
OUT-OF-BOUNDS DIRECTION AVAILABLE: YES
OUT-OF-BOUNDS MAGNITUDE AVAILABLE: PARTIAL
CLAMP LOCATION: AR/Calibration/GazeMapper.swift → screenPoint(normalized:), lignes 47–53
FUTURE EDGE HALO FEASIBLE WITHOUT CHANGING GAZE ENGINE: YES
```

Le seul écrêtage du pipeline borne au viewport **élargi de 50 % de chaque côté** — pas au viewport. Les points hors
écran existent donc réellement et traversent tout l'aval intacts. Le modèle (`GazeDiagnostics.Edge`) et le rendu
(`drawEdgeIndicator`) existent déjà ; ils sont seulement alimentés en DEBUG. Détail au document 06.

## Flash

```
NEW EVIDENCE FOUND: NO
NEW JETSAM/CRASH REPORT: NO
FLASH INCIDENT CAUSE: NOT DETERMINED
```

Aucun rapport d'incident iPhone n'est arrivé sur ce Mac ; le `sysdiagnose` de l'appareil a échoué. La preuve
précédente est intacte et relue : le 16 septembre à 04:54, c'est **`backboardd`** qui a été tué — Iris n'avait pas
planté non plus. Chercher donc, dans Réglages → Confidentialité → Analyse et améliorations → Données d'analyse, un
`JetsamEvent-…` postérieur à 04:54:47, et non un plantage d'Iris. Rien n'a été modifié au rendu.

## Systèmes gelés

`git diff` contre `527b9ae` est **vide** pour : `GameEngine`, `AR/Calibration`, `AR/Services`, `Audio`, `Haptics`,
`Domain/Campaign`, `Domain/Entities`, `Domain/Physics`, `Domain/Validation`, `Domain/Access`, `Features/Game`,
`Features/GazeSetup`, `DesignSystem`, `Navigation`, `Resources`.

Le chapitre III niveau 7 n'a pas été ouvert. Aucun mode d'aide, aucun viseur, aucun halo n'a été implémenté.

## Demande future consignée (§20 du mandat, non implémentée)

Chapitre III, niveau 7 : lorsque la comète est effectivement suivie comme demandé, un **retour lumineux** devrait
confirmer visuellement la poursuite. La solution devra être **purement visuelle** et ne changer ni trajectoire, ni
vitesse, ni physique, ni validation, ni mapping du regard.

## Ce qui bloque encore

1. **iPhone 15 Pro verrouillé** — deux mesures attendent le déverrouillage (StoreKit et ARKit). Commandes exactes
   aux documents 02 §5 et 04 §1.
2. **État réel des produits dans App Store Connect** — aucun accès n'a été utilisé.
3. **Comparaison du regard non exécutée** — protocole prêt, exige une personne.
4. **Nouveau rapport Jetsam éventuel** — à récupérer sur l'appareil.
