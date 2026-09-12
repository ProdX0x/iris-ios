# Iris — vision UX

## 1. Principes

1. **Une fonction par écran.** Chaque écran répond à une seule question : *où j'en suis ?*, *qu'est-ce qui m'attend ?*, *comment ça s'est passé ?*
2. **Le jeu enseigne, l'interface se tait.** Aucune règle à lire avant de jouer. Les consignes arrivent au moment où elles servent et disparaissent.
3. **Les yeux jouent, les doigts naviguent.** Aucun élément interactif ne se trouve dans le champ de jeu pendant une partie, sauf la pause (coin supérieur droit, 44 pt).
4. **Rien ne capte le regard pendant le jeu.** Pas de compteur, pas de chronomètre, pas de texte animé au centre. Les consignes sont en bas, petites et fixes.
5. **Continuité.** L'accueil propose toujours la chose suivante à faire, en un bouton.
6. **Réversible.** Tout écran a une sortie claire. Rien n'est perdu en quittant.

## 2. Parcours

### Premier lancement

```
Seuil (accueil) ─ Commencer
  → Permission caméra (explication puis demande iOS)
  → Compatibilité TrueDepth (sinon : écran « regard indisponible »)
  → Regard : diagnostic → calibration 9 points → vérification 5 points → « regard prêt »
  → Niveau I-1 « Premier regard » (tutoriel joué)
  → Résultat → I-2 …
```

Objectif : moins de 90 s entre l'ouverture et la première validation.

### Lancements suivants

```
Seuil ─ Continuer (II · Partage — 3 « Garde »)
  → Regard : diagnostic → vérification 5 points (revalidation du profil)
  → Niveau
Seuil ─ Chapitres → Carte → niveau débloqué → (regard validé dans la session ? sinon revalidation) → niveau
```

### En jeu

```
Intro du niveau (carte) ─ toucher → Jeu ─ pause → Pause (reprendre · recommencer · chapitres · réglages du regard)
                                     └ dernier iris fermé → Résultat (éclats) ─ suivant · rejouer · chapitres
Dernier niveau du chapitre VI → Fin de parcours
```

## 3. Écrans

### 3.1 Seuil (accueil)

- **Fonction** : reprendre en un geste.
- **Contenu** : emblème diaphragme (lent), mot-symbole « iris », phrase « Ce que vous regardez s'éloigne. ». Bouton principal *Commencer* (premier lancement) ou *Continuer* avec le libellé du prochain niveau. Bouton secondaire *Chapitres*. Icône *Réglages*.
- **Hiérarchie** : emblème puis action principale. Aucune liste, aucun texte long.

### 3.2 Regard (diagnostic, calibration, vérification, verdict)

Existant (Gaze Engine v2) et restylé. Le titre de l'étape et une ligne d'aide restent en haut. Les cibles adoptent la forme « iris ». Le verdict « regard prêt » garde le point de vérification vivant.

### 3.3 Chapitres (carte)

- **Fonction** : situer sa progression et choisir.
- **Contenu** : six chapitres empilés. Chacun porte un numéral romain, un nom, une phrase de principe, six (ou cinq) nœuds de niveau et sa progression « 4 / 6 ».
- **Nœud** : cercle avec trois arcs d'éclats (allumés ou éteints), numéro du niveau. Un nœud verrouillé est plus sombre et n'est pas interactif. Le prochain niveau est cerclé d'ambre.
- **Chapitre verrouillé** : nom visible, phrase « Terminez le chapitre II ».
- **Carnet** : lien en bas vers la page des éléments rencontrés.

### 3.4 Intro de niveau (dans l'écran de jeu)

- **Fonction** : dire en 3 secondes ce que le niveau demande.
- **Contenu** : sourcil « III · Courants — 2 », titre (serif), principe (une phrase). Si le niveau introduit un élément : pastille « nouveau » avec le glyphe. Action : toucher n'importe où, ou le bouton *Commencer*.
- Le niveau est déjà visible, voilé, derrière la carte : le joueur lit la géométrie avant de jouer.

