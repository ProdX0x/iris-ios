# 05 — Fiche App Store : ce qui existe, ce qui manque

Inventaire du 17 septembre 2026. `Docs/AppStore/` contient six documents, tous en français.

## Champ par champ

| Champ App Store Connect | État | Où / pourquoi |
|---|---|---|
| Nom | **READY** | `Iris` — identique à `CFBundleDisplayName` |
| Sous-titre | **READY** | « Le regard repousse les sphères » — 30 caractères, exactement la limite |
| Texte promotionnel | **READY** | `APP_STORE_METADATA_FR.md` |
| Description FR | **READY** | texte complet, du positionnement aux douze chapitres, se terminant par « Iris est un jeu. Il ne fait aucune promesse de santé. » |
| Description EN | **MISSING** | aucune copie anglaise. Le document annonce une « § localisation » dans la checklist : **cette section n'existe pas** |
| Mots-clés | **READY** | 98 caractères |
| Catégories | **READY** (dépôt) / **EXTERNAL** (saisie) | Jeux → Réflexion, secondaire Jeux → Occasionnel ; `LSApplicationCategoryType` cohérent |
| URL de support | **MISSING** | obligatoire ; aucune URL n'existe dans le dépôt |
| URL marketing | facultative | non fournie |
| URL de politique de confidentialité | **PARTIAL** | le **texte** est écrit ; l'URL n'existe pas, et le texte finit par « Contact : *(adresse à indiquer)* » |
| Copyright | **READY** | © 2026 Stéphane SAULNIER |
| Classification d'âge | **PARTIAL** / **EXTERNAL** | 4+ attendu, justification écrite ; le questionnaire est externe |
| Nom et description des achats intégrés | **CONFLIT** | voir ci-dessous |
| Notes pour la relecture | **READY** | `APP_REVIEW_NOTES_FR.md` — positionnement, procédure de test en 5 étapes, modèle commercial, promo, confidentialité, aucun paiement externe |
| Explication caméra / TrueDepth au relecteur | **READY** | permission demandée au premier niveau, écran d'indisponibilité sur appareil sans TrueDepth |
| Nouveautés de la version | **READY** | rédigé |
| Localisations réellement écrites | **fr-FR seulement** | aucun `.lproj`, aucun `.strings`, aucun `.xcstrings` dans le projet |

### Le conflit à trancher

Le déblocage complet a **deux descriptions différentes** dans deux documents :

| Source | Texte | Longueur |
|---|---|---|
| `APP_STORE_METADATA_FR.md` | « Ouvre tous les chapitres. Achat unique. » | tient dans la limite de 45 caractères que le document lui-même énonce |
| `STOREKIT_PRODUCTS.md` | « Débloque les douze chapitres d'Iris et tous les niveaux à venir. Achat unique, sans abonnement. » | 94 caractères — **dépasse** |

Il faut en choisir une. Ce n'est pas une correction documentaire évidente : c'est une décision produit, donc elle
n'a pas été prise ici.

## Positionnement : aucune promesse de santé

Recherche en français et en anglais de `rééduc`, `thérap`, `traitement`, `médical`, `soigner`, `guérir`, `heal`,
`cure`, `vision improvement`, `améliore la vue/vision`, `eye training`, `entraînement oculaire`, `orthopt`,
`amblyop`, `strabis`, `myop`, `presbyt`, `fatigue oculaire`, `eye strain`, `neurolog`, `cognitif`, `cognitive`,
`bienfait`, `santé`, `health`, `wellness`, `bien-être` — sur les six documents App Store, l'Info.plist, le
manifeste de confidentialité, `Docs/`, `README.md`, les dix-huit fichiers de `Design/` et `attention-indirecte.html`.

**Aucune allégation trouvée.** Chaque occurrence est une **négation** — « Iris ne promet aucun effet de santé » —
ou une ligne de questionnaire, ou un item de la liste interne « Qu'est-ce qu'Iris n'est pas ? ».

Ce n'est pas seulement rédactionnel : `CommerceBoundaryTests` test H relit chaque `.md` de `Docs/AppStore/` **et**
chaque littéral de chaîne du code produit, et échoue sur vingt-deux sous-chaînes interdites. Quatre autres suites
tiennent la même ligne sur la copie du jeu.

Les quatre éléments de positionnement demandés sont présents et exacts : le jeu, le regard qui repousse, l'attention
qu'on déplace à côté, douze chapitres dont trois gratuits et un achat unique.

**Deux formulations internes à surveiller**, dans `Docs/product.md` : « trains my attention » et « attention
training ». Ces fichiers ne partent pas à Apple, mais ils ne doivent jamais être recopiés dans la fiche.
Le même `Docs/product.md` est par ailleurs périmé (« 14 levels »), comme `Docs/project-brief.md` (« Free. No
StoreKit »). Incohérence interne, pas risque de relecture.

## Verdict

```
MÉTADONNÉES : PARTIAL
```

Le texte français est prêt et sûr. Manquent : les deux URL obligatoires, la décision sur la description de
l'achat, et — si l'anglais est voulu au lancement — toute la copie anglaise.
