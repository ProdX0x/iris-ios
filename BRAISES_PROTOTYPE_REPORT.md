# Iris — rapport du prototype B1 « Braises »

> **Note B1.1 (12 septembre 2026).** Le test humain de cette version (`416feb9`) a validé A et n'a pas perçu de différence dans B. Le diagnostic et la correction de B sont dans `BRAISES_B_REWORK_REPORT.md` ; la section « Prototype B » ci-dessous décrit la version `416feb9`, conservée telle quelle comme trace.

Date : 12 septembre 2026. Branche : `prototype/braises`, créée depuis `937d549` (conception de phase A). Bundle `net.steve-s.iris`, équipe `G4U9RG5GL7`, `project.yml` source de vérité, inchangés.
Nature : expérience contrôlée, hors campagne. Deux niveaux, pas davantage. Aucune décision de chapitre.

## Avant

- Six chapitres officiels, 34 niveaux, identifiants `1-1` à `6-6`, inchangés (vérifié par test).
- Concept Braises de la phase A (`Design/GAME_EXPANSION_CONCEPTS.md`, C1) : une lueur froide que le regard nourrit et fait fuir ; regarder brièvement, relâcher, recommencer.

## Prototype A — « braise » (`0-1`)

**Ce qu'il teste.** Le geste seul : comprend-on, sans texte long, qu'il faut regarder la braise puis cesser de la regarder ?

**Mécanique retenue.** Une braise **dort** : froide, sombre, immobile (ni dérive vers l'iris, ni bruit). Le regard posé sur elle la réchauffe ; quand la chaleur atteint 0,5 elle **s'allume** : elle se réveille, fuit le regard comme n'importe quelle lueur, dérive vers son iris, et l'iris l'accepte. Laissée tranquille, elle refroidit lentement et se rendort sous 0,4. Si le regard insiste au-delà de 0,85, elle **s'affole** : sa zone d'attention grandit (jusqu'à × 1,5), elle fuit de plus loin, jusqu'à ce qu'elle refroidisse un peu. Elle ne perd jamais sa chaleur ni sa place pour avoir été regardée.

Le sommeil a été ajouté au concept de phase A pour la lisibilité : une braise froide qui dériverait seule vers un iris fermé aurait produit une scène ambiguë (« elle est arrivée, pourquoi rien ne se passe ? ») ; une braise qui ne bouge pas tant qu'on ne la regarde pas rend la cause et l'effet immédiats.

**Paramètres** (`BraiseDefinition.prototype`) :

| Paramètre | Valeur | Pourquoi |
|---|---|---|
| rayon de charge | 0,22 du petit côté (86 pt) | au-dessus des 71 pt d'erreur moyenne d'une calibration acceptée de justesse (`PLAYER_COMFORT_CONSTRAINTS.md` § 2) |
| rayon de relâchement | 0,28 (110 pt) | hystérésis contre un regard qui tremble |
| chauffe | 0,9 s de 0 à 1 | un regard de 0,5 s suffit à allumer |
| refroidissement | 30 s de 1 à 0 | le trajet vers l'iris et la présence de 0,75 s tiennent largement dans la marge |
| allumage / extinction | 0,5 / 0,4 | hystérésis |
| affolement | 0,85, zone × 1,5 à 1,0 | atteint après 0,77 s de regard continu, dissipé en 4,5 s |
| zone d'attention du niveau | 0,46 | comme le chapitre II |

**Géométrie.** Braise à (0,50 ; 0,74), iris à (0,50 ; 0,32) : 357 pt à parcourir, iris loin des bords ; le regard qui la réveille est au centre bas de l'écran.

**Quantité d'explication.** Une phrase d'intro sur la carte du niveau (« Elle dort, froide. Votre regard la réveille. ») et quatre consignes contextuelles d'une ligne : « Elle est froide. Regardez-la. » au départ ; « Elle s'allume et fuit. Laissez-la venir. » à l'allumage ; « Trop regardée, elle s'affole. » au premier affolement ; « Un regard bref suffit. Puis regardez ailleurs. » après 30 s. Aucune page de règles. Jugement honnête : la consigne de départ est probablement **nécessaire** pour un joueur formé par Iris à ne pas regarder les lueurs, car une braise endormie ne fait rien tant qu'on l'évite ; c'est un signal de risque modéré, à confirmer par le test. Les autres consignes confirment ce que la lumière et le mouvement montrent déjà.