### 3.5 Jeu

- **Champ** : plein écran. Seuls les éléments du monde sont visibles.
- **Haut gauche** : « III · 2 » en petit (lecture périphérique).
- **Haut droite** : pause, 44 pt.
- **Bas** : zone de consigne (une ligne, deux au plus), fondu entrant et sortant.
- **Voie** (aide) : pointillés très fins, après 45 s.
- **Mode diagnostic** (réglage) : points brut, calibré et lissé, badges regard et son.

### 3.6 Pause

- Reprendre (action principale), Recommencer, Chapitres.
- Carte « Regard » : état de la calibration, *Recalibrer le regard*, *Afficher les points de regard*.
- Le jeu est voilé derrière.

### 3.7 Résultat

- **Fonction** : récompenser, puis relancer.
- **Contenu** : « atteint » (serif), les trois éclats qui s'allument l'un après l'autre (atteint, fluide, serein) avec leur libellé et leur condition, les mesures (temps, intrusions, validations perdues), le rappel du meilleur résultat si différent.
- **Actions** : *Suivant* (principal), *Rejouer*, *Chapitres*.
- **Haptique** : succès à l'apparition.

### 3.8 Réglages (feuille)

Effets sonores, ambiance sonore (coupée par défaut depuis le test du 12 septembre 2026), vibrations, points de regard (diagnostic), *Recalibrer le regard*, *Carnet*, *Réinitialiser la progression* (confirmation destructive), note de confidentialité.

### 3.9 Carnet

Liste des éléments rencontrés (glyphe, nom, une phrase, niveau d'introduction). Les éléments non rencontrés affichent « ? ».

### 3.10 Fin de parcours

« clairvoyance » en titre, total des éclats (n / 102), temps de jeu cumulé, *Rejouer un chapitre*, *Seuil*.

## 4. Consignes contextuelles

- Déclenchées par le moteur : départ, première intrusion, premier maintien, première validation, première perte, première sortie de l'écran, première veilleuse faible, et 45 s écoulées.
- Chaque consigne n'apparaît qu'une fois par tentative. Elle reste 4 s ou jusqu'à la suivante.
- Ton : impératif doux, tutoiement exclu, phrases de moins de 60 caractères.

## 5. Mouvement et transitions

- Entre routes : fondu de 0,45 s avec un léger zoom. Si « Réduire les animations » est actif : fondu seul.
- Intro → jeu : la carte se dissout et le voile se lève (0,35 s).
- Résultat : les éclats s'allument l'un après l'autre (0,25 s d'écart).
- Aucune animation ne dépasse 0,6 s, sauf l'emblème de l'accueil et la respiration du champ (lente, désactivée avec « Réduire les animations »).

## 6. Accessibilité

- Tout texte d'interface suit Dynamic Type. Les écrans défilent aux tailles d'accessibilité.
- Cibles de toucher ≥ 44 pt.
- VoiceOver : tous les écrans de navigation sont décrits. La carte annonce « Chapitre III, Courants, 4 niveaux sur 6 atteints ». Un nœud annonce « Niveau 2, La brèche, 2 éclats sur 3 ». Le champ de jeu est masqué : le jeu repose sur le regard, et l'état est annoncé par les consignes, qui sont des annonces d'accessibilité.
- Couleurs : la séquence n'est jamais portée par la couleur seule (points de rang 1, 2, 3 dans la lueur et près de l'iris). Contraste du texte ≥ 4,5:1.
- « Réduire les animations » : pas de respiration, courants rendus par des traits fixes, pas de rotation des lames.
- Son facultatif : aucun retour indispensable n'est uniquement sonore.

## 7. Critères d'acceptation UX

- Un nouveau joueur termine I-1 sans lire autre chose que les consignes.
- Depuis l'accueil, reprendre sa partie demande un toucher, plus la revalidation du regard.
- Aucun écran ne propose plus d'une action principale.
- Pendant le jeu, aucun texte n'apparaît dans le tiers central de l'écran.
