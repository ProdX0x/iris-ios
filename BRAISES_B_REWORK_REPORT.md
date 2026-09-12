# Iris — rapport B1.1 : diagnostic et correction de « Braises B »

Date : 12 septembre 2026. Branche : `prototype/braises-b-rework`, créée depuis `416feb92d2ee27fb020917f4f85e0e1cb4b5b42b` (version testée humainement, conservée intacte). Bundle `net.steve-s.iris`, équipe `G4U9RG5GL7`, `project.yml` source de vérité, inchangés.

# 1. OBSERVATION HUMAINE

Test sur iPhone 14 Pro de la version `416feb9`.

**Braises A** : réveil perçu ; attraction naturelle vers l'iris ; affolement perçu ; influence du regard à plus grande distance après affolement ; comportement global conforme à l'attendu. **A est figé.**

**Braises B** : différence stratégique avec A non perçue ; implication sur l'autre sphère lors du réveil non perçue ; nécessité de choisir quand réveiller la braise non établie. Le joueur a volontairement cherché la situation de conflit et ne l'a pas trouvée.

# 2. DIAGNOSTIC TECHNIQUE

Reconstitution tick par tick avec le moteur réel (écran 393 × 852 pt, regard lissé comme en jeu, réveil « jusqu'à allumage » comme le fait un humain), sur la géométrie de `416feb9` : lueur 1 de (0,22 ; 0,86) vers l'iris central (0,50 ; 0,50) ; braise endormie en (0,76 ; 0,86), iris en (0,62 ; 0,36) ; zone d'attention 0,46 = 181 pt.

| Stratégie | Résultat sur la lueur 1 | Pertes | Durée |
|---|---|---|---|
| Attendre que la 1 soit posée (3,3 s), puis réveiller la braise | trouble maximal 0,32 pendant quelques images, distance minimale regard → lueur 121 – 125 pt, la lueur reste dans sa tolérance de 36 pt | 0 | 8,2 – 8,8 s |
| Réveiller la braise d'abord (t = 0) | trouble 0,00 – 0,01, distance minimale 178 – 181 pt | 0 | 4,9 – 5,5 s |
| Réveiller puis suivre la braise du regard pendant 6 s | la 1, encore en route, est déviée (trouble 0,14) et retardée de 5 s ; jamais délogée | 0 | 8,9 s |

Causes, dans l'ordre d'importance :

1. **Le regard qui réveille ne touche rien.** La braise dort à 315 pt de l'iris 1 et à 235 pt du départ de la 1 : hors de toute zone d'attention. Le seul regard que le niveau exige est sans conséquence.
2. **La braise réveillée est autonome.** Depuis le sommeil ajouté en B1 (allumée = elle dérive et son iris l'accepte), aucun second regard n'est jamais nécessaire. La géométrie « iris de la braise à 128 pt de l'iris 1, dangereuse à nourrir » n'est jamais exercée : personne ne nourrit une braise à son iris puisqu'elle y arrive allumée.
3. **Rien n'est en cours au moment du réveil.** La 1 se pose à 3,3 s ; la braise met 3 à 4 s à rejoindre son iris ; le niveau se termine en 5 à 9 s. Aux deux moments naturels du réveil (tout de suite, ou après la 1), rien n'est à protéger.
4. **Le seul trouble mesurable est un balayage.** Quand le curseur lissé descend du repos (haut à droite) vers la braise, il passe à 129 pt de l'iris 1 pendant quelques images : trouble 0,32, aucune perte. C'est la seule « implication », et elle est imperceptible.
5. **Même la curiosité ne coûte rien.** Suivre la braise pendant son vol dévie la 1 pendant qu'elle est encore en route (pas de perte, un retard) ; l'attention du joueur est alors sur la braise.

Conclusion : B ne posait aucune décision. Attendre ou réveiller tout de suite donnait le même résultat, sans risque ni raison de préférer un moment. B était A avec une lueur ordinaire en plus.

# 3. EST-CE QUE LE RAPPORT 416feb9 ÉTAIT EXACT ?

**Techniquement vrai mais pratiquement neutralisé**, et sur un point trompeur.

- Vrai : un regard posé sur l'iris de la braise est à 128 pt de l'iris 1 et y pousserait la lueur 1 (force 0,7 pt par image, perte en 0,3 s). Le test `guardPressure` le vérifiait géométriquement.
- Neutralisé : ce regard n'est jamais requis, et rien dans le niveau n'y conduit. Le rapport supposait une braise arrivant froide qu'il faudrait nourrir à son iris ; le sommeil de B1 a supprimé ce cas. Le rapport n'a pas été relu après cet ajout.
- Trompeur : le rapport affirmait que « feeding at the start is safe » comme si un autre choix existait ; en réalité c'était le seul choix, donc pas un choix.

Le test automatisé de `416feb9` prouvait une géométrie, pas une décision. La perception humaine était juste.

# 3 BIS. DÉCISION APRÈS DIAGNOSTIC

`ISSUE 1 — B EST RÉPARABLE NATURELLEMENT`

Justification : le regard qui réveille une braise est un regard comme les autres, avec une zone de 181 pt. Il suffit que la braise dorme **à l'intérieur de cette zone autour de l'iris de la lueur 1** pour que le moment du réveil devienne une décision : avant que la 1 ne s'y pose, le regard ne dérange rien ; après, il la chasse. Aucune règle nouvelle, aucun paramètre du moteur, aucune modification de la braise : uniquement des positions. La correction a été vérifiée par simulation avant d'être retenue (§ 6), avec deux points de repos du regard différents, pour s'assurer que l'effet ne dépend pas d'où vient le curseur.

# 4. CORRECTION APPLIQUÉE

**Ce qui a changé** (`Domain/Campaign/BraisesPrototype.swift`, niveau `0-2` seulement) :

| | Avant (416feb9) | Après (B1.1) |
|---|---|---|
| Lueur 1 | départ (0,22 ; 0,86), iris (0,50 ; 0,50) | départ (0,50 ; 0,86), iris (0,50 ; 0,32) : elle monte tout droit |
| Braise | dort en (0,76 ; 0,86), iris (0,62 ; 0,36) | dort en (0,50 ; 0,18), **120 pt au-dessus de l'iris 1** ; iris en (0,20 ; 0,20), à 156 pt de l'iris 1, atteint par attraction seule |
| Intro | « La 1 se pose. Réveillez la 2 sans chasser la 1. » | « La 1 monte au centre. La braise dort juste au-dessus. » |
| Consignes | « D'abord la 1. La 2 dort. » ; affolement ; « La 1 a perdu sa place : réveillez la 2 de plus loin. » | « La braise dort au-dessus de l'iris de la 1. » ; affolement ; à la première perte : « Votre regard sur la braise a chassé la 1. Réveillez-la avant. » |
| Références | 22 s / 7 intrusions | 15 s / 4 intrusions (formule de la campagne sur le joueur simulé qui réveille d'abord) |

Le joueur simulé de vérification réveille désormais toute braise endormie sans attendre son tour (réveiller ne valide rien ; l'ordre reste tenu par le moteur). Sur A, une seule lueur, c'est identique.

**Pourquoi A n'a pas changé** : A n'est pas touché par ce fichier ailleurs que dans la définition de B ; un test compare A, champ par champ, aux valeurs de `416feb9` (§ 5).

**Pourquoi le moteur Braises n'a pas changé** : `BraiseDefinition.prototype`, `BraiseState`, `BehaviourScale`, `GameSession` et `TargetPhysics` sont identiques à `416feb9` ; B utilise exactement le réglage de braise validé dans A, vérifié par test.

**Pourquoi la correction est minimale** : quatre points, une phrase d'intro, deux consignes, deux références. Rien d'autre.

**Point de vigilance** : le sens de la fuite au réveil dépend de la direction d'où arrive le curseur lissé (comportement d'A, figé). La braise dort près du bord haut pour que, quelle que soit l'approche (bas, côtés), sa fuite la plaque le long du bord et l'éloigne de l'iris 1 ; vérifié avec un repos en bas à droite et en haut à droite. Un curseur qui arriverait du haut à gauche (position de repos improbable, l'iris de la braise y est) la pousserait vers le centre : risque résiduel documenté, non traité.

# 5. BRAISES A

`IDENTIQUE À LA VERSION HUMAINEMENT VALIDÉE 416feb9`

Vérifications :

- `git diff 416feb9 -- Domain/Campaign/BraisesPrototype.swift` ne touche que le bloc `static let b` ;
- `git diff 416feb9 -- Domain/Campaign/BraiseDefinition.swift GameEngine/Environment/BraiseState.swift GameEngine/Session/GameSession.swift GameEngine/Physics/TargetPhysics.swift` est vide ;
- test `aIsFrozen` : identifiant, titre, principe, zone, forces, bruit, maintien, lueur (départ, iris, tempérament, mouvement, voie), les neuf paramètres de braise, les quatre consignes (déclencheurs et textes), les références, et le rayon de charge résolu (86,46 pt) ;
- test `flareReach` : comportement humainement observé (une braise affolée est repoussée par un regard à 230 pt qu'une braise calme ignore) ;
- tests `discovery` et `flare` (B1) inchangés et verts.

# 6. BRAISES B

**Situation.** La lueur 1 part du bas et monte vers son iris au centre-haut de l'écran (4,3 s de trajet et de présence). La braise dort 120 pt au-dessus de cet iris. Le regard qui réveille la braise est, par construction, un regard posé dans la zone de la lueur 1 lorsqu'elle est à son iris.

**Choix attendu.** Réveiller la braise **avant** que la 1 ne se pose, ou l'attendre par habitude (« d'abord la 1 ») et payer.

**Moment prudent** (réveil dès le départ, mesuré avec le regard lissé, deux points de repos) : la braise s'allume à 0,6 – 0,9 s, fuit vers le bord haut puis glisse vers son iris ; la 1 monte, au plus effleurée par le passage du curseur (trouble ≤ 0,36 sans perte), se pose à 4,4 – 4,6 s ; la braise, qui attendait allumée, se valide 0,75 s après. Fin en 5,1 – 5,4 s, aucune perte.

**Conflit provoqué** (attendre la validation de la 1, puis réveiller) : dès que le regard se pose sur la braise, la lueur 1, à 120 pt, est repoussée (trouble 0,83 – 0,86, distance minimale 28 – 33 pt) et **perd sa place 0,4 à 0,7 s après sa validation** : iris rouvert, lueur éteinte, glissando, impulsion haptique. Le regard parti, elle revient et se repose ; la braise, réveillée, attend à son iris. Fin en 6,9 – 8,0 s, une perte, éclat *serein* perdu.

Preuve d'existence physique du conflit : test `timingConflict` (deux stratégies, deux points de repos, événements horodatés, trouble mesuré, durées comparées). Ce test démontre l'existence et la reproductibilité de la différence ; il ne démontre ni qu'un humain la perçoit, ni qu'elle lui plaît.

**Le choix n'est pas factice.** Attendre coûte une perte visible ; réveiller d'abord n'est pas gratuit non plus : le regard qui monte vers la braise frôle la 1 en route (trouble jusqu'à 0,36), et un regard trop long affole la braise (règle d'A). Il n'existe pas d'esquive spatiale confortable : regarder la braise par le côté laisse le regard à 134 pt de l'iris 1, encore dans la zone ; la regarder par-dessus demanderait un regard dans la marge haute, hors des positions requises admises. Le levier est le moment.

# 7. DIFFÉRENCE A / B

`Dans A, le joueur décide : comment regarder la braise, assez pour l'allumer, pas assez pour l'affoler, puis où poser les yeux pour la laisser venir.`

`Dans B, le joueur décide en plus : quand la réveiller, parce que le regard qui la réveille est aussi un regard sur l'iris de la lueur 1 : avant qu'elle ne s'y pose, ou après en la chassant.`

# 8. CE QUE L'AUTOMATISATION CONCLUT

L'ancien B ne créait aucune décision (aucune stratégie ne produit de perte, écart de durée dû au seul enchaînement) ; une correction minimale de level design existe ; la physique du conflit existe et se reproduit ; deux stratégies produisent des trajectoires et des issues différentes ; A est inchangé ; le noyau Braises est inchangé ; la campagne officielle est inchangée ; le code compile ; les tests passent.

# 9. CE QU'ELLE NE CONCLUT PAS

Que le joueur percevra spontanément le conflit ; qu'il comprendra B ; que B est plus intéressant qu'A ; que B est agréable ; que Braises mérite un chapitre ; que Braises tient sur plusieurs niveaux ; que l'interférence d'apprentissage en campagne est résolue.

**LE TEST HUMAIN RESTE OBLIGATOIRE.**

# 10. INTERFÉRENCE D'APPRENTISSAGE

`NON RÉSOLUE PAR B1.1` : B n'est toujours pas testé à sa position réelle dans une campagne où le joueur a appris pendant plusieurs chapitres à éviter le regard direct.

# 11. VÉRIFICATIONS

Voir `README.md` § 17 (résultats réels des builds, des tests, de l'audit et de l'appareil pour B1.1).