## Prototype B — « deux feux » (`0-2`)

**Ce qu'il ajoute.** Une seule augmentation : une lueur normale (1) à poser d'abord, dans l'ordre, puis la braise (2) à réveiller. L'iris de la braise est à 128 pt de l'iris 1, à l'intérieur de la zone d'attention d'un regard posé sur elle : réveiller la braise à son iris chasse la lueur 1 et lui fait perdre sa place. Son départ, en bas à droite, est hors de portée. Le joueur doit donc choisir **d'où** et **quand** réveiller : tôt et de loin, assez pour qu'elle arrive encore allumée, pas trop pour qu'elle ne s'affole pas.

**Pourquoi il est différent de A.** A demande un geste ; B demande une décision de position et de dosage, en présence d'un acquis à protéger, avec des règles que le joueur connaît déjà (ordre, garde).

**Quantité d'explication.** Intro d'une phrase (« La 1 se pose. Réveillez la 2 sans chasser la 1. »), trois consignes : « D'abord la 1. La 2 dort. » ; « Trop regardée, elle s'affole. » ; à la première perte, « La 1 a perdu sa place : réveillez la 2 de plus loin. »

## Lisibilité

- **Un regard bref est bénéfique** : la braise passe du sombre à l'ambre puis au nacré à mesure qu'elle chauffe ; à l'allumage son iris s'ouvre (lames colorées au lieu de grises, comme pour les veilleuses et le regard hors écran), un battement doux joue (réutilisation du son de veilleuse), la consigne le dit une fois, et surtout **elle se met en mouvement** vers son iris.
- **Un regard excessif a un autre effet** : au-delà de 0,85, cœur blanc, halo qui pulse, anneau chaud, et un comportement visible : elle fuit un regard pourtant lointain. L'affolement se dissipe seul en quelques secondes.
- **« Puni pour avoir obéi »** : traité par trois choix. Regarder ne retire jamais rien (pas de brûlure, pas de retour au froid, pas de perte de validation) ; la fuite est la même loi que partout dans Iris, annoncée par l'intro ; l'affolement ne coûte que de l'espace et du temps, jamais l'acquis. Reste le risque que la fuite déclenchée par le regard soit **ressentie** comme une punition : c'est précisément ce que le test humain doit dire.
- **Sans texte** : le prototype reste jouable sans aucune consigne pour qui sait qu'il faut regarder ; pour un joueur formé à éviter, la première consigne est probablement nécessaire (voir A).

## Architecture

**Ajoutés** : `Domain/Campaign/BraiseDefinition.swift` (réglages), `Domain/Campaign/BraisesPrototype.swift` (deux niveaux, chapitre 0 « P », `#if DEBUG`), `GameEngine/Environment/BraiseState.swift` (chaleur, hystérésis, affolement, `BehaviourScale`), `Tests/IrisTests/GameEngine/BraiseStateTests.swift`, `Tests/IrisTests/Campaign/BraisesPrototypeTests.swift`, `Design/BRAISES_PROTOTYPE_TEST.md`, ce rapport.

**Modifiés** : `LueurDefinition` (champ optionnel `braise`, nil partout dans la campagne), `LevelDefinition` (`isExperimental`, `hasBraises`), `ChapterDefinition` (numéral « P » pour le chapitre 0), `LevelHint` (deux déclencheurs), `GameEvent` (trois événements), `LevelEnvironment` et `LevelResolver` (braises par index), `TargetPhysics` (paramètre `behaviour`, neutre par défaut), `GameSession` (mise à jour des braises, iris fermé pour une braise endormie), `HintTracker`, `AudioCuePolicy` (allumage → battement), `HapticCuePolicy` (rien), `GameSceneSnapshot` et `GameSceneRenderer` (dessin de braise), `LevelResult` et `GameViewModel` (flux de résultat hors campagne, chapitre P), `AppCoordinator` (`playPrototype` en DEBUG, aucun enregistrement des niveaux expérimentaux), `LaunchOptions` (identifiants `0-1`, `0-2` en DEBUG), `SettingsView` (carte *prototypes (debug)*), `CampaignBot` (politique de nourrissage du joueur simulé), README § 17, `Docs/domain-model.md` (R-32 expérimentale), `Docs/file-map.md`, projet régénéré.

