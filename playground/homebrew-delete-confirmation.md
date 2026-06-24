# Internal Homebrew Uninstall Script – Jamf/Root-Run swiftDialog Prompt for codex-swiftdialog-builder

**Review** `skills/codex-swiftdialog-builder/SKILL.md` (including its intake checklist, tier definitions, and references to authoring-patterns.md) and use it to create a self-contained, internal-use Zsh shell script for our team.

This script is a **Jamf/root-run workflow**: the script itself is launched as `root`, while swiftDialog is presented to the logged-in GUI user.

## Goal
Create a script that **safely uninstalls Homebrew** with clear user consent and security verification.

The script must follow this exact workflow:
1. Check if `brew` is installed. If not, show a simple info dialog and exit 0.
2. Display a **prominent warning dialog** that dynamically lists all currently installed Homebrew formulae (`brew list`) and casks (`brew list --cask`).
3. Require **explicit acknowledgment** via a checkbox before any further action can proceed.
4. After acknowledgment:
   - Download the official Homebrew uninstall script to a temporary location.
   - Strictly verify its SHA256 hash (fail closed with an error dialog if it does not match).
   - Run the uninstall script non-interactively.
5. Show appropriate status or progress feedback while the uninstall is running.
6. Handle user cancellation gracefully at any step.

For the progress/status portion, use the repo's **Jamf/root-run command-file handoff pattern**:
- The script runs as `root`.
- The command file lives in `/var/tmp`.
- The command file is handed off to the logged-in GUI user so swiftDialog can read live updates.

## Security Requirement (Critical – Fail Closed)
- Download from: `https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh`
- Save to a temporary file (use `mktemp`).
- Compute the SHA256 hash using `openssl sha256` (preferred) or `shasum -a 256`.
- The hash **must exactly match** the known good value. If it does **not** match, display a clear error dialog and exit 1. Do **not** proceed under any circumstances.
- Expected hash: `58e8ea576b9f9682c4740c0e4c286dfea8d15271f33d8504006132a634f25b01`

**Note**: This uninstall is highly destructive. It will remove all formulae, casks, the Cellar, taps, and related files. Communicate this risk clearly and strongly in the dialog.

## Workflow & UI Details
- Use warning/red-orange accent colors and appropriate icons (e.g., shield or alert) for the acknowledgment dialog.
- Dynamically insert the list of installed packages into the message.
- After acknowledgment, display a progress/status dialog during the uninstall (Tier 3 behavior using command file updates if needed for live feedback).
- The progress/status dialog must be shown to the logged-in GUI user even though the script is launched as `root`.
- Treat this as a strict **internal team workflow tool** — professional, no-frills, no public-demo styling.

## Reference Acknowledgment Pattern
Adapt this exact Tier 1 acknowledgment pattern (checkbox + `enableButton1` + `--button1disabled`):

```zsh
#!/bin/zsh
# Internal: Policy Acknowledgment Dialog

DIALOG="/usr/local/bin/dialog"

# Guard: swiftDialog must be installed
if ! command -v "$DIALOG" &>/dev/null; then
    echo "Error: swiftDialog not found at $DIALOG" >&2
    exit 1
fi

"$DIALOG" \
    --title "Before You Proceed" \
    --message "Please read the following instructions carefully before continuing.\n\n**Step 1:** ...\n\n..." \
    --icon "SF=exclamationmark.shield,colour=#FF9500" \
    --checkbox "I have read and understood the instructions above,name=acknowledged,enableButton1" \
    --button1text "Acknowledge and Continue" \
    --button1disabled \
    --button2text "Cancel" \
    --moveable \
    --width 700 \
    --json 2>/dev/null || exit 0

# Workflow continues here...
```

## Additional Guidelines
- Follow **all** repository conventions from `SKILL.md`, `authoring-patterns.md`, and related references:
  - Shebang: `#!/bin/zsh`
  - `DIALOG="/usr/local/bin/dialog"`
  - Proper quoting of all variables
  - Use `[[ ]]` for tests
  - `|| exit 0` for graceful cancel
  - Self-contained script (no external helpers)
  - Use the Jamf/root-run `/var/tmp` + ownership-handoff command-file pattern for Tier 3 progress updates
- Choose the **smallest viable tier** that fully satisfies the requirements.
- Output **one complete, ready-to-use script**.
- At the bottom of the script (as comments), include brief notes explaining:
  - Which demo patterns or tiers were adapted.
  - Any assumptions made (dialog sizing, progress method, etc.).

Produce the full script.
