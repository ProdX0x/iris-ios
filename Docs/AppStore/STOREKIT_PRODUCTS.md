# Iris — produits StoreKit

Ce document décrit les produits à créer dans App Store Connect et la façon dont Iris les lit.
Rien ici n'est créé automatiquement : App Store Connect reste une action humaine.

## 1. Modèle commercial

| Élément | Valeur |
|---|---|
| Téléchargement de l'app | Gratuit |
| Chapitres gratuits | I, II, III |
| Chapitres de l'accès complet | IV à XII (et tout chapitre ajouté ensuite) |
| Niveaux au total aujourd'hui | 82, en 12 chapitres (6, 6, 7, puis 7 par chapitre) |
| Niveaux jouables sans achat | 19 |

Le nombre de chapitres gratuits est écrit **une seule fois** dans le code, dans
`Domain/Access/AccessPolicy.swift` (`freeChapterCount = 3`). `CommerceBoundaryTests` (test D) échoue si un autre
fichier réécrit cette valeur.

## 2. Produit permanent — jeu complet

| Champ | Valeur |
|---|---|
| Type | Non-Consumable In-App Purchase |
| Product ID | `net.steve_s.iris.unlock.fullgame` |
| Reference Name | Iris Full Game |
| Prix cible France | 2,99 € |
| Family Sharing | Non |
| Nom affiché (fr-FR) | Iris — jeu complet |
| Description (fr-FR) | Ouvre tous les chapitres. Achat unique. |

**La source canonique de ces deux textes est `APP_STORE_METADATA_FR.md`**, § « Achats intégrés — textes localisés
(fr-FR) ». Les valeurs ci-dessus en sont la reprise exacte ; en cas d'écart, c'est ce document-ci qui a tort.

Ce fichier a porté jusqu'au 21 septembre 2026 une description plus longue (« Débloque les douze chapitres… », 94
caractères) qui contredisait la copie canonique et dépassait la limite retenue. Elle est supprimée, sans qu'aucune
troisième formulation ne soit introduite.

**Longueur du champ « Description » d'un achat intégré — à revalider.** La documentation d'Apple n'est pas
univoque : App Store Connect Help et la page dédiée aux achats intégrés annoncent **45 caractères**, tandis qu'une
autre page générale mentionne encore **55**. La copie canonique en fait **39**, donc conforme dans les deux cas.
La contrainte opérationnelle retenue pour cette phase est la plus prudente, **45 caractères** ; la limite réellement
appliquée sera constatée dans l'interface d'App Store Connect lors de la configuration des produits, et non
supposée ici.

**Caractères du Product ID — constatés dans App Store Connect, pas supposés.** Les deux identifiants s'écrivent
`net.steve_s.iris…`, avec un **tiret bas**, alors que le Bundle ID reste `net.steve-s.iris`, avec un tiret. Le
22 septembre 2026, un test de saisie dans le formulaire de création d'achat intégré, sans rien créer, a refusé la
forme avec tiret (« Seuls les caractères alphanumériques, points et tirets bas sont autorisés ») et accepté la forme
avec tiret bas. La documentation d'Apple n'est pas univoque : l'aide d'App Store Connect (« In-App Purchase
information ») déclare les tirets autorisés, la Technical Q&A QA1329 ne les autorise pas ; c'est le formulaire qui
fait foi. Un Product ID n'est pas un Bundle ID et ne doit pas être aligné sur lui. Par prudence, Iris s'en tient
aux lettres, chiffres, points et tirets bas : `CommerceBoundaryTests` (test N) échoue si un identifiant sort de cet
ensemble. C'est une contrainte locale fondée sur ce constat, pas la grammaire officielle d'Apple.

**Le prix n'est jamais écrit dans Iris.** L'interface affiche `Product.displayPrice`, c'est-à-dire la chaîne que
l'App Store formate pour la boutique du joueur. `CommerceBoundaryTests` (test G) échoue si une source de production
contient « 2,99 », « 2.99 » ou un symbole monétaire.

