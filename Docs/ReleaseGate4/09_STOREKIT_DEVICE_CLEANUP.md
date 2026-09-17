# 09 — Gate 4A : restaurer un appareil de validation StoreKit réelle

**État : INTERROMPU EN ATTENTE D'AUTORISATION HUMAINE.** Ce document consigne le diagnostic, la mesure de
référence et l'action proposée. **Aucune action modificatrice n'a été exécutée.**

## Périmètre

| | |
|---|---|
| Branche | `release/iris-appstore-rc1` @ `6806ffd` |
| Appareil concerné | iPhone 14 Pro uniquement |
| iPhone 15 Pro | **hors périmètre — non modifié, et actuellement déconnecté** |
| Code produit / projet | non modifiés |

## Les deux appareils

| | iPhone 14 Pro | iPhone 15 Pro |
|---|---|---|
| Nom | « iPhone Steve. » | « The Grey » |
| UDID | `CD9242BD-9650-52C9-BBA6-A30490C6DFA8` | `21ABC186-DEFC-59C7-9671-85E4FA69DA9A` |
| Modèle | `iPhone15,2` | `iPhone16,1` |
| iOS | 26.5.2 | 26.6.1 |
| Connexion | disponible, appairé, mode développeur actif | **indisponible (déconnecté)** |
| Iris installé | 1.0 (1), **DEBUG** | 1.0 (1), DEBUG |

## Mesure de référence, avant toute action

iPhone 14 Pro, dernière lecture du magasin, `2026-09-17T11:33:37Z` :

```
device.model=iPhone15,2  device.ios=26.5.2  app.version=1.0  app.build=1
app.configuration=DEBUG
request.ids=net.steve-s.iris.access.promopass|net.steve-s.iris.unlock.fullgame
result.count=2
result.ids=net.steve-s.iris.access.promopass|net.steve-s.iris.unlock.fullgame
result.types=…promopass=Auto-Renewable Subscription|…fullgame=Non-Consumable
result.displayPrice=2,99 €
entitlement=free
error.domain=(none)
storefront.country=FRA  storefront.id=143442
appTransaction.environment=Xcode  appTransaction.verified=yes
```

**Onze lectures consécutives**, du `2026-09-16T19:06:39Z` au `2026-09-17T11:33:37Z`, donnent toutes le même
résultat : `environment=Xcode`, deux produits, 2,99 €.

## Diagnostic

### Ce qui est prouvé

**1. L'environnement n'est pas dans le conteneur de données de l'app.** Listage complet des 35 fichiers du
`appDataContainer` de `net.steve-s.iris` : aucun artefact StoreKit, aucun `.storekit`, aucun répertoire
`StoreKitTest`. Ce qui s'y trouve est la préférence de l'app, l'état de scène, les caches Metal et les deux
journaux de debug.

**2. Le conteneur date du `2026-09-16 19:06 UTC`** (`Library/` et `SystemData/` créés à cet instant), et la
**toute première lecture du magasin faite dans ce conteneur neuf rapporte déjà `environment=Xcode`**, à
`19:06:39Z`, 39 secondes plus tard.

**3. La bascule s'est produite entre le `2026-09-16 ~14:32 UTC` et le `19:06 UTC`.** Avant : le Gate 1 avait
mesuré sur ce même appareil `result.count=0`, `environment=(unavailable)`, `StoreKit.StoreKitError/2` — mesure
consignée dans `Docs/ReleaseGate1/02_STOREKIT_DEVICE_DIFFERENTIAL.md` et figée par le commit `565d2ca`
(`2026-09-16T16:32:41+02:00`).

**4. La seule action de scheme Xcode encore conservée ne concerne pas cet appareil.** Xcode a gardé une unique
action « Run Iris », `2026-09-16T20:53:47Z`, dont le résultat nomme sa destination :

```
deviceName  = "The Grey"
deviceId    = 00008130-000819961498001C
modelName   = iPhone 15 Pro
osVersion   = 26.6.1
```

C'est l'**iPhone 15 Pro**, et c'est **après** la bascule du 14 Pro. Ce n'est donc pas la cause.

**5. Aucun enregistrement local ne couvre la fenêtre utile.** Les journaux conservés par Xcode
(`Logs/Build`, `Logs/Test`, `Logs/Launch`) commencent tous le `2026-09-16` vers `20:00 UTC` ; ce qui est
antérieur a été purgé. Recherche faite dans `~/Library/Developer/Xcode` : les seuls fichiers « storekit »
récents sont des caches de modules du compilateur, sans rapport avec l'activation sur un appareil.

### Ce qui n'est pas prouvé

**La cause est NON DÉTERMINÉE.** Deux mécanismes restent compatibles avec les faits ci-dessus, et rien de
disponible localement ne permet de les départager :

| | Hypothèse | Ce qu'elle expliquerait |
|---|---|---|
| **A** | Une action « Run » depuis Xcode sur le 14 Pro vers `19:06 UTC`, avec la configuration StoreKit attachée au scheme — elle aurait à la fois réinstallé l'app (conteneur neuf) et activé l'environnement | le conteneur daté de `19:06` **et** l'environnement présent dès la première lecture |
| **B** | Un environnement de test **persistant au niveau de l'appareil**, établi plus tôt, ayant survécu à une réinstallation faite à `19:06` | les mêmes faits, exactement |

Départager A et B demanderait un enregistrement Xcode antérieur à `20:00 UTC` le 16 septembre — purgé — ou
l'observation directe de `Réglages → Développeur` sur l'appareil.

**Cette distinction n'est pas académique** : si B est vraie, désinstaller Iris **ne suffira pas**.

