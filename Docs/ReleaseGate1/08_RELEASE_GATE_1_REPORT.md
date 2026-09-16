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
STOREKIT DIFFERENCE ROOT CAUSE: PROVEN
```

**La cause est un environnement de test StoreKit persistant sur le 15 Pro, absent du 14 Pro.**

Les deux appareils ont été mesurés avec **le même binaire** (`Iris.debug.dylib`, SHA-256
`64968a8e660b0cefdfc69e0338d24e04…`), installés et lancés par **les mêmes commandes `devicectl`**, tous deux **hors
Xcode** :

| | iPhone 14 Pro | iPhone 15 Pro |
|---|---|---|
| `appTransaction.environment` | **`(unavailable)`** | **`Xcode`**, vérifié |
| Produits rendus | **0** | **2** |
| `displayPrice` | **(none)** | **2,99 €** |
| Droit | `free` | `fullAccess` |
| Erreur | aucune | aucune |
| Storefront | FRA / 143442 | FRA / 143442 |

Tout le reste étant contrôlé et identique, la variable explicative est isolée — et elle suffit à expliquer l'écart
dans les deux sens.

**Ce que la mesure a corrigé.** L'hypothèse précédente — « le 15 Pro affiche le prix parce qu'il est lancé depuis
Xcode » — était **mécaniquement fausse**. Ce lancement-ci s'est fait par `devicectl`, sans Xcode, et les produits
sont apparus quand même : **l'environnement de test StoreKit persiste sur l'appareil**. C'est un état de
l'appareil, pas un état du lancement. Conséquence pratique : **il faudra purger cet état du 15 Pro avant toute
validation représentative d'un utilisateur réel.**

**NOT DETERMINED, et écrit comme tel :** que « l'App Store ne connaisse pas ces identifiants ». Le 14 Pro rend une
liste vide *sans erreur* — compatible avec cette explication et avec d'autres. Seule une source Apple faisant
autorité trancherait ; aucun accès à App Store Connect n'a été utilisé. La mesure du 15 Pro n'éclaire pas ce point,
puisque ses deux produits viennent de la configuration locale.

**ÉCARTÉ PAR MESURE :** le matériel, le réseau, le bundle identifier, une différence de code.

**Aucun défaut d'Iris n'est en cause :** le 14 Pro se comporte exactement comme spécifié et testé quand le magasin
ne fournit rien — prix inconnu, achat désactivé, message explicite, **chapitres gratuits ouverts**.

## 3. Différence matérielle démontrable ?

```
GAZE HARDWARE DIFFERENCE: NOT PROVEN
ARKIT RUNTIME DIFFERENCE: NOT PROVEN — aucune différence n'a été mesurée
```

**MEASURED, sources Apple :** caméra TrueDepth et écran décrits **dans les mêmes termes** pour les deux appareils.
Seules différences publiées : A16 Bionic → A17 Pro, GPU 5 → 6 cœurs ; Neural Engine 16 cœurs des deux côtés, sans
débit publié.

**NOT PUBLISHED BY APPLE :** précision du regard, erreur angulaire, latence, précision des transformations
oculaires — pour aucun des deux appareils.

**MEASURED, ARKit sur les deux appareils — identiques champ par champ :**

| | 14 Pro | 15 Pro |
|---|---|---|
| `isSupported` | true | true |
| visages suivis | 3 | 3 |
| formats | 4 | 4 |
| résolutions / cadences | 1440×1080 @ 60 et 30 ; 1280×720 @ 60 et 30 | **identiques** |
| capteur | TrueDepth frontal | **identique** |

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
| 1 | **État réel des produits dans App Store Connect** — aucun accès utilisé. Seule chose qui dise ce qu'un appareil sans environnement de test recevra en production. | humaine |
| 2 | **Achat en bac à sable sur un appareil sans environnement de test StoreKit**, une fois les produits créés. C'est la validation qui compte pour la publication. | humaine |
| 3 | **Comparaison du regard non exécutée** — protocole prêt (document 05), exige une personne devant l'écran. | humaine |
| 4 | **Heure de l'épisode de flash** — sans elle, aucune corrélation possible, même sur des données existantes. | humaine |

**Note d'hygiène, découverte par la mesure :** l'iPhone 15 Pro porte un environnement de test StoreKit persistant et
un droit `fullAccess` acquis par achat simulé. Tant qu'ils ne sont pas purgés, cet appareil **ne peut pas** servir à
valider l'expérience d'un utilisateur réel.
