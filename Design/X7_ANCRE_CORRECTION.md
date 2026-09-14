# X·7 « l'ancre » — correction ciblée

Branche `prototype/x7-stabilisation-head-guidance`. Statut : **TECHNIQUEMENT VALIDÉ / À JOUER HUMAINEMENT**.

## Point de départ

La mission demandait de partir du tag `iris-expansion-human-validated-v1` (`4bdb0ae`). À ce tag, le chapitre X n'a que six niveaux : X·7 n'existe pas encore, il apparaît au commit `275aa8f` de l'expansion oculomotrice. La branche part donc de `e29cae7` (`fix/chapter-card-adaptive-layout`). Ce commit descend du tag, contient X·7 tel que le joueur l'a essayé et garde sur l'iPhone les cartes de chapitres corrigées. Les commits de cette branche ne touchent pas aux cartes.

## Ce qui n'allait pas

L'ancienne version enchaînait six petits gestes isolés (des « bandes » de boussole). Elle apprenait le sens de chaque axe au premier geste du joueur, si bien qu'un premier geste à gauche s'affichait à droite. Elle exigeait aussi le regard dans une zone serrée pendant chaque maintien, alors que l'estimation du regard se dégrade quand la tête tourne. Le joueur ne savait ni quoi faire de sa tête, ni si son geste était bon ; après tout cela, une lueur devait encore contourner un gouffre.

## Logique finale

