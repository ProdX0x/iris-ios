# 06 — Plan de test du Gate 3

## 1. Ce qui a été ajouté

**36 tests**, en quatre suites, sous `Tests/IrisTests/GazeAssistance/`.

### `GazeAssistanceModeTests` — les trois modes (7 tests)

| Test | Ce qu'il démontre |
|---|---|
| nouveau joueur | `default == .classic`, et un magasin neuf le rend |
| CLASSIC | repère masqué à **121 instants** entre 0 et 30 s ; halo permis |
| VISIBLE | opacité 1 à **121 instants** ; halo permis |
| GUIDED | jamais permanent (un moment plein, un moment nul dans un cycle) ; les quatre points qui définissent le cycle ; **déterminisme vérifié sur 7 cycles** |
| persistance | le choix se relit après reconstruction du magasin |
| migration | `true → visible`, `false → classic`, clé ancienne supprimée, absence → défaut |
| priorité | un mode enregistré l'emporte toujours sur l'ancienne clé |
| vocabulaire | aucun nom ni résumé ne contient « diagnostic », « debug », « capteur », « pointeur », `VALID`, `YAW`, `PITCH` |

### `GazeLearningFlowTests` — l'apprentissage (9 tests)

| Test | Ce qu'il démontre |
|---|---|
| les trois niveaux | `1-1`, `1-2`, `1-3` existent et appartiennent au chapitre I |
| PREMIER I-1 | repère forcé visible **pour les trois modes**, sur 31 instants |
| PREMIER I-2 | idem |
| PREMIER I-3 | entier au départ, **décroissance monotone**, **partielle à mi-parcours** (ni 0 ni 1), nulle à la fin, et qui le reste |
| PREMIER I-4 | plus de surcharge : le mode s'applique |
| APRÈS l'apprentissage | rejouer I-1, I-2, I-3 obéit aux trois modes |
| fin de l'apprentissage | déduite de la progression : neuf, puis après 1-2, puis après 1-3 |
| introduction | montrée avant le premier 1-1, garde le niveau, le lance ensuite, ne revient pas |
| introduction à la demande | rouvrable sans lancer de niveau |
| texte | les trois titres, la référence 0 %, et aucun mot de jargon ni promesse de santé |

### `GazeEdgeGuidanceTests` — le halo (10 tests)

Intérieur (5 points, coins compris) · les 4 côtés · les 4 coins · intensité croissante · **saturation exacte au
clamp et au-delà** · intensité d'un coin · **aucune direction sans curseur placé** · le snapshot porte la direction ·
**le mode Classique garde le halo** · les 8 directions ont chacune leur ancrage · **aucune animation dans le halo**.

### `ChapterIIISevenFeedbackTests` — le retour lumineux (7 tests)

Le niveau est bien celui de l'étincelle · regard loin : aucun retour · regard dessus : retour actif · le regard
part : le retour disparaît · **le retour est exactement `isNear` du moteur, comparé à chaque frame sur 240 frames** ·
**dessiner ne change rien** (trajectoire, charge, pertes, achèvement identiques sur 600 frames) · le renderer
n'invente aucun seuil.

## 2. Non-régression

La suite historique a été exécutée à chaque étape.

```
541 tests · 78 suites · 0 échec · 5 ignorés · 17 known issues
```

Les 17 *known issues* sont ceux du Gate 1 : le runtime iOS 26.3 de cette machine refuse les sessions de test
StoreKit. Les 5 ignorés sont les captures d'écran, conditionnées à `IRIS_CAPTURE_DIR`.

**Aucun test n'a été transformé en skip, aucun échec n'a été masqué.**

## 3. Les tests existants qui ont dû changer, et pourquoi

| Fichier | Changement | Raison |
|---|---|---|
| 15 suites de campagne et de rendu | `showsGaze: false` → `marker: .hidden` | l'API du snapshot exprime maintenant une opacité, pas un booléen |
| `GameSettingsStoreTests` | `showsGazeIndicator` → `gazeAssistance` | le réglage produit a remplacé l'interrupteur |
| `GameViewModelTests` | `sut.showsGazeIndicator = true` → `sut.gazeAssistance = .visible` | idem |
| `DSGlassTests` K | quatrième feuille attendue, trois empreintes de navigation | l'introduction est une feuille de plus |
| `GameContentFreezeTests` G | deux empreintes | voir §4 |

## 4. Les deux fichiers regelés, et la justification inscrite dans la table

**`Features/Game/ViewModels/GameViewModel.swift`** — l'ancien interrupteur devient le mode du joueur, la visibilité
est demandée à `GazeAssistancePolicy`, l'overlay développeur passe sous `#if DEBUG`.

**`Features/GazeSetup/ViewModels/GazeSetupViewModel.swift`** — une liaison morte (`showsDiagnostics`, que personne ne
lisait) est supprimée, et les marques vivantes suivent le mode du joueur.

Les deux sont des changements de **présentation**. Aucune physique, aucune mathématique du regard, aucune
calibration, aucun audio, aucune haptique, aucun paramètre de niveau n'a été touché — le reste des 71 empreintes du
gel est intact.

## 5. Une régression introduite puis corrigée

En réécrivant le snapshot, la suppression des marques pendant les cercles à la tête seule du chapitre X a d'abord
été perdue : `AncreSceneTests` K l'a détectée immédiatement (« gaze marks » non nul). La condition `headOnly` a été
rétablie pour les diagnostics comme pour le repère. Le test est vert, et le gel du chapitre X est intact.

## 6. Contrôle de performance statique

| Vérification | Résultat |
|---|---|
| Écouteur de regard dupliqué | non — le halo et le repère lisent le snapshot déjà construit |
| Nouveau timer haute fréquence | non |
| Nouveau `CADisplayLink` | non — il n'en existe toujours qu'un, la boucle de jeu |
| Nouvelle session ARKit | non |
| Boucle d'animation permanente | non — trois `repeatForever` avant, trois après |
| Requête StoreKit liée à cette fonction | non |
| Reconstruction du snapshot hors jeu | **resserrée** : conditionnée à la présence réelle du repère |
