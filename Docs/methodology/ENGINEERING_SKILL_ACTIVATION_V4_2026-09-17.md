# Engineering Expert Skill v1.0.2 — Activation V4

Date: 2026-09-17 · Protocol: `LIRE_AVANT_ACTIVATION_SKILLS_V4.md`
(protocol file SHA-256 `00c6dc820e36c2938719e6a9a013f3fb655167f117e73e04dc682c773b15665c`, read only, unmodified)

    ARTIFACT      Engineering-Agent-Skill-v1.0.2.zip
    SHA-256       7d17f13a311784251fff487f95c372c948e659e49acd38aea415979d11209d11
    SOURCE COMMIT 9d1afef9345cf7f20b0848134734a203c3e7f891

## 1. Purpose

Decide, from evidence rather than from confidence, whether `engineering-expert-skill` v1.0.2 is really
detected and really shapes the agent's behaviour — and to name precisely what that does and does not
license anyone to claim afterwards.

The order was fixed in advance: evidence surface first, acquisition second, preservation third,
classification fourth, verdict last. No verdict was chosen as a target.

## 2. V4 evidence taxonomy — exact relevant clauses

Level A, SELF-REPORTED:

> Une auto-déclaration ne constitue jamais une preuve suffisante.

Level B, SYSTEM / TOOL EVIDENCE — the example list, quoted in full because the verdict turns on it:

> - liste officielle des capacités chargées ;
> - configuration active pointant vers le Skill ;
> - registre d'usage ;
> - plugin manager déclarant le Skill actif ;
> - log d'invocation ;
> - **tool call montrant le chargement** ;
> - mécanisme officiellement documenté + état vérifiable.

Level C, DISTINCTIVE RUNTIME EVIDENCE:

> - une règle propre au Skill est déclenchée ;
> - un outil uniquement fourni par le Skill répond ;
> - **un routeur charge automatiquement une référence spécifique** ;
> - une sonde d'activation retourne un identifiant/version propres au package ;
> - un comportement interdit par le Skill est bloqué de façon reproductible.
>
> Valeur probante : **forte**, à condition que le test soit réellement distinctif et qu'il ne puisse pas
> être obtenu par simple connaissance générale du modèle.

Decision rule, case 1 — level B available:

> Pour déclarer `RUNTIME VERIFIED = YES` il faut `B + C` […] A seul ne compte pas.

Negative-control sublevel:

> Utiliser `B+C VERIFIED — WITH NEGATIVE CONTROL` lorsque : B est positif ; C est positif ; le même
> scénario échoue ou perd sa signature distinctive lorsque le Skill est absent/inactif.

On absence, and on the protocol's own dependencies:

> Une preuve absente n'est jamais une preuve positive.
> **Les dépendances du protocole doivent elles-mêmes être vérifiées.**

And section 7, which governs what may count as distinctive:

> Un principe général tel que « mesurer avant de modifier » n'est pas un test distinctif suffisant.

## 3. Claude Code evidence-surface map

Determined read-only, before looking for anything.

    CLAUDE CODE VERSION                2.1.274
    SESSION PERSISTENCE DOCUMENTED     YES   ~/.claude/projects/<encoded-cwd>/<session-uuid>.jsonl
    SESSION STORAGE EXPOSED LOCALLY    YES
    TRANSCRIPT STORAGE EXPOSED         YES   JSON Lines, one structured record per event
    SKILL INVOCATION LOG EXPOSED       YES   as a tool_use record with name "Skill"
    RENDERED /skills OUTPUT PERSISTED  NO    the command invocation is stored, its rendered list is not

Earlier phases recorded the version as 2.1.268 from operator report. The transcripts record 2.1.274 for
both sessions, and an update 2.1.273 → 2.1.274 at 08:12Z. Both arms therefore ran on the same build; the
discrepancy is in the earlier paperwork, not in the comparison.

Because level B turned out to be available, V4 case 1 applies. Case 2 and the
`HIGH CONFIDENCE — NO SYSTEM TELEMETRY AVAILABLE` class are not in play.

## 4. Frozen behavioural specification

Written before any response was observed. `BEHAVIORAL-TEST-SPEC.md`, SHA-256
`0eb4c4bb1ac84b7f1bbc89d74a78ed3bc8d2c537b37459d0d90925add00c2dba`, verified unchanged at every phase
since. It fixed the prompt, the seven criteria, the maximum of 14, and the rule that the score alone
proves nothing — only the difference does.

