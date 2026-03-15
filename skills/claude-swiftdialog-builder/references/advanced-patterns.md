# Advanced Patterns

Use these patterns only when a simpler tier is insufficient.

## When To Use a Command File

Choose a command-file workflow when the dialog must stay open while the script updates:

- Progress values or progress text change over time
- List item statuses need live updates (pending → working → success)
- Buttons or messages must unlock after background work finishes
- The script needs one persistent window instead of many sequential dialogs

**Reference demos:**

- `06_progress_timer.zsh` — progress bars, progress text, timers
- `10_list_items.zsh` — list items with dynamic status transitions
- `12_command_file.zsh` — comprehensive command-file update examples
- `14_mini_presentation.zsh` — compact staged presentation workflows

**Typical workflow:**

1. Set `CMD_FILE="/var/tmp/dialog.log"` and remove before use
2. Launch dialog in background: `"$DIALOG" ... --commandfile "$CMD_FILE" &`
3. Capture PID: `DIALOG_PID=$!`
4. Sleep briefly to ensure dialog is ready: `sleep 1`
5. Write updates: `echo "progress: 1" >> "$CMD_FILE"`
6. Wait for completion: `wait $DIALOG_PID 2>/dev/null || true`
7. Clean up: `rm -f "$CMD_FILE"` (ideally via `trap cleanup EXIT`)

**Example:**

```zsh
DIALOG="/usr/local/bin/dialog"
CMD_FILE="/var/tmp/dialog.log"

cleanup() {
    rm -f "$CMD_FILE"
}
trap cleanup EXIT

rm -f "$CMD_FILE"

"$DIALOG" \
    --title "Installing Components" \
    --progress 3 \
    --progresstext "Starting..." \
    --commandfile "$CMD_FILE" \
    --button1text "Please wait..." \
    --button1disabled &

DIALOG_PID=$!
sleep 1

echo "progress: 1" >> "$CMD_FILE"
echo "progresstext: Step 1/3: Download" >> "$CMD_FILE"
sleep 2

echo "progress: 2" >> "$CMD_FILE"
echo "progresstext: Step 2/3: Verify" >> "$CMD_FILE"
sleep 2

echo "progress: 3" >> "$CMD_FILE"
echo "progresstext: Step 3/3: Install" >> "$CMD_FILE"
sleep 1

echo "progresstext: Complete" >> "$CMD_FILE"
echo "button1text: Done" >> "$CMD_FILE"
echo "button1: enable" >> "$CMD_FILE"

wait $DIALOG_PID 2>/dev/null || true
```

---

## When To Use JSON Input

Choose `--jsonstring` or `--jsonfile` when:

- The dialog definition is easier to manage as structured data
- There are repeated field groups or array-heavy controls
- The user already has configuration data to transform into a dialog
- You need dynamic form generation based on external config

**Do not use JSON input just because it exists.** For simple scripts, direct CLI flags are easier to read and maintain.

**Reference demo:**

- `16_json_input.zsh` — demonstrates both `--jsonstring` and `--jsonfile` patterns

**Example use case:**

A deployment tool reads a JSON manifest of required fields and generates a swiftDialog form dynamically. Instead of building CLI arguments programmatically, it's cleaner to transform the manifest into dialog JSON and use `--jsonfile`.

**Typical workflow:**

1. Generate or load configuration JSON
2. Validate JSON with `jq empty "$JSON_FILE"`
3. Pass to dialog: `"$DIALOG" --jsonfile "$JSON_FILE"`

**Example:**

```zsh
DIALOG="/usr/local/bin/dialog"
CONFIG_JSON="/tmp/dialog_config.json"

cat > "$CONFIG_JSON" <<EOF
{
    "title": "User Setup",
    "message": "Enter your details below.",
    "textfield": [
        { "title": "Name", "required": true, "name": "username" },
        { "title": "Email", "required": true, "name": "email" }
    ],
    "button1text": "Submit",
    "button2text": "Cancel"
}
EOF

if ! jq empty "$CONFIG_JSON" 2>/dev/null; then
    echo "Error: Invalid JSON config"
    exit 1
fi

result=$("$DIALOG" --jsonfile "$CONFIG_JSON" 2>/dev/null) || exit 0
echo "$result" | jq '.'
```

