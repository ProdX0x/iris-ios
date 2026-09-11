# Iris — game design

Référence du produit complet. Le noyau mécanique historique (règles R-01 à R-15 de `Docs/domain-model.md`) est conservé. Ce document décrit ce qui s'y ajoute et pourquoi.

## 1. Boucle de jeu

```
Lire le niveau (intro) → choisir où poser les yeux → observer la réaction des lueurs
→ corriger son regard → maintenir la présence 0,75 s → validation (carillon)
→ protéger les validations acquises → dernier iris fermé → éclats → niveau suivant
```

Une partie dure de 15 s à 2 min. Un chapitre dure de 10 à 25 min.

## 2. Vocabulaire du jeu

| Terme | Sens |
|---|---|
| **Lueur** | Objet mobile (ex-sphère). Elle fuit le regard et rejoint son iris quand on la laisse. |
| **Iris** | Point d'arrivée, dessiné comme un diaphragme qui se ferme pendant la validation. |
| **Zone d'attention** | Rayon autour du regard où les lueurs sont repoussées. Invisible, ressenti par la fuite des lueurs. |
| **Courant** | Bande où les lueurs sont entraînées dans une direction. |
| **Voile** | Paroi que les lueurs ne traversent pas. |
| **Veilleuse** | Flamme qui s'éteint si on ne la regarde pas. Tant qu'elle est éteinte, les iris qu'elle éclaire se ferment. |
| **Iris mouvant** | Iris qui se déplace lentement. |
| **Éclats** | Marques de maîtrise : *atteint*, *fluide*, *serein*. |

## 3. Règles

### 3.1 Règles conservées du prototype

- R-01 attraction, R-02 répulsion proportionnelle, R-03 bruit, R-04 plafond, R-05 friction, R-06 intégration, R-07 rebonds amortis.
- R-08 présence continue 0,75 s. R-09 ordre 1 → 2 → 3. R-10 tolérance d'une lueur validée. R-11 cascade.
- R-13 lissage du regard (alpha 0,1). R-14 équivalence temporelle.

Le moteur n'est pas réécrit. Les traces golden du prototype restent des tests.

### 3.2 Règles modifiées

| Règle | Prototype | Iris | Raison |
|---|---|---|---|
| Unités | Pixels CSS, constantes absolues | Constantes à l'échelle de l'écran : `échelle = petit côté / 393 pt` | Même jeu sur iPhone mini, Pro Max et iPad |
| Zone d'attention | 220/190/150 × 1,6 pt | Fraction du petit côté, 0,40 à 0,50 selon le niveau | 352 pt couvrait l'écran ; la zone doit laisser un espace de jeu |
| Force de répulsion | `k` fixe par bande | Force maximale choisie (pt/frame), `k = force / zone` | Réglage lisible : la force au contact ne dépend pas de la taille de la zone |
| Positions | Tirées par graine | Placées à la main, en coordonnées normalisées | Le niveau porte une intention |
| Ordre | Toujours séquentiel à partir de 2 lueurs | Séquentiel ou libre selon le niveau | L'ordre est une contrainte que l'on introduit |
| Fin de niveau | Enchaînement immédiat | Écran de résultat avec éclats | Respiration et rejouabilité |

### 3.3 Règles nouvelles

| ID | Règle | Pourquoi elle sert l'identité |
|---|---|---|
| R-23 | **Regard sur l'écran** : si le regard sort de l'écran (tolérance 6 % du petit côté), les iris se ferment. La présence ne progresse plus, sans être perdue, et aucune validation n'est possible. | Supprime la faille « regarder le plafond ». L'attention doit rester présente sans se poser sur les lueurs. |
| R-24 | **Courant** : dans une bande, chaque lueur reçoit une impulsion constante, qu'elle soit attirée ou repoussée. | Le regard devient un outil : il faut pousser la lueur contre le courant. |
| R-25 | **Voile** : segment impénétrable. La composante normale de la vitesse est inversée et amortie (× 0,5). | Contrainte spatiale : l'attraction en ligne droite échoue, il faut contourner en poussant. |
| R-26 | **Veilleuse** : charge 0 → 1. Elle se vide en `d` secondes et se recharge en `r` secondes quand le regard est à moins de `ρ` d'elle. Éteinte, elle ferme les iris liés : ils ne progressent plus et les lueurs liées perdent leur validation, avec cascade. | Il faut regarder quelque chose tout en évitant le reste. C'est la répartition de l'attention poussée au bout. |
| R-27 | **Iris mouvant** : l'iris oscille entre deux points (période `T`, lissage cosinus). | Il faut anticiper la trajectoire d'une zone qu'on ne doit pas fixer. |
| R-28 | **Tempérament** : une lueur *lourde* (répulsion × 0,6, attraction × 0,6) ou *vive* (répulsion × 1,45, attraction × 1,2). Elle est dessinée plus grande ou plus petite. | Varie la réponse au regard sans nouvelle règle. |

