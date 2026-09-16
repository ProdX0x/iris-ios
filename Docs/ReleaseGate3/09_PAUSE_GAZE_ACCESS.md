# 09 — L'aide au regard depuis la pause

Raffinement approuvé le 17 septembre 2026, après la validation humaine du Gate 3.

## Le problème

Changer d'aide au regard coûtait cinq écrans : Pause → Chapitres → Seuil → Réglages → Aide au regard, puis tout
le chemin inverse pour retrouver son niveau. Un joueur qui trouve le repère gênant à la troisième minute d'une
partie ne fait pas ce trajet : il subit.

## Ce qui a été fait

Le choix est désormais dans le panneau de pause, sous l'état de calibration, dans le verre qui y était déjà.
Pause → un appui → Reprendre.

## Une seule vérité, deux présentations

`GazeAssistancePicker` est le composant, et il n'y en a qu'un.

| | Réglages | Pause |
|---|---|---|
| Variante | `.detailed` | `.compact` |
| Ce qui est dessiné | nom + phrase de chaque mode | nom seul |
| Ce que VoiceOver annonce | nom + phrase + « sélectionné » | **identique** — la phrase reste la valeur d'accessibilité de la ligne |
| Lié à | `settings.gazeAssistance` | `viewModel.gazeAssistance` → `settings.gazeAssistance` |

Les deux écrivent dans la même propriété du même `GameSettingsStore`, l'instance unique que `AppContainer` donne
à la fois au coordinateur et au `GameViewModel`. Il n'y a pas de second état à synchroniser : il n'y a rien à
synchroniser. Aucune clé `UserDefaults` n'a été ajoutée — `iris.gazeAssistance`, celle du Gate 3, reste la seule,
et un test le prouve en comparant les clés du domaine avant et après trois changements faits depuis la pause.

## L'apprentissage garde le dernier mot

Pendant la première traversée de I-1, I-2 et I-3, c'est le niveau qui décide du repère. Offrir un choix qui ne
changerait rien serait un mensonge d'interface. Les trois lignes restent donc affichées — elles montrent ce que
le joueur a choisi, et ce qui s'appliquera à partir de I-4 — mais elles sont inertes, sous une phrase :

> L'aide au regard est guidée pendant les premiers niveaux d'apprentissage.

Le verrou n'est pas une nouvelle règle : `GameViewModel.isGazeLearningActive` repose la question à
`GazeAssistancePolicy.isLearning(levelID:hasCompletedLearning:)`, celle-là même qui décide déjà du repère. Les
deux ne peuvent pas diverger, parce qu'il n'y a qu'une source.

Une fois I-3 terminé, les lignes redeviennent actives partout, y compris en rejouant I-1 — exactement ce que le
Gate 3 spécifiait.

## Coût pendant le jeu

Nul. Le panneau de pause n'existe que dans la phase `.paused` ; aucun `Canvas`, aucun `TimelineView`, aucun
timer, aucune session ARKit, aucun écouteur de regard n'a été ajouté. Le setter existant appelle `refreshSnapshot()`
une fois, au moment du choix, pour que le niveau obéisse dès la reprise.

## Ce qui a bougé dans les fichiers

| Fichier | Changement |
|---|---|
| `Features/GazeAssistance/GazeAssistancePicker.swift` | **nouveau** — les trois lignes, deux variantes, le verrou d'apprentissage |
| `Features/Settings/GazeAssistanceSection.swift` | ses lignes propres remplacées par le composant partagé |
| `Features/Game/Views/GameOverlayView.swift` | deux lignes de texte mortes remplacées par le sélecteur compact |
| `Features/Game/ViewModels/GameViewModel.swift` | `isGazeLearningActive`, une propriété calculée qui repose la question à la politique |

Le panneau de pause n'a pas grandi : les deux lignes de texte qu'il affichait — dont un résumé qui repliait sur
trois lignes — occupaient à peu près la place que prennent les trois choix.

## Tests

`PauseGazeAssistanceTests`, **13 tests** — comptés à l'exécution : `Test run with 13 tests in 1 suite passed`.

Le chiffre était juste ; la phrase qui le décrivait ne l'était pas. Elle annonçait « les 10 preuves demandées,
plus la phrase du verrou et I-4 déjà libre », ce qui fait douze. En réalité :

| Preuve demandée | Test |
|---|---|
| 1 · même source de vérité | `oneSourceOfTruth` |
| 2 · CLASSIQUE persisté | `classicPersists` |
| 3 · GUIDÉ persisté | `guidedPersists` |
| 4 · VISIBLE persisté | `visiblePersists` |
| 5 · les Réglages reflètent la pause | `settingsReflectPauseImmediately` |
| 6 · I-1 première passe | `firstLevelOneProtected` |
| 7 · I-2 première passe | `firstLevelTwoProtected` |
| 8 · I-3 première passe | `firstLevelThreeProtected` |
| 9 · sélecteur actif après I-3 | `activeAfterLearning` |
| 10 · le rejeu respecte le mode | `activeAfterLearning` — **le même test** |

Les preuves 9 et 10 sont une seule assertion : rejouer I-1, I-2 et I-3 après coup, c'est exactement ce que les
deux demandent. **Dix preuves, neuf tests.** Quatre autres ne répondaient à aucune preuve numérotée et n'avaient
pas été cités :

| | Test | Ce qu'il tient |
|---|---|---|
| 10 | `noSecondKey` | aucune clé `UserDefaults` ajoutée |
| 11 | `fourthLevelIsFree` | I-4 déjà libre en première passe |
| 12 | `learningNote` | la phrase du verrou, mot pour mot |
| 13 | `compactVariantKeepsTheChoices` | les trois modes, chacun disant ce qu'il fait |

Neuf plus quatre font treize. Les deux qui manquaient à la description étaient `noSecondKey` et
`compactVariantKeepsTheChoices` ; l'écart venait de là, et d'avoir compté les preuves 9 et 10 pour deux tests.
