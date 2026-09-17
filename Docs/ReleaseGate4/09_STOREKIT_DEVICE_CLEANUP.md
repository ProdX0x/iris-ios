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

---

# Gate 4A — test contrôlé « StoreKit Configuration = None »

Autorisé et exécuté le 17 septembre 2026. **Résultat : CAS B — l'environnement Xcode n'a pas disparu.**

| | |
|---|---|
| Branche | `release/iris-appstore-rc1` |
| HEAD au départ | `03fab79af9c766b060eb61fbf4161453940df1ae` |
| Appareil testé | iPhone 14 Pro, `00008120-0016341A2187C01E`, iOS 26.5.2 |
| iPhone 15 Pro | **déconnecté pendant toute la mission — aucune action, aucune tentative de reconnexion** |

## 1. Sauvegarde de précaution

Hors du dépôt Git, dans `/Volumes/Steve Pro BlackSSD/Dev/App Mobile/.iris-gate4a-backup/` :

| Fichier | Taille | SHA-256 |
|---|---|---|
| `net.steve-s.iris.plist` | 765 o | `c8aa57c7e0dfdd31740b4d975289a3f0d18502fe3bcdeaa3a7dc2a81621dbdcc` |
| `iris-storekit.log` | 8 162 o | `0760015878dc9cf00e0a19ee82f1a017dfccd683b904457da42d1244f39c66e4` |
| `iris-lifecycle.log` | 13 192 o | `6bd37badfc1502e744b4380f7e973d388153a266f189b1f0245104a2c9a2c63a` |
| `Iris.xcscheme.ORIGINAL` | 4 595 o | `56d1db6ce21194f31dcee60b15e91dbe51d027adbc769b2f4f9f75fa1e074756` |

Rien n'a été restauré, rien n'a été supprimé, rien n'a été modifié sur l'appareil pendant la sauvegarde.

**Ce que la sauvegarde des préférences contient réellement** — et c'est une bonne nouvelle :

```
iris.gaze.calibrationProfile        ← le profil de calibration
iris.gazeAssistance                 ← le mode d'aide au regard
iris.onboarding.completed
iris.onboarding.gazeIntroduction
SKTransactionUpdatesLastChecked     ← géré par StoreKit
```

**`iris.campaign.progress` est absent** : aucune progression de campagne n'est enregistrée sur cet iPhone. Ce qui
serait perdu par une désinstallation est donc plus petit que ce que le premier inventaire laissait craindre — la
calibration et les réglages, pas des heures de jeu.

## 2. Le scheme

| | |
|---|---|
| Chemin | `Iris.xcodeproj/xcshareddata/xcschemes/Iris.xcscheme` |
| Stockage | **xcshareddata** |
| Suivi Git | **suivi**, non ignoré — `git diff` est donc ici une vérification valable, en plus du hash |
| SHA-256 avant | `56d1db6ce21194f31dcee60b15e91dbe51d027adbc769b2f4f9f75fa1e074756` |

État initial, lignes 93-95, dans `<LaunchAction>` :

```xml
<StoreKitConfigurationFileReference
   identifier = "../../Config/Iris.storekit">
</StoreKitConfigurationFileReference>
```

**Modification temporaire** : suppression de ces trois lignes — c'est ainsi que « None » se représente.
SHA-256 pendant le test : `c9758e9920dffb1af45bbfd33596fdd9e1d0f262dd0e25c9849f58c00b96c9e0`.

Vérifié en cours de build : Xcode **n'a pas réécrit** le fichier, l'édition est restée en place tout du long.

## 3. Le lancement

Piloté par AppleScript avec une destination explicite, pour ne dépendre d'aucune sélection d'interface :

```applescript
debug doc scheme "Iris" run destination specifier "platform=iOS,id=00008120-0016341A2187C01E"
```

Xcode a enregistré ce run, et son propre compte rendu nomme la destination :

```
Run-Iris-2026.09.17_14-41-07-+0200.xcresult
deviceName = "iPhone Steve."   modelName = iPhone 14 Pro
deviceId   = 00008120-0016341A2187C01E
status     = succeeded
```

**Le conteneur a été intégralement préservé** : le journal est passé de 33 à 36 lignes — trois lignes ajoutées,
aucune perdue — et les cinq préférences sont toujours là, calibration comprise. La session de débogage a ensuite
été arrêtée proprement ; Iris ne tourne plus.

## 4. La mesure

`2026-09-17T12:45:50Z`, après le lancement contrôlé :

| | |
|---|---|
| `appTransaction.environment` | **`Xcode`** (verified=yes) |
| `result.count` | 2 |
| `result.ids` | `net.steve-s.iris.access.promopass` · `net.steve-s.iris.unlock.fullgame` |
| `result.displayPrice` | 2,99 € |
| `entitlement` | `free` |
| `storefront` | FRA / 143442 |
| erreurs | aucune (`error.domain=(none)`) |

Rigoureusement identique aux onze lectures précédentes.

