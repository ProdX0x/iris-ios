# Iris — App Store listing (en)

Copie anglaise **proposée** pour la localisation `en` de la fiche v1.0. Le français reste la langue principale et
`APP_STORE_METADATA_FR.md` reste la source canonique : chaque champ ci-dessous en dérive et indique sa source.

**Cette fiche attend une relecture humaine avant d'être collée.** C'est la seule chose qui manque encore :
les URL d'assistance et de confidentialité sont en ligne et vérifiées — voir § « URL Support / Privacy ».

Comme la fiche française, aucune ligne ne promet un effet de santé ou de soin : Iris est présenté comme un jeu, et
seulement comme un jeu. `CommerceBoundaryTests` (test H) relit ce dossier à chaque exécution des tests.

Les longueurs indiquées sont **mesurées**, pas estimées.

---

## Name (30 max)

```
Iris
```
*4 caractères.* Inchangé — nom propre, identique dans les deux langues.

## Subtitle (30 max)

```
What you look at moves away
```
*27 caractères, 27 octets.* Source : « Le regard repousse les sphères » (30).

**Retenu par le pilote.** C'est mot pour mot la signature déjà validée dans l'app (`home.tagline`, et le principe
du chapitre I), donc la fiche et le produit disent exactement la même phrase. Les deux autres formulations
mesurées — `Your gaze pushes spheres away` (29) et `Gaze pushes the spheres away` (28) — sont écartées.

## Promotional text (170 max)

```
Three free chapters. Your gaze pushes the glimmers away: learn to rest your eyes beside them to guide them to their iris.
```
*121 caractères.* Source : le texte promotionnel français (127).

## Description (4 000 max)

```
Iris is a game of indirect attention. Your gaze becomes a force: what you stare at moves away.

Glimmers drift in the dark. Each one is waiting for its iris. You cannot grab them or aim at them — looking straight at one drives it off, often far from where you meant to take it. To guide them you have to learn the opposite: rest your eyes beside them, and move your attention around them.

The iPhone's TrueDepth camera estimates the direction of your gaze. Everything is computed on the device, frame after frame.

WHAT YOU LEARN TO DO
• Avoid what you want to move
• Share your attention between several glimmers
• Push against a current, go around a veil
• Wake an ember with a brief look, without panicking it
• Read a whole level before touching it

TWELVE CHAPTERS, 82 LEVELS
I · awakening — What you look at moves away.
II · sharing — One attention, several glimmers.
III · currents — Your gaze pushes, too.
IV · veils — To go around is to aim.
V · watchlights — Look without disturbing.
VI · clear sight — Read the level before you play.
VII · twins — Each one is the other's iris.
VIII · breaths — What it passes through, it carries away.
IX · echoes — An iris closing wakes whatever sleeps within reach.
X · chasms — What it swallows goes back to the start.
XI · embers — A brief look wakes it. A long look panics it.
XII · constellation — Everything you have learned to look at, together.

Every level ends on three glints: reached, fluid, serene. They are not won by going fast, but by going right.

FREE, THEN A SINGLE PURCHASE
Chapters I, II and III are free, forever. A single purchase opens the rest of the game — and everything added to it later. No subscription, no ads, no account to create, no in-game currency.

YOUR FACE DOES NOT LEAVE THE IPHONE
Iris contains no network code. No camera image, no data from your face, no measurement of your gaze is recorded or sent. Only your calibration coefficients and your progress stay on the device.

COMFORT
Hold the iPhone at eye level, an arm's length away, in steady light. A short calibration at first launch is enough; it can be redone at any time from the settings.

Iris is a game. It makes no health promise.
```

Source : la description française. Les douze noms de chapitre et leurs douze principes ne sont **pas retraduits
ici** : ce sont les valeurs anglaises déjà validées de `Resources/Gameplay.xcstrings`, reprises à la lettre, de sorte
que la fiche et le jeu ne puissent pas diverger.

## What's New in This Version — `NOT_APPLICABLE_INITIAL_VERSION`

```
WHATS_NEW_INITIAL_VERSION_STATUS = NOT_APPLICABLE_INITIAL_VERSION
WHATS_NEW_RESERVED_COPY          = RESERVED_FOR_FUTURE_UPDATE
```

**Ce champ n'existe pas pour une première version.** App Store Connect ne le propose qu'à partir de la deuxième,
où il devient obligatoire. Il ne fait donc **pas** partie des champs à saisir pour la soumission initiale de la v1.0,
et rien ici ne prétend qu'il le sera.

La copie ci-dessous est **conservée en réserve** pour la première mise à jour, et devra être relue à ce moment-là :
écrite pour annoncer la version initiale, elle ne conviendra pas telle quelle pour décrire des nouveautés.

```
The first version of Iris.

Twelve chapters, 82 levels, one idea: what you look at moves away.
The first three chapters are free. A single purchase opens the rest.
```
*163 caractères.* Source : « Nouveautés de cette version » (fr).

## Keywords (100 max, séparés par des virgules, sans espace)

```
gaze,eyes,attention,puzzle,calm,truedepth,focus,relaxing,indirect,spheres,contemplative
```
*87 caractères, **87 octets UTF-8** (chaîne entièrement ASCII), plafond opérationnel 100 octets — marge de 13.*

