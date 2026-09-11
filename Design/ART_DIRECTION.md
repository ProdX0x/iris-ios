# Iris — direction artistique

## 1. Concept : la chambre noire

Iris se joue **à l'intérieur d'un œil qui regarde**. Le champ est une chambre noire : un espace sombre, profond, légèrement vivant, où la lumière est rare et précieuse. Les lueurs sont des particules de lumière. Les points d'arrivée sont des **iris**, des diaphragmes qui se referment autour d'elles. Le regard du joueur n'est jamais dessiné : on ne voit que son effet, la lumière qui se trouble et fuit.

Trois idées guident chaque décision :

1. **Ouverture et fermeture.** Le diaphragme est la forme maîtresse : emblème, iris, progression, transitions.
2. **La lumière est l'attention.** L'ambre, chaud et rare, marque ce qui demande ou reçoit l'attention (veilleuses, action principale, prochain niveau).
3. **Le calme lisible.** Peu d'éléments, contrastes francs, formes nettes, mouvement lent.

## 2. Ce que l'on abandonne du prototype

- **La perspective** (horizon, sol en fuite, échelle selon la hauteur) : la physique est plane. Une lueur dessinée plus petite en haut semblait plus lointaine, alors qu'elle se comportait exactement comme en bas. Iris est vu **de face**, sans profondeur trompeuse. La profondeur vient de la lumière (halo, vignettage, champ qui respire), pas de la géométrie.
- **Les sphères grises en dégradé radial** : remplacées par des lueurs émissives.
- **Les cinq couleurs de séquence arbitraires** : remplacées par trois teintes douces et des points de rang.
- **Les textes de statut** et le gris de navigateur (#16171a).

## 3. Palette

| Rôle | Nom | Valeur | Usage |
|---|---|---|---|
| Fond profond | encre | #07080B | fond du champ, écrans |
| Fond | abysse | #0D0F14 | cartes, surfaces |
| Surface élevée | ardoise | #161922 | feuilles, pause |
| Ligne | trait | #262A35 | séparateurs, contours |
| Texte principal | nacre | #ECE7DC | titres, corps |
| Texte secondaire | brume | #A7A399 | descriptions |
| Texte tertiaire | cendre | #6D6A63 | notes |
| Attention | ambre | #F2B35A | action principale, veilleuses, prochain niveau |
| Attention profonde | braise | #C9812F | lames d'iris actives |
| Réussite | menthe | #7FE0C0 | validation, éclats |
| Trouble | corail | #FF7A5C | intrusion, perte |
| Courant | marée | #5E93BF | flux (toujours à faible opacité) |
| Lueur | nacre lumineuse | #F4EFE4 | cœur des lueurs |
| Rang 1 | sable | #E9C98A | séquence 1 |
| Rang 2 | givre | #9CC3E6 | séquence 2 |
| Rang 3 | orchidée | #DBA3CF | séquence 3 |

Règles : l'ambre ne sert jamais à la décoration ; une seule surface ambrée par écran. Le corail n'apparaît que pendant un trouble. La menthe n'apparaît que pour une réussite.

## 4. Formes

- **Lueur** : disque émissif. Cœur nacré, halo en dégradé radial (addition lumineuse), rayon 20 pt (× 1,2 lourde, × 0,8 vive). Le rang est marqué par des points au centre (1, 2 ou 3) teintés de la couleur de rang. La lueur *vive* scintille légèrement, la *lourde* a un halo plus dense.
- **Iris (arrivée)** : anneau fin (1 pt) et **six lames** (arcs de 40°) qui se referment de l'extérieur vers l'intérieur à mesure que la présence progresse. Fermé, c'est un disque menthe ceint d'un halo. Iris d'un rang : petit arc de couleur de rang et points de rang à l'extérieur, en haut. Iris fermé par une veilleuse éteinte ou un regard hors écran : lames grisées, opacité 35 %.
- **Courant** : bande invisible dont seuls les **filaments** sont dessinés : 20 à 40 traits courts, couleur marée à 25 %, qui défilent dans la direction du flux. Les bords de la bande sont suggérés par l'extinction des filaments.
- **Voile** : membrane. Trait central nacré à 55 %, épaisseur 3 pt, doublé d'une lueur diffuse de 10 pt à 8 %. Extrémités arrondies.
- **Veilleuse** : petite flamme en goutte, ambre, dans un anneau de charge (arc ambre qui se vide). Faible : la flamme vacille et l'anneau passe au corail sous 30 %. Éteinte : braise grise et anneau pointillé.
- **Trouble** : onde corail (anneau qui s'élargit et s'efface en 0,4 s) autour d'une lueur repoussée. Son opacité est proportionnelle à la force.
- **Voie** (aide) : pointillés nacrés à 18 %, points de 2 pt espacés de 10 pt.
- **Champ** : vignettage radial (encre au bord, abysse au centre) et **fibres d'iris** très discrètes (80 rayons fins à 3 % d'opacité) centrées sur l'écran, statiques. Le champ « respire » : la luminosité du centre varie de ± 2 % sur 8 s.