Les lueurs ne se heurtent pas entre elles (prototype conservé).

## 4. Progression

Six chapitres, 34 niveaux (détail et justification : `LEVEL_DESIGN_SYSTEM.md`).

| Chapitre | Nom | Niveaux | Idée enseignée |
|---|---|---|---|
| I | Éveil | 5 | Le regard repousse. Tenir. Rester sur l'écran. Deux lueurs. Tempéraments. |
| II | Partage | 5 | L'ordre, le croisement, la cascade, trois lueurs. |
| III | Courants | 6 | Pousser avec le regard. |
| IV | Voiles | 6 | Contourner en poussant. |
| V | Veilleuses | 6 | Regarder sans troubler. |
| VI | Clairvoyance | 6 | Iris mouvants, puis toutes les idées combinées. |

**Déblocage** : un niveau se débloque quand le précédent est atteint. Un chapitre terminé débloque le suivant. On peut rejouer tout niveau débloqué.

## 5. Maîtrise et rejouabilité : les éclats

Rien n'est affiché pendant le jeu. À la fin d'un niveau, trois éclats peuvent s'allumer :

- **Atteint** : le niveau est terminé.
- **Fluide** : il est terminé en moins que le temps de référence du niveau.
- **Serein** : aucune validation n'a été perdue et le nombre d'intrusions (entrées d'une lueur dans la zone d'attention) ne dépasse pas la référence.

Les temps et intrusions de référence sont calculés par la simulation d'un joueur-robot bruité, avec une marge (§ 6 de `LEVEL_DESIGN_SYSTEM.md`). Ils sont atteignables mais demandent de la maîtrise. Le meilleur résultat est conservé. La carte des chapitres affiche les éclats. La fin de parcours affiche leur total.

## 6. Apprentissage

- **Pas d'écran de règles.** Le niveau I-1 est le tutoriel. Les consignes apparaissent quand le joueur fait la chose :
  - au départ : « Regardez la lueur. » ;
  - à la première intrusion : « Elle fuit votre regard. Regardez ailleurs, sur l'écran. » ;
  - au premier maintien : « Laissez-la se poser dans son iris. » ;
  - à la validation : « L'iris se ferme. ».
- **Chaque nouvel élément** a une carte d'introduction (glyphe, nom, une phrase) et une consigne contextuelle.
- **Regard hors écran** : la consigne « Gardez les yeux sur l'écran. » s'affiche à la première sortie.
- **Carnet** : une page qui rappelle les éléments rencontrés.

## 7. Échec et reprise

- Il n'existe pas de défaite. Une validation perdue coûte du temps et l'éclat *serein*.
- **Aide** : après 45 s sans terminer un niveau qui demande de pousser (III à VI), la *voie* s'affiche : un tracé en pointillés du chemin prévu. Après 45 s sur un niveau d'évitement, une consigne propose de regarder l'espace le plus vide.
- **Recommencer** est disponible en pause et sur l'écran de résultat.
- **Visage perdu** : la partie se met en pause et reprend seule (Gaze Engine v2).

## 8. Retours au joueur

| Événement | Visuel | Son | Haptique |
|---|---|---|---|
| Intrusion (lueur repoussée) | onde corail autour de la lueur, proportionnelle à la force | — | — |
| Présence en cours | lames de l'iris qui se referment | crescendo (prototype) | — |
| Validation | iris fermé, lueur menthe, halo | carillon 3 notes | légère |
| Validation perdue | lueur éteinte, iris qui se rouvre, trait corail vers la cause (cascade) | glissando descendant, un seul par tick | — |
| Regard hors écran | tous les iris pâlissent | — | — |
| Veilleuse faible | flamme qui vacille, anneau de charge | battement doux | — |
| Veilleuse éteinte | iris liés grisés | glissando | — |
| Niveau atteint | fermeture du dernier iris, lumière qui se retire | arpège ascendant | succès |
| Ambiance | champ qui respire lentement | nappe grave par chapitre | — |

## 9. Ce qui a été rejeté