### Classification demandée par le mandat

```
A. configuration StoreKit attachée au lancement Xcode ... POSSIBLE, non prouvée
B. environnement de test persistant sur l'appareil ...... POSSIBLE, non prouvée
C. état associé à l'installation/build .................. ÉCARTÉ — la même build Debug,
                                                           installée par devicectl, donnait
                                                           (unavailable) au Gate 1
D. autre cause .......................................... non identifiée
E. CAUSE NON DÉTERMINÉE ................................. ← conclusion retenue
```

## Contrainte imposée par le mandat lui-même

L'étape la moins invasive de l'ordre de préférence — « supprimer uniquement l'association StoreKit/Xcode
responsable » — passe par le scheme : mettre **StoreKit Configuration** à `None` dans l'action *Run*, puis lancer
une fois depuis Xcode. Le §10 de ce mandat **interdit toute modification de scheme et de projet**.

Cette voie est donc fermée ici, et doit être signalée plutôt que contournée. Reste la voie côté appareil, qui
commence par une désinstallation — donc par une perte de données, donc par une autorisation.

## Données qui seraient détruites par une désinstallation

Inventaire réel, relevé dans le conteneur :

| Fichier | Contenu |
|---|---|
| `Library/Preferences/net.steve-s.iris.plist` (765 o) | **toutes** les préférences : progression de campagne (`iris.campaign.progress`), **profil de calibration du regard** (`iris.gaze.calibrationProfile`), sons, ambiance, vibrations, mode d'aide au regard, drapeaux d'introduction |
| `Documents/iris-storekit.log` (8 Ko) | les 33 lignes de mesure StoreKit — **la preuve même de ce Gate** |
| `Documents/iris-lifecycle.log` (13 Ko) | les mesures thermiques et mémoire du Gate 2 |

Le reste (caches Metal, instantanés d'écran, état de scène) se reconstruit seul.

**Une sauvegarde non destructive est techniquement possible** : `devicectl device copy from` sait extraire ces
trois fichiers. La **restauration** de la progression et de la calibration par `devicectl device copy to` est
plausible mais **non garantie** — `cfprefsd` met les préférences en cache, et un fichier réécrit sous
`Library/Preferences` n'est pas toujours relu. Les deux journaux, eux, se récupèrent à coup sûr, puisque rien ne
les relit.

## ACTION REQUIRED — en attente d'autorisation

Rien de ce qui suit n'a été fait.

### Étape 0 — sauvegarde (proposée, non exécutée)

Extraire les trois fichiers ci-dessus vers le Mac. Aucune écriture sur l'appareil, aucun risque.

### Étape 1 — désinstaller Iris du seul iPhone 14 Pro

```
xcrun devicectl device uninstall app --device CD9242BD-9650-52C9-BBA6-A30490C6DFA8 net.steve-s.iris
```

Supprime l'app **et tout son conteneur** : progression, calibration, préférences, les deux journaux.
Ne touche à rien d'autre sur le téléphone. Aucune donnée personnelle, aucun compte Apple.

### Étape 2 — redémarrer l'iPhone 14 Pro (si l'étape 4 montre que l'environnement persiste)

Redémarrage normal. Aucune perte de données.

### Étape 3 — réinstaller une build Debug par `devicectl`, jamais par Xcode

La build **Debug** est nécessaire : l'instrument de mesure `StoreDiagnostics` n'existe qu'en `#if DEBUG`. Une
build Release ne dirait rien. `devicectl` n'attache aucune configuration StoreKit, contrairement à l'action *Run*
d'Xcode.

### Étape 4 — mesurer

Lancer par `devicectl`, puis relire `Documents/iris-storekit.log`.

**Résultat recherché :** `appTransaction.environment` différent de `Xcode`.
`(unavailable)` avec `StoreKitError/2` et `result.count=0` serait un **succès** — c'est exactement ce que le
Gate 1 mesurait sur cet appareil, et c'est normal tant qu'App Store Connect n'est pas configuré.

**Ce ne serait pas** une validation de production. Voir §9 ci-dessous.

### Risque

Le risque réel n'est pas la casse : c'est que **l'étape 1 ne suffise pas**. Si l'hypothèse B est la bonne et que
l'environnement est attaché à l'appareil plutôt qu'à l'app, la désinstallation détruira les données sans rien
changer à `environment=Xcode`, et la seule voie restante passera par le scheme Xcode — que ce mandat interdit.

C'est pourquoi la sauvegarde de l'étape 0 est proposée avant tout le reste.

## Distinction des environnements — à ne pas confondre

| | Ce que ce serait |
|---|---|
| **Xcode StoreKit Configuration** | ce que le 14 Pro montre aujourd'hui : produits simulés, prix simulé |
| **StoreKit Test** (`SKTestSession`) | ce que les tests unitaires utilisent, sur simulateur |
| **Sandbox Apple** | un vrai compte de test Apple, de vrais produits App Store Connect |
| **Production** | l'App Store |
| **Non déterminé** | `(unavailable)` : aucun environnement n'a répondu |

Faire disparaître l'environnement Xcode ne prouve **rien** sur les trois autres. L'objectif de ce Gate 4A est
`CLEAN FOR REAL STOREKIT VALIDATION`, **pas** `PRODUCTION VERIFIED`.

## État à cet instant

```
ACTIONS MODIFICATRICES EXÉCUTÉES : aucune
IPHONE 15 PRO MODIFIÉ : NON (et déconnecté pendant toute la mission)
CODE PRODUIT MODIFIÉ : NON
CONFIGURATION DU PROJET MODIFIÉE : NON
GATE 4A : INTERROMPU — en attente d'autorisation humaine
```
