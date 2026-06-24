# AGENTS.md

**Single source of truth for coding agents** (Codex, Copilot, Claude, Aider, Cursor, etc.).
Takes precedence over `README.md`, `.github/copilot-instructions.md`, and similar instruction files.

## Orchestration Contract

This file codifies project rules, boundaries, workflows, and repeatable skills.
If same correction repeats, formalize it here instead of re-prompting it.

## Project Overview

`swiftDialog_demos` is self-guided showcase of swiftDialog features plus repo-aligned AI skill packs for authoring similar scripts.
Primary controller is `run_demos.zsh`.
Primary artifacts are demo scripts under `demos/01_basic_styles.zsh` through `demos/20_branched_workflows.zsh`.
AI skill packs live under `skills/codex-swiftdialog-builder/` and `skills/claude-swiftdialog-builder/`.

## Key Commands

- Run demo suite: `./run_demos.zsh`
- Run individual demo: `./demos/06_progress_timer.zsh`
- Validate changed demo script: `zsh -n demos/06_progress_timer.zsh`
- Validate changed controller: `zsh -n run_demos.zsh`
- Validate changed starter template: `zsh -n skills/claude-swiftdialog-builder/templates/basic-dialog.zsh`

## Agent Workflow

- Start non-trivial changes in Plan mode or equivalent before editing.
- Default user-facing communication mode is `$caveman full`, except for security warnings, irreversible actions, or when clarity needs full sentences.
- Confirm this file is loaded before starting substantial work.
- Treat context like scalpel, not net; provide only files, lines, and examples needed.
- Prefer surgical edits and exact file references over broad rewrites.
- Never make edits while checked out on `main`.
- Before any new feature or refactor, create and switch to new Git branch.
- If branch creation or switching is blocked, stop and ask user how to proceed.
- After any edit to changed `.zsh` files, prompt user to run `zsh -n` on each changed file.
- Do not attempt `zsh -n` via Bash tool; sandbox restrictions may interrupt it.
- Ask for confirmation before adding any new production dependency.
- Do not add `Co-Authored-By:` or agent-attribution trailers to commit messages.

## Skills

Invoke relevant skill name during planning when work matches one of these patterns.

### Add New Demo

1. Start from nearest existing demo pattern instead of inventing shared abstractions.
2. Create new `demos/NN_*.zsh` file with repo-standard header, dialog invocation layout, cleanup, and error-handling style.
3. Update selector UI and `demo_map` in `run_demos.zsh`.
4. Update Demo Index in `README.md`.
5. If demo introduces or depends on skill-pack guidance, update `skills/README.md` and relevant skill-specific `README.md`.
6. Prompt user to run `zsh -n` on new demo, changed templates, and `run_demos.zsh`.

### Update Existing Demo

1. Identify nearest related patterns in surrounding demos before editing.
2. Keep demo self-contained; avoid introducing shared helper libraries for simple examples.
3. Preserve temp-file cleanup, command-file behavior, background process handling, and user-facing copy concision.
4. If feature list, numbering, or showcased behavior changes, update `README.md` and `run_demos.zsh` together.
5. Prompt user to run `zsh -n` on every changed `.zsh` file.

### Update AI Skill Pack

1. Keep bundled skill packs aligned with repo's actual demo patterns.
2. Update skill directory contents plus companion docs together:
   - `skills/README.md`
   - skill-specific `README.md`
   - top-level AI skills section in `README.md`
3. If starter templates change, preserve repo shell conventions unless target AI platform requires different file layout.
4. Prompt user to run `zsh -n` on any changed template under `skills/**/templates/` or `skills/**/assets/templates/`.

## Boundaries

**Always allowed without asking**

- Read any repository file.
- Make doc-only edits that stay within current task scope.
- Make small targeted edits that follow rules in this file.

**Ask before doing**

- Add any new production dependency.
- Change demo ordering semantics or renumber demos.
- Rename demo files.
- Broadly restructure repo, skill packs, or controller flow.
- Change AI skill-pack scope in ways that no longer match actual demos.

**Never do**

- Edit while checked out on `main`.
- Add agent attribution trailers to commits.
- Introduce shared helper abstraction for simple demos.
- Break demo independence.
- Renumber or rename demos without updating `README.md` and `run_demos.zsh` in same change.
- Remove temp-file cleanup behavior for `/tmp` or `/var/tmp` workflows.

## Source of Truth

For implemented repo behavior, prefer:

1. `run_demos.zsh` and `demos/*.zsh` for implemented behavior and showcased features.
2. `README.md` for public demo index and repo usage guidance.
3. `skills/README.md` and skill-specific `README.md` files for AI skill-pack guidance.

For agent instructions, `AGENTS.md` overrides `README.md`, `.github/copilot-instructions.md`, and similar instruction files.

## Key Files

- `run_demos.zsh`: suite controller, selector UI, and `demo_map`
- `demos/`: self-contained feature demos
- `README.md`: public repo overview, quick start, demo index, AI skills summary
- `skills/README.md`: human-facing skill-pack overview
- `skills/codex-swiftdialog-builder/` and `skills/claude-swiftdialog-builder/`: AI-facing instruction packs, references, and starter templates
- `playground/README.md`: guided AI-assisted development workspace

## Mission and Scope

Mission: keep repo clear, realistic, and self-guided for learning swiftDialog features and for teaching AI assistants to generate repo-aligned shell scripts.

In scope:

- clear swiftDialog feature demos
- realistic demo patterns for Mac Admin workflows
- AI skill packs aligned to repo conventions
- starter templates that match actual repo behavior

Out of scope:

- heavy abstraction layers across demos
- skill-pack guidance that diverges from repo behavior
- dependency sprawl for simple showcase scripts

