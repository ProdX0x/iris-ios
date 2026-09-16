# Iris — produits StoreKit

Ce document décrit les produits à créer dans App Store Connect et la façon dont Iris les lit.
Rien ici n'est créé automatiquement : App Store Connect reste une action humaine.

## 1. Modèle commercial

| Élément | Valeur |
|---|---|
| Téléchargement de l'app | Gratuit |
| Chapitres gratuits | I, II, III |
| Chapitres de l'accès complet | IV à XII (et tout chapitre ajouté ensuite) |
| Niveaux au total aujourd'hui | 82, en 12 chapitres |

Le nombre de chapitres gratuits est écrit **une seule fois** dans le code, dans
`Domain/Access/AccessPolicy.swift` (`freeChapterCount = 3`). `CommerceBoundaryTests` (test D) échoue si un autre
fichier réécrit cette valeur.

## 2. Produit permanent — jeu complet

| Champ | Valeur |
|---|---|
| Type | Non-Consumable In-App Purchase |
| Product ID | `net.steve-s.iris.unlock.fullgame` |
| Reference Name | Iris Full Game Unlock |
| Prix cible France | 2,99 € |
| Family Sharing | Non |
| Nom affiché (fr-FR) | Iris — jeu complet |
| Description (fr-FR) | Débloque les douze chapitres d'Iris et tous les niveaux à venir. Achat unique, sans abonnement. |

**Le prix n'est jamais écrit dans Iris.** L'interface affiche `Product.displayPrice`, c'est-à-dire la chaîne que
l'App Store formate pour la boutique du joueur. `CommerceBoundaryTests` (test G) échoue si une source de production
contient « 2,99 », « 2.99 » ou un symbole monétaire.

Le produit n'est jamais lié au périmètre « chapitres IV à XII » : il ouvre *l'accès complet*, donc aussi les
chapitres ajoutés après le XII.

## 3. Produit promotionnel — accès temporaire de 7 jours

| Champ | Valeur |
|---|---|
| Type | Auto-Renewable Subscription |
| Product ID | `net.steve-s.iris.access.promopass` |
| Reference Name | Iris Promotional Access Pass |
| Groupe d'abonnement | Iris Access |
| Durée de renouvellement | 1 semaine |
| Usage | Véhicule Apple d'un Offer Code promotionnel, **uniquement** |

Ce produit **n'est jamais vendu dans Iris** : aucun bouton « S'abonner », aucune page d'abonnement, aucun prix
affiché. Iris se contente de reconnaître un droit StoreKit vérifié portant sur cet identifiant.
`CommerceBoundaryTests` (test I) échoue si l'interface propose un abonnement, et si le service tente d'acheter ce
produit.

### Offer Code

| Champ | Valeur |
|---|---|
| Type de code | Custom code |
| Code | `IRIS7D` |
| Type d'offre | Free |
| Durée | 1 semaine |
| Éligibilité | New subscribers (et Expired subscribers si souhaité) |
| Renouvellement automatique à la fin de l'offre | **Désactivé** (case à cocher, voir §4) |

Iris ne connaît pas la chaîne `IRIS7D` : `CommerceBoundaryTests` (test E) échoue si elle apparaît dans une source.
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
  `net.steve-s.iris.access.promopass` existe ;
- une offre **Free** d'une semaine est possible : la page « Set up introductory offers » liste les durées d'essai
  gratuit « 3 Days / 1 or 2 Weeks / 1, 2, 3, or 6 Months / 1 Year » ;
- en cochant la case ci-dessus, **le droit expire sans reconduction et sans facturation** ;
- les custom codes acceptent jusqu'à 64 caractères sans caractère spécial : `IRIS7D` convient ;
- un client ne peut utiliser qu'un seul code par offre.

Le montage demandé est donc réalisable tel quel. **Aucune offre de deux mois n'existe** dans le code, les tests, la
configuration locale ni cette documentation.

## 5. Ce que fait Iris avec ces produits

| Droit | Condition |
|---|---|
| `fullAccess` | une transaction **vérifiée**, non révoquée, non remplacée, sans date d'expiration dépassée, sur `net.steve-s.iris.unlock.fullgame` |
| `promotionalAccess` | la même chose sur `net.steve-s.iris.access.promopass`, et encore active |
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
   `SKInternalErrorDomain 3` et tout appel boutique revient en `notEntitled`. Les mêmes tests s'exécutent réellement
   sur un runtime iOS 18.x. Sur un runtime qui refuse, chaque test enregistre un *known issue* nommant la limite
   plutôt que de prétendre avoir prouvé quelque chose.

## 7. Scénarios couverts par les tests

`Tests/IrisTests/Commerce/StoreKitEntitlementTests.swift` (17 tests, joués sur iOS 18.6) :

produit disponible · prix issu du store · produit indisponible · achat vérifié · achat non vérifié refusé ·
achat en attente · achat annulé · erreur d'achat · droit retrouvé au lancement · restauration · restauration quand
la synchronisation échoue · révocation (remboursement) · accès promotionnel obtenu par Offer Code ·
expiration de l'accès promotionnel · achat permanent survivant à l'expiration · `Transaction.updates`.

`Tests/IrisTests/Access/AccessPolicyTests.swift` et `AccessGatingTests.swift` couvrent la règle métier et les huit
parcours joueur sans toucher à StoreKit.
