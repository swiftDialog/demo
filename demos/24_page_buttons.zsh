#!/bin/zsh
# Demo 24: Page Buttons
# Demonstrates: --button / --buttons (url, shell, sheet, confirm, symbol, display),
#               JSON rows with items, selectable swatch rows (labelposition: selected),
#               type: colour, type: info, slow shell spinner and "still running"
#               sheet, clicked and exitcode output

DIALOG="${DIALOG:-/usr/local/bin/dialog}"
ACTION_DIR=""

cleanup() {
    [[ -n "$ACTION_DIR" && -d "$ACTION_DIR" ]] && rm -rf "$ACTION_DIR"
}
trap cleanup EXIT

# Dialog always runs as the console user, even when this script runs as root,
# so the action folder lives in /var/tmp and is handed to that user
dialog_user() {
    stat -f %Su /dev/console
}

hand_to_dialog_user() {
    [[ "$EUID" -eq 0 ]] || return 0
    chown -R "$(dialog_user)" "$@"
}

dialog_version() {
    "$DIALOG" --version 2>/dev/null || echo ""
}

dialog_build_number() {
    local version_string
    version_string=$(dialog_version)

    if [[ "$version_string" =~ ([0-9]{4,})$ ]]; then
        echo "${match[1]}"
    else
        echo "0"
    fi
}

require_dialog_preview() {
    local version_string build_number
    version_string=$(dialog_version)
    build_number=$(dialog_build_number)

    [[ -n "$version_string" ]] || return 1

    if [[ "$version_string" == 3.2.0* ]]; then
        [[ "$build_number" -eq 0 || "$build_number" -ge 5001 ]]
        return $?
    fi

    return 1
}

if [[ ! -x "$DIALOG" ]]; then
    echo "ERROR: swiftDialog not found at ${DIALOG}" >&2
    exit 1
fi

if ! require_dialog_preview; then
    detected_version=$(dialog_version)
    [[ -n "$detected_version" ]] || detected_version="unknown"

    "$DIALOG" \
        --style alert \
        --title "swiftDialog 3.2.0 Preview Required" \
        --message "Demo 24 uses the new **page buttons** added in the **swiftDialog 3.2.0 preview (build 5001)**.\n\nDetected version: \`${detected_version}\`\n\nInstall **swiftDialog 3.2.0 build 5001 or newer** to run this demo." \
        --button1text "Close" \
        --width 700 \
        --json || true
    exit 0
fi

"$DIALOG" \
    --title "Page Buttons" \
    --message "This demo frames page buttons as a **self-service help desk toolkit**. Unlike Button 1 and Button 2, page buttons act immediately and don't close the dialog.\n\nThe toolkit shows:\n- \`url\`, \`shell\`, and \`sheet\` actions, with optional \`confirm\`\n- \`symbol\` and \`display=symbol\` for icon-only buttons\n- JSON rows with an \`items\` array\n- A selectable 8-swatch colour row with \`labelposition: selected\`\n- \`type: colour\` wells and \`type: info\` rows\n- A slow shell action with a spinner and a *still running* sheet\n- Output with each button's \`clicked\` state and \`exitcode\`\n\nShell actions only write to a temporary folder that this demo removes when it exits." \
    --icon "SF=hand.tap.fill,colour=#007AFF" \
    --button1text "Start Demo ->" \
    --button2text "Skip" \
    --moveable \
    --width 760 \
    --height 580 \
    --json || exit 0

ACTION_DIR=$(mktemp -d /var/tmp/swiftdialog_page_buttons_demo.XXXXXX) || exit 1
hand_to_dialog_user "$ACTION_DIR" || exit 1

# --- Command-line buttons ---
result=$("$DIALOG" \
    --title "Help Desk Toolkit" \
    --message "Each \`--button\` argument adds one row. One \`--buttons\` argument with a JSON \`items\` array puts several buttons on one row.\n\nTry the buttons, then press **Next** and check the output for \`clicked\` and \`exitcode\`." \
    --icon "SF=wrench.and.screwdriver.fill,colour=#007AFF" \
    --button "title=Service desk,label=Open Help Portal,name=portal,symbol=safari,url=https://example.com" \
    --button "title=Printing,label=Reset Printing,name=resetprinting,symbol=printer,confirm=Remove all printers and queued jobs?,shell=echo printing reset > ${ACTION_DIR}/printing" \
    --button "title=How these buttons work,label=Help,name=help,symbol=questionmark,display=symbol,sheet=Each **page button** runs its action straight away. **Reset Printing** asks first because it sets **confirm**." \
    --buttons '{"name":"settings","title":"System Settings","items":[{"name":"wifi","label":"Wi-Fi…","url":"x-apple.systempreferences:com.apple.wifi-settings-extension"},{"name":"swupdate","label":"Software Update…","url":"x-apple.systempreferences:com.apple.Software-Update-Settings.extension"},{"name":"rowinfo","label":"About this row","symbol":"info.circle","display":"symbol","sheet":"One **--buttons** argument with an **items** array puts several buttons on one row."}]}' \
    --button1text "Next ->" \
    --button2text "Skip" \
    --moveable \
    --width 760 \
    --height 500 \
    --json 2>/dev/null) || exit 0

echo "Command-line buttons output:"
echo "$result" | jq '.'