**Chain of custody on the stimulus.** The prompt recorded in each session's transcript hashes to
`af070d3613a8795f78c7559bac7968f3c740a360c851bbf612d8bcfbd55fb606` — the same value computed from the
frozen spec in phase 1, before either session ran. The A/B stimulus is identical by measurement.

## 5. Negative control

Ran 18:17–18:21 UTC in an empty directory, with no skill installed. Sealed as
`NEGATIVE-RESPONSE.txt`, SHA-256 `f507b9c3…`; the machine transcript corroborates it at 99.87 % after
normalisation.

It already refused blind deletion, established ground truth, and proposed a reversible experiment. Those
behaviours are therefore **baseline**, not evidence of the skill — exactly the trap V4 section 7 names.

Machine side: 0 Skill tool calls, 0 occurrences of the string `engineering-expert-skill`, 0 skill
references read.

## 6. The v1.0.1 probe defect

The probe assumed it always ran inside the full package tree. Installed the way an agent actually
installs a skill, it reported `SKILL.md` missing while the file sat two directories up, and reported all
six sibling tools missing while every one was on disk beside it — from
`missing_tools = list(SIBLING_TOOLS)` standing in for a check that was never run.

Worth recording plainly: **24 tests passed and the defect survived, because every test ran in package
layout.** It was the installation for the negative control that caught it. A green suite proves only what
it exercises.

## 7. The v1.0.2 correction

Two declared layouts, detected rather than assumed: `MODE=PACKAGE` and `MODE=INSTALLED SKILL`. `SKILL.md`
located by walking up from the probe. Sibling tools tested one file at a time in either layout. A package
root accepted only when its `skills/engineering-expert-skill` really is this skill directory. Checks
carry `PASS` / `FAIL` / `N/A`, so "not applicable" stops being indistinguishable from "failed". An
embedded version inside the skill subtree, cross-checked against the probe and, in package mode, the
manifest. 116 tests pass.

## 8. Positive evidence acquisition and preservation

Positive session, 18:53–18:54 UTC, same directory, skill installed at
`.claude/skills/engineering-expert-skill/`.

Sealed: `POSITIVE-RESPONSE.txt` (`1ba1d609…`) and `POSITIVE-SYSTEM-OBSERVATIONS.txt` (`96c0c80c…`), both
operator transcriptions, sealed **before** any comparison was attempted.

## 9. Persistent trace investigation

Searched only the surface established in section 3.

    POSITIVE  9787ac3b-51b7-4af7-93c6-d8881b8382f6.jsonl  0ea1f646…
              one tool_use, name "Skill", input {"skill": "engineering-expert-skill", …},
              caller {"type": "direct"}; result "Launching skill: engineering-expert-skill";
              followed by the skill's own SKILL.md text and its base directory under the
              project install path; then four of its references read in the same turn.
    NEGATIVE  0fdae23a-8def-4605-b0fb-3f546b8dd219.jsonl  4f6be104…
              zero Skill tool calls, zero mentions of the skill.
    LATER     02421ab3-e65a-48ab-8ac6-9f231f85299c.jsonl  41c50fcc…
              five records, no skill call, no /skills listing.

Two findings that cut against the operator's transcription, recorded rather than smoothed over:

- the string **"Successfully loaded skill" appears in none of the three transcripts.** The store's
  wording is "Launching skill: engineering-expert-skill". The *event* is established by a stronger
  source; the *wording* transcribed is not what the store holds.
- the rendered `/skills` list is not persisted at all, so neither the pre-clear nor the post-clear
  display can be checked against anything.

## 10. Evidence provenance matrix

