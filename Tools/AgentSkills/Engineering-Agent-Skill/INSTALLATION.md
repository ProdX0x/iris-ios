# Installation

Support levels, stated honestly:

| | Meaning |
|---|---|
| **STRUCTURALLY SUPPORTED** | the manifest exists and matches the layout the environment documents |
| **RUNTIME VERIFIED** | it was installed and observed working |

At version 1.0.0, **everything below is STRUCTURALLY SUPPORTED. Nothing is RUNTIME VERIFIED.** This package was
built and tested as a source tree; it has not been loaded into an agent environment. Treat installation as
untested and report what happens.

## What you get

Two skills plus a maintenance skill:

- `engineering-expert-skill` — the main one;
- `ios-release-evidence-skill` — optional; ignore it if you do not ship Apple platforms;
- `extract-validated-lessons` — used after a project, not during one.

## Requirements

- Python 3.9 or later for the tools. No third-party packages.
- `git` on `PATH` for the repository tools.
- macOS with Xcode command line tools **only** for the iOS skill's subject matter.

## Claude

**STRUCTURALLY SUPPORTED.** `.claude-plugin/plugin.json` declares both skills; `.claude-plugin/marketplace.json`
describes the plugin for a marketplace listing.

Point Claude at the package directory, or install it as a plugin from a marketplace that serves this repository.
The skills are discovered from the `skills` array in `.claude-plugin/plugin.json`.

To use it without any plugin mechanism, copy `skills/engineering-expert-skill/` into wherever your setup keeps
skills. The skill is self-contained: `SKILL.md`, `references/`, `scripts/`, `case-studies/`.

## Codex / OpenAI

**STRUCTURALLY SUPPORTED.** `.codex-plugin/plugin.json` points at the `skills/` directory and carries an
`interface` block with display metadata and starter prompts. `agents/openai.yaml` declares the package and its
skills; each skill has its own `agents/openai.yaml` with an interface block.

## Cursor

**STRUCTURALLY SUPPORTED.** `.cursor-plugin/plugin.json` lists both skill directories.

## Verify the install

```bash
cd Engineering-Agent-Skill
python3 -m unittest discover -s tests -t . -v
python3 skills/engineering-expert-skill/scripts/repo_snapshot.py --repo . --json
```

The first should pass. The second should print the state of whatever repository you run it in — proof the tools
work in your environment.

## First use

Ask something the skill is for:

> Is this actually a regression? We don't have a baseline.

A correct response says a regression cannot be claimed without a measured baseline, offers to establish one, and
does **not** start optimising.

## Using it alongside a domain skill

Load both. There is no conflict by design: this package claims no project document and writes under its own
namespace. If you also use a skill set that owns files at your project root, this one will not touch them.

## Uninstalling

Delete the directory. Nothing is written outside it, no global configuration is modified, and no state is kept
anywhere else.
