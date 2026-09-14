# Iris

Jeu iOS natif d'attention indirecte : **ce que vous regardez s'éloigne**. Le joueur guide des lueurs vers leurs iris en choisissant où poser les yeux et où ne pas les poser, sur une campagne de six chapitres et 34 niveaux conçus un par un : éviter, partager son attention, pousser contre un courant, contourner un voile, raviver une veilleuse, anticiper un iris mouvant.

Ce README est le carnet technique autoritaire du projet. Les statuts utilisés sont :

- `[vérifié automatiquement]` : couvert par la suite de tests réellement exécutée ;
- `[vérifié par compilation]` : compilé (simulateur et appareil arm64) mais non exercé matériellement ;
- `[nécessite validation sur appareil TrueDepth]` : exige un test physique sur iPhone ou iPad Face ID.

---

# Apple Signing — NE PAS MODIFIER SANS RAISON EXPLICITE

| | |
|---|---|
| App | `Iris` |
| Bundle ID principal | `net.steve-s.iris` |
| Bundle ID des tests | `net.steve-s.iris.tests` |
| Signing | `Automatic` (aucun certificat ni profil de provisioning imposé) |
| Development Team | `G4U9RG5GL7` — Stéphane SAULNIER, équipe individuelle de l'Apple Developer Program |
| Concepteur | Stéphane SAULNIER |
| Marque potentielle | ProdX0xSs (marque ou studio éventuel : ni Apple Account, ni Team ID, ni préfixe de Bundle ID) |

**Toute future génération ou modification du projet doit préserver ces valeurs.**

- La source de vérité est `project.yml` (XcodeGen). `Iris.xcodeproj` est régénéré par `xcodegen generate`, et tout réglage saisi dans Xcode (Signing & Capabilities, Build Settings) est écrasé à la régénération suivante : corriger `project.yml`, jamais le `.pbxproj` seul.
- `python3 Tools/audit.py` (contrôle C12) échoue si `project.yml`, le projet généré ou les sources s'écartent de ces valeurs, ou si un profil de provisioning est épinglé.
- `NKN63DTRM4` n'est **pas** une équipe : c'est l'identifiant personnel inscrit dans le nom des certificats « Apple Development » ; l'équipe (champ OU des certificats) est `G4U9RG5GL7`. Ne jamais le réintroduire.
- Aucun identifiant Apple personnel (e-mail, mot de passe, jeton, clé, secret App Store Connect) n'est versionné ; le compte reste géré par Xcode et le trousseau macOS.

Migration, cause du problème et vérifications : § 13.

---

## 0. Refonte du produit (11 septembre 2026)

Le prototype (moteur HTML porté, 14 niveaux générés par graine) a été traité comme la première démonstration d'une idée. Il reste autoritaire pour le **noyau mécanique** (répulsion par le regard, attraction, présence 0,75 s, ordre, cascade, physique), mais plus pour le périmètre du jeu.

Documents de référence du produit, dans `Design/` :

| Document | Contenu |
|---|---|
| `PRODUCT_AUDIT.md` | Audit mesuré du prototype : niveau 2 presque résolu d'avance, 0,4 % d'écran libre au niveau 5, difficulté non monotone, faille « regarder hors de l'écran », un seul usage du regard. |
| `GAME_VISION.md` | Vision, piliers, arc d'expérience, ce qu'Iris n'est pas. |
| `GAME_DESIGN.md` | Règles conservées, modifiées et nouvelles (R-23 à R-28), progression, éclats, apprentissage, retours, idées rejetées, revue critique, écarts d'implémentation. |
| `LEVEL_DESIGN_SYSTEM.md` | Paramètres, règles de combinaison, familles, métriques, vérification automatique, 13 critères de différence, justification des 34 niveaux, mesures réelles de chaque niveau. |
| `UX_VISION.md` | Parcours, fonction de chaque écran, consignes contextuelles, mouvement, accessibilité. |
| `ART_DIRECTION.md` | La « chambre noire » : palette, formes (diaphragme à six lames), typographie, mouvement, son. |

Ce qui change pour le joueur :

- **Six chapitres** : Éveil, Partage, Courants, Voiles, Veilleuses, Clairvoyance. Chaque chapitre introduit un seul élément, d'abord seul, puis le combine.
- **Le regard devient un outil** : les courants et les voiles exigent de pousser une lueur en regardant de l'autre côté ; les veilleuses exigent de regarder quelque chose sans troubler le reste.
- **Regard sur l'écran (R-23)** : hors de l'écran, les iris se ferment. La faille du prototype est supprimée.
- **Apprentissage joué** : plus d'écran de règles. Le niveau I-1 est le tutoriel, et des consignes apparaissent quand le joueur fait la chose.
- **Progression persistante** : carte des chapitres, déblocage niveau par niveau, trois éclats par niveau (atteint, fluide, serein), Carnet des éléments rencontrés, aide « voie » après 45 s.
- **Nouvelle identité** : vue de face sans perspective trompeuse, lueurs émissives, iris-diaphragmes, nappe sonore par chapitre, arpège de fin de niveau.

Chaque niveau est **prouvé par simulation** (`Tests/IrisTests/Campaign/`) : faisable par un joueur-robot bruité, et impossible sans l'élément qu'il enseigne.

---

## 1. Projet

| | |
|---|---|
| Objectif | Jeu complet construit sur le noyau mécanique porté fidèlement de `attention-indirecte.html` : campagne de 34 niveaux conçus, suivi du regard ARKit calibré, audio synthétisé, identité propre |
| Plateforme | iOS 17.0 et plus, iPhone et iPad, **portrait uniquement**, plein écran |
| Contrainte matérielle | Caméra TrueDepth / `ARFaceTrackingConfiguration.isSupported` (Face ID). Sans elle : écran « regard indisponible » |
| Technologies | Swift 6 (concurrence stricte complète), SwiftUI, Observation, ARKit, AVFoundation / AVAudioEngine, simd, QuartzCore (CADisplayLink) |
| Dépendances tierces | Aucune |
| Outils | Xcode 26.3 (17C529), SDK iOS 26.2, XcodeGen 2.45.4 pour générer `Iris.xcodeproj` depuis `project.yml` |
| Bundle | `net.steve-s.iris` (tests : `net.steve-s.iris.tests`), équipe `G4U9RG5GL7`, signature automatique — voir « Apple Signing » |
| Concepteur | Stéphane SAULNIER |
| Marque potentielle | ProdX0xSs (non utilisée dans la configuration Apple) |

Arborescence (le projet Xcode est directement dans ce dossier, pas de conteneur `Iris/`) :

```
Iris.xcodeproj  project.yml  Config/Info.plist  README.md  GAZE_ENGINE_V2_REPORT.md  attention-indirecte.html (intact)
Design/       audit du prototype, vision, game design, level design, UX, direction artistique (référence produit)
App/          IrisApp, DI/AppContainer, Persistence/ (progression), Platform/ (CADisplayLink, liens système, options de lancement)
Domain/       entités, constantes physiques, règles de validation, Campaign/ (34 niveaux), Progress/ (éclats, déblocages), catalogue prototype
GameEngine/   bruit, intégrateur, session, Environment/ (courants, voiles, veilleuses, iris mouvants), Campaign/ (résolution, consignes)
AR/           GazeTrackingService (ARKit / simulé), Calibration/ (Gaze Engine v2), capacités, permission caméra
Audio/        AudioService (AVAudioEngine / silencieux), synthétiseur sinus, politique sonore
Haptics/      HapticFeedbackService (UIKit / silencieux), politique haptique (une impulsion par événement logique)
Navigation/   AppRoute, AppSheet, HomeSummary, AppCoordinator, RootView
Features/     Home, CameraAccess, GazeSetup, Chapters, Carnet, Settings, Game (ViewModels, Views, Rendering), JourneyComplete, Unavailable
DesignSystem/ Tokens, Components (dont DSIrisMark, DSEclats, DSGlyph), Modifiers
Resources/    Assets.xcassets (palette chambre noire, icône)
Tests/IrisTests  suite Swift Testing, fixtures golden, robots de campagne, mocks
Docs/         brief, conventions, architecture (ADR-1 à 16), modèle de domaine (R-01 à R-30), design system, file-map, audit
Tools/        MakeAppIcon.swift (icône), audit.py (audit de couches)
```

Regénérer le projet après ajout de fichiers : `xcodegen generate`. `project.yml` est la seule source de vérité des réglages Xcode, signature comprise : un réglage modifié dans Xcode sans être reporté dans `project.yml` est perdu à la régénération.

---

## 2. Source de référence

`attention-indirecte.html` est la **source de vérité fonctionnelle**. Il n'a été ni modifié, ni déplacé, ni remplacé. Aucune WebView n'est utilisée : le moteur est réimplémenté en Swift (ADR-1).

### 2.1 Correspondance HTML / JavaScript → Swift

