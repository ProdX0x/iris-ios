# Iris

Jeu iOS natif d'attention indirecte : **regarder directement une sphère la repousse**. Le joueur doit répartir son attention sans la fixer pour laisser une, deux puis trois sphères rejoindre leur point d'arrivée, dans l'ordre, sur quatorze niveaux.

Ce README est le carnet technique autoritaire du projet. Les statuts utilisés sont :

- `[vérifié automatiquement]` : couvert par la suite de tests réellement exécutée ;
- `[vérifié par compilation]` : compilé (simulateur et appareil arm64) mais non exercé matériellement ;
- `[nécessite validation sur appareil TrueDepth]` : exige un test physique sur iPhone ou iPad Face ID.

---

## 1. Projet

| | |
|---|---|
| Objectif | Portage natif fidèle du moteur `attention-indirecte.html` avec suivi du regard ARKit, audio synthétisé et identité visuelle propre |
| Plateforme | iOS 17.0 et plus, iPhone et iPad, **portrait uniquement**, plein écran |
| Contrainte matérielle | Caméra TrueDepth / `ARFaceTrackingConfiguration.isSupported` (Face ID). Sans elle : écran « regard indisponible » |
| Technologies | Swift 6 (concurrence stricte complète), SwiftUI, Observation, ARKit, AVFoundation / AVAudioEngine, simd, QuartzCore (CADisplayLink) |
| Dépendances tierces | Aucune |
| Outils | Xcode 26.3 (17C529), SDK iOS 26.2, XcodeGen 2.45.4 pour générer `Iris.xcodeproj` depuis `project.yml` |
| Bundle | `com.prodx0x.iris`, équipe de développement pré-renseignée, signature automatique |

Arborescence (le projet Xcode est directement dans ce dossier, pas de conteneur `Iris/`) :

```
Iris.xcodeproj  project.yml  Config/Info.plist  README.md  attention-indirecte.html (intact)
App/          IrisApp, DI/AppContainer, Platform/ (CADisplayLink, liens système, options de lancement)
Domain/       entités, valeurs, constantes physiques, règles de validation, catalogue de niveaux (Foundation seul)
GameEngine/   bruit, intégrateur, session, progression, filtre de regard, horloge (Foundation seul)
AR/           GazeTrackingService (ARKit / simulé), projection du regard, capacités, permission caméra
Audio/        AudioService (AVAudioEngine / silencieux), synthétiseur sinus, politique sonore
Navigation/   AppRoute, AppCoordinator, RootView
Features/     Home, CameraAccess, Tutorial, Game (ViewModels, Views, Rendering), JourneyComplete, Unavailable
DesignSystem/ Tokens, Components, Modifiers
Resources/    Assets.xcassets (couleurs, icône)
Tests/IrisTests  suite Swift Testing + fixtures golden + mocks
Docs/         brief, conventions, produit, architecture, modèle de domaine, design system, file-map, audit
Tools/        MakeAppIcon.swift (icône), audit.py (audit de couches)
```

Regénérer le projet après ajout de fichiers : `xcodegen generate`.

---

## 2. Source de référence

`attention-indirecte.html` est la **source de vérité fonctionnelle**. Il n'a été ni modifié, ni déplacé, ni remplacé. Aucune WebView n'est utilisée : le moteur est réimplémenté en Swift (ADR-1).

### 2.1 Correspondance HTML / JavaScript → Swift