| # | Evidence item | Original producer | Acquisition | Preservation | Verified now | Independently auditable | Hashed | V4 clause | Level | Limitation |
|---|---|---|---|---|---|---|---|---|---|---|
| A | `/skills` pre-clear | Claude Code UI | operator transcription | text file | no | no | yes | — | A | output not persisted by the tool |
| B | `engineering-expert-skill · project · on` | Claude Code UI | operator transcription | text file | no | no | yes | — | A | same |
| C | `Skill(engineering-expert-skill)` display | Claude Code UI | operator transcription | text file | no | no | yes | — | A | superseded by item I |
| D | `Successfully loaded skill` | Claude Code UI | operator transcription | text file | no | no | yes | — | A | **wording not found in the store** |
| E | positive behavioural answer | the model | operator transcription, corroborated at 99.26 % against the transcript | text file + transcript | yes | yes | yes | Level C | C | one run, one scenario |
| F | `/skills` post-clear | Claude Code UI | operator transcription | text file | no | no | yes | — | A | uncorroborated; no stored listing |
| G | probe v1.0.2 `AVAILABLE` | the package's own tool | run directly, three layouts | re-runnable | yes | yes | n/a | "une sonde d'activation retourne un identifiant/version propres au package" | C | says nothing about loading |
| H | negative control | the model, without the skill | operator transcription + transcript | text file + transcript | yes | yes | yes | negative-control clause | C | baseline behaviour is already strong |
| I | **persistent trace: Skill tool_use** | Claude Code's session writer | direct read of `~/.claude/projects/…` | JSONL on disk | **yes** | **yes** | yes | **"tool call montrant le chargement"** | **B** | local store, not remote telemetry |
| J | router reading four skill references | Claude Code, recorded in the transcript | direct read | JSONL on disk | yes | yes | yes | "un routeur charge automatiquement une référence spécifique" | C | — |

## 11. Behavioural A/B comparison

Scored with the frozen rubric, unchanged, after re-verifying its hash.

| | S1 | S2 | S3 | S4 | S5 | S6 | S7 | Total |
|---|---|---|---|---|---|---|---|---|
| Negative | 2 | 2 | 2 | 2 | 1 | 1 | 2 | **12 / 14** |
| Positive | 2 | 2 | 2 | 2 | 2 | 2 | 2 | **14 / 14** |

Delta +2. The honest reading is not the total: **S1 to S4 are at ceiling in both arms and are therefore
not diagnostic here.** A capable model refuses a blind `rm -rf` on its own.

The difference is concentrated where the frozen spec predicted it would have to be:

- **S5 +1** — explicit evidence vocabulary used as labels: `MESURÉ`, `NON PROUVÉE`, `FORTEMENT ÉTAYÉ`,
  and "conclure sans dépasser la preuve".
- **S6 +1** — `Mode : DEEP` announced and justified; "Règle dure du skill" quoted as a rule rather than
  improvised; **`hash_manifest.py` named** — a tool that exists only in this package, which a model
  without the skill has no way to know; and the full sequence inventory → fingerprint → competing
  hypotheses → one variable → measure/restore/prove → classify.

The negative arm contains none of that vocabulary and names no tool of this package.

## 12. Ancillary Claude.ai Skills context difference

The negative arm displayed `No skills found`; the positive displayed nine, of which eight are
`anthropic-skills:*`. The cause is now dated and identified: `~/.claude/skills/synced/` was created at
20:51 local by an account-level skill sync — eight Anthropic skills, none of them this one. It was not
created by this work.

So the global A/B is **not perfectly single-variable**, and that is stated rather than hidden. Impact per
claim:

| Claim | Impact | Why |
|---|---|---|
| presence of `engineering-expert-skill` in the list | NOT AFFECTED | it is project-scoped, in the lab directory; the synced set does not contain it |
| status `project · on` | NOT AFFECTED | `project` scope is the lab install, unrelated to the synced global set |
| the specific invocation | NOT AFFECTED | the trace names this skill and its base directory inside the lab install path |
| distinctive behavioural signature | NOT AFFECTED | none of the eight synced skills concerns evidence discipline or destructive restraint; the vocabulary matches this skill's own references, read in the same turn |
| persistence after `/clear` | UNCERTAIN | it rests on the same uncorroborated transcription, and the environment changed between the arms |

## 13. Persistence observation

`/skills` after `/clear` was reported as still showing the skill. Nothing in the store corroborates it:
the rendered list is not persisted, and the session recorded at 18:57 UTC contains no listing and no
skill call. The one companion element of that same transcription that *could* be checked — the
"Successfully loaded skill" wording — did not match the store.

    PERSISTENCE VERIFIED : NOT PROVEN

Per V4, "La persistance n'est jamais supposée". Re-establishing it needs one fresh session in which a
Skill tool call appears again in the store. That is cheap, and it is the obvious next experiment.

## 14. Verdict derivation

