# AGENTS.md

Agent guidelines for `swiftDialog_demos`.

## Intent

Keep this repo a clear, self-guided showcase of swiftDialog features.
Prefer readable, realistic demos over abstraction.
Keep the bundled AI skill packs aligned with the repo's actual demo patterns.

## Workspace Snapshot

- Controller: `run_demos.zsh`
- Demos: `demos/01_basic_styles.zsh` through `demos/19_inspect_mode.zsh`
- AI skills: `skills/codex-swiftdialog-builder/` and `skills/claude-swiftdialog-builder/`
- Skills index: `skills/README.md`
- Public index: `README.md`
- Repo guidance: `AGENTS.md`

## Working Agreements

- Before finishing, prompt the user to run `zsh -n` against any changed `.zsh` files. This includes `demos/NN_*.zsh` and any starter templates under `skills/**/templates/` and `skills/**/assets/templates/`.
- Do not attempt this syntax check via the Bash tool — sandbox restrictions may interrupt it.
- Ask for confirmation before adding any new dependency.
- Never make edits while checked out on `main`.
- Before any new feature or refactor, create and switch to a new Git branch.
- If branch creation/switching is blocked, stop and ask the user how to proceed.
- Do not add `Co-Authored-By:` or any agent attribution trailers to commit messages.

## Script Conventions (Match Existing Files)

### Headers and structure

- Use `#!/bin/zsh` in executable scripts.
- Keep demo headers in this pattern:
  - `# Demo NN: ...`
  - `# Demonstrates: ...`
- Demo files use two-digit zero-padded numbering: `01`, `02`, ... `19`.
- Define `DIALOG="/usr/local/bin/dialog"` near the top.
- Only `run_demos.zsh` uses `set -euo pipefail`; demo scripts do not.
- Starter templates under `skills/` should also use `#!/bin/zsh` and keep the same shell conventions unless the target AI platform requires a different file layout. This applies to both `templates/` and `assets/templates/`.

### Comments

- Use single `#` with a space for inline comments.
- Section dividers use exactly three dashes on each side: `# --- Section Name ---`.

### Variables

- Use UPPER_CASE for constants and script-wide variables.
- Always quote variable expansions: `"$DIALOG"`, `"$CMD_FILE"`, `"$result"`.
- Common variable names: `DIALOG`, `CMD_FILE`, `DIALOG_PID`, `result`.
- Do not use `local` at script level — it is only meaningful inside functions.

### Conditionals and tests

- Use `[[ ]]` for conditional tests, not `[ ]`.
- File existence: `[[ -f "$file" ]]`.
- Command availability: `command -v <cmd> &>/dev/null`.

### Dialog invocations

- Keep dialog arguments one flag per line with trailing `\`.
- Suppress stderr when capturing output: `result=$("$DIALOG" ... 2>/dev/null)`.
- Chain with error handling: `|| exit 0` (skip) or `|| true` (final step).
- When capturing JSON output, often follow with: `echo "$result" | jq '.'`.

### Strings and markdown

- Use double quotes for strings.
- Use backticks for inline code in markdown messages: `` `--flag` ``.
- Keep user-facing copy concise and feature-specific.

## Real-World Patterns in This Repo

### Error handling

- Skip flows usually use `|| exit 0` in intermediate steps (for example `demos/01_basic_styles.zsh`).
- Final non-fatal completion usually uses `|| true` (for example the last step in many demo scripts).
- Suppress stderr with `2>/dev/null` when capturing dialog output or checking versions.

### Background processes

- Launch dialog in background: `"$DIALOG" ... &`.
- Capture PID immediately after: `DIALOG_PID=$!`.
- Wait safely at end: `wait $DIALOG_PID 2>/dev/null || true`.
- Used in demos `06`, `10`, `12`, `14`.

### Command files

- Command-file demos use `CMD_FILE="/var/tmp/dialog.log"` and clean up with `rm -f` (for example demos `06`, `10`, `12`, `14`).
- Always remove command file before use: `rm -f "$CMD_FILE"`.
- Write updates with `echo "key: value" >> "$CMD_FILE"`.

### Cleanup

- Use `rm -f` to remove temp files (no error if missing).
- `run_demos.zsh` uses `trap cleanup EXIT` for automatic cleanup.

### Zsh-specific features

- Array keys: `${(@k)array}`.
- Array length: `${#array[@]}`.
- Array sorting: `${(o)array}`.
- Associative arrays (maps) used in `run_demos.zsh`.

## Runtime and Dependencies

- Target assumptions: macOS 15+, swiftDialog 3+.
- `jq` is bundled with macOS 15 (Sequoia) and later — it is always available in the target environment; no fallback handling is needed.
- Ask for confirmation before adding new dependencies.

## Change Rules

- Prompt the user to run `zsh -n` on any changed `.zsh` files before finishing. Do not attempt to run this check via the Bash tool.
- Do not renumber or rename demos unless `README.md` and `run_demos.zsh` are updated in the same change.
- Keep demos independent; avoid introducing shared helper libraries for simple examples.
- Preserve cleanup behavior for temp files in `/tmp` and `/var/tmp`.
- If adding a new demo/feature, update all related mapping points together:
  - `demos/NN_*.zsh`
  - selector UI and `demo_map` in `run_demos.zsh`
  - Demo Index in `README.md`
- If adding or changing an AI skill pack, update the related documentation together:
  - skill directory contents
  - `skills/README.md`
  - skill-specific `README.md`
  - top-level AI skills section in `README.md`

## Local Tracking

This file is repo guidance and is version-controlled alongside the demos and skill packs.