# --- Selectable swatches, colour well, info rows ---
# Unquoted heredoc so ${ACTION_DIR} expands inside each swatch's shell action
ACCENT_ROW=$(cat <<EOF
{
  "name": "accent",
  "title": "Accent colour",
  "style": "plain",
  "selectable": true,
  "default": "blue",
  "labelposition": "selected",
  "size": 26,
  "items": [
    { "value": "blue", "label": "Blue", "symbol": "circle.fill,colour=blue", "shell": "echo blue > ${ACTION_DIR}/accent" },
    { "value": "purple", "label": "Purple", "symbol": "circle.fill,colour=purple", "shell": "echo purple > ${ACTION_DIR}/accent" },
    { "value": "pink", "label": "Pink", "symbol": "circle.fill,colour=pink", "shell": "echo pink > ${ACTION_DIR}/accent" },
    { "value": "red", "label": "Red", "symbol": "circle.fill,colour=red", "shell": "echo red > ${ACTION_DIR}/accent" },
    { "value": "orange", "label": "Orange", "symbol": "circle.fill,colour=orange", "shell": "echo orange > ${ACTION_DIR}/accent" },
    { "value": "yellow", "label": "Yellow", "symbol": "circle.fill,colour=yellow", "shell": "echo yellow > ${ACTION_DIR}/accent" },
    { "value": "green", "label": "Green", "symbol": "circle.fill,colour=green", "shell": "echo green > ${ACTION_DIR}/accent" },
    { "value": "graphite", "label": "Graphite", "symbol": "circle.fill,colour=gray", "shell": "echo graphite > ${ACTION_DIR}/accent" }
  ]
}
EOF
)

result=$("$DIALOG" \
    --title "Personalise This Mac" \
    --message "A **selectable** row works like a choice: clicking a swatch selects it **and** runs its action. Only the selected swatch shows its name (\`labelposition: selected\`).\n\n\`type: colour\` is a colour well that returns a hex value. \`type: info\` rows are read-only values filled from system tags." \
    --icon "SF=paintpalette.fill,colour=#FF2D55" \
    --button "$ACCENT_ROW" \
    --button '{"name":"highlight","title":"Highlight colour","detail":"A colour well; the colour you pick is returned in the output","type":"colour","value":"#0066FF","label":"Highlight colour"}' \
    --button '{"name":"serial","title":"Serial Number","type":"info","value":"{serialnumber}"}' \
    --button '{"name":"model","title":"Model","type":"info","value":"{computermodel}"}' \
    --button '{"name":"macos","title":"macOS","type":"info","value":"{osversion}"}' \
    --button '{"name":"serialhelp","title":"Where is my serial number?","label":"Help","symbol":"questionmark","display":"symbol","sheet":"## Serial number\n\nThis Mac reports **{serialnumber}**.\n\nQuote it whenever you contact the service desk."}' \
    --vieworder "[Accent],accent,highlight,[This Mac],serial,model,macos,serialhelp" \
    --button1text "Next ->" \
    --button2text "Skip" \
    --moveable \
    --width 760 \
    --height 660 \
    --json 2>/dev/null) || exit 0

echo "Swatch, colour well, and info row output:"
echo "$result" | jq '.'

# --- Slow, confirm-first, and failing actions ---
DIAGNOSTICS_ROW=$(cat <<EOF
{
  "name": "diagrow",
  "title": "Diagnostics",
  "detail": "Takes 5 seconds and runs in the background",
  "items": [
    { "name": "diagnostics", "label": "Collect Diagnostics", "symbol": "stethoscope", "shell": "sleep 5; echo collected > ${ACTION_DIR}/diagnostics" }
  ]
}
EOF
)

CACHES_ROW=$(cat <<EOF
{
  "name": "cacherow",
  "title": "Caches",
  "detail": "Asks before it runs",
  "items": [
    { "name": "clearcaches", "label": "Clear Caches", "symbol": "trash", "confirm": "Clear user caches now?", "shell": "echo cleared > ${ACTION_DIR}/caches" }
  ]
}
EOF
)

ENROLLMENT_ROW=$(cat <<EOF
{
  "name": "enrollrow",
  "title": "Enrollment",
  "detail": "Exits with code 7 on purpose",
  "items": [
    { "name": "enrollment", "label": "Check Enrollment", "symbol": "checkmark.shield", "shell": "echo simulated failure > ${ACTION_DIR}/enrollment; exit 7" }
  ]
}
EOF
)

result=$("$DIALOG" \
    --title "Maintenance" \
    --message "Things to try:\n\n- Click **Collect Diagnostics**. A spinner appears after half a second, and clicking it again does nothing. Press **Done** while it runs: a *still running* sheet keeps the dialog open.\n- **Clear Caches** asks before it runs (\`confirm\`).\n- **Check Enrollment** exits with code 7, so the output shows a non-zero \`exitcode\`. The dialog's own exit code is unchanged." \
    --icon "SF=bolt.fill,colour=#FF9500" \
    --button "$DIAGNOSTICS_ROW" \
    --button "$CACHES_ROW" \
    --button "$ENROLLMENT_ROW" \
    --button1text "Done" \
    --button2text "Skip" \
    --moveable \
    --width 760 \
    --height 600 \
    --json 2>/dev/null) || exit 0

echo "Maintenance action output:"
echo "$result" | jq '.'
