# Gaze Engine v2 — rapport

Date : 11 septembre 2026. Portée : pipeline de suivi du regard d'Iris (ARKit → regard brut → projection → calibration → lissage → coordonnées jeu). Le moteur de jeu (physique, validation 0,75 s, séquence, cascade, niveaux, progression, audio) n'a pas été modifié.

## Avant

Chaîne v1 (session du 10 septembre) :

1. `ARKitGazeTrackingService` : `viewMatrix(for: .portrait)` **codé en dur**, rayon `milieu des yeux → lookAtPoint`, intersection avec le plan `z = 0`, **hypothèse** `eyeOrigin.z < 0`.
2. `GazeProjector` : conversion mètres → points par `metersPerPoint` **estimé** (460 ppi pour les iPhone 3x, 326 ppi pour 2x, 264 ppi iPad), origine caméra **supposée** à `(largeur/2, 12 pt)` (`-40 pt` sur iPad), **miroir horizontal imposé** (`screenX = cx - x/mpp`), signe vertical imposé (`screenY = cy - y/mpp`).
3. Réglage manuel « Miroir horizontal » dans le menu pause pour corriger un éventuel mauvais signe.
4. `GazeFilter` (alpha 0,1, rejet des sauts) dans la session de jeu.
5. Aucune calibration : hypothèse `lookAtPoint ne nécessite aucune calibration`.

## Défauts trouvés

- **Signes X et Y déduits d'un raisonnement sur les conventions ARKit**, jamais mesurés. Le symptôme observé (« le suivi fonctionne mieux iPhone retourné ») correspond exactement à une inversion des deux axes (rotation de 180°) ou d'un axe plus un mauvais miroir : le code v1 fixait `screenX` avec un miroir et `screenY` avec un signe imposé.
- Orientation `.portrait` forcée dans la projection au lieu de l'orientation réelle de la `UIWindowScene`.
- Échelle physique et position de caméra approximées par famille d'appareil : erreur d'échelle et d'offset structurelle, différente pour chaque iPhone.
- Aucun contrôle du signal avant de jouer (visage, yeux, direction, stabilité, clignements).
- Aucune correction du biais individuel (offset, échelle, cisaillement).
- Un point de regard périmé continuait d'être utilisé quand le visage disparaissait (curseur figé).
- Le réglage « miroir » servait de rustine à une transformation incertaine.

## Après

Chaîne v2 :

