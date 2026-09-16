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

Ce qui est **PROUVÉ** par cette mesure, et rien de plus :

1. **`Product.products(for:)` s'est terminée avec succès et a rendu zéro produit**, en dehors de la configuration
   StoreKit locale. `error.domain=(none)` : aucune erreur n'a été levée. Ce n'est ni une panne, ni un refus, ni un
   délai dépassé.
2. **Le storefront est lu normalement** : France, identifiant 143442. La liaison au magasin fonctionne.
3. **`AppTransaction.shared` est indisponible** : `StoreKit.StoreKitError`, code 2,
   `appTransaction.errorDescription=unknown` — donc le cas **`.unknown`**.

**Correction d'une inférence antérieure.** Une version antérieure de ce document déduisait « code 2 =
`networkError` » de l'ordre de déclaration du type dans le SDK. La description mesurée dit `unknown` : la
numérotation NSError de `StoreKitError` ne suit pas l'ordre de déclaration. L'inférence était fausse et est retirée.

**Ce qui N'EST PAS prouvé, et n'est donc plus écrit ici :** que « l'App Store ne connaît pas ces identifiants ».
Une liste vide est *compatible* avec cette explication, mais elle l'est aussi avec d'autres. Seul App Store Connect,
ou une autre source Apple faisant autorité, pourrait l'établir — et aucun accès n'a été utilisé. Statut :
**NOT DETERMINED**.

## 4. Mesure réelle — avec une configuration StoreKit active

**MEASUREMENT.** Les mêmes identifiants, lus par le **même code**, sous une session de test StoreKit
(`SKTestSession`, suite `IrisTests/StoreKitEntitlementTests` exécutée sur un runtime iOS 18.6, 17 tests verts) :

- `Product.products(for:)` rend **2** produits ;
- `net.steve-s.iris.unlock.fullgame` est de type `nonConsumable` et porte un `displayPrice` non vide ;
- `net.steve-s.iris.access.promopass` est de type `autoRenewable`.

Donc : le code d'Iris lit correctement le magasin **dès qu'une source de produits existe**.

## 5. Mesure réelle — iPhone 15 Pro

**MEASUREMENT**, 16 septembre 2026, **même binaire**, **même méthode de lancement** (`devicectl`, donc **hors
Xcode**), rapport récupéré dans le conteneur de l'application :

```
IRIS-STOREKIT device.model=iPhone16,1 device.ios=26.6.1 app.version=1.0 app.build=1
  app.bundle=net.steve-s.iris app.configuration=DEBUG
  request.ids=net.steve-s.iris.access.promopass|net.steve-s.iris.unlock.fullgame
  result.count=2
  result.ids=net.steve-s.iris.access.promopass|net.steve-s.iris.unlock.fullgame
  result.types=net.steve-s.iris.access.promopass=Auto-Renewable Subscription
              |net.steve-s.iris.unlock.fullgame=Non-Consumable
  result.displayPrice=2,99 €
  entitlement=fullAccess
  error.domain=(none)
IRIS-STOREKIT device.model=iPhone16,1 storefront.country=FRA storefront.id=143442
IRIS-STOREKIT device.model=iPhone16,1 appTransaction.environment=Xcode appTransaction.verified=yes
```

Deux relevés indépendants (16:26:56 et 16:29:29 UTC+2) donnent le même résultat.

**La ligne décisive est la troisième :** `appTransaction.environment=**Xcode**`, vérifiée. `AppStore.Environment`
ne prend que trois valeurs — `production`, `sandbox`, `xcode`. L'appareil tourne donc dans un **environnement de
test StoreKit**, et le 14 Pro n'en a aucun (`(unavailable)`).

**Correction d'une inférence antérieure, et elle est importante.** Ce document supposait que le 15 Pro affichait le
prix « parce qu'il était lancé depuis Xcode ». C'est mécaniquement faux : ce lancement-ci s'est fait par
`devicectl`, sans Xcode, et le prix est apparu quand même. Ce que la mesure établit est plus précis :
**l'environnement de test StoreKit persiste sur l'appareil** une fois qu'Xcode l'y a installé, et s'applique aux
lancements suivants, quelle qu'en soit l'origine. C'est un état de l'appareil, pas un état du lancement.

`entitlement=fullAccess` est cohérent avec l'achat simulé réussi rapporté par l'utilisateur : le droit acquis dans
cet environnement de test y persiste lui aussi.

## 6. Matrice

Les deux appareils portent **le même binaire** : `Iris.debug.dylib` SHA-256 `64968a8e660b0cefdfc69e0338d24e04…`,
installé par la même commande `devicectl device install app`, lancé par la même commande `devicectl device process
launch`. Aucune des deux exécutions ne passe par Xcode.

| | iPhone 14 Pro | iPhone 15 Pro |
|---|---|---|
| MODEL IDENTIFIER | `iPhone15,2` — MEASURED | `iPhone16,1` — MEASURED |
| iOS | 26.5.2 (23F84) — MEASURED | 26.6.1 (23G83) — MEASURED |
| BUILD Iris | 1.0 (1) Debug, même dylib — CONTROLLED | 1.0 (1) Debug, même dylib — CONTROLLED |
| INSTALL METHOD | `devicectl device install app` — CONTROLLED | identique — CONTROLLED |
| LAUNCH METHOD | `devicectl`, hors Xcode — CONTROLLED | identique — CONTROLLED |
| CONFIGURATION | Debug — MEASURED | Debug — MEASURED |
| **STOREKIT TEST ENVIRONMENT** | **aucun** (`appTransaction.environment=(unavailable)`) — MEASURED | **`Xcode`**, vérifié — MEASURED |
| PRODUCT REQUEST | 2 identifiants — MEASURED | 2 identifiants — MEASURED |
| **PRODUCTS RETURNED** | **0** — MEASURED | **2** — MEASURED |
| PRODUCT TYPES | — | `Non-Consumable` + `Auto-Renewable Subscription` — MEASURED |
| **DISPLAY PRICE** | **(none)** — MEASURED | **2,99 €** — MEASURED |
| ENTITLEMENT | `free` — MEASURED | `fullAccess` — MEASURED |
| ERROR | aucune — MEASURED | aucune — MEASURED |
| STOREFRONT | FRA / 143442 — MEASURED | FRA / 143442 — MEASURED |

