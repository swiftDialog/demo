# Skills Directory

This `skills/` directory holds AI-assistant instruction packs for `swiftDialog_demos`.

**These skills are not runnable demos.** They are guidance packages intended to help AI assistants (Codex, Claude, etc.) understand how to work within this repository, reuse the existing demo patterns, and produce output that matches the repo's conventions.

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

Helps **GitHub Copilot/Codex** create or revise swiftDialog-enabled macOS shell scripts using the patterns in this repo.

- **Main file**: `SKILL.md`
- **Platform**: GitHub Copilot, OpenAI Codex
- **Invocation**: `Use $codex-swiftdialog-builder to create a repo-style swiftDialog shell script.`

### [`claude-swiftdialog-builder`](./claude-swiftdialog-builder/)

Helps **Claude Sonnet** create or revise swiftDialog-enabled macOS shell scripts using the patterns in this repo.

- **Main file**: `CLAUDE.md`
- **Platform**: Claude (Anthropic)
- **Invocation**: Upload as project knowledge or reference directly: `Using the swiftDialog builder skill, create...`

## Usage

### For GitHub Copilot / Codex

If a skill supports explicit invocation, reference it by name in your prompt:

```
Use $codex-swiftdialog-builder to create a form that collects hostname and email.
```

### For Claude Sonnet

Upload the skill folder as project knowledge or attach/reference the main instruction file:

```
Using the swiftDialog builder skill, create a progress dialog with live updates.
```

Alternatively, point Claude directly to the instruction file:

```
Review CLAUDE.md in skills/claude-swiftdialog-builder/, then create a dialog for Mac setup.
```

### For Other AI Assistants

Both skill packs are self-contained and can be adapted to other AI platforms. Review the `README.md` and main instruction file in each skill directory for usage guidance specific to that skill.

## Choosing a Skill Pack

- **Use `codex-swiftdialog-builder`** if working with GitHub Copilot or OpenAI Codex
- **Use `claude-swiftdialog-builder`** if working with Claude Sonnet
- Both produce identical script output and follow the same repo conventions from `AGENTS.md`

For detailed behavior, examples, and references, open the skill-specific `README.md` or instruction file inside that skill's directory.
