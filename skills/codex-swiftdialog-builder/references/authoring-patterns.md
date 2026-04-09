# Authoring Patterns

These patterns are shared across the repo and should shape generated scripts.

## Script shape

- Use `#!/bin/zsh`
- Keep the script self-contained and readable
- Define `DIALOG="/usr/local/bin/dialog"` near the top
- Use section dividers like `# --- Section Name ---`

## Dialog invocation

- Put one argument per line with trailing `\`
- Capture output as `result=$("$DIALOG" ... --json 2>/dev/null) || exit 0`
- Print captured JSON with `echo "$result" | jq '.'` when the script is a demo or debugging starter

## Flow control

- Use `|| exit 0` for intermediate dialogs that users can skip or cancel
- Use `|| true` for the final non-fatal dialog in a sequence
- Use `[[ ... ]]` instead of `[ ... ]`

## Background dialogs and command files

- Set `CMD_FILE="/var/tmp/dialog.log"`
- Remove the command file before use with `rm -f "$CMD_FILE"`
- Launch the dialog in the background, then set `DIALOG_PID=$!`
- Write updates with `echo "key: value" >> "$CMD_FILE"`
- Finish with `wait $DIALOG_PID 2>/dev/null || true`
- Remove temporary files after the workflow completes

## Checkbox-gated button

To require a checkbox before button1 becomes active, combine `--button1disabled` with the `enableButton1` modifier on `--checkbox`. swiftDialog wires them natively — no command file or JSON validation needed.

- `--button1disabled` locks button1 at launch
- `,enableButton1` on the checkbox value unlocks button1 when checked
- Both flags are required together; neither works alone for this pattern

**Example:**

```zsh
"$DIALOG" \
    --title "Confirm" \
    --message "Read the above before continuing." \
    --checkbox "I have read and understood the instructions above,name=acknowledged,enableButton1" \
    --button1text "Continue" \
    --button1disabled \
    --button2text "Cancel" \
    --json 2>/dev/null || exit 0
```

## Output conventions

- Prefer JSON output for forms and selections
- Use named fields when downstream processing benefits from stable keys
- Keep user-facing copy concise and feature-specific
