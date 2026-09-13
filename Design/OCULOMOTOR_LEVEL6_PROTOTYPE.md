# Prototype oculomoteur — Chapitre I, niveau 6 (branche `prototype/ch1-oculomotor-level6`)

Statut : **PROTOTYPE, À TESTER HUMAINEMENT**. Un seul niveau, optionnel, ajouté après le niveau 5 du chapitre I. Rien d'autre ne change : les niveaux 1 à 5, les chapitres II à XII, le Gaze Engine, ses filtres, ses seuils, la calibration et l'avertissement de décrochage sont intacts (voir « Protection »).

## Le niveau : « le fil des balises »

L'iris du centre est éteint. Cinq balises dorment : au centre, à droite, à gauche, en haut, en bas (0,5/0,5 ; 0,82/0,5 ; 0,18/0,5 ; 0,5/0,16 ; 0,5/0,84). Seule la balise que le fil désigne respire ; elle s'éveille sous un regard posé 0,25 s dans sa zone (rayon 0,2 du petit côté, soit 79 pt, relâchement à 0,27), puis tend un fil vers la suivante. Chaque balise éveillée entrouvre l'iris. Le fil complet ouvre l'iris et libère une lueur, qui rejoint l'iris comme au niveau 1.

Le fil visite, dans l'ordre : centre, droite, gauche, centre, haut, bas, centre, droite, gauche, droite, gauche, haut, bas, haut, bas, centre (16 étapes). Le joueur ne lit jamais « regardez à droite » : il suit un fil.

Le niveau ne bloque pas le chapitre II (il est optionnel : `gatesProgression = false`). Il est proposé comme niveau suivant après le 5, et accessible depuis la carte.

## Ce que le prototype mesure (DEBUG, jamais montré au joueur)

`OculomotorTrace` (Presentation, `#if DEBUG`, observation seule) :

- état du regard par échantillon : `VALID_INSIDE` (projection dans le viewport), `VALID_OUTSIDE` (le mapper produit encore une projection, hors viewport ; écrêtée à ±50 % du viewport, signalée `capped` si elle est sur la butée), `INVALID` (aucune projection : rayon n'atteignant pas le plan, visage perdu) ;
- sorties de viewport : horodatage, dernière position valide, projection réellement produite (seulement en `VALID_OUTSIDE`), bord (LEFT/RIGHT/TOP/BOTTOM : depuis la projection si elle existe, sinon la dernière direction observée à condition que la dernière position valide ait été dans le tiers extérieur de ce côté), durée jusqu'au retour, position de réentrée. Aucune position hors écran n'est inventée ;
- par transition (balise précédente → balise désignée) : départ, état initial, première entrée, acquisition, dwell, validation, sorties/INVALID pendant la transition, yaw et pitch de tête au départ et à l'acquisition, deltas, `headMotion` (max |Δyaw| + |Δpitch|, descriptif, sans seuil) ;
- pose de tête et géométrie oculaire ARKit (yeux gauche/droit, lookAt, repère vue) : exposées par un champ optionnel `observation` du `RawGazeSample`, rempli par le service ARKit ; rien dans le calcul du regard ne le lit.

Lecture : `log stream --predicate 'subsystem == "net.steve-s.iris" AND category == "oculotest"'` sur le Mac, appareil branché. Ligne type : `[OculoTest] transition=CENTER->RIGHT step=1 acquisition=412ms dwell=251ms gazeState=VALID_INSIDE excursions=0 invalid=0ms outside=0ms headYawDelta=3.1deg headPitchDelta=0.7deg headMotion=3.8deg`.

Indicateur DEBUG de bord (chevron corail) : visible seulement avec « Points de regard (diagnostic) » ; il désigne la dernière direction observable pendant une sortie ou une perte. Il complète l'avertissement « visage perdu », qui reste exactement celui d'avant.

## Décrochage existant, identifié et intact

- Perte du visage : `GameViewModel.tick` compte 0,3 s de `.tracking(faceVisible: false)`, arrête la boucle et passe en `.faceLost` ; l'overlay « visage perdu » de `GameOverlayView` s'affiche ; le retour du visage relance la partie. Test de non-régression : `OculomotorTraceTests.faceLostUnchanged` (niveaux 1 et 6 comparés).
- Regard hors champ (R-23) : `GameSession.updateAttention` ferme les iris au-delà de 6 % du petit côté hors viewport ; `attentionOffFieldUnchanged`.
- Interruption de session, caméra refusée, erreurs : inchangés.

## Protection

- Niveaux 1 à 5 : `Campaign+Eveil.swift` gelé (SHA-256), empreinte `historical_campaign.txt` intacte ; le chapitre I joué est `eveil.levels + [oculomoteur]`, `historicalChapters` ne change pas.
- Chapitres II à XII : inchangés (structure, ids, tests).
- Gaze Engine : aucune ligne de calcul modifiée. Deux fichiers `AR/` ont chacun un ajout purement additif (champ optionnel `observation`, un argument à sa construction) ; leurs SHA-256 gelés ont été mis à jour délibérément, avec cette raison, dans `HistoricalCampaignFingerprintTests`.

## Tests d'ablation (automatiques)

Regard central permanent, attente, regard aléatoire (3 graines, 90 s), passages de 130 ms, mauvais ordre, alternance horizontale seule, alternance verticale seule : aucun n'achève le niveau. La séquence correcte, scriptée avec le vrai filtre de regard, l'achève ; le bot guidé aussi (3 graines, 11 s en moyenne) ; l'évitement et le regard hors écran jamais.

## Protocole du premier test humain

1. Jouer naturellement, sans bloquer la tête. Terminer le niveau si possible, sinon noter à quelle balise ça coince.
2. Noter : mes yeux vont-ils réellement à droite/gauche/haut/bas ? Ai-je l'impression de tourner la tête ? Dois-je me forcer à la garder stable ? Quelles balises sont difficiles ? L'avertissement « visage perdu » apparaît-il, quand ? Le suivi décroche-t-il près des bords ? Est-ce encore Iris ? Agréable ? Amusant ? Envie de recommencer ?
3. Optionnel, après : un second passage tête volontairement stable, à comparer sans le considérer comme « le bon ».
4. Relever le journal `oculotest` (transitions, sorties, yaw/pitch).

## Diagnostic à cinq cas

A tracking/calibration (le regard va sur la balise, les coordonnées non), B logique (les coordonnées entrent, la balise ne s'éveille pas : dwell, ordre, machine d'état), C périphérie/décrochage (INVALID ou sortie près des bords ; à documenter, pas à corriger ici), D gameplay (tout marche mais c'est artificiel ou ennuyeux), E tête (acquisitions correctes avec forte participation yaw/pitch, ce qui ne prouve pas que les yeux ne bougent pas). Verdict possible : excellent ; gameplay bon / tracking périphérique limité ; tracking bon / tête très active ; techniquement bon / gameplay faible ; design invalide.
