# Iris — fiche App Store (fr-FR)

Texte prêt à coller dans App Store Connect. La langue principale reste le français, et **la fiche v1.0 sera
localisée en français et en anglais** : l'anglais n'est plus une éventualité mais une décision (voir
`Docs/AppStore/APP_STORE_CONNECT_CHECKLIST.md`, § 7). Ce document porte la copie **française** ; la copie anglaise
n'est pas encore rédigée.

Aucune de ces lignes ne promet un effet de santé ou de soin : Iris est présenté comme un jeu, et seulement
comme un jeu. `CommerceBoundaryTests` (test H) relit ce dossier à chaque exécution des tests.

---

## Nom (30 caractères max)

```
Iris
```

## Sous-titre (30 caractères max)

```
Le regard repousse les sphères
```
*30 caractères.*

## Texte promotionnel (170 caractères max, modifiable sans nouvelle version)

```
Trois chapitres gratuits. Votre regard repousse les lueurs : apprenez à poser les yeux à côté pour les guider jusqu'à leur iris.
```
*127 caractères.*

## Description (4 000 caractères max)

```
Iris est un jeu d'attention indirecte. Votre regard y devient une force : ce que vous fixez s'éloigne.

Des lueurs flottent dans le noir. Chacune attend son iris. Vous ne pouvez ni les saisir ni les viser — les regarder droit dessus les chasse, souvent loin de là où vous vouliez les emmener. Pour les guider, il faut apprendre l'inverse : poser les yeux à côté, et déplacer son attention autour d'elles.

La caméra TrueDepth de l'iPhone estime la direction de votre regard. Tout est calculé sur l'appareil, image après image.

CE QUE VOUS APPRENEZ À FAIRE
• Éviter ce que vous voulez déplacer
• Partager votre attention entre plusieurs lueurs
• Pousser contre un courant, contourner un voile
• Réveiller une braise d'un regard bref, sans l'affoler
• Lire un niveau entier avant d'y toucher

DOUZE CHAPITRES, 82 NIVEAUX
I · éveil — Ce que vous regardez s'éloigne.
II · partage — Une attention, plusieurs lueurs.
III · courants — Votre regard pousse aussi.
IV · voiles — Contourner, c'est viser.
V · veilleuses — Regarder sans troubler.
VI · clairvoyance — Lire le niveau avant de jouer.
VII · jumelles — Chacune est l'iris de l'autre.
VIII · souffles — Ce qu'il traverse, il l'emporte.
IX · échos — Un iris qui se ferme réveille ce qui dort à portée.
X · gouffres — Ce qu'il avale revient au départ.
XI · braises — Un regard bref la réveille. Un regard long l'affole.
XII · constellation — Tout ce que vous savez regarder, ensemble.

Chaque niveau se termine sur trois éclats : atteint, fluide, serein. Ils ne se gagnent pas en allant vite, mais en allant juste.

GRATUIT, PUIS UN SEUL ACHAT
Les chapitres I, II et III sont gratuits, pour toujours. Un achat unique ouvre le reste du jeu — et tout ce qui viendra s'y ajouter. Aucun abonnement, aucune publicité, aucun compte à créer, aucune monnaie interne.

VOTRE VISAGE NE QUITTE PAS L'IPHONE
Iris ne contient aucun code réseau. Aucune image de la caméra, aucune donnée de votre visage, aucune mesure de votre regard n'est enregistrée ni envoyée. Seuls vos coefficients de calibration et votre progression restent sur l'appareil.

CONFORT
Tenez l'iPhone à hauteur des yeux, à une longueur de bras, dans une lumière régulière. Une calibration courte au premier lancement suffit ; elle se refait à tout moment depuis les réglages.

Iris est un jeu. Il ne fait aucune promesse de santé.
```

## Nouveautés de cette version

```
Première version d'Iris.

Douze chapitres, 82 niveaux, une seule idée : ce que vous regardez s'éloigne.
Les trois premiers chapitres sont gratuits. Un achat unique ouvre le reste.
```

## Mots-clés (100 caractères max, séparés par des virgules, sans espace)

```
regard,attention,yeux,puzzle,calme,truedepth,contemplatif,réflexion,sphères,indirect,concentration
```
*98 caractères.*

## Catégories

| Champ | Valeur |
|---|---|
| Catégorie principale | Jeux → Réflexion (Puzzle) |
| Catégorie secondaire | Jeux → Occasionnel (Casual) |
| `LSApplicationCategoryType` (déjà dans `Config/Info.plist`) | `public.app-category.games` |

## Classification par âge

4+ attendue : aucun contenu sensible, aucune violence, aucun achat aléatoire, aucun contenu généré par les
utilisateurs, aucun accès web. À confirmer via le questionnaire d'App Store Connect.

## Copyright

Champ « Copyright » d'App Store Connect — **sans le symbole**, Apple l'ajoute lui-même :

```
2026 Stéphane SAULNIER
```

La ligne affichée dans l'app porte le symbole : `© 2026 Stéphane SAULNIER` (`Features/About/AboutCopy.swift`).

## Achats intégrés — textes localisés (fr-FR)

### Jeu complet

| Champ | Valeur |
|---|---|
| Nom affiché (30 max) | `Iris — jeu complet` |
| Description (45 max) | `Ouvre tous les chapitres. Achat unique.` |

### Accès promotionnel (jamais mis en avant dans l'app)

| Champ | Valeur |
|---|---|
| Nom affiché (30 max) | `Accès promotionnel Iris` |
| Description (45 max) | `Accès temporaire à tout le jeu.` |

Ce second produit n'est jamais proposé à la vente dans Iris : il n'existe que pour porter l'Offer Code gratuit de
7 jours. Voir `STOREKIT_PRODUCTS.md`.

## URLs

| Champ | Valeur |
|---|---|
| URL d'assistance | `https://www.steve-s.net/iris/` — en ligne, porte `contact@steve-s.net` |
| URL de politique de confidentialité | `https://www.steve-s.net/iris/privacy-iris/` — en ligne, mise à jour du 13 septembre 2026 |
| URL marketing | facultative — non fournie |

Les deux pages ont été consultées le 18 septembre 2026 (Release Gate 4H-A) : HTTPS valide, français, politique de
confidentialité propre à Iris, adresse de contact présente. Le texte de référence reste `PRIVACY_RELEASE_NOTES.md` § 5.
Les deux adresses sont également accessibles depuis l'app, écran « À propos & informations légales » (Réglages).