| Idée | Raison du rejet |
|---|---|
| Lueur *curieuse* attirée par le regard | Transforme le regard en curseur : on déplacerait l'objet en le fixant, l'inverse d'Iris. |
| Rémanence (le regard laisse une trace qui repousse) | Règle invisible et injuste avec un regard bruité. |
| Clignement comme commande | Le clignement est involontaire et c'est déjà un bruit à filtrer. Ce serait un gadget. |
| Collisions entre lueurs | Chaos peu lisible qui ne renforce pas l'attention. |
| Lueurs liées par un fil | Complexité sans nouveau rapport au regard. |
| Chronomètre visible, vies, défaite | Contraire au calme exigeant. La maîtrise est mesurée après coup. |
| Défi quotidien procédural | Des niveaux générés n'égaleront pas des niveaux conçus. Rejouer des niveaux en miroir serait du remplissage. |
| Mode infini | Pas de matière au-delà des combinaisons conçues. |
| Classements en ligne | Contraire à la confidentialité (100 % local) et au ton. |
| Point de regard visible en jeu | L'œil suit le point, qui suit l'œil : une boucle qui détruit le jeu. Réservé au mode diagnostic. |
| Perspective et horizon | Mentent sur une physique plane (voir `ART_DIRECTION.md`). |

## 10. Revue critique de la proposition

Relue comme un critique externe, la première version de ce document contenait :

1. **Un chapitre « Orbites » séparé** (6 niveaux). L'iris mouvant ne change pas le rapport au regard, il ajoute une anticipation. Il est fusionné dans le chapitre VI comme dernière surprise, sur deux niveaux.
2. **Six niveaux dans chaque chapitre** : c'était une uniformité artificielle. Les chapitres I et II ont moins de matière (un seul concept, pas d'élément), ils passent à 5 niveaux.
3. **Un « Rituel du jour »** : supprimé (§ 9).
4. **Les lueurs curieuses** : supprimées (§ 9).
5. **Un codex illustré par élément** : réduit à une page « Carnet ».
6. **Un score chiffré par niveau** : remplacé par trois éclats binaires, plus calmes et plus lisibles.
7. **Des niveaux « Voile + Veilleuse + Courant + Iris mouvant »** avant le chapitre VI : interdits par la règle de combinaison (au plus deux éléments par niveau hors chapitre VI).
8. **Une zone d'attention visible** (halo autour du regard) : supprimée, car c'est un curseur déguisé. La fuite des lueurs (onde corail) est le seul retour.
9. **Risque « idée impossible à tester »** : chaque élément est accompagné d'une preuve automatique de nécessité (le robot passif échoue) et de faisabilité (le robot guidé réussit).
10. **Risque de frustration dans les chapitres III et IV** avec un regard imprécis : la zone y est plus large (0,48) et les voies d'aide existent. La faisabilité est vérifiée avec un bruit de regard de ± 24 pt.

## 11. Écarts entre conception et implémentation

Relevés après implémentation et vérification par simulation. Chaque écart est volontaire ou assumé.

### Niveaux modifiés par la vérification automatique

| Niveau | Première version | Version livrée | Test qui l'a imposé |
|---|---|---|---|
| 3-4 | « Cisaille » : deux courants opposés | « Contre-marée » : deux courants successifs dans le même sens | Un courant perpendiculaire à la trajectoire ne bloque pas une lueur : le niveau se jouait sans pousser. |
| 3-5 | Courant de force 0,85 | Force 0,72 | Le robot guidé échouait : une lueur lourde ne peut pas remonter un courant plus fort que sa répulsion maximale. |
| 2-2 | Croisement court | Trajets qui traversent tout l'écran | Différence insuffisante avec 2-1. |
| 4-2 | Une lueur, col décalé de 63 pt | Col décalé de 86 pt et une seconde lueur posée là où l'on regarde pour pousser | Le robot passif glissait jusqu'au col en 38 s, et le niveau différait trop peu de 4-1. |
| 5-4 | Veilleuse longue (8 s, charge 0,7) | 6 s, charge 0,35 | Le niveau se terminait avant l'extinction : la vigilance n'était pas nécessaire. |
| 6-4 | Iris mouvant de 0,26 à 0,74 | De 0,52 à 0,80 | La lueur longeait le voile jusqu'à son extrémité et arrivait sans poussée. |
| Voiles | Longueur ≥ 25 % de la largeur | ≥ 20 % | Les voiles courts du col (4-2) et de la finale (6-6) sont voulus. |

### Retours prévus mais non implémentés

- Le trait corail qui relie une lueur perdue en cascade à la lueur qui a causé la perte.
- L'assombrissement du champ pendant 0,5 s avant l'écran de résultat : le résultat apparaît directement.
- La vibration légère à chaque validation : seule la réussite du niveau vibre.

Aucun de ces retours ne change une règle. Ils restent au programme d'une itération de finition, après les tests humains.

### Non vérifiable dans cet environnement

- Le plaisir, la frustration et la durée réelle d'un parcours humain : le robot est plus précis et plus rapide qu'un joueur.
- La jouabilité des niveaux de poussée avec la précision réelle d'ARKit (le robot simule ± 24 pt de bruit).
