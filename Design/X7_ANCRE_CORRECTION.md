# X·7 « l'ancre » — correction ciblée

Branches : `prototype/x7-stabilisation-head-guidance` (première correction), puis `fix/x7-head-only-circling` (option A, après le test sur iPhone 14 Pro). Statut : **TECHNIQUEMENT VALIDÉ / À JOUER HUMAINEMENT**.

## Point de départ

La première mission demandait de partir du tag `iris-expansion-human-validated-v1` (`4bdb0ae`). À ce tag, le chapitre X n'a que six niveaux : X·7 n'existe pas encore, il apparaît au commit `275aa8f` de l'expansion oculomotrice. La première correction part donc de `e29cae7` (`fix/chapter-card-adaptive-layout`), qui descend du tag et contient X·7. L'option A part de `3abddb7`, la tête de cette première correction.

## Ce que le test sur iPhone a montré

La calibration du regard est bonne tête de face. Quand la tête tourne volontairement, le point de regard projeté dérive fortement et peut sortir de l'écran, alors que le visage et la pose de tête restent suivis. La première correction faisait dépendre la progression de la présence des yeux près du point pendant le cercle : elle bloquait un joueur qui fixait pourtant réellement le point. C'est une limite de la projection du regard tête tournée, pas un défaut à corriger dans le Gaze Engine, qui n'a pas été modifié.

## Logique finale (option A)

1. **Fixation d'ouverture.** Yeux sur le point, tête présente, immobile (à 2,5° près) et à peu près face à l'écran (moins de 30° de lacet et de 40° de tangage), pendant 0,8 s. La pose de repos est mesurée, un son doux confirme. Le regard est le critère.
2. **Départ.** La tête tourne vers la droite ; le cercle commence quand elle atteint 60 % de l'amplitude de ce côté. Le regard est ignoré.
3. **Cercle.** Seul le parcours observé de la tête, lacet et tangage, remplit l'anneau : droite, haut-droite, haut, haut-gauche, gauche, bas-gauche, bas, bas-droite. L'anneau ne gagne qu'avec une tête sur le cercle qui avance dans le bon sens, juste devant la partie allumée (50° au plus) et à 120°/s au plus. Quatre jalons : côté de départ, haut, côté opposé, bas. Le regard est ignoré : hors de la zone, hors de l'écran ou absent, il ne met rien en pause. Sans pose de tête, la progression attend et ne gagne rien, puis reprend avec la tête.
4. **Retour face.** Après 300°, la tête revient au repos pendant 0,3 s : le premier cercle est fermé (signal de validation). L'anneau se disperse en poussière d'étoiles pendant la respiration de 1,8 s.
5. **Re-fixation.** Le regard redevient le critère : yeux sur le point, tête immobile et face à l'écran, pendant 0,7 s. Sans elle, le deuxième cercle ne commence pas, même si la tête le dessine.
6. **Cercle inverse.** Même chose en partant vers la gauche, dans l'autre sens, regard ignoré.
7. **Fixation finale.** La tête revenue de face, le regard redevient le critère : yeux sur le point pendant 0,7 s. Sans elle, le niveau ne se termine pas. Ensuite vient la récompense finale : l'anneau se disperse et la lueur rejoint seule son iris.

Amplitude confortable : 10° de lacet et 8° de tangage autour du repos ; le cercle compte dès 6° et 4,8°.

## Où le regard compte

| Phase | Regard | Tête |
|---|---|---|
| Fixation d'ouverture | critère : sur le point | présente, immobile, à peu près de face |
| Départ vers le côté | ignoré | seule entrée |
| Cercle | ignoré | seule entrée, pause sans pose |
| Retour face | ignoré | seule entrée |
| Re-fixation avant le cercle inverse | critère : sur le point | présente, immobile, à peu près de face |
| Fixation finale | critère : sur le point | présente, revenue près du repos |

Le roulis n'intervient jamais : le lacet et le tangage viennent de la direction avant du visage, qu'une inclinaison de la tête sur le côté ne change pas.

## Lecture de la tête

Le lacet et le tangage arrivent dans le repère de l'écran : `GameViewModel.screenHead` applique à l'observation ARKit la correspondance d'axes que la calibration a déjà résolue pour le regard. Pour ce niveau seulement (`OculoDefinition.readsHeadWithoutGaze`), la pose de tête est lue même quand l'échantillon de regard n'a pas de projection ; pour tous les autres niveaux, rien ne change. Les niveaux 11-7 et 12-7 comptent des mouvements de tête en valeur absolue et restent identiques.

## Visuel

