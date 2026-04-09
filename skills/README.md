# Skills Directory

This `skills/` directory holds AI-assistant instruction packs for `swiftDialog_demos`.

**These skills are not runnable demos.** They are guidance packages intended to help AI assistants (Codex, Claude, etc.) understand how to work within this repository, reuse the existing demo patterns, and produce output that matches the repo's conventions.

They treat the official Builder page as onboarding help, not final output, and normalize repo patterns such as `mktemp`-based command files and content-aware window sizing.

## Purpose

Use the files in this directory when you want an AI assistant to:

- generate new repo-aligned swiftDialog shell scripts
- revise existing scripts using patterns from this repository
- reuse curated references, templates, and instructions instead of starting from scratch

## Structure

Each skill lives in its own subdirectory and may include:

- `SKILL.md` or `CLAUDE.md`: the core AI-facing instructions
- `README.md`: a human-facing overview of the skill
- `references/`: focused reference material used by the skill
- `templates/` or `assets/`: starter scripts or reusable files
- `agents/`: UI metadata for specific AI platforms (when applicable)

## Current Skills

### [`codex-swiftdialog-builder`](./codex-swiftdialog-builder/)

Helps **GitHub Copilot / Codex** build or revise repo-aligned swiftDialog shell scripts.

- **Main file**: `SKILL.md`
- **Platform**: GitHub Copilot, OpenAI Codex
- **Invocation**:
```text
Review skills/codex-swiftdialog-builder/SKILL.md and use it to create an internal-use swiftDialog shell script for our team. The script should display on-screen instructions and require the user to explicitly acknowledge them before proceeding. Treat this as an internal workflow, not a public-facing demo.
```

### [`claude-swiftdialog-builder`](./claude-swiftdialog-builder/)

Helps **Claude Sonnet** create or revise swiftDialog-enabled macOS shell scripts using the patterns in this repo.

- **Main file**: `CLAUDE.md`
- **Platform**: Claude (Anthropic)
- **Invocation**:
```text
Review skills/claude-swiftdialog-builder/CLAUDE.md and use it to create an internal-use swiftDialog shell script for our team. The script should display on-screen instructions and require the user to explicitly acknowledge them before proceeding. Treat this as an internal workflow, not a public-facing demo.
```

## Usage

### For GitHub Copilot / Codex

If a skill supports explicit invocation, reference it by name in your prompt:

```
Use $codex-swiftdialog-builder to create a form that collects hostname and email.
```

### For Claude Sonnet

Reference the skill's main instruction file directly in your prompt:

```
Review skills/claude-swiftdialog-builder/CLAUDE.md and use it to create a progress dialog with live updates.
```

### For Other AI Assistants

Both skill packs are self-contained and can be adapted to other AI platforms. Review the `README.md` and main instruction file in each skill directory for usage guidance specific to that skill.

### Hands-On Practice

For a guided, step-by-step introduction to using these skills with AI assistants, see the [`playground/`](../playground/) directory. The playground includes:

- Detailed workflow walkthroughs showing exact prompts and expected AI interactions
- 5 realistic Mac Admin scenarios (onboarding forms, compliance prompts, app deployment, policy acknowledgment, inspect mode)
- Tips for effective AI collaboration and troubleshooting common issues
- Quick reference cards for tier selection and common patterns

**Start here:** [`playground/README.md`](../playground/README.md)

## Choosing a Skill Pack

- **Use `codex-swiftdialog-builder`** if working with GitHub Copilot or OpenAI Codex
- **Use `claude-swiftdialog-builder`** if working with Claude Sonnet
- Both produce identical script output and follow the same repo conventions from `AGENTS.md`

For detailed behavior, examples, and references, open the skill-specific `README.md` or instruction file inside that skill's directory.