1. **`ARKitGazeTrackingService`** : `viewMatrix(for: orientation)` avec l'orientation réelle fournie par `WindowSceneOrientationProvider` (`UIWindowScene.interfaceOrientation`, repli portrait si inconnue). Par frame : positions des deux yeux (`leftEyeTransform`, `rightEyeTransform`), `lookAtPoint`, tous transformés dans le repère caméra orienté ; intersection rayon/plan **sans hypothèse sur le côté du plan** (`GazeRay.planeHit`, paramètre `t > 0`) ; direction « droite de l'utilisateur » (œil gauche → œil droit, projetée dans le plan) ; direction « haut » issue de la **gravité** (`+y monde` exprimé dans le repère caméra, alignement gravité par défaut d'ARKit) ; repli « haut visage » (produit vectoriel droite × direction yeux→caméra) si l'appareil est à plat ; blend shapes `eyeBlinkLeft/Right` ; distance et écartement des yeux. Sortie : `RawGazeSample` métrique, **sans aucun signe, échelle ou position de caméra présumés**.
2. **`AxisResolver` / `AxisVote`** : les axes écran (droite, haut) sont **résolus à l'exécution** parmi ±x/±y du repère caméra à partir de la ligne des yeux et de la gravité, par vote majoritaire sur la fenêtre de diagnostic (confiance ≥ 0,8). Un iPhone retourné, un repère miroir ou pivoté de 90° donnent des mappings différents mais corrects. Le résultat est enregistré dans le profil (contexte d'orientation) et journalisé (y compris la main du repère, à titre diagnostique).
3. **`NominalDisplayGeometry`** : les anciennes estimations (ppi, caméra en haut au centre) subsistent uniquement comme *repère nominal* pour normaliser les mètres en coordonnées 0…1 et pour le point brut de diagnostic. Elles ne sont plus le chemin principal : la calibration apprend l'échelle et l'offset réels par-dessus.
4. **`GazeMapper`** : `RawGazeSample` → offsets (droite, haut) via `AxisMapping` → nominal normalisé → **affine 2D** (`AffineTransform2D`, 6 coefficients, moindres carrés par équations normales, élimination de Gauss avec pivot) → points, bornés à ±50 % du viewport.
5. **Diagnostic (`GazeReadinessEvaluator`)** : caméra TrueDepth, permission, session AR, visage détecté, suivi des yeux (distance 15–90 cm, écartement 4–10 cm), direction du regard (≥ 80 % des rayons atteignent l'écran), tête stable (RMS ≤ 2 cm), signal stable (RMS ≤ 10 % du nominal), clignements disponibles, axes résolus. Écran `Gaze Readiness` avec liste ✓ et « regard prêt pour la calibration » ; calibration lancée d'elle-même après 1 s de diagnostic vert.
6. **Calibration** : 9 points (grille 3 × 3, marges 15 % / 14 %), par point 300 ms de stabilisation puis 800 ms de collecte (prolongeable à 2,5 s si les échantillons manquent, une reprise du point), échantillons ignorés pendant les clignements (seuil 0,5, garde 120 ms) et non finis, **agrégation robuste** (médiane par axe, rejet > 3,5 MAD, moyenne tronquée, ≥ 12 échantillons valides). Temps réel (horodatage des frames), jamais un nombre de frames.
7. **Vérification** : 5 cibles (centre, gauche, droite, haut, bas) mesurées avec le regard **calibré** ; erreur = distance en points divisée par la petite dimension du viewport. **Critère** : moyenne ≤ 18 % et maximum ≤ 30 %. Échec → « La précision peut être améliorée » avec Recalibrer (et Continuer quand même après un premier essai, profil marqué non validé).
8. **`Regard prêt`** : point menthe vivant qui suit le regard calibré, bouton Continuer.
9. **Persistance** (`CalibrationProfile`, JSON dans `UserDefaults`) : version du modèle, 6 coefficients, mapping d'axes, orientation, viewport, repère nominal utilisé, date, erreurs de vérification, validité. **Invalidation** : version différente, viewport différent de plus de 1 %, orientation différente, profil non validé, âge > 30 jours, transformée non finie. Lancements suivants : diagnostic → vérification 5 points (revalidation) → jeu ; échec → calibration complète.
10. **Recalibration** : bouton « Recalibrer le regard » dans le menu pause ; le jeu est suspendu (progression conservée), le parcours diagnostic → calibration → vérification s'exécute, puis le jeu reprend avec le nouveau profil.
11. **Lissage** : inchangé (`GazeFilter`, alpha 0,1, rejet des sauts > 300 pt sauf 3 consécutifs), appliqué **après** calibration et conversion en points, uniquement pendant `playing`.
12. **Perte de visage** : après 0,3 s sans visage pendant la partie, phase `faceLost` (boucle arrêtée, crescendos coupés), reprise automatique au retour du visage. Aucun point périmé n'est réutilisé.
13. **Diagnostic visuel** : « Afficher les points de regard » (menu pause et écrans de calibration) : corail = brut nominal, menthe = calibré non lissé, ambre = curseur lissé du jeu. Le réglage « miroir » a été supprimé.
14. **Logs** (`os.Logger`, sous-systèmes `net.steve-s.iris`, catégories `gaze`, `calibration`, `game`) : orientation, viewport, états AR, axes résolus, résidus de calibration, erreurs de vérification, chargement de profil. Aucune donnée faciale.

## Fichiers modifiés ou créés

Nouveaux : `AR/Calibration/{DeviceAxis, AxisMapping, NominalDisplayGeometry, NormalizedCoordinates, AffineTransform2D, RobustAggregator, FixationSequence, CalibrationGrid, CalibrationResult, CalibrationProfile, CalibrationStore, BlinkDetector, GazeMapper, GazeReadiness}.swift`, `AR/Projection/GazeRay.swift`, `AR/Services/InterfaceOrientationProvider.swift`, `Features/GazeSetup/ViewModels/{GazeSetupIntent, GazeSetupPhase, GazeSetupNavigating, GazeSetupViewModel}.swift`, `Features/GazeSetup/Views/{GazeSetupView, GazeReadinessView, FixationTargetView, GazeVerdictView}.swift`, `Features/Game/ViewModels/GazeCalibrationStatus.swift`, tests `Tests/IrisTests/AR/{AxisMapping, AffineTransform2D, RobustAggregator, FixationSequence, NormalizedCoordinates, CalibrationProfile, GazeMapper, GazeReadinessEvaluator}Tests.swift`, `Tests/IrisTests/Presentation/GazeSetupViewModelTests.swift`.

Modifiés : `AR/Services/{GazeTrackingService, ARKitGazeTrackingService, SimulatedGazeTrackingService}.swift`, `Features/Game/ViewModels/{GameViewModel, GamePhase, GameSettingsStore, GameNavigating}.swift`, `Features/Game/Rendering/{GameSceneSnapshot, GameSceneRenderer}.swift`, `Features/Game/Views/GameOverlayView.swift`, `Features/Home/HomeView.swift`, `Navigation/{AppRoute, AppCoordinator, RootView}.swift`, `App/DI/AppContainer.swift`, `App/Platform/LaunchOptions.swift`, `Domain/ValueObjects/Vector2.swift` (Codable), tests `GameViewModelTests`, `AppCoordinatorTests`, `MockGameNavigating`.

Supprimés : `AR/Projection/GazeProjector.swift`, `AR/Projection/DisplayGeometry.swift`, `Tests/IrisTests/AR/GazeProjectorTests.swift`.

## Tests

Commande : `xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Debug test`

Résultat réel (11 septembre 2026) : `Test run with 185 tests in 27 suites passed after 0.544 seconds`, `** TEST SUCCEEDED **`.

| Exécutés | Réussis | Échoués | Ignorés |
|---|---|---|---|
| 185 | 185 | 0 | 0 |

Nouveaux tests (69) : `AxisMappingTests` (8), `AffineTransform2DTests` (10), `RobustAggregatorTests` (4), `FixationSequenceTests` (6), `NormalizedCoordinatesTests` (4), `CalibrationProfileTests` (5), `GazeMapperTests` (8), `GazeReadinessEvaluatorTests` (7), `GazeSetupViewModelTests` (10), et les cas ajoutés à `GameViewModelTests` (profil appliqué, visage perdu, recalibration, propriété du tracker partagé) et `AppCoordinatorTests` (setup premier lancement / revalidation, complétion, annulation, recalibration aller-retour). Tous les anciens tests du moteur (physique, validation 0,75 s, séquence, cascade, progression, niveaux, traces golden) passent sans modification.

## Builds

| Build | Commande | Résultat réel |
|---|---|---|
| Debug simulateur | `xcodebuild … -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Debug build` | `** BUILD SUCCEEDED **`, 0 warning de notre code |
| Release simulateur | `… -configuration Release build` | `** BUILD SUCCEEDED **` |
| Debug appareil arm64 | `… -destination 'generic/platform=iOS' -configuration Debug build CODE_SIGNING_ALLOWED=NO` | `** BUILD SUCCEEDED **` |
| Release appareil arm64 | `… -destination 'generic/platform=iOS' -configuration Release build CODE_SIGNING_ALLOWED=NO` | `** BUILD SUCCEEDED **` |
| Audit de couches | `python3 Tools/audit.py` | pass, 138 fichiers |

Un iPhone 14 Pro appairé est visible (`xcrun xctrace list devices`) ; aucune installation ni exécution n'a été réalisée dessus. `[compilation appareil réussie]` n'est pas `[calibration TrueDepth validée humainement]`.

## Ce qui est maintenant vérifié

`[vérifié automatiquement]`
- Intersection rayon / plan sans hypothèse de côté ; rejet des rayons qui s'éloignent et des valeurs non finies.
- Résolution des axes pour un repère standard, retourné de 180°, miroir, pivoté de 90°, gravité dégénérée (repli visage), directions dégénérées ou conflictuelles, vote majoritaire.
- Modèle affine : identité, offsets X/Y, échelles X/Y, combinaison avec cisaillement et inversion, miroir corrigé, récupération sur données bruitées, résidus, refus (< 3 points, non fini, colinéaire).
- Agrégation robuste (médiane, MAD, rejet d'outliers, non finis), détection des clignements avec garde.
- Protocole de fixation temps réel : stabilisation, collecte, prolongation, reprise, échec, complétion.
- Coordonnées normalisées (coins, centre, plusieurs viewports, erreur relative à la petite dimension).
- Persistance (mémoire et UserDefaults), compatibilité (version, validité, orientation, viewport ± 1 %, âge).
- Readiness : dix contrôles, états en attente / réussi / bloqué.
- Machine d'états du setup : readiness → calibration → vérification → prêt ; biais appris (30 pt, −20 pt) ; regard miroir corrigé (coefficient négatif) ; verdict insuffisant, recalibration, continuer quand même (profil non validé) ; revalidation sans calibration ; matériel / caméra ; clignements ignorés ; cycle de vie ; annulation.
- Jeu : profil appliqué au curseur, perte de visage après 0,3 s et reprise automatique, recalibration depuis la pause, propriété du tracker partagé pendant les transitions.
- Navigation : premier lancement → setup, profil stocké → revalidation, complétion → tutoriel puis jeu, annulation → accueil, recalibration aller-retour.

`[vérifié par compilation]`
- `ARKitGazeTrackingService` v2 (viewMatrix avec l'orientation réelle, yeux, lookAtPoint, gravité, blend shapes, logs), `WindowSceneOrientationProvider`, écrans du setup, overlay « visage perdu », menu pause avec recalibration. Exercés sur simulateur avec un regard scripté (captures des quatre étapes).

`[nécessite validation sur iPhone TrueDepth]`
- Direction réelle du regard (le mapping d'axes résolu, la main du repère journalisée).
- Précision réelle après calibration (erreurs de vérification observées, pertinence des seuils 18 % / 30 %).
- Confort du protocole (durées 0,3 s + 0,8 s par cible, taille des cibles, 9 + 5 points).
- Comportement en lumière réelle, port de lunettes, distance, clignements réels.

## Test humain à effectuer au retour de l'utilisateur

Ouvrir `Iris.xcodeproj`, choisir l'iPhone, Run (signature automatique). Puis :

1. **Sens normal** : tenir l'iPhone en portrait, caméra en haut, à 30–40 cm, sans le retourner.
2. **Diagnostic** : Commencer → autoriser la caméra → l'écran « diagnostic du regard » doit passer ses dix lignes au vert en fixant le point ; noter la ligne « Orientation du regard (droite = …, haut = …) ».
3. **Calibration** : suivre les 9 points des yeux sans bouger la tête (≈ 12 s), puis les 5 points de vérification (≈ 6 s).
4. **Centre** : sur « regard prêt », fixer le centre de l'écran : le point menthe doit s'y poser (à quelques millimètres près).
5. **Haut** : regarder le haut de l'écran : le point monte.
6. **Bas** : regarder le bas : le point descend.
7. **Gauche** : regarder le bord gauche : le point va à gauche.
8. **Droite** : regarder le bord droit : le point va à droite.
9. **Coins** : balayer les quatre coins : le point suit chaque coin sans inversion ni rotation.
10. **Partie réelle** : Continuer → tutoriel → Jouer ; regarder une sphère la repousse, regarder ailleurs la laisse rejoindre son cercle ; en pause, « Afficher les points de regard » montre corail (brut), menthe (calibré), ambre (curseur) ; « Recalibrer le regard » refait le parcours et revient au niveau en cours.

Si l'étape 5, 6, 7 ou 8 est inversée, relever la ligne « Orientation du regard » du diagnostic et les logs `subsystem:net.steve-s.iris category:gaze` (Console) : ils indiquent le mapping résolu et la main du repère, ce qui permettra de corriger sans conjecture.