| HTML / JavaScript | Swift | Statut |
|---|---|---|
| `makeNoise1D(seed)` (LCG 9301 / 49297 / 233280, table 256, smoothstep) | `LinearCongruentialGenerator`, `ValueNoise1D` (GameEngine/Noise) | `[vérifié automatiquement]` valeurs bit à bit |
| `rngFor(2000 + n*97)`, `randomPoint(margin 0.2)`, `buildLevel(n)`, `GAZE_ZONE_MULTIPLIER = 1.6` | `PrototypeLevelCatalog`, `LevelDifficulty`, `TargetBlueprint` (Domain/Levels), conservés comme référence historique des traces golden | `[vérifié automatiquement]` géométrie identique |
| bandes : n<3 → 1 cible, 220, 0.008, 0.6 ; n<8 → 2, 190, 0.009, 0.55 ; sinon 3, 150, 0.013, 0.5 | `LevelDifficulty.band(forLevelIndex:)` | `[vérifié automatiquement]` |
| `hold_time_frames = 45` | `PrototypeLevelCatalog.holdDuration = 45/60 s`, `LevelDefinition.hold = 0,75 s`, `Target.requiredHoldTime` | `[vérifié automatiquement]` |
| `RADIUS_TARGET 24`, `RADIUS_ARRIVAL 40`, `VITESSE_MAX 2.2`, `FRICTION 0.94`, `MARGE_BORD 60`, `PERTE_REBOND 0.5` | `PhysicsConstants` | `[vérifié automatiquement]` |
| `SETTLE_RADIUS = 40 - 24`, `WOBBLE_TOLERANCE = SETTLE_RADIUS + 20` | `ValidationRules` (16 pt, 36 pt) | `[vérifié automatiquement]` |
| `step()` : répulsion `k*(zone-d)`, attraction, bruit, plafond, friction, intégration, rebonds | `TargetPhysics.integrate` | `[vérifié automatiquement]` traces golden |
| `isTargetsTurn`, `lowestUnsettledSeq` | `TurnRule` | `[vérifié automatiquement]` |
| bloc `settled / holdFrames` | `ValidationRule` | `[vérifié automatiquement]` |
| cascade (`brokenSeq`) | `CascadeRule` | `[vérifié automatiquement]` |
| `allSettled` → niveau suivant | `GameSession.isComplete`, `Campaign.next(after:)`, écran de résultat | `[vérifié automatiquement]` |
| `LEVELS` (14), `currentLevelIndex`, `gameState` | `PrototypeLevelCatalog` (référence) ; le jeu utilise `Campaign` (34 niveaux), `CampaignProgress`, `AppRoute` + `GamePhase` | `[vérifié automatiquement]` |
| listener WebGazer : `alpha = 0.1`, saut > 300 px ignoré sauf 3 consécutifs | `GazeFilter` (appliqué après calibration, en points) | `[vérifié automatiquement]` |
| `cursor` initialisé au centre | `GameSession.gaze` initialisé au centre, puis amorcé sur le dernier regard calibré au premier tap | `[vérifié automatiquement]` |
| `FACE_LOST_TIMEOUT = 300 ms` (défini, non utilisé par le HTML) | phase `faceLost` du jeu après 0,3 s sans visage, reprise automatique (évolution v2) | `[vérifié automatiquement]` |
| calibration WebGazer (6 points, 5 clics chacun) | Gaze Engine v2 : diagnostic, 9 points sans clic, vérification 5 points, profil persistant (§4 bis) | `[vérifié automatiquement]` (logique), `[nécessite validation sur iPhone TrueDepth]` (précision réelle) |
| `ensureCrescendoOsc / updateCrescendo / stopCrescendo` (220 + p·340 Hz, gain 0.02 + p·0.025, τ 0.05, arrêt τ 0.08) | `SineSynth` voix de progression, `AudioCue.progress/stopProgress` | `[vérifié automatiquement]` (rendu hors ligne) |
| `playChime([660, 880, 1100], 0.12, 0.05)` | `SineSynth.triggerChime` | `[vérifié automatiquement]` |
| `playFail()` (220 → 120 Hz, 0.25 s, gain 0.05 → 0) | `SineSynth.triggerLoss` | `[vérifié automatiquement]` |
| `draw()` : horizon, sol en perspective, échelle selon la profondeur, sphères en dégradé | remplacé par la chambre noire (`GameSceneRenderer`, ADR-16) : vue de face, lueurs émissives, iris-diaphragmes, filaments de courant, voiles, veilleuses, onde de trouble | `[vérifié par compilation]` + captures simulateur |
| `drawOverlay`, `drawRules`, `drawCameraPrompt` | `DSOverlayPanel`, `LevelIntroCard`, consignes contextuelles (`HintTracker`), `CameraAccessView` | `[vérifié automatiquement]` (consignes) et `[vérifié par compilation]` (vues) |
| `SEQ_COLORS` (5 couleurs), `#16171a`, `#5DCAA5`, `#D85A30` | rangs `ds.rank.1…3` toujours doublés de points, palette chambre noire (`Docs/design-system.md`) | `[vérifié par compilation]` |
| `FACE_LOST_TIMEOUT`, `faceCurrentlyLost()` (défini mais jamais utilisé par la physique) | état `GazeTrackingState.tracking(faceVisible:)` affiché dans le HUD, sans effet sur la physique | conforme au comportement effectif |
| `driftNoise`, `arrivalBaseX/Y` (définis, jamais utilisés) | non portés | conforme au comportement effectif |

### 2.2 Différences volontaires

1. **Fin de niveau** : le HTML enchaîne immédiatement le niveau suivant avec un flash « niveau terminé » de 90 frames. Iris arrête la boucle et affiche un overlay de fin de niveau (bouton Continuer), puis un écran de fin de parcours après le niveau 14 (ADR-6).
2. **Amorçage du curseur** : le HTML démarre le curseur au centre faute de données. Iris reçoit des échantillons avant le premier tap et place le curseur exactement sur le dernier regard connu au démarrage d'un niveau (évite une répulsion parasite depuis le centre). Le lissage 0.1 s'applique ensuite à l'identique.
3. **Cascade sonore** : le HTML joue un `playFail` par sphère invalidée. Iris joue un seul son de perte par tick, espacé d'au moins 150 ms (ADR-7).
4. **Pause** : Échap devient un bouton de pause dans le HUD ; la mise en arrière-plan suspend automatiquement.
5. **Gain audio** : les gains Web Audio sont conservés dans leurs rapports, multipliés par 2 pour le haut-parleur iPhone (`SineSynth.Configuration.masterGain`).
6. **Indépendance au framerate** : voir §5.
7. **Périmètre du jeu** : les 14 niveaux, l'écran de règles, la perspective et l'enchaînement immédiat sont remplacés par la campagne, l'apprentissage joué, la chambre noire et l'écran de résultat (§0).

---

## 3. Architecture

Couches et dépendances autorisées (détail dans `Docs/architecture.md`) :

```
App (composition root, adaptateurs plateforme)
  └─ Presentation : Navigation, Features, DesignSystem
       ├─ GameEngine ─ Domain   (Foundation seulement, testables sans ARKit / caméra / SwiftUI / AVAudioEngine)
       ├─ AR (protocole GazeTrackingService, implémentations ARKit et simulée)
       ├─ Audio (protocole AudioService, implémentations AVAudioEngine et silencieuse)
       └─ Haptics (protocole HapticFeedbackService, implémentations UIKit et silencieuse)
```