Le produit n'est jamais lié au périmètre « chapitres IV à XII » : il ouvre *l'accès complet*, donc aussi les
chapitres ajoutés après le XII.

## 3. Produit promotionnel — abonnement d'une semaine, porteur d'une offre gratuite de 3 jours

| Champ | Valeur |
|---|---|
| Type | Auto-Renewable Subscription |
| Product ID | `net.steve_s.iris.access.promopass` |
| Reference Name | Iris Promotional Access |
| Groupe d'abonnement | Iris Access |
| Durée de renouvellement | 1 semaine |
| Prix normal | 0,99 € / semaine |
| Usage | Véhicule Apple d'un Offer Code promotionnel, **uniquement** |

Ce produit **n'est jamais vendu dans Iris** : aucun bouton « S'abonner », aucune page d'abonnement, aucun prix
affiché. Iris se contente de reconnaître un droit StoreKit vérifié portant sur cet identifiant.
`CommerceBoundaryTests` (test I) échoue si l'interface propose un abonnement, et si le service tente d'acheter ce
produit.

### Offer Code

| Champ | Valeur |
|---|---|
| Nom de référence de l'offre | Iris 3-Day Promotional Access |
| Type de code | Custom code |
| Code | `IRIS3D` — prévu, pas encore créé : App Store Connect le refuse tant que l'abonnement n'est pas approuvé et que l'app n'est pas prête à être distribuée |
| Type d'offre | Free |
| Durée de l'offre | **3 jours** — la période de l'abonnement reste d'une semaine |
| Éligibilité | nouveaux, actuels et anciens abonnés |
| Renouvellement automatique à la fin de l'offre | **Désactivé** : « Ne pas renouveler automatiquement l'abonnement à la fin de cette offre » (voir §4) |
| Offres d'introduction | « Non, uniquement ce code d'offre » |

Iris ne connaît ni `IRIS3D` ni l'ancien `IRIS7D` : `CommerceBoundaryTests` (test E) échoue si l'un d'eux apparaît
dans une source ou dans un catalogue de textes livré avec l'app.
Le seul chemin de rédemption est la feuille officielle Apple (`offerCodeRedemption`, iOS 16+), présentée par
`Features/Paywall/OfferCodeRedemption.swift` — le seul fichier de l'interface qui importe StoreKit.

## 4. Vérification de la règle Apple (faite, pas supposée)

