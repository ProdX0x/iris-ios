# 06 — Captures d'écran

Inventaire du 17 septembre 2026.

## Ce qui existe

| Fichier | Dimensions | Ce que c'est |
|---|---|---|
| `Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png` | 1024 × 1024 | **l'icône marketing**, présente et correctement dimensionnée |
| `x7_silhouette_reference.png` (non suivi) | 941 × 1672 | un contour de tête servant de calque de tracé pour X-7 — aucune interface, aucun texte. **Pas une capture** |

Il n'existe **aucun autre** `.png`, `.jpg`, `.jpeg`, `.heic`, `.gif`, `.mp4` ou `.mov` dans l'arbre de travail.
Pas de dossier `Screenshots/`, `Captures/`, `Preview/` ni `Media/`. Rien n'est masqué par `.gitignore`.

## Ce qu'Apple demande

Pour une soumission iPhone seule : **une série 6,9 pouces portrait** — 1290 × 2796 ou 1320 × 2868 (1260 × 2736
également accepté) — de 1 à 10 images, PNG ou JPEG, RVB, sans canal alpha. Apple redimensionne seule pour tous les
iPhone plus petits. Sans série 6,9″, une série 6,5″ devient obligatoire à la place. L'icône 1024 × 1024 est
exigée, et elle est livrée dans le build. Une vidéo App Preview reste facultative.

**Couverture : 0 des 1 tailles requises.**

## Le plan existe, la production n'a pas eu lieu

`Docs/AppStore/SCREENSHOT_PLAN.md` fixe la série 6,9″ à 1290 × 2796, décrit **huit captures obligatoires** et deux
optionnelles, et donne pour chacune les arguments de lancement exacts qui amènent l'écran dans l'état voulu, puis
la séquence `xcrun simctl boot / launch / io screenshot`.

Une recette complète, zéro image produite. La checklist le dit sans détour : « à produire, aucune n'existe encore ».

**Attention à un piège du plan** : les arguments de lancement qu'il utilise sont lus par `LaunchOptions`, qui
n'existe qu'en `#if DEBUG`. Les captures seront donc prises sur une build **Debug**. C'est acceptable — l'apparence
est identique — mais il faut le savoir et vérifier qu'aucun recouvrement de développement n'est visible avant de
livrer les images.

## Deux décisions encore ouvertes

1. **iPhone seul ou iPhone + iPad ?** Le projet se construit avec `TARGETED_DEVICE_FAMILY = 1,2`, et le bundle
   Release contient bien une icône iPad. Publier pour iPad ajouterait une série 13″ obligatoire. Restreindre la
   disponibilité à l'iPhone dans App Store Connect évite cela sans toucher au code.
2. **La capture de relecture de l'achat intégré.** App Store Connect exige une image de l'écran « accès complet »
   pour le non consommable. Elle n'existe pas non plus.

## Verdict

```
CAPTURES : MISSING
```

C'est, avec les deux URL, ce qui empêche le plus directement une soumission — et c'est entièrement réalisable en
local, sans Apple.
