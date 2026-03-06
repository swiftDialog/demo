#!/bin/zsh
# Demo 19: Inspect Mode
# Demonstrates: --inspect-mode, --inspect-config, DIALOG_INSPECT_CONFIG,
#               inspect JSON (preset, logMonitor, items, sideMessage,
#               autoEnableButton)

DIALOG="/usr/local/bin/dialog"
INSPECT_JSON="/tmp/swiftdialog_inspect_mode_demo.json"
INSPECT_LOG="/tmp/swiftdialog_inspect_mode_demo.log"
INSPECT_ROOT="/tmp/swiftdialog_inspect_mode_items"

CORE_TOOLS_APP="${INSPECT_ROOT}/CoreTools.app"
SECURITY_AGENT_APP="${INSPECT_ROOT}/SecurityAgent.app"
PRODUCTIVITY_SUITE_APP="${INSPECT_ROOT}/ProductivitySuite.app"
VPN_CLIENT_APP="${INSPECT_ROOT}/VPNClient.app"

cleanup() {
    rm -f "$INSPECT_JSON" "$INSPECT_LOG"
    rm -rf "$INSPECT_ROOT"
}
trap cleanup EXIT

# --- Intro ---
"$DIALOG" \
    --title "Inspect Mode" \
    --message "Inspect Mode builds a live progress UI from JSON configuration.\n\nThis demo uses temporary paths in \`/tmp\` to simulate installs so the behavior is deterministic on any Mac." \
    --icon "SF=list.bullet.clipboard,colour=#007AFF" \
    --button1text "Start Demo ->" \
    --button2text "Skip" \
    --moveable \
    --width 700 \
    --json || exit 0

# --- Prepare deterministic simulation state ---
rm -f "$INSPECT_JSON" "$INSPECT_LOG"
rm -rf "$INSPECT_ROOT"
mkdir -p "$INSPECT_ROOT"
touch "$INSPECT_LOG"

# --- Build Inspect Mode JSON configuration ---
cat > "$INSPECT_JSON" <<EOF
{
    "preset": "preset1",
    "title": "Inspect Mode Demo",
    "message": "Monitoring a simulated software deployment using logMonitor and item path checks.",
    "icon": "sf=shippingbox.fill,colour=#007AFF",
    "overlayicon": "sf=magnifyingglass.circle.fill,colour=#34C759",
    "highlightColor": "#FF9500",
    "logMonitor": {
        "path": "${INSPECT_LOG}",
        "preset": "installomator",
        "autoMatch": true,
        "startFromEnd": true
    },
    "sideMessage": [
        "Preparing deployment checks...",
        "Inspect Mode is watching the log file in real time.",
        "Each item completes when its configured path appears.",
        "Using temporary paths keeps this demo repeatable.",
        "Finalizing setup..."
    ],
    "sideInterval": 4,
    "button1text": "Please wait ...",
    "button1disabled": true,
    "autoEnableButton": true,
    "autoEnableButtonText": "Close",
    "items": [
        {
            "id": "coretools",
            "displayName": "CoreTools",
            "guiIndex": 0,
            "paths": ["${CORE_TOOLS_APP}"]
        },
        {
            "id": "securityagent",
            "displayName": "SecurityAgent",
            "guiIndex": 1,
            "paths": ["${SECURITY_AGENT_APP}"]
        },
        {
            "id": "productivitysuite",
            "displayName": "ProductivitySuite",
            "guiIndex": 2,
            "paths": ["${PRODUCTIVITY_SUITE_APP}"]
        },
        {
            "id": "vpnclient",
            "displayName": "VPNClient",
            "guiIndex": 3,
            "paths": ["${VPN_CLIENT_APP}"]
        }
    ]
}
EOF

# --- Validate generated JSON ---
if ! jq empty "$INSPECT_JSON" 2>/dev/null; then
    "$DIALOG" \
        --style alert \
        --title "Inspect Config Error" \
        --message "The generated Inspect Mode JSON is invalid.\n\nCheck \`${INSPECT_JSON}\` and run the demo again." \
        --button1text "Close" \
        --json || true
    exit 0
fi

# --- Launch Inspect Mode ---
DIALOG_INSPECT_CONFIG="$INSPECT_JSON" "$DIALOG" --inspect-mode --inspect-config "$INSPECT_JSON" &
DIALOG_PID=$!
sleep 1

# --- Simulate install progression ---
ITEM_IDS=("coretools" "securityagent" "productivitysuite" "vpnclient")
ITEM_PATHS=("$CORE_TOOLS_APP" "$SECURITY_AGENT_APP" "$PRODUCTIVITY_SUITE_APP" "$VPN_CLIENT_APP")

for i in {1..4}; do
    echo "$(date '+%Y-%m-%d %H:%M:%S') INFO [${ITEM_IDS[$i]}] starting install workflow" >> "$INSPECT_LOG"
    sleep 1
    echo "$(date '+%Y-%m-%d %H:%M:%S') INFO [${ITEM_IDS[$i]}] downloading package" >> "$INSPECT_LOG"
    sleep 1
    mkdir -p "${ITEM_PATHS[$i]}"
    echo "$(date '+%Y-%m-%d %H:%M:%S') INFO [${ITEM_IDS[$i]}] install complete" >> "$INSPECT_LOG"
    sleep 1
done

echo "$(date '+%Y-%m-%d %H:%M:%S') INFO deployment workflow complete" >> "$INSPECT_LOG"

# Wait for the Inspect Mode window to close
wait $DIALOG_PID 2>/dev/null || true

# --- Completion ---
"$DIALOG" \
    --title "Inspect Mode Complete" \
    --message "Inspect Mode can be launched with:\n\n\`DIALOG_INSPECT_CONFIG=\"/path/to/config.json\" dialog --inspect-mode\`\n\nThis demo used deterministic temporary paths under \`/tmp\` and cleaned them up on exit." \
    --icon "SF=checkmark.seal.fill,colour=#34C759" \
    --button1text "Done" \
    --moveable \
    --width 700 \
    --json || true
