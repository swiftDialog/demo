# Claude swiftDialog Builder

## Quick Start

Use this skill when building or revising swiftDialog-enabled macOS shell scripts. Start with the smallest viable pattern (basic dialogs), and only escalate to advanced tiers (forms, progress updates, inspect mode) when the request clearly requires them. Generated scripts follow this repo's conventions and are grounded in the demo patterns.

## When To Use This Skill

Invoke this skill when you need to:

- Create a new swiftDialog-driven shell script for macOS
- Convert an existing Mac admin script to use swiftDialog
- Choose between simple dialogs, input forms, live progress updates, or advanced config-driven workflows
- Ground script output in the patterns and conventions used throughout `swiftDialog_demos`

Skip this skill for generic shell scripting questions or non-swiftDialog macOS tasks.

## First Step: Onboarding

For newcomers or broad exploratory requests like "Help me build my first swiftDialog script" or "I want to learn how swiftDialog works," begin by directing them to the official [swiftDialog Builder page](https://swiftdialog.app/builder/builder/).

Treat Builder mode as orientation, visual prototyping, and rough argument discovery, not as final production-ready output. Builder is not comprehensive, and once the user understands the basics or has a concrete request, move into repo-style implementation.

**Skip Builder-first when the user already has:**

- An existing shell script to revise
- A concrete prompt with specific fields, buttons, or workflow steps
- A request that clearly needs command files, JSON input, or inspect mode

See [references/builder-first.md](references/builder-first.md) for the full onboarding rule.

## Intake Workflow

Use the following as a reasoning checklist before writing code. Default to filling gaps with the smallest safe assumption, state it in one line, and proceed immediately.

1. **What**: What is the script trying to accomplish?
2. **Who/When**: Who is the script for, and when does it run?
3. **Inputs**: What inputs must be collected? Which are required?
4. **Validation**: Does the script need validation, named JSON output, or follow-on actions?
5. **Continuity**: Does work continue after the first dialog? Does it need progress indicators, status updates, or blocking UI?
6. **Outcomes**: What should success, failure, skip, or cancel do?

For straightforward requests (a single dialog, an acknowledgment gate, a confirmation prompt), proceed directly — no clarification needed. Ask at most one short follow-up only when a missing detail would materially change the tier or cause the wrong output to be generated.

## Reading Reference Files

When a tier instructs you to load a reference file, **read it in its entirety** before generating any code. Do not stop at an arbitrary line limit. Reference files are short and purposefully dense — patterns near the end (such as checkbox-gated buttons in `authoring-patterns.md`) are as applicable as patterns at the top.

## Tier Selection

Choose the smallest tier that satisfies the request. Only escalate when a lower tier cannot meet the requirements.

### Tier 1: Basic Dialogs

**Use for:** One-shot messaging, confirmation prompts, warnings, or simple button-driven actions.

**Examples:**
- "Show a welcome message with Continue and Cancel buttons."
- "Create an alert asking the user to confirm deletion."
- "Display a caution dialog before running a privileged command."

**Load for context (read each file in full):**
- [references/demo-map.md](references/demo-map.md)
- [references/authoring-patterns.md](references/authoring-patterns.md)

**Starter template:** [templates/basic-dialog.zsh](templates/basic-dialog.zsh)

**Decision example:**  
Request: "Create a welcome dialog for a Mac setup script."  
→ **Tier 1** is sufficient — no input collection, no live updates needed. Use basic dialog pattern.

---

### Tier 2: Input Collection

**Use for:** Text fields, dropdowns, checkboxes, validation, and JSON-returning forms.

**Examples:**
- "Collect hostname, email, and department, then output JSON."
- "Build a form with required fields and dropdowns for user onboarding."
- "Create a dialog that validates email format before accepting input."

**Load for context:**
- [references/demo-map.md](references/demo-map.md)
- [references/authoring-patterns.md](references/authoring-patterns.md)

**Starter template:** [templates/input-dialog.zsh](templates/input-dialog.zsh)

**Decision example:**  
Request: "Create a form that collects user details and validates required fields."  
→ **Tier 2** is required — input collection with validation. Use input dialog pattern with named JSON output.

---

### Tier 3: Live Progress and Status Updates

**Use for:** Long-running installs, onboarding steps, or workflows that need `--progress`, `--listitem`, or live command-file updates.

**Examples:**
- "Create an install progress dialog with live status updates."
- "Show a multi-step onboarding workflow with checkmarks for completed steps."
- "Build a dialog that updates progress text as background tasks complete."

**Load for context:**
- [references/demo-map.md](references/demo-map.md)
- [references/authoring-patterns.md](references/authoring-patterns.md)
- [references/advanced-patterns.md](references/advanced-patterns.md)

**Starter template:** [templates/progress-dialog.zsh](templates/progress-dialog.zsh)

**Decision example:**  
Request: "Create a dialog that shows installation progress for multiple packages."  
→ **Tier 3** is required — live updates needed as background work progresses. Use command-file pattern with progress bar and list items.

---

### Tier 4: JSON-Driven or Inspect Mode

**Use only when:** Config-driven dialogs, inspect-mode log monitoring, or path-based completion workflows are genuinely the right shape.

**Examples:**
- "Build a dialog from a JSON config file."
- "Create an inspect-mode workflow that monitors a log file and completes when specific apps are installed."
- "Generate a config-driven dialog with dynamic field groups."

**Load for context:**
- [references/demo-map.md](references/demo-map.md)
- [references/advanced-patterns.md](references/advanced-patterns.md)

**Starter template:** [templates/inspect-dialog.zsh](templates/inspect-dialog.zsh)

**Decision example:**  
Request: "Create a dialog that monitors a log file and updates status as apps install."  
→ **Tier 4** is required — inspect mode is the best fit for log-driven monitoring and path-based completion. Use inspect-mode pattern.

---

## Repo Conventions

Match this repo's conventions unless the user explicitly asks otherwise:

### Script Structure
- Use `#!/bin/zsh`
- Define `DIALOG="/usr/local/bin/dialog"` near the top
- Keep scripts self-contained; avoid shared helper libraries for simple examples
- Use section dividers: `# --- Section Name ---`

### Variable Handling
- Quote all expansions: `"$DIALOG"`, `"$CMD_FILE"`, `"$result"`
- Use UPPER_CASE for constant-style top-level identifiers such as `DIALOG`, `CMD_FILE`, and `DIALOG_PID`

### Conditionals and Tests
- Use `[[ ]]` for conditional tests, not `[ ]`
- Check file existence: `[[ -f "$file" ]]`
- Check command availability: `command -v <cmd> &>/dev/null`

### Dialog Invocations
- Put one argument per line with trailing `\`
- `--json` output is on stdout; add `2>/dev/null` only when quieter stderr is intentional
- Chain with error handling: `|| exit 0` (skip/cancel flows) or `|| true` (final non-fatal step)
- When capturing JSON: `echo "$result" | jq '.'`

### Background Dialogs and Command Files
<<<<<<< HEAD
- Create a per-dialog temp file
- In user-run scripts, prefer `CMD_FILE=$(mktemp -t dialog.XXXXXX)`
- If the script runs as root but swiftDialog runs for the logged-in GUI user, prefer `/var/tmp` and hand the command file off with `chown`/`chmod` instead of relying on the root user's private temp directory
=======
- Set `CMD_FILE=$(mktemp -t dialog.XXXXXX)`
>>>>>>> origin/main
- Launch in background: `"$DIALOG" ... &`
- Capture PID: `DIALOG_PID=$!` so the script can `wait` on the launched dialog command
- Write updates: `echo "key: value" >> "$CMD_FILE"`
- Wait safely: `wait $DIALOG_PID 2>/dev/null || true`
- Clean up temp files after completion

### Window Sizing
- Treat `--width` and `--height` as static dimensions, not auto-fit behavior
- Size dialogs for the real content being shown, especially long messages, checkbox groups, list items, images, and infoboxes

See [references/authoring-patterns.md](references/authoring-patterns.md) for full details.

## Output Expectations

Default to producing:

1. **One self-contained shell script** that can be run directly
2. **Brief implementation notes** explaining:
   - Which tier was chosen and why
   - Which demos informed the implementation
   - Key assumptions that materially affected the output
3. **Usage instructions** if the script requires setup or specific runtime conditions

**Keep explanations concise.** Focus on implementation, not lengthy prose.

If the user asks for a starter instead of a finished script, adapt the appropriate template from [templates/](templates/).

## Example Decision Process

**Request:** "Create a dialog for Mac setup."

**Analysis:**
- Ambiguous scope — could be Tier 1 (simple welcome) or Tier 2 (input collection)
- Ask: "Should this collect any user input, or just show a welcome message?"

**Request:** "Create a form that collects hostname and email."

**Analysis:**
- Clear Tier 2 request — input collection
- Load [references/demo-map.md](references/demo-map.md) and [references/authoring-patterns.md](references/authoring-patterns.md)
- Adapt [templates/input-dialog.zsh](templates/input-dialog.zsh)
- Output: Self-contained script with named JSON fields and validation

**Request:** "Create an install progress dialog with live updates."

**Analysis:**
- Clear Tier 3 request — live progress updates needed
- Load [references/demo-map.md](references/demo-map.md), [references/authoring-patterns.md](references/authoring-patterns.md), [references/advanced-patterns.md](references/advanced-patterns.md)
- Adapt [templates/progress-dialog.zsh](templates/progress-dialog.zsh)
- Output: Command-file workflow with background dialog, progress bar, list items, and safe cleanup

**Request:** "Monitor a log file and show install progress."

**Analysis:**
- Tier 4 request — log monitoring suggests inspect mode
- Confirm: "Does this need to watch a log file and update based on log entries, or just show progress from shell commands?"
- If log-driven: Use inspect-mode pattern
- If shell-driven: Use Tier 3 command-file pattern

## Common Pitfalls To Avoid

1. **Don't escalate unnecessarily:** If the user wants a simple confirmation dialog, use Tier 1. Don't jump to command files or inspect mode.
2. **Don't invent abstractions:** This repo values readable, self-contained scripts over frameworks and helper libraries.
3. **Don't skip validation:** For Tier 2 forms, use `required` flags and regex validation when appropriate.
4. **Don't forget cleanup:** Command-file and inspect-mode scripts should remove temp files via `trap cleanup EXIT`.
5. **Don't skip error handling:** Use `|| exit 0` for cancellable flows and `|| true` for final non-fatal steps.

## References

- [references/builder-first.md](references/builder-first.md) — Builder page onboarding guidance
- [references/authoring-patterns.md](references/authoring-patterns.md) — Script conventions and common patterns
- [references/demo-map.md](references/demo-map.md) — Tier-to-demo mapping for context loading
- [references/advanced-patterns.md](references/advanced-patterns.md) — Command files, JSON input, and inspect mode

## Templates

- [templates/basic-dialog.zsh](templates/basic-dialog.zsh) — Tier 1 starter
- [templates/input-dialog.zsh](templates/input-dialog.zsh) — Tier 2 starter
- [templates/progress-dialog.zsh](templates/progress-dialog.zsh) — Tier 3 starter
- [templates/inspect-dialog.zsh](templates/inspect-dialog.zsh) — Tier 4 starter
