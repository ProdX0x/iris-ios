# Iris — checklist App Store Connect

Tout ce qui suit demande une action humaine dans App Store Connect ou sur le portail développeur. **Rien n'a été
créé, modifié ni vérifié côté Apple depuis cette machine** : aucun accès n'a été utilisé. Les états marqués
« inconnu » le sont réellement.

Identité verrouillée du projet (`project.yml`, contrôle C12 de `Tools/audit.py`) :

| Champ | Valeur |
|---|---|
| Bundle ID | `net.steve-s.iris` |
| Team ID | `G4U9RG5GL7` |
| Signature | Automatique, aucun profil épinglé |
| `MARKETING_VERSION` | `1.0` |
| `CURRENT_PROJECT_VERSION` | `1` |

## 1. Compte et contrats

| Élément | État connu | Action |
|---|---|---|
| Apple Developer Program actif | inconnu | vérifier l'adhésion et sa date d'expiration |
| Rôle du compte utilisé | inconnu | il faut au moins Admin ou Account Holder pour créer les produits et les contrats |
| App record créé pour `net.steve-s.iris` | inconnu | créer l'app (plateforme iOS, langue principale français) |
| **Paid Applications Agreement** signé | inconnu | **obligatoire** : sans lui aucun achat intégré n'est possible, même en bac à sable |
| Informations fiscales | inconnu | obligatoire pour les contrats payants |
| Coordonnées bancaires | inconnu | obligatoire pour les contrats payants |
| Capacité In-App Purchase | activée par défaut pour un App ID explicite | vérifier sur le portail développeur |

Tant que le Paid Applications Agreement n'est pas actif, les produits restent en « Missing Metadata » et
`Product.products(for:)` renverra une liste vide sur l'appareil. Iris gère ce cas : le prix est inconnu, le bouton
d'achat est désactivé, un message le dit, et **les chapitres gratuits restent ouverts**.

## 2. Produits à créer

### 2.1 Jeu complet

| Champ | Valeur |
|---|---|
| Type | Non-Consumable |
| Product ID | `net.steve-s.iris.unlock.fullgame` |
| Reference Name | Iris Full Game Unlock |
| Prix France | 2,99 € (choisir le palier correspondant) |
| Nom affiché fr-FR | Iris — jeu complet |
| Description fr-FR | Ouvre tous les chapitres. Achat unique. |
| Family Sharing | désactivé |
| Capture d'écran de relecture | requise : une capture de l'écran « accès complet » |

### 2.2 Accès promotionnel

| Champ | Valeur |
|---|---|
| Type | Auto-Renewable Subscription |
| Groupe d'abonnement | `Iris Access` (à créer) |
| Product ID | `net.steve-s.iris.access.promopass` |
| Reference Name | Iris Promotional Access Pass |
| Durée | 1 semaine |
| Prix | un palier doit être choisi (Apple l'exige), **jamais facturé** : voir 2.3 |

### 2.3 Offer Code — le point décisif

| Champ | Valeur |
|---|---|
| Type | Custom code |
| Code | `IRIS7D` |
| Type d'offre | **Free** |
| Durée | 1 semaine |
| Éligibilité | New subscribers (ajouter Expired subscribers si souhaité) |
| **« Automatically renew to standard price at the end of the offer »** | **décoché / case de prévention cochée** |

Formulation exacte d'Apple (App Store Connect Help, « Set up subscription offer codes », étape 8, consultée le
16 septembre 2026) :

> « Choose whether you'd like the subscription to automatically renew to the standard price upon conclusion of the
> offer period. (Checking the box will prevent auto-renewal, ensuring customers receive a commitment-free trial
> subscription. If you choose this option, you'll only be able to choose Free offers). »

C'est cette case qui garantit les deux exigences du produit : **le droit expire réellement** et **rien n'est
facturé**. Si elle n'est pas cochée, l'abonnement se renouvellera au prix standard : le montage serait alors
non conforme à l'intention et devrait être annulé.

Limites Apple à connaître : 1 million de codes par app et par trimestre (tous abonnements confondus), un code
personnalisé de 64 caractères maximum sans caractère spécial, un seul code par client et par offre, expiration
facultative pour un code personnalisé et de 6 mois maximum si elle est fixée.

## 3. Fiche App Store

| Élément | Source |
|---|---|
| Nom, sous-titre, texte promotionnel, description, mots-clés | `APP_STORE_METADATA_FR.md` |
| Catégories, classification par âge, copyright | `APP_STORE_METADATA_FR.md` |
| Captures d'écran | `SCREENSHOT_PLAN.md` — **à produire**, aucune n'existe encore |
| Notes pour la relecture | `APP_REVIEW_NOTES_FR.md` |
| Réponses « App Privacy » | `PRIVACY_RELEASE_NOTES.md` § 4 |
| **URL d'assistance** | `https://www.steve-s.net/iris/` — en ligne, vérifiée le 18 septembre 2026 |
| **URL de politique de confidentialité** | `https://www.steve-s.net/iris/privacy-iris/` — en ligne, vérifiée le 18 septembre 2026 |
| Copyright | `2026 Stéphane SAULNIER` — sans le symbole, Apple l'ajoute |

## 4. Décisions humaines restées ouvertes

1. **iPad.** Le projet compile pour iPhone et iPad (`TARGETED_DEVICE_FAMILY = 1,2`). Publier pour iPad obligerait à
   fournir les captures iPad 13" et à valider le jeu sur iPad. Sinon, restreindre la disponibilité aux iPhone.
2. **Palier de prix de l'abonnement promotionnel.** Il faut en choisir un même s'il ne sera jamais facturé.
3. **Nom exact du groupe d'abonnement** visible par les clients dans les réglages iOS.
4. **Disponibilité géographique** de l'app et des produits.

## 5. Versions et numéros de build

`MARKETING_VERSION = 1.0` et `CURRENT_PROJECT_VERSION = 1` n'ont pas été modifiés : aucun build n'a jamais été
téléversé, `1.0 (1)` reste donc cohérent pour un premier envoi. **À partir du deuxième téléversement**, incrémenter
`CURRENT_PROJECT_VERSION` dans `project.yml` à chaque build (Apple refuse deux builds avec le même numéro pour une
même version marketing), puis régénérer avec `xcodegen generate`.

## 6. Avant de soumettre

- [ ] Paid Applications Agreement actif
- [ ] Les deux produits créés, avec leurs métadonnées et leur capture de relecture
- [ ] Offer Code `IRIS7D` créé, gratuit, 1 semaine, **sans reconduction**
- [ ] Achat réel testé en bac à sable sur un iPhone avec TrueDepth
- [ ] Rédemption réelle de `IRIS7D` testée en bac à sable, puis expiration observée
- [x] Captures produites selon `SCREENSHOT_PLAN.md` — 8/8 validées le 18 septembre 2026, manifeste et empreintes dans `Docs/ReleaseGate4/11_SCREENSHOTS.md`
- [x] URL d'assistance et politique de confidentialité en ligne — vérifiées le 18 septembre 2026
- [ ] **Statut « trader / non-trader » (UE, DSA) déclaré dans App Store Connect** — NON VÉRIFIÉ, hors du périmètre du Gate 4H ; à contrôler avant soumission dans l'UE
- [ ] Questionnaire « App Privacy » rempli selon `PRIVACY_RELEASE_NOTES.md` § 4
- [ ] **Validation physique des performances sur iPhone** (voir le rapport de mission : régression non résolue)
- [ ] **Validation de stabilité mémoire / backboardd** (voir le rapport de mission : incident Jetsam non attribué)
