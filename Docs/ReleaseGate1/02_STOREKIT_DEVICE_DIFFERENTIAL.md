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

## 5. Mesure — iPhone 15 Pro

**NOT DETERMINED — non mesuré.** L'iPhone 15 Pro (« The Grey », `iPhone16,1`, iOS 26.6.1, identifiant CoreDevice
`21ABC186-DEFC-59C7-9671-85E4FA69DA9A`, UDID matériel `00008130-000819961498001C`) n'a pas pu être mesuré.

**Cause, mesurée et non supposée :**

```
xcrun devicectl device info lockState --device 21ABC186-DEFC-59C7-9671-85E4FA69DA9A
→ passcodeRequired: true      unlockedSinceBoot: true

(pour comparaison, au même instant)
xcrun devicectl device info lockState --device CD9242BD-9650-52C9-BBA6-A30490C6DFA8
→ passcodeRequired: false     unlockedSinceBoot: true
```

L'écran du 15 Pro est verrouillé. iOS refuse alors tout lancement d'application :

```
FBSOpenApplicationServiceErrorDomain error 1 — RequestDenied — BSErrorCodeDescription = Locked
"Unable to launch net.steve-s.iris because the device was not, or could not be, unlocked."
```

Plus de cinquante tentatives ont été faites sur environ trente minutes ; **une seule** a réussi, immédiatement après
un déverrouillage humain, avant que le verrouillage automatique ne reprenne. La build instrumentée **est installée**
(conteneur `762A6828-119D-4F75-8B7E-5F73561F64EB`), et son répertoire `Documents` a été relu : **il est vide**,
l'application n'y a jamais été lancée avec cette build.

**Ce qui n'est pas bloquant :** la lecture de fichiers sur l'appareil fonctionne **même verrouillé**
(`unlockedSinceBoot: true`). Un **seul** lancement suffit donc : l'instrument écrit son rapport dans le conteneur, et
le fichier peut être récupéré ensuite à tout moment.

### Procédure exacte, à exécuter une fois l'écran déverrouillé

```sh
# 1. déverrouiller l'écran de l'iPhone 15 Pro et le garder allumé
xcrun devicectl device info lockState --device 21ABC186-DEFC-59C7-9671-85E4FA69DA9A   # attendre passcodeRequired: false

# 2. lancer l'application (une seule fois suffit)
xcrun devicectl device process launch \
  --device 21ABC186-DEFC-59C7-9671-85E4FA69DA9A --terminate-existing net.steve-s.iris

# 3. récupérer le rapport — fonctionne ensuite même écran verrouillé
mkdir -p /tmp/iris-pull
xcrun devicectl device copy from --device 21ABC186-DEFC-59C7-9671-85E4FA69DA9A \
  --domain-type appDataContainer --domain-identifier net.steve-s.iris \
  --source Documents/iris-storekit.log --destination /tmp/iris-pull/15Pro-storekit.log
cat /tmp/iris-pull/15Pro-storekit.log
```

## 6. Matrice

Les deux appareils portent **le même binaire** : `Iris.debug.dylib` SHA-256 `64968a8e660b0cefdfc69e0338d24e04…`,
installé par la même commande `devicectl device install app`.

| | iPhone 14 Pro | iPhone 15 Pro |
|---|---|---|
| MODEL IDENTIFIER | `iPhone15,2` — **MEASURED** | `iPhone16,1` — **MEASURED** |
| iOS | 26.5.2 (23F84) — **MEASURED** | 26.6.1 (23G83) — **MEASURED** |
| BUILD Iris | 1.0 (1) Debug, même dylib — **CONTROLLED** | 1.0 (1) Debug, même dylib — **CONTROLLED** |
| INSTALL METHOD | `devicectl device install app` — **CONTROLLED** | `devicectl device install app` — **CONTROLLED** |
| SCHEME | aucun (lancé hors Xcode) — **MEASURED** | **NOT DETERMINED** (jamais lancé avec cette build) |
| CONFIGURATION | Debug — **MEASURED** (`app.configuration=DEBUG`) | **NOT DETERMINED** |
| STOREKIT CONFIG FILE | aucune — **MEASURED** | **NOT DETERMINED** |
| PRODUCT REQUEST | 2 identifiants — **MEASURED** | **NOT DETERMINED** |
| PRODUCTS RETURNED | **0** — **MEASURED** | **NOT DETERMINED** |
| DISPLAY PRICE | **(none)** — **MEASURED** | **NOT DETERMINED** |
| PURCHASE SHEET | non atteignable (bouton désactivé) — **MEASURED** | **NOT DETERMINED** |
| ENTITLEMENT | `free` — **MEASURED** | **NOT DETERMINED** |
| ERROR | aucune — **MEASURED** | **NOT DETERMINED** |
| STOREFRONT | FRA / 143442 — **MEASURED** | **NOT DETERMINED** |
| APP TRANSACTION ENV. | `(unavailable)`, `StoreKitError` code 2 = `unknown` — **MEASURED** | **NOT DETERMINED** |

