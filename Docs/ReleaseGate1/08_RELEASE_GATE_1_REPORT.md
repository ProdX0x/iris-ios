# 08 — Release Gate 1 : rapport

Base : `527b9ae` → branche `audit/iris-release-gate-1`.
Mesures des 16 septembre 2026. Xcode 26.3 (17C529), SDK iPhoneOS 26.2.

Appareils : iPhone 14 Pro (`iPhone15,2`, iOS 26.5.2 / 23F84) · iPhone 15 Pro (`iPhone16,1`, iOS 26.6.1 / 23G83).

Toute conclusion porte exactement une étiquette : **PROVEN**, **MEASURED**, **INFERRED**, **NOT DETERMINED**.

---

## 1. Des outils DEBUG peuvent-ils apparaître dans une build Release ?

| | Verdict | Étiquette | Fondement |
|---|---|---|---|
| Prototypes hors campagne (« Braises A ») | **NON** | PROVEN | 0 symbole `BraisesPrototype` / `playPrototype` dans le binaire Release |
| Capture de trajectoire (`--iris-capture`) | **NON** | PROVEN | 0 symbole `AncreCapture` |
| HUD oculomoteur (`VALID_INSIDE`, `yaw`, `pitch`) | **NON** | PROVEN | 0 symbole `oculoStatus` |
| Arguments de lancement | **NON** | PROVEN | seul site d'appel de `LaunchOptions.parse` sous `#if DEBUG` ; **et** iOS ne permet aucun argument depuis l'App Store |
| Substitution d'un droit commercial | **NON** | PROVEN | `#if DEBUG` + verrou `CommerceBoundaryTests` test L |
| Instrumentation StoreKit ajoutée ici | **NON** | PROVEN | 0 symbole `StoreDiagnostics` dans le binaire Release |
| Points de regard, badges « regard : … », lecture de calibration | **OUI**, derrière un interrupteur **éteint par défaut** | MEASURED | code non gardé ; détail document 01 §4 |

Racine : **la configuration Release ne définit aucune condition de compilation.** Piège de méthode consigné :
`strings` ne prouve pas l'absence d'un littéral court (Swift garde ≤ 15 octets en immédiat) ; tout repose sur `nm`.

**Aucune fuite de développement n'a été corrigée : aucune n'existe.** Ce qui reste visible est une préférence
produit délibérée, étiquetée, éteinte par défaut, dont le §19 du mandat prévoit la refonte au Gate 2.
Classification **G — décision humaine**.

## 2. Pourquoi le prix diffère entre les deux appareils ?

```
STOREKIT DIFFERENCE ROOT CAUSE: NOT PROVEN
```

**MEASURED — iPhone 14 Pro, hors Xcode, deux captures indépendantes :** `Product.products(for:)` **se termine avec
succès et rend zéro produit**, `error.domain=(none)`, storefront lu normalement (FRA / 143442),
`AppTransaction.shared` indisponible (`StoreKitError` code 2, description mesurée : **`unknown`**).

**MEASURED — même code, configuration StoreKit active :** 2 produits, `displayPrice` présent (17 tests verts).

**PROVEN — dans le dépôt :** `Config/Iris.storekit` n'est attachée qu'à l'action **Run** du schéma ; aucun lancement
hors Xcode n'utilise d'action de schéma.

