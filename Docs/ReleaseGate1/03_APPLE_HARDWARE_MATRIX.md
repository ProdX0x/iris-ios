# 03 — Matrice matérielle officielle Apple : iPhone 14 Pro / iPhone 15 Pro

Règle appliquée : **seules les pages Apple font foi**. Aucun blog, forum, Reddit ou banc d'essai non officiel n'est
utilisé comme source de capacité matérielle. Aucune donnée absente n'est remplacée par une estimation.

Sources, consultées le **16 septembre 2026** :

- iPhone 14 Pro — Caractéristiques techniques : <https://support.apple.com/en-us/111849>
- iPhone 15 Pro — Caractéristiques techniques : <https://support.apple.com/en-us/111829>
- `ARFaceAnchor.lookAtPoint` — documentation développeur :
  <https://developer.apple.com/documentation/arkit/arfaceanchor/lookatpoint>

---

## 1. Matrice

Les libellés entre guillemets sont **cités mot pour mot** des pages Apple ci-dessus.

| Donnée | iPhone 14 Pro | iPhone 15 Pro | Différence ? |
|---|---|---|---|
| Identifiant modèle (mesuré sur l'appareil, pas publié) | `iPhone15,2` | `iPhone16,1` | oui |
| SoC | « A16 Bionic chip » | « A17 Pro chip » | **oui** |
| CPU | « 6‑core CPU with 2 performance and 4 efficiency cores » | « New 6‑core CPU with 2 performance and 4 efficiency cores » | même structure |
| GPU | « 5‑core GPU » | « New 6‑core GPU » | **oui (5 → 6 cœurs)** |
| Neural Engine | « 16‑core Neural Engine » | « New 16‑core Neural Engine » | même nombre de cœurs ; **aucun débit publié sur ces pages** |
| Écran | « Super Retina XDR display », « 6.1‑inch (diagonal) all‑screen OLED display » | idem, mot pour mot | non |
| Résolution / densité | « 2556‑by‑1179-pixel resolution at 460 ppi » | « 2556‑by‑1179-pixel resolution at 460 ppi » | **non** |
| Taux de rafraîchissement | « ProMotion technology with adaptive refresh rates up to 120Hz » | idem | **non** |
| Luminance | « 1000 nits max brightness (typical); 1600 nits peak brightness (HDR); 2000 nits peak brightness (outdoor) » | idem | **non** |
| Caméra TrueDepth — définition | « 12MP camera » | « 12MP camera » | **non** |
| Caméra TrueDepth — ouverture | « ƒ/1.9 aperture » | « ƒ/1.9 aperture » | **non** |
| Caméra TrueDepth — mise au point | « Autofocus with Focus Pixels » | « Autofocus with Focus Pixels » | **non** |
| Caméra TrueDepth — optique | « Six‑element lens » | *non énoncé en ces termes sur la page 15 Pro* | **UNKNOWN** |
| Caméra TrueDepth — vidéo | « 4K video recording at 24 fps, 25 fps, 30 fps, or 60 fps » | idem | **non** |
| Face ID | « Enabled by TrueDepth camera for facial recognition » | idem | **non** |
| LiDAR | non mentionné | « LiDAR Scanner » (capteur **arrière**, cité pour « Night mode portraits ») | oui, **sans rapport avec le regard** |

## 2. Lecture

**FACT.** Sur les deux pages officielles, **la caméra TrueDepth est décrite dans les mêmes termes** : 12 Mpx,
ƒ/1.9, autofocus avec Focus Pixels, mêmes modes vidéo, même rôle pour Face ID. **L'écran est décrit à l'identique**
sur chaque ligne — taille, résolution, densité, ProMotion, luminance.

**FACT.** Les seules différences publiées qui concernent le calcul sont le SoC (A16 Bionic → A17 Pro) et le GPU
(5 → 6 cœurs). Le Neural Engine est annoncé à 16 cœurs des deux côtés ; **ces pages ne publient aucun débit**
(TOPS), donc aucune comparaison quantitative n'est possible à partir de sources officielles.

**INFERENCE, à ne pas confondre avec une preuve :** un GPU et un SoC plus rapides peuvent réduire la latence de
traitement d'une image, ce qui *pourrait* influencer une boucle de jeu. **Rien dans les sources Apple ne relie cette
différence à la précision d'une estimation de regard.** Aucune conclusion ne peut en être tirée sans mesure.

**Le LiDAR du 15 Pro est un capteur arrière.** Iris n'utilise que la caméra frontale : il est hors sujet.

## 3. Ce qu'Apple ne publie pas (§11 de la mission)

Recherche menée sur les pages ci-dessus et sur la documentation ARKit.

| Donnée cherchée | Réponse |
|---|---|
| Précision du suivi du regard | **NON PUBLIÉ PAR APPLE DANS LES SOURCES CONSULTÉES** |
| Erreur angulaire du regard | **NON PUBLIÉ PAR APPLE DANS LES SOURCES CONSULTÉES** |
| Précision TrueDepth utile à l'estimation du regard | **NON PUBLIÉ PAR APPLE DANS LES SOURCES CONSULTÉES** |
| Latence du regard | **NON PUBLIÉ PAR APPLE DANS LES SOURCES CONSULTÉES** |
| Cadence ARFaceTracking par appareil | **NON PUBLIÉ** dans les caractéristiques ; en revanche **exposé à l'exécution** par `ARFaceTrackingConfiguration.supportedVideoFormats` — voir le document 04, où il est mesuré |
| Précision des `leftEyeTransform` / `rightEyeTransform` | **NON PUBLIÉ PAR APPLE DANS LES SOURCES CONSULTÉES** |

Citation exacte de la documentation de `lookAtPoint` — la seule chose qu'Apple en dit :

> « A position in face coordinate space estimating the direction of the face's gaze. »
>
> « This vector abstracts from the leftEyeTransform and rightEyeTransform matrices to estimate what point, relative
> to the face, the user's eyes are focused upon. »

Le mot employé est **« estimating »**, sans chiffre. **Aucune valeur d'exactitude, de précision, d'erreur angulaire
ou de comportement spécifique à un appareil n'y figure.**

## 4. Conclusion du document

**DOCUMENTED TRUEDEPTH DIFFERENCE RELEVANT TO IRIS : NON.** Les deux appareils sont décrits par Apple avec la même
caméra TrueDepth et le même écran.

**DOCUMENTED GAZE PRECISION DIFFERENCE : NON PUBLIÉ.** Apple ne publie aucun chiffre de précision de regard, pour
aucun des deux appareils ; il ne peut donc exister de différence publiée.

**Conséquence de méthode :** toute affirmation du type « l'iPhone 14 Pro suit le regard moins bien » ne peut pas
s'appuyer sur une source Apple. Elle ne pourrait venir que d'une mesure expérimentale contrôlée — c'est l'objet du
document 05, qui n'a pas encore été exécuté.
