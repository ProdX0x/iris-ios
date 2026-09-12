# Iris — contraintes de confort du joueur

Statut : autoritaire pour les futurs niveaux. Fondé sur le test humain du 12 septembre 2026 (iPhone 14 Pro, TrueDepth, Gaze Engine v2) et sur les valeurs réelles du moteur.
Aucune de ces contraintes ne modifie le Gaze Engine : elles s'appliquent à la conception des niveaux.

## 1. Données issues du test réel

| Observation | Valeur ou constat |
|---|---|
| Orientation | téléphone tenu normalement ; aucun retournement nécessaire |
| Calibration acceptée | erreur moyenne 10 %, maximale 17 % du petit côté |
| Calibration refusée | moyenne 17 %, maximale 39 % ; recalibration proposée (seuils 18 % / 30 %) |
| Gameplay | fluide, contrôle des lueurs satisfaisant |
| Téléphone tenu en main | les micro-mouvements de la main déplacent légèrement le regard apparent, donc les lueurs |
| Téléphone posé | stabilité nettement supérieure |
| Regards extrêmes | vers les bords et les diagonales, le point de regard peut sortir de l'écran |
| Haptique | réglage marche/arrêt fonctionnel ; validation et perte perceptibles ; cascade : une seule impulsion, satisfaisant |

## 2. Ce que ces chiffres signifient en points

Écran de référence : 393 × 852 pt, petit côté 393 pt.

| Grandeur | Points |
|---|---|
| Erreur moyenne d'une bonne calibration (10 %) | ≈ 39 pt |
| Erreur maximale d'une bonne calibration (17 %) | ≈ 67 pt |
| Erreur moyenne encore acceptée (18 %) | ≈ 71 pt |
| Erreur maximale encore acceptée (30 %) | ≈ 118 pt |
| Rayon de validation d'un iris | 16 pt (la lueur y est guidée par la physique, pas par le regard) |
| Tolérance d'une lueur validée | 36 pt |
| Rayon de regard d'une veilleuse (0,14) | ≈ 55 pt |
| Zone d'attention (0,42 – 0,50) | 165 – 196 pt de rayon |

Lecture : le joueur ne place jamais une lueur avec son regard, il place une **zone** de 165 à 196 pt de rayon autour d'un point connu à 39 pt près en moyenne. C'est pourquoi l'évitement et la poussée sont confortables. En revanche, toute mécanique qui exige que le regard soit **dans** une petite région (veilleuse, ancre, zone interdite) subit l'erreur de plein fouet.

**Point ouvert pour la phase B** : le rayon de regard des veilleuses (55 pt) est inférieur à l'erreur moyenne d'une calibration acceptée de justesse (71 pt). Le test humain s'est fait avec une bonne calibration (39 pt). Un joueur à 17 % de moyenne pourrait avoir du mal à raviver une flamme. À vérifier avec un second testeur avant d'agrandir ce rayon ; ne pas le modifier dans cette phase.

## 3. Contraintes de conception

### 3.1 Cibles de regard obligatoires

Toute chose que le joueur **doit** regarder (veilleuse, et tout élément futur du même type) :

- rayon de regard ≥ 0,18 du petit côté, ou une hystérésis : entrée à 0,14, sortie à 0,22, pour qu'un regard qui tremble au bord ne clignote pas ;
- position dans `x` 0,20 – 0,80 et `y` 0,15 – 0,85, rayon entièrement sur l'écran ;
- au plus deux par niveau, jamais deux dans le même quart d'écran si elles exigent une alternance ;
- l'effet d'un regard qui s'écarte brièvement est un **gel**, jamais une remise à zéro (règle déjà appliquée par R-23 et par les iris fermés).

### 3.2 Micro-mouvements du téléphone tenu en main

- Aucune mécanique fondée sur la vitesse, l'accélération ou le tremblement du regard.
- Aucun état « dedans / dehors » sans hystérésis ni tolérance temporelle (≥ 0,2 s avant de basculer).
- Aucune tolérance de position inférieure à 36 pt pour une lueur validée (valeur actuelle, conservée).
- Une poussée nécessaire doit réussir avec un regard décalé de 39 pt : les passages, brèches et cols mesurent au moins 3 rayons de lueur (règle 6 actuelle), et l'angle de poussée admis est large (≥ 40°).
- Les niveaux ne supposent jamais un téléphone posé. Un niveau qui n'est agréable que sur support est un niveau raté.