Source : App Store Connect Help, « Set up subscription offer codes »
(<https://developer.apple.com/help/app-store-connect/manage-subscriptions/set-up-subscription-offer-codes/>),
consultée le 16 septembre 2026. Citation exacte de l'étape 8 :

> « Choose whether you'd like the subscription to automatically renew to the standard price upon conclusion of the
> offer period. (Checking the box will prevent auto-renewal, ensuring customers receive a commitment-free trial
> subscription. If you choose this option, you'll only be able to choose Free offers). »

Conséquences vérifiées :

- les Offer Codes n'existent **que** pour les abonnements auto-renouvelables : c'est la raison pour laquelle
  `net.steve_s.iris.access.promopass` existe ;
- une offre **Free** de 3 jours est possible : la page « Set up introductory offers » liste les durées d'essai
  gratuit « 3 Days / 1 or 2 Weeks / 1, 2, 3, or 6 Months / 1 Year » ;
- en cochant la case ci-dessus, **le droit expire sans reconduction et sans facturation** ;
- les custom codes acceptent jusqu'à 64 caractères sans caractère spécial : `IRIS3D` convient ;
- un client ne peut utiliser qu'un seul code par offre.

Le montage demandé est donc réalisable tel quel. **Aucune offre de deux mois n'existe** dans le code, les tests, la
configuration locale ni cette documentation.

## 5. Ce que fait Iris avec ces produits

| Droit | Condition |
|---|---|
| `fullAccess` | une transaction **vérifiée**, non révoquée, non remplacée, sans date d'expiration dépassée, sur `net.steve_s.iris.unlock.fullgame` |
| `promotionalAccess` | la même chose sur `net.steve_s.iris.access.promopass`, et encore active |
| `free` | aucun droit actif |

Priorité stricte : `fullAccess` > `promotionalAccess` > `free`.
Source de vérité : `Transaction.currentEntitlements` et `Transaction.updates`. Iris ne garde **aucun drapeau local**
qui survivrait à une expiration : `CommerceBoundaryTests` (test F) échoue si un tel drapeau apparaît, et si le
service écrit quoi que ce soit dans les préférences.

## 6. Configuration StoreKit locale

`Config/Iris.storekit` décrit les deux produits pour les tests. Elle est référencée par l'action Run du schéma
(`project.yml` → `schemes.Iris.run.storeKitConfiguration`).

**Elle ne crée rien dans App Store Connect.** Elle sert uniquement à jouer les scénarios avant que les produits réels
existent.

Deux limites mesurées, pas supposées :

1. **Les offres (`codeOffers`, `adHocOffers`) ne peuvent pas être déclarées dans ce fichier** : toute entrée non vide
   rend la configuration entière illisible et l'app ne voit plus aucun produit. Ce n'est pas gênant :
   `SKTestSession.buyProduct(identifier:options:)` accepte `.codeOffer(referenceName:)` sans que l'offre soit
   déclarée, et c'est ainsi que le test de l'accès promotionnel est joué.
2. **Le runtime iOS 26.3 installé sur cette machine refuse les sessions de test StoreKit** : `storekitd` répond
   `SKInternalErrorDomain 3`. Depuis que les produits existent dans App Store Connect, `Product.products(for:)` y
   reçoit alors la réponse du **sandbox** — les vrais produits, vitrine et prix américains — au lieu de la session
   locale. La présence des produits ne prouve donc plus rien : chaque session tourne sur une copie de ce fichier
   augmentée d'un produit témoin (`net.steve_s.iris.test.localsession`) qu'aucun App Store ne connaît, et c'est lui
   que la garde des tests cherche. Absent sur un runtime iOS 26, il signale cette limite connue, et chaque test
   enregistre un *known issue* qui la nomme ; absent partout ailleurs — iOS 18.x compris, où les tests s'exécutent
   réellement —, il fait échouer le test.

La limite 2 ne peut plus masquer une divergence d'identifiants : `CommerceBoundaryTests` (test N) lit ce fichier
sans StoreKit et échoue franchement s'il ne déclare pas exactement `StoreProductID.all`, chacun avec son type, quel
que soit le côté qui a bougé.

## 7. Scénarios couverts par les tests

`Tests/IrisTests/Commerce/StoreKitEntitlementTests.swift` (20 tests, joués sur iOS 18.6) :

produit disponible · prix issu du store · produit indisponible · achat vérifié · achat non vérifié refusé ·
achat en attente · achat annulé · erreur d'achat · droit retrouvé au lancement · restauration · restauration quand
la synchronisation échoue · révocation (remboursement) · accès promotionnel obtenu par Offer Code ·
expiration de l'accès promotionnel · achat permanent survivant à l'expiration · `Transaction.updates`.

`Tests/IrisTests/Access/AccessPolicyTests.swift` et `AccessGatingTests.swift` couvrent la règle métier et les huit
parcours joueur sans toucher à StoreKit.

## 8. Comment rejouer les tests StoreKit

Le runtime iOS 26.3 de cette machine refuse les sessions de test StoreKit. Un simulateur iOS 18.x les accepte :

```
xcrun simctl create "Iris-SK-18" "iPhone 16" com.apple.CoreSimulator.SimRuntime.iOS-18-6
xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'platform=iOS Simulator,name=Iris-SK-18' \
  test -only-testing:IrisTests/StoreKitEntitlementTests
```

Un simulateur `Iris-SK-18` a été créé sur cette machine pour cette vérification ; il peut être supprimé avec
`xcrun simctl delete "Iris-SK-18"` et recréé à l'identique par la commande ci-dessus.
