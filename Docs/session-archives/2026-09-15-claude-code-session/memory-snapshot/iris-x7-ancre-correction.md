---
name: iris-x7-ancre-correction
description: "Branch prototype/x7-stabilisation-head-guidance (14 Sept 2026): level 10-7 « l'ancre » rebuilt as two guided head loops around a fixated point, with a silhouette traced from the user's reference image; awaiting human play, not pushed"
metadata:
  type: project
---

The mission asked to start from tag `iris-expansion-human-validated-v1`, but X·7 does not exist there (chapter X has 6 levels at the tag). The branch starts from `e29cae7`, the tip of `fix/chapter-card-adaptive-layout`: it descends from the tag, contains X·7, and matches the build on the phone. 10-7 now works in six steps:
- settle facing the screen, eyes on the central point;
- turn the head right;
- draw one continuous circle (the ring fills only forward, at most 50° ahead and 120°/s);
- come back to face;
- a stardust breath;
- the same loop from the left, after which the lueur drifts into its iris alone (par 82 s / 2).

Head pose is screen-oriented through the calibration's `AxisMapping` (`GameViewModel.screenHead`), with no learned axis signs. The silhouette is vector points traced from `x7_silhouette_reference.png`. That PNG and the user's `SKILL.md` ("iris-debug-observability") stay untracked at the repo root.

**Why:** the user found the old compass-band version of 10-7 unclear; it was "the level to review". They want the head movement obvious, the gaze tolerated while the head turns, no clinical wording, nothing else touched, and no Liquid Glass yet.

**How to apply:**
- For the DEBUG trace, launch with `--iris-capture`, then copy `tmp/iris-debug/*.jsonl` from the app data container with devicectl.
- Follow SKILL.md: observe before touching the Gaze Engine.
- Don't push this branch unless asked; the mission said « Ne pousse rien sans nécessité explicite ».

See [[iris-oculomotor-expansion]] and [[iris-chapter-card-layout]].

**Option A (14 Sept 2026, branch `fix/x7-head-only-circling` from `3abddb7`):** the user's iPhone test showed the projected gaze drifting far, even off screen, while the head turns, with face and head pose still tracked. So the gaze is now a criterion only in the fixations: an opening one (0.8 s, head still and roughly facing the screen), a re-fixation before the reverse circle (0.7 s) and a closing one after it (0.7 s). While the head goes to the side, circles and returns, the gaze is not read at all. The head pose is read even without a gaze projection, for 10-7 only (`OculoDefinition.readsHeadWithoutGaze`), and the DEBUG gaze indicator is hidden during circles. The DEBUG trace had `String(format:)` errors from `%d` with 64-bit Int; they are fixed with interpolation on X·7's paths (the 1-6 balise logs still use `%d`, which is out of scope). The user explicitly forbade touching the Gaze Engine, ARKit, calibration, AxisMapping or the filters for this.