**Level B — satisfied.** V4's own example list contains "tool call montrant le chargement". The store
holds exactly that: a structured `tool_use` record produced by Claude Code, naming the tool `Skill`, the
skill `engineering-expert-skill`, with `caller: direct`, followed by a tool result and the skill's text.
It was read directly, is on disk unmodified, is hashed, and anyone with the machine can re-read it. It
did not reach this report through anyone's memory or typing.

The transcription-based items (A–D, F) are **not** used to support B. They were sealed, and one of them
was contradicted in wording by the store. Hashing them protects their future integrity; it does not make
them independent observations, and they are classified A.

**Level C — satisfied,** on the strength of the items V4 names, not on general good sense:

- a router automatically loading specific references — four of this skill's own reference files were read
  inside the same turn;
- a tool provided only by this package — `hash_manifest.py`, named in the answer;
- an activation probe returning identifiers proper to the package — `AVAILABLE` in three layouts.

S1–S4 are deliberately **not** counted as distinctive: V4 section 7 rules out "mesurer avant de modifier"
as a sufficient test, and the negative control demonstrated those behaviours without the skill.

**Negative control — satisfied,** at two levels: behaviourally, the distinctive signature is absent; and
in the store, the negative session contains zero Skill tool calls.

    FINAL VERDICT : B+C VERIFIED — WITH NEGATIVE CONTROL
                    PERSISTENCE VERIFIED = NOT PROVEN

The second line is part of the verdict, not a footnote to it.

## 15. Limits of conclusion

What was shown: on this build, in this directory, for this prompt, the skill was auto-invoked by the
model without being asked for, its references were loaded, and its vocabulary and procedure appeared in
the answer — none of which happened in the controlled arm without it.

What was not shown: that any of this repeats. One scenario, one run per arm, one machine, one build. The
positive arm is also a favourable case: an empty directory, a single skill, and a prompt built to hit its
subject squarely.

## 16. Real-world / noisy-context trigger robustness — NOT TESTED

Auto-invocation was **not** tested in Iris, in a long session, under heavy context, with competing
skills, on ambiguous tasks, on weak activation signals, on future Claude Code versions, or across future
sessions generally.

    REAL-WORLD / NOISY-CONTEXT TRIGGER ROBUSTNESS : NOT TESTED
    UNIVERSAL FUTURE AUTO-INVOCATION              : NOT PROVEN

## 17. Permanent package promotion

A separate question, decided on artefact integrity alone and deliberately not on the runtime verdict.

    ZIP SHA-256 verified · source_commit matches · version 1.0.2 coherent across ten sources ·
    116 tests pass · probe PASS in source tree, extracted archive and installed-skill layout

v1.0.0 archived first to `_archives/Engineering-Agent-Skill-v1.0.0-pre-v1.0.2-2026-09-17.tar.gz`
(SHA-256 `1cd5403560d9430da86af0fff2396dd2ffdb40ba87bff79ac711d98b8cdaf317`, tested, confirmed to contain
1.0.0 and no probe). Replacement performed via a same-volume rename with a rollback kept until every
check passed. Destination compared to the validated archive content: 104 entries, 81 files, zero missing,
zero extra, zero hash difference — `CONTENT-IDENTICAL PASS`. Filesystem modes checked separately:
`PASS`. Probe from the permanent copy: `MODE=PACKAGE`, `VERSION=1.0.2`, `STATUS=AVAILABLE`, 6/6.

## 18. Final state

    PERMANENT LIBRARY  1.0.0 -> 1.0.2
    IRIS               product untouched; only this document added
    LABS               /tmp/engineering-skill-activation-test and -evaluation preserved
    PROTOCOL V4        read only, unmodified

Sealed experiment:

    BEHAVIORAL-TEST-SPEC.md           0eb4c4bb1ac84b7f1bbc89d74a78ed3bc8d2c537b37459d0d90925add00c2dba
    NEGATIVE-RESPONSE.txt             f507b9c31dddaf4ec75a6b698d1867363659f58ea7b6495b4d6d29d76186f71e
    POSITIVE-RESPONSE.txt             1ba1d60966b5e0d302b1326fc594a0a980262719dbd3f8c1109337a022b57171
    POSITIVE-SYSTEM-OBSERVATIONS.txt  96c0c80c8ab67f1550bdd4d5b3b7fe2611c080a7614fa7f33f0703ee0bc3ce3a
    POSITIVE-PROVENANCE.md            8e46db1f89feccabb8e5edc9331ee3f622e09dd2b215a64c4030f20215f67790
