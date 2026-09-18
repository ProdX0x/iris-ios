# 11 — Captures App Store

```
GATE 4G : CLOSED
Validées le 18 septembre 2026, une par une, par relecture humaine.
```

Les huit captures obligatoires existent. Elles vivent **hors du dépôt**, comme les artefacts de build :

```
/Volumes/Steve Pro BlackSSD/Dev/App Mobile/.iris-gate4g-screenshots/
```

Ce document est leur seule trace versionnée : il dit ce qu'elles montrent, comment elles ont été obtenues, et
avec quelles empreintes. Une capture dont le SHA-256 ne correspond plus à ce tableau n'est plus celle qui a été
validée.

## Ce qu'elles ont en commun

| | |
|---|---|
| Format | PNG |
| Dimensions | **1320 × 2868**, résolution native — jamais redimensionnées |
| Orientation | portrait |
| Langue | français |
| Appareil | simulateur **Iris-69**, iPhone 17 Pro Max, iOS 26.3 |
| UDID | `ED9684A0-BF2E-4277-8554-E07ABDA95BAF` |
| Barre d'état | 09:41, batterie pleine (`simctl status_bar override`), sauf sur les écrans qui la masquent par conception — calibration et jeu |
| Build | celui du HEAD `3b94a621`, installé par `simctl install` ; jamais Xcode Run |

**Aucune capture n'a été redimensionnée, recadrée ou retouchée.** Aucune retouche d'image d'aucune sorte n'a été
appliquée à aucun moment.

## Manifeste

| # | Fichier | Écran | SHA-256 |
|---|---|---|---|
| 01 | `01_accueil.png` | Accueil, partie en cours | `677ffb5467f719c52de7b8af451af0784cf896af85f3aacadce3f2c1e7143677` |
| 02 | `02_explication-1-4.png` | Explication 1/4 | `b2d0dff2abe33d838f97807b73203a73ed74a4df4bbc46cf58f3c85d08a48db7` |
| 03 | `03_explication-3-4.png` | Explication 3/4 | `d2a30cbde39d47ed24835106b9608a9088ece63f655286250372ee3f00305c9b` |
| 04 | `04_calibration.png` | Calibration 5/9, cible centrée | `b14c060bba3110b4b7e67e8e511e465c135570b36b605a3400350b23a6c766d1` |
| 05 | `05_jeu-reel.png` | Jeu réel, niveau III-4 | `0329596427802eebc2f3a1d98acfa45792ff3b54876abcce9c32906a84bbbe0c` |
| 06 | `06_chapitres.png` | Chapitres, accès gratuit, IV et V verrouillés | `c859ab347f5cb431b50ffedfccef66d58cab7310736e457fe15f016d781d7ee0` |
| 07 | `07_progression.png` | Progression complète, cinq chapitres | `ee1d96d01f1278e43e3a2d12e1f854ed663f79cb442300e42e5486fd2d40f026` |
| 08 | `08_niveau-avance.png` | Niveau avancé XI-3, la braise a franchi le courant | `ed07ff89348c5100f09ccbe60a2f8e4102be8069fe9eaf57f8d86144a1957df4` |

## Comment chacune a été atteinte

Tous les arguments employés sont des mécanismes DEBUG déjà présents dans `App/Platform/LaunchOptions.swift` ;
aucun n'a été ajouté pour l'occasion, et aucun ne modifie le jeu, la physique, les niveaux ou l'équilibrage.

| # | Arguments de lancement | Remarque |
|---|---|---|
| 01 | `--iris-route home --iris-progress 3-4 --iris-entitlement full` | |
| 02 | `--iris-onboarding --iris-entitlement full` | l'argument ouvre l'explication dans une suite de préférences jetable : la préférence `iris.onboarding.completed` de l'appareil n'est pas touchée |
| 03 | `--iris-onboarding --iris-entitlement full`, puis deux appuis humains sur « Suivant » | seule mise en scène manuelle de la série, autorisée explicitement |
| 04 | `--iris-route gazeSetup --iris-oracle-gaze --iris-entitlement full` | le regard oracle est le mécanisme prévu pour exécuter la calibration sur simulateur, faute de caméra TrueDepth. Sans lui, l'écran reste bloqué sur le diagnostic de préparation |
| 05 | `--iris-route game --iris-level 3-4 --iris-oracle-gaze --iris-entitlement full --iris-autoplay` | `--iris-autoplay` sert uniquement à franchir la carte d'introduction en l'absence d'appui humain ; instant retenu à +5 s, avant toute aide tardive |
| 06 | `--iris-route chapters --iris-progress 7-4 --iris-entitlement free` | état **free** assumé : deux chapitres verrouillés, badges « ACCÈS COMPLET » et boutons entiers. Liste défilée à la main d'un cran, pour dégager la barre d'onglets |
| 07 | `--iris-route chapters --iris-progress all --iris-entitlement full` | liste défilée à la main ; cinq chapitres, aucun verrouillage |
| 08 | `--iris-route game --iris-level 11-3 --iris-entitlement full --iris-autoplay` | **sans** `--iris-oracle-gaze` : voir ci-dessous |

## Trois précisions qui comptent

**04, 05 et 08 sont des sondes natives `simctl` copiées octet pour octet.** Ces trois écrans changent en
permanence — une cible de calibration qui se déplace, un courant qui dérive, une braise qui monte. L'image
validée par relecture humaine a donc été copiée telle quelle vers sa destination, par `cp -p`, plutôt que
reprise : reprendre aurait donné une autre image que celle qui avait été jugée. Identité vérifiée dans les trois
cas par SHA-256 **et** par comparaison binaire `cmp` : aucun octet ne diffère. La source de la 08 est la sonde
`b42` d'une rafale de 70 images.

**08 a été produite par une interaction humaine réelle.** Le regard oracle ne réveille pas une braise — la
réveiller demande de la regarder. Le niveau XI-3 a donc été joué à la main sur le simulateur, où le pointeur
tient lieu de regard, **sans `--iris-oracle-gaze`**. La braise a été réveillée, poussée à travers le courant et
photographiée au-dessus de lui. Aucun état de gameplay n'a été forgé : ce que montre l'image est arrivé.

**Les captures 06 et 07 doivent leur cadrage à un défilement manuel.** En haut de liste, la barre d'onglets
flottante recouvre le bas de la dernière carte ; dès que la liste défile, elle se réduit à sa pastille et ne
masque plus rien. Ce comportement est natif (`dsTabBarMinimizesOnScroll`).

## Ce que ces huit captures ne couvrent pas

La **capture de relecture de l'achat intégré** exigée par App Store Connect pour le non consommable n'est pas
dans cette série : elle montre un écran d'achat réel et dépend de produits qui n'existent pas encore côté Apple.
Elle reste ouverte dans `Docs/AppStore/APP_STORE_CONNECT_CHECKLIST.md`, avec les autres points qui dépendent
d'App Store Connect.