- **Injection** : `AppContainer` unique, construit par `IrisApp`, fabrique les services (`AudioService`, `GameClock`), possède le `GazeTrackingService` **partagé** (une seule `ARSession` par processus, utilisée tour à tour par le setup du regard et par le jeu, avec un drapeau de propriété des callbacks), le `CalibrationStore` et l'`InterfaceOrientationProvider`, et fabrique les ViewModels par injection de constructeur. Environnements `live`, `simulator` (regard piloté au doigt, faute de TrueDepth), `preview` (services simulés, horloge manuelle). Aucun singleton global.
- **Navigation** : `AppCoordinator` (`@Observable`, `@MainActor`) possède un `AppRoute` unique (`home`, `cameraAccess`, `gazeSetup(intent)`, `chapters`, `carnet`, `game`, `journeyComplete`, `unavailable`), une feuille `AppSheet` (réglages) et la `CampaignProgress`. Un niveau ne démarre qu'après un regard validé dans le processus courant ; premier lancement : seuil → caméra → diagnostic → calibration → vérification → regard prêt → niveau I-1 (tutoriel joué) ; lancements suivants : seuil → diagnostic → vérification → prochain niveau. Dans le jeu, `GameViewModel.phase` est un unique enum `GamePhase` (`initializing`, `ready` = carte d'intro, `playing`, `paused`, `levelComplete(résultat)`, `interrupted`, `faceLost`, `resuming`, `suspended`, `failed`). Aucun booléen contradictoire.
- **ViewModels** : `GameViewModel`, `GazeSetupViewModel` et `CameraAccessViewModel` (`@MainActor @Observable`). Les écrans sans état propre (seuil, chapitres, carnet, réglages, fin de parcours, indisponibilité) lisent le coordinateur et lui envoient leurs intentions (ADR-4). La progression est enregistrée par le coordinateur via `ProgressStore` (ADR-15).
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
- Direction réelle du regard, précision obtenue après calibration, confort du protocole : validés par un humain sur iPhone 14 Pro le 12 septembre 2026 (§ 14) ; la précision mesurée dépend de la calibration (10 % / 17 % lors de la bonne, 17 % / 39 % lors de la moins bonne).

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
- **Événements** : `validationProgressed`, `validationProgressStopped`, `targetValidated`, `targetLost(cause: drift | cascade | veilleuse)`, `levelCompleted`, `intrusion`, `attentionLeftField`, `attentionReturned`, `veilleuseLow`, `veilleuseOut`, `veilleuseRelit`.
- **Règles de campagne (R-23 à R-28)**, portées par `LevelEnvironment` sans modifier le pas historique (ADR-14) : regard hors écran (tolérance 6 % du petit côté) = présence gelée et validation impossible ; courant = impulsion constante dans une bande, dans le même pas fractionnaire ; voile = collision disque-segment avec rebond amorti ; veilleuse = charge qui se vide en `decay` s et se remplit en `recharge` s sous le regard, et qui, éteinte, ferme ses iris et coûte leur validation ; iris mouvant = oscillation cosinus entre deux points ; tempéraments lourde et vive.
- **Échelle** : `LevelResolver` multiplie forces, vitesses et rayons par `petit côté / 393 pt` et exprime la zone d'attention en fraction du petit côté (0,42 à 0,50). Le prototype reste en unités absolues pour ses traces golden.
- **Mesures** : `SessionMetrics` compte les intrusions (entrées dans la zone), les pertes et les sorties de l'écran, pour les éclats.

---

## 6. Niveaux

La campagne compte **34 niveaux en six chapitres**. La longueur est justifiée par la matière disponible dans `Design/LEVEL_DESIGN_SYSTEM.md` § 8, et chaque niveau y est décrit avec son intention et ses mesures.

| Chapitre | Niveaux | Élément introduit | Zone d'attention | Compétence |
|---|---|---|---|---|
| I · éveil | 5 | lueur, iris, regard sur l'écran, tempéraments | 0,50 | éviter, tenir, traverser |
| II · partage | 5 | ordre, cascade | 0,46 | répartir, croiser, protéger |
| III · courants | 6 | courant | 0,48 | pousser contre |
| IV · voiles | 6 | voile | 0,46 | contourner en poussant |
| V · veilleuses | 6 | veilleuse | 0,44 | regarder sans troubler |
| VI · clairvoyance | 6 | iris mouvant | 0,42 | anticiper, puis tout combiner |

Vérifications automatiques (`CampaignStructureTests`, `CampaignSimulationTests`) :

- Structure, règles de combinaison (un élément nouveau par chapitre, au plus deux types hors chapitre VI) et géométrie (positions, iris hors courants, voiles, veilleuses visibles).
- **Faisabilité** : un robot guidé au regard bruité (± 24 pt, lissage du jeu) termine chaque niveau avec 3 graines en moins de 90 s.
- **Nécessité** : l'évitement suffit aux chapitres I et II ; tout niveau à voie échoue sans pousser ; tout niveau à veilleuse échoue sans regarder la flamme ; aucun niveau ne se termine hors écran.
- **Références d'éclats** : temps et intrusions atteignables mais exigeants.
- **Différence** : deux niveaux d'un chapitre diffèrent sur au moins deux des 13 critères.
- **Maîtrise** : le dernier niveau de chaque chapitre a la difficulté estimée la plus élevée de son chapitre.

`LevelLabTests` imprime la table de mesures reprise dans `LEVEL_DESIGN_SYSTEM.md` § 10.

Les 14 niveaux du prototype existent toujours (`PrototypeLevelCatalog`) comme référence historique : ils valident le port exact du moteur JavaScript (traces golden), mais ne sont plus jouables.

---

## 7. Audio

- `AVAudioEngine` → `AVAudioSourceNode` mono (Float32, fréquence du matériel) → mixeur → sortie. Session `.ambient` + `mixWithOthers` (respecte le commutateur silence).
- `SineSynth` (thread audio) : 3 voix de crescendo (sinus, fréquence 220 + p·340 Hz, gain 0,02 + p·0,025, constante de temps 0,05 s ; relâchement 0,08 s), carillon 3 notes (660/880/1100 Hz, 0,12 s chacune, enveloppe 30 % montée / 70 % descente, gain 0,05), perte (220 → 120 Hz linéaire sur 0,25 s, gain 0,05 → 0). Commandes de taille fixe protégées par `OSAllocatedUnfairLock`, lecture non bloquante côté rendu, aucune allocation dans la boucle.
- **Sons de campagne** : arpège de fin de niveau (440, 554, 659, 880 Hz, 0,16 s par note) qui remplace le carillon de la dernière validation ; battement de veilleuse faible (990 Hz, 60 ms) ; nappe d'ambiance par chapitre (deux sinus en quinte, gain 0,012, fondu de 0,8 s), fondamentale propre à chaque chapitre.
- **Deux réglages** depuis le 12 septembre 2026 : **Effets sonores** (crescendo, carillon, perte, arpège, battements ; activés par défaut) et **Ambiance sonore** (la nappe ; coupée par défaut après le retour humain : sourde, désagréable, sans bénéfice perçu). L'ancien réglage unique « Son » est migré sans rien rallumer : coupé reste tout coupé, activé garde sa nappe. Le moteur audio ne démarre que si l'un des deux est actif. Validé humainement (ambiance coupée, effets activés).
- **Politique sonore** (`AudioCuePolicy`, R-15) : crescendo par cible (voix = séquence − 1) tant que la présence progresse ; un carillon par validation, ou l'arpège si elle termine le niveau ; **un seul son de perte par tick**, même en cascade, extinction de veilleuse comprise, jamais deux à moins de `FeedbackTiming.lossRetriggerInterval` (150 ms, garde partagée avec l'haptique, § 15) ; battement de veilleuse au plus une fois par seconde. Pause, interruption, arrière-plan et sortie coupent les voix de progression. Le réglage « Son » désactive le moteur audio.
- Cycle de vie : interruption `AVAudioSession` (began → pause, ended + shouldResume → redémarrage), `AVAudioEngineConfigurationChange` et `mediaServicesWereReset` → reconstruction du graphe. Échec de démarrage → `AudioStatus.unavailable` affiché dans le HUD, le jeu continue sans son.
- Statuts : synthèse et politique `[vérifié automatiquement]` (rendu hors ligne à 44,1 kHz : hauteurs, enveloppes, silences) ; démarrage moteur exercé sur simulateur `[vérifié par compilation]` ; sortie réelle sur appareil `[nécessite validation sur appareil TrueDepth]`.

---

## 8. UI / UX

Référence : `Design/UX_VISION.md` et `Design/ART_DIRECTION.md`. Implémentation : `Docs/design-system.md`.

- **Identité « chambre noire »** : fond encre avec fibres d'iris et respiration lente, lueurs nacrées émissives, iris dessinés comme des diaphragmes à six lames qui se referment pendant la présence, ambre réservé à l'attention, menthe à la réussite, corail au trouble, bleu marée pour les courants. Titres en serif minuscules, sourcils en capitales espacées, numéraux romains pour les chapitres. Nouvelle icône d'application : le diaphragme ambre autour d'une lueur.
- **Écrans** :
  - **seuil** : emblème, promesse, *Commencer* ou *Continuer* avec le prochain niveau, *Chapitres*, total d'éclats, réglages ;
  - **permission caméra** et **setup du regard** (Gaze Engine v2, restylés) ;
  - **chapitres** : six cartes, nœuds de niveau avec arcs d'éclats, prochain niveau cerclé d'ambre, chapitres verrouillés ;
  - **carnet** : éléments rencontrés, glyphe et une phrase, les autres « à découvrir » ;
  - **réglages** (feuille) : effets sonores, ambiance sonore, vibrations, points de regard, recalibrer, carnet, réinitialiser la progression avec confirmation, confidentialité ;
  - **jeu** : champ plein écran, repère « III · 2 » et pause en périphérie, consignes en bas, carte d'intro compacte et translucide, pause avec recalibration, **résultat** avec trois éclats qui s'allument l'un après l'autre, interruption, visage perdu, reprise, erreurs ;
  - **fin de parcours** « clairvoyance » avec niveaux, éclats et temps de jeu ;
  - **appareil sans suivi facial**.
