# Codex swiftDialog Builder

`codex-swiftdialog-builder` is a repo-contained Codex skill for creating or revising swiftDialog-enabled macOS shell scripts.

It is tuned to this repository's demo patterns, starter templates, and scripting conventions. The goal is to help Codex produce self-contained, readable scripts that follow the same style and behaviors used throughout `swiftDialog_demos`.

## Purpose

Use this skill when you want Codex to:

- create a new swiftDialog-driven shell script
- convert an existing Mac admin script to use swiftDialog
- choose between a simple dialog, form input flow, command-file progress UI, JSON-driven dialog, or inspect-mode workflow
- ground generated output in the demos and patterns already present in this repo

For newcomers, the skill begins by directing them to review the official [swiftDialog Builder page](https://swiftdialog.app/builder/builder/) for orientation before moving into repo-style implementation.

## What This Skill Contains

- [`SKILL.md`](./SKILL.md): the agent-facing workflow and rules
- [`references/`](./references/): demo mapping, authoring conventions, Builder-first guidance, and advanced pattern notes
- [`assets/templates/`](./assets/templates/): starter shell-script templates for common swiftDialog patterns
- [`agents/openai.yaml`](./agents/openai.yaml): Codex/OpenAI UI metadata for the skill

## How To Use It

Ask Codex to use `$codex-swiftdialog-builder` when you want help building or refining a script.

Example prompts:

- `Use $codex-swiftdialog-builder to create a welcome and confirmation dialog for a Mac setup workflow.`
- `Use $codex-swiftdialog-builder to turn this existing shell script into a swiftDialog-based form.`
- `Use $codex-swiftdialog-builder to build a progress dialog with live status updates for an install process.`

## Workflow

The skill is intentionally tiered so Codex chooses the smallest viable implementation:

1. Basic dialogs
2. Input collection
3. Live progress and status updates
4. JSON-driven or inspect-mode workflows

It should stay in a lower tier unless the request clearly requires a more advanced pattern.

## Repo Alignment

The skill assumes the same conventions used by the demos in this repo, including:

- `#!/bin/zsh`
- `DIALOG="/usr/local/bin/dialog"`
- quoted variable expansions
- `[[ ]]` conditionals
- optional `2>/dev/null` when quieter stderr is intentional during capture
- `/var/tmp` command-file handling with logged-in-user ownership handoff for root-run workflows, plus safe `wait $DIALOG_PID 2>/dev/null || true`
- deliberate window sizing because `--width` and `--height` are static

If you want the generated script to follow a specific demo, point Codex at that demo explicitly.