| HTML / JavaScript | Swift | Statut |
|---|---|---|
| `makeNoise1D(seed)` (LCG 9301 / 49297 / 233280, table 256, smoothstep) | `LinearCongruentialGenerator`, `ValueNoise1D` (GameEngine/Noise) | `[vérifié automatiquement]` valeurs bit à bit |
| `rngFor(2000 + n*97)`, `randomPoint(margin 0.2)`, `buildLevel(n)`, `GAZE_ZONE_MULTIPLIER = 1.6` | `LevelCatalog`, `LevelDifficulty`, `TargetBlueprint` (Domain/Levels) | `[vérifié automatiquement]` géométrie identique |
| bandes : n<3 → 1 cible, 220, 0.008, 0.6 ; n<8 → 2, 190, 0.009, 0.55 ; sinon 3, 150, 0.013, 0.5 | `LevelDifficulty.band(forLevelIndex:)` | `[vérifié automatiquement]` |
| `hold_time_frames = 45` | `LevelCatalog.holdDuration = 45/60 s`, `Target.requiredHoldTime` | `[vérifié automatiquement]` |
| `RADIUS_TARGET 24`, `RADIUS_ARRIVAL 40`, `VITESSE_MAX 2.2`, `FRICTION 0.94`, `MARGE_BORD 60`, `PERTE_REBOND 0.5` | `PhysicsConstants` | `[vérifié automatiquement]` |
| `SETTLE_RADIUS = 40 - 24`, `WOBBLE_TOLERANCE = SETTLE_RADIUS + 20` | `ValidationRules` (16 pt, 36 pt) | `[vérifié automatiquement]` |
| `step()` : répulsion `k*(zone-d)`, attraction, bruit, plafond, friction, intégration, rebonds | `TargetPhysics.integrate` | `[vérifié automatiquement]` traces golden |
| `isTargetsTurn`, `lowestUnsettledSeq` | `TurnRule` | `[vérifié automatiquement]` |
| bloc `settled / holdFrames` | `ValidationRule` | `[vérifié automatiquement]` |
| cascade (`brokenSeq`) | `CascadeRule` | `[vérifié automatiquement]` |
| `allSettled` → niveau suivant | `GameSession.isComplete`, `GameProgression` | `[vérifié automatiquement]` |
| `LEVELS` (14), `currentLevelIndex`, `gameState` | `GameProgression`, `AppRoute` + `GamePhase` | `[vérifié automatiquement]` |
| listener WebGazer : `alpha = 0.1`, saut > 300 px ignoré sauf 3 consécutifs | `GazeFilter` (appliqué après calibration, en points) | `[vérifié automatiquement]` |
| `cursor` initialisé au centre | `GameSession.gaze` initialisé au centre, puis amorcé sur le dernier regard calibré au premier tap | `[vérifié automatiquement]` |
| `FACE_LOST_TIMEOUT = 300 ms` (défini, non utilisé par le HTML) | phase `faceLost` du jeu après 0,3 s sans visage, reprise automatique (évolution v2) | `[vérifié automatiquement]` |
| calibration WebGazer (6 points, 5 clics chacun) | Gaze Engine v2 : diagnostic, 9 points sans clic, vérification 5 points, profil persistant (§4 bis) | `[vérifié automatiquement]` (logique), `[nécessite validation sur iPhone TrueDepth]` (précision réelle) |
| `ensureCrescendoOsc / updateCrescendo / stopCrescendo` (220 + p·340 Hz, gain 0.02 + p·0.025, τ 0.05, arrêt τ 0.08) | `SineSynth` voix de progression, `AudioCue.progress/stopProgress` | `[vérifié automatiquement]` (rendu hors ligne) |
| `playChime([660, 880, 1100], 0.12, 0.05)` | `SineSynth.triggerChime` | `[vérifié automatiquement]` |
| `playFail()` (220 → 120 Hz, 0.25 s, gain 0.05 → 0) | `SineSynth.triggerLoss` | `[vérifié automatiquement]` |
| `draw()` : horizon 38 %, dégradés ciel/sol, lignes de fuite, échelle `0.55 + 0.65·profondeur`, anneau aplati (0.4), arc de progression, ombre aplatie (0.35), dégradé radial, halo de vitesse, anneaux et numéros de séquence | `GameSceneRenderer` (Canvas SwiftUI) | `[vérifié par compilation]` + captures simulateur |
| `drawOverlay`, `drawRules`, `drawCameraPrompt` | `DSOverlayPanel`, `TutorialView`, `CameraAccessView` | `[vérifié par compilation]` |
| `SEQ_COLORS`, `#16171a`, `#5DCAA5`, `#D85A30`, `#EEEDFE`, `#B4B2A9`, `#D3D1C7` | tokens `ds.sequence.n`, `ds.background.surface`, `ds.status.success`, `ds.status.danger`, `ds.text.*` | `[vérifié par compilation]` |
| `FACE_LOST_TIMEOUT`, `faceCurrentlyLost()` (défini mais jamais utilisé par la physique) | état `GazeTrackingState.tracking(faceVisible:)` affiché dans le HUD, sans effet sur la physique | conforme au comportement effectif |
| `driftNoise`, `arrivalBaseX/Y` (définis, jamais utilisés) | non portés | conforme au comportement effectif |

### 2.2 Différences volontaires

1. **Fin de niveau** : le HTML enchaîne immédiatement le niveau suivant avec un flash « niveau terminé » de 90 frames. Iris arrête la boucle et affiche un overlay de fin de niveau (bouton Continuer), puis un écran de fin de parcours après le niveau 14 (ADR-6).
2. **Amorçage du curseur** : le HTML démarre le curseur au centre faute de données. Iris reçoit des échantillons avant le premier tap et place le curseur exactement sur le dernier regard connu au démarrage d'un niveau (évite une répulsion parasite depuis le centre). Le lissage 0.1 s'applique ensuite à l'identique.
3. **Cascade sonore** : le HTML joue un `playFail` par sphère invalidée. Iris joue un seul son de perte par tick, espacé d'au moins 150 ms (ADR-7).
4. **Pause** : Échap devient un bouton de pause dans le HUD ; la mise en arrière-plan suspend automatiquement.
5. **Gain audio** : les gains Web Audio sont conservés dans leurs rapports, multipliés par 2 pour le haut-parleur iPhone (`SineSynth.Configuration.masterGain`).
6. **Indépendance au framerate** : voir §5.

