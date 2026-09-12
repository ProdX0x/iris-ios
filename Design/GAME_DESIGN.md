# Iris — game design

Référence du produit complet, révisée le 12 septembre 2026 (phase A de l'expansion). Le noyau mécanique (règles R-01 à R-15 de `Docs/domain-model.md`, invariants de `GAME_CORE_INVARIANTS.md`) est conservé. Les sections 5, 10 et 12 sont provisoires : elles décrivent une campagne étendue qui n'est pas implémentée.

## 1. Core gameplay

```
Lire le niveau (intro) → choisir où poser les yeux → observer la réaction des lueurs
→ corriger son regard → maintenir la présence 0,75 s → validation
→ protéger les validations acquises → dernier iris fermé → éclats → niveau suivant
```

Le regard repousse ce qu'il touche (R-02) ; laissée tranquille, une lueur rejoint son iris (R-01) ; la présence doit durer 0,75 s sans interruption (R-08) ; l'ordre et la cascade donnent un prix aux erreurs (R-09, R-11) ; les yeux doivent rester sur l'écran (R-23). Une partie dure de 15 s à 2 min ; un chapitre, 10 à 25 min.

## 2. Existing systems

### 2.1 Vocabulaire

| Terme | Sens |
|---|---|
| **Lueur** | Objet mobile. Elle fuit le regard et rejoint son iris quand on la laisse. |
| **Iris** | Point d'arrivée, dessiné comme un diaphragme qui se ferme pendant la validation. |
| **Zone d'attention** | Rayon autour du regard où les lueurs sont repoussées. Invisible, ressenti par la fuite. |
| **Courant** | Bande où les lueurs sont entraînées dans une direction. |
| **Voile** | Paroi que les lueurs ne traversent pas. |
| **Veilleuse** | Flamme qui s'éteint si on ne la regarde pas ; éteinte, elle ferme les iris qu'elle éclaire. |
| **Iris mouvant** | Iris qui glisse lentement entre deux points. |
| **Tempérament** | Lourde (répulsion et attraction × 0,6, plus grande) ou vive (× 1,45 et × 1,2, plus petite). |
| **Éclats** | Marques de maîtrise : *atteint*, *fluide*, *serein*. |

### 2.2 Règles conservées du prototype

R-01 attraction, R-02 répulsion proportionnelle, R-03 bruit, R-04 plafond, R-05 friction, R-06 intégration, R-07 rebonds amortis, R-08 présence continue 0,75 s, R-09 ordre, R-10 tolérance d'une lueur validée, R-11 cascade, R-13 lissage du regard, R-14 équivalence temporelle. Les traces golden du prototype restent des tests.

### 2.3 Règles modifiées par la refonte

| Règle | Prototype | Iris | Raison |
|---|---|---|---|
| Unités | pixels CSS absolus | échelle = petit côté / 393 pt | même jeu sur tout écran |
| Zone d'attention | 220/190/150 × 1,6 pt | fraction du petit côté, 0,40 à 0,52 | laisser un espace de jeu |
| Force de répulsion | `k` fixe par bande | force au contact, `k = force / zone` | réglage lisible |
| Positions | tirées par graine | placées à la main | le niveau porte une intention |
| Ordre | toujours séquentiel | séquentiel ou libre | l'ordre est une contrainte que l'on introduit |
| Fin de niveau | enchaînement immédiat | écran de résultat, éclats | respiration, rejouabilité |

### 2.4 Règles ajoutées par la refonte

| ID | Règle | Pourquoi elle sert l'identité |
|---|---|---|
| R-23 | Regard hors écran (tolérance 6 % du petit côté) : les iris se ferment, la présence gèle sans être perdue. | Supprime la faille « regarder le plafond ». |
| R-24 | Courant : impulsion constante dans une bande. | Le regard devient un outil qui pousse. |
| R-25 | Voile : segment impénétrable, rebond amorti × 0,5. | Il faut contourner en poussant. |
| R-26 | Veilleuse : charge qui se vide en `d` s, se remplit en `r` s sous le regard (rayon `ρ`) ; éteinte, ferme les iris liés et fait perdre leurs validations. | Regarder quelque chose tout en évitant le reste. |
| R-27 | Iris mouvant : oscillation entre deux points, période `T`. | Anticiper une zone qu'on ne doit pas fixer. |
| R-28 | Tempéraments lourde et vive. | Varier la réponse au regard sans nouvelle règle. |
| R-29, R-30 | Éclats ; déblocage niveau par niveau. | Maîtrise mesurée après coup ; progression persistante. |
| R-31 | Haptique : une impulsion par événement logique, cascade = une perte, garde de 150 ms partagée avec l'audio. | Le toucher confirme, ne rythme pas. |

Les lueurs ne se heurtent pas entre elles.

## 3. Audit des six chapitres existants

Analyse des configurations réelles (`Domain/Campaign/Campaign+*.swift`) et des mesures (`LEVEL_DESIGN_SYSTEM.md` § 10). Difficulté : estimation automatique du niveau de maîtrise ; fatigue et nouveauté : `DIFFICULTY_MODEL.md`.

### 3.1 Matrice chapitre × mécanique × compétence × difficulté × fatigue × nouveauté

| Chapitre | Niveaux | Lueurs | Paramètres | Mécanique dominante | Compétence sollicitée | Nouveauté introduite | Difficulté (plage, maîtrise) | Fatigue | Répétitions | Trous d'apprentissage |
|---|---|---|---|---|---|---|---|---|---|---|
| I Éveil | 5 | 1 – 2, ordre libre | zone 0,50, force 2,4 | évitement, traversée | trouver et déplacer l'espace libre | lueur, iris, écran (R-23), tempéraments | 1,5 – 4,0 (1-5) | 0 – 1 | 1-2 refait 1-1 en plus facile | trois découvertes en cinq niveaux ; « tenir » n'est pas une compétence distincte |
| II Partage | 5 | 2 – 3, ordonné | zone 0,46 | ordre, croisement, garde, cascade | répartir, anticiper, protéger | ordre, cascade | 3,0 – 7,5 (2-5) | 1 – 2 | — | la garde est enseignée par un seul niveau (2-3) avant d'être exigée partout |
| III Courants | 6 | 1 – 3 | zone 0,48, force 2,6, courants 0,72 – 0,85 | poussée dans l'axe | regarder derrière la lueur | courant | 2,7 – 7,1 (3-6) | 2 | 3-1, 3-2, 3-4 : même profil (une lueur, 2,7) | pas de respiration ; le passage de 1 à 2 lueurs (3-3) double la difficulté d'un coup (2,7 → 5,7) |
| IV Voiles | 6 | 1 – 2 | zone 0,46, force 2,6 | contournement | viser un angle, planifier | voile | 2,7 – 5,4 (4-6) | 2 – 3 | profil en dents de scie : 2,7 / 3,8 / 2,8 / 4,0 / 2,8 / 5,4 | même verbe que III (pousser) ; 4-6 est le seul niveau à trois voiles |
| V Veilleuses | 6 | 1 – 3 | zone 0,44, veilleuses 6 – 8 s | vigilance | regarder sans troubler, alterner | veilleuse | 2,6 – 7,8 (5-6) | 2 – 3 | 5-3 et 5-4 enchaînent deux charges fortes | 5-1 est facile (robot 4,5 s) puis 5-2 saute à 5,45 : la vigilance est apprise en un niveau |
| VI Clairvoyance | 6 | 1 – 3 | zone 0,42, force 2,6 | anticipation, synthèse | lire le niveau | iris mouvant | 2,4 – 9,2 (6-6) | 1 – 3 | 6-1 et 6-2 se jouent par évitement ; 6-5 (8,15, 14,7 s) plus long que la finale | l'élément propre du chapitre n'est pas nécessaire ; la synthèse repose sur III à V |

### 3.2 Ce que le joueur sait faire après chaque chapitre

| Après | Il sait | Il ne savait pas avant |
|---|---|---|
| I | ne pas regarder ce qu'il veut voir arriver ; tenir 0,75 s ; garder les yeux sur l'écran ; reconnaître lourde et vive | tout |
| II | ordonner ; anticiper un croisement ; protéger une lueur validée ; comprendre une cascade | partager |
| III | pousser en regardant derrière | que le regard est un outil |
| IV | pousser sous un angle ; enchaîner deux poussées | viser |
| V | programmer des coups d'œil ; garder une flamme vivante en guidant | regarder quelque chose exprès |
| VI | anticiper une zone mobile ; lire un niveau entier | combiner |

Redondances signalées : **III et IV** apportent essentiellement la même réponse (pousser), IV y ajoute l'angle ; **1-2** n'apporte rien à 1-1 ; **6-1 et 6-2** n'apportent pas de compétence nécessaire (évitement suffit) ; la **garde** est répétée dans quatre chapitres (2-3, 3-5, 4-4, 5-2) sans jamais devenir active.

### 3.3 Rôle de chaque niveau

| ID | Rôle | ID | Rôle | ID | Rôle |
|---|---|---|---|---|---|
| 1-1 | découverte | 3-1 | découverte | 5-1 | découverte |
| 1-2 | consolidation (faible) | 3-2 | variation | 5-2 | consolidation |
| 1-3 | découverte (R-23) | 3-3 | défi (2 lueurs) | 5-3 | variation |
| 1-4 | variation | 3-4 | variation (respiration de fait) | 5-4 | défi (cascade) |
| 1-5 | découverte (tempéraments) | 3-5 | défi (lourde) | 5-5 | respiration de fait |
| 2-1 | découverte | 3-6 | maîtrise | 5-6 | maîtrise |
| 2-2 | variation | 4-1 | découverte | 6-1 | découverte |
| 2-3 | découverte (cascade) | 4-2 | variation | 6-2 | variation |
| 2-4 | défi (3 lueurs) | 4-3 | variation (respiration de fait) | 6-3 | synthèse |
| 2-5 | maîtrise | 4-4 | consolidation | 6-4 | synthèse (respiration de fait) |
| | | 4-5 | variation (courant) | 6-5 | défi |
| | | 4-6 | maîtrise | 6-6 | maîtrise |

Aucun niveau n'a été conçu **comme** une respiration : les respirations de fait sont des niveaux à une lueur qui exigent toujours la précision du chapitre.

### 3.4 Points forts et faiblesses

Forts : chaque élément est prouvé nécessaire par simulation ; chaque paire de niveaux diffère sur deux critères ; les finales sont les niveaux les plus difficiles ; les consignes contextuelles apprennent sans texte ; la partie gratuite (I, II) ne frustre pas.

Faibles : une seule courbe (montée continue) sur quatre chapitres ; deux chapitres pour un verbe ; l'élément de VI facultatif ; la garde jamais active ; aucun chapitre à charge temporelle ni à attention diffuse ; le passage de une à deux lueurs est un saut dans III, IV et V ; la fatigue estimée de la seconde moitié est uniformément élevée.

## 4. Espace de conception inexploité

Ce qui peut varier sans dénaturer Iris (test d'appartenance de `GAME_CORE_INVARIANTS.md`), et son état :

| Dimension | Exploité par | Encore libre |
|---|---|---|
| Nombre de cibles | 1 à 3, individuelles | un groupe à validation collective (attention diffuse) |
| Disposition, géométrie des destinations | iris fixes, iris mouvants | but qui fuit (une autre lueur) ; but qui s'ouvre et se ferme |
| Ordre, maintien, risque de cascade | II, partout ensuite | présence simultanée exigée (accord) |
| Choix de la zone où poser le regard | évitement, poussée | regard imposé (ancre) ; regard interdit (ombre) : tous deux coûteux en précision |
| Interactions spatiales entre cibles | croisement, garde | protéger une cible d'un tiers mobile |
| Occupation visuelle, distractions cohérentes | courants, voiles | brume qui dérive ; objets tiers repoussés par le regard |
| Trajectoires | voies, voiles, courants | rebonds d'un tiers ; trajets circulaires lents |
| Attention périphérique | veilleuses (coups d'œil) | fixation avec surveillance périphérique ; charge diffuse d'un groupe |
| Timing sans vitesse | iris mouvants | fenêtres lentes, rythme lisible (phares) |
| Compromis progression / maintien | garde | retenir exprès une lueur (frein), relâcher au bon moment |
| Alternance concentration / détente | aucune conception explicite | chapitres et niveaux de respiration |
| Changement de stratégie du regard | III (pousser), V (regarder) | nourrir (regard bref sur la lueur), protéger (regard sur un tiers), converger (regard au-delà de deux mobiles) |

Les concepts issus de cet inventaire sont dans `GAME_EXPANSION_CONCEPTS.md`.

## 5. Skill progression (provisoire)

Progression des compétences sur la campagne étendue proposée (`CAMPAIGN_STRUCTURE.md`) :

```
retenir (I) → répartir, protéger (II) → pousser (III) → viser (IV) → réunir, respirer (V)
→ veiller (VI) → protéger activement (VII) → attendre, relâcher (VIII) → nourrir, désapprendre (IX) → tout lire (X)
```

Chaque compétence nouvelle s'appuie sur la précédente sans la rendre obsolète ; les chapitres de respiration (V, VIII) réutilisent les acquis avec une précision réduite.

## 6. Player mastery

Rien n'est affiché pendant le jeu. À la fin d'un niveau, trois éclats peuvent s'allumer : **atteint**, **fluide** (temps ≤ référence), **serein** (aucune perte, intrusions ≤ référence). Les références viennent de la simulation avec marge (`LEVEL_DESIGN_SYSTEM.md` § 6). La maîtrise d'Iris est l'économie du regard : peu d'intrusions, pas de perte, le sentiment de n'avoir presque rien fait. Les nouveaux éléments devront donner un sens propre à *serein* : ne pas laisser un souffle déloger une lueur, ne pas laisser une braise refroidir, ne pas manquer une fenêtre de phare.

## 7. Failure / recovery

- Aucune défaite. Une validation perdue coûte du temps et l'éclat *serein*.
- **Aide** : après 45 s, la voie s'affiche sur les niveaux qui demandent de pousser ; une consigne propose l'espace vide sur les niveaux d'évitement. Les nouveaux éléments auront chacun une aide contextuelle (le trajet d'un souffle surligné, le rythme d'un phare annoncé, la chaleur d'une braise expliquée).
- **Recommencer** est disponible en pause et sur l'écran de résultat.
- **Visage perdu** : pause automatique, reprise automatique.
- **Regard hors écran** : gel, jamais remise à zéro ; ce principe s'étend à tout état « regard dedans / dehors » futur.

## 8. Sensory feedback

| Événement | Visuel | Son | Haptique |
|---|---|---|---|
| Intrusion | onde corail proportionnelle à la force | — | — |
| Présence en cours | lames de l'iris qui se referment | crescendo | préparation du moteur |
| Validation | iris fermé, lueur menthe, halo | carillon | impulsion moyenne |
| Validation perdue | lueur éteinte, iris qui se rouvre | glissando, un seul par tick | impulsion douce, une par cascade |
| Regard hors écran | iris pâlis | — | — |
| Veilleuse faible / éteinte | flamme qui vacille, anneau ; iris liés grisés | battement / glissando | — / impulsion douce |
| Niveau atteint | dernier iris fermé, lumière qui se retire | arpège | notification de réussite |
| Ambiance | champ qui respire | nappe grave par chapitre | — |

Règle commune audio / haptique : un événement logique, un retour ; jamais une rafale (R-15, R-31). Les nouveaux éléments ajouteront des retours visuels et sonores, mais **aucune impulsion haptique nouvelle** (`PLAYER_COMFORT_CONSTRAINTS.md` § 3.6).

## 9. Comfort

Résumé de `PLAYER_COMFORT_CONSTRAINTS.md` : téléphone tenu en main et regard imprécis de 39 à 71 pt sont la norme de conception ; toute cible de regard obligatoire est large et centrale ; aucune mécanique de vitesse du regard ; gel plutôt que remise à zéro ; jamais plus de deux niveaux exigeants d'affilée ; une respiration par chapitre ; jamais trois chapitres exigeants consécutifs ; la fatigue n'est jamais une mécanique.

## 10. Campaign rhythm (provisoire)

Dix chapitres proposés, deux respirations placées après les deux blocs les plus fatigants :

```
I apprentissage · II consolidation · III tension · IV précision · V respiration
· VI nouveauté · VII tension maximale · VIII respiration · IX renversement · X expertise
```

À l'intérieur de chaque chapitre : entrée (1), montée (2 – 3), respiration (1), finale (1). Les chapitres existants ont des respirations de fait, pas de conception ; elles seront ajustées en phase B sans changer leur matière.

## 11. Replayability raisonnable

- Trois éclats par niveau, meilleur résultat conservé ; carte des chapitres et Carnet.
- Rejouer un chapitre entier comme session de 10 à 15 min.
- Aucun contenu généré, aucun mode infini, aucun défi quotidien (§ 13) : la rejouabilité est celle de la maîtrise, pas du volume.
- À décider : un compteur d'éclats total visible sur le seuil suffit-il, ou faut-il un objectif de fin (« tous les éclats d'un chapitre ») ? Rien n'est ajouté sans test.

## 12. Éléments encore non décidés

- Les quatre finalistes eux-mêmes (`GAME_EXPANSION_CONCEPTS.md` § 7) : aucun n'est approuvé.
- L'ordre relatif de Phares et Braises ; le sort de l'iris mouvant (X ou VIII) ; la longueur de X.
- La finale du chapitre II et le remplacement éventuel de 1-2 (`CAMPAIGN_STRUCTURE.md` § 6).
- Le rayon de regard des veilleuses face à une calibration acceptée de justesse (`PLAYER_COMFORT_CONSTRAINTS.md` § 2).
- Le plafond de trois lueurs : maintenu pour les lueurs individuelles ; à rediscuter si Nuée sort de la réserve.
- La preuve exigée d'un chapitre de respiration : nécessité ou différence (`LEVEL_DESIGN_SYSTEM.md`, partie B).
- Le rendu des nouveaux éléments (brume, phare, braise, jumelles) : hors périmètre de cette phase.

## 13. Ce qui a été rejeté

| Idée | Raison du rejet |
|---|---|
| Lueur *curieuse* attirée par le regard | Le regard deviendrait un curseur. |
| Rémanence du regard | Règle invisible, injuste avec un regard bruité. |
| Clignement, mouvement de tête, vitesse du regard comme commande | Bruit physiologique transformé en verbe ; incompatible avec le téléphone tenu en main. |
| Collisions entre lueurs, lueurs liées par un fil | Chaos ou complexité sans nouveau rapport au regard. |
| Chronomètre, vies, défaite, score en jeu | Contraire au calme exigeant. |
| Défi quotidien, mode infini, classements | Remplissage ; confidentialité. |
| Point de regard visible en jeu | Boucle œil-point qui détruit le jeu. |
| Perspective et horizon | Mentent sur une physique plane. |
| Ombres (zones de regard interdites) | Précision aux frontières ; duplique la zone d'attention ; retire la liberté de regarder. |
| Pénombre (lueurs cachées) | Viole « rien de caché ». |
| Carrefour (choix d'iris) | Décision unique, attraction ambiguë. |

## 14. Écarts entre conception et implémentation (refonte v2)

Relevés après implémentation et vérification par simulation. Chaque écart est volontaire ou assumé.

| Niveau | Première version | Version livrée | Test qui l'a imposé |
|---|---|---|---|
| 3-4 | « Cisaille » : deux courants opposés | « Contre-marée » : deux courants successifs | Un courant perpendiculaire ne bloque pas : le niveau se jouait sans pousser. |
| 3-5 | Courant de force 0,85 | Force 0,72 | Une lueur lourde ne remonte pas un courant plus fort que sa répulsion maximale. |
| 2-2 | Croisement court | Trajets qui traversent tout l'écran | Différence insuffisante avec 2-1. |
| 4-2 | Une lueur, col décalé de 63 pt | Col à 86 pt et une seconde lueur | Le robot passif glissait jusqu'au col ; trop proche de 4-1. |
| 5-4 | Veilleuse 8 s, charge 0,7 | 6 s, charge 0,35 | Le niveau se terminait avant l'extinction. |
| 6-4 | Iris mouvant de 0,26 à 0,74 | De 0,52 à 0,80 | La lueur longeait le voile sans poussée. |
| Voiles | Longueur ≥ 25 % | ≥ 20 % | Les voiles courts de 4-2 et 6-6 sont voulus. |

Retours prévus mais non implémentés : le trait corail qui relie une perte en cascade à sa cause ; l'assombrissement du champ avant le résultat. La vibration par validation est implémentée depuis le 12 septembre 2026 (R-31).

Non vérifiable dans cet environnement : le plaisir, la frustration, la durée réelle d'un parcours, la jouabilité fine des poussées avec la précision d'ARKit. Le test humain du 12 septembre 2026 a confirmé la fluidité générale et la calibration ; il n'a pas mesuré la fatigue sur une session longue.