### 3.3 Périphérie et bords

- Le regard est inconfortable et imprécis aux bords. Toute position de regard **nécessaire** (pour pousser, veiller, ancrer) reste dans `x` 0,15 – 0,85 et `y` 0,12 – 0,88.
- Corollaire géométrique : pour pousser une lueur vers un point, le regard doit être **au-delà** de la lueur, à l'opposé du point. Un iris qu'il faut atteindre en poussant ne peut donc pas être dans un coin ni contre un bord : la position de regard requise serait hors écran. Un iris en bord ou en coin n'est admis que si l'attraction seule y mène.
- Aucun niveau construit entièrement dans les coins ; aucune fixation périphérique prolongée (> 2 s) exigée.
- La disparition du point de diagnostic aux extrêmes est une réalité du suivi, pas un bug de niveau. Elle n'est pas compensée par un bornage des coordonnées de jeu.

### 3.4 Fatigue

Iris sollicite les yeux ; la fatigue vient de trois sources : la précision soutenue (pousser longtemps sous un angle), les saccades obligatoires (veiller), et la charge de surveillance (plusieurs lueurs validées à protéger).

- Une session visée dure 5 à 15 min : un chapitre de 5 ou 6 niveaux, ou une demi-douzaine de niveaux rejoués.
- Un niveau humain dure 2 à 5 fois le temps du robot : viser 20 à 90 s, jamais plus de 2 min pour un joueur qui sait.
- Dans un chapitre, jamais plus de **deux niveaux consécutifs** à précision ou stabilité élevées (`DIFFICULTY_MODEL.md`, niveaux 2 ou 3 sur ces axes). Au moins un niveau de respiration par chapitre, placé après la montée.
- Dans la campagne, jamais **trois chapitres consécutifs** à fatigue élevée. Les chapitres III, IV, V et VI actuels enchaînent quatre charges élevées : c'est le premier problème structurel que l'expansion doit résoudre (`CAMPAIGN_STRUCTURE.md`).
- La fatigue physiologique n'est jamais une mécanique : aucun élément ne se dégrade parce que le joueur cligne, détourne les yeux ou repose son regard un instant. Le gel (R-23) est la seule réponse.

### 3.5 Calibration

- Les niveaux sont conçus pour rester **terminables** avec une calibration acceptée de justesse (18 % / 30 %) et **agréables** avec une bonne calibration (10 % / 17 %). Les références d'éclats visent la seconde.
- Toute mécanique nouvelle est d'abord jugée à 18 % d'erreur : si elle n'y fonctionne pas, elle est rejetée ou élargie.
- Le robot de vérification simule aujourd'hui un bruit de ± 24 pt. Pour les nouveaux éléments qui exigent de regarder une région, la vérification devra aussi passer avec un biais constant de 71 pt (phase B).

### 3.6 Haptique

- Le comportement validé (une impulsion par validation, par perte, par fin de niveau, une cascade = une perte, garde de 150 ms) est conservé.
- Aucune impulsion nouvelle pour les intrusions, les contacts de brume ou les battements rythmiques : le toucher confirme des événements rares, il ne rythme pas le jeu.
- Le jeu reste entièrement jouable vibrations coupées.

## 4. Liste de contrôle d'un futur niveau

1. Chaque position de regard nécessaire est dans `x` 0,15 – 0,85, `y` 0,12 – 0,88.
2. Chaque cible de regard obligatoire a un rayon ≥ 0,18 ou une hystérésis, et un gel plutôt qu'une remise à zéro.
3. Aucun iris à atteindre en poussant n'est en bord ou en coin.
4. Chaque passage mesure ≥ 3 rayons de lueur ; chaque poussée admet ≥ 40° d'erreur.
5. Le niveau se termine avec un regard biaisé de 71 pt (simulation) et reste faisable avec ± 24 pt de bruit (simulation actuelle).
6. Aucune fenêtre temporelle < 1,5 s, aucune mécanique de vitesse du regard.
7. Le niveau ne suit pas deux niveaux déjà exigeants en précision ou stabilité.
8. Durée humaine estimée ≤ 2 min ; robot ≤ 20 s.
9. Rien n'est caché ; l'état se lit sans texte.
10. Le niveau est jouable sans son ni vibration.