- **Retours** : onde corail proportionnelle à la force de répulsion, lames qui se ferment, iris grisés quand le regard quitte l'écran ou qu'une veilleuse s'éteint, flamme qui vacille et anneau de charge corail sous 30 %, voie en pointillés après 45 s ; au toucher, une impulsion par validation, par perte et à la fin du niveau (§ 15).
- **Rendu** : un fond statique et un seul `Canvas` alimenté par un snapshot immuable par frame ; halos en dégradés radiaux additifs, sans filtre de flou ; HUD et overlays observent des propriétés grossières.
- **Accessibilité** : Dynamic Type, cibles ≥ 44 pt, libellés VoiceOver (chapitres, nœuds, éclats, HUD), consignes publiées comme annonces d'accessibilité, rang jamais porté par la seule couleur, Reduce Motion (pas de respiration, filaments figés, pas de scintillement ni d'onde animée), texte tertiaire ≥ 4,5:1.
- **Captures simulateur** (iPhone 17) réalisées après implémentation : seuil (premier lancement et reprise), chapitres, carnet, intro 3-1, jeu 4-6, 5-6 et 6-5, résultat 1-2, fin de parcours, calibration. Deux défauts visuels relevés ainsi ont été corrigés : les lames se reliaient en anneau continu, et la carte d'intro masquait le niveau.

---

## 9. Confidentialité

- Caméra frontale utilisée uniquement via `ARFaceTrackingConfiguration` pour estimer `lookAtPoint` en temps réel. Message `NSCameraUsageDescription` (`Config/Info.plist`) en français, compréhensible.
- Aucune image, aucune vidéo, aucune géométrie ni représentation du visage n'est conservée : les `ARFrame` sont lus puis relâchés dans le callback ; l'échantillon brut (impact sur le plan, position des yeux, clignements) vit le temps d'une frame et n'est jamais persisté ; les échantillons de calibration sont agrégés puis oubliés.
- Aucun compte, serveur, cloud, analytics. Stockage local dans `UserDefaults`, limité à :
  - quatre préférences : points de regard, effets sonores, ambiance sonore, vibrations ;
  - le profil de calibration : 6 coefficients, mapping d'axes, orientation, viewport, repère nominal, date, erreurs de vérification, validité ;
  - la progression : pour chaque niveau, nombre de réussites, meilleur temps, moins d'intrusions et éclats ; plus le temps de jeu total et les éléments rencontrés.

  Aucune donnée de regard ni de visage n'est stockée. La progression peut être effacée depuis les réglages.

---

## 10. Tests

Suite Swift Testing (`Tests/IrisTests`, 37 fichiers) exécutée sur simulateur iPhone 17 Pro (iOS 26.3.1) via `xcodebuild test`.