**INFERRED, et cela le reste :** que le 15 Pro affichait 2,99 € parce qu'il tournait depuis Xcode. L'observation
humaine (feuille de test StoreKit, message d'environnement de test) le soutient sans le démontrer.

**NOT DETERMINED, et désormais écrit comme tel :**
- que « l'App Store ne connaît pas ces identifiants » — une liste vide sans erreur est compatible avec cette
  explication comme avec d'autres ; seule une source Apple faisant autorité trancherait, et aucun accès n'a été
  utilisé ;
- que l'environnement d'exécution des deux appareils soit identique ;
- le rôle éventuel de l'écart de version d'iOS.

**ÉCARTÉ PAR MESURE :** le matériel, le réseau, le bundle identifier, une différence de code (le **même binaire**,
`Iris.debug.dylib` SHA-256 `64968a8e660b0cefdfc69e0338d24e04…`, a été installé sur les deux appareils).

## 3. Différence matérielle démontrable ?

```
GAZE HARDWARE DIFFERENCE: NOT PROVEN
```

**MEASURED, sources Apple :** caméra TrueDepth et écran décrits **dans les mêmes termes** pour les deux appareils
(12 Mpx, ƒ/1.9, autofocus Focus Pixels ; 2556×1179 à 460 ppi, ProMotion 120 Hz, mêmes luminances). Seules
différences publiées : A16 Bionic → A17 Pro, GPU 5 → 6 cœurs ; Neural Engine 16 cœurs des deux côtés, **sans débit
publié**.

**NOT PUBLISHED BY APPLE :** précision du regard, erreur angulaire, latence, précision des transformations
oculaires — pour aucun des deux appareils.

**MEASURED, ARKit sur le 14 Pro :** face tracking supporté, 3 visages, 4 formats TrueDepth frontaux, jusqu'à
1440×1080 à 60 fps.

```
ARKIT RUNTIME DIFFERENCE: NOT PROVEN   (le 15 Pro n'a pas pu être mesuré)
```

## 4. Que peut-on affirmer sur le suivi observé sur le 14 Pro ?

```
FINAL CLASSIFICATION: E — DONNÉES INSUFFISANTES
```

Aucune comparaison contrôlée n'a été exécutée : elle exige une personne devant l'écran. Le protocole est prêt
(document 05). **Il n'est donc pas possible d'écrire « le 14 Pro suit le regard moins bien ».**

---

## Le regard hors écran

```
OUT-OF-BOUNDS DIRECTION AVAILABLE: YES            (PROVEN)
OUT-OF-BOUNDS MAGNITUDE AVAILABLE: PARTIAL        (PROVEN)
CLAMP LOCATION: AR/Calibration/GazeMapper.swift → screenPoint(normalized:), lignes 47–53
FUTURE EDGE HALO FEASIBLE WITHOUT CHANGING GAZE ENGINE: YES   (INFERRED, sur trois briques existantes)
```

Le seul écrêtage borne au viewport **élargi de 50 % de chaque côté**. Détail au document 06.

## Flash

```
NEW EVIDENCE FOUND: NO                 (MEASURED — recherche exhaustive)
NEW JETSAM/CRASH REPORT: NO            (MEASURED)
FLASH INCIDENT CAUSE: NOT DETERMINED
```

**MEASURED :** le magasin de rapports d'incident du 14 Pro a été copié **en entier** (149 fichiers,
`devicectl device copy from --domain-type systemCrashLogs`). Il contient **exactement un** fichier daté du
2026-09-16 : `JetsamEvent-2026-09-16-045447.ips`, celui déjà connu. **Aucun** Jetsam postérieur à 04:54:47, **aucun**
rapport nommant Iris, `backboardd` ou `SpringBoard`.

**Nuance :** un `JetsamEvent` n'existe que si le noyau tue un processus. Un flash n'ayant tué personne ne laisse
aucune trace. L'absence mesurée **écarte une hypothèse** ; elle n'en confirme aucune.

Rien n'a été modifié au rendu. Ce qui manque maintenant n'est plus un fichier : c'est **l'heure de l'épisode**.

## Systèmes gelés

`git diff` contre `527b9ae` est **vide** pour `GameEngine`, `AR/Calibration`, `AR/Services`, `Audio`, `Haptics`,
`Domain/*`, `Features/Game`, `Features/GazeSetup`, `DesignSystem`, `Navigation`, `Resources`.
Chapitre III-7 non ouvert. Aucun mode d'aide, aucun viseur, aucun halo implémenté.

## Ce qui bloque encore

| # | Blocage | Nature |
|---|---|---|
| 1 | **iPhone 15 Pro : écran verrouillé** (`passcodeRequired: true`, mesuré). Les deux mesures attendent un déverrouillage humain. | humaine |
| 2 | **État réel des produits dans App Store Connect** — aucun accès utilisé. | humaine |
| 3 | **Comparaison du regard non exécutée** — protocole prêt, exige une personne. | humaine |
| 4 | **Heure de l'épisode de flash** — sans elle, aucune corrélation possible. | humaine |