### Environnement d'exécution identique ?

```
EXECUTION ENVIRONMENT IDENTICAL: NOT DETERMINED
```

**Ce qui est maîtrisé** (donc identique par construction) : le binaire, la méthode d'installation, la configuration
de compilation du paquet installé.

**Ce qui n'est pas vérifié** : ce que l'environnement d'exécution du 15 Pro renvoie réellement — aucune ligne
`IRIS-STOREKIT` n'en provient. Tant que cette ligne n'existe pas, écrire « environnement identique : OUI » serait
une affirmation non prouvée. Deux différences subsistent d'ailleurs, connues et non contrôlables : la **version
d'iOS** (26.5.2 / 26.6.1) et l'**état de session App Store** de chaque appareil.

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
STOREKIT DIFFERENCE ROOT CAUSE: NOT PROVEN
```

### Ce qui est PROUVÉ

| Énoncé | Fondement |
|---|---|
| Sur l'iPhone 14 Pro, hors Xcode, `Product.products(for:)` **se termine avec succès et rend zéro produit**, sans lever d'erreur | ligne `IRIS-STOREKIT` capturée deux fois, deux builds |
| Sur ce même appareil, la liaison au magasin fonctionne | `storefront.country=FRA storefront.id=143442` |
| Le **même code** rend 2 produits et un `displayPrice` dès qu'une configuration StoreKit est active | `IrisTests/StoreKitEntitlementTests`, 17 tests verts sur un runtime iOS 18.6 |
| La configuration `Config/Iris.storekit` n'est attachée **qu'à l'action Run** du schéma | inspection du schéma généré (§7) |
| Un lancement par `devicectl`, depuis l'écran d'accueil, par TestFlight ou par l'App Store n'utilise aucune action de schéma | fait de plateforme |
| Iris se comporte correctement dans ce cas : prix inconnu, achat désactivé, message explicite, chapitres gratuits ouverts | test « when the store cannot be reached the price is unknown, the free chapters stay open » |

### Ce qui est INFÉRÉ, et le reste

Que l'iPhone 15 Pro affichait 2,99 € **parce qu'il tournait depuis Xcode**, donc avec `Config/Iris.storekit` actif.

L'observation humaine va dans ce sens — « la feuille StoreKit/Xcode de test apparaît », « le message indique
explicitement un environnement de test » sont la signature du test StoreKit, qui sur un appareil n'existe que
lancé par Xcode. **Cela reste une inférence** : aucune mesure ne provient du 15 Pro.

### Ce qui est NOT DETERMINED, et qui ne doit pas être écrit autrement

- **Que l'App Store « ne connaisse pas » ces identifiants.** Une liste vide sans erreur est compatible avec cette
  explication, mais aussi avec d'autres. Seul App Store Connect, ou une autre source Apple faisant autorité,
  pourrait l'établir ; aucun accès n'a été utilisé.
- **Que l'environnement d'exécution des deux appareils soit identique** (§6).
- **Le rôle éventuel de la différence de version d'iOS.**

### Ce qui est ÉCARTÉ PAR MESURE

| Hypothèse | Pourquoi elle tombe |
|---|---|
| Le matériel du 14 Pro | la lecture du magasin ne dépend d'aucune capacité matérielle, et le storefront a répondu |
| Un défaut réseau sur le 14 Pro | `Storefront.current` a répondu et `Product.products` n'a levé aucune erreur |
| Un bundle identifier différent | `app.bundle=net.steve-s.iris` mesuré, et l'inventaire des apps le confirme des deux côtés |
| Un code Iris différent entre les deux appareils | le **même binaire** a été installé sur les deux (§6) |

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
