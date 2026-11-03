#!/bin/zsh
# Demo 22: View Order Groups
# Demonstrates: --vieworder with [Title] groups (CSV), JSON {"groups":[...]} with
#               description and footer, mixed input types in one group, detail
#               subtext, unlisted inputs in a trailing group, type-only ordering

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
        --message "Demo 22 uses the new **vieworder groups** added in the **swiftDialog 3.2.0 preview (build 5001)**.\n\nDetected version: \`${detected_version}\`\n\nInstall **swiftDialog 3.2.0 build 5001 or newer** to run this demo." \
        --button1text "Close" \
        --width 700 \
        --json || true
    exit 0
fi

"$DIALOG" \
    --title "View Order Groups" \
    --message "This demo frames grouped layouts as an **annual device inventory check-in**.\n\n\`--vieworder\` can now place individual inputs by **name**, mix input types, and collect them into titled groups.\n\nThe check-in shows:\n- \`[Title]\` groups in the comma-separated form\n- A JSON \`{\"groups\":[...]}\` object with \`description\` and \`footer\`\n- Text fields, selects, and checkboxes sharing one group\n- \`detail\` subtext under input titles\n- Unlisted inputs landing in a trailing group\n- The original type-only ordering, unchanged" \
    --icon "SF=rectangle.3.group,colour=#007AFF" \
    --button1text "Start Demo ->" \
    --button2text "Skip" \
    --moveable \
    --width 760 \
    --height 520 \
    --json || exit 0

# --- CSV groups with mixed input types ---
result=$("$DIALOG" \
    --title "Device Check-In" \
    --message "Confirm who uses this Mac and where it lives.\n\n\`[Owner]\` and \`[This Mac]\` start titled groups; the names after each one place inputs inside it. **Notes** isn't listed, so it lands in an untitled group at the end." \
    --icon "SF=desktopcomputer,colour=#007AFF" \
    --textfield "Full Name,name=fullname,required,detail=As shown in the directory" \
    --textfield "Work Email,name=email,prompt=first.last@example.com" \
    --selecttitle "Department,name=department,detail=Cost centre for this Mac" \
    --selectvalues "Engineering,Finance,Marketing,Sales,Support" \
    --textfield "Asset Tag,name=assettag,prompt=MAC-000000,detail=On the sticker under the Mac" \
    --checkbox "Shared device,name=shared,detail=More than one person signs in" \
    --selecttitle "Location,name=location" \
    --selectvalues "Office,Home,Hybrid" \
    --textfield "Notes,name=notes,prompt=Anything IT should know" \
    --vieworder "[Owner],fullname,email,department,[This Mac],assettag,shared,location" \
    --button1text "Next ->" \
    --button2text "Skip" \
    --moveable \
    --width 760 \
    --height 680 \
    --json 2>/dev/null) || exit 0

echo "CSV groups output:"
echo "$result" | jq '.'

# --- JSON groups with description and footer ---
ATTESTATION_GROUPS='{
  "groups": [
    {
      "title": "Owner",
      "description": "Pulled from the directory. Correct anything that is wrong.",
      "items": ["fullname", "department"]
    },
    {
      "title": "Security, Backup & Recovery",
      "description": "A group title with commas needs the JSON form.",
      "footer": "Your answers are sent to the IT asset register.",
      "items": ["filevault", "backup", "lastbackup", "recoverykey"]
    }
  ]
}'

result=$("$DIALOG" \
    --title "Security Attestation" \
    --message "The same idea written as a JSON object:\n\n\`{\"groups\":[{\"title\",\"description\",\"footer\",\"items\"}]}\`\n\nUse the JSON form for group descriptions, footers, or titles that contain commas." \
    --icon "SF=lock.shield,colour=#34C759" \
    --textfield "Full Name,name=fullname" \
    --selecttitle "Department,name=department" \
    --selectvalues "Engineering,Finance,Marketing,Sales,Support" \
    --checkbox "FileVault is on,name=filevault,detail=System Settings > Privacy & Security" \
    --selecttitle "Backup method,name=backup" \
    --selectvalues "Time Machine,Cloud backup,None" \
    --textfield "Last backup,name=lastbackup,date,detail=Date of the last successful backup" \
    --checkbox "I know where my recovery key is,name=recoverykey" \
    --vieworder "$ATTESTATION_GROUPS" \
    --button1text "Next ->" \
    --button2text "Skip" \
    --moveable \
    --width 760 \
    --height 680 \
    --json 2>/dev/null) || exit 0

echo "JSON groups output:"
echo "$result" | jq '.'

# --- Type-only ordering still works ---
result=$("$DIALOG" \
    --title "Type-Only Ordering" \
    --message "Without a \`[Title]\` group, an input name, or a JSON object, \`--vieworder\` keeps its original behaviour and orders by **type**.\n\nHere \`--vieworder \"checkbox,textfield\"\` puts the checkbox above the text field, with no titled groups." \
    --icon "SF=list.number,colour=#FF9500" \
    --textfield "Asset Tag,name=assettag" \
    --checkbox "This Mac is still in use,name=inuse" \
    --vieworder "checkbox,textfield" \
    --button1text "Done" \
    --button2text "Skip" \
    --moveable \
    --width 650 \
    --height 460 \
    --json 2>/dev/null) || exit 0

echo "Type-only ordering output:"
echo "$result" | jq '.'