**Composés, non traduits.** Le champ se compose pour un marché, il ne se traduit pas. Le nom de l'app est déjà
indexé par Apple : `iris` n'y figure donc pas. `réflexion` et `concentration` sont rendus par `puzzle` et `focus`,
qui sont les termes réellement cherchés en anglais. `mindful` a été retiré par décision du pilote : il positionnait
Iris près de la catégorie bien-être, où le jeu n'appartient pas. Il n'a été remplacé par rien — la place libre reste
libre, l'objectif étant la pertinence et non l'occupation des 100 octets.

Aucun mot n'est ajouté pour combler la marge.

## Champs réellement nécessaires à la soumission initiale v1.0

`FACT` — huit champs, et non neuf : « What's New » ne s'applique pas à une première version.

| # | Champ | Longueur | Limite | État |
|---|---|---|---|---|
| 1 | Subtitle | 27 car. | 30 | prêt |
| 2 | Promotional text | 121 car. | 170 | prêt |
| 3 | Description | 2 180 car. | 4 000 | prêt |
| 4 | Keywords | 87 octets | 100 octets | prêt |
| 5 | IAP full game — display name | 16 car. | 30 | prêt |
| 6 | IAP full game — description | 40 car. | 45 (prudentiel) | prêt |
| 7 | IAP promotional access — display name | 23 car. | 30 | prêt |
| 8 | IAP promotional access — description | 35 car. | 45 (prudentiel) | prêt |
| — | What's New | 163 car. | — | **non applicable en v1.0**, gardé en réserve |

Le champ **Name** reste `Iris` dans les deux langues : rien à saisir de différent.

## Catégories, classification par âge, copyright

Champs **globaux**, non localisables : voir `APP_STORE_METADATA_FR.md`. Rien à traduire.

## In-App Purchases — textes localisés (en)

### Full game

| Champ | Valeur | Longueur |
|---|---|---|
| Display name (30 max) | `Iris — Full Game` | 16 |
| Description (45) | `Unlocks all chapters. One-time purchase.` | 40 |

Source : « Iris — jeu complet » et la copie canonique de 39 caractères « Ouvre tous les chapitres. Achat unique. ».
Le français dit « ouvre » parce que c'est le verbe du jeu ; l'anglais dit `unlocks`, qui est le verbe d'une boutique.

### Promotional access

| Champ | Valeur | Longueur |
|---|---|---|
| Display name (30 max) | `Iris Promotional Access` | 23 |
| Description (45) | `Temporary access to the whole game.` | 35 |

Source : « Accès promotionnel Iris » et « Accès temporaire à tout le jeu. ».

**Limite du champ Description — à revalider.** La documentation d'Apple n'est pas univoque : 45 caractères d'un
côté, 55 de l'autre. Les deux descriptions ci-dessus tiennent dans 45, donc dans les deux cas. La limite réellement
appliquée sera constatée dans App Store Connect au moment de créer les produits — voir `STOREKIT_PRODUCTS.md`.

## App Review Notes

**Hors des champs de la fiche.** C'est un champ unique et **non localisable** : une seule valeur existe pour toute
la fiche, quelle que soit la langue. Il ne compte donc pas parmi les huit champs à saisir pour la v1.0.

Décision du pilote : **la valeur saisie sera l'anglais**, parce que la relecture d'Apple se fait le plus souvent
dans cette langue et que le montage Offer Code est le point le plus facile à mal comprendre. Le texte est dans
`Docs/AppStore/APP_REVIEW_NOTES_EN.md` ; `APP_REVIEW_NOTES_FR.md` reste la source canonique dont il dérive.

---

## URL Support / Privacy

`FACT`, vérifié publiquement le 21 septembre 2026, vérification TLS activée. Les quatre pages sont en ligne, dans
les deux langues, et le certificat couvre désormais `www.steve-s.net` comme l'apex.

| Fiche | Champ | URL |
|---|---|---|
| **fr-FR** | Support | `https://www.steve-s.net/iris/` |
| **fr-FR** | Politique de confidentialité | `https://www.steve-s.net/iris/privacy-iris/` |
| **en** | Support | `https://www.steve-s.net/en/iris/` |
| **en** | Privacy policy | `https://www.steve-s.net/en/iris/privacy-iris/` |

Les URL françaises sont **inchangées** : ce sont exactement celles que `Features/About/AboutCopy.swift` embarque et
que `AboutLegalTests.swift` vérifie à l'octet près. Aucune modification du produit n'a été nécessaire.

Constats : certificat `CN=steve-s.net` couvrant `www.steve-s.net` (Let's Encrypt, valide jusqu'au 20 décembre 2026),
aucune erreur de nom d'hôte, une seule redirection `301` de `www` vers l'apex, sans boucle, status final `200`,
langues `fr` et `en` correctes, contenu identique au bit près aux fichiers publiés.

Les pages sont servies par GitHub Pages depuis `ProdX0x/prodx0x-wonderland` (`main`, racine), commit
`1e928aa27bf5bb8461013fe4f9e92cdb15d4b2ba`. Ce dépôt est **hors du dépôt Iris**.

## Ce qui reste à décider par le pilote

1. **Relecture humaine de la copie anglaise** ci-dessus — en particulier le sous-titre, où trois variantes sont
   proposées, et les mots-clés.
2. **Notes de relecture en anglais** : confort pour le relecteur ou non. Voir § App Review Notes.
3. **Carte Iris de la page d'accueil du site** : `https://steve-s.net/` présente encore Iris comme « un concept
   d'application » au statut « En développement ». C'est en décalage avec une v1.0 prête à soumettre. La source est
   `src/apps.js` du dépôt Pages, donc hors du dépôt Iris. Signalé, non corrigé.
