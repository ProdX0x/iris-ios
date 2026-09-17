# Méthodologie — index

Ce dossier contient la **connaissance d'ingénierie réutilisable** extraite du projet Iris le 17 septembre 2026.

Il est délibérément séparé de l'état du projet. Deux choses, deux durées de vie :

| | Où | Périme |
|---|---|---|
| **État du projet** — branche, HEAD, Gates, problèmes ouverts | `Docs/session-handoffs/` | à chaque commit |
| **Connaissance réutilisable** — comment travailler, prouver, décider | **ici** | lentement, et seulement avec des preuves |

Une session qui reprend le travail lit **d'abord** le handoff (« où en est-on ? »), **puis** ceci (« comment
travaille-t-on ? »).

---

## Les documents

| Document | Ce qu'il contient | Pour qui |
|---|---|---|
| [`AI_ASSISTED_ENGINEERING_METHOD.md`](AI_ASSISTED_ENGINEERING_METHOD.md) | La méthode : niveaux de preuve, expérimentation réversible, Gates, gel, Git, preuve humaine, handoff, collaboration avec un agent, conflits de règles, calibration | **le document principal** ; à lire en entier une fois |
| [`IRIS_CASE_STUDY.md`](IRIS_CASE_STUDY.md) | Les faits qui ont produit ces règles, y compris les erreurs et les fausses pistes | qui veut savoir **pourquoi** une règle existe |
| [`KNOWLEDGE_CLASSIFICATION.md`](KNOWLEDGE_CLASSIFICATION.md) | Ce qui est propre à Iris, propre à Apple, réutilisable, propre à l'IA, à réévaluer sur Android — plus une taxonomie pour stocker la suite | qui veut savoir **ce qui voyage** |
| [`SKILL_ARCHITECTURE_BLUEPRINT.md`](SKILL_ARCHITECTURE_BLUEPRINT.md) | Une modularisation future en Skills, avec sept fiches candidates et l'analyse de recouvrement avec les 19 skills iOS existants | plus tard, et seulement après un second projet |
| [`ANDROID_TRANSFER_MAP.md`](ANDROID_TRANSFER_MAP.md) | Ce qui se transfère, ce qui se remesure, ce qui ne se porte pas — et la question préalable go/no-go | avant d'envisager Android |
| [`SOURCE_INDEX.md`](SOURCE_INDEX.md) | Les sources réellement lues, et pourquoi chacune a de la valeur | qui veut remonter aux preuves originales |

---

## Le noyau, en dix lignes

Si rien d'autre n'est lu :

1. **Mesurer avant de modifier.** L'état de départ est un fait, pas un souvenir.
2. **Nommer le niveau de preuve** de chaque conclusion — et ce qu'elle ne couvre pas.
3. **Préférer l'expérience réversible.** Une action destructive exige une justification supérieure tant qu'une
   expérience réversible peut encore discriminer.
4. **Ne changer qu'une variable**, et prouver la restauration par hash **et** diff.
5. **Rapporter une ambiguïté comme ambiguë.** C'est ce qui débloque, pas ce qui ralentit.
6. **Rendre les règles exécutables.** Un test attrape ce qu'une relecture ne voit pas.
7. **Geler ce qui est validé**, et écrire ce qui le rouvrirait.
8. **Décider est permis sans preuve complète** — à condition d'écrire à quel niveau et ce qui ferait revenir.
9. **La machine et l'humain prouvent des choses différentes.** Ni l'un ni l'autre n'est supérieur.
10. **Ce qui doit survivre à la session doit être dans le dépôt.**

---

## Statut de ce dossier

**Ce n'est pas une doctrine.** Ces règles viennent d'**un** projet : une application Apple, un développeur, un
agent IA, un domaine où le matériel et l'argent rendent les erreurs coûteuses. Sur un outil interne jetable, la
plupart sont du luxe.

Trois limites à garder en tête :

- aucune règle ici n'a été testée **contre son absence** ;
- le coût du formalisme n'a pas été mesuré ;
- les règles qui n'ont jamais rien attrapé sont invisibles — et ce sont celles qu'il faudrait supprimer.

**Ces documents ne sont pas des Skills**, et ne doivent pas le devenir avant qu'un second projet les ait éprouvés.
