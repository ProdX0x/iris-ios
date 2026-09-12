# Calibration du regard — hypothèse de distance visage / iPhone

Date : 12 septembre 2026.

## Observation

Pendant les nombreuses recalibrations des tests Braises, l'utilisateur rapporte, de façon répétée :

- autour de **30 cm** entre le visage et l'iPhone : calibration subjectivement plus facile et plus fiable ;
- téléphone presque **à bout de bras**, distance sensiblement supérieure : calibration subjectivement plus difficile.

## Statut

`NON VÉRIFIÉ — HYPOTHÈSE HUMAINE.`

Elle n'est ni une règle de calibration, ni une contrainte de 30 cm, ni un motif de modification des seuils, du diagnostic, de la projection ou d'un avertissement permanent. Le Gaze Engine n'a pas été modifié.

## Limite des données actuelles

Les journaux enregistrent les résidus de calibration (moyenne, maximum), les erreurs de vérification (moyenne, maximum) et l'acceptation, mais pas une mesure exploitable et synchronisée de la distance exacte entre le visage et le téléphone. Le diagnostic de préparation vérifie seulement que la distance est comprise entre 15 et 90 cm. Aucune corrélation distance / précision ne peut donc être calculée à partir des données existantes.

## Futur protocole possible

À réaliser dans une mission distincte, uniquement si cela est décidé :

- plusieurs calibrations à environ 30 cm, plusieurs à environ 45 cm, plusieurs à distance plus grande (bras tendu) ;
- pour chacune, relever : acceptation, erreur moyenne et maximale de vérification, stabilité de `faceVisible`, et si possible les erreurs par point ;
- comparer les distributions.

Aucune implémentation maintenant.
