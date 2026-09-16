# 04 — Performance mesurée : iPhone 15 Pro

```
STATUS: NOT MEASURED
```

## 1. Pourquoi

**FACT.** L'iPhone 15 Pro (« The Grey », `iPhone16,1`, iOS 26.6.1, UDID matériel `00008130-000819961498001C`) a été
**déconnecté de la machine pendant toute la fenêtre de mesure de ce Gate**.

Relevé au moment de préparer les instruments :

```
xcrun devicectl list devices      → The Grey : unavailable
xcrun xctrace list devices        → The Grey absent des appareils en ligne
```

Il n'a pas été possible d'y lancer l'application, ni d'y attacher un instrument.

## 2. Ce qui est tout de même établi pour cet appareil

**FACT (humain).** L'utilisateur a testé le gameplay sur le 15 Pro et rapporte **aucune latence ressentie**.

**MEASUREMENT (Gate 1, conservé).** ARKit y expose exactement les mêmes capacités de suivi de visage que le
14 Pro — même support, 3 visages, 4 formats TrueDepth frontaux jusqu'à 1440×1080 à 60 fps, champ par champ
identiques.

**MEASUREMENT (Gate 1, conservé).** L'appareil porte un environnement de test StoreKit persistant
(`appTransaction.environment = Xcode`) et un droit `fullAccess` simulé. Il ne représente donc pas l'état commercial
d'un utilisateur de production, et cet écart est une variable de contexte à consigner — **sans lui attribuer un
effet sur les performances**, faute de mesure.

## 3. Ce qu'il faudrait pour compléter

Rebrancher l'appareil, puis rejouer le protocole du document 02 :

```sh
xcrun devicectl device process launch --device 21ABC186-DEFC-59C7-9671-85E4FA69DA9A \
  --terminate-existing net.steve-s.iris \
  && sleep 5 \
  && xcrun xctrace record --device 00008130-000819961498001C --template "Activity Monitor" \
       --attach Iris --time-limit 11m --no-prompt --output session-15pro.trace
```

Le scénario humain doit être **le même** : calibration, deux niveaux gratuits des chapitres I–III, pause/reprise,
retour Seuil, sans paywall ni achat.

## 4. Conséquence sur les conclusions du Gate

La comparaison inter-appareils demandée au §8 **n'a pas pu être faite**. Aucune conclusion comparative n'est écrite.

Cela ne bloque pas les décisions de ce Gate : la question centrale — Iris provoque-t-elle une croissance mémoire
anormale — est tranchée par la mesure sur le 14 Pro, qui est **l'appareil où les flashes et l'incident Jetsam
historique ont eu lieu**, donc le plus défavorable des deux.