1. **Ancrage.** Visage de face, yeux sur le point au centre de la silhouette, tête immobile pendant 0,8 s (à 2,5° près). La pose de repos est mesurée, un petit arc se remplit autour du point, un son doux confirme.
2. **Départ.** La tête tourne vers le côté indiqué (droite pour la première boucle). Dès qu'elle atteint 60 % de l'amplitude confortable de ce côté, la boucle commence.
3. **Cercle.** Le parcours de la tête remplit l'anneau segmenté : droite, haut-droite, haut, haut-gauche, gauche, bas-gauche, bas, bas-droite. L'anneau ne gagne que si la tête est sur le cercle, avance dans le bon sens, juste devant la partie allumée (50° au plus) et à 120°/s au plus. Des poses séparées par le centre, un saut à travers le cercle ou le mauvais sens ne remplissent rien. Quatre jalons (côté de départ, haut, côté opposé, bas) donnent un son doux et un éclat lumineux.
4. **Regard tolérant.** Les yeux doivent rester près du point, dans une zone large pendant la rotation. Leur présence monte et descend lentement : un tremblement de l'estimation ne coûte rien, un vrai regard ailleurs met l'anneau en pause (un seul écart, rien n'est perdu), une perte de suivi ne fait que suspendre.
5. **Retour face.** Après 300° de cercle, la tête revient de face pendant 0,3 s : la boucle est complète (signal de validation). L'anneau se disperse en poussière d'étoiles pendant la respiration de 1,8 s.
6. **Boucle inverse.** Même chose en partant vers la gauche, dans l'autre sens. Ensuite la lueur, placée haut au-dessus de la silhouette et loin du point, rejoint seule son iris : le niveau se termine sans autre geste.

Amplitude confortable : 10° de lacet et 8° de tangage autour du repos ; le cercle compte dès 6° et 4,8°.

## Orientation de la tête

Le lacet et le tangage arrivent désormais dans le repère de l'écran. `GameViewModel.screenHead` applique à l'observation ARKit la correspondance d'axes que la calibration a déjà résolue pour le regard, à partir des yeux et de la gravité. Aucun signe d'axe n'est supposé, et rien n'est appris au premier geste. Les niveaux 11-7 et 12-7 comptent des mouvements de tête en valeur absolue : ils ne changent pas.

## Silhouette de référence

Source : `x7_silhouette_reference.png` (941 × 1672 px), contour néon d'une tête, des oreilles, du cou et des épaules, sans texte ni bouton. Le trait a été relevé par balayage de sa luminance : rayons depuis le centre du visage pour le crâne et la mâchoire, lignes pour l'oreille et le cou, colonnes pour l'épaule qui s'estompe. Les points sont exprimés en demi-largeurs de visage puis simplifiés : 25 points pour la moitié droite du contour, 12 pour le cou et l'épaule (`Features/Game/Rendering/AncreSilhouette.swift`). La moitié gauche est le miroir exact, et une courbe de Catmull-Rom centripète relie les points. Le test `referenceOverlay` superpose le tracé à l'image de référence quand elle est présente. L'image elle-même n'est pas embarquée dans l'app.

À l'écran, la silhouette est grande, centrée sur le point et translucide : trait lavande du chapitre X, halo doux, épaules qui s'effacent. L'anneau tient à l'intérieur du visage. La silhouette se penche légèrement avec la tête du joueur ; tant que la tête ne bouge pas encore, elle dessine elle-même lentement la boucle à faire. Un petit chevron à l'intérieur de l'anneau indique le sens, le prochain jalon respire, la lumière de la tête glisse sur l'anneau.

## Textes

- Carte d'introduction, trois lignes : « Regardez le point au centre. » / « Gardez vos yeux dessus et tournez doucement la tête en rond. » / « Faites le tour complet, puis recommencez dans l'autre sens. »
- Indices en jeu : le point au départ ; « Les yeux sur le point, tournez doucement la tête : à droite, puis en rond. » après l'ancrage ; un rappel si les yeux quittent le point ; « Tour complet ! Recommencez dans l'autre sens, par la gauche. » après la première boucle ; une aide tardive qui parle de la tête.
- Carnet : « Un point au centre d'une silhouette. Les yeux posés dessus, la tête dessine un cercle lent : l'anneau se remplit, puis dans l'autre sens. »
- Aucun terme médical n'est montré au joueur ; stabilisation du regard, coordination œil-tête et réflexe vestibulo-oculaire restent dans le code et la documentation.

## Retours

Aucun son ni vibration nouveaux : un jalon réutilise la pulsation douce, une boucle complète le signal de validation et sa vibration.

## Tests

- `OculoAncreTests` : structure (10-7 optionnel, deux boucles opposées, amplitudes douces), victoire du joueur idéal (dix jalons, deux boucles, aucun écart, fin du niveau six secondes au plus après les boucles), ablations (tête immobile, tête sans les yeux, mauvais sens, poses séparées, pas de données de tête, regard aléatoire : jamais), mécanique d'une boucle, boucle inverse, tolérance (tremblement, regard ailleurs, perte de suivi), allure bornée, consignes dans l'ordre et sans terme clinique, orientation de la tête par la calibration, joueur guidé et par.
- `AncreSceneTests` : silhouette symétrique et cadrée, scène qui suit les boucles, images de contrôle des dix moments du niveau et superposition sur la référence (fichiers PNG quand `IRIS_SNAPSHOT_DIR` est défini).
- Joueur guidé : 3 graines sur 3, 41,6 s, aucune intrusion ; par 81 s et 2 intrusions selon la formule historique.

## Observation (DEBUG)

- `OculomotorTrace` (catégorie `oculotest`) : phases, jalons, pose de repos, décalage de tête, présence des yeux, état du regard (VALID_INSIDE, VALID_OUTSIDE, INVALID), retour des données de tête ; une ligne d'état dans le HUD de diagnostic.
- `AncreCapture`, seulement si l'app est lancée avec `--iris-capture` : une ligne JSON par échantillon de regard et par événement. Elle garde séparés la phase de jeu (dont l'alerte de visage perdu), le suivi du visage, le lacet, le tangage et le roulis caméra et écran, la présence d'un échantillon de regard, son état et sa position normalisée, l'âge du dernier regard valide, la boucle, sa phase, ses jalons, son balayage et la présence des yeux. Fichier local `tmp/iris-debug/iris-debug-<date>-10-7.jsonl` dans le conteneur de l'app, 180 s au plus, écrit hors du fil principal ; ni image, ni géométrie du visage, ni envoi. Récupération : `xcrun devicectl device copy from --device <iPhone> --domain-type appDataContainer --domain-identifier net.steve-s.iris --source tmp/iris-debug --destination <dossier>`.

## Inchangé

Gaze Engine, fichiers AR (lus seulement), calibration, filtrage, décrochage, audio et haptique globaux, autres niveaux et chapitres, progression, empreintes et fixtures des campagnes validées.

## À juger humainement

- Le cercle se comprend-il avec la carte, la silhouette et l'anneau, sans autre explication ?
- L'amplitude est-elle confortable, sans vertige ni fatigue ?
- L'anneau et la silhouette suivent-ils la tête du bon côté ?
- La tolérance du regard est-elle juste, ni punitive pendant la rotation, ni triviale ?
- La démonstration par la silhouette et la poussière d'étoiles sont-elles lisibles et élégantes ?
- Le suivi du visage tient-il sur toute la boucle ? La capture `--iris-capture` permet de le vérifier.
