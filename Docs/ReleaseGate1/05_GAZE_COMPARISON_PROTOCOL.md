# 05 — Protocole de comparaison contrôlée du regard : 14 Pro / 15 Pro

Objectif : savoir s'il existe une différence **mesurable** de suivi du regard entre les deux appareils, en
n'utilisant que des grandeurs qu'Iris calcule déjà. Aucune métrique inventée.

**État : NON EXÉCUTÉ.** Ce protocole demande une personne devant l'écran ; il ne peut pas être joué depuis cette
machine. Les résultats attendus sont consignés au document 08 comme « INSUFFICIENT DATA » tant qu'il n'a pas tourné.

---

## 1. Les grandeurs, et où Iris les calcule

Aucune n'est ajoutée : toutes existent déjà dans le code.

| Grandeur | Où | Sens |
|---|---|---|
| Erreur moyenne de calibration | `CalibrationProfile.validationMeanError` ; affichée dans le panneau de pause par `GazeCalibrationStatus` : « Calibration validée, erreur moyenne **N %** de la largeur » | fraction du petit côté du viewport |
| Erreur maximale de calibration | `CalibrationProfile.validationMaxError` | idem |
| Calibration validée ou non | `CalibrationProfile.isValid` | booléen |
| 10 contrôles de préparation | `GazeReadinessReport.checks` — `faceTracking`, `cameraAccess`, `session`, `faceDetected`, `eyeTracking`, `gazeDirection`, `headStable`, `signalStable`, `blinkDetection`, `axisMapping` | pass / fail / pending, avec un détail |
| Confiance d'axe | `GazeReadinessReport.axisConfidence` | 0…1, seuil interne 0,8 |
| Échantillons dans la fenêtre | `GazeReadinessReport.sampleCount` sur `windowDuration = 1,2 s` | **cadence effective ≈ sampleCount / 1,2** ; le moteur exige au moins 20 échantillons, soit ≈ 16,7 /s |
| Pertes de visage | état `GazeTrackingState.tracking(faceVisible:)`, visible en jeu par le badge « regard : visage perdu » | comptage à la main |
| Interruptions | `GazeTrackingState.interrupted`, badge « regard : interrompu » | comptage à la main |
| Intrusions et pertes du niveau | `LevelOutcome.intrusions`, `.losses`, écran de résultat | comportement de jeu réel |
| Temps du niveau | `LevelOutcome.time`, écran de résultat | idem |

## 2. Ce qui doit être identique entre les deux appareils

Même version d'Iris (même commit), **même personne**, portrait, même distance (bras tendu, iPhone à hauteur des
yeux), même pièce et même éclairage, même heure de la journée à ±1 h, sans lunettes ou avec les mêmes lunettes dans
toutes les répétitions, même séquence de calibration, même niveau joué, même durée.

Différence connue et à consigner, non contrôlable : **iOS 26.5.2 sur le 14 Pro, iOS 26.6.1 sur le 15 Pro.**

## 3. Préparation (une fois par appareil)

```sh
# 1. Poser exactement la même build sur les deux appareils.
xcodebuild -project Iris.xcodeproj -scheme Iris -configuration Debug \
  -destination 'generic/platform=iOS' -derivedDataPath /tmp/iris-gate1 build

xcrun devicectl device install app --device <identifiant CoreDevice> \
  /tmp/iris-gate1/Build/Products/Debug-iphoneos/Iris.app
```

Identifiants CoreDevice : 14 Pro `CD9242BD-9650-52C9-BBA6-A30490C6DFA8` · 15 Pro
`21ABC186-DEFC-59C7-9671-85E4FA69DA9A`.

Sur chaque appareil, une seule fois : Réglages d'Iris → activer **« Points de regard (diagnostic) »**. Les badges
« regard : … » et les points corail / menthe deviennent visibles, ce qui rend les pertes de suivi observables.

## 4. Une répétition (à faire **3 fois par appareil**, en alternant les appareils : A B A B A B)

1. Déverrouiller l'appareil, fermer Iris s'il tourne.
2. Lancer Iris depuis l'écran d'accueil.
3. **Recalibrer** : Réglages → « Recalibrer le regard ». Aller jusqu'au bout sans reprise.
4. À la fin de la calibration, noter ce que l'écran de vérification indique : contrôles passés / échoués, et la
   confiance d'axe si elle est affichée.
5. Lancer le **même niveau** sur les deux appareils. Niveau recommandé : **III · 4** — chapitre gratuit, une lueur,
   un courant, pas d'étape oculomotrice, donc une mesure du suivi et non d'une mécanique particulière.
6. Mettre en pause dès le niveau chargé et relever la ligne du panneau de pause :
   « Calibration validée / non validée, erreur moyenne **N %** de la largeur ».
7. Reprendre et jouer le niveau jusqu'au bout, **une seule fois**, sans recalibrer.
8. Pendant le jeu, compter à voix haute et noter : combien de fois le badge passe à **« regard : visage perdu »**,
   combien de fois à **« regard : interrompu »**.
9. À l'écran de résultat, noter **temps**, **intrusions**, **pertes**.

## 5. Fiche de relevé

Une ligne par répétition. À remplir pour les 6 répétitions.

| # | Appareil | iOS | Calibration validée | Erreur moyenne (%) | Contrôles échoués | « visage perdu » | « interrompu » | Temps (s) | Intrusions | Pertes |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 14 Pro | 26.5.2 | | | | | | | | |
| 2 | 15 Pro | 26.6.1 | | | | | | | | |
| 3 | 14 Pro | | | | | | | | | |
| 4 | 15 Pro | | | | | | | | | |
| 5 | 14 Pro | | | | | | | | | |
| 6 | 15 Pro | | | | | | | | | |

## 6. Comment lire le résultat — décidé à l'avance

Trois répétitions par appareil ne permettent aucun test statistique sérieux. La règle de lecture est donc
opérationnelle, et fixée **avant** la mesure pour ne pas être choisie après coup :

- **Différence opérationnellement significative** si, sur les trois répétitions, l'erreur moyenne de calibration du
  14 Pro dépasse celle du 15 Pro d'au moins **2 points de pourcentage** à chaque fois, **ou** si les pertes de
  visage sont au moins **deux fois plus nombreuses** à chaque fois.
- **Aucune différence significative** si les plages des deux appareils se chevauchent.
- **Données insuffisantes** dans tout autre cas — en particulier si une répétition échoue pour une raison
  extérieure (appel, lumière changée, calibration abandonnée).

Un écart observé **n'attribue aucune cause**. Il faudrait ensuite écarter la version d'iOS (en amenant les deux
appareils à la même version) avant même de parler de matériel.

## 7. Ce que ce protocole ne peut pas établir

- Il ne mesure **pas** l'erreur angulaire du regard : Iris ne la calcule pas, et Apple ne la publie pas (doc 03).
- Il ne mesure **pas** la cadence réelle des images AR pendant le jeu (voir doc 04, §5).
- Il ne dira **jamais** « le 14 Pro est moins précis » : au mieux « dans ces conditions, sur cette personne, à ces
  versions d'iOS, l'écart mesuré est X ».
