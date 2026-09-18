# Localisation — état canonique français (EN-3)

Iris est français. Cette phase ne traduit rien : elle constitue les deux catalogues français canoniques, pour qu'une
traduction anglaise (EN-4) puisse être écrite sans jamais avoir à toucher au code.

## Les deux tables

| Table | Fichier | Clés | Ce qu'elle contient |
|---|---|---|---|
| `Gameplay` | `Resources/Gameplay.xcstrings` | 417 | Chapitres, niveaux, éléments, éclats, et chaque instruction contextuelle |
| `Localizable` | `Resources/Localizable.xcstrings` | 238 | Tout ce que l'application dit d'elle-même |

`sourceLanguage = fr` pour les deux. Aucune entrée ne porte d'autre langue que le français.

## Comment ils sont produits

Aucune phrase du corpus n'est recopiée à la main. `Tests/IrisTests/Presentation/LocalizationCatalog.swift` énumère
les clés depuis ce qui les possède — la campagne, les énumérations, les sites d'appel écrits dans l'application — et
`LocalizationCatalogTests` vérifie ensuite que les fichiers sur disque disent exactement cela. Le générateur et le
vérificateur sont le même code : un catalogue ne peut pas dériver en silence.

Régénérer, après une modification du corpus :

```sh
touch .write-catalogs
xcodebuild test -project Iris.xcodeproj -scheme Iris -configuration Debug \
  -destination "platform=iOS Simulator,id=<UDID>" -only-testing:IrisTests/LocalizationCatalogTests
rm -f .write-catalogs
```

Sans le fichier témoin, aucun test n'écrit jamais dans le dépôt.

## Phrases à paramètres

24 entrées portent des paramètres (`%@`, `%lld`). Leur commentaire décrit chaque paramètre dans l'ordre : une
traduction qui en perd un, en ajoute un ou en change le type est un plantage, pas une maladresse. Une phrase entière
est toujours localisée d'un bloc — jamais des fragments recollés — à deux exceptions documentées :
`common.list.conjunction` (« et », qui joint deux numéros de chapitre dans une liste) et `gazeStatus.line` (qui
n'ajoute qu'un point final).

2 entrées déclarent un pluriel (`eclats.outOfThree.value`, `eclats.total.value`), compilées dans
`fr.lproj/Localizable.stringsdict`. **Les deux catégories françaises portent la même phrase**, volontairement : le
français correct dirait « 1 éclat », mais cette phrase a été validée et photographiée telle quelle, et EN-3 ne change
pas un caractère du français validé. Le logement du pluriel existe pour que l'anglais — et, le jour où quelqu'un le
décide, le français — s'écrive sans déplacer de clé.

## Dette de localisation bloquée par le gel

Trois ensembles ne peuvent pas être localisés sans modifier un fichier gelé. Aucun contournement n'a été tenté.

### 1. Titres de navigation — 7 chaînes, clés réservées

`AppSheet.title` (4) et `AppDestination.title` (3) ne sont affichés qu'à un seul endroit,
`Navigation/RootView.swift`, qui est gelé et les lit directement : aucune couture n'existe entre les deux.

Les identités sont fixées malgré tout dans `Features/Shared/NavigationText.swift`, et les 7 clés sont au catalogue
avec la mention `RESERVED` — elles sont donc traduisibles dès EN-4. Le jour où le gel de `RootView` est délibérément
revisité, chaque site d'appel devient un changement d'une ligne.

### 2. Détails des vérifications du regard — 30 clés, non nommables

`GazeReadinessText.detailKey(for:status:)` produit une clé par (vérification, état), mais les phrases correspondantes
sont composées dans `AR/Calibration/GazeReadinessEvaluator.swift`, gelé, et **une même paire en produit plusieurs** :
`.session` + `.fail` en a trois (« Session interrompue », « Indisponible », « Erreur »), et
`.eyeTracking` + `.pass` est construite avec une mesure prise à l'instant (« Distance 45 cm »).

Une clé qui ne nomme pas une phrase unique ne doit pas recevoir de valeur canonique : la traduire fondrait trois
messages différents en un seul. Ces clés sont donc **absentes du catalogue**, et le test X interdit qu'on les y
ajoute. Les **noms** des vérifications (`gazeReadiness.check.<kind>.title`, 10 clés) viennent d'une énumération propre
et sont, eux, au catalogue.

### 3. Ligne de niveau du seuil — résolue

`AppCoordinator.label(for:)` compose cette ligne dans un fichier gelé et la livre déjà assemblée. `HomeView` n'étant
pas gelé et disposant du niveau lui-même, la ligne est recomposée à partir de clés dans `NavigationText.label(for:)`.
Le risque de divergence entre les deux compositions est tenu par un test : elles doivent coïncider caractère pour
caractère sur les 141 niveaux de la campagne.

## Ce que EN-4 devra vérifier

`LocalizationCatalogTests.keysAwaitingEnglish(in:)` retourne les clés d'une table encore dépourvues d'anglais.
Aujourd'hui : toutes. Quand EN-4 aura fait son travail, cette liste sera vide, et c'est l'assertion à inverser.
