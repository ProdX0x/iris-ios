# 10 — Microcopie de la pause, clarté de la calibration, accessibilité

Raffinement du 17 septembre 2026, après la revue physique de l'accès en pause (document 09).

## Ce que la revue a trouvé

L'accès en pause fonctionnait. Mais trois mots nus —

> Classique · Guidé · Visible

— ne disent rien à quelqu'un qui découvre le jeu. L'ancienne présentation, plus lourde, expliquait au moins le
mode actif ; la nouvelle, plus rapide, avait perdu cette explication. Et une ligne comme

> Calibration réussie — écart moyen 8 %.

est exacte sans être compréhensible : 8 % de quoi, et est-ce bien ?

## La règle de produit, inchangée

| | Rôle |
|---|---|
| **Réglages** | l'explication détaillée — on y va pour lire |
| **Pause** | la compréhension immédiate et l'action rapide — on y est parce qu'on joue |

Rien n'a été recopié d'un écran vers l'autre.

## La microcopie de la pause

```
AIDE AU REGARD

○ Classique
  Sans repère

○ Guidé
  Repère ponctuel

◉ Visible
  Repère permanent
```

Deux mots, jamais une phrase, jamais un point final : ce sont des étiquettes, pas de la prose. Un test tient
chacune à vingt caractères, sans vocabulaire technique et sans rien qui puisse se lire comme une promesse de
santé — Iris est un jeu.

Les Réglages gardent mot pour mot leurs explications longues. Un test vérifie qu'elles n'ont pas été remplacées
par les étiquettes courtes, et qu'elles restent plus longues qu'elles.

## Une seule règle décide de ce qu'une ligne dit

`GazeAssistancePicker.meaning(for:variant:)`. La vue l'appelle pour dessiner la ligne **et** pour répondre à
VoiceOver. Le texte lu et le texte affiché ne peuvent donc pas diverger — c'est la même expression, pas deux
expressions tenues en accord.

| | Réglages (`.detailed`) | Pause (`.compact`) |
|---|---|---|
| Dessiné | `mode.summary` | `mode.compactSummary` |
| Annoncé | `mode.summary` | `mode.compactSummary` |
| VoiceOver dit | « Classique, le repère reste masqué… » | « Classique, sans repère » |

Le marqueur rond reste masqué à VoiceOver : la sélection est un *trait*, pas un mot de plus.

## La calibration

Le chiffre ne bouge pas. La même moyenne, le même arrondi, les mêmes mots autour. Une ligne s'ajoute dessous :

> Plus l'écart est faible, plus le suivi du regard est précis.

Elle dit dans quel sens c'est mieux. Elle ne dit pas que 0 % est exigé, ni qu'on l'atteint, ni qu'Iris mesure
quoi que ce soit de médical — un test le vérifie mot par mot. L'explication plus complète, celle qui pose 0 %
comme référence idéale, reste où elle était : dans les trois écrans d'introduction. Elle n'est pas recopiée ici.

Quand aucune calibration n'existe, il n'y a pas de chiffre à expliquer : la ligne dit alors quoi faire.

Cette propriété, `GazeCalibrationStatus.explanation`, existait depuis le Gate 3 sans être affichée nulle part.
Elle est maintenant utilisée, avec la phrase demandée.

## Ce qui a été vérifié par la machine

`sizeThatFits` sur un `UIHostingController`, le harnais que `ChapterCardLayoutTests` utilise déjà :

- le sélecteur compact **et** le sélecteur détaillé tiennent dans la largeur utile de chaque iPhone supporté
  (279 à 324 pt), à `large`, `xxxLarge`, `accessibility2` et `accessibility5` ;
- les phrases longues — note d'apprentissage, état et aide de calibration — grandissent en hauteur quand le texte
  grandit, ce qui est la signature d'un retour à la ligne et non d'une coupe ;
- le sélecteur verrouillé est plus haut que le sélecteur libre, donc la raison est bien affichée.

## Ce que la machine ne sait pas dire

Ce que VoiceOver prononce réellement, et si le panneau reste confortable une fois le texte agrandi sur un vrai
iPhone. Ces points sont dans le document 07, section finale, P à X. Ils ne sont pas cochés.

## Coût

Nul pendant le jeu. Le panneau de pause n'existe que dans la phase `.paused`. Aucun timer, aucune session ARKit,
aucun écouteur, aucun état observable ajouté : quatre chaînes de caractères et une `Text` de plus.