Le point et l'anneau sont fixes à l'écran. Les barres allumées viennent du parcours de la tête ; la lumière sur l'anneau et le léger penché de la silhouette suivent la tête. Rien ne suit le regard pendant un cercle : le halo qui rappelle les yeux n'apparaît que pendant une fixation, et l'indicateur de regard DEBUG (curseur et points de diagnostic) est masqué pendant le départ, le cercle et le retour, pour X·7 seulement.

## Silhouette de référence

Source : `x7_silhouette_reference.png` (941 × 1672 px), contour néon d'une tête, des oreilles, du cou et des épaules, sans texte ni bouton. Le trait a été relevé par balayage de sa luminance puis simplifié : 25 points pour la moitié droite du contour, 12 pour le cou et l'épaule (`Features/Game/Rendering/AncreSilhouette.swift`). La moitié gauche est le miroir exact et une courbe de Catmull-Rom centripète relie les points. Le test `referenceOverlay` superpose le tracé à l'image quand elle est présente ; l'image n'est pas embarquée. Géométrie et design inchangés par l'option A.

## Textes

- Carte d'introduction, trois lignes : « Regardez le point au centre. » / « Gardez vos yeux dessus et tournez doucement la tête en rond. » / « Faites le tour complet, puis recommencez dans l'autre sens. »
- Indices en jeu, dans l'ordre : « Gardez les yeux sur le point. » ; « Maintenant, dessinez le cercle avec la tête, en partant vers la droite. » ; « Tour complet ! Revenez de face, les yeux sur le point. » ; « Maintenant, le cercle dans l'autre sens, en partant vers la gauche. » ; « Les yeux sur le point, une dernière fois. » ; « Les deux cercles sont faits. La lueur s'éveille. »
- Aucun terme médical n'est montré au joueur.

## Retours

Aucun son ni vibration nouveaux : une fixation ou un jalon réutilise la pulsation douce, un cercle fermé le signal de validation et sa vibration.

## Observation (DEBUG)

- `OculomotorTrace` (catégorie `oculotest`) : phases, succès, sens attendu, pose de repos, décalage de tête, état du regard et son rôle (`gaze=criterion` pendant une fixation, `gaze=ignored` pendant un cercle). Pendant un cercle, un changement d'état du regard est journalisé comme attendu (« the circle goes on »), jamais comme une erreur. Les lignes sont construites par interpolation : les erreurs `String(format:)` dues à des `%d` appliqués à des entiers 64 bits ont disparu des chemins de X·7.
- `AncreCapture`, seulement si l'app est lancée avec `--iris-capture` : une ligne JSON par échantillon et par événement, avec la phase de jeu (dont l'alerte de visage perdu), le suivi du visage et de la tête, lacet, tangage et roulis caméra et écran, l'état du regard, son rôle et sa position, la boucle, sa phase, son sens attendu, ses jalons et son balayage. `gazeState = VALID_OUTSIDE` avec `gazeRole = ignored` et un balayage qui grandit est le comportement attendu. Fichier local `tmp/iris-debug/iris-debug-<date>-10-7.jsonl`, 180 s au plus ; ni image, ni géométrie du visage, ni envoi. Récupération : `xcrun devicectl device copy from --device <iPhone> --domain-type appDataContainer --domain-identifier net.steve-s.iris --source tmp/iris-debug --destination <dossier>`.

## Tests

- `OculoAncreTests` : structure ; A fixation puis cercle ; B regard hors écran pendant le cercle ; C regard absent pendant le cercle ; D tête immobile ; E mauvais sens ; F poses séparées et sauts ; G perte de pose de tête ; H pas de re-fixation ; I pas de fixation finale ; J deux cercles et fixations ; exigences de la fixation ; cercle inverse ; allure ; roulis ; consignes ; orientation de la tête ; joueur guidé et par ; L empreintes des autres finales.
- `AncreSceneTests` : silhouette ; scène à travers les phases ; K regard déchaîné pendant les cercles sans aucun effet sur la scène ni marque de regard ; trace et capture DEBUG ; images de contrôle ; superposition sur la référence.
- Joueur guidé : 3 graines sur 3, 42,2 s, aucune intrusion ; par 82 s et 2 intrusions selon la formule historique.

## Inchangé

Gaze Engine, acquisition ARKit, TrueDepth, calibration, correspondance d'axes, transformation affine, filtre du regard, viewport global, décrochage, audio et haptique globaux, autres niveaux et chapitres, physique historique, progression, empreintes et fixtures des campagnes validées, Liquid Glass.

## À juger humainement

- La fixation d'ouverture et la re-fixation se font-elles sans hésitation ?
- Le cercle se dessine-t-il sans jamais bloquer quand les yeux restent volontairement sur le point ?
- L'amplitude est-elle confortable, sans vertige ni fatigue ?
- L'anneau et la silhouette suivent-ils la tête du bon côté ?
- La fixation finale est-elle comprise comme la dernière étape ?
