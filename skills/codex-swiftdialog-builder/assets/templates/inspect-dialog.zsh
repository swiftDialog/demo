#!/bin/zsh
# Starter: Inspect Mode dialog

DIALOG="/usr/local/bin/dialog"
INSPECT_JSON="/tmp/swiftdialog_inspect_template.json"
INSPECT_LOG="/tmp/swiftdialog_inspect_template.log"
INSPECT_ROOT="/tmp/swiftdialog_inspect_template_items"

APP_ONE="${INSPECT_ROOT}/ExampleAppOne.app"
APP_TWO="${INSPECT_ROOT}/ExampleAppTwo.app"

cleanup() {
    rm -f "$INSPECT_JSON" "$INSPECT_LOG"
    rm -rf "$INSPECT_ROOT"
}
trap cleanup EXIT

# --- Prepare demo state ---
rm -f "$INSPECT_JSON" "$INSPECT_LOG"
rm -rf "$INSPECT_ROOT"
mkdir -p "$INSPECT_ROOT"
touch "$INSPECT_LOG"

# --- Write inspect config ---
cat > "$INSPECT_JSON" <<EOF
{
    "preset": "preset1",
    "title": "Inspect Mode Starter",
    "message": "Replace these items, paths, and log events with your own workflow.",
    "icon": "sf=shippingbox.fill,colour=#007AFF",
    "logMonitor": {
        "path": "${INSPECT_LOG}",
        "preset": "installomator",
        "autoMatch": true,
        "startFromEnd": true
    },
    "button1text": "Please wait ...",
    "button1disabled": true,
    "autoEnableButton": true,
    "autoEnableButtonText": "Close",
    "items": [
        {
            "id": "exampleappone",
            "displayName": "ExampleAppOne",
            "guiIndex": 0,
            "paths": ["${APP_ONE}"]
        },
        {
            "id": "exampleapptwo",
            "displayName": "ExampleAppTwo",
            "guiIndex": 1,
            "paths": ["${APP_TWO}"]
        }
    ]
}
EOF

if ! jq empty "$INSPECT_JSON" 2>/dev/null; then
    "$DIALOG" \
        --style alert \
        --title "Inspect Config Error" \
        --message "The generated JSON is invalid." \
        --button1text "Close" \
        --json || true
    exit 0
fi

# --- Launch inspect mode ---
DIALOG_INSPECT_CONFIG="$INSPECT_JSON" "$DIALOG" --inspect-mode --inspect-config "$INSPECT_JSON" &
DIALOG_PID=$!
sleep 1

echo "$(date '+%Y-%m-%d %H:%M:%S') INFO [exampleappone] starting install workflow" >> "$INSPECT_LOG"
sleep 1
mkdir -p "$APP_ONE"
echo "$(date '+%Y-%m-%d %H:%M:%S') INFO [exampleappone] install complete" >> "$INSPECT_LOG"
sleep 1
echo "$(date '+%Y-%m-%d %H:%M:%S') INFO [exampleapptwo] starting install workflow" >> "$INSPECT_LOG"
sleep 1
mkdir -p "$APP_TWO"
echo "$(date '+%Y-%m-%d %H:%M:%S') INFO [exampleapptwo] install complete" >> "$INSPECT_LOG"

wait $DIALOG_PID 2>/dev/null || true
