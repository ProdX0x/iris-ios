# 02 — Apprentissage progressif du chapitre I

## 1. Ce que le joueur traverse

| Étape | Ce qui se passe |
|---|---|
| Avant I-1 | trois écrans expliquent le repère (document 04 §3 et `GazeIntroductionPage`) |
| **I-1** | repère **visible en permanence** |
| **I-2** | repère **visible en permanence** |
| **I-3** | repère **entier au début**, puis **disparition progressive** |
| **I-4 et suivants** | plus aucune surcharge : le mode choisi s'applique |

La surcharge pédagogique **ignore le mode choisi** : même en Classique, I-1 et I-2 montrent le repère. C'est
l'apprentissage, et il a lieu une fois.

## 2. La disparition de I-3

Mécanisme retenu, et pourquoi.

Le §7 du mandat demande de préférer un signal de progression normalisé **s'il existe déjà et s'il est fiable**.
Il n'en existe pas pour un niveau de chapitre I : la progression d'un niveau ordinaire est la position des lueurs,
qui dépend du joueur et n'est pas monotone. La seconde option est donc retenue : **une durée de jeu actif,
déterministe et centralisée, pause exclue**.

Cette durée existe déjà : **`GameSession.elapsed`**, qui n'avance que dans `tick()`, appelé seulement en phase
`.playing`. Aucune horloge n'a été ajoutée, et **aucune logique de niveau n'a été modifiée pour obtenir ce signal**.

| Constante | Valeur | Effet |
|---|---|---|
| `learningHold` | 12 s | le repère reste entier |
| `learningFade` | 18 s | il décroît linéairement jusqu'à disparaître |

Soit : opacité 1 jusqu'à 12 s de jeu actif, puis décroissance régulière, éteinte à 30 s. La descente est
**linéaire et continue** : jamais une coupure.

À 21 s (mi-parcours de la descente) l'opacité vaut 0,5 — un test vérifie qu'elle est bien partielle, ni allumée ni
éteinte, pour interdire une disparition brutale déguisée.

Le niveau 1-3 (« le fil des balises ») a un par de 30 s : la disparition accompagne donc la durée attendue du
niveau, sans jamais la piloter.

## 3. Quand l'apprentissage est-il fini ?

**Il est déduit de la progression déjà enregistrée, pas stocké une deuxième fois.**

```swift
var hasCompletedGazeLearning: Bool {
    guard let final = Campaign.level(id: "1-3") else { return true }
    return progress.isCompleted(final)
}
```

Le mandat demande de ne pas multiplier les drapeaux si l'architecture existante peut exprimer la chose plus
proprement. `CampaignProgress` sait déjà si 1-3 est terminé ; c'est exactement l'information voulue, elle survit
comme la progression survit, et elle ne peut pas se désynchroniser d'elle.

Conséquence : **rejouer I-1, I-2 ou I-3 après avoir terminé 1-3 respecte le mode choisi.** Trois assertions le
vérifient, pour les trois modes.

Un joueur qui a fini 1-1 et 1-2 mais pas 1-3 est encore en apprentissage : il n'a pas terminé ce qui l'enseigne.

## 4. Le seul drapeau ajouté, et pourquoi

`OnboardingStore.hasSeenGazeIntroduction`.

Il ne peut pas être déduit de la progression : un joueur peut ouvrir 1-1 sans le terminer, et l'introduction ne doit
pas revenir à chaque tentative. Il rejoint donc l'objet qui porte déjà « cette explication a-t-elle été vue »,
plutôt que de créer un nouvel endroit.

## 5. Comment le moteur reçoit la réponse

`GameViewModel` ne connaît pas la progression. Il **demande** à son navigateur, comme il demande déjà s'il peut
continuer vers le niveau suivant :

```swift
func gameHasCompletedGazeLearning() -> Bool
```

`AppCoordinator` répond depuis la progression. Le moteur de jeu n'apprend donc ni le chapitre, ni le tutoriel, ni le
mode : il pose une question et applique une opacité.

## 6. L'introduction

Elle est présentée **avant** le premier lancement de 1-1, par `AppCoordinator.play(_:)` : le niveau est mis de côté,
la feuille s'ouvre, et le niveau démarre quand les trois écrans ont été lus. Si la feuille est refermée sans être
lue, rien ne démarre et elle reviendra — aucun état intermédiaire n'est laissé derrière.

Elle est **revoyable à tout moment** depuis Réglages → Aide au regard → « Revoir l'explication », auquel cas elle ne
lance aucun niveau.
