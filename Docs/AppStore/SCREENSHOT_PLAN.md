# Iris — plan des captures App Store

Aucune capture n'est fabriquée. Toutes proviennent de l'app réelle, lancée sur un appareil ou un simulateur, avec
les états atteints par des arguments de lancement **DEBUG uniquement**.

## 1. Formats exigés par Apple

Source : App Store Connect Help, « Screenshot specifications »
(<https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications/>), consultée le
16 septembre 2026.

| Taille | Dimensions portrait acceptées | Statut |
|---|---|---|
| 6,9" | 1290 × 2796, ou 1320 × 2868, ou 1260 × 2736 | recommandé — Apple redimensionne vers les tailles inférieures |
| 6,5" | 1284 × 2778 | **requis si les captures 6,9" ne sont pas fournies** |
| 6,3" | 1179 × 2556 ou 1206 × 2622 | facultatif |
| 6,1" | 1170 × 2532, 1125 × 2436 ou 1080 × 2340 | facultatif |

Règles : de 1 à 10 captures par langue, en `.png`, `.jpg` ou `.jpeg`. Apple redimensionne du plus grand vers le plus
petit ; fournir la série 6,9" suffit donc pour tous les iPhone visés.

Décision : **fournir la série 6,9"** (1290 × 2796), plus une série 6,5" (1284 × 2778) si le rendu redimensionné ne
satisfait pas à la relecture humaine.

Iris est aussi compilé pour iPad (`TARGETED_DEVICE_FAMILY = 1,2`). Si l'app est publiée pour iPad, Apple exige en
plus la série iPad 13" ; sinon, restreindre la disponibilité aux iPhone dans App Store Connect. **Décision à
prendre par une personne** — voir la checklist.

## 2. Les huit captures

| # | Écran | Comment l'atteindre | Ce qu'elle doit montrer |
|---|---|---|---|
| 01 | Accueil | `--iris-route home --iris-progress 3-4` | L'emblème, « iris », « Ce que vous regardez s'éloigne. », le bouton principal, « Comment jouer » |
| 02 | Explication 1/4 | `--iris-onboarding` | « Votre regard repousse les sphères » et sa figure |
| 03 | Explication 3/4 | `--iris-onboarding`, puis deux fois « Suivant » | « Regardez autour d'elle pour la guider » et sa figure |
| 04 | Calibration | `--iris-route gazeSetup` | Une cible de fixation sur le champ sombre |
| 05 | Jeu réel | `--iris-route game --iris-level 3-4 --iris-oracle-gaze` | Une lueur, son iris, le HUD minimal |
| 06 | Chapitres | `--iris-route chapters --iris-progress 7-4` | Les douze cartes, les éclats, un chapitre verrouillé |
| 07 | Progression | `--iris-route chapters --iris-progress all` | Les éclats gagnés, la campagne parcourue |
| 08 | Niveau avancé | `--iris-route game --iris-level 11-3 --iris-oracle-gaze` | Un chapitre tardif, sa couleur propre |

Captures utiles en complément (facultatives) :

| # | Écran | Comment l'atteindre |
|---|---|---|
| 09 | Accès complet | `--iris-entitlement free --iris-progress all`, puis un chapitre verrouillé → « Débloquer » |
| 10 | Carnet | `--iris-route carnet --iris-progress all` |

## 3. Le mécanisme DEBUG

`App/Platform/LaunchOptions.swift` lit ces arguments. `AppContainer.live()` ne les analyse que dans une compilation
DEBUG :

```swift
#if DEBUG
let launchOptions = LaunchOptions.parse(ProcessInfo.processInfo.arguments)
#else
let launchOptions = LaunchOptions.none
#endif
```

Conséquences, vérifiées par `CommerceBoundaryTests` (test L) et `LaunchOptionsTests` :

- **rien de tout cela n'existe en Release** ;
- aucun argument ne modifie le jeu : ni la physique, ni la répulsion, ni les niveaux, ni l'équilibrage ;
- `--iris-entitlement` remplace la boutique par un droit fixe **en DEBUG seulement** ; en Release, le seul chemin
  vers un droit est une transaction StoreKit vérifiée ;
- `--iris-onboarding` rouvre l'explication sans effacer ce que l'appareil a retenu (elle écrit dans une zone de
  préférences jetable) ;
- `--iris-oracle-gaze` ne vaut que sur simulateur, où il n'existe pas de caméra TrueDepth : le regard simulé fixe la
  cible que l'écran propose. L'apparence du jeu n'est pas modifiée.

## 4. Prise des captures

Sur appareil, la combinaison boutons latéraux produit un PNG à la résolution native de l'écran. Un iPhone 14 Pro
donne 1179 × 2556 (6,1") : il faut donc un iPhone 6,9" ou un simulateur 6,9" pour la série principale.

Sur simulateur :

```
xcrun simctl boot <udid>
xcrun simctl launch <udid> net.steve-s.iris --iris-route chapters --iris-progress 7-4
xcrun simctl io <udid> screenshot 06-chapitres.png
```

Ne jamais retoucher une capture au point de modifier ce que l'app montre. Un cadre marketing (titre, fond) reste
permis tant que la capture d'écran elle-même n'est pas falsifiée.