## Scripting Style

Match established repo style unless user explicitly asks otherwise.

### Headers and Structure

- Use `#!/bin/zsh` in executable scripts.
- Keep demo headers in this pattern:
  - `# Demo NN: ...`
  - `# Demonstrates: ...`
- Demo files use two-digit zero-padded numbering: `01`, `02`, ... `20`.
- Define `DIALOG="/usr/local/bin/dialog"` near top.
- Only `run_demos.zsh` uses `set -euo pipefail`; demo scripts do not.
- Starter templates under `skills/` should also use `#!/bin/zsh` and keep same shell conventions unless target AI platform requires different layout. Applies to both `templates/` and `assets/templates/`.

### Comments

- Use single `#` with space for inline comments.
- Section dividers use exactly three dashes on each side: `# --- Section Name ---`.

### Variables

- Use UPPER_CASE for constant-style top-level identifiers such as `DIALOG`, `CMD_FILE`, and `DIALOG_PID`.
- Always quote variable expansions: `"$DIALOG"`, `"$CMD_FILE"`, `"$result"`.
- Common variable names: `DIALOG`, `CMD_FILE`, `DIALOG_PID`, `result`.
- Do not use `local` at script level; only inside functions.

### Conditionals and Tests

- Use `[[ ]]` for conditional tests, not `[ ]`.
- File existence: `[[ -f "$file" ]]`
- Command availability: `command -v <cmd> &>/dev/null`

### Dialog Invocations

- Keep dialog arguments one flag per line with trailing `\`.
- `--json` writes structured output to stdout; add `2>/dev/null` only when intentionally quieting stderr.
- Chain with error handling: `|| exit 0` for skip flow or `|| true` for final non-fatal step.
- When capturing JSON output, common follow-up is `echo "$result" | jq '.'`.

### Strings and Markdown

- Use double quotes for strings.
- Use backticks for inline code in markdown messages: `` `--flag` ``.
- Keep user-facing copy concise and feature-specific.

## Real-World Repo Patterns

### Error Handling

- Skip flows usually use `|| exit 0` in intermediate steps, as in `demos/01_basic_styles.zsh`.
- Final non-fatal completion usually uses `|| true`.
- Suppress stderr with `2>/dev/null` when capturing dialog output or checking versions.

### Background Processes

- Launch dialog in background: `"$DIALOG" ... &`
- Capture PID immediately after: `DIALOG_PID=$!`
- Use `DIALOG_PID` to `wait` on launched dialog command; this is separate from internal `dialogcli --pid` flag.
- Wait safely at end: `wait $DIALOG_PID 2>/dev/null || true`
- Used in demos `06`, `10`, `12`, and `14`

### Command Files

- Command-file demos create per-run temp file with `CMD_FILE=$(mktemp -t dialog.XXXXXX)`.
- Clean up with `rm -f "$CMD_FILE"` via `cleanup` function and `trap cleanup EXIT`.
- Write updates with `echo "key: value" >> "$CMD_FILE"`.
- Preserve cleanup behavior for temp files in `/tmp` and `/var/tmp`.

### Cleanup

- Use `rm -f` to remove temp files with no error if file is already missing.
- `run_demos.zsh` uses `trap cleanup EXIT` for automatic cleanup.

### Window Sizing

- `--width` and `--height` are static values, not auto-fit hints.
- Size windows for actual content being shown, especially long messages, checkbox groups, list items, images, and infoboxes.
- Use `demos/11_window_options.zsh` as starting reference, then adjust after testing real content.

### Zsh-Specific Features

- Array keys: `${(@k)array}`
- Array length: `${#array[@]}`
- Array sorting: `${(o)array}`
- Associative arrays used in `run_demos.zsh`

## Runtime and Dependencies

- Target assumptions: macOS 15+ and swiftDialog 3+.
- `jq` ships with macOS 15 (Sequoia) and later; no fallback handling needed in this repo.
- Ask for confirmation before adding new dependencies.

## Change Rules

- Prompt user to run `zsh -n` on any changed `.zsh` files before finishing.
- This includes `demos/NN_*.zsh` and starter templates under `skills/**/templates/` and `skills/**/assets/templates/`.
- Do not renumber or rename demos unless `README.md` and `run_demos.zsh` are updated in same change.
- Keep demos independent; avoid shared helper libraries for simple examples.
- If adding new demo or feature, update all related mapping points together:
  - `demos/NN_*.zsh`
  - selector UI and `demo_map` in `run_demos.zsh`
  - Demo Index in `README.md`
- If adding or changing AI skill pack, update related documentation together:
  - skill directory contents
  - `skills/README.md`
  - skill-specific `README.md`
  - top-level AI skills section in `README.md`

## Required Validation

1. For `AGENTS.md`-only changes, review Markdown structure, terminology, and cross-file consistency.
2. For any changed `.zsh` script or template, prompt user to run `zsh -n` on each changed file.
3. For demo additions or behavior changes, verify repo layout references still match actual files:
   - `run_demos.zsh`
   - `demos/01_basic_styles.zsh` through `demos/20_branched_workflows.zsh`
   - Demo Index in `README.md`
4. For skill-pack changes, verify companion docs stay aligned:
   - `skills/README.md`
   - skill-specific `README.md`
   - top-level AI skills section in `README.md`
5. Verify no instructions or docs import behavior from unrelated repos.

## Maintenance

This file is version-controlled with repo.
When workflow, style rules, validation expectations, or boundaries change, update `AGENTS.md` so repeated guidance becomes explicit.
Keep file concise enough for agent attention, but specific enough to prevent repeat mistakes.
