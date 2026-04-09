# Authoring Patterns

These patterns are shared across the repo and should shape generated scripts.

## Script shape

- Use `#!/bin/zsh`
- Keep the script self-contained and readable
- Define `DIALOG="/usr/local/bin/dialog"` near the top
- Use section dividers like `# --- Section Name ---`

## Dialog invocation

- Put one argument per line with trailing `\`
- Capture output as `result=$("$DIALOG" ... --json) || exit 0`
- Add `2>/dev/null` only when you intentionally want quieter stderr
- Print captured JSON with `echo "$result" | jq '.'` when the script is a demo or debugging starter

**Example:**

```zsh
result=$("$DIALOG" \
    --title "User Input" \
    --message "Enter your details below." \
    --textfield "Name,required,name=username" \
    --button1text "Submit" \
    --button2text "Cancel" \
    --json) || exit 0

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

## Window sizing

- `--width` and `--height` are static values, not auto-fit hints
- Size windows for the actual content you are showing: long messages, lists, checkbox groups, images, and infoboxes all change the space needed
- Builder previews are useful, but final scripts still need sizing judgment after testing real content
- Start from `demos/11_window_options.zsh` and adjust based on the workflow

## Background dialogs and command files

- Create a per-dialog temp file
- In user-run scripts, prefer `CMD_FILE=$(mktemp -t dialog.XXXXXX)`
- If the script runs as root but swiftDialog runs for the logged-in GUI user, prefer `/var/tmp` over the root user's private temp directory and hand the file off with `chown`/`chmod`
- Use a `cleanup` function plus `trap cleanup EXIT` to remove it automatically
- Launch the dialog in the background: `"$DIALOG" ... &`
- Capture PID immediately: `DIALOG_PID=$!`
- Use `DIALOG_PID` to `wait` on the launched dialog command; do not treat `dialogcli --pid` as a general-purpose scripting pattern
- Write updates with `echo "key: value" >> "$CMD_FILE"`
- Finish with `wait $DIALOG_PID 2>/dev/null || true`
- Remove temporary files after the workflow completes

**User-run example structure:**

```zsh
DIALOG="/usr/local/bin/dialog"
CMD_FILE=""

cleanup() {
    if [[ -n "$CMD_FILE" ]]; then
        rm -f "$CMD_FILE"
    fi
}
trap cleanup EXIT

CMD_FILE=$(mktemp -t dialog.XXXXXX)

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

wait $DIALOG_PID 2>/dev/null || true
```

**Jamf/root-run example structure:**

```zsh
DIALOG="/usr/local/bin/dialog"
CMD_FILE=""

cleanup() {
    if [[ -n "$CMD_FILE" ]]; then
        rm -f "$CMD_FILE"
    fi
}
trap cleanup EXIT

current_logged_in_user() {
    LOGGED_IN_USER=$(/bin/echo "show State:/Users/ConsoleUser" | /usr/sbin/scutil | /usr/bin/awk '/Name :/ { print $3 }')
    [[ -n "$LOGGED_IN_USER" && "$LOGGED_IN_USER" != "loginwindow" ]] || return 1
    /usr/bin/id -u "$LOGGED_IN_USER" >/dev/null 2>&1
}

prepare_file_for_dialog_user() {
    local target_file="$1"

    current_logged_in_user || return 1
    /usr/sbin/chown "$LOGGED_IN_USER" "$target_file" || return 1
    /bin/chmod 600 "$target_file" || return 1
}

CMD_FILE=$(mktemp "/var/tmp/dialog.XXXXXX")
prepare_file_for_dialog_user "$CMD_FILE" || exit 1

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
    --json) || exit 0

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

- `--json` writes structured output to stdout, while errors are written to stderr
- Use `2>/dev/null` only when you intentionally want to hide noisy stderr from the user or logs

```zsh
# Keep stderr visible
result=$("$DIALOG" --json)

# Quieter capture when desired
result=$("$DIALOG" --json 2>/dev/null)
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
- `CMD_FILE=$(mktemp "/var/tmp/dialog.XXXXXX")` for root-run command-file flows that hand work to the logged-in GUI user
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