---

## 3. Architecture

Couches et dépendances autorisées (détail dans `Docs/architecture.md`) :

```
App (composition root, adaptateurs plateforme)
  └─ Presentation : Navigation, Features, DesignSystem
       ├─ GameEngine ─ Domain   (Foundation seulement, testables sans ARKit / caméra / SwiftUI / AVAudioEngine)
       ├─ AR (protocole GazeTrackingService, implémentations ARKit et simulée)
       └─ Audio (protocole AudioService, implémentations AVAudioEngine et silencieuse)
```

- **Injection** : `AppContainer` unique, construit par `IrisApp`, fabrique les services (`AudioService`, `GameClock`), possède le `GazeTrackingService` **partagé** (une seule `ARSession` par processus, utilisée tour à tour par le setup du regard et par le jeu, avec un drapeau de propriété des callbacks), le `CalibrationStore` et l'`InterfaceOrientationProvider`, et fabrique les ViewModels par injection de constructeur. Environnements `live`, `simulator` (regard piloté au doigt, faute de TrueDepth), `preview` (services simulés, horloge manuelle). Aucun singleton global.
- **Navigation** : `AppCoordinator` (`@Observable`, `@MainActor`) possède un `AppRoute` unique (`home`, `cameraAccess`, `gazeSetup(intent)`, `tutorial`, `game`, `journeyComplete`, `unavailable`). Le jeu ne démarre qu'après un regard validé dans le processus courant ; premier lancement : accueil → caméra → diagnostic → calibration → vérification → regard prêt → tutoriel → jeu ; lancements suivants : accueil → diagnostic → vérification → jeu. Les vues émettent des intentions ; `RootView` rend la route. Dans le jeu, `GameViewModel.phase` est un unique enum `GamePhase` (`initializing`, `ready`, `playing`, `paused`, `levelComplete`, `interrupted`, `resuming`, `suspended`, `failed`). Aucun booléen contradictoire.
- **ViewModels** : `GameViewModel`, `GazeSetupViewModel` et `CameraAccessViewModel` (`@MainActor @Observable`). Les écrans statiques (accueil, tutoriel, fin de parcours, indisponibilité) appellent directement le coordinateur (ADR-4).
- **Concurrence** : tout l'état UI est sur le MainActor ; le délégué `ARSession` est livré sur la file principale et bascule via `MainActor.assumeIsolated` ; le bloc de rendu audio est `@Sendable`, sans allocation ni verrou bloquant (`withLockIfAvailable`, structures de taille fixe) ; l'horloge `CADisplayLink` utilise un proxy faible (pas de cycle). Aucune `Task` non structurée dans les ViewModels (les vues possèdent les tâches asynchrones).
- **Skills utilisés** (pack `ios-app-skills` et `swiftui-expert-skill`) : product-conception (`Docs/product.md`, `Docs/Features/*.md`), architecture-designer (`Docs/architecture.md`, 9 ADR), domain-modeler et business-logic-engine (`Docs/domain-model.md`, règles R-01 à R-15), ui-ux-designer et swiftui-component-library (`Docs/design-system.md`, `DesignSystem/`), viewmodel-generator / view-generator / coordinator-navigator / dependency-injector (Features, Navigation, App/DI), test-generator (Tests), file-structure-organizer (`Docs/file-map.md`), layer-auditor (`Tools/audit.py`, `Docs/audit-2026-09-11.md`), code-deduplicator (`Docs/dedup-log.md`). Les couches Data et use cases du pack n'ont pas été créées : l'app n'a ni persistance ni réseau (ADR-2).

---

## 4. Regard (Gaze Engine v2)

Le suivi du regard a été entièrement refondu le 11 septembre 2026 après deux défauts constatés sur iPhone (aucune calibration ; suivi meilleur téléphone retourné). Le détail factuel est dans `GAZE_ENGINE_V2_REPORT.md`.

### 4.1 Diagnostic de l'ancienne chaîne (v1)

- `frame.camera.viewMatrix(for: .portrait)` codé en dur.
- Signes X et Y imposés par raisonnement (`screenX = cx - x/mpp`, `screenY = cy - y/mpp`), jamais mesurés : un iPhone retourné inversait les deux axes, d'où le symptôme.
- Échelle physique par table de PPI (460 / 326 / 264) et caméra supposée à `(largeur/2, 12 pt)`.
- Réglage « Miroir horizontal » comme rustine.
- Aucune vérification du signal ni correction du biais individuel.

### 4.2 Pipeline retenu

