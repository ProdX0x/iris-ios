# 01 — Architecture de l'aide au regard

## 1. Le principe

Le repère de regard cesse d'être un interrupteur de diagnostic et devient une **fonction produit**. Le moteur
fournit la donnée ; la présentation décide de ce qu'on en montre. Le moteur n'a jamais entendu parler de
« Classique », « Guidé » ou « Visible ».

## 2. Les types, et où ils vivent

| Type | Couche | Rôle |
|---|---|---|
| `GazeAssistanceMode` | `Domain/GazeAssistance` | les trois états produit : `classic`, `guided`, `visible`, avec leur nom et leur phrase en français |
| `GazeMarkerPresentation` | `Domain/GazeAssistance` | la décision : une opacité 0…1, et si le halo de bord est permis |
| `GazeEdgeGuidance` | `Domain/GazeAssistance` | la direction de sortie (8, coins compris) et son intensité mesurée |
| `GazeAssistancePolicy` | `Domain/GazeAssistance` | **LA** décision, et toutes les constantes |
| `GameSettingsStore.gazeAssistance` | Presentation | la persistance, et la migration de l'ancien réglage |
| `GazeAssistanceSection` | `Features/Settings` | le choix, accessible |
| `GazeIntroductionView` | `Features/GazeLearning` | les trois écrans d'introduction |

## 3. La règle est posée à un seul endroit

```swift
GazeAssistancePolicy.presentation(mode:levelID:hasCompletedLearning:activePlayTime:) -> GazeMarkerPresentation
```

Aucune vue n'écrit `if chapter == 1 && level == 3`. `GameViewModel` expose `gazeMarker`, qui appelle cette fonction
et rien d'autre. `GameSceneSnapshot` reçoit le résultat et le renderer l'applique.

Le moteur (`GameSession`, `TargetPhysics`, `GazeFilter`, `GazeMapper`) **n'a pas été touché**.

## 4. Les trois modes

| Mode | Repère | Halo de bord |
|---|---|---|
| **Classique** | jamais pendant le jeu | oui |
| **Guidé** | apparaît brièvement, sur un cycle fixe | oui |
| **Visible** | présent tant que le suivi donne une position | oui |

**Par défaut, pour un nouveau joueur : `classic`** (`GazeAssistanceMode.default`).

### Les constantes du mode Guidé

Regroupées dans `GazeAssistancePolicy`, modifiables en un seul endroit après un test humain :

| Constante | Valeur | Ce qu'elle fait |
|---|---|---|
| `guidedPeriod` | 6 s | une apparition par cycle |
| `guidedHold` | 1,2 s | durée pleine |
| `guidedFade` | 0,5 s | montée et descente |

Soit, par cycle de six secondes : 0,5 s d'apparition, 1,2 s de présence, 0,5 s de disparition, 3,8 s d'absence.
Le choix vise l'aide au recalage sans clignotement : une respiration lente, pas un stroboscope.

**Déterministe par construction** : `guidedOpacity(at:)` est une fonction pure du temps de jeu actif. Même instant,
même valeur, toujours — ce qu'un test vérifie sur sept cycles consécutifs.

## 5. Le temps utilisé

`activePlayTime` est **`GameSession.elapsed`**, qui n'avance que dans `tick()`, lui-même appelé seulement pendant
la phase `.playing`. C'est donc du **temps de jeu actif, pause exclue**, déjà existant et déjà déterministe :
aucune horloge n'a été ajoutée.

Conséquence voulue : en pause, le cycle du mode Guidé se fige au lieu de continuer à clignoter derrière le panneau.

## 6. Migration de l'ancien réglage

L'ancien booléen `iris.showsGazeIndicator` (« Points de regard (diagnostic) ») est migré **une seule fois** :

| Ancien | Nouveau |
|---|---|
| `true` | `visible` |
| `false` | `classic` |
| absent | `classic` (le défaut) |

La clé ancienne est ensuite **supprimée**, de sorte que les deux ne puissent jamais diverger. Un mode déjà
enregistré l'emporte toujours sur l'ancienne clé. Quatre tests couvrent ces cas.

**Il ne reste qu'une seule source de vérité produit.** La seule occurrence restante du nom `iris.showsGazeIndicator`
dans tout le projet est la constante de migration elle-même.

## 7. Ce qui reste développeur, et le reste vraiment

Les diagnostics techniques sont désormais **entièrement séparés** et **absents de Release** :

| Élément | Avant | Après |
|---|---|---|
| Points corail (brut) et menthe (calibré) | visibles en Release sous l'interrupteur « diagnostic » | `#if DEBUG`, sous `showsDeveloperGazeDiagnostics` |
| Badges « regard : … », « son : … » | visibles en Release | `#if DEBUG` |
| Ligne `oculo : VALID_INSIDE · yaw … pitch …` | déjà DEBUG | inchangée |
| Chevron de bord | déjà DEBUG | inchangé, remplacé pour le joueur par le halo |
| Phrase « Corail : brut. Menthe : calibré… » | visible en Release | déplacée dans le panneau DEBUG |

**Vérifié sur le binaire Release signé** : 0 symbole pour `drawDiagnostics`, `drawEdgeIndicator`,
`showsDeveloperGazeDiagnostics`, `oculoStatus` ; 0 occurrence des chaînes « Corail » et « (diagnostic) ».

`VALID_INSIDE` subsiste comme valeur brute d'énumération dans les métadonnées de réflexion d'`OculomotorTrace` —
type compilé mais **injoignable**, exactement comme le Gate 1 l'avait établi et mesuré : sa seule construction est
sous `#if DEBUG`, et `oculoStatus` est absent du binaire.

## 8. Le repère lui-même

Le rendu éprouvé est conservé : un anneau doux de 14 pt et un point de 2 pt, en ambre du chapitre
(`DSColor.Chapter.attention`). Il gagne seulement une opacité, celle que la politique demande.

Il dit « voici où Iris estime que vous regardez », pas « voici une précision parfaite » — d'où l'anneau souple
plutôt qu'une mire.
