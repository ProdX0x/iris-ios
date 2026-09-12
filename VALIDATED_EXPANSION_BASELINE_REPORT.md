# Iris — baseline validée d'expansion (phase C0)

Date : 12 septembre 2026. Branche : `baseline/iris-expansion-validated`. Bundle `net.steve-s.iris`, équipe `G4U9RG5GL7`, `project.yml` source de vérité, inchangés.

Cette branche ne contient que les acquis validés humainement, recomposés depuis les expérimentations Braises, puis recompilés, retestés et audités.

## 1. Ancêtre propre utilisé

`937d5497f2f82ebad42f3c2d3c883f99d7127113` (docs de la phase A de conception). Vérifié : il contient `229b8df` (haptique validé) et `52f20b7` (Iris v2, `main`), et aucun fichier Braises ; les quatre commits Braises (`416feb9`, `ea1cfae`, `aeafc28`, `c0709d0`) le suivent linéairement et n'ont pas été fusionnés.

## 2. Acquis importés

### Braises A

- Source : `416feb92d2ee27fb020917f4f85e0e1cb4b5b42b`, transplanté sans Braises B (commit `194dcd1e6dbcc0d51fccb8518ff2bbb9bf5eb71d`).
- Fichiers : `Domain/Campaign/BraiseDefinition.swift`, `Domain/Campaign/BraisesPrototype.swift` (niveau A seul), `GameEngine/Environment/BraiseState.swift` (avec `BehaviourScale`), et les points d'accroche minimaux dans `LueurDefinition`, `LevelDefinition`, `ChapterDefinition`, `LevelHint`, `GameEvent`, `LevelEnvironment`, `LevelResolver`, `TargetPhysics`, `GameSession`, `HintTracker`, `AudioCuePolicy`, `HapticCuePolicy`, `GameSceneSnapshot`, `GameSceneRenderer`, `LevelResult`, `GameViewModel`, `AppCoordinator`, `LaunchOptions`, `SettingsView` (un seul bouton DEBUG) ; tests `BraiseStateTests`, `BraisesPrototypeTests` (A seulement, dont `aIsFrozen` et `flareReach`), joueur simulé nourrissant dans `CampaignBot`.
- Parité : diff vide contre `416feb9` sur tous ces fichiers ; le bloc de définition d'A est identique caractère pour caractère.
- Statut humain : validé (sommeil, réveil, attraction, répulsion, affolement, portée accrue). Reste un prototype DEBUG hors campagne.

### Audio

- Source : `aeafc28cd0b38147c9d45db166724dc6d454629d`, transplanté sans les textes et tests Braises B du même commit (commit `4d78ce83ef93200386ae4acc78b79d4ce71c20c7`).
- Fichiers : `GameSettingsStore` (deux préférences et migration), `GameViewModel` (routage), `SettingsView` (deux interrupteurs), `Docs/Features/Audio.md`, `Design/UX_VISION.md`, `Design/ART_DIRECTION.md`, tests `GameSettingsStoreTests` et `GameViewModelTests`.
- Parité : diff vide contre `aeafc28` sur ces fichiers.
- Statut humain : validé (ambiance coupée, effets activés : plus de fond sourd, sons utiles conservés).

## 3. Éléments volontairement exclus

Braises B (niveau `0-2`, géométrie, textes, lanceur DEBUG, scénarios) ; les itérations B1.1, B1.2 et B1.3 ; l'instrumentation de laboratoire (relevé à l'écran, journaux `lab`, seuils et distances de debug) ; les tests spécifiques à B (géométrie, conflit tôt / tard, caractérisation) ; les rapports `BRAISES_PROTOTYPE_REPORT.md`, `BRAISES_B_REWORK_REPORT.md`, `BRAISES_B1_2_AUDIO_UX_REPORT.md`, `BRAISES_B_FINAL_DIAGNOSTIC_REPORT.md` et la fiche `Design/BRAISES_PROTOTYPE_TEST.md`, conservés dans les branches d'archive. Vérifié : aucune référence à `BraisesPrototype.b`, « deux feux », `0-2`, `experimentReadout` ou `labReadout` dans le code ; `BraisesPrototype.levels` ne contient que `0-1` (test `officialCampaignUntouched`).

## 4. Dernière preuve physique de rejet de B

Essai propre sur iPhone 14 Pro, calibration acceptée (`validation: mean 0.132 max 0.236 accepted true`), scénario tardif :

```text
t=4.00   targetValidated(sequence: 1)
t=7.96   braiseLit(sequence: 2)
t=8.27   braiseFlared(sequence: 2)
t=16.10  targetValidated(sequence: 2)
t=16.10  levelCompleted
losses 0
```

La lueur 1 déjà validée, la braise réveillée après elle et poussée jusqu'à l'affolement : aucune perte. Un réveil tardif, même avec affolement, ne produit pas de conséquence fiable sur la lueur 1. Les pertes des essais antérieurs survenaient avant le réveil, longtemps après, ou pendant des dérives indépendantes ; le cas isolé « affolement puis perte au même instant » n'établit plus de causalité. Motifs complets : `Design/BRAISES_VALIDATION_STATUS.md`.

## 5. Campagne

Six chapitres, 34 niveaux, identifiants `1-1` à `6-6`, ordre, progression et comportements inchangés (test `officialCampaignUntouched`, tests de structure et de simulation de la campagne). Braises A reste hors campagne ; aucun prototype ne touche la progression, les déblocages, les éclats ni la navigation officielle.

## 6. Moteurs protégés

Gaze Engine (`AR/`, `Features/GazeSetup/`), haptique (`Haptics/`), physique de référence (traces golden) : identiques à `937d549` hors les points d'accroche Braises A énumérés en § 2, eux-mêmes identiques à `416feb9`.

## 7. Audio

Deux réglages : « Effets sonores » (cues d'événements) et « Ambiance sonore » (nappe). Défauts pour une nouvelle installation : effets activés, ambiance coupée. Migration de l'ancien « Son » : coupé → tout coupé (rien n'est rallumé) ; activé → effets et ambiance activés ; absent → défauts. Validé humainement.

## 8. Hypothèse calibration-distance

`ENVIRON 30 CM SEMBLE SUBJECTIVEMENT PLUS FAVORABLE — NON VÉRIFIÉ.`

Voir `Design/GAZE_CALIBRATION_DISTANCE_HYPOTHESIS.md`. Aucune modification du Gaze Engine.

## 9. Vérifications de la recomposition

Voir `README.md` § 18 pour les résultats réels (builds, tests, audit, appareil) du HEAD final.

## 10. Nouveau point de départ

**LE HEAD FINAL DE CETTE BRANCHE EST LA BASELINE AUTORITATIVE POUR LES PROCHAINS PROTOTYPES D'EXPANSION.** Aucun merge, aucun push ; `main` et `feature/game-expansion` inchangés ; les branches `prototype/*` restent des archives.
