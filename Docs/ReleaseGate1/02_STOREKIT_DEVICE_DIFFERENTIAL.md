# 02 — StoreKit : différentiel iPhone 14 Pro / iPhone 15 Pro

Question : pourquoi l'iPhone 15 Pro affiche 2,99 € et la feuille d'achat de test, alors que l'iPhone 14 Pro affiche
« Le prix n'a pas pu être lu sur l'App Store » ?

---

## 1. Ce qui a été observé humainement (rapporté, non mesuré ici)

**OBSERVATION.** iPhone 15 Pro : paywall à 2,99 €, feuille StoreKit/Xcode de test, achat simulé réussi, message
indiquant explicitement un environnement de test.
**OBSERVATION.** iPhone 14 Pro : « Le prix n'a pas pu être lu sur l'App Store », bouton de déblocage indisponible.

## 2. L'instrument

Une instrumentation **DEBUG uniquement** a été ajoutée : `Commerce/Diagnostics/StoreDiagnostics.swift` (fichier
entier entre `#if DEBUG`). Elle écrit **une ligne sur la sortie standard** après chaque lecture du magasin, pour que
`devicectl … --console` puisse la capturer depuis un iPhone physique. Elle n'écrit ni Apple Account, ni jeton, ni
reçu, ni fragment de reçu.

Champs : modèle matériel (`sysctl hw.machine`), version d'iOS, version et build de l'app, bundle id, identifiants
demandés, nombre et identifiants retournés, type de chaque produit, prix d'affichage, domaine/code/description
d'erreur, droit courant, storefront (`Storefront.current`), environnement de transaction
(`AppTransaction.shared.environment` — c'est la valeur qui distingue `production`, `sandbox` et **`xcode`**).

## 3. Mesure réelle — iPhone 14 Pro

**MEASUREMENT**, 16 septembre 2026, build Debug identique installée par `devicectl` (donc **sans Xcode**), lancée par
`devicectl device process launch --console` :

```
IRIS-STOREKIT device.model=iPhone15,2 device.ios=26.5.2 app.version=1.0 app.build=1
  app.bundle=net.steve-s.iris app.configuration=DEBUG
  request.ids=net.steve-s.iris.access.promopass|net.steve-s.iris.unlock.fullgame
  result.count=0 result.ids= result.types= result.displayPrice=(none)
  entitlement=free
  error.domain=(none)
  storefront.country=FRA storefront.id=143442
  appTransaction.environment=(unavailable) appTransaction.error=StoreKit.StoreKitError/2
```

Trois faits s'en dégagent :

1. **`result.count=0` avec `error.domain=(none)`.** `Product.products(for:)` **n'a pas échoué** : elle a réussi et
   rendu une liste vide. C'est la réponse de l'App Store quand il ne connaît pas les identifiants demandés — ce
   n'est ni une panne réseau, ni un refus.
2. **Le storefront est lu normalement** (France, id 143442) : la connexion au magasin fonctionne.
3. **`AppTransaction.shared` est indisponible** (`StoreKitError` code 2 ; par l'ordre de déclaration du type dans le
   SDK — `unknown, userCancelled, networkError, systemError, notAvailableInStorefront, notEntitled, unsupported` —
   le code 2 correspond à `networkError`). Attendu : une build installée par `devicectl` n'a pas de reçu d'App
   Store à présenter.

## 4. Mesure réelle — avec une configuration StoreKit active

**MEASUREMENT.** Les mêmes identifiants, lus par le **même code**, sous une session de test StoreKit
(`SKTestSession`, suite `IrisTests/StoreKitEntitlementTests` exécutée sur un runtime iOS 18.6, 17 tests verts) :

- `Product.products(for:)` rend **2** produits ;
- `net.steve-s.iris.unlock.fullgame` est de type `nonConsumable` et porte un `displayPrice` non vide ;
- `net.steve-s.iris.access.promopass` est de type `autoRenewable`.

Donc : le code d'Iris lit correctement le magasin **dès qu'une source de produits existe**.

## 5. Mesure — iPhone 15 Pro

**UNKNOWN — non mesuré.** L'iPhone 15 Pro (« The Grey », `iPhone16,1`, iOS 26.6.1, UDID matériel
`00008130-000819961498001C`) était **verrouillé** pendant toute la fenêtre de mesure. Les deux tentatives ont
échoué avec l'erreur exacte du système :

```
FBSOpenApplicationServiceErrorDomain error 1 — RequestDenied
"Unable to launch net.steve-s.iris because the device was not, or could not be, unlocked."
Error Domain=com.apple.dt.deviceprep Code=-3 "Unlock The Grey to Continue"
```

La build instrumentée **est installée** sur l'appareil (conteneur `4C316378-C0AA-445A-A2D0-ABABB9D8F08B`) : il ne
manque que le déverrouillage. Commande à rejouer, telle quelle :

```sh
xcrun devicectl device process launch --console \
  --device 21ABC186-DEFC-59C7-9671-85E4FA69DA9A --terminate-existing net.steve-s.iris
# puis, dans la sortie :  grep IRIS-STOREKIT
```

## 6. Matrice