### Environnement d'exécution identique ?

```
EXECUTION ENVIRONMENT IDENTICAL: NO   (MEASURED)
```

**Ce qui est identique, et vérifié :** le binaire, la méthode d'installation, la méthode de lancement, la
configuration de compilation, le storefront (France / 143442).

**Ce qui diffère, et c'est la seule différence pertinente mesurée :** le 15 Pro porte un **environnement de test
StoreKit persistant** (`Xcode`), le 14 Pro n'en a aucun.

Deux différences secondaires subsistent, sans effet démontré : la version d'iOS (26.5.2 / 26.6.1) et l'état de
session App Store de chaque appareil.

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

```
STOREKIT DIFFERENCE ROOT CAUSE: PROVEN
```

**La cause est un environnement de test StoreKit persistant sur l'iPhone 15 Pro, absent de l'iPhone 14 Pro.**

Le raisonnement tient en quatre mesures, toutes faites avec le **même binaire** et la **même méthode de lancement** :

| # | Mesure | Appareil |
|---|---|---|
| 1 | `appTransaction.environment=Xcode`, vérifié → 2 produits, `displayPrice=2,99 €` | 15 Pro |
| 2 | `appTransaction.environment=(unavailable)` → 0 produit, aucune erreur | 14 Pro |
| 3 | Storefront identique des deux côtés : France / 143442 | les deux |
| 4 | Le même code rend 2 produits sous `SKTestSession` (17 tests verts) | simulateur |

La variable explicative est isolée : **tout le reste est contrôlé et identique**, seul l'environnement StoreKit
diffère, et il suffit à expliquer l'écart dans les deux sens.

**Ce que la mesure a corrigé.** L'hypothèse antérieure — « le 15 Pro affiche le prix parce qu'il est lancé depuis
Xcode » — est **fausse dans sa mécanique**. Le 15 Pro a ici été lancé par `devicectl`, sans Xcode, et a quand même
vu les produits. L'environnement de test StoreKit **persiste sur l'appareil** après qu'Xcode l'y a installé : c'est
un état de l'appareil, pas un état du lancement. La conclusion pratique change : **désinstaller Iris du 15 Pro, ou
purger son environnement de test, est nécessaire avant toute validation représentative d'un utilisateur réel.**

### Ce qui reste NOT DETERMINED

- **Que l'App Store « ne connaisse pas » ces identifiants.** Le 14 Pro rend une liste vide sans erreur : c'est
  compatible avec cette explication, et avec d'autres. Seuls App Store Connect ou une autre source Apple faisant
  autorité trancheraient ; aucun accès n'a été utilisé. La mesure du 15 Pro ne l'éclaire pas, puisque ses deux
  produits viennent de la configuration locale, pas de l'App Store.
- **Le comportement en production** : aucun des deux appareils n'a interrogé l'App Store réel pour ces produits.

### Ce qui est ÉCARTÉ PAR MESURE

| Hypothèse | Pourquoi elle tombe |
|---|---|
| Le matériel du 14 Pro | même binaire, même méthode ; le 14 Pro lit le storefront sans erreur, et le 15 Pro n'a rien de matériellement différent qui touche StoreKit |
| Un défaut réseau sur le 14 Pro | `Storefront.current` a répondu ; `Product.products` n'a levé aucune erreur |
| Un bundle identifier différent | `net.steve-s.iris` mesuré des deux côtés |
| Un code Iris différent | **même dylib**, empreinte SHA-256 identique |
| La version d'iOS | non écartée formellement, mais l'environnement StoreKit suffit à expliquer l'écart : aucune mesure n'appelle une seconde cause |

### Conséquence pour Iris

**Aucun défaut d'Iris n'est en cause.** Le comportement du 14 Pro est exactement celui qui est spécifié et testé
quand le magasin ne fournit aucun produit : prix inconnu, achat désactivé, message explicite, **et les trois
chapitres gratuits restent ouverts**. Le comportement du 15 Pro est celui attendu quand des produits existent.

## 9. Ce qui reste inconnu

1. **L'état réel des produits dans App Store Connect.** Aucun accès n'a été utilisé. C'est la seule chose qui
   dirait ce qu'un appareil sans environnement de test recevra en production.
2. **Le comportement en bac à sable**, sur un appareil **sans** environnement de test StoreKit, une fois les
   produits créés. C'est la validation qui compte pour la publication.
3. **Aucun compte de bac à sable n'a été vérifié** : Iris ne lit jamais l'Apple Account, et `AppTransaction` était
   indisponible sur le 14 Pro.

## 10. Conséquence pour la publication

**INFERENCE, faible risque :** rien n'indique un défaut dans Iris. Le comportement du 14 Pro est exactement celui
prévu et testé pour « le magasin ne connaît pas encore les produits » : prix inconnu, bouton d'achat désactivé,
message explicite, **et les trois chapitres gratuits restent ouverts** (couvert par
`StoreKitEntitlementTests` → « when the store cannot be reached the price is unknown, the free chapters stay open »).

La vraie levée du doute est une action App Store Connect, pas une correction de code : créer les produits, puis
observer un achat en bac à sable sur un appareil **sans** Xcode.
