#!/bin/zsh
# Demo 23: Sliders & Steppers
# Demonstrates: --slider and --stepper keys (min, max, step, value, unit,
#               minlabel, maxlabel, showvalue, detail), JSON object per
#               argument, numeric --json output

DIALOG="${DIALOG:-/usr/local/bin/dialog}"

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
        --message "Demo 23 uses the new **slider** and **stepper** inputs added in the **swiftDialog 3.2.0 preview (build 5001)**.\n\nDetected version: \`${detected_version}\`\n\nInstall **swiftDialog 3.2.0 build 5001 or newer** to run this demo." \
        --button1text "Close" \
        --width 700 \
        --json || true
    exit 0
fi

"$DIALOG" \
    --title "Sliders & Steppers" \
    --message "This demo frames numeric inputs as **software update deferral preferences**.\n\nThe preferences show:\n- \`--slider\` and \`--stepper\` with \`min\`, \`max\`, \`step\`, \`value\`, and \`unit\`\n- \`minlabel\` / \`maxlabel\` at the ends of a slider\n- \`showvalue=false\` to hide a slider's readout\n- \`detail\` subtext under a title\n- A JSON object per argument, for text that contains commas\n- \`--json\` output with real numbers, not strings" \
    --icon "SF=slider.horizontal.3,colour=#007AFF" \
    --button1text "Start Demo ->" \
    --button2text "Skip" \
    --moveable \
    --width 760 \
    --height 480 \
    --json || exit 0

# --- Comma-separated keys ---
result=$("$DIALOG" \
    --title "Update Deferral Preferences" \
    --message "Choose when this Mac installs updates.\n\nSliders snap to their \`step\`. A decimal step returns decimals; a whole step returns whole numbers. Steppers accept typing or the arrows, and values outside \`min\` / \`max\` are held to the range." \
    --icon "SF=arrow.down.circle,colour=#007AFF" \
    --slider "Minimum battery to install,name=minbattery,min=20,max=100,step=5,value=50,unit=%,minlabel=Low,maxlabel=Full" \
    --slider "Download speed cap,name=bandwidth,min=0.5,max=10,step=0.5,value=2.5,unit=MB/s,detail=Decimal steps return decimals" \
    --slider "Reminder intensity,name=reminders,min=1,max=5,step=1,value=3,minlabel=Gentle,maxlabel=Persistent,showvalue=false" \
    --stepper "Defer updates for,name=deferdays,min=0,max=14,value=3,unit=days,detail=Type a number or use the arrows" \
    --stepper "Restart deadline,name=deadlinehours,min=1,max=72,step=1,value=24,unit=hours" \
    --button1text "Next ->" \
    --button2text "Skip" \
    --moveable \
    --width 760 \
    --height 620 \
    --json 2>/dev/null) || exit 0

echo "Comma-separated sliders and steppers output:"
echo "$result" | jq '.'

# --- JSON object per argument ---
result=$("$DIALOG" \
    --title "Storage Housekeeping" \
    --message "Each \`--slider\` or \`--stepper\` can also take a JSON object with the same keys. Use it when \`detail\` text needs commas.\n\nWith \`--json\`, the output holds numbers: \`\"diskwarn\": 15\`, not \`\"diskwarn\": \"15\"\`." \
    --icon "SF=internaldrive,colour=#FF9500" \
    --slider '{"title":"Free space warning","name":"diskwarn","min":5,"max":50,"step":5,"value":15,"unit":"%","minlabel":"5%","maxlabel":"50%","detail":"Warn below this level, then offer to clear caches, logs, and old installers"}' \
    --stepper '{"title":"Keep install logs for","name":"keeplogs","min":1,"max":90,"step":1,"value":30,"unit":"days","detail":"Older logs are removed first, newest kept"}' \
    --button1text "Done" \
    --button2text "Skip" \
    --moveable \
    --width 760 \
    --height 460 \
    --json 2>/dev/null) || exit 0

echo "JSON object sliders and steppers output:"
echo "$result" | jq '.'