---

## When To Use Inspect Mode

Choose inspect mode only for workflows that benefit from a config-driven monitor:

- A log file is being tailed for state changes
- Completion is tied to file or app path appearance (e.g., wait for `/Applications/Example.app` to exist)
- Side messages and monitored items are easier to express in JSON than shell logic

**Inspect mode is not the default answer for ordinary install progress.** Use Tier 3 command-file patterns first unless the workflow is clearly config-driven or log-monitoring focused.

**Reference demo:**

- `19_inspect_mode.zsh` — inspect-mode configuration, log monitoring, path-based completion

**Typical workflow:**

1. Create JSON config defining monitored items, log path, and completion criteria
2. Validate JSON with `jq empty "$CONFIG_JSON"`
3. Launch inspect mode: `DIALOG_INSPECT_CONFIG="$CONFIG_JSON" "$DIALOG" --inspect-mode --inspect-config "$CONFIG_JSON" &`
4. Capture PID: `DIALOG_PID=$!`
5. Perform background work (write to log, create files)
6. Wait for dialog completion: `wait $DIALOG_PID 2>/dev/null || true`
7. Clean up temp files

**Example use case:**

An install script writes to a log file as it installs multiple apps. swiftDialog monitors the log for keywords like `[appname] install complete` and updates item status automatically. When all monitored paths exist, the dialog auto-enables the close button.

**Example:**

```zsh
DIALOG="/usr/local/bin/dialog"
INSPECT_JSON="/tmp/inspect_config.json"
INSPECT_LOG="/tmp/install.log"
APP_PATH="/Applications/Example.app"

cleanup() {
    rm -f "$INSPECT_JSON" "$INSPECT_LOG"
}
trap cleanup EXIT

cat > "$INSPECT_JSON" <<EOF
{
    "title": "Installing Applications",
    "icon": "sf=arrow.down.app",
    "logMonitor": {
        "path": "${INSPECT_LOG}",
        "preset": "installomator",
        "autoMatch": true,
        "startFromEnd": true
    },
    "button1text": "Please wait...",
    "button1disabled": true,
    "autoEnableButton": true,
    "items": [
        {
            "id": "exampleapp",
            "displayName": "Example App",
            "paths": ["${APP_PATH}"]
        }
    ]
}
EOF

if ! jq empty "$INSPECT_JSON" 2>/dev/null; then
    echo "Error: Invalid inspect config"
    exit 1
fi

touch "$INSPECT_LOG"

DIALOG_INSPECT_CONFIG="$INSPECT_JSON" "$DIALOG" \
    --inspect-mode \
    --inspect-config "$INSPECT_JSON" &

DIALOG_PID=$!
sleep 1

# Simulate install
echo "$(date '+%Y-%m-%d %H:%M:%S') INFO [exampleapp] starting install" >> "$INSPECT_LOG"
sleep 2
mkdir -p "$APP_PATH"
echo "$(date '+%Y-%m-%d %H:%M:%S') INFO [exampleapp] install complete" >> "$INSPECT_LOG"

wait $DIALOG_PID 2>/dev/null || true
```

---

## Decision Guide

| Workflow Need | Pattern | Tier |
|--------------|---------|------|
| Static dialog, no updates | Direct invocation | 1 or 2 |
| Live progress updates | Command file | 3 |
| Dynamic field generation | JSON input | 2 or 4 |
| Log-driven monitoring | Inspect mode | 4 |
| Path-based completion | Inspect mode | 4 |

When in doubt, start with the simplest pattern and only escalate if requirements demand it.
