# Braises — statut de validation

Date : 12 septembre 2026. Document autoritatif et concis. L'historique complet est dans les branches d'archive `prototype/braises`, `prototype/braises-b-rework`, `prototype/braises-b-ux-audio`, `prototype/braises-b-final-diagnostic`.

## Braises A

Statut : `HUMAINEMENT VALIDÉ COMME PROTOTYPE`

Niveau `0-1` « braise », chapitre « P », DEBUG seulement, hors campagne. Référence comportementale : commit `416feb92d2ee27fb020917f4f85e0e1cb4b5b42b`, transplanté à l'identique dans la baseline (test `aIsFrozen`).

| Validation sur iPhone 14 Pro | |
|---|---|
| sommeil (froide, immobile, éteinte) | OUI |
| réveil par le regard | OUI |
| attraction naturelle vers l'iris une fois réveillée | OUI |
| répulsion par le regard | OUI |
| affolement après un regard prolongé | OUI |
| augmentation de la portée du regard après affolement | OUI |
| agrément initial | acceptable |
| profondeur de chapitre | non déterminée |

Réglages figés (`BraiseDefinition.prototype`) : rayon de charge 0,22 du petit côté, relâchement 0,28, chauffe 0,9 s, refroidissement 30 s, allumage 0,5, extinction 0,4, affolement 0,85, zone × 1,5 à chaleur pleine, chaleur initiale 0. Ne pas modifier sans un nouveau test humain.

## Braises B

Statut : `REJETÉ DANS SA FORME ACTUELLE`

Hypothèse testée (B1, B1.1, B1.2, B1.3) : une lueur ordinaire déjà posée et une braise à réveiller, le moment du réveil devant compter.

Motifs :

- conséquence du réveil tardif non fiable : simulée, elle est au mieux une sortie de 45 à 98 pt réparée automatiquement en 1 à 2,5 s ; certains gestes réalistes (curseur un peu au-dessus de la braise) n'en produisent aucune ;
- sur l'appareil, de nombreuses pertes de la lueur 1 sont survenues avant le réveil de la braise, longtemps après, ou pendant des dérives indépendantes : elles ne sont pas attribuables à B ;
- dernier essai propre sur iPhone, calibration acceptée (moyenne 13,2 %, maximum 23,6 %), scénario tardif avec affolement : `targetValidated(1)` à 4,00 s, `braiseLit(2)` à 7,96 s, `braiseFlared(2)` à 8,27 s, `targetValidated(2)` et `levelCompleted` à 16,10 s, **aucune perte** ;
- causalité non robuste : une règle « si trop tard alors la 1 est chassée » ne peut pas enseigner ce qui se produit parfois, parfois pas, selon la trajectoire du regard, la calibration et quelques dizaines de points ;
- rendre la conséquence robuste aurait exigé une pénalité, un piège, une règle spéciale, une modification du moteur partagé, une géométrie forcée ou une fixation artificiellement longue, tous refusés.

`AUCUNE NOUVELLE ITÉRATION B1.X N'EST AUTORISÉE.`

B est absent du runtime consolidé : ni niveau, ni lanceur, ni textes, ni instrumentation, ni tests.

## Ce qui reste inconnu

- La profondeur de Braises au-delà du geste d'A : aucune seconde couche de décision n'a été démontrée ; la taille d'un éventuel chapitre reste indéterminée, ni limitée ni acquise.
- L'interférence d'apprentissage : Braises n'a jamais été joué après les six chapitres qui apprennent à ne pas regarder les lueurs.
- L'endurance : deux niveaux au plus ont été joués d'affilée.
