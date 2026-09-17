# 07 — Ce qui ne dépend plus du code

Tout ce qui suit est hors du dépôt : App Store Connect, le portail développeur, un hébergement, ou une décision
humaine. Rien ici n'a été fait, et rien ici ne pouvait l'être depuis cette machine.

## A. Actions requises dans le projet — interdites par ce mandat

Ces quatre points **touchent au code ou à la configuration** et sont donc consignés, non exécutés.

| # | Action | Pourquoi |
|---|---|---|
| **1** | `CODE_SIGN_IDENTITY` doit devenir `Apple Distribution` pour la configuration Release | une archive App Store ne peut pas être signée `Apple Development` |
| **2** | La build de distribution doit porter `get-task-allow = false` | conséquence de 1 ; l'App Store refuse un binaire de développement |
| **3** | Enregistrer l'**App ID explicite** `net.steve-s.iris` avec le service **In-App Purchase**, et un profil de distribution App Store | le profil actuel est générique `*` ; un App ID générique **ne peut pas** porter l'achat intégré |
| **4** | Trancher la description de `net.steve-s.iris.unlock.fullgame` entre les deux versions concurrentes | décision produit, pas correction documentaire |

Deux durcissements, souhaitables mais non bloquants :

| # | Action | Gain |
|---|---|---|
| **5** | Corriger le message de restauration hors ligne (document 03, point ouvert 1) | un client payant s'entend actuellement dire que son compte Apple ne contient aucun achat |
| **6** | Envelopper `Features/Game/Diagnostics/OculomotorTrace.swift` dans `#if DEBUG` | la garantie deviendrait structurelle au lieu de dépendre de ses appelants ; 255 symboles quitteraient le binaire |

## B. App Store Connect — inconnu et indispensable

| | État |
|---|---|
| Statut du programme Apple Developer, rôle du compte | **inconnu** |
| Fiche d'app créée pour `net.steve-s.iris` | **inconnu** |
| **Contrat Applications payantes**, fiscalité, coordonnées bancaires | **inconnu** — sans lui, **aucun** achat intégré ne se résout, même en bac à sable |
| `net.steve-s.iris.unlock.fullgame` créé (non consommable, palier 2,99 € FR) | **NOT DETERMINED** |
| `net.steve-s.iris.access.promopass` créé (auto-renouvelable, 1 semaine, groupe `Iris Access`) | **NOT DETERMINED** |
| Code d'offre `IRIS7D` en code personnalisé **gratuit**, case « pas de renouvellement automatique » cochée | à faire — sans la case, un joueur qui échange le code est inscrit à un abonnement hebdomadaire payant |
| Questionnaire de classification d'âge | à répondre — 4+ attendu, justification écrite |
| Questionnaire App Privacy | à répondre — **toutes les réponses sont déjà rédigées**, document 04 |
| Disponibilité iPhone seul ou iPhone + iPad | **décision ouverte**, voir document 06 |
| Palier de prix jamais facturé de l'abonnement promo, nom visible du groupe, disponibilité géographique | décisions ouvertes |

## C. Hébergement

| | État |
|---|---|
| Page de politique de confidentialité en ligne | **manquante** — le texte est écrit, l'URL n'existe pas, et le contact est encore un espace réservé |
| Page de support en ligne | **manquante** — obligatoire |

## D. Production locale, réalisable sans Apple

| | État |
|---|---|
| Série de captures 6,9″ (8 obligatoires selon le plan) | **à produire** — la recette existe |
| Capture de relecture de l'achat intégré | **à produire** |
| Copie anglaise de la fiche | **absente** — nécessaire seulement si l'anglais est voulu au lancement |

## E. Validation humaine encore due

| | État |
|---|---|
| Achat réel en bac à sable sur un iPhone TrueDepth | **jamais observé** |
| Échange réel de `IRIS7D` et observation de son expiration | **jamais observé** |
| Environnement StoreKit propre sur au moins un appareil | **perdu sur les deux** — voir document 03 |

## F. Ce qui n'existe pas et n'est pas nécessaire

Aucun fastlane, aucun `Fastfile`, aucun `ExportOptions.plist`, aucun CI. La soumission sera manuelle. Ce n'est pas
un manque : c'est un fait à connaître avant de planifier l'étape suivante.
