# Notice

## Architectural reference

`SwiftUI-Agent-Skill` by Antoine van der Lee (MIT) was studied as a reference for how a mature agent skill
package is organised.

**Reused as structure, not as content:**

- a `SKILL.md` whose frontmatter description carries the trigger vocabulary;
- the section shape: operating rules → task workflows → topic router → hard rules → references;
- a topic router table mapping a subject to a reference file loaded on demand, rather than one large document;
- one anchor reference read at the start of every task;
- an explicit separation between hard rules and optional suggestions;
- executable scripts beside the prose, with a shared module and tests;
- a maintenance skill under `.agents/skills/`;
- the per-agent manifest layout: `plugin.json`, `.claude-plugin/`, `.codex-plugin/`, `.cursor-plugin/`,
  `agents/openai.yaml`, and a per-skill interface file.

**No source code and no prose were copied.** Every script, reference, workflow and rule in this package was
written for it. The subject matter does not overlap: that package is about writing SwiftUI; this one is about
deciding what to prove, what to protect, and when to stop.

A set of 19 iOS skills (`ios-app-skills`) was also studied. Three patterns influenced this package: stable
identifiers for findings, an explicit forward channel for unresolved uncertainty, and recording refused
proposals so they are not raised again. No content was taken.

## Provenance of the rules

The rules were extracted from **one** project: an iOS game with gaze tracking, in-app purchase and a public
release — a domain where errors are expensive. One developer, one AI agent, working in series.

What follows from that:

- most rules are *observed once*. They are stated as such where it matters;
- none has been tested against its own absence — no control group exists;
- the cost of the formalism was never measured;
- the rules that never caught anything are invisible, and those are exactly the ones worth deleting.

Use this package as a starting hypothesis, not as doctrine. `extract-validated-lessons` exists to make it
smaller as well as larger.

## Licence

MIT, matching the reference package's terms for the structural ideas it inspired.