## 5. Typographie

- **Titres** : New York (serif système), graisse régulière, **en minuscules** (« la brèche », « atteint », « regard prêt »). Tailles Dynamic Type `.largeTitle` et `.title`.
- **Sourcils** : SF Pro, `.caption` semi-gras, **capitales espacées** (tracking 2), couleur brume ou ambre.
- **Corps** : SF Pro `.body` / `.callout`, couleur brume.
- **Numéraux de chapitre** : chiffres romains en serif (I, II, III…), niveau en chiffres arabes : « III · 2 ».
- **Mesures** : chiffres à chasse fixe (`.monospacedDigit()`).

## 6. Emblème et icône

Le diaphragme à six lames entrouvert, ambre sur encre, avec une petite lueur nacrée au centre. L'icône d'application reprend l'emblème à plat. Aucune pupille littérale ni œil figuratif.

## 7. Mouvement

- **Lent et amorti.** Courbes `easeInOut` et ressorts très amortis. Aucun rebond cartoon.
- **Le monde bouge, l'interface reste.** Les éléments d'interface apparaissent en fondu, et seules les lames d'iris et les lueurs ont du mouvement propre.
- **Fermeture** : la fin d'un niveau referme le dernier iris, puis le champ s'assombrit de 30 % pendant 0,5 s avant le résultat.
- **Réduire les animations** : respiration, scintillement, filaments en mouvement et onde de trouble sont remplacés par des états fixes.

## 8. Son

- **Nappe d'ambiance** par chapitre : deux sinus graves en quinte, gain très faible, fondue en entrée et en sortie. Fondamentales : I 110 Hz, II 123,5 Hz, III 98 Hz, IV 130,8 Hz, V 116,5 Hz, VI 146,8 Hz.
- **Crescendo, carillon, perte** : ceux du prototype, conservés.
- **Veilleuse faible** : battement doux (990 Hz, 60 ms), au plus une fois par seconde.
- **Niveau atteint** : arpège ascendant de 4 notes (440, 554, 660, 880 Hz), plus lent que le carillon, qui le remplace.
- Aucune musique mélodique : l'attention du joueur doit rester libre.

## 9. À faire / à éviter

| À faire | À éviter |
|---|---|
| Une seule idée visuelle par élément | Verre dépoli, reflets, néons « parce que c'est moderne » |
| Lumière additive pour les lueurs | Dégradés décoratifs sur les fonds d'interface |
| Contraste fort texte/fond | Gris sur gris |
| Formes géométriques simples (cercles, arcs, segments) | Illustrations, personnages, textures lourdes |
| SF Symbols seulement dans l'interface | SF Symbols dans le monde du jeu |
| Silence et vide | Remplir chaque zone de l'écran |