```
ARKit (frame, ARFaceAnchor)
 → orientation réelle de l'interface (UIWindowScene) → viewMatrix(for: orientation)
 → yeux (leftEyeTransform, rightEyeTransform) et lookAtPoint dans le repère caméra orienté
 → GazeRay : intersection rayon (milieu des yeux → lookAtPoint) / plan de l'appareil, en mètres, sans hypothèse de côté
 → RawGazeSample : impact plan, yeux, ligne des yeux, haut gravitationnel, clignements (jamais persisté)
 → AxisMapping : axes écran (droite, haut) résolus par vote parmi ±x/±y du repère caméra (ligne des yeux + gravité)
 → NominalDisplayGeometry : normalisation mètres → 0…1 (repère nominal, première approximation)
 → AffineTransform2D (profil de calibration, 6 coefficients) → coordonnées écran normalisées
 → points du viewport (bornés à ±50 %)
 → GazeFilter (alpha 0,1, rejet des sauts) → curseur du moteur de jeu
```

- **Orientation** : `WindowSceneOrientationProvider` lit `UIWindowScene.interfaceOrientation` de la scène active (repli portrait si inconnue). L'app reste verrouillée en portrait, mais aucune transformation ne présume l'orientation.
- **Axes** : la droite de l'écran est, par définition, la droite de l'utilisateur qui regarde l'écran : direction œil gauche → œil droit projetée dans le plan ; le haut est l'opposé de la gravité (`+y` monde exprimé dans le repère caméra), avec repli sur le produit vectoriel droite × (yeux → caméra) si l'appareil est à plat. `AxisResolver` choisit l'axe dominant et son signe ; `AxisVote` fait la majorité sur la fenêtre de diagnostic (confiance ≥ 0,8). Un téléphone retourné, un repère miroir ou pivoté donnent chacun un mapping correct. La main du repère (`isRightHanded`) est journalisée pour diagnostiquer les conventions ARKit réelles.
- **Approximations supprimées du chemin principal** : la table de PPI et la position de caméra ne servent plus qu'à définir le repère nominal contre lequel l'affine est apprise ; toute erreur d'échelle ou d'offset est absorbée par la calibration.
- **Normalisation** : toute la calibration travaille en coordonnées `x, y ∈ [0, 1]` ; la conversion en points n'a lieu qu'à la frontière jeu / présentation (`NormalizedCoordinates`).
- **Lissage** : inchangé (facteur 0,1 du HTML), appliqué après calibration et conversion en points, pendant `playing` seulement. Latence : à 60 Hz, 90 % de la réponse en ~22 frames (0,37 s), identique à l'original.

### 4.3 Diagnostic (`Gaze Readiness`)

