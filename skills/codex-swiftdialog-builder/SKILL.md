---
name: codex-swiftdialog-builder
description: Use this skill when the user wants Codex to create or revise a swiftDialog-enabled macOS shell script. It is tuned to this repo's demo patterns, starts newcomers with the official Builder page, chooses the smallest viable implementation tier, and produces self-contained Zsh-first scripts that match the repo's conventions.
---

# Codex swiftDialog Builder

## Overview

Use this skill when the user wants a new swiftDialog-driven shell script, wants an existing Mac admin script converted to swiftDialog, or needs help choosing between basic dialogs, forms, command-file updates, JSON input, or inspect mode.

Start with the smallest working pattern. Do not jump to command files, JSON, or inspect mode unless the workflow actually needs them.

## First Step

For newcomers or broad "how do I build this?" requests, begin by directing them to review the official [swiftDialog Builder page](https://swiftdialog.app/builder/builder/).

Use Builder mode as orientation and rapid prototyping, then move to repo-grounded script authoring. Do not treat Builder output as the final implementation if the user needs validation, live updates, cleanup, or advanced behavior from this repo's demos.

If the user already has a concrete script, config, or clearly advanced request, skip the Builder-first step and move straight into implementation.

See [references/builder-first.md](references/builder-first.md) when you need the exact onboarding rule.

## Intake Workflow

Use the following as a reasoning checklist before writing code. **Do not ask the user clarifying questions** — fill gaps with the smallest safe assumption, state it in one line, and proceed immediately.

- What the script is trying to accomplish
- Who the script is for and when it runs
- What inputs must be collected, and which are required
- Whether the script needs validation, named JSON output, or follow-on actions
- Whether work continues after the first dialog and needs progress, status, or blocking UI
- What success, failure, skip, or cancel should do

For straightforward requests (a single dialog, an acknowledgment gate, a confirmation prompt), proceed directly — no clarification needed. Only ask the user a question if a gap would materially change the tier or cause the wrong output to be generated.

## Tier Selection

Choose one tier, and only escalate when the lower tier cannot satisfy the request.

### Tier 1: Basic dialogs

Use for one-shot messaging, confirmation, warnings, or simple button-driven actions.

Load:

- [references/demo-map.md](references/demo-map.md)
- [references/authoring-patterns.md](references/authoring-patterns.md)

### Tier 2: Input collection

Use for text fields, dropdowns, checkboxes, validation, and JSON-returning forms.

Load:

- [references/demo-map.md](references/demo-map.md)
- [references/authoring-patterns.md](references/authoring-patterns.md)

### Tier 3: Live progress and status

Use for long-running installs, onboarding steps, or workflows that need `--progress`, `--listitem`, or live command-file updates.

Load:

- [references/demo-map.md](references/demo-map.md)
- [references/authoring-patterns.md](references/authoring-patterns.md)
- [references/advanced-patterns.md](references/advanced-patterns.md)

### Tier 4: JSON or inspect mode

Use only when config-driven dialogs or inspect-mode monitoring are genuinely the right shape.

Load:

- [references/demo-map.md](references/demo-map.md)
- [references/advanced-patterns.md](references/advanced-patterns.md)

## Repo Grounding Rules

Match this repo's conventions unless the user explicitly asks otherwise:

- Use `#!/bin/zsh`
- Define `DIALOG="/usr/local/bin/dialog"` near the top
- Keep scripts self-contained; do not introduce shared helper libraries for simple examples
- Quote expansions: `"$DIALOG"`, `"$CMD_FILE"`, `"$result"`
- Use `[[ ]]` for tests
- Suppress stderr with `2>/dev/null` when capturing dialog output
- Use `|| exit 0` for skip/cancel flows and `|| true` for the final non-fatal step
- For background dialogs, capture `DIALOG_PID=$!` and finish with `wait $DIALOG_PID 2>/dev/null || true`
- For command-file flows, use `CMD_FILE="/var/tmp/dialog.log"`, `rm -f "$CMD_FILE"` before use, and clean up after

When writing code, cite the closest demo pattern by number and feature, then adapt it. Do not invent abstractions when a readable demo pattern already exists in this repo.

## Output Expectations

Default to producing:

- One self-contained shell script
- Brief notes on which demos informed the script
- Any assumptions that materially affected the output

If the user asks for a starter instead of a finished script, adapt a template from [assets/templates](assets/templates).