| Domaine | Fichiers | Ce qui est couvert |
|---|---|---|
| Physique | `TargetPhysicsTests` | attraction, répulsion, proportionnalité, frontière de zone, bruit uniquement hors zone, plafond 2,2, friction 0,94, équivalence temporelle (demi-pas), rebonds amortis, quatre bords, stabilité pour f ∈ {0,05 … 3}, facteurs de pas fractionnaire |
| Validation | `ValidationRuleTests` | entrée dans la zone, refus à 44 frames, validation à 45, validation temporelle à 30 et 120 Hz, sortie avant validation, rayon strict 16 pt, maintien à 35 pt, perte à 37 pt, progression des événements |
| Ordre | `SequenceOrderTests` | 1 immédiatement, 2 pas avant 1, 3 pas avant 1 et 2, arrivée physique hors tour, validation 1 → 2 → 3, `TurnRule` |
| Cascade | `CascadeRuleTests` | perte de 3 seule ; perte de 2 → 2 et 3 ; perte de 1 → 1, 2, 3 (règle et session, avec événements), retour à l'ordre, absence de cascade en niveau simple |
| Prototype | `PrototypeLevelCatalogTests` | 14 niveaux historiques, comptes 1/2/3, bandes exactes, hold 0,75 s, marges, géométrie exacte niveaux 1 et 9 |
| Campagne | `CampaignStructureTests`, `CampaignSimulationTests`, `LevelLabTests` | structure 5/5/6/6/6/6, introductions, combinaisons, géométrie, résolution sur 3 tailles d'écran ; faisabilité (robot guidé, 3 graines), nécessité (évitement, sans veilleuse, hors écran), références, 13 critères de différence, maîtrise ; table de mesures |
| Environnement | `LevelEnvironmentTests` | échelle du résolveur, R-23 regard hors écran et tolérance, courant bloquant puis traversé en poussant, voile bloquant et réponse de collision, cycle et arithmétique de veilleuse, iris mouvant, intrusions, prototype non affecté |
| Progression et consignes | `CampaignProgressTests`, `ProgressStoreTests`, `HintTrackerTests`, `LaunchOptionsTests` | éclats, records, déblocage et prochain niveau, éléments rencontrés ; stockage UserDefaults et mémoire ; consignes par déclencheur, disparition après 4,5 s, aide générique ; options de lancement et progression amorcée |
| Fidélité | `GameSessionGoldenTests` | deux traces frame par frame générées par le moteur JavaScript extrait (`Fixtures/golden_generator.js`) : niveau 1 (393 frames, répulsion, rebonds, attraction, validation) et niveau 9 (241 frames, validations 1, 2, 3 aux frames 151, 196, 241), tolérance 1e-6 |
| Session | `GameSessionTests`, `GazeFilterTests`, `ValueNoise1DTests`, `LinearCongruentialGeneratorTests` | chargement, complétion, bornage 0,1 s, 30 Hz = 2 × 60 Hz exact, 120 Hz, deltas nuls, lissage, sauts, bruit, LCG |
| Haptique | `HapticCuePolicyTests`, `GameSettingsStoreTests` | validation, perte quelle que soit la cause, cascade = une impulsion, une impulsion par tick (perte avant validation), garde partagée avec l'audio et non empilement, fin de niveau jamais filtrée, préparation une fois par maintien, événements muets, remise à zéro ; préférences par défaut et persistance |
| Audio | `AudioCuePolicyTests`, `SineSynthTests` | cascade → un seul son, garde 150 ms, arpège de fin qui remplace le carillon, veilleuse (perte, battement limité), hauteurs 560 / 305 Hz, gains, extinction, carillon, balayage descendant, arpège, battement, nappe (fondu entrant et sortant) |
| Regard v2 | `AxisMappingTests`, `AffineTransform2DTests`, `RobustAggregatorTests`, `FixationSequenceTests`, `NormalizedCoordinatesTests`, `CalibrationProfileTests`, `GazeMapperTests`, `GazeReadinessEvaluatorTests`, `GazeSetupViewModelTests` | repère standard, retourné 180°, miroir, pivoté 90°, gravité / repli, dégénérescences, votes ; identité, offsets, échelles, combinaison, miroir corrigé, bruit, refus (< 3 points, non fini, colinéaire) ; médiane / MAD ; stabilisation, collecte, clignements, reprise puis échec, prolongation ; conversions et grilles ; sauvegarde / chargement (mémoire et UserDefaults), compatibilité (version, validité, orientation, viewport, âge) ; rayon / plan des deux côtés, mapping appliqué avant le nominal, calibration appliquée une fois, bornage, détecteur de clignements ; readiness (prêt, en attente, bloqué, yeux, direction, stabilité, blend shapes) ; parcours complet avec biais appris, regard miroir corrigé, verdict insuffisant / continuer quand même, recalibration, revalidation, signal insuffisant, matériel / caméra, clignements ignorés, cycle de vie, propriété du tracker partagé |
| Présentation | `GameViewModelTests`, `AppCoordinatorTests`, `CameraAccessViewModelTests` | intro, nappe du chapitre, son désactivé, haptique activée (préparation puis impulsion de fin avec l'arpège) et désactivée (rien, prise en compte au tick suivant), consignes jouées, résultat et éclats nouveaux, niveau suivant, fin de chapitre et de campagne, rejouer, recommencer, chapitres, voie après 45 s, curseur, profil appliqué, visage perdu, interruptions et erreurs, arrière-plan, recalibration, autoplay, propriété du tracker partagé ; seuil, appareil incompatible, premier lancement, revalidation, caméra, annulation, niveaux verrouillés et progression, carnet, parcours depuis les chapitres, réglages et recalibration, finale, réinitialisation, options de lancement ; permission |

### 10.1 Résultats réels de la dernière exécution (12 septembre 2026, après la correction haptique)

Commande :

```
xcodebuild -project Iris.xcodeproj -scheme Iris \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Debug test
```

Résultat : `Test run with 232 tests in 35 suites passed after 6.320 seconds` puis `** TEST SUCCEEDED **`. Le bundle de tests construit porte l'identifiant `net.steve-s.iris.tests`, l'hôte `net.steve-s.iris`.

| Exécutés | Réussis | Échoués | Ignorés |
|---|---|---|---|
| 232 | 232 | 0 | 0 |

**232/232 PASS** (220 tests de la refonte, 12 tests haptiques et de préférences ajoutés). Aucun test n'est désactivé. Au premier passage, un nouveau test de garde haptique échouait parce qu'il plaçait la seconde perte exactement à la frontière de 150 ms, où l'arithmétique flottante donne 0,1499… : le test place désormais ses pertes nettement en deçà et au-delà de la garde ; la politique n'a pas changé. Les traces golden du moteur JavaScript restent vertes : le noyau historique n'a pas changé.

Deux tests de présentation ont été réécrits parce que leur objet a disparu : le parcours à 14 niveaux (`GameProgression`) et le tutoriel. Deux tests audio ont été adaptés : la dernière validation joue désormais l'arpège de fin au lieu du carillon. Au premier passage de la suite complète, un test échouait : il supposait qu'une caméra encore refusée menait au setup du regard. Le code est correct, car le coordinateur revérifie l'autorisation réelle. Le test a été corrigé et couvre maintenant les deux cas.

---

## 10 bis. Builds

Toutes les commandes ont été réellement exécutées depuis la racine du projet, sur macOS 26.3 (Darwin 25.3.0), Xcode 26.3 (17C529), SDK iOS 26.2, simulateur iPhone 17 Pro (iOS 26.3.1), le 12 septembre 2026 après la correction haptique (§ 15) ; les résultats du 11 septembre (identité Apple, § 13) étaient identiques hors nombre de tests. Les builds appareil sont désormais **signés** (signature automatique, équipe `G4U9RG5GL7`), plus `CODE_SIGNING_ALLOWED=NO`.

| # | Commande | Résultat réel |
|---|---|---|
| 1 | `xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Debug build` | `** BUILD SUCCEEDED **`, 0 erreur, 0 warning issu de notre code |
| 2 | `xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Debug test` | `** TEST SUCCEEDED **`, 232 tests, 232 réussis, 0 échec, 0 ignoré |
| 3 | `xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Release build` | `** BUILD SUCCEEDED **`, 0 erreur, 0 warning |
| 4 | `xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'generic/platform=iOS' -configuration Debug build` (signé) | `** BUILD SUCCEEDED **` ; `codesign` : `Identifier=net.steve-s.iris`, `TeamIdentifier=G4U9RG5GL7`, identité « Apple Development », profil « iOS Team Provisioning Profile: * » choisi automatiquement (rien d'épinglé), entitlements `application-identifier`, `com.apple.developer.team-identifier`, `get-task-allow` |
| 5 | `xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'generic/platform=iOS' -configuration Release build` (signé) | `** BUILD SUCCEEDED **` ; `Identifier=net.steve-s.iris`, `TeamIdentifier=G4U9RG5GL7` |
| 6 | `xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'generic/platform=iOS' -configuration Debug build-for-testing` (signé) | `** TEST BUILD SUCCEEDED **` ; `IrisTests.xctest` signé `net.steve-s.iris.tests`, équipe `G4U9RG5GL7` (11 septembre, non relancé le 12) |
| 7 | `xcrun devicectl device install app --device <iPhone 14 Pro> Iris.app` puis `xcrun devicectl device process launch --device <iPhone 14 Pro> net.steve-s.iris` | `App installed: bundleID: net.steve-s.iris` ; `Launched application` (build haptique du 12 septembre installé par-dessus la précédente) |
| 8 | `python3 Tools/audit.py` | C1, C2, C8, C9, C10, C12 et scan TODO : pass, 200 fichiers |

Diagnostics restants :

- `appintentsmetadataprocessor[...] warning: Metadata extraction skipped. No AppIntents.framework dependency found.` : notice de l'outillage Xcode émise pour toute app sans App Intents ; aucun défaut du projet, non masquée.
- Aucun warning du compilateur Swift (mode Swift 6, concurrence stricte complète, `ExistentialAny` activé) ni de l'éditeur de liens.

Appareil physique : `xcrun devicectl list devices` montre l'iPhone 14 Pro « iPhone Steve. » (iOS 26.5.2, mode développeur activé, jumelé, connecté) ; son UDID figure dans le profil de développement automatique de l'équipe. Statuts réels :

- `[build appareil réussi]` : Debug et Release signés pour arm64 (lignes 4 à 6).
- `[installation appareil réussie]` : le build Debug du 11 septembre, puis celui du 12 (haptique), ont été installés par `devicectl` (mise à jour de l'installation `net.steve-s.iris`, données conservées) et lancés. Aucune interaction n'a eu lieu sur l'écran lors de ces lancements automatisés.
- Validation humaine du regard : faite le 12 septembre (§ 14). `[sensation physique nécessite validation humaine]` pour les impulsions haptiques (§ 15).

L'iPhone conserve aussi une installation `com.prodx0x.iris` faite depuis Xcode avant la migration ; rien ne la met plus à jour, elle peut être supprimée à la main.

Vérifications sur simulateur (iPhone 17, options DEBUG `--iris-route`, `--iris-level`, `--iris-progress`, `--iris-autoplay`, `--iris-gaze`, `--iris-oracle-gaze`) : captures des écrans listés au § 8, aucun rapport de plantage produit. Le regard y est simulé : ces captures valident le rendu et la navigation, pas la jouabilité au regard.

---

## 11. Validation

| Élément | Statut |
|---|---|
| Noyau historique (générateur prototype, bruit, physique, validation, ordre, cascade, filtre de regard), règles de campagne R-23 à R-30, faisabilité et nécessité de chaque niveau par simulation, références d'éclats, progression et stockage, consignes, politique et synthèse audio, Gaze Engine v2 (rayon, axes, affine, agrégation, fixation, critères, profil, readiness), machines d'états du jeu, du setup et du coordinateur, permission | `[vérifié automatiquement]` |
| Intégration ARKit (`ARSession`, délégué, interruptions), `AVAudioEngine` sur appareil, `CADisplayLink`, rendu Canvas de la chambre noire, écrans SwiftUI (seuil, chapitres, carnet, réglages, intro, résultat, fin de parcours), vibration de réussite, Info.plist / permission caméra | `[vérifié par compilation]` (Debug et Release simulateur, Debug et Release appareil arm64 signés) ; écrans et rendu également observés sur simulateur avec un regard simulé ; lancement sur iPhone 14 Pro sans plantage à 8 s |
| Identité Apple : Bundle ID `net.steve-s.iris`, équipe `G4U9RG5GL7`, signature automatique, cohérence `project.yml` / projet généré / sources | `[vérifié automatiquement]` (audit C12) et `[build appareil réussi]` (signature réelle, profil automatique) |
| Direction du regard, calibration et jouabilité de base sur iPhone 14 Pro | validés par un humain le 12 septembre 2026 (§ 14) |
| Logique haptique (événements, cascade, garde, réglage) | `[logique haptique vérifiée automatiquement]` |
| Sensation des impulsions, jouabilité fine des niveaux de poussée (III, IV, VI) et de vigilance (V), pertinence des références d'éclats, durée et courbe de difficulté ressenties, lisibilité en lumière réelle, sons sur appareil | `[sensation physique nécessite validation humaine]` / `[nécessite validation sur iPhone TrueDepth]` |

---

## 12. Limites honnêtes

- Le suivi du regard a été validé par un humain sur iPhone 14 Pro le 12 septembre 2026 (§ 14) : calibration fonctionnelle, gameplay fluide. Deux contraintes observées, non « réparées » : sensibilité aux micro-mouvements du téléphone tenu en main, et point de diagnostic qui sort de l'écran aux extrêmes. Le confort sur une longue session et le ressenti des vibrations restent à mesurer.
- Les conventions d'axes du repère caméra ARKit pour la caméra frontale ne sont pas documentées de façon exploitable ; le Gaze Engine v2 ne les présume plus (résolution par les yeux et la gravité), mais la première confirmation viendra du diagnostic sur appareil (ligne « Orientation du regard » et logs `gaze`).
- Le simulateur n'a pas de TrueDepth : la build simulateur remplace le regard par le doigt (glisser sur l'écran) ou, avec `--iris-oracle-gaze`, par un regard scripté qui fixe chaque cible ; le HUD l'indique (« mode : simulateur (toucher) »). Ces modes n'existent pas sur appareil.
- L'échelle physique de l'écran et la position de la caméra sont des estimations par famille d'appareil (erreur attendue de quelques pour cent). Les iPad dont la caméra est sur le bord long (iPad Pro M4, iPad 10) sont approximés avec une caméra en haut.
- La suite de tests s'exécute avec l'app comme hôte sur simulateur ; elle ne dépend d'aucun matériel.
- Les gains sonores absolus ont été validés hors ligne, pas à l'oreille sur appareil.
- Le robot de campagne est plus précis et plus rapide qu'un humain. Il prouve qu'un niveau est faisable et qu'un élément est nécessaire, pas qu'il est agréable. La courbe de difficulté ressentie, la frustration et la durée réelle d'un parcours (estimée entre 1 h 30 et 2 h 30) restent à mesurer avec des joueurs.
- Deux retours conçus ne sont pas implémentés : le trait corail qui relie une perte en cascade à sa cause et l'assombrissement avant le résultat (`Design/GAME_DESIGN.md` § 11). La vibration par validation l'est depuis le 12 septembre 2026 (§ 15).
- La carte d'intro, même translucide, recouvre le bas de l'écran. Sur les niveaux dont la lueur part en bas, le joueur la découvre pleinement en touchant *Commencer*, avant tout mouvement.
- Les niveaux sont réglés et vérifiés sur un écran de 393 × 852 pt. Ils se résolvent sur toutes les tailles testées (375 × 812, 430 × 932, 834 × 1194), mais la simulation de faisabilité n'est exécutée que sur l'écran de référence ; l'iPad, au rapport d'aspect différent, n'est pas vérifié par simulation.

---

## 13. Identité Apple : migration, cause et vérifications (11 septembre 2026)

Résumé autoritaire en tête de ce fichier (« Apple Signing »). Ce paragraphe donne les faits.

### 13.1 Bundle

| | |
|---|---|
| Ancienne valeur constatée | `com.prodx0x.iris` (app) et `com.prodx0x.iris.tests` (tests) dans `project.yml`, donc dans chaque projet régénéré ; `net.steve-s.iris` saisi à la main dans Xcode, présent seulement dans le `.pbxproj` |
| Nouvelle valeur | `net.steve-s.iris` (app), `net.steve-s.iris.tests` (tests), `bundleIdPrefix: net.steve-s` |
| Fichiers migrés | `project.yml` (source), `Iris.xcodeproj/project.pbxproj` (régénéré), sous-systèmes `os.Logger` de `ARKitGazeTrackingService`, `GazeSetupViewModel`, `GameViewModel` (`net.steve-s.iris`, pour filtrer la Console), `GAZE_ENGINE_V2_REPORT.md`, `Docs/project-brief.md`, ce README |
| Non concernés | `Config/Info.plist` (`$(PRODUCT_BUNDLE_IDENTIFIER)`), aucun `.xcconfig`, `.entitlements`, `.storekit`, URL scheme, App Group, groupe de trousseau, domaine associé, script de CI ; le scheme référence les cibles par identifiant interne |
| Occurrences restantes de l'ancien préfixe | `Tools/audit.py` (chaîne interdite recherchée par le contrôle C12), `Docs/architecture.md` ADR-17 et ce paragraphe (historique). Aucune dans le code, la configuration ou les ressources |

### 13.2 Team

| | |
|---|---|
| Team ID retenu | `G4U9RG5GL7` |
| Méthode | (1) `security find-identity -v -p codesigning` puis lecture du champ **OU** des certificats : les quatre certificats « Apple Development » et les deux « Apple Distribution » portent `OU=G4U9RG5GL7`, `O=Stéphane SAULNIER` ; (2) Xcode (`defaults read com.apple.dt.Xcode`) ne connaît qu'une équipe, `G4U9RG5GL7`, « Stéphane SAULNIER », type Individual, payante, dernière équipe sélectionnée ; (3) les 29 profils de provisioning installés appartiennent tous à `G4U9RG5GL7` et les autres apps du compte utilisent le préfixe `net.steve-s` ; (4) le seul build appareil signé présent dans DerivedData portait `TeamIdentifier=G4U9RG5GL7` |
| Ce qu'est `NKN63DTRM4` | l'identifiant personnel inscrit entre parenthèses dans le **nom** des certificats « Apple Development » (`CN=Apple Development: Stéphane SAULNIER (NKN63DTRM4)`). Ce n'est pas une équipe : Xcode ne le trouve dans aucun compte, d'où l'absence d'équipe dans Signing & Capabilities |
| Persistance | `project.yml` → `settings.base.DEVELOPMENT_TEAM` (hérité par `Iris` et `IrisTests`), donc dans chaque projet régénéré ; contrôlé par C12 |

### 13.3 Signing

| Réglage | Debug | Release |
|---|---|---|
| `PRODUCT_BUNDLE_IDENTIFIER` (Iris) | `net.steve-s.iris` | `net.steve-s.iris` |
| `PRODUCT_BUNDLE_IDENTIFIER` (IrisTests) | `net.steve-s.iris.tests` | `net.steve-s.iris.tests` |
| `DEVELOPMENT_TEAM` | `G4U9RG5GL7` | `G4U9RG5GL7` |
| `CODE_SIGN_STYLE` | `Automatic` | `Automatic` |
| `CODE_SIGN_IDENTITY` | `Apple Development` (type générique, pas un certificat précis) | `Apple Development` |
| `PROVISIONING_PROFILE_SPECIFIER` | absent | absent |
| Entitlements | aucun fichier ; la caméra n'en exige pas ; entitlements injectés par le profil automatique | idem |

Valeurs lues avec `xcodebuild -showBuildSettings` pour les deux configurations, pour l'appareil et le simulateur, et confirmées par `codesign -dv` sur les produits signés (§ 10 bis). Il n'existe pas de configuration Archive distincte : l'archive utilise Release.

### 13.4 Cause réelle du problème

1. Lors de la création du projet (11 septembre 2026, première mission), le Team ID a été lu dans le **nom** du certificat « Apple Development » au lieu de son champ OU : `project.yml` a reçu `DEVELOPMENT_TEAM: NKN63DTRM4`, et un préfixe d'identifiant inventé, `com.prodx0x`.
2. Xcode ne connaissant aucune équipe `NKN63DTRM4`, Signing & Capabilities affichait une équipe manquante. Le concepteur a corrigé dans Xcode (équipe `G4U9RG5GL7`, identifiant `net.steve-s.iris`). Xcode n'écrit que dans `Iris.xcodeproj/project.pbxproj` ; `project.yml` n'a pas changé. Cet état a été commité (`6e1b726`).
3. Chaque `xcodegen generate` (après chaque ajout de fichier, à de nombreuses reprises pendant les missions Gaze Engine v2 et refonte) a régénéré le `.pbxproj` depuis `project.yml`, rétablissant `com.prodx0x.iris` et `NKN63DTRM4`. D'où le retour répété dans Signing & Capabilities, et deux installations différentes sur l'iPhone (`com.prodx0x.iris` et `net.steve-s.iris`).
4. Aucun `.xcconfig`, script, CI ou suppression explicite de `DEVELOPMENT_TEAM` n'est en cause. La cause est double : une valeur fausse dans la source génératrice, et une correction faite dans le fichier généré.

Correction : les bonnes valeurs sont dans `project.yml` (commentaire de tête explicite), l'identité « iPhone Developer » héritée du préréglage XcodeGen est remplacée par « Apple Development » (ce qu'écrit Xcode lui-même), `ORGANIZATIONNAME` du projet vaut « Stéphane SAULNIER » (en-têtes des nouveaux fichiers Xcode ; sans effet sur la signature), et `Tools/audit.py` C12 échoue si `project.yml`, le `.pbxproj` ou les sources s'écartent des valeurs verrouillées.

### 13.5 Appareil

iPhone 14 Pro « iPhone Steve. » détecté, connecté, mode développeur activé ; build Debug signé, installé et lancé (§ 10 bis, lignes 4 à 7). Statuts : `[build appareil réussi]`, `[installation appareil réussie]`, `[nécessite validation humaine]` pour la calibration et le jeu.

### 13.6 Identité

- Concepteur : Stéphane SAULNIER (champ `O` des certificats, nom de l'équipe Apple, `ORGANIZATIONNAME` du projet).
- Marque éventuelle : ProdX0xSs, non utilisée comme Apple Account, Team ID, identité légale, Bundle ID ou nom de vendeur.
- Aucune donnée de compte (e-mail, mot de passe, jeton, clé) dans le dépôt ; le dépôt distant GitHub est authentifié par Xcode / le trousseau, hors projet.
- `NSHumanReadableCopyright` n'est pas ajouté à `Info.plist` : la clé est ignorée sur iOS.

### 13.7 StoreKit readiness

Le Bundle ID principal `net.steve-s.iris` est stabilisé : défini dans la source génératrice, régénéré à l'identique, vérifié par l'audit, signé et installé sous l'équipe `G4U9RG5GL7`. La configuration StoreKit (App ID explicite sur le portail, produits, `.storekit` de test) peut être entreprise sur cette base. Prérequis restant côté portail, non fait ici : enregistrer l'App ID explicite `net.steve-s.iris` (le profil actuel est un profil de développement générique `G4U9RG5GL7.*`, suffisant pour le développement, pas pour les achats intégrés ni pour la distribution).

---

## 14. Validation humaine — iPhone 14 Pro (12 septembre 2026)

Session réelle sur l'iPhone 14 Pro, téléphone tenu dans son orientation normale, regard du joueur, calibration réelle.

| Observation | Constat |
|---|---|
| Calibration physique | réalisée : diagnostic, neuf cibles, vérification, « Regard prêt » |
| Calibration réussie | erreur moyenne 10 %, maximale 17 % : acceptée |
| Calibration moins bonne | erreur moyenne 17 %, maximale 39 % pour des seuils de 18 % / 30 % : refusée, recalibration proposée, comme prévu par R-20 |
| Gameplay | fluide, expérience satisfaisante ; aucune nécessité de retourner l'iPhone |
| Téléphone tenu en main | les micro-mouvements de la main influencent le regard apparent, donc les lueurs ; nettement moins sur un support |
| Extrêmes de l'écran | en regardant très loin vers un bord ou une diagonale, le point de diagnostic peut sortir de l'écran et disparaître |
| Corrections du Gaze Engine | aucune : ces deux observations sont conservées comme contraintes de conception |

Conséquences pour la suite : les futurs niveaux ne doivent exiger ni une immobilité irréaliste du téléphone, ni une précision extrême prolongée, ni une stabilité incompatible avec un usage tenu en main. Les coordonnées de jeu ne sont pas bornées artificiellement pour rendre le point visible ; une éventuelle amélioration ne concernera que la visualisation de diagnostic (indicateur collé au bord ou flèche), non faite ici.

Statut : **Gaze Engine v2 suffisamment validé humainement pour démarrer le game design.** Restent à mesurer sur la durée : confort, fatigue, courbe de difficulté ressentie.

---

## 15. Haptique (12 septembre 2026)

**Cause du défaut.** Le réglage « Vibrations » existait, était persisté et lu, mais un seul retour haptique existait dans toute l'app : un modificateur SwiftUI `sensoryFeedback(.success)` sur l'écran de résultat, déclenché quand le troisième éclat s'allume, soit près d'une seconde après la fin du niveau. Aucun événement de jeu (validation, perte, cascade, fin de niveau au tick) n'appelait de générateur haptique : c'était une décision de conception de la refonte (« seule la réussite du niveau vibre »), pas un bogue de thread, de `prepare()` ni de générateur non conservé. Le joueur ne pouvait donc rien sentir pendant la partie. À vérifier aussi sur l'appareil : le réglage iOS « Vibrations système » (Réglages › Sons et vibrations) coupe tous les générateurs UIKit, Iris ne le contourne pas.

**Architecture.** Une couche `Haptics/` calquée sur `Audio/` : `HapticCue` (intentions : `prepare`, `validation`, `loss`, `levelComplete`), `HapticCuePolicy` (Foundation seul, déterministe), protocole `HapticFeedbackService` avec `UIKitHapticFeedbackService` (générateurs conservés pour la session : impact moyen à 0,7 pour une validation, impact doux à 0,45 pour une perte, notification de réussite pour la fin de niveau) et `SilentHapticFeedbackService` (aperçus). `AppContainer` choisit l'implémentation ; `GameViewModel` consomme la politique à chaque tick, uniquement si la préférence est activée. Le modificateur SwiftUI de l'écran de résultat est supprimé : une seule source de vérité. Le moteur de jeu ne connaît pas UIKit.

**Événements couverts.** Validation d'une lueur ; perte d'une validation, quelle qu'en soit la cause (dérive, cascade, veilleuse éteinte) ; fin de niveau, en remplacement de l'impulsion de la dernière validation et synchronisée avec l'arpège audio. Aucune vibration de navigation ni de sélection : l'interface n'en avait pas.

**Cascade.** Une cascade est une perte logique : tous les événements de perte d'un même tick donnent au plus une impulsion. Un tick ne produit jamais plus d'une impulsion, la fin de niveau primant sur la perte, qui prime sur la validation. La règle est appliquée dans la politique, avant tout appel au service, pas masquée après coup.

**Anti-empilement.** Deux impulsions ne sont jamais espacées de moins de `FeedbackTiming.lossRetriggerInterval` (150 ms), constante du domaine désormais partagée avec `AudioCuePolicy` : c'était déjà la garde audio de R-15, un seul concept métier, une seule valeur. La fin de niveau n'est jamais filtrée. La boucle « perte → vibration → micro-mouvement → nouvelle perte » est bornée par cette garde, par l'intensité douce de la perte et par le maintien de 0,75 s nécessaire à toute revalidation. `prepare()` est appelé une fois au début d'un maintien, pour que l'impulsion de validation n'ait pas de latence ; ce n'est pas la cause du défaut initial.

**Réglage.** « Vibrations » commande tous les retours haptiques volontaires d'Iris, prend effet au tick suivant, et persiste dans `UserDefaults` avec les autres préférences.

**Tests.** `HapticCuePolicyTests` (8), `GameSettingsStoreTests` (2), `GameViewModelTests` (2 nouveaux) : `[logique haptique vérifiée automatiquement]`. La sensation réelle des impulsions, leur intensité et leur discrétion : `[sensation physique nécessite validation humaine]`.

---

## 16. Conception de l'expansion — phase A (12 septembre 2026)

Sur `feature/game-expansion`, après la validation humaine du Gaze Engine (§ 14) et de l'haptique (§ 15), une phase de conception sans implémentation a produit, dans `Design/` :

| Document | Contenu | Statut |
|---|---|---|
| `GAME_CORE_INVARIANTS.md` | ce qui fait Iris, ce qui varie, ce qui l'approfondit, ce qui le dénaturerait | autoritaire (A et D) |
| `PLAYER_COMFORT_CONSTRAINTS.md` | contraintes issues du test iPhone : précision, périphérie, micro-mouvements, fatigue, calibration, haptique | autoritaire |
| `DIFFICULTY_MODEL.md` | douze axes, profils des chapitres, garde-fous de séquence | provisoire |
| `GAME_EXPANSION_CONCEPTS.md` | douze concepts de chapitre, critiques à charge, matrice, éliminations, quatre finalistes, seconde passe | à juger |
| `CAMPAIGN_STRUCTURE.md` | campagne de dix chapitres proposée, courbe, découpages, solutions de repli, partie gratuite | à juger |
| `LEVEL_DESIGN_SYSTEM.md` | partie A implémentée (I à VI) ; partie B provisoire (dimensions, règles à assouplir, éléments candidats) | provisoire |
| `GAME_VISION.md`, `GAME_DESIGN.md` | révisés : audit des six chapitres, espace inexploité, sections de rythme et de confort, indécisions | révisés |

Rapport de synthèse : `GAME_EXPANSION_DESIGN_REPORT.md` (racine). Aucun niveau, aucun chapitre, aucune mécanique, aucun paramètre du regard ni du moteur n'a été modifié pendant cette phase ; les 232 tests et les six chapitres sont ceux du commit haptique.

**Étape suivante : validation humaine de la conception avant toute implémentation des nouveaux chapitres.**

---

## 17. Prototype « Braises A » (hors campagne, DEBUG, validé humainement)

Un niveau expérimental, `0-1` « braise », chapitre « P » (`Domain/Campaign/BraisesPrototype.swift`, compilé en DEBUG seulement), issu de la phase B1 et validé sur iPhone 14 Pro le 12 septembre 2026. Statut détaillé : `Design/BRAISES_VALIDATION_STATUS.md`.

- **Mécanique** : une braise dort, froide et immobile ; le regard posé sur elle (rayon 0,22 du petit côté, 86 pt) la réchauffe en 0,9 s ; à 0,5 elle s'allume : elle fuit le regard comme toute lueur, dérive vers son iris, et l'iris l'accepte ; ignorée, elle refroidit en 30 s et se rendort sous 0,4. Au-delà de 0,85 elle s'affole : sa zone d'attention grandit jusqu'à × 1,5 et le regard l'influence de plus loin. Elle ne perd jamais sa chaleur pour avoir été regardée. **Ces valeurs sont figées** (`BraiseDefinition.prototype`, test `aIsFrozen`).
- **Accès sur iPhone** : Réglages → *prototypes (debug)* → Braises A. Option de lancement : `--iris-route game --iris-level 0-1`. Rien n'est enregistré dans la progression ; le résultat propose les chapitres, jamais la fin de parcours.
- **Isolation** : `LueurDefinition.braise` (nil dans les 34 niveaux officiels), `BraiseState` et `BehaviourScale` dans le moteur (neutres, × 1,0 exact, pour toute lueur ordinaire ; traces golden inchangées), trois événements, deux déclencheurs de consigne, un dessin de braise, un lanceur DEBUG. Le Gaze Engine, la calibration, la physique de référence et les six chapitres sont inchangés ; un test le vérifie.
- **Vérifié automatiquement** : chaleur, hystérésis, affolement, comportement ; réveil, fuite, retour et validation en session ; portée accrue d'une braise affolée ; faisabilité par le joueur simulé qui nourrit et impossibilité sans nourrir ou hors écran ; consignes, son et haptique ; isolation de la progression ; définition figée.
- **Validé humainement** : sommeil, réveil, attraction naturelle, répulsion, affolement, portée accrue après affolement.
- **Braises B** (une seconde lueur à protéger) a été prototypé, retravaillé trois fois et **rejeté dans sa forme testée** : absent de cette baseline. Trace et motifs : `Design/BRAISES_VALIDATION_STATUS.md` ; branches d'archive `prototype/braises*`.

---

## 18. Baseline validée d'expansion (branche `baseline/iris-expansion-validated`, 12 septembre 2026)

Point de départ autoritatif des prochains prototypes : l'ancêtre propre `937d549` (phase A) plus, transplantés à l'identique, **Braises A** validé humainement et la **séparation audio** validée humainement. Braises B et tout son laboratoire en sont absents. Rapport : `VALIDATED_EXPANSION_BASELINE_REPORT.md` ; statut Braises : `Design/BRAISES_VALIDATION_STATUS.md` ; hypothèse de distance de calibration (environ 30 cm subjectivement plus favorable, non vérifiée) : `Design/GAZE_CALIBRATION_DISTANCE_HYPOTHESIS.md`.

Résultats réels, mesurés sur l'arbre du HEAD final juste avant le commit documentaire (le commit n'ajoute que de la documentation) :

| Étape | Résultat |
|---|---|
| `git diff --check` | propre |
| Parité Braises A avec `416feb9` | diff vide sur tous les fichiers de support ; bloc de définition d'A identique |
| Parité audio avec `aeafc28` | diff vide sur les fichiers audio, préférences et tests |
| Gaze Engine, synthétiseur, service audio, physique de référence, campagne | identiques à `937d549` ; seule `HapticCuePolicy` diffère, par les trois événements de braise ignorés (support d'A, identique à `416feb9`) |
| Absence de B | aucune référence à `BraisesPrototype.b`, « deux feux », `0-2`, relevé de laboratoire ; `BraisesPrototype.levels` = [`0-1`] ; un seul bouton de prototype dans les réglages |
| Debug simulateur | BUILD SUCCEEDED |
| Tests | 251 exécutés, 251 réussis, 0 échec, 0 ignoré |
| Release simulateur | BUILD SUCCEEDED |
| Audit | C1, C2, C8, C9, C10, C12 pass, 205 fichiers |
| Appareil | build Debug signé (`net.steve-s.iris`, `G4U9RG5GL7`), installation et lancement réussis sur l'iPhone 14 Pro, processus vivant après 8 s ; l'accès Braises A et les deux réglages audio sont ceux du code compilé, aucune validation humaine n'a été refaite |

## 19. Expansion intégrale — chapitres VII à XII (branche `feature/iris-full-expansion`, 13 septembre 2026)

Six nouveaux chapitres jouables dans la campagne normale, à la suite de VI, chacun avec sa mécanique, son identité visuelle et ses six niveaux : **VII jumelles** (l'une est l'iris de l'autre), **VIII souffles** (un souffle emporte par-dessus les voiles), **IX échos** (l'iris qui se ferme réveille les dormeuses), **X gouffres** (ce qu'il avale revient au départ), **XI braises** (la braise validée humainement, réglage gelé), **XII constellation** (la synthèse, jusqu'au dernier iris). Rapport : `Design/IRIS_FULL_EXPANSION_REPORT.md`.

Statut : **TECHNIQUEMENT VALIDÉ / À JOUER HUMAINEMENT**. Chapitres 1 à 6 / 34 niveaux : **INCHANGÉS**, protégés par une empreinte octet pour octet (`Tests/IrisTests/Fixtures/historical_campaign.txt`) et par les SHA-256 des sources gelées (chapitres historiques, Gaze Engine, filtre de regard, intégrateur physique).

| Étape | Résultat |
|---|---|
| Campagne | 12 chapitres, 70 niveaux, 210 éclats (les chiffres 66 / 198 figurant dans les versions taguées étaient une erreur d'addition) |
| Commits | infrastructure partagée puis un commit par chapitre (`19f2b1c`, `6d17731`, `ae0ef43`, `393a566`, `31ed0f7`, `d90f117`, `8282ffd`) |
| Tests | 298 exécutés, 298 réussis (simulateur iPhone 17 Pro) |
| Audit | C1, C2, C8, C9, C10, C12 pass |
| Debug simulateur / Release iOS signé | BUILD SUCCEEDED |
| `main`, `baseline/iris-expansion-validated`, `baseline-expansion-v1` | intacts |

## 20. Prototype oculomoteur — chapitre I, niveau 6 (branche `prototype/ch1-oculomotor-level6`, 14 septembre 2026)

Depuis le tag `iris-expansion-human-validated-v1` : un seul niveau optionnel ajouté au chapitre I, « le fil des balises » (centre, droite, gauche, centre, haut, bas, centre, puis droite/gauche ×2, haut/bas ×2, centre ; dwell 0,25 s ; zone 0,2 du petit côté). Instrumentation DEBUG seule (`OculomotorTrace`) : états VALID_INSIDE / VALID_OUTSIDE / INVALID tels que le mapper les fournit, sorties de viewport sans position inventée, transitions (acquisition, dwell, yaw/pitch de tête), indicateur de bord qui complète l'avertissement historique sans le remplacer. Détails et protocole du test humain : `Design/OCULOMOTOR_LEVEL6_PROTOTYPE.md`.

Gaze Engine : aucun calcul modifié ; deux fichiers `AR/` reçoivent un champ optionnel d'observation (pose de tête, géométrie oculaire) et leurs SHA-256 gelés sont mis à jour délibérément pour cette seule raison. Niveaux 1–5, chapitres II–XII, calibration, avertissement de décrochage : inchangés et testés. Statut : **PROTOTYPE, À TESTER HUMAINEMENT**.

## 21. Expansion oculomotrice — un niveau final par chapitre II à XII (branche `feature/iris-oculomotor-expansion`)

Depuis le tag `iris-ch1-oculomotor-human-validated-v1` (le niveau 1-6 « le fil des balises », validé humainement) : onze niveaux finaux optionnels, un par chapitre II à XII, ajoutés après les niveaux validés sans en renuméroter aucun. Chaque niveau s'ouvre sur une étape où le regard est l'interaction et où le motif oculaire découle d'une règle de jeu ; les lueurs du chapitre apparaissent ensuite. Rapport : `Design/OCULOMOTOR_EXPANSION_REPORT.md`.

| Niveau | Nom | Paradigme (interne) |
|---|---|---|
| 2-6 | le cœur de verre | fixation stable, distracteurs |
| 3-7 | le fil vivant | poursuite lisse |
| 4-7 | le miroir menteur | anti-saccade |
| 5-7 | les étoiles absentes | saccades guidées par la mémoire |
| 6-7 | le jardin caché | recherche visuelle, exploration |
| 7-7 | la danse croisée | saccades diagonales, amplitude variable |
| 8-7 | la lanterne du courant | poursuite prédictive |
| 9-7 | l'absence | désengagement (gap / overlap) |
| 10-7 | l'ancre | stabilisation du regard (tête) |
| 11-7 | d'abord les yeux | coordination œil-tête |
| 12-7 | l'orchestre du regard | synthèse |

Protection : les chapitres VII à XII et le niveau 1-6 ont désormais leur empreinte octet pour octet (`Tests/IrisTests/Fixtures/expansion_campaign.txt`) et leurs sources rejoignent les SHA-256 gelés, à côté de l'empreinte historique des chapitres I à VI. Gaze Engine, calibration, filtrage, seuils, décrochage : inchangés. Aucune allégation médicale n'est affichée ; les termes scientifiques restent dans le code et la documentation. Statut : **TECHNIQUEMENT VALIDÉ / À JOUER HUMAINEMENT**.

## 22. Correction de X·7 « l'ancre » (branche `prototype/x7-stabilisation-head-guidance`)

Depuis `e29cae7`, qui descend de `iris-expansion-human-validated-v1` et contient X·7 (au tag, le chapitre X n'a que six niveaux). Le niveau 10-7 devient deux boucles de tête guidées autour d'un point fixé des yeux, au centre d'une silhouette tracée depuis `x7_silhouette_reference.png` : ancrage de face, un cercle continu en partant vers la droite, retour face, poussière d'étoiles, puis le même cercle vers la gauche ; la lueur rejoint ensuite seule son iris. La progression suit le parcours de la tête (en avant, sans saut, à allure bornée) ; le regard doit seulement rester près du point et une perte de suivi ne fait que suspendre. La tête est lue dans le repère de l'écran grâce à la correspondance d'axes de la calibration, sans signe supposé. Capture DEBUG JSON Lines avec `--iris-capture`. Détails : `Design/X7_ANCRE_CORRECTION.md`. Gaze Engine, calibration, décrochage, audio, haptique et autres niveaux : inchangés. Statut : **TECHNIQUEMENT VALIDÉ / À JOUER HUMAINEMENT**.

**Option A (branche `fix/x7-head-only-circling`).** Le test sur iPhone 14 Pro a montré que le regard projeté dérive fortement quand la tête tourne, alors que le visage reste suivi. Le regard ne compte donc plus qu'avant chaque cercle (fixation d'ouverture, re-fixation) et après le dernier (fixation finale) ; pendant le départ, le cercle et le retour, seule la pose de tête compte, et elle est lue même sans projection du regard pour ce niveau. Point et anneau restent fixes, l'indicateur de regard DEBUG est masqué pendant les cercles, les erreurs `String(format:)` de la trace sont corrigées. Gaze Engine, ARKit, calibration et autres niveaux : inchangés.