## 5. Restauration

```
SHA-256 après  : 56d1db6ce21194f31dcee60b15e91dbe51d027adbc769b2f4f9f75fa1e074756
SHA-256 avant  : 56d1db6ce21194f31dcee60b15e91dbe51d027adbc769b2f4f9f75fa1e074756
identiques     : OUI
```

Les trois lignes `StoreKitConfigurationFileReference` sont de retour aux lignes 93-95. `git diff` est vide, et
`git status` ne montre que les trois fichiers non suivis qui préexistaient à toute cette mission.

## 6. Ce que ce test prouve, et ce qu'il ne prouve pas

**PROVEN.** Un lancement depuis Xcode sur l'iPhone 14 Pro, le scheme sur disque portant « None », n'a pas fait
disparaître `appTransaction.environment=Xcode`. Le run a bien eu lieu sur le bon appareil — Xcode le consigne
lui-même — et la mesure qui a suivi est inchangée.

**NOT PROVEN — et il faut le dire.** Rien ne démontre qu'Xcode ait relu mon édition du fichier. Xcode était
ouvert sur le projet pendant tout le test ; il a pu servir une version du scheme gardée en mémoire. Deux lectures
restent donc possibles :

| | Lecture | Ce qu'elle impliquerait |
|---|---|---|
| **B1** | Xcode a bien appliqué « None », et l'environnement a survécu | l'état est persistant, hors du scheme |
| **B2** | Xcode a utilisé un scheme en cache portant encore la configuration | le run a **ré-affirmé** l'environnement, et le test n'aura rien montré |

**Trois tentatives pour départager B1 et B2 ont échoué**, et il faut le consigner plutôt que de conclure :

- le `.xcresult` du run ne mentionne pas StoreKit — mais **le run du 16 septembre non plus**, alors qu'il portait
  la configuration. Contrôle négatif : cette absence ne prouve rien ;
- les deux journaux de build contiennent exactement une occurrence « storekit », **identique dans les deux** : une
  section de compilation, sans rapport avec la configuration ;
- aucun outil en ligne de commande ne sait lire ni écrire cet état : ni `devicectl`, ni `simctl` n'ont de
  sous-commande StoreKit.

**Statut de la cause racine : NOT PROVEN.** L'hypothèse d'un état persistant au niveau de l'appareil est
**renforcée** par ce test, sans être établie — parce que B2 n'a pas pu être écartée.

Ce que ce test n'établit toujours pas : où réside cet état, par quel mécanisme, et si une désinstallation le
supprimerait.

## 7. État à l'arrêt

```
IRIS DÉSINSTALLÉ : NON
APPAREIL REDÉMARRÉ : NON
DONNÉES SUPPRIMÉES : NON
ENVIRONNEMENT STOREKIT RÉINITIALISÉ : NON
SCHEME : restauré à l'identique, hash vérifié
CODE PRODUIT MODIFIÉ : NON
IPHONE 15 PRO : non connecté, non touché
PRODUCTION VERIFIED : NON — et rien dans ce test n'y touche
```

La mission s'arrête ici, conformément au CAS B.

---

# Gate 4A — test à froid : Xcode fermé avant la modification du scheme

Exécuté le 17 septembre 2026. **Résultat : CAS A — l'environnement Xcode a disparu.**

Le test précédent était ambigu : Xcode était ouvert pendant la modification et pouvait servir un scheme gardé en
mémoire. Cette reprise élimine cette ambiguïté en fermant Xcode **avant** de toucher au fichier.

## Déroulé, dans l'ordre

| | Étape | Vérification |
|---|---|---|
| 1 | État de départ | branche `release/iris-appstore-rc1`, HEAD `cfdd70b`, arbre propre, sauvegarde intacte (`56d1db6…`) |
| 2 | iPhone 14 Pro | « iPhone Steve. », `00008120-0016341A2187C01E`, iOS 26.5.2, disponible, déverrouillé |
| 3 | **Xcode fermé** | quitté par AppleScript, **fermé en ~2 s, sans dialogue** ; aucun processus `Xcode`, aucun `XCBBuildService`, aucun `SourceKitService` |
| 4 | Scheme vérifié à froid | hash `56d1db6…`, **byte-identique** à la sauvegarde, référence `Iris.storekit` présente aux lignes 93-95 |
| 5 | **Modification à froid** | suppression des trois lignes ; hash `c9758e99…` ; `git diff` ne contient **que** cette suppression |
| 6 | Xcode rouvert | `open -a Xcode Iris.xcodeproj` ; chargé, scheme actif « Iris » ; l'édition **intacte** sur disque |
| 7 | Run contrôlé | destination explicite `platform=iOS,id=00008120-0016341A2187C01E` |
| 8 | Mesure | voir ci-dessous |
| 9 | Restauration | Xcode fermé, fichier restauré depuis la sauvegarde |

## La mesure — et elle change tout

`2026-09-17T13:47:04Z` à `13:47:12Z`, les trois lignes produites par **ce** run :