| | iPhone 14 Pro | iPhone 15 Pro |
|---|---|---|
| MODEL IDENTIFIER | `iPhone15,2` **(mesuré)** | `iPhone16,1` **(mesuré, `devicectl info details`)** |
| iOS | 26.5.2 (23F84) **(mesuré)** | 26.6.1 (23G83) **(mesuré)** |
| BUILD Iris | 1.0 (1), Debug, `527b9ae` + instrumentation | identique, installée |
| INSTALL METHOD | `devicectl device install app` | `devicectl device install app` |
| SCHEME | aucun (lancement hors Xcode) | aucun (lancement hors Xcode) |
| CONFIGURATION | Debug | Debug |
| STOREKIT CONFIG FILE | **aucune** | **aucune** |
| PRODUCT REQUEST | 2 identifiants | *non mesuré (appareil verrouillé)* |
| PRODUCT RETURNED | **0** | *non mesuré* |
| DISPLAY PRICE | **(none)** | *non mesuré* |
| PURCHASE SHEET | non atteignable (bouton désactivé) | *non mesuré* |
| ENTITLEMENT | `free` | *non mesuré* |
| ERROR | **aucune** (liste vide, succès) | *non mesuré* |
| STOREFRONT | FRA / 143442 | *non mesuré* |

## 7. Le mécanisme, établi par le dépôt

**FACT.** La configuration StoreKit locale n'est attachée qu'à **une seule action** du schéma. Vérifié sur le schéma
généré :

| Action du schéma | `StoreKitConfigurationFileReference` |
|---|---|
| LaunchAction (Run) | **OUI** → `../../Config/Iris.storekit` |
| TestAction | non |
| ProfileAction | non |
| AnalyzeAction | non |
| ArchiveAction | non |

**FACT.** Un lancement par `devicectl`, depuis l'écran d'accueil, par TestFlight ou par l'App Store n'utilise
aucune action de schéma : la configuration StoreKit locale ne s'applique donc pas. Seul **Xcode → Run** l'applique.

**FACT (corrigé dans cette mission).** `project.yml` déclarait aussi `storeKitConfiguration` sous `test:`.
XcodeGen 2.45.4 **ignore silencieusement** cette clé : le TestAction généré n'en porte aucune. Le commentaire qui
affirmait le contraire était faux ; il a été remplacé par l'observation exacte. Les tests StoreKit n'en dépendent
pas : ils activent le test eux-mêmes avec `SKTestSession(contentsOf:)`.

## 8. Cause

**CAUSE RACINE : PROUVÉE pour l'appareil 14 Pro, INFÉRÉE pour la différence entre les deux appareils.**

Ce qui est **prouvé** :

- sur l'iPhone 14 Pro, lancé hors Xcode, le magasin répond **succès avec zéro produit** — l'App Store ne connaît pas
  ces identifiants dans cet environnement ;
- le même code rend 2 produits et un prix dès qu'une configuration StoreKit est active ;
- la configuration StoreKit d'Iris n'est branchée que sur l'action Run de Xcode ;
- aucun produit n'a jamais été créé dans App Store Connect (registre de la mission 9 ; aucun accès à App Store
  Connect n'a été utilisé depuis cette machine, ni alors ni maintenant).

Ce qui est **inféré**, faute de la mesure sur le 15 Pro : que l'iPhone 15 Pro affichait 2,99 € **parce qu'il avait
été lancé depuis Xcode**, donc avec `Config/Iris.storekit` actif. L'observation humaine le soutient fortement —
« la feuille StoreKit/Xcode de test apparaît » et « le message indique explicitement un environnement de test » sont
la signature exacte du test StoreKit, qui sur un appareil n'existe que lancé par Xcode. Mais tant que la ligne
`IRIS-STOREKIT` du 15 Pro n'est pas capturée, **ce n'est pas une preuve**.

**Ce qui n'est PAS la cause, et peut être écarté :**

| Hypothèse | Statut |
|---|---|
| Le matériel du 14 Pro | **écartée** : la lecture du magasin ne dépend d'aucune capacité matérielle, et le storefront a répondu normalement |
| Un défaut réseau sur le 14 Pro | **écartée par mesure** : `Storefront.current` a répondu (FRA/143442) et `Product.products` n'a pas levé d'erreur |
| Un bundle identifier différent | **écartée par mesure** : `app.bundle=net.steve-s.iris` sur le 14 Pro, et l'inventaire des apps montre le même identifiant sur les deux |
| Un code Iris différent entre les deux appareils | **écartée** : la même build a été installée sur les deux |
| Une différence de version d'iOS (26.5.2 / 26.6.1) | **non écartée mais improbable** : aucune mesure ne l'implique ; elle deviendra vérifiable dès la capture du 15 Pro |

## 9. Ce qui reste inconnu

1. **La ligne `IRIS-STOREKIT` de l'iPhone 15 Pro** — appareil verrouillé. Commande au §5.
2. **L'état réel des produits dans App Store Connect.** Aucun accès n'a été utilisé. Si les produits y avaient été
   créés et approuvés depuis la mission 9, un appareil sans configuration locale pourrait les recevoir — ce que le
   14 Pro n'a pas fait, ce qui est cohérent avec « non créés », sans le prouver.
3. **Aucun compte de bac à sable n'a été vérifié** : `AppTransaction` était indisponible sur le 14 Pro, et Iris ne
   lit jamais l'Apple Account.

## 10. Conséquence pour la publication

**INFERENCE, faible risque :** rien n'indique un défaut dans Iris. Le comportement du 14 Pro est exactement celui
prévu et testé pour « le magasin ne connaît pas encore les produits » : prix inconnu, bouton d'achat désactivé,
message explicite, **et les trois chapitres gratuits restent ouverts** (couvert par
`StoreKitEntitlementTests` → « when the store cannot be reached the price is unknown, the free chapters stay open »).

La vraie levée du doute est une action App Store Connect, pas une correction de code : créer les produits, puis
observer un achat en bac à sable sur un appareil **sans** Xcode.
