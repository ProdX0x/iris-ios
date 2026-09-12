# Iris — rapport B1.3 : diagnostic final et clôture de Braises B

Date : 12 septembre 2026. Branche : `prototype/braises-b-final-diagnostic`, créée depuis `aeafc28cd0b38147c9d45db166724dc6d454629d`. Références intactes : `416feb9` (B1, A validé), `ea1cfae` (B1.1), `aeafc28` (B1.2, audio validé). Bundle `net.steve-s.iris`, équipe `G4U9RG5GL7`, `project.yml` source de vérité, inchangés.

# 1. OBSERVATION HUMAINE

`Le joueur comprend désormais la consigne de Braises B, mais ne perçoit aucune différence pratique entre la respecter et ne pas la respecter.`

Test sur iPhone 14 Pro de la version `aeafc28` : consigne comprise (réveiller la braise avant que la 1 n'atteigne son iris ; un réveil tardif est censé perturber la 1) ; en la respectant, le niveau se termine normalement ; en ne la respectant pas, il **semble** se dérouler et se terminer de la même manière : aucune perte perçue, aucune anomalie durable, aucune raison pratique de distinguer les deux comportements.

# 2. DIAGNOSTIC RÉEL

## Méthode

Reconstitution avec le moteur réel de l'application (mêmes seuils, même lissage du regard, mêmes forces, même attraction, mêmes règles de validation et de perte), sur l'écran de référence 393 × 852 pt, niveau B tel que testé. Le regard humain est modélisé de façon réaliste : un point de repos loin de tout (trois positions), puis un saut vers la braise avec une erreur de position (huit décalages de 0 à 70 pt, dans les quatre directions), en fixant soit l'endroit où la braise dort, soit la braise elle-même pendant sa fuite, jusqu'à ce qu'elle s'allume, plus 0 ou 0,25 s de réaction ; puis retour au repos. Scénario « tard » : le saut se fait après la validation de la 1. 96 scénarios tardifs, 3 scénarios « tôt ».

Rappel des grandeurs en jeu : zone d'attention 181 pt ; la 1 est **validée** dans un rayon de 16 pt de son iris et **perdue** au-delà de 36 pt ; vitesse maximale d'une lueur 2,2 pt par image, soit 132 pt/s, pour la fuite comme pour le retour ; la braise dort à 120 pt au-dessus de l'iris de la 1 ; elle s'allume après 0,45 s de regard dans son rayon de charge.

## Ce qui se passe dans le scénario tardif

| Grandeur mesurée | Résultat |
|---|---|
| Une perte de validation est-elle émise ? | oui dans 80 scénarios sur 96 (83 %) ; **non dans 16** |
| Sortie de l'iris (distance maximale au centre) | médiane 62 pt ; cas usuels 45 à 98 pt, soit 2 à 5 diamètres de lueur |
| Temps passé hors du rayon de présence (16 pt) | 0,4 à 1,2 s |
| Durée de la poussée (regard dans la zone de la 1) | 0,5 à 1,0 s : le temps que le curseur lissé arrive, que la braise s'allume, et que le regard reparte |
| Perte → retour → revalidation | médiane 1,67 s ; cas usuels 1,0 à 2,5 s, dont 0,75 s de présence obligatoire |
| Iris rouvert, son de perte, impulsion haptique | oui, pendant cette durée, quand la perte est émise |
| Retour de la 1 | **automatique et immédiat** : dès que le regard quitte la zone, l'attraction la ramène à 132 pt/s ; aucune action du joueur n'est nécessaire |
| Fin du niveau | 6,7 à 8,8 s au lieu de 5,1 à 5,4 s en réveillant tôt : 1,5 à 3 s de plus |

Les 16 scénarios **sans aucune perte** sont ceux où le curseur se pose 40 à 70 pt **au-dessus** de la braise (regard sur la moitié haute de son halo, ou erreur de calibration verticale, fréquente pour une cible à 150 pt du bord haut) : le curseur est alors à 172 – 188 pt de la 1, à la lisière ou hors de sa zone de 181 pt ; la 1 oscille de 2 à 36 pt, **sous le seuil de perte de 36 pt**, et rien n'est signalé au joueur.

Deux familles de scénarios extrêmes (fixation 70 pt sous la braise, soit à 50 pt de l'iris de la 1 ; ou regard collé à la braise pendant trois secondes de fuite) produisent 160 à 290 pt et 4,5 à 5,3 s ; elles reviennent à regarder la 1 elle-même ou à pourchasser la braise, pas à la réveiller. Elles ne décrivent pas le geste demandé.

## Ce que le joueur voit donc

Dans le cas usuel : pendant qu'il fixe la braise en haut de l'écran, la 1, 120 pt plus bas, glisse de 2 à 5 diamètres vers le bas pendant une demi-seconde, son iris se rouvre, un glissando et une impulsion douce jouent, puis elle remonte seule et son iris se referme moins de deux secondes plus tard. Le niveau se termine comme prévu, deux secondes plus tard. Dans une part plausible des cas réels, le curseur est un peu au-dessus de la braise et **rien ne se passe du tout**.

L'hypothèse du § 9 de la mission est confirmée : `lueur 1 validée → regard vers la braise → lueur repoussée → sortie brève → attraction immédiate → retour quasi instantané → revalidation`, **de sorte que le joueur ne voit pratiquement rien**, et parfois rien.

## Pourquoi aucune géométrie ne change cela

La conséquence est bornée par trois faits figés : le regard qui réveille est **bref** par construction (0,45 s de charge, la brièveté est l'identité validée de A) ; la fuite et le retour se font à la **même vitesse maximale** (132 pt/s), donc toute sortie se répare en un temps égal à celui de la poussée ; et le retour est **automatique** (attraction). Excursion ≈ 132 pt/s × durée de poussée (0,5 à 1 s) ≈ 60 à 130 pt au mieux ; retour ≈ 0,5 à 1 s ; présence 0,75 s : au total un incident de 1 à 2,5 s quelle que soit la position de la braise. Rapprocher la braise n'augmente pas la vitesse, déjà plafonnée ; déplacer la braise sur le côté de l'iris rendrait la perte plus robuste aux erreurs verticales de calibration, mais pas plus longue ni plus visible. Rendre l'incident durable exigerait que quelque chose **retienne** la 1 loin de son iris (un courant ou un voile placés là uniquement pour cela : une pénalité déguisée), un regard plus long ou plus proche (changer le réglage de A ou le moteur), ou une fixation posée presque sur la 1 (forcer le joueur). Les trois sont exclus.

# 3. POURQUOI LES TESTS PRÉCÉDENTS ONT PU CONCLURE À TORT

Les tests de B1.1 et B1.2 (`timingConflict`) prouvaient l'**existence** d'un événement de perte et une différence d'issue entre deux stratégies, dans le cas le plus favorable (curseur juste sous la braise, suivi de la braise, regard maintenu jusqu'à l'allumage). Ils ne mesuraient ni l'amplitude de la sortie (60 pt), ni sa durée (1,7 s), ni le caractère automatique du retour, ni la sensibilité à une erreur de position du regard vers le haut, qui supprime purement la perte. Le rapport B1.1 a présenté « une perte 0,4 à 0,7 s après la validation, iris rouvert, glissando, impulsion » comme une conséquence claire, en confondant un événement du moteur avec une expérience du joueur. La simulation était exacte ; son interprétation ne l'était pas. La perception humaine, seule autorité ici, l'a montré.

# 3 BIS. DÉCISION

`ISSUE B — BRAISES B REJETÉ DANS SA FORME ACTUELLE`

Justification : la conséquence prévue du « trop tard » existe physiquement mais est, par construction, une perte immédiatement annulée (critère d'insuffisance du § 14 de la mission), et elle disparaît entièrement pour une part plausible des regards réels. Aucune modification minimale de level design (géométrie, distance, position, marge, timing, placement des iris) ne peut la rendre durable : la physique plafonne l'excursion et répare seule la sortie. La rendre significative supposerait un artifice (élément-piège, pénalité, changement de A ou du moteur, regard forcé sur la 1).

# 4. MODIFICATIONS

`AUCUNE NOUVELLE COMPLICATION N'A ÉTÉ AJOUTÉE POUR SAUVER B.`

Aucun changement de gameplay, de géométrie, de texte de niveau, de physique ni de réglage. Deux ajouts de diagnostic, tous deux en dehors du jeu :

- un **relevé de laboratoire** DEBUG, affiché en bas de l'écran pendant une partie des seuls niveaux expérimentaux (chapitre 0) : état de chaque lueur (en route, présence, validée), distance à son iris, distance au regard, état et chaleur de la braise, seuils de présence et de perte, nombre de pertes, temps, dernier événement horodaté ; les mêmes événements sont journalisés (`os_log`, catégorie `game`). Il permet à qui rejoue B sur l'iPhone de lire, par exemple, « perdue à 5,2 s, revalidée à 6,8 s ». Il est facilement supprimable (deux blocs `#if DEBUG`) et n'existe pas en Release ;
- un **test de caractérisation** (`lateWakeConsequenceIsTransient`) qui fixe le constat dans le dépôt : dans le cas nominal, une perte suivie d'une revalidation automatique en moins de 2,6 s et une excursion inférieure à 110 pt ; avec le curseur 60 pt au-dessus de la braise, aucune perte et une oscillation sous 36 pt.

Le rejet ne fait pas l'objet d'un « B1.4 » : cette hypothèse est close. Il ne dit rien de la taille ni de l'existence d'un futur chapitre Braises ; il dit seulement que **la profondeur testée par B, dans cette forme, n'existe pas pour le joueur**. Braises A, ses apprentissages, le sommeil, le réveil, l'affolement et la portée accrue restent acquis.

# 5. PROTECTIONS

- Braises A : intact (diff vide contre `416feb9` ; tests `aIsFrozen`, `flareReach`, `discovery`, `flare`).
- Réglage de braise, `BraiseState`, `GameSession`, `TargetPhysics` : identiques à `416feb9`.
- Audio validé (`aeafc28`) : préférences, routage, migration, synthétiseur, haptique intacts (diff vide sur `Audio/`, `Haptics/`, `GameSettingsStore`).
- Gaze Engine : intact (diff vide sur `AR/`, `Features/GazeSetup/`).
- Campagne : six chapitres, 34 niveaux, mêmes identifiants, même ordre (test `officialCampaignUntouched`).
- Aucun StoreKit, réseau ni télémétrie.

# 6. VÉRIFICATIONS

Voir `README.md` § 17.3 pour les résultats réels des builds, des tests, de l'audit et de l'appareil sur cette branche.
