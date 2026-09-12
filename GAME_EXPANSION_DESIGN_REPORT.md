# Iris — rapport de conception de l'expansion (phase A)

Date : 12 septembre 2026. Branche : `feature/game-expansion`. Base : `52f20b7` (Iris v2), `229b8df` (haptique).
Nature : conception, comparaison, sélection. **Aucune implémentation.** Aucun fichier Swift n'a été modifié.

Ce rapport résume les documents de `Design/` ; il ne les remplace pas. Il n'est pas promotionnel : chaque proposition y est présentée avec ses faiblesses.

## 1. Situation actuelle

- Six chapitres, **34 niveaux**, tous prouvés faisables par simulation, chaque élément prouvé nécessaire (sauf l'iris mouvant), chaque paire de niveaux différente sur deux critères.
- Validation humaine acquise sur iPhone 14 Pro : regard fluide, calibration fonctionnelle (10 % / 17 %), haptique perceptible et sobre.

**Forces.** Un noyau mécanique exact et stable ; un apprentissage sans texte ; une preuve automatique par niveau ; une partie gratuite (I, II) qui apprend sans frustrer ; des finales qui sont bien les niveaux les plus difficiles de leur chapitre.

**Faiblesses.** Une seule courbe, en montée continue, sur les quatre derniers chapitres : aucune respiration conçue, quatre charges élevées d'affilée. III et IV enseignent le même verbe (pousser), douze niveaux de suite. L'élément propre de VI (iris mouvant) est facultatif : 6-1 et 6-2 se jouent par évitement. La garde, présente dans quatre chapitres, n'est jamais active. Aucun chapitre à charge temporelle ni à attention diffuse. Le passage de une à deux lueurs double la difficulté d'un coup dans III, IV et V.

**Répétitions.** 1-2 refait 1-1 en plus facile ; 3-1, 3-2 et 3-4 ont le même profil ; IV alterne en dents de scie (2,7 / 3,8 / 2,8 / 4,0 / 2,8 / 5,4) ; 5-3 et 5-4 enchaînent deux charges fortes ; 6-5 est plus long et plus intrusif que la finale.

Détail : `Design/GAME_DESIGN.md` § 3, `Design/DIFFICULTY_MODEL.md` § 3 et § 4.

## 2. Invariants

`Design/GAME_CORE_INVARIANTS.md`. Douze invariants absolus, dont : le regard est le seul verbe ; regarder repousse et rien n'est attiré par le regard ; l'action est indirecte ; présence continue de 0,75 s ; attention sur l'écran ; calme exigeant sans défaite ni chronomètre ; lisible sans texte ; chaque niveau prouvé ; physique validée comme sol commun ; confidentialité totale ; jouable sans son ni vibration. Ce qui dénaturerait Iris : tout contrôle tactile du jeu, tout objet attiré par le regard, le regard comme pointeur, le clignement ou la vitesse du regard comme commande, les réflexes, les objets cachés, le ton de combat. Cinq questions de test d'appartenance pour toute idée future.

## 3. Contraintes humaines intégrées

`Design/PLAYER_COMFORT_CONSTRAINTS.md`. Le joueur ne place jamais une lueur avec son regard ; il place une zone de 165 à 196 pt autour d'un point connu à 39 pt près (71 pt pour une calibration acceptée de justesse). Toute cible de regard obligatoire doit donc mesurer ≥ 0,18 du petit côté ou avoir une hystérésis ; toute position de regard nécessaire reste loin des bords ; un iris à atteindre en poussant ne peut pas être dans un coin ; aucune mécanique de vitesse du regard ; gel plutôt que remise à zéro ; jamais deux niveaux exigeants d'affilée sans respiration ; jamais trois chapitres exigeants consécutifs ; la fatigue n'est jamais une mécanique. Point ouvert relevé : le rayon de regard des veilleuses (55 pt) est inférieur à l'erreur moyenne d'une calibration acceptée de justesse (71 pt) ; à vérifier avec un second testeur, sans modification pour l'instant.

## 4. Exploration

- **Douze concepts** de chapitre générés : Braises, Ombres, Phares, Souffles, Nuée, Ancres, Pénombre, Regard calme, Élan, Accord, Carrefour, Rendez-vous.
- Thèmes explorés : dosage du regard sur la lueur elle-même ; contraintes sur l'espace de regard ; temps et fenêtres lentes ; tiers mobile que le regard protège ; attention diffuse sur un groupe ; fixation imposée avec surveillance périphérique ; prédiction sans voir ; manière de bouger les yeux ; impulsion dosée ; présence simultanée ; choix de but ; but mutuel qui fuit.
- Chaque fiche contient une rubrique « pourquoi cette idée pourrait être mauvaise », un test « chapitre ou niveau ? », un test de redondance, et une note séparée sur treize critères.

`Design/GAME_EXPANSION_CONCEPTS.md`.

## 5. Concepts rejetés

| Concept | Raison |
|---|---|
| Ombres (zones de regard interdites) | duplique la contrainte de la zone d'attention avec une frontière invisible ; exige la précision aux bords, contraire au test humain ; retire le plaisir de choisir où regarder |
| Pénombre (lueurs presque invisibles) | viole l'invariant « rien de caché » ; frustration garantie avec un regard imprécis |
| Regard calme (lueurs sensibles à la vitesse du regard) | punit le fonctionnement normal de l'œil (saccades) ; amplifie les micro-mouvements du téléphone tenu en main |
| Carrefour (choix entre deux iris) | décision unique puis niveau connu ; attraction ambiguë ; nouveauté mince |

## 6. Concepts en réserve

| Concept | Rôle possible |
|---|---|
| Ancres (fixer un repère pendant que la lueur se pose) | mini-séquence de deux niveaux dans un chapitre de synthèse ; finaliste de première passe, rétrogradé pour sa dépendance à la précision du suivi et parce qu'il serait un troisième « regardez ici » après veilleuses et braises |
| Nuée (petit groupe, iris commun) | interlude de deux ou trois niveaux de respiration, si huit lueurs restent lisibles |
| Élan (tempérament glissante) | un ou deux niveaux, dessiné clairement différent |
| Accord (deux iris qui ne se ferment qu'ensemble) | finale alternative du chapitre II, utile à la partie gratuite |

## 7. Les quatre finalistes

Aucun n'est approuvé. Chacun devra être prototypé sur deux niveaux et joué avant d'être développé.

### Souffles

- **Description.** Une brume lente dérive sur un trajet visible ; ce qu'elle touche est entraîné (une lueur déviée, une lueur validée délogée, une flamme éteinte). Regardée, elle s'éloigne : le regard devient un bouclier.
- **Rôle.** Chapitre VII, tension maximale, après les veilleuses.
- **Compétence.** La garde active : regarder un tiers pour protéger un acquis.
- **Exemples.** Une brume qui repasse sur un iris validé ; escorter une lueur à travers son trajet ; protéger une flamme ; un souffle qui rebondit sur un voile ; deux souffles, trois lueurs.
- **Bénéfices.** Seul concept sans redondance avec une valeur de chapitre maximale ; donne enfin une expression active à la garde ; aucune nouvelle loi, un objet de plus soumis à la même.
- **Risques.** Le plus coûteux techniquement (objet mobile repoussé et entraînant) ; fatigue de surveillance ; ton « défense » si la brume va vite ou cherche quelque chose ; la protection peut se contourner en poussant la lueur ailleurs.
- **Pourquoi retenir.** Il complète le verbe du regard (pousser, veiller, protéger).
- **Pourquoi rejeter malgré tout.** Si l'on refuse toute charge de surveillance continue, ou tout troisième objet mobile.

### Braises

- **Description.** Des lueurs froides que l'iris n'accepte pas ; elles se réchauffent sous le regard, qui les fait fuir. Nourrir par courts regards, relâcher, recommencer.
- **Rôle.** Chapitre IX, renversement tardif.
- **Compétence.** Le dosage et le rythme du regard sur la chose même qu'on a appris à ne pas regarder.
- **Exemples.** Première braise ; braise et lueur normale dans l'ordre ; braise et courant (nourrir et pousser d'un seul regard) ; braise derrière un voile ; deux braises de tempéraments différents.
- **Bénéfices.** La contradiction fondatrice rendue explicite ; désapprentissage d'un réflexe ; coût technique faible.
- **Risques.** Ressemble aux veilleuses (charge au regard) ; le regard de près projette la lueur si le rayon de charge est trop petit ; sentiment d'être puni pour obéir ; deux chargeurs au regard dans un même jeu.
- **Pourquoi retenir.** C'est le concept le plus fidèle à l'identité.
- **Pourquoi rejeter malgré tout.** Si Ancres ou une autre obligation de regard est retenue à sa place, ou si le prototype se révèle chaotique.

### Rendez-vous

- **Description.** Deux lueurs jumelles sans iris : chacune est le but de l'autre ; elles se valident en restant ensemble 0,75 s. Toutes deux fuient le regard ; les voiles et les courants les séparent.
- **Rôle.** Chapitre V, respiration après douze niveaux de poussée.
- **Compétence.** Converger : raisonner sur deux corps mobiles, regarder au-delà pour rapprocher.
- **Exemples.** Jumelles ; le voile entre elles ; une vive et une lourde ; dans le courant ; trois.
- **Bénéfices.** Confort maximal, fatigue minimale, lisibilité ; une scène propre à Iris ; un but qui fuit, ce qu'aucun iris ne fait.
- **Risques.** Nécessité indirecte : sans obstacle, les jumelles se rejoignent seules ; un critique y verra un iris mouvant recombiné ; « où est l'iris ? » doit se comprendre sans texte.
- **Pourquoi retenir.** C'est la respiration qui manque, avec une identité.
- **Pourquoi rejeter malgré tout.** Si chaque chapitre doit prouver sa nécessité par lui-même ; Nuée prendrait alors sa place, avec la même faiblesse et moins d'identité.

### Phares

- **Description.** Un iris qui s'ouvre et se ferme à un rythme lent et lisible ; fermé, il expire et tient les lueurs à distance ; il faut retenir la lueur tout près pendant la fermeture, puis relâcher à l'ouverture.
- **Rôle.** Chapitre VIII, respiration temporelle après la tension maximale.
- **Compétence.** Attendre, retenir, relâcher au rythme du monde.
- **Exemples.** Premier phare ; deux phares décalés dans l'ordre ; phare et courant ; phare lent et lueur lourde ; trois lueurs, deux phares.
- **Bénéfices.** Seul axe temporel de la campagne ; le plus tolérant au suivi imprécis ; faible fatigue.
- **Risques.** Sans expiration, l'idée est passive (garer et attendre) ; avec, on ajoute une règle pour en sauver une autre ; attendre peut ennuyer ; « retenir contre le souffle » est du chapitre III inversé.
- **Pourquoi retenir.** Promu à la seconde passe à la place d'Ancres : il couvre exactement ce que la campagne n'a pas (le temps) sans coût de précision.
- **Pourquoi rejeter malgré tout.** Si le prototype de l'expiration n'est pas convaincant : le concept ne tient pas sans elle.

## 8. Campagne proposée

`Design/CAMPAIGN_STRUCTURE.md`. Dix chapitres, 57 à 58 niveaux, 2 h 30 à 4 h :

```
I Éveil · II Partage · III Courants · IV Voiles · V Rendez-vous (respiration)
· VI Veilleuses · VII Souffles (tension) · VIII Phares (respiration) · IX Braises (renversement)
· X Clairvoyance (expertise, étendue aux nouveaux éléments)
```

Les nouveaux chapitres ne sont pas tous placés après VI : Rendez-vous s'insère entre IV et V actuels, où la respiration manque. Chaque chapitre suit entrée, montée, respiration, finale. Des remplacements sont prévus si un finaliste est rejeté (§ 5 du document).

Partie gratuite (I, II) : elle apprend Iris sans frustrer mais ne montre pas le retournement du chapitre III. Propositions conceptuelles : une finale de II qui annonce la poussée ; le remplacement de 1-2 ; Accord en variation. Aucun StoreKit.

## 9. Incertitudes qui exigent une décision humaine

1. Lesquels des quatre finalistes prototyper, et dans quel ordre.
2. Accepter qu'un chapitre de respiration prouve sa différence plutôt que sa nécessité.
3. L'ordre relatif de Phares et Braises ; le sort de l'iris mouvant (X ou VIII) ; la longueur de X.
4. La finale du chapitre II et le remplacement de 1-2 pour la partie gratuite.
5. Le rayon de regard des veilleuses face à une calibration acceptée de justesse.
6. Le plafond de trois lueurs si Nuée sort de la réserve.
7. Le rendu des nouveaux éléments (brume, phare, braise, jumelles) : hors périmètre ici.

## 10. Ce que cette phase ne peut pas démontrer

Ces documents montrent la cohérence, la différence conceptuelle, une progression théorique et une faisabilité probable. Ils ne montrent ni le plaisir réel, ni la fatigue réelle, ni la difficulté réelle, ni la qualité finale d'un chapitre joué. Ces quatre choses exigent une implémentation de prototype puis un test humain.

## 11. État du projet

- Aucun nouveau niveau, aucun chapitre 7 à 10 dans le code, aucune mécanique, aucune force, aucun paramètre du regard, aucun réglage de difficulté, aucun StoreKit, aucune modification du Gaze Engine.
- Fichiers touchés : documentation et conception uniquement (`Design/`, ce rapport, une section du README).
- Commit de conception sur `feature/game-expansion`, sans push ni merge.

## 12. Étape suivante

**VALIDATION HUMAINE DE LA CONCEPTION AVANT TOUTE IMPLEMENTATION DES NOUVEAUX CHAPITRES.**