**Isolation.** La mécanique tient dans `BraiseState` et deux points d'accroche de la session ; l'intégrateur reçoit un `BehaviourScale` neutre (× 1,0, exact) pour toute lueur ordinaire, et les traces golden du moteur JavaScript restent vertes. Les données du prototype et son lanceur n'existent qu'en DEBUG. Supprimer le prototype revient à retirer les fichiers ajoutés et le champ `braise` ; aucun niveau officiel n'en dépend.

## Protection de l'existant

- Campagne officielle non modifiée : test `officialCampaignUntouched` (six chapitres, les 34 identifiants dans l'ordre, aucune braise, aucun chapitre 0, environnement résolu sans braise).
- Progression : un niveau expérimental n'est jamais enregistré ni compté (test `coordinatorIsolation`) ; le chemin de jeu officiel ignore un niveau hors campagne.
- Gaze Engine non modifié : aucun fichier de `AR/` ni de `Features/GazeSetup/` touché.
- Physique officielle : une extension isolée et documentée de l'intégrateur (`behaviour`), sans effet sur les lueurs ordinaires ; rayon des veilleuses (55 pt) laissé tel quel.
- StoreKit absent. Aucune télémétrie, aucun réseau.

## Tests, builds, appareil

| Étape | Résultat réel |
|---|---|
| `git diff --check` | propre |
| Debug simulateur | BUILD SUCCEEDED |
| Tests | 246 exécutés, 246 réussis, 0 échec, 0 ignoré (14 tests ajoutés) |
| Release simulateur | BUILD SUCCEEDED |
| Audit | C1, C2, C8, C9, C10, C12 pass, 205 fichiers |
| Debug appareil signé | BUILD SUCCEEDED, `net.steve-s.iris`, `G4U9RG5GL7` : `[build appareil réussi]` |
| Installation, lancement | non faits : l'iPhone 14 Pro était **déconnecté** (`devicectl` : unavailable) au moment de l'installation ; à refaire depuis Xcode ou `devicectl` une fois l'iPhone branché |

Mesures du joueur simulé (regard bruité ± 24 pt, 3 graines) : A terminé en 4,6 s avec 1,7 intrusion ; B en 8,8 s avec 4,3 intrusions ; aucune perte. Le joueur qui ne nourrit jamais échoue sur les deux ; un regard hors écran aussi. Références d'éclats dérivées par la formule de la campagne : A 14 s / 4 intrusions, B 22 s / 7.

## Ce que l'automatisation peut conclure

La logique fonctionne et est déterministe ; les deux niveaux sont faisables et exigent le geste ; rien n'a régressé (traces golden, 232 tests antérieurs, campagne et progression isolées) ; les builds et la signature sont sains.

## Ce qu'elle ne peut pas conclure

Le plaisir ; la lisibilité humaine réelle du geste et de l'affolement ; la fatigue réelle ; la valeur de Braises comme chapitre complet ; l'endurance sur cinq ou six niveaux ; la qualité dans le flux réel d'une campagne ; l'absence d'interférence d'apprentissage.

## Interférence d'apprentissage

Braises inverse ponctuellement la règle « ne regardez pas la cible ». Deux niveaux isolés ne disent pas si un joueur qui a traversé six chapitres d'évitement comprendra qu'une règle nouvelle lui est proposée, ni si ses automatismes créeront frustration ou retournement intéressant.

`NON RÉSOLUE — nécessite un futur test contextuel si Braises devient PROMETTEUR.`

## Verdict possible après test humain

REJETER · À RETRAVAILLER · PROMETTEUR. Le statut « VALIDÉ POUR CHAPITRE ÉTENDU » ne peut pas être attribué à partir de ce prototype.

`BRAISES PRÊT POUR TEST HUMAIN SUR IPHONE — AUCUNE DÉCISION DE CHAPITRE N'A ÉTÉ PRISE.`