```
result.count=0   result.ids=   result.types=   result.displayPrice=(none)
entitlement=free   error.domain=(none)
storefront.country=FRA   storefront.id=143442
appTransaction.environment=(unavailable)
appTransaction.error=StoreKit.StoreKitError/2
appTransaction.errorDescription=unknown
```

À comparer aux douze lectures précédentes, toutes identiques entre elles :

| | Avant (16 sept. 19:06 → 17 sept. 12:48) | **Après le test à froid** |
|---|---|---|
| `appTransaction.environment` | `Xcode`, verified=yes | **`(unavailable)`** |
| erreur | aucune | `StoreKit.StoreKitError/2` |
| `result.count` | 2 | **0** |
| `result.displayPrice` | 2,99 € | **(none)** |
| storefront | FRA / 143442 | FRA / 143442 — inchangé |

C'est **exactement** la signature que le Gate 1 avait mesurée sur cet appareil avant la contamination.

## Ce que cela établit

**STRONGLY SUPPORTED : le test précédent était contaminé par un scheme conservé en mémoire par Xcode.**
La seule différence entre les deux tests est l'ordre des opérations — Xcode ouvert pendant l'édition, puis Xcode
fermé pendant l'édition — et le résultat bascule complètement. Ce n'est pas `PROVEN` au sens causal strict : rien
n'a permis de lire directement le scheme qu'Xcode tenait en mémoire lors du premier test.

**Par voie de conséquence, l'hypothèse B — un état StoreKit persistant au niveau de l'appareil — tombe.**
L'environnement suivait la configuration StoreKit attachée à l'action *Run* du scheme. Un lancement avec « None »
le fait disparaître. Aucune désinstallation, aucun redémarrage, aucune suppression de données n'aura été
nécessaire.

**ROOT CAUSE STATUS : STRONGLY SUPPORTED.** Le mécanisme est maintenant clair : un lancement depuis Xcode avec
`Config/Iris.storekit` attaché au scheme installe l'environnement de test sur l'appareil, et il y reste jusqu'au
prochain lancement fait avec « None ». Ce qui reste **NOT PROVEN**, faute d'enregistrement — Xcode avait purgé les
siens — c'est *quand* et *par qui* ce premier lancement a eu lieu sur le 14 Pro entre le Gate 1 et le
16 septembre 19:06 UTC.

## Restauration et intégrité

```
hash original : 56d1db6ce21194f31dcee60b15e91dbe51d027adbc769b2f4f9f75fa1e074756
hash final    : 56d1db6ce21194f31dcee60b15e91dbe51d027adbc769b2f4f9f75fa1e074756
identiques    : OUI
byte-compare avec la sauvegarde : IDENTIQUE
référence Iris.storekit : restaurée aux lignes 93-95
git diff : vide
git status : seuls les trois fichiers non suivis préexistants
```

Une confirmation d'Xcode a bloqué la fermeture — « Are you sure you want to close the Project "Iris"? Closing this
workspace will stop the task "Run Iris" », boutons *Cancel* / *Stop Tasks*. Ce n'est pas une autorisation système
mais une confirmation applicative, cliquable par script ; la tâche visée était déjà terminée (`succeeded`, Iris
plus en cours sur l'appareil). *Stop Tasks* a été cliqué pour achever la fermeture demandée. Xcode s'est fermé en
4 secondes, et la restauration a eu lieu ensuite, à froid.

## Aucune donnée perdue

```
Iris désinstallé : NON      appareil redémarré : NON
conteneur effacé : NON      journal : 39 → 42 lignes, trois ajoutées, aucune perdue
préférences intactes : iris.gaze.calibrationProfile ✓  iris.gazeAssistance ✓
                       iris.onboarding.completed ✓     iris.onboarding.gazeIntroduction ✓
iPhone 15 Pro : non connecté, aucune commande ne l'a visé
code produit / Info.plist / entitlements / Iris.storekit / Product IDs : inchangés
```

## L'iPhone 14 Pro est propre — et fragile

`appTransaction.environment=(unavailable)` : aucune trace d'environnement StoreKit simulé.

**Zéro produit et aucun prix sont le résultat attendu**, pas un échec : App Store Connect n'est pas configuré, et
c'est précisément ce qu'un client verrait aujourd'hui.

`CLEAN FOR REAL STOREKIT VALIDATION : OUI`
`PRODUCTION VERIFIED : NON` — et rien ici ne s'en approche.

**Le point de vigilance.** Le scheme porte de nouveau `Config/Iris.storekit`. **Le prochain « Run » d'Iris depuis
Xcode sur le 14 Pro le recontaminera immédiatement.** Pour garder cet appareil comme témoin : l'installer
uniquement par `devicectl` — c'est ce que le Gate 1 faisait — ou mettre StoreKit Configuration à `None` avant tout
lancement depuis Xcode vers lui. Le 15 Pro reste l'appareil de développement, avec son environnement simulé.
