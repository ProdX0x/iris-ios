# 10 — Addendum de relecture du Gate 2

Court addendum de précision méthodologique, écrit après coup. **L'historique Git du Gate 2 n'est pas réécrit** : les
documents 01 à 09 restent tels qu'ils ont été produits, et celui-ci les précise.

---

## Statuts retenus

```
PERFORMANCE:
NOT REPRODUCED AS A RELEASE-BLOCKING REGRESSION
```

Raisons :

- une session longue et représentative de jeu réel a été mesurée ;
- aucune croissance monotone de la mémoire résidente (plate à 119,1–119,2 Mo sur près de dix minutes) ;
- aucune latence ressentie par l'utilisateur, ni sur l'iPhone 14 Pro ni sur l'iPhone 15 Pro ;
- **le frame pacing et les hitches n'ont PAS été instrumentés.**

```
JETSAM:
NOT ATTRIBUTABLE TO IRIS — NON-BLOCKING FOR RELEASE
```

```
FLASH:
NOT REPRODUCED UNDER INSTRUMENTATION
CAUSE NOT DETERMINED
NON-BLOCKING FOR RELEASE
```

## Précision importante sur la session longue de l'iPhone 14 Pro

La session instrumentée du 16 septembre à 21:11 a été jouée **en utilisant ponctuellement le repère de regard**,
afin que le joueur puisse franchir certains passages.

Elle est donc **valide** pour ce qu'elle mesure :

- la mémoire ;
- la stabilité ;
- l'absence de plantage ;
- l'usage réel de l'application.

Elle **n'est pas** une preuve que tous les niveaux soient confortablement jouables **sans** assistance visuelle.

Ce point ne retire rien aux conclusions du Gate 2 — aucune d'elles ne portait sur le confort de jeu sans aide — et
il **renforce la justification du Gate 3** : si une aide visuelle est nécessaire pour franchir certains passages,
alors cette aide doit devenir une fonction produit assumée, réglable et expliquée, plutôt qu'un interrupteur
étiqueté « diagnostic ».

C'est exactement ce que le Release Gate 3 met en place.
