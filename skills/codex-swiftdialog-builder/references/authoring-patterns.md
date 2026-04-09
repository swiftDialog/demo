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

**Example:**

```zsh
result=$("$DIALOG" \
    --title "User Input" \
    --message "Enter your details below." \
    --textfield "Name,required,name=username" \
    --button1text "Submit" \
    --button2text "Cancel" \
    --json 2>/dev/null) || exit 0

echo "$result" | jq '.'
```

## Flow control

- Use `|| exit 0` for intermediate dialogs that users can skip or cancel
- Use `|| true` for the final non-fatal dialog in a sequence
- Use `[[ ... ]]` instead of `[ ... ]` for conditional tests

**Examples:**

```zsh
# Intermediate dialog - user can cancel
"$DIALOG" --message "Step 1" --button1text "Next" --json || exit 0

# Final dialog - do not fail the script if dialog errors out
"$DIALOG" --message "Complete!" --button1text "Done" --json || true
```

## Background dialogs and command files

- Set `CMD_FILE="/var/tmp/dialog.log"`
- Remove the command file before use with `rm -f "$CMD_FILE"`
- Launch the dialog in the background: `"$DIALOG" ... &`
- Capture PID immediately: `DIALOG_PID=$!`
- Write updates with `echo "key: value" >> "$CMD_FILE"`
- Finish with `wait $DIALOG_PID 2>/dev/null || true`
- Remove temporary files after the workflow completes

**Example structure:**

```zsh
DIALOG="/usr/local/bin/dialog"
CMD_FILE="/var/tmp/dialog.log"

cleanup() {
    rm -f "$CMD_FILE"
}
trap cleanup EXIT

rm -f "$CMD_FILE"

"$DIALOG" \
    --title "Installing" \
    --progress 3 \
    --commandfile "$CMD_FILE" \
    --button1text "Please wait..." \
    --button1disabled &

DIALOG_PID=$!
sleep 1

echo "progress: 1" >> "$CMD_FILE"
echo "progresstext: Step 1/3" >> "$CMD_FILE"
sleep 2

echo "progress: 2" >> "$CMD_FILE"
echo "progresstext: Step 2/3" >> "$CMD_FILE"
sleep 2

echo "progress: 3" >> "$CMD_FILE"
echo "progresstext: Complete" >> "$CMD_FILE"
echo "button1text: Done" >> "$CMD_FILE"
echo "button1: enable" >> "$CMD_FILE"

wait $DIALOG_PID 2>/dev/null || true
```

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

**Example with named fields:**

```zsh
result=$("$DIALOG" \
    --textfield "Hostname,required,name=hostname" \
    --textfield "Email,required,name=email" \
    --selecttitle "Department,required,name=department" \
    --selectvalues "Engineering,Design,Marketing" \
    --json 2>/dev/null) || exit 0

# Named output: {"hostname":"mac-001","email":"user@example.com","department":"Engineering"}
echo "$result" | jq '.'
```

## Variable handling

- Quote all variable expansions: `"$DIALOG"`, `"$CMD_FILE"`, `"$result"`
- Use UPPER_CASE for constant-style top-level identifiers such as `DIALOG`, `CMD_FILE`, and `DIALOG_PID`
- Do not use `local` at script level (only meaningful inside functions)

## Conditional tests

- Use `[[ ]]` for tests, not `[ ]`
- File existence: `[[ -f "$file" ]]`
- Command availability: `command -v <cmd> &>/dev/null`

**Examples:**

```zsh
if ! command -v "$DIALOG" &>/dev/null; then
    echo "Error: swiftDialog not found at $DIALOG"
    exit 1
fi

if [[ -f "$CMD_FILE" ]]; then
    rm -f "$CMD_FILE"
fi
```

## Error suppression

- Suppress stderr with `2>/dev/null` when capturing dialog output
- This prevents error messages from polluting captured JSON

```zsh
# Correct
result=$("$DIALOG" --json 2>/dev/null)

# Incorrect (stderr will mix with JSON output)
result=$("$DIALOG" --json)
```

## Cleanup patterns

- Use `rm -f` to remove temp files (no error if missing)
- Use `trap cleanup EXIT` for automatic cleanup in command-file scripts

```zsh
cleanup() {
    rm -f "$CMD_FILE"
    rm -f "$TEMP_JSON"
}
trap cleanup EXIT
```

## Common variable names

Follow these conventions from the demos:

- `DIALOG="/usr/local/bin/dialog"`
- `CMD_FILE="/var/tmp/dialog.log"`
- `DIALOG_PID` (for background dialog process ID)
- `result` (for captured dialog output)

## String formatting

- Use double quotes for strings
- Use backticks for inline code in markdown messages: `` `--flag` ``
- Keep user-facing copy concise and feature-specific

```zsh
"$DIALOG" \
    --title "Setup Complete" \
    --message "Your Mac is ready to use. Click **Done** to finish." \
    --button1text "Done"
```