Fenêtre glissante de 1,2 s, dix contrôles : caméra TrueDepth, accès caméra, session AR, visage détecté, suivi des yeux (distance 15–90 cm, écartement 4–10 cm), direction du regard (≥ 80 % des rayons atteignent l'écran), tête stable (RMS ≤ 2 cm), signal stable (RMS ≤ 10 % du nominal en fixant le point central), clignements détectables (blend shapes), axes résolus. Après 1 s de diagnostic entièrement vert, la calibration démarre d'elle-même.

### 4.4 Calibration

9 cibles (grille 3 × 3, marges 15 % / 14 %). Par cible : 300 ms de stabilisation, 800 ms de collecte (prolongée jusqu'à 2,5 s si les échantillons manquent, une reprise), échantillons rejetés pendant les clignements (`eyeBlinkLeft/Right` ≥ 0,5, garde 120 ms) et s'ils ne sont pas finis, agrégation robuste (médiane par axe, rejet > 3,5 MAD avec plancher 0,01, moyenne des acceptés, ≥ 12 échantillons). Ajustement affine par moindres carrés (équations normales 3 × 3, pivot partiel) ; refus si < 3 points, valeurs non finies ou géométrie dégénérée. Protocole piloté par les horodatages des frames, jamais par un nombre de frames.

### 4.5 Vérification et critère

5 cibles de contrôle (centre, gauche, droite, haut, bas) mesurées avec le regard calibré. Erreur = distance en points / petite dimension du viewport. **Accepté si moyenne ≤ 18 % et maximum ≤ 30 %** : tolérant vis-à-vis de la précision réelle d'ARKit (quelques centimètres), strict face à un axe inversé ou une échelle fausse (erreurs > 50 %). Sinon « La précision peut être améliorée » → Recalibrer, ou après un premier essai « Continuer quand même » (profil marqué non validé, recalibration complète au prochain lancement). Aucune boucle automatique.

### 4.6 Regard prêt, persistance, recalibration

- « Regard prêt » montre le point menthe (regard calibré) en direct, puis Continuer.
- Profil (`CalibrationProfile`, JSON dans `UserDefaults`) : version du modèle (1), 6 coefficients, mapping d'axes, orientation, viewport, repère nominal, date, erreurs de vérification, validité. Invalidé si version différente, viewport différent (> 1 %), orientation différente, non validé, > 30 jours. Lancements suivants : diagnostic + vérification 5 points ; échec → calibration complète.
- « Recalibrer le regard » dans le menu pause : le jeu est suspendu (niveau conservé), diagnostic → calibration → vérification, puis reprise avec le nouveau profil.
- Perte de visage pendant la partie : après 0,3 s, phase `faceLost` (boucle arrêtée) ; reprise automatique au retour du visage. Aucun point périmé n'est réutilisé.
- Mode diagnostic (menu pause, écrans de calibration) : corail = brut nominal, menthe = calibré non lissé, ambre = curseur lissé du jeu.

### 4.7 Statuts

- Géométrie du rayon, résolution des axes, modèle affine, agrégation, protocole, critères, persistance, machines d'états : `[vérifié automatiquement]` (63 tests dédiés).
- Intégration `ARSession`, `viewMatrix(for:)`, blend shapes, orientation de scène : `[vérifié par compilation]`.
- Direction réelle du regard, précision obtenue après calibration, confort du protocole : `[nécessite validation sur iPhone TrueDepth]`.

---

## 5. Game Engine

- **Unités** : points (1 pt = 1 px CSS du HTML). L'espace de jeu est la taille de l'écran en portrait (plein écran) ; les positions normalisées des niveaux sont résolues contre cette taille comme le HTML contre la fenêtre.
- **deltaTime (R-14)** : `GameSession.advance(by:)` borne le delta à 0,1 s (stall), puis le découpe en sous-pas d'au plus une frame de référence (1/60 s). À 60 Hz : un pas de fraction f = 1, **bit à bit identique** au HTML (prouvé par traces golden). À 30 Hz : deux frames de référence exactes. Pour un pas fractionnaire f (120 Hz), `TargetPhysics` applique la puissance fractionnaire exacte de l'application affine `v ← k·(v + a)` : friction `k^f`, impulsions × `k^(1-f)·(1-k^f)/(1-k)`, plafond `2.2·k^(1-f)` ; la vitesse de croisière après friction est alors identique à toutes les fréquences. L'horloge `CADisplayLink` demande 60 Hz (`preferredFrameRateRange`).
- **Attraction (R-01)** : hors zone d'attention, `v += dir(arrivée)·0.6 / 0.55 / 0.5` par frame selon la bande.
- **Répulsion (R-02)** : si `d < zone_attention`, `v += dir(sphère - regard)·k·(zone - d)`, k = 0.008 / 0.009 / 0.013, zone = 352 / 304 / 240 pt.
- **Bruit (R-03)** : bruit de valeur 1D interpolé smoothstep (port de `makeNoise1D`), amplitude 0,15, temps `t·0.02` (x) et `t·0.02 + 50` (y), appliqué uniquement pendant l'attraction, comme le HTML.
- **Plafond / friction (R-04, R-05)** : 2,2 pt/frame puis × 0,94.
- **Collisions (R-07)** : marge 60 pt, position bloquée, composante de vitesse inversée × 0,5.
- **Validation (R-08, R-10)** : présence continue < 16 pt du point d'arrivée pendant 0,75 s (45 frames) ; sortie → progression remise à zéro ; une fois validée, tolérance 36 pt (16 + 20) ; au-delà, perte immédiate.
- **Ordre (R-09)** : la présence ne compte que pour la plus petite séquence non validée (ou pour une sphère déjà validée). Une sphère hors tour peut atteindre et rester dans son cercle sans jamais valider.
- **Cascade (R-11)** : toute sphère validée de rang supérieur à la première non validée est invalidée dans le même tick, progression remise à zéro.
- **Événements** : `validationProgressed`, `validationProgressStopped`, `targetValidated`, `targetLost(cause: drift | cascade)`, `levelCompleted`.

---

## 6. Niveaux

| Niveaux | Cibles | zone_attention (× 1,6) | k_repulsion | attraction_passive | bruit | hold |
|---|---|---|---|---|---|---|
| 1 à 3 | 1 | 220 → **352 pt** | 0,008 | 0,6 | 0,15 | 0,75 s |
| 4 à 8 | 2 | 190 → **304 pt** | 0,009 | 0,55 | 0,15 | 0,75 s |
| 9 à 14 | 3 | 150 → **240 pt** | 0,013 | 0,5 | 0,15 | 0,75 s |

Positions de départ et d'arrivée générées avec les mêmes graines que le HTML (`2000 + n·97`), marge 0,2, ordre des tirages identique : les 14 niveaux sont géométriquement identiques à l'original (test `LevelCatalogTests.exactGeometry` contre des valeurs calculées indépendamment en Python et JavaScript). La difficulté est strictement croissante : zone décroissante, répulsion croissante, nombre de cibles croissant. Aucune courbe n'a été inventée.

Note de jouabilité : sur un iPhone de 393 × 852 pt, la zone de 352 pt des trois premiers niveaux couvre une grande partie de l'écran ; c'est le comportement validé du HTML (multiplicateur 1,6) conservé tel quel ; `LevelCatalog.gazeZoneMultiplier` reste le seul endroit à ajuster si un test sur appareil montrait que ARKit est plus précis que WebGazer.

---

## 7. Audio

- `AVAudioEngine` → `AVAudioSourceNode` mono (Float32, fréquence du matériel) → mixeur → sortie. Session `.ambient` + `mixWithOthers` (respecte le commutateur silence).
- `SineSynth` (thread audio) : 3 voix de crescendo (sinus, fréquence 220 + p·340 Hz, gain 0,02 + p·0,025, constante de temps 0,05 s ; relâchement 0,08 s), carillon 3 notes (660/880/1100 Hz, 0,12 s chacune, enveloppe 30 % montée / 70 % descente, gain 0,05), perte (220 → 120 Hz linéaire sur 0,25 s, gain 0,05 → 0). Commandes de taille fixe protégées par `OSAllocatedUnfairLock`, lecture non bloquante côté rendu, aucune allocation dans la boucle.
- **Politique sonore** (`AudioCuePolicy`, R-15) : crescendo par cible (voix = séquence − 1) tant que la présence progresse ; un carillon par validation ; **un seul son de perte par tick**, même en cascade (drift + cascades), et jamais deux sons de perte à moins de 150 ms. Pause, interruption, arrière-plan et sortie coupent toutes les voix de progression.
- Cycle de vie : interruption `AVAudioSession` (began → pause, ended + shouldResume → redémarrage), `AVAudioEngineConfigurationChange` et `mediaServicesWereReset` → reconstruction du graphe. Échec de démarrage → `AudioStatus.unavailable` affiché dans le HUD, le jeu continue sans son.
- Statuts : synthèse et politique `[vérifié automatiquement]` (rendu hors ligne à 44,1 kHz : hauteurs, enveloppes, silences) ; démarrage moteur exercé sur simulateur `[vérifié par compilation]` ; sortie réelle sur appareil `[nécessite validation sur appareil TrueDepth]`.

---

## 8. UI / UX

- **Identité** : fond noir chaud (#0F1013), lueur ambre montant de l'horizon, emblème « iris » (anneaux ambre, pupille sombre) décliné en icône d'app, titres en serif minuscules, corps en SF, menthe pour la validation, corail pour la perte, tons neutres chauds. Tokens et composants dans `DesignSystem/` (aucun littéral de couleur dans les écrans).
- **Écrans** : accueil (Commencer, Les règles) ; explication et demande de permission caméra (états explication, demande, refus avec Réglages, restriction) ; **setup du regard** (diagnostic avec liste de contrôles et point de fixation, cibles de calibration et de vérification avec anneau de progression, verdict « regard prêt » ou « la précision peut être améliorée », échecs) ; tutoriel ; jeu (canvas plein écran, HUD, overlays prêt / pause avec recalibration / fin de niveau / interruption / visage perdu / reprise / arrière-plan / erreur) ; fin de parcours ; appareil sans suivi facial.
- **Rendu** : `Canvas` SwiftUI, snapshot immuable par frame ; le HUD et les overlays observent des propriétés grossières et ne se réévaluent pas à chaque tick.
- **Accessibilité** : Dynamic Type sur tout le texte UI, boutons ≥ 44 pt, labels VoiceOver, overlays modaux, Reduce Motion respecté (pas de respiration ni de scale), contraste ≥ 4,5:1 pour le texte principal et secondaire.
- Captures simulateur réalisées pendant le développement (accueil, tutoriel, permission, indisponibilité, fin de parcours, jeu prêt, jeu en cours niveaux 1 et 9, validations niveau 9 et 14).

---

## 9. Confidentialité

- Caméra frontale utilisée uniquement via `ARFaceTrackingConfiguration` pour estimer `lookAtPoint` en temps réel. Message `NSCameraUsageDescription` (`Config/Info.plist`) en français, compréhensible.
- Aucune image, aucune vidéo, aucune géométrie ni représentation du visage n'est conservée : les `ARFrame` sont lus puis relâchés dans le callback ; l'échantillon brut (impact sur le plan, position des yeux, clignements) vit le temps d'une frame et n'est jamais persisté ; les échantillons de calibration sont agrégés puis oubliés.
- Aucun compte, serveur, cloud, analytics. Stockage limité, dans `UserDefaults`, à deux booléens de préférence (points de regard visibles, tutoriel vu) et au profil de calibration (6 coefficients, mapping d'axes, orientation, viewport, repère nominal, date, erreurs de vérification, validité) : aucune donnée de regard ni de visage.

---

## 10. Tests

Suite Swift Testing (`Tests/IrisTests`, 30 fichiers) exécutée sur simulateur iPhone 17 Pro (iOS 26.3.1) via `xcodebuild test`.

| Domaine | Fichiers | Ce qui est couvert |
|---|---|---|
| Physique | `TargetPhysicsTests` | attraction, répulsion, proportionnalité, frontière de zone, bruit uniquement hors zone, plafond 2,2, friction 0,94, équivalence temporelle (demi-pas), rebonds amortis, quatre bords, stabilité pour f ∈ {0,05 … 3}, facteurs de pas fractionnaire |
| Validation | `ValidationRuleTests` | entrée dans la zone, refus à 44 frames, validation à 45, validation temporelle à 30 et 120 Hz, sortie avant validation, rayon strict 16 pt, maintien à 35 pt, perte à 37 pt, progression des événements |
| Ordre | `SequenceOrderTests` | 1 immédiatement, 2 pas avant 1, 3 pas avant 1 et 2, arrivée physique hors tour, validation 1 → 2 → 3, `TurnRule` |
| Cascade | `CascadeRuleTests` | perte de 3 seule ; perte de 2 → 2 et 3 ; perte de 1 → 1, 2, 3 (règle et session, avec événements), retour à l'ordre, absence de cascade en niveau simple |
| Progression | `LevelCatalogTests`, `GameProgressionTests`, `LaunchOptionsTests` | 14 niveaux, comptes 1/2/3, bandes exactes, monotonie de la difficulté, hold 0,75 s, marges, géométrie exacte niveaux 1 et 9, enchaînement, redémarrage, bornage |
| Fidélité | `GameSessionGoldenTests` | deux traces frame par frame générées par le moteur JavaScript extrait (`Fixtures/golden_generator.js`) : niveau 1 (393 frames, répulsion, rebonds, attraction, validation) et niveau 9 (241 frames, validations 1, 2, 3 aux frames 151, 196, 241), tolérance 1e-6 |
| Session | `GameSessionTests`, `GazeFilterTests`, `ValueNoise1DTests`, `LinearCongruentialGeneratorTests` | chargement, complétion, bornage 0,1 s, 30 Hz = 2 × 60 Hz exact, 120 Hz, deltas nuls, lissage, sauts, bruit, LCG |
| Audio | `AudioCuePolicyTests`, `SineSynthTests` | cascade → un seul son, garde 150 ms, hauteurs 560 / 305 Hz, gains, extinction, carillon, balayage descendant |
| Regard v2 | `AxisMappingTests`, `AffineTransform2DTests`, `RobustAggregatorTests`, `FixationSequenceTests`, `NormalizedCoordinatesTests`, `CalibrationProfileTests`, `GazeMapperTests`, `GazeReadinessEvaluatorTests`, `GazeSetupViewModelTests` | repère standard, retourné 180°, miroir, pivoté 90°, gravité / repli, dégénérescences, votes ; identité, offsets, échelles, combinaison, miroir corrigé, bruit, refus (< 3 points, non fini, colinéaire) ; médiane / MAD ; stabilisation, collecte, clignements, reprise puis échec, prolongation ; conversions et grilles ; sauvegarde / chargement (mémoire et UserDefaults), compatibilité (version, validité, orientation, viewport, âge) ; rayon / plan des deux côtés, mapping appliqué avant le nominal, calibration appliquée une fois, bornage, détecteur de clignements ; readiness (prêt, en attente, bloqué, yeux, direction, stabilité, blend shapes) ; parcours complet avec biais appris, regard miroir corrigé, verdict insuffisant / continuer quand même, recalibration, revalidation, signal insuffisant, matériel / caméra, clignements ignorés, cycle de vie, propriété du tracker partagé |
| Présentation | `GameViewModelTests`, `AppCoordinatorTests`, `CameraAccessViewModelTests` | prêt, jeu, pause, curseur amorcé / lissé / figé, profil appliqué, visage perdu, recalibration, fin de niveau, fin de parcours, redémarrage, interruption, refus caméra, erreurs, arrière-plan / retour, sortie, autoplay, réglages ; routes (setup premier lancement / revalidation, complétion, annulation, recalibration aller-retour), permission |

### 10.1 Résultats réels de la dernière exécution (11 septembre 2026, Gaze Engine v2)

Commande :

```
xcodebuild -project Iris.xcodeproj -scheme Iris \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Debug test
```

Résultat : `Test run with 185 tests in 27 suites passed after 0.544 seconds` puis `** TEST SUCCEEDED **`.

| Exécutés | Réussis | Échoués | Ignorés |
|---|---|---|---|
| 185 | 185 | 0 | 0 |

**185/185 PASS** (121 tests de la phase 1 conservés, dont les 5 tests de projection v1 remplacés par les tests v2 ; 69 tests ajoutés pour le Gaze Engine v2 et la navigation associée). Aucun test désactivé. Les traces golden du moteur JavaScript restent vertes : le moteur de jeu n'a pas changé.

---

## 10 bis. Builds

Toutes les commandes ont été réellement exécutées depuis la racine du projet, sur macOS 26.3 (Darwin 25.3.0), Xcode 26.3 (17C529), SDK iOS 26.2, simulateur iPhone 17 Pro (iOS 26.3.1), le 11 septembre 2026 après l'intégration du Gaze Engine v2.

| # | Commande | Résultat réel |
|---|---|---|
| 1 | `xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Debug build` | `** BUILD SUCCEEDED **`, 0 erreur, 0 warning issu de notre code |
| 2 | `xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Debug test` | `** TEST SUCCEEDED **`, 185 tests, 185 réussis, 0 échec, 0 ignoré |
| 3 | `xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Release build` | `** BUILD SUCCEEDED **`, 0 erreur, 0 warning |
| 4 | `xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'generic/platform=iOS' -configuration Debug build CODE_SIGNING_ALLOWED=NO` | `** BUILD SUCCEEDED **` (arm64 appareil, non signé) |
| 5 | `xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'generic/platform=iOS' -configuration Release build CODE_SIGNING_ALLOWED=NO` | `** BUILD SUCCEEDED **` (arm64 appareil, non signé) |
| 6 | `python3 Tools/audit.py` | C1, C2, C8, C9, C10 et scan TODO : pass, 138 fichiers |

Diagnostics restants :

- `appintentsmetadataprocessor[...] warning: Metadata extraction skipped. No AppIntents.framework dependency found.` : notice de l'outillage Xcode émise pour toute app sans App Intents ; aucun défaut du projet, non masquée.
- Aucun warning du compilateur Swift (mode Swift 6, concurrence stricte complète, `ExistentialAny` activé) ni de l'éditeur de liens.

Appareils physiques : `xcrun xctrace list devices` montre un iPhone 14 Pro (« iPhone Steve. », iOS 26.5.2) appairé et accessible ; les builds appareil ci-dessus sont compilés sans signature pour ne pas dépendre d'un profil de provisioning dans cette session ; le projet contient l'équipe de développement et la signature automatique pour un Run direct depuis Xcode. **Aucune installation ni exécution n'a été faite sur cet iPhone : `[compilation appareil réussie]` n'équivaut pas à `[calibration TrueDepth validée humainement]`.**

Vérifications sur simulateur (iPhone 17, options DEBUG `--iris-route gazeSetup --iris-oracle-gaze`) : captures du diagnostic (dix contrôles verts), des cibles de calibration (progression), de la vérification et de l'écran « regard prêt » (point menthe vivant, erreurs 0 % avec le regard scripté). Une régression détectée par ce moyen (liste de diagnostic débordant sous l'îlot, libellé et bouton chevauchant des cibles) a été corrigée.

---

## 11. Validation

| Élément | Statut |
|---|---|
| Générateur, niveaux, bruit, physique, validation, ordre, cascade, progression, filtre de regard, politique audio, synthèse audio, rayon / plan, résolution des axes, modèle affine, agrégation robuste, protocole de fixation, critères de qualité, profil et persistance, readiness, machines d'états du jeu et du setup, coordinateur, permission | `[vérifié automatiquement]` |
| Intégration ARKit (`ARSession`, délégué, interruptions), `AVAudioEngine` sur appareil, `CADisplayLink`, rendu Canvas, écrans SwiftUI, Info.plist / permission caméra | `[vérifié par compilation]` (Debug et Release simulateur, Debug et Release device arm64) ; écrans et rendu également observés sur simulateur |
| Direction réelle du regard après résolution des axes et calibration, précision obtenue, confort du protocole (durées, tailles de cibles), latence perçue, jouabilité de la zone 352 pt, sortie audio réelle, comportement en appel entrant, arrière-plan réel | `[nécessite validation sur iPhone TrueDepth]` |

---

## 12. Limites honnêtes

- Aucun appareil TrueDepth n'a été utilisé pendant ces sessions : le suivi du regard n'a **pas** été testé physiquement par un humain. Les deux iPhone appairés visibles depuis cette machine (iPhone 14 Pro, iPhone 15 Pro) n'ont reçu aucune installation. Procédure de test humain : voir `GAZE_ENGINE_V2_REPORT.md`.
- Les conventions d'axes du repère caméra ARKit pour la caméra frontale ne sont pas documentées de façon exploitable ; le Gaze Engine v2 ne les présume plus (résolution par les yeux et la gravité), mais la première confirmation viendra du diagnostic sur appareil (ligne « Orientation du regard » et logs `gaze`).
- Le simulateur n'a pas de TrueDepth : la build simulateur remplace le regard par le doigt (glisser sur l'écran) ou, avec `--iris-oracle-gaze`, par un regard scripté qui fixe chaque cible ; le HUD l'indique (« mode : simulateur (toucher) »). Ces modes n'existent pas sur appareil.
- L'échelle physique de l'écran et la position de la caméra sont des estimations par famille d'appareil (erreur attendue de quelques pour cent). Les iPad dont la caméra est sur le bord long (iPad Pro M4, iPad 10) sont approximés avec une caméra en haut.
- La suite de tests s'exécute avec l'app comme hôte sur simulateur ; elle ne dépend d'aucun matériel.
- Les gains sonores absolus ont été validés hors ligne, pas à l'oreille sur appareil.
