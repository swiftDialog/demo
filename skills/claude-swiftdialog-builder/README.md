# Claude swiftDialog Builder

A self-contained instruction pack for Claude Sonnet to create and revise swiftDialog-enabled macOS shell scripts.

## Purpose

This skill pack helps Claude Sonnet generate readable, self-contained swiftDialog scripts that follow the conventions and patterns used throughout the `swiftDialog_demos` repository.

Use this when you want Claude to:

- Create a new swiftDialog-driven shell script
- Convert an existing Mac admin script to use swiftDialog
- Choose between simple dialogs, input forms, live progress updates, or advanced config-driven workflows
- Ground generated output in proven demo patterns

## What's Included

- **[CLAUDE.md](CLAUDE.md)**: Main instruction file with tier selection workflow, intake process, and output expectations
- **[references/](references/)**: Supporting guidance documents
  - [builder-first.md](references/builder-first.md) — Builder page onboarding for newcomers
  - [authoring-patterns.md](references/authoring-patterns.md) — Script conventions and common patterns
  - [demo-map.md](references/demo-map.md) — Tier-to-demo mapping for context loading
  - [advanced-patterns.md](references/advanced-patterns.md) — Command files, JSON input, and inspect mode
- **[templates/](templates/)**: Four starter scripts for common patterns
  - [basic-dialog.zsh](templates/basic-dialog.zsh) — Simple messaging and confirmation (Tier 1)
  - [input-dialog.zsh](templates/input-dialog.zsh) — Input collection forms (Tier 2)
  - [progress-dialog.zsh](templates/progress-dialog.zsh) — Live progress and status updates (Tier 3)
  - [inspect-dialog.zsh](templates/inspect-dialog.zsh) — Log monitoring and inspect mode (Tier 4)

## How To Use With Claude Sonnet

### Option 1: Project Knowledge (Recommended)

Add this skill pack as project knowledge in Claude:

1. Upload the entire `claude-swiftdialog-builder/` folder to your [Claude project](https://support.anthropic.com/en/articles/9517075-what-are-projects)
2. Reference it naturally in prompts: "Using the swiftDialog builder skill, create a form that collects user details."

### Option 2: Direct Reference

Point Claude directly to `CLAUDE.md`:

```
Review the instructions in CLAUDE.md, then create a dialog for Mac setup.
```

### Option 3: Attach Individual Files

For specific requests, attach the relevant template or reference file to your conversation.

## Example Prompts

### Tier 1: Basic Dialogs

```
Using the swiftDialog builder skill, create a welcome dialog for a Mac setup workflow with Continue and Cancel buttons.
```

```
Create a simple confirmation dialog asking if the user wants to proceed with FileVault enablement.
```

### Tier 2: Input Collection

```
Using the swiftDialog builder skill, create a form that collects hostname, department, and email address. Make hostname and email required, and output the result as JSON.
```

```
Build an onboarding dialog that collects user details with validation—email must match a pattern, and include a dropdown for department selection.
```

### Tier 3: Live Progress and Status

```
Using the swiftDialog builder skill, create an install progress dialog that shows live updates as packages are downloaded, verified, and installed.
```

```
Create a multi-step setup workflow with a progress bar and list items that show status transitions as each step completes.
```

### Tier 4: JSON-Driven or Inspect Mode

```
Using the swiftDialog builder skill, create an inspect-mode workflow that monitors a log file and updates status as applications install, completing when all target apps appear.
```

```
Build a dialog from a JSON config file with dynamic field groups and validation rules.
```

### Conversion Requests

```
Using the swiftDialog builder skill, convert this existing shell script to use swiftDialog for user interaction:

[paste script]
```

## Tier Selection

Claude will automatically choose the smallest viable implementation tier:

1. **Tier 1**: Simple dialogs (messaging, confirmation, warnings)
2. **Tier 2**: Input collection (text fields, dropdowns, checkboxes, validation)
3. **Tier 3**: Live progress and status updates (command files, background dialogs)
4. **Tier 4**: JSON-driven or inspect mode (config-driven dialogs, log monitoring)

Claude will only escalate to higher tiers when the request clearly requires advanced features.

## Script Conventions

Generated scripts follow these conventions:

- `#!/bin/zsh`
- `DIALOG="/usr/local/bin/dialog"` defined near the top
- Quoted variable expansions
- `[[ ]]` conditionals (not `[ ]`)
- `2>/dev/null` when capturing dialog output
- `|| exit 0` for skip/cancel flows
- `|| true` for final non-fatal steps
- Command-file cleanup and `wait $DIALOG_PID 2>/dev/null || true` for background dialogs

See [references/authoring-patterns.md](references/authoring-patterns.md) for complete details.

## Builder Page Onboarding

For newcomers, Claude will direct them to the official [swiftDialog Builder page](https://swiftdialog.app/builder/builder/) for orientation before moving into script generation.

This helps new users understand swiftDialog's capabilities and experiment with arguments interactively before committing to a full implementation.

## Self-Contained Design

This skill pack is fully self-contained and requires no external dependencies or hidden context. All guidance, templates, and references are included in this folder.

You can copy this folder to any Claude project or share it with others who want to generate swiftDialog scripts with Claude Sonnet.

## Differences From Codex Version

This Claude-native version differs from the Codex skill in several ways:

- **No YAML frontmatter**: Pure markdown files optimized for Claude's instruction-following model
- **Conversational tone**: CLAUDE.md uses directive, conversational language rather than agent-facing metadata
- **Simplified structure**: `templates/` instead of `assets/templates/`, flatter hierarchy
- **Example prompts**: Includes Claude-specific example prompts showing natural interaction patterns
- **Decision process examples**: Shows Claude's tier selection reasoning explicitly

Both versions produce identical script output and follow the same conventions from `swiftDialog_demos`.
